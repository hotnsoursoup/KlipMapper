//! Compression and formatting for anchor headers.
//!
//! Uses gzip compression with base64 encoding to create compact,
//! ASCII-safe representations that can be embedded in source comments.

use std::io::{Read, Write};
use std::path::PathBuf;

use anyhow::{Context, Result};
use base64::{engine::general_purpose, Engine as _};
use flate2::{read::GzDecoder, write::GzEncoder, Compression};
use sha2::{Digest, Sha256};

use super::types::{AnchorHeader, InlineAnchor, MAX_HEADER_CHUNK_SIZE};

/// Compressor for anchor headers and inline anchors.
///
/// Provides compression, decompression, and formatting utilities
/// for embedding analysis metadata in source code comments.
pub struct AnchorCompressor;

impl AnchorCompressor {
    /// Compress and base64-encode an anchor header.
    ///
    /// Uses gzip best compression for maximum space savings,
    /// then base64 encodes for ASCII-safe embedding.
    ///
    /// # Example
    ///
    /// ```rust,ignore
    /// let header = AnchorHeaderBuilder::new(...).build();
    /// let compressed = AnchorCompressor::compress_header(&header)?;
    /// // compressed is a base64 string like "H4sIAAAAAAAA/8tIzcnJ..."
    /// ```
    pub fn compress_header(header: &AnchorHeader) -> Result<String> {
        // Serialize to JSON
        let json = serde_json::to_string(header)
            .context("Failed to serialize anchor header to JSON")?;

        // Compress with gzip (best compression)
        let mut encoder = GzEncoder::new(Vec::new(), Compression::best());
        encoder
            .write_all(json.as_bytes())
            .context("Failed to write to gzip encoder")?;
        let compressed = encoder
            .finish()
            .context("Failed to finalize gzip compression")?;

        // Base64 encode for ASCII safety
        Ok(general_purpose::STANDARD.encode(&compressed))
    }

    /// Decompress a base64-encoded anchor header.
    ///
    /// Reverses the compression process to restore the original header.
    ///
    /// # Example
    ///
    /// ```rust,ignore
    /// let header = AnchorCompressor::decompress_header(&compressed)?;
    /// println!("Symbols: {}", header.symbols.len());
    /// ```
    pub fn decompress_header(compressed: &str) -> Result<AnchorHeader> {
        // Decode base64
        let compressed_bytes = general_purpose::STANDARD
            .decode(compressed)
            .context("Failed to decode base64 anchor data")?;

        // Decompress gzip
        let mut decoder = GzDecoder::new(&compressed_bytes[..]);
        let mut json = String::new();
        decoder
            .read_to_string(&mut json)
            .context("Failed to decompress gzip anchor data")?;

        // Deserialize JSON
        serde_json::from_str(&json).context("Failed to deserialize anchor header from JSON")
    }

    /// Format a compressed header as comment lines for embedding.
    ///
    /// Creates properly formatted comments with:
    /// - Header marker (`agentmap:1`)
    /// - Compressed content (chunked if large)
    /// - Footer with size and checksum
    ///
    /// # Arguments
    ///
    /// * `compressed` - Base64-encoded compressed header
    /// * `lang` - Programming language for comment syntax
    ///
    /// # Example
    ///
    /// ```rust,ignore
    /// let comments = AnchorCompressor::format_header_comments(&compressed, "rust");
    /// // ["// agentmap:1", "// gz64: H4sI...", "// total-bytes: 42 sha1:a1b2"]
    /// ```
    pub fn format_header_comments(compressed: &str, lang: &str) -> Vec<String> {
        let comment_prefix = Self::comment_prefix(lang);
        let chunk_size = MAX_HEADER_CHUNK_SIZE;

        // Split into chunks if needed
        let chunks: Vec<String> = compressed
            .as_bytes()
            .chunks(chunk_size)
            .map(|chunk| std::str::from_utf8(chunk).unwrap_or("").to_string())
            .collect();

        let mut lines = Vec::with_capacity(chunks.len() + 2);

        // Header marker
        lines.push(format!("{} agentmap:1", comment_prefix));

        // Content (single or chunked)
        if chunks.len() == 1 {
            lines.push(format!("{} gz64: {}", comment_prefix, compressed));
        } else {
            for (i, chunk) in chunks.iter().enumerate() {
                lines.push(format!(
                    "{} gz64[{}/{}]: {}",
                    comment_prefix,
                    i + 1,
                    chunks.len(),
                    chunk
                ));
            }
        }

        // Footer with size and checksum
        lines.push(format!(
            "{} total-bytes: {} sha1:{}",
            comment_prefix,
            compressed.len(),
            Self::hash_content(compressed)
        ));

        lines
    }

    /// Parse anchor header from comment lines.
    ///
    /// Extracts and reassembles the compressed content from formatted comments.
    ///
    /// # Returns
    ///
    /// The compressed base64 string if valid header comments are found.
    pub fn parse_header_comments(lines: &[&str]) -> Option<String> {
        let mut in_header = false;
        let mut chunks: Vec<(usize, String)> = Vec::new();
        let mut single_content: Option<String> = None;

        for line in lines {
            // Strip comment prefix
            let content = Self::strip_comment_prefix(line)?;
            let content = content.trim();

            if content.starts_with("agentmap:") {
                in_header = true;
                continue;
            }

            if !in_header {
                continue;
            }

            if content.starts_with("total-bytes:") {
                // End of header
                break;
            }

            // Parse content line
            if let Some(data) = content.strip_prefix("gz64:") {
                single_content = Some(data.trim().to_string());
            } else if content.starts_with("gz64[") {
                // Parse chunk: gz64[1/3]: data
                if let Some((index_part, data)) = content
                    .strip_prefix("gz64[")
                    .and_then(|s| s.split_once("]: "))
                {
                    if let Some((idx_str, _total_str)) = index_part.split_once('/') {
                        if let Ok(idx) = idx_str.parse::<usize>() {
                            chunks.push((idx, data.to_string()));
                        }
                    }
                }
            }
        }

        // Return single content or reassemble chunks
        if let Some(content) = single_content {
            Some(content)
        } else if !chunks.is_empty() {
            chunks.sort_by_key(|(idx, _)| *idx);
            Some(chunks.into_iter().map(|(_, data)| data).collect())
        } else {
            None
        }
    }

    /// Format an inline anchor as a comment.
    ///
    /// Creates a compact comment suitable for placing next to a symbol.
    ///
    /// # Example
    ///
    /// ```rust,ignore
    /// let comment = AnchorCompressor::format_inline_anchor(&anchor, "rust");
    /// // "// am:a=C1;fg=abc123;r=10-50"
    /// ```
    pub fn format_inline_anchor(anchor: &InlineAnchor, lang: &str) -> String {
        let prefix = Self::comment_prefix(lang);
        format!(
            "{} am:a={};fg={};r={}",
            prefix, anchor.anchor_id, anchor.fingerprint, anchor.range
        )
    }

    /// Parse an inline anchor from a comment string.
    ///
    /// Extracts anchor data from both `//` and `#` style comments.
    /// The anchor can appear anywhere in the line (e.g., after code).
    ///
    /// # Returns
    ///
    /// `Some(InlineAnchor)` if the comment contains a valid anchor.
    pub fn parse_inline_anchor(comment: &str) -> Option<InlineAnchor> {
        // Look for anchor marker anywhere in the line
        let am_pos = comment.find("am:")?;
        let am_part = &comment[am_pos + 3..];

        // Parse key=value pairs (stop at whitespace or newline)
        let mut anchor_id = None;
        let mut fingerprint = None;
        let mut range = None;

        // Get the anchor content (everything until whitespace or end of line)
        let anchor_content = am_part.split_whitespace().next().unwrap_or(am_part);

        for part in anchor_content.split(';') {
            let part = part.trim();
            if let Some(value) = part.strip_prefix("a=") {
                anchor_id = Some(value.to_string());
            } else if let Some(value) = part.strip_prefix("fg=") {
                fingerprint = Some(value.to_string());
            } else if let Some(value) = part.strip_prefix("r=") {
                range = Some(value.to_string());
            }
        }

        // All fields required
        match (anchor_id, fingerprint, range) {
            (Some(a), Some(fg), Some(r)) => Some(InlineAnchor {
                anchor_id: a,
                fingerprint: fg,
                range: r,
            }),
            _ => None,
        }
    }

    /// Create a SHA-256 content fingerprint (truncated to 8 chars).
    ///
    /// Used for change detection and verification.
    pub fn hash_content(content: &str) -> String {
        let mut hasher = Sha256::new();
        hasher.update(content.as_bytes());
        let result = hasher.finalize();
        format!("{:x}", result)[..8].to_string()
    }

    /// Create a file identifier combining path and content hash.
    ///
    /// Format: `path/to/file.rs@a1b2c3d4`
    pub fn create_file_id(path: &PathBuf, content: &str) -> String {
        format!(
            "{}@{}",
            path.to_string_lossy().replace('\\', "/"),
            Self::hash_content(content)
        )
    }

