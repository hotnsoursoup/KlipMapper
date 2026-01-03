use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use std::path::PathBuf;
use anyhow::{Result, Context};
use flate2::{write::GzEncoder, read::GzDecoder, Compression};
use base64::{Engine as _, engine::general_purpose};
use std::io::{Write, Read};
use sha2::{Sha256, Digest};

/// Version of the anchor schema
pub const ANCHOR_VERSION: &str = "1.0";

/// Maximum size for inline anchors (bytes)
pub const MAX_INLINE_ANCHOR_SIZE: usize = 64;

/// Maximum size for header before chunking
pub const MAX_HEADER_CHUNK_SIZE: usize = 8192;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SourceRange {
    /// Line range [start, end] (1-indexed, inclusive)
    #[serde(rename = "l")]
    pub lines: [u32; 2],
    /// Byte range [start, end] (0-indexed, inclusive)  
    #[serde(rename = "b")]
    pub bytes: [u32; 2],
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ScopeFrame {
    /// Frame kind: "file", "class", "method", "block", etc.
    #[serde(rename = "k")]
    pub kind: String,
    /// Optional frame name/identifier
    #[serde(rename = "n", skip_serializing_if = "Option::is_none")]
    pub name: Option<String>,
    /// Frame source range
    #[serde(rename = "r")]
    pub range: SourceRange,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SymbolReference {
    /// Reference type: "import", "type", "call", "read", "write", etc.
    #[serde(rename = "t")]
    pub ref_type: String,
    /// Target symbol identifier
    #[serde(rename = "q")]
    pub target: String,
    /// Line number where reference occurs
    #[serde(rename = "at")]
    pub at_line: u32,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SymbolEdge {
    /// Edge type: "call", "inherit", "override", "uses-type", etc.
    #[serde(rename = "t")]
    pub edge_type: String,
    /// Target symbol identifier
    #[serde(rename = "to")]
    pub target: String,
    /// Line number where edge occurs
    #[serde(rename = "at")]
    pub at_line: u32,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct GuardInfo {
    /// IO effects: "network", "file", "database", etc.
    #[serde(rename = "io", skip_serializing_if = "Vec::is_empty", default)]
    pub io_effects: Vec<String>,
    /// Invariants/preconditions
    #[serde(rename = "inv", skip_serializing_if = "Vec::is_empty", default)]
    pub invariants: Vec<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Symbol {
    /// Short symbol ID (unique within file)
    #[serde(rename = "id")]
    pub id: String,
    /// Symbol kind: "class", "method", "function", "type", etc.
    #[serde(rename = "k")]
    pub kind: String,
    /// Symbol name
    #[serde(rename = "n")]
    pub name: String,
    /// Owner symbol (for methods, fields, etc.)
    #[serde(rename = "own", skip_serializing_if = "Option::is_none")]
    pub owner: Option<String>,
    /// Source range of the symbol
    #[serde(rename = "r")]
    pub range: SourceRange,
    /// Nested scope frames
    #[serde(rename = "fr")]
    pub frames: Vec<ScopeFrame>,
    /// Role annotations
    #[serde(rename = "roles", skip_serializing_if = "Vec::is_empty", default)]
    pub roles: Vec<String>,
    /// Symbol references (imports, type uses, etc.)
    #[serde(rename = "refs", skip_serializing_if = "Vec::is_empty", default)]
    pub references: Vec<SymbolReference>,
    /// Outgoing edges to other symbols
    #[serde(rename = "edges", skip_serializing_if = "Vec::is_empty", default)]
    pub edges: Vec<SymbolEdge>,
    /// Content fingerprint for change detection
    #[serde(rename = "fg")]
    pub fingerprint: String,
    /// Optional guard/effect information
    #[serde(rename = "guard", skip_serializing_if = "Option::is_none")]
    pub guard: Option<GuardInfo>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CrossReference {
    /// Target identifier (import path, type name, etc.)
    #[serde(rename = "q")]
    pub target: String,
    /// List of line numbers where it appears
    #[serde(rename = "ls")]
    pub lines: Vec<u32>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct FastIndex {
    /// Symbol ID -> line range mapping
    #[serde(rename = "bySym")]
    pub by_symbol: HashMap<String, [u32; 2]>,
    /// Type name -> line occurrences
    #[serde(rename = "byType")]
    pub by_type: HashMap<String, Vec<u32>>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AnchorHeader {
    /// Schema version
    #[serde(rename = "v")]
    pub version: String,
    /// File identifier with hash
    #[serde(rename = "fid")]
    pub file_id: String,
    /// File content fingerprint
    #[serde(rename = "fp")]
    pub file_fingerprint: String,
    /// Programming language
    #[serde(rename = "lang")]
    pub language: String,
    /// Optional config metadata
    #[serde(rename = "cfg", skip_serializing_if = "Option::is_none")]
    pub config: Option<HashMap<String, String>>,
    /// Symbols in this file
    #[serde(rename = "sym")]
    pub symbols: Vec<Symbol>,
    /// Cross-reference index
    #[serde(rename = "xrefs")]
    pub xrefs: HashMap<String, Vec<CrossReference>>,
    /// Fast lookup index
    #[serde(rename = "idx")]
    pub index: FastIndex,
    /// Timestamp when generated
    #[serde(rename = "ts")]
    pub timestamp: u64,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct InlineAnchor {
    /// Symbol ID reference
    #[serde(rename = "a")]
    pub anchor_id: String,
    /// Short fingerprint
    #[serde(rename = "fg")]
    pub fingerprint: String,
    /// Line range hint
    #[serde(rename = "r")]
    pub range: String, // e.g., "42-118"
}

pub struct AnchorCompressor;

impl AnchorCompressor {
    /// Compress and encode header for embedding in comments
    pub fn compress_header(header: &AnchorHeader) -> Result<String> {
        let json = serde_json::to_string(header)
            .context("Failed to serialize anchor header")?;
        
        let mut encoder = GzEncoder::new(Vec::new(), Compression::best());
        encoder.write_all(json.as_bytes())
            .context("Failed to compress header")?;
        let compressed = encoder.finish()
            .context("Failed to finalize compression")?;
        
        Ok(general_purpose::STANDARD.encode(&compressed))
    }

    /// Decompress header from base64 string
    pub fn decompress_header(compressed: &str) -> Result<AnchorHeader> {
        let compressed_bytes = general_purpose::STANDARD.decode(compressed)
            .context("Failed to decode base64")?;
        
        let mut decoder = GzDecoder::new(&compressed_bytes[..]);
        let mut json = String::new();
        decoder.read_to_string(&mut json)
            .context("Failed to decompress header")?;
        
        serde_json::from_str(&json)
            .context("Failed to deserialize anchor header")
    }

    /// Create chunked comment lines for large headers
    pub fn format_header_comments(compressed: &str, lang: &str) -> Vec<String> {
        let chunk_size = MAX_HEADER_CHUNK_SIZE;
        let chunks: Vec<String> = compressed
            .as_bytes()
            .chunks(chunk_size)
            .map(|chunk| std::str::from_utf8(chunk).unwrap_or("").to_string())
            .collect();

        let comment_prefix = match lang {
            "rust" | "javascript" | "typescript" | "java" | "dart" => "//",
            "python" => "#",
            _ => "//",
        };

        let mut lines = vec![format!("{} agentmap:1", comment_prefix)];
        
        if chunks.len() == 1 {
            lines.push(format!("{} gz64: {}", comment_prefix, compressed));
        } else {
            for (i, chunk) in chunks.iter().enumerate() {
                lines.push(format!("{} gz64[{}/{}]: {}", comment_prefix, i + 1, chunks.len(), chunk));
            }
        }
        
        lines.push(format!("{} total-bytes: {} sha1:{}", 
            comment_prefix, 
            compressed.len(),
            Self::hash_content(compressed)
        ));

        lines
    }

    /// Generate inline anchor comment
    pub fn format_inline_anchor(anchor: &InlineAnchor, lang: &str) -> String {
        let comment_prefix = match lang {
            "rust" | "javascript" | "typescript" | "java" | "dart" => "//",
            "python" => "#",
            _ => "//",
        };

        format!("{} am:a={};fg={};r={}", 
            comment_prefix,
            anchor.anchor_id,
            anchor.fingerprint,
            anchor.range
        )
    }

    /// Parse inline anchor from comment
    pub fn parse_inline_anchor(comment: &str) -> Option<InlineAnchor> {
        // Look for pattern: // am:a=ID;fg=HASH;r=RANGE
        if let Some(am_part) = comment.strip_prefix("//").and_then(|s| s.trim().strip_prefix("am:")) {
            let mut anchor_id = None;
            let mut fingerprint = None;
            let mut range = None;

            for part in am_part.split(';') {
                if let Some(value) = part.strip_prefix("a=") {
                    anchor_id = Some(value.to_string());
                } else if let Some(value) = part.strip_prefix("fg=") {
                    fingerprint = Some(value.to_string());
                } else if let Some(value) = part.strip_prefix("r=") {
                    range = Some(value.to_string());
                }
            }

            if let (Some(a), Some(fg), Some(r)) = (anchor_id, fingerprint, range) {
                return Some(InlineAnchor {
                    anchor_id: a,
                    fingerprint: fg,
                    range: r,
                });
            }
        }
        None
    }

    /// Create content fingerprint
    pub fn hash_content(content: &str) -> String {
        let mut hasher = Sha256::new();
        hasher.update(content.as_bytes());
        let result = hasher.finalize();
        format!("{:x}", result)[..8].to_string() // First 8 chars
    }

    /// Create file fingerprint from path and content
    pub fn create_file_id(path: &PathBuf, content: &str) -> String {
        format!("{}@{}", 
            path.to_string_lossy().replace('\\', "/"),
            Self::hash_content(content)
        )
    }
}

/// Builder for constructing anchor headers
pub struct AnchorHeaderBuilder {
    pub file_path: PathBuf,
    pub language: String,
    pub content: String,
    pub symbols: Vec<Symbol>,
    pub config: Option<HashMap<String, String>>,
}

impl AnchorHeaderBuilder {
    pub fn new(file_path: PathBuf, language: String, content: String) -> Self {
        Self {
            file_path,
            language,
            content,
            symbols: Vec::new(),
            config: None,
        }
    }

    pub fn add_symbol(mut self, symbol: Symbol) -> Self {
        self.symbols.push(symbol);
        self
    }

    pub fn with_config(mut self, config: HashMap<String, String>) -> Self {
        self.config = Some(config);
        self
    }

    pub fn build(self) -> AnchorHeader {
        let file_id = AnchorCompressor::create_file_id(&self.file_path, &self.content);
        let file_fingerprint = format!("sha1:{}", AnchorCompressor::hash_content(&self.content));
        
        // Build cross-reference index
        let mut xrefs: HashMap<String, Vec<CrossReference>> = HashMap::new();
        let mut by_symbol: HashMap<String, [u32; 2]> = HashMap::new();
        let mut by_type: HashMap<String, Vec<u32>> = HashMap::new();

        for symbol in &self.symbols {
            by_symbol.insert(symbol.id.clone(), [symbol.range.lines[0], symbol.range.lines[1]]);
            
            // Collect import references
            let mut import_refs = Vec::new();
            let mut type_refs = Vec::new();
            
            for ref_item in &symbol.references {
                match ref_item.ref_type.as_str() {
                    "import" => {
                        if let Some(existing) = import_refs.iter_mut().find(|cr: &&mut CrossReference| cr.target == ref_item.target) {
                            existing.lines.push(ref_item.at_line);
                        } else {
                            import_refs.push(CrossReference {
                                target: ref_item.target.clone(),
                                lines: vec![ref_item.at_line],
                            });
                        }
                    },
                    "type" => {
                        if let Some(existing) = type_refs.iter_mut().find(|cr: &&mut CrossReference| cr.target == ref_item.target) {
                            existing.lines.push(ref_item.at_line);
                        } else {
                            type_refs.push(CrossReference {
                                target: ref_item.target.clone(),
                                lines: vec![ref_item.at_line],
                            });
                        }
                    },
                    _ => {}
                }
            }

            if !import_refs.is_empty() {
                xrefs.insert("import".to_string(), import_refs);
            }
            if !type_refs.is_empty() {
                xrefs.insert("typeUse".to_string(), type_refs);
            }

            // Build type index
            for ref_item in &symbol.references {
                if ref_item.ref_type == "type" {
                    by_type.entry(ref_item.target.clone())
                        .or_insert_with(Vec::new)
                        .push(ref_item.at_line);
                }
            }
        }

        let index = FastIndex {
            by_symbol,
            by_type,
        };

        AnchorHeader {
            version: ANCHOR_VERSION.to_string(),
            file_id,
            file_fingerprint,
            language: self.language,
            config: self.config,
            symbols: self.symbols,
            xrefs,
            index,
            timestamp: std::time::SystemTime::now()
                .duration_since(std::time::UNIX_EPOCH)
                .unwrap()
                .as_secs(),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::path::PathBuf;

    #[test]
    fn test_anchor_compression() {
        let header = AnchorHeaderBuilder::new(
            PathBuf::from("test.rs"),
            "rust".to_string(),
            "struct TestClass {}".to_string(),
        )
        .add_symbol(Symbol {
            id: "C1".to_string(),
            kind: "class".to_string(),
            name: "TestClass".to_string(),
            owner: None,
            range: SourceRange { lines: [10, 50], bytes: [200, 1000] },
            frames: vec![
                ScopeFrame {
                    kind: "file".to_string(),
                    name: None,
                    range: SourceRange { lines: [1, 100], bytes: [0, 2000] },
                },
                ScopeFrame {
                    kind: "class".to_string(),
                    name: Some("TestClass".to_string()),
                    range: SourceRange { lines: [10, 50], bytes: [200, 1000] },
                },
            ],
            roles: vec!["entity".to_string()],
            references: Vec::new(),
            edges: Vec::new(),
            fingerprint: "abc123".to_string(),
            guard: None,
        })
        .build();

        let compressed = AnchorCompressor::compress_header(&header).unwrap();
        let decompressed = AnchorCompressor::decompress_header(&compressed).unwrap();

        assert_eq!(header.version, decompressed.version);
        assert_eq!(header.language, decompressed.language);
        assert_eq!(header.symbols.len(), decompressed.symbols.len());
        assert_eq!(header.symbols[0].name, decompressed.symbols[0].name);
    }

    #[test]
    fn test_inline_anchor_parsing() {
        let comment = "// am:a=C1;fg=abc123;r=10-50";
        let anchor = AnchorCompressor::parse_inline_anchor(comment).unwrap();

        assert_eq!(anchor.anchor_id, "C1");
        assert_eq!(anchor.fingerprint, "abc123");
        assert_eq!(anchor.range, "10-50");
    }

    #[test]
    fn test_header_comment_formatting() {
        let short_data = "SGVsbG8gV29ybGQ="; // "Hello World" in base64
        let comments = AnchorCompressor::format_header_comments(short_data, "rust");
        
        assert!(comments[0].starts_with("// agentmap:1"));
        assert!(comments[1].contains("gz64:"));
        assert!(comments[2].contains("total-bytes:"));
    }
}