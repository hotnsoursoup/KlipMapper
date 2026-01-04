//! Anchor system for embedded metadata in source code.
//!
//! The anchor system allows embedding compressed analysis metadata directly
//! into source files as specially-formatted comments. This enables:
//!
//! - Fast re-parsing by comparing fingerprints
//! - Symbol navigation without full reanalysis
//! - Cross-reference tracking within files
//! - IDE/editor integration via inline anchors
//!
//! # Anchor Types
//!
//! ## Header Anchors
//!
//! Full file metadata embedded at the top of a file:
//!
//! ```text
//! // agentmap:1
//! // gz64: H4sIAAAAAAAA/8tIzcnJVyjPL8pJUQQAAAD//w==
//! // total-bytes: 42 sha1:a1b2c3d4
//! ```
//!
//! For large headers, content is chunked:
//!
//! ```text
//! // agentmap:1
//! // gz64[1/3]: H4sIAAAAAAAA/8tIzcnJVyjPL8pJ...
//! // gz64[2/3]: UQQAlJSUlBQWFhYWFxcXFxgYGB...
//! // gz64[3/3]: gYGBgYKCgoKDg4ODhISEhIWFhQ==
//! // total-bytes: 12288 sha1:a1b2c3d4
//! ```
//!
//! ## Inline Anchors
//!
//! Lightweight markers next to individual symbols:
//!
//! ```text
//! struct User { // am:a=C1;fg=abc123;r=10-50
//!     name: String,
//! }
//! ```
//!
//! # Example Usage
//!
//! ```rust,ignore
//! use agentmap::anchor::{AnchorHeaderBuilder, AnchorCompressor, Symbol, SourceRange};
//!
//! // Build a header
//! let header = AnchorHeaderBuilder::new(
//!     PathBuf::from("src/lib.rs"),
//!     "rust".to_string(),
//!     content.to_string(),
//! )
//! .add_symbol(symbol)
//! .build();
//!
//! // Compress for embedding
//! let compressed = AnchorCompressor::compress_header(&header)?;
//! let comments = AnchorCompressor::format_header_comments(&compressed, "rust");
//!
//! // Later, decompress
//! let restored = AnchorCompressor::decompress_header(&compressed)?;
//! ```

mod types;
mod compress;
mod builder;

pub use types::{
    SourceRange,
    ScopeFrame,
    SymbolReference,
    SymbolEdge,
    GuardInfo,
    Symbol,
    CrossReference,
    FastIndex,
    AnchorHeader,
    InlineAnchor,
    ANCHOR_VERSION,
    MAX_INLINE_ANCHOR_SIZE,
    MAX_HEADER_CHUNK_SIZE,
};

pub use compress::AnchorCompressor;
pub use builder::AnchorHeaderBuilder;

#[cfg(test)]
mod tests {
    use super::*;
    use std::path::PathBuf;