    /// Get the comment prefix for a language.
    pub fn comment_prefix(lang: &str) -> &'static str {
        match lang.to_lowercase().as_str() {
            "python" | "py" | "shell" | "bash" | "sh" | "ruby" | "rb" | "perl" | "yaml" | "yml" => {
                "#"
            }
            "rust" | "javascript" | "js" | "typescript" | "ts" | "java" | "dart" | "go"
            | "c" | "cpp" | "c++" | "csharp" | "cs" | "swift" | "kotlin" => "//",
            "html" | "xml" => "<!--", // Note: closing --> needed
            "sql" => "--",
            "lua" => "--",
            _ => "//",
        }
    }

    /// Get the closing comment suffix for a language (if any).
    pub fn comment_suffix(lang: &str) -> Option<&'static str> {
        match lang.to_lowercase().as_str() {
            "html" | "xml" => Some("-->"),
            _ => None,
        }
    }

    /// Strip the comment prefix from a line.
    fn strip_comment_prefix(line: &str) -> Option<&str> {
        let trimmed = line.trim_start();

        // Try various comment prefixes
        if let Some(rest) = trimmed.strip_prefix("//") {
            Some(rest)
        } else if let Some(rest) = trimmed.strip_prefix('#') {
            Some(rest)
        } else if let Some(rest) = trimmed.strip_prefix("--") {
            Some(rest)
        } else if let Some(rest) = trimmed.strip_prefix("<!--") {
            // Remove closing --> if present
            Some(rest.trim_end_matches("-->"))
        } else {
            None
        }
    }

    /// Extract all anchor comments from source code.
    ///
    /// Returns both header and inline anchors found in the source.
    pub fn extract_anchors(source: &str, _lang: &str) -> ExtractedAnchors {
        let lines: Vec<&str> = source.lines().collect();
        let mut result = ExtractedAnchors {
            header: None,
            inline: Vec::new(),
        };

        // Try to parse header from beginning of file
        if let Some(compressed) = Self::parse_header_comments(&lines[..lines.len().min(50)]) {
            if let Ok(header) = Self::decompress_header(&compressed) {
                result.header = Some(header);
            }
        }

        // Find inline anchors
        for (line_num, line) in lines.iter().enumerate() {
            if let Some(anchor) = Self::parse_inline_anchor(line) {
                result.inline.push((line_num as u32 + 1, anchor));
            }
        }

        result
    }

    /// Check if a file has a valid anchor header.
    pub fn has_anchor_header(source: &str) -> bool {
        let prefix = source.lines().take(5).collect::<Vec<_>>();
        prefix.iter().any(|line| {
            let trimmed = line.trim();
            trimmed.contains("agentmap:1") || trimmed.contains("agentmap:2")
        })
    }

    /// Validate anchor header against current file content.
    pub fn validate_header(header: &AnchorHeader, content: &str) -> ValidationResult {
        let current_hash = Self::hash_content(content);
        let expected_hash = header
            .file_fingerprint
            .strip_prefix("sha1:")
            .unwrap_or(&header.file_fingerprint);

        if current_hash == expected_hash {
            ValidationResult::Valid
        } else {
            ValidationResult::Stale {
                header_hash: expected_hash.to_string(),
                current_hash,
            }
        }
    }
}

/// Result of extracting anchors from source code.
#[derive(Debug, Clone)]
pub struct ExtractedAnchors {
    /// File-level header anchor (if present).
    pub header: Option<AnchorHeader>,
    /// Inline anchors with their line numbers.
    pub inline: Vec<(u32, InlineAnchor)>,
}

impl ExtractedAnchors {
    /// Check if any anchors were found.
    pub fn is_empty(&self) -> bool {
        self.header.is_none() && self.inline.is_empty()
    }

    /// Get the count of inline anchors.
    pub fn inline_count(&self) -> usize {
        self.inline.len()
    }
}

/// Result of validating an anchor header.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum ValidationResult {
    /// Header matches current file content.
    Valid,
    /// Header is outdated (file changed).
    Stale {
        /// Hash stored in header.
        header_hash: String,
        /// Hash of current content.
        current_hash: String,
    },
}

impl ValidationResult {
    /// Check if the header is valid.
    pub fn is_valid(&self) -> bool {
        matches!(self, Self::Valid)
    }

