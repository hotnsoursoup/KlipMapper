//! Chunk configuration.

use super::LargeSymbolHandling;

/// Configuration for chunking.
#[derive(Debug, Clone)]
pub struct ChunkConfig {
    /// Maximum chunk size in tokens (approximate).
    pub max_tokens: usize,

    /// Minimum chunk size.
    pub min_tokens: usize,

    /// Overlap between adjacent chunks.
    pub overlap_tokens: usize,

    /// Include imports in each chunk.
    pub include_imports: bool,

    /// Strategy for large symbols.
    pub large_symbol_handling: LargeSymbolHandling,
}

impl Default for ChunkConfig {
    fn default() -> Self {
        Self {
            max_tokens: 400,      // 2025 best practice for code
            min_tokens: 50,
            overlap_tokens: 40,   // 10% overlap
            include_imports: false,
            large_symbol_handling: LargeSymbolHandling::KeepWhole,
        }
    }
}

impl ChunkConfig {
    /// Create config for code.
    pub fn for_code() -> Self {
        Self {
            max_tokens: 400,
            min_tokens: 50,
            overlap_tokens: 40,
            ..Self::default()
        }
    }

    /// Create config for documentation.
    pub fn for_docs() -> Self {
        Self {
            max_tokens: 600,
            min_tokens: 100,
            overlap_tokens: 60,
            ..Self::default()
        }
    }
}