    #[test]
    fn test_anchor_roundtrip() {
        // Build a comprehensive header with multiple symbols
        let header = AnchorHeaderBuilder::new(
            PathBuf::from("test.rs"),
            "rust".to_string(),
            "struct TestClass {\n    fn method(&self) {}\n}".to_string(),
        )
        .add_symbol(Symbol {
            id: "C1".to_string(),
            kind: "struct".to_string(),
            name: "TestClass".to_string(),
            owner: None,
            range: SourceRange::new(1, 3, 0, 45),
            frames: vec![
                ScopeFrame::new("file", None, SourceRange::new(1, 100, 0, 2000)),
                ScopeFrame::new("struct", Some("TestClass".to_string()), SourceRange::new(1, 3, 0, 45)),
            ],
            roles: vec!["entity".to_string()],
            references: vec![],
            edges: vec![],
            fingerprint: "abc123".to_string(),
            guard: None,
        })
        .add_symbol(Symbol {
            id: "M1".to_string(),
            kind: "method".to_string(),
            name: "method".to_string(),
            owner: Some("C1".to_string()),
            range: SourceRange::new(2, 2, 20, 42),
            frames: vec![
                ScopeFrame::new("file", None, SourceRange::new(1, 100, 0, 2000)),
                ScopeFrame::new("struct", Some("TestClass".to_string()), SourceRange::new(1, 3, 0, 45)),
                ScopeFrame::new("method", Some("method".to_string()), SourceRange::new(2, 2, 20, 42)),
            ],
            roles: vec![],
            references: vec![],
            edges: vec![],
            fingerprint: "def456".to_string(),
            guard: None,
        })
        .build();

        // Compress
        let compressed = AnchorCompressor::compress_header(&header).unwrap();

        // Verify compression worked (should be significantly smaller)
        assert!(!compressed.is_empty());

        // Decompress and verify
        let restored = AnchorCompressor::decompress_header(&compressed).unwrap();

        assert_eq!(header.version, restored.version);
        assert_eq!(header.language, restored.language);
        assert_eq!(header.symbols.len(), restored.symbols.len());
        assert_eq!(header.symbols[0].name, restored.symbols[0].name);
        assert_eq!(header.symbols[1].name, restored.symbols[1].name);
        assert_eq!(header.symbols[1].owner, restored.symbols[1].owner);
    }

    #[test]
    fn test_inline_anchor_roundtrip() {
        let anchor = InlineAnchor {
            anchor_id: "C1".to_string(),
            fingerprint: "abc123".to_string(),
            range: "10-50".to_string(),
        };

        // Format as comment
        let comment = AnchorCompressor::format_inline_anchor(&anchor, "rust");
        assert!(comment.starts_with("//"));
        assert!(comment.contains("am:"));
        assert!(comment.contains("a=C1"));
        assert!(comment.contains("fg=abc123"));
        assert!(comment.contains("r=10-50"));

        // Parse back
        let parsed = AnchorCompressor::parse_inline_anchor(&comment).unwrap();
        assert_eq!(anchor.anchor_id, parsed.anchor_id);
        assert_eq!(anchor.fingerprint, parsed.fingerprint);
        assert_eq!(anchor.range, parsed.range);
    }

    #[test]
    fn test_inline_anchor_different_languages() {
        let anchor = InlineAnchor {
            anchor_id: "F1".to_string(),
            fingerprint: "xyz789".to_string(),
            range: "1-10".to_string(),
        };

        // Rust
        let rust_comment = AnchorCompressor::format_inline_anchor(&anchor, "rust");
        assert!(rust_comment.starts_with("// "));

        // Python
        let python_comment = AnchorCompressor::format_inline_anchor(&anchor, "python");
        assert!(python_comment.starts_with("# "));

        // JavaScript
        let js_comment = AnchorCompressor::format_inline_anchor(&anchor, "javascript");
        assert!(js_comment.starts_with("// "));
    }

    #[test]
    fn test_header_comment_formatting() {
        let short_data = "SGVsbG8gV29ybGQ="; // "Hello World" in base64
        let comments = AnchorCompressor::format_header_comments(short_data, "rust");

        assert_eq!(comments.len(), 3); // header, content, footer
        assert!(comments[0].starts_with("// agentmap:1"));
        assert!(comments[1].contains("gz64:"));
        assert!(comments[2].contains("total-bytes:"));
        assert!(comments[2].contains("sha1:"));
    }

    #[test]
    fn test_header_comment_chunking() {
        // Create data larger than MAX_HEADER_CHUNK_SIZE
        let large_data = "A".repeat(20000);
        let comments = AnchorCompressor::format_header_comments(&large_data, "rust");

        // Should have header, multiple chunks, and footer
        assert!(comments.len() > 3);
        assert!(comments[0].starts_with("// agentmap:1"));
        assert!(comments[1].contains("gz64[1/"));
        assert!(comments.last().unwrap().contains("total-bytes:"));
    }

    #[test]
    fn test_fingerprint_consistency() {
        let content = "fn main() { println!(\"Hello\"); }";

        let hash1 = AnchorCompressor::hash_content(content);
        let hash2 = AnchorCompressor::hash_content(content);

        assert_eq!(hash1, hash2);
        assert_eq!(hash1.len(), 8); // Truncated to 8 chars
    }