    /// Check if the header is stale.
    pub fn is_stale(&self) -> bool {
        matches!(self, Self::Stale { .. })
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::anchor::{AnchorHeaderBuilder, SourceRange, Symbol};

    #[test]
    fn test_compress_decompress_roundtrip() {
        let header = AnchorHeaderBuilder::new(
            PathBuf::from("test.rs"),
            "rust".to_string(),
            "fn main() {}".to_string(),
        )
        .add_symbol(Symbol::new(
            "F1",
            "function",
            "main",
            SourceRange::new(1, 1, 0, 12),
            "abc123",
        ))
        .build();

        let compressed = AnchorCompressor::compress_header(&header).unwrap();
        let restored = AnchorCompressor::decompress_header(&compressed).unwrap();

        assert_eq!(header.version, restored.version);
        assert_eq!(header.language, restored.language);
        assert_eq!(header.symbols.len(), restored.symbols.len());
        assert_eq!(header.symbols[0].name, restored.symbols[0].name);
    }

    #[test]
    fn test_comment_prefix_languages() {
        assert_eq!(AnchorCompressor::comment_prefix("rust"), "//");
        assert_eq!(AnchorCompressor::comment_prefix("python"), "#");
        assert_eq!(AnchorCompressor::comment_prefix("javascript"), "//");
        assert_eq!(AnchorCompressor::comment_prefix("typescript"), "//");
        assert_eq!(AnchorCompressor::comment_prefix("java"), "//");
        assert_eq!(AnchorCompressor::comment_prefix("go"), "//");
        assert_eq!(AnchorCompressor::comment_prefix("ruby"), "#");
        assert_eq!(AnchorCompressor::comment_prefix("sql"), "--");
    }

    #[test]
    fn test_hash_consistency() {
        let content = "Hello, World!";
        let hash1 = AnchorCompressor::hash_content(content);
        let hash2 = AnchorCompressor::hash_content(content);

        assert_eq!(hash1, hash2);
        assert_eq!(hash1.len(), 8);
    }

    #[test]
    fn test_hash_uniqueness() {
        let hash1 = AnchorCompressor::hash_content("Hello");
        let hash2 = AnchorCompressor::hash_content("World");

        assert_ne!(hash1, hash2);
    }

    #[test]
    fn test_file_id_creation() {
        let path = PathBuf::from("src/main.rs");
        let content = "fn main() {}";

        let file_id = AnchorCompressor::create_file_id(&path, content);

        assert!(file_id.contains("src/main.rs"));
        assert!(file_id.contains("@"));
        assert_eq!(file_id.split('@').count(), 2);
    }

    #[test]
    fn test_inline_anchor_roundtrip() {
        let anchor = InlineAnchor::new("C1", "abc123", "10-50");

        let comment = AnchorCompressor::format_inline_anchor(&anchor, "rust");
        let parsed = AnchorCompressor::parse_inline_anchor(&comment).unwrap();

        assert_eq!(anchor.anchor_id, parsed.anchor_id);
        assert_eq!(anchor.fingerprint, parsed.fingerprint);
        assert_eq!(anchor.range, parsed.range);
    }

    #[test]
    fn test_parse_header_comments() {
        let lines = [
            "// agentmap:1",
            "// gz64: SGVsbG8gV29ybGQ=",
            "// total-bytes: 16 sha1:a1b2c3d4",
        ];

        let compressed = AnchorCompressor::parse_header_comments(&lines);
        assert!(compressed.is_some());
        assert_eq!(compressed.unwrap(), "SGVsbG8gV29ybGQ=");
    }

    #[test]
    fn test_parse_chunked_header_comments() {
        let lines = [
            "// agentmap:1",
            "// gz64[1/3]: AAA",
            "// gz64[2/3]: BBB",
            "// gz64[3/3]: CCC",
            "// total-bytes: 9 sha1:xyz",
        ];

        let compressed = AnchorCompressor::parse_header_comments(&lines);
        assert!(compressed.is_some());
        assert_eq!(compressed.unwrap(), "AAABBBCCC");
    }

    #[test]
    fn test_has_anchor_header() {
        let with_anchor = "// agentmap:1\n// gz64: data\nfn main() {}";
        let without_anchor = "fn main() {}";

        assert!(AnchorCompressor::has_anchor_header(with_anchor));
        assert!(!AnchorCompressor::has_anchor_header(without_anchor));
    }

    #[test]
    fn test_validation_result() {
        let result = ValidationResult::Valid;
        assert!(result.is_valid());
        assert!(!result.is_stale());

        let stale = ValidationResult::Stale {
            header_hash: "abc".to_string(),
            current_hash: "def".to_string(),
        };
        assert!(!stale.is_valid());
        assert!(stale.is_stale());
    }

    #[test]
    fn test_extract_anchors_inline() {
        let source = r#"
fn main() { // am:a=F1;fg=abc123;r=1-5
    println!("Hello");
}
struct User { // am:a=C1;fg=def456;r=4-10
    name: String,
}
"#;

        let extracted = AnchorCompressor::extract_anchors(source, "rust");

        assert!(extracted.header.is_none());
        assert_eq!(extracted.inline.len(), 2);
        assert_eq!(extracted.inline[0].1.anchor_id, "F1");
        assert_eq!(extracted.inline[1].1.anchor_id, "C1");
    }
}
