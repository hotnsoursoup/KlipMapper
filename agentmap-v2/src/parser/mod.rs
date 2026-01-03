//! Parser module for TreeSitter-based code parsing.

mod treesitter;
mod languages;
mod queries;

pub use treesitter::TreeSitterParser;
pub use languages::Language;
pub use queries::{QueryLoader, QueryType};

use crate::core::{Result, SourceLocation, Symbol};

/// Parsed file representation.
#[derive(Debug, Clone)]
pub struct ParsedFile {
    /// Source file path.
    pub path: std::path::PathBuf,

    /// Detected language.
    pub language: Language,

    /// Source content.
    pub content: String,

    /// TreeSitter tree (if available).
    pub tree: Option<tree_sitter::Tree>,

    /// Extracted symbols (from parsing only, no cross-file analysis).
    pub symbols: Vec<Symbol>,
}

impl ParsedFile {
    /// Create a new parsed file.
    pub fn new(path: std::path::PathBuf, language: Language, content: String) -> Self {
        Self {
            path,
            language,
            content,
            tree: None,
            symbols: Vec::new(),
        }
    }

    /// Get source text for a location.
    pub fn get_text(&self, location: &SourceLocation) -> Option<&str> {
        let start = location.byte_offset as usize;
        let end = start + location.byte_length as usize;
        self.content.get(start..end)
    }
}

/// Parser trait for code parsing.
pub trait Parser: Send + Sync {
    /// Parse source code into a ParsedFile.
    fn parse(&self, content: &str, language: Language) -> Result<ParsedFile>;

    /// Get list of supported languages.
    fn supported_languages(&self) -> &[Language];
}
