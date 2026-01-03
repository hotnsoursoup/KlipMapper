//! Source location types.

use std::path::PathBuf;
use serde::{Deserialize, Serialize};

/// Location of a symbol in source code.
#[derive(Debug, Clone, PartialEq, Eq, Hash, Serialize, Deserialize)]
pub struct SourceLocation {
    /// Path to the source file.
    pub file_path: PathBuf,

    /// Start line (1-indexed).
    pub start_line: u32,

    /// Start column (0-indexed).
    pub start_column: u32,

    /// End line (1-indexed).
    pub end_line: u32,

    /// End column (0-indexed).
    pub end_column: u32,

    /// Byte offset in the file.
    pub byte_offset: u32,

    /// Length in bytes.
    pub byte_length: u32,
}

impl SourceLocation {
    /// Create a new source location.
    pub fn new(file_path: PathBuf, start_line: u32, end_line: u32) -> Self {
        Self {
            file_path,
            start_line,
            start_column: 0,
            end_line,
            end_column: 0,
            byte_offset: 0,
            byte_length: 0,
        }
    }

    /// Create from TreeSitter node positions.
    pub fn from_node(file_path: PathBuf, node: &tree_sitter::Node) -> Self {
        let start = node.start_position();
        let end = node.end_position();

        Self {
            file_path,
            start_line: start.row as u32 + 1, // TreeSitter is 0-indexed
            start_column: start.column as u32,
            end_line: end.row as u32 + 1,
            end_column: end.column as u32,
            byte_offset: node.start_byte() as u32,
            byte_length: (node.end_byte() - node.start_byte()) as u32,
        }
    }

    /// Get the number of lines spanned.
    pub fn line_count(&self) -> u32 {
        self.end_line.saturating_sub(self.start_line) + 1
    }

    /// Check if this location contains another.
    pub fn contains(&self, other: &SourceLocation) -> bool {
        self.file_path == other.file_path
            && self.start_line <= other.start_line
            && self.end_line >= other.end_line
    }
}

impl std::fmt::Display for SourceLocation {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(
            f,
            "{}:{}:{}",
            self.file_path.display(),
            self.start_line,
            self.start_column
        )
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_source_location_display() {
        let loc = SourceLocation::new(PathBuf::from("src/main.rs"), 10, 20);
        assert_eq!(loc.to_string(), "src/main.rs:10:0");
    }

    #[test]
    fn test_line_count() {
        let loc = SourceLocation::new(PathBuf::from("test.rs"), 5, 15);
        assert_eq!(loc.line_count(), 11);
    }
}
