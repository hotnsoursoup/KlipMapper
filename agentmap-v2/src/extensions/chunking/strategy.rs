//! Chunk strategy trait.

use crate::core::{CodeAnalysis, SymbolId};
use std::collections::HashMap;
use std::path::PathBuf;

/// A semantic code chunk for embedding.
#[derive(Debug, Clone)]
pub struct CodeChunk {
    /// Unique chunk identifier.
    pub id: String,

    /// Chunk content.
    pub content: String,

    /// Source file path.
    pub file_path: PathBuf,

    /// Byte range in original file.
    pub byte_range: (usize, usize),

    /// Line range in original file.
    pub line_range: (u32, u32),

    /// Type of chunk.
    pub chunk_type: ChunkType,

    /// Parent symbol if any.
    pub parent_symbol: Option<SymbolId>,

    /// Additional metadata.
    pub metadata: HashMap<String, String>,
}

/// Type of code chunk.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum ChunkType {
    /// Single symbol (function, class).
    Symbol,
    /// Multiple symbols grouped.
    SymbolGroup,
    /// File header (imports, module docs).
    FileHeader,
    /// Fallback text chunk.
    Text,
}

/// Chunking strategy trait.
pub trait ChunkStrategy: Send + Sync {
    /// Chunk an analysis into code chunks.
    fn chunk(&self, analysis: &CodeAnalysis, content: &str) -> Vec<CodeChunk>;

    /// Strategy name.
    fn name(&self) -> &str;
}