    #[test]
    fn test_fingerprint_uniqueness() {
        let content1 = "fn main() { println!(\"Hello\"); }";
        let content2 = "fn main() { println!(\"World\"); }";

        let hash1 = AnchorCompressor::hash_content(content1);
        let hash2 = AnchorCompressor::hash_content(content2);

        assert_ne!(hash1, hash2);
    }

    #[test]
    fn test_file_id_creation() {
        let path = PathBuf::from("src/lib.rs");
        let content = "pub mod anchor;";

        let file_id = AnchorCompressor::create_file_id(&path, content);

        assert!(file_id.contains("src/lib.rs"));
        assert!(file_id.contains("@"));

        // Same content should produce same ID
        let file_id2 = AnchorCompressor::create_file_id(&path, content);
        assert_eq!(file_id, file_id2);

        // Different content should produce different ID
        let file_id3 = AnchorCompressor::create_file_id(&path, "pub mod other;");
        assert_ne!(file_id, file_id3);
    }

    #[test]
    fn test_cross_reference_indexing() {
        let header = AnchorHeaderBuilder::new(
            PathBuf::from("test.rs"),
            "rust".to_string(),
            "use std::io; struct User {}".to_string(),
        )
        .add_symbol(Symbol {
            id: "C1".to_string(),
            kind: "struct".to_string(),
            name: "User".to_string(),
            owner: None,
            range: SourceRange::new(1, 1, 15, 27),
            frames: vec![],
            roles: vec![],
            references: vec![
                SymbolReference::new("import", "std::io", 1),
                SymbolReference::new("type", "String", 10),
                SymbolReference::new("type", "String", 15),
            ],
            edges: vec![],
            fingerprint: "abc".to_string(),
            guard: None,
        })
        .build();

        // Check xrefs were indexed
        assert!(!header.xrefs.is_empty());

        // Check fast index
        assert!(header.index.by_symbol.contains_key("C1"));
    }

    #[test]
    fn test_symbol_with_edges() {
        let symbol = Symbol {
            id: "M1".to_string(),
            kind: "method".to_string(),
            name: "process".to_string(),
            owner: Some("C1".to_string()),
            range: SourceRange::new(10, 20, 100, 300),
            frames: vec![],
            roles: vec!["handler".to_string()],
            references: vec![],
            edges: vec![
                SymbolEdge::new("call", "helper_fn", 12),
                SymbolEdge::new("uses-type", "Config", 11),
            ],
            fingerprint: "xyz".to_string(),
            guard: Some(GuardInfo {
                io_effects: vec!["network".to_string()],
                invariants: vec!["user_authenticated".to_string()],
            }),
        };

        assert_eq!(symbol.edges.len(), 2);
        assert!(symbol.guard.is_some());
        let guard = symbol.guard.as_ref().unwrap();
        assert_eq!(guard.io_effects.len(), 1);
        assert_eq!(guard.invariants.len(), 1);
    }

    #[test]
    fn test_parse_inline_anchor_with_different_prefixes() {
        // Standard format
        let comment1 = "// am:a=C1;fg=abc;r=1-10";
        assert!(AnchorCompressor::parse_inline_anchor(comment1).is_some());

        // With extra spaces
        let comment2 = "//  am:a=C1;fg=abc;r=1-10";
        assert!(AnchorCompressor::parse_inline_anchor(comment2).is_some());

        // Python style
        let comment3 = "# am:a=C1;fg=abc;r=1-10";
        assert!(AnchorCompressor::parse_inline_anchor(comment3).is_some());

        // Invalid format - missing required field
        let comment4 = "// am:a=C1;fg=abc";
        assert!(AnchorCompressor::parse_inline_anchor(comment4).is_none());

        // Not an anchor comment
        let comment5 = "// regular comment";
        assert!(AnchorCompressor::parse_inline_anchor(comment5).is_none());
    }
}
