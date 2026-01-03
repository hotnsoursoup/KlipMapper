//! AST-aware code chunking.

mod strategy;
mod config;

pub use strategy::{ChunkStrategy, CodeChunk, ChunkType};
pub use config::ChunkConfig;

use crate::core::CodeAnalysis;

/// Symbol boundary chunker - respects function/class boundaries.
pub struct SymbolBoundaryChunker {
    config: ChunkConfig,
}

impl SymbolBoundaryChunker {
    pub fn new(config: ChunkConfig) -> Self {
        Self { config }
    }
}

impl Default for SymbolBoundaryChunker {
    fn default() -> Self {
        Self::new(ChunkConfig::default())
    }
}

impl ChunkStrategy for SymbolBoundaryChunker {
    fn chunk(&self, analysis: &CodeAnalysis, content: &str) -> Vec<CodeChunk> {
        let mut chunks = Vec::new();

        for symbol in &analysis.symbols {
            // Use symbol's byte range
            let start = symbol.location.byte_offset as usize;
            let end = (symbol.location.byte_offset + symbol.location.byte_length) as usize;

            if end <= content.len() {
                let chunk_content = &content[start..end];

                // Check chunk size against config
                let token_estimate = chunk_content.split_whitespace().count();

                if token_estimate <= self.config.max_tokens {
                    chunks.push(CodeChunk {
                        id: format!("{}:{}", analysis.file_path.display(), symbol.id.0),
                        content: chunk_content.to_string(),
                        file_path: analysis.file_path.clone(),
                        byte_range: (start, end),
                        line_range: (symbol.location.start_line, symbol.location.end_line),
                        chunk_type: ChunkType::Symbol,
                        parent_symbol: Some(symbol.id.clone()),
                        metadata: std::collections::HashMap::new(),
                    });
                } else {
                    // Large symbol - use configured handling
                    match self.config.large_symbol_handling {
                        LargeSymbolHandling::KeepWhole => {
                            chunks.push(CodeChunk {
                                id: format!("{}:{}", analysis.file_path.display(), symbol.id.0),
                                content: chunk_content.to_string(),
                                file_path: analysis.file_path.clone(),
                                byte_range: (start, end),
                                line_range: (symbol.location.start_line, symbol.location.end_line),
                                chunk_type: ChunkType::Symbol,
                                parent_symbol: Some(symbol.id.clone()),
                                metadata: std::collections::HashMap::new(),
                            });
                        }
                        LargeSymbolHandling::SlidingWindow => {
                            // Split with overlap
                            chunks.extend(self.sliding_window_chunk(
                                chunk_content,
                                start,
                                &analysis,
                                &symbol.id,
                            ));
                        }
                    }
                }
            }
        }

        chunks
    }

    fn name(&self) -> &str {
        "SymbolBoundary"
    }
}

impl SymbolBoundaryChunker {
    fn sliding_window_chunk(
        &self,
        content: &str,
        base_offset: usize,
        analysis: &CodeAnalysis,
        symbol_id: &crate::core::SymbolId,
    ) -> Vec<CodeChunk> {
        let mut chunks = Vec::new();
        let lines: Vec<&str> = content.lines().collect();

        let window_size = self.config.max_tokens / 10; // Approximate lines
        let overlap = self.config.overlap_tokens / 10;

        let mut start_line = 0;
        let mut chunk_num = 0;

        while start_line < lines.len() {
            let end_line = (start_line + window_size).min(lines.len());
            let chunk_lines = &lines[start_line..end_line];
            let chunk_content = chunk_lines.join("\n");

            chunks.push(CodeChunk {
                id: format!("{}:{}:chunk{}", analysis.file_path.display(), symbol_id.0, chunk_num),
                content: chunk_content,
                file_path: analysis.file_path.clone(),
                byte_range: (base_offset, base_offset), // Approximate
                line_range: (start_line as u32, end_line as u32),
                chunk_type: ChunkType::Text,
                parent_symbol: Some(symbol_id.clone()),
                metadata: std::collections::HashMap::new(),
            });

            if end_line >= lines.len() {
                break;
            }

            start_line = end_line.saturating_sub(overlap);
            chunk_num += 1;
        }

        chunks
    }
}

/// Large symbol handling strategy.
#[derive(Debug, Clone, Copy, Default)]
pub enum LargeSymbolHandling {
    #[default]
    KeepWhole,
    SlidingWindow,
}
