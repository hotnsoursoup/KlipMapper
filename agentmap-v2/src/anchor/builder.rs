//! Builder pattern for constructing anchor headers.
//!
//! Provides a fluent API for building anchor headers with
//! automatic index generation and cross-reference tracking.

use std::collections::HashMap;
use std::path::PathBuf;

use super::compress::AnchorCompressor;
use super::types::{
    AnchorHeader, CrossReference, FastIndex, Symbol, ANCHOR_VERSION,
};

/// Builder for constructing `AnchorHeader` instances.
///
/// Provides a fluent API for adding symbols and configuration,
/// automatically generating indexes and cross-references on build.
///
/// # Example
///
/// ```rust,ignore
/// use agentmap::anchor::{AnchorHeaderBuilder, Symbol, SourceRange};
///
/// let header = AnchorHeaderBuilder::new(
///     PathBuf::from("src/lib.rs"),
///     "rust".to_string(),
///     file_content.to_string(),
/// )
/// .add_symbol(Symbol::new("C1", "class", "MyClass", range, fingerprint))
/// .add_symbol(Symbol::new("M1", "method", "process", range, fingerprint).with_owner("C1"))
/// .with_config(config_map)
/// .build();
/// ```
pub struct AnchorHeaderBuilder {
    /// File path being analyzed.
    pub file_path: PathBuf,
    /// Programming language.
    pub language: String,
    /// File content (for fingerprinting).
    pub content: String,
    /// Collected symbols.
    pub symbols: Vec<Symbol>,
    /// Optional configuration metadata.
    pub config: Option<HashMap<String, String>>,
}

impl AnchorHeaderBuilder {
    /// Create a new builder for the given file.
    pub fn new(file_path: PathBuf, language: String, content: String) -> Self {
        Self {
            file_path,
            language,
            content,
            symbols: Vec::new(),
            config: None,
        }
    }

    /// Add a symbol to the header.
    pub fn add_symbol(mut self, symbol: Symbol) -> Self {
        self.symbols.push(symbol);
        self
    }

    /// Add multiple symbols.
    pub fn add_symbols(mut self, symbols: impl IntoIterator<Item = Symbol>) -> Self {
        self.symbols.extend(symbols);
        self
    }

    /// Set configuration metadata.
    pub fn with_config(mut self, config: HashMap<String, String>) -> Self {
        self.config = Some(config);
        self
    }

    /// Add a single configuration entry.
    pub fn add_config(mut self, key: impl Into<String>, value: impl Into<String>) -> Self {
        self.config
            .get_or_insert_with(HashMap::new)
            .insert(key.into(), value.into());
        self
    }

    /// Get the current symbol count.
    pub fn symbol_count(&self) -> usize {
        self.symbols.len()
    }

    /// Build the final `AnchorHeader`.
    ///
    /// This:
    /// 1. Creates file ID and fingerprint
    /// 2. Indexes all symbols
    /// 3. Builds cross-reference maps
    /// 4. Generates fast lookup indexes
    /// 5. Sets current timestamp
    pub fn build(self) -> AnchorHeader {
        let file_id = AnchorCompressor::create_file_id(&self.file_path, &self.content);
        let file_fingerprint = format!("sha1:{}", AnchorCompressor::hash_content(&self.content));

        // Build cross-reference index
        let xrefs = self.build_xrefs();

        // Build fast lookup index
        let index = self.build_index();

        // Get current timestamp
        let timestamp = std::time::SystemTime::now()
            .duration_since(std::time::UNIX_EPOCH)
            .map(|d| d.as_secs())
            .unwrap_or(0);

        AnchorHeader {
            version: ANCHOR_VERSION.to_string(),
            file_id,
            file_fingerprint,
            language: self.language,
            config: self.config,
            symbols: self.symbols,
            xrefs,
            index,
            timestamp,
        }
    }

    /// Build cross-reference index from symbol references.
    fn build_xrefs(&self) -> HashMap<String, Vec<CrossReference>> {
        let mut xrefs: HashMap<String, Vec<CrossReference>> = HashMap::new();

        // Collect references by category
        let mut import_refs: HashMap<String, Vec<u32>> = HashMap::new();
        let mut type_refs: HashMap<String, Vec<u32>> = HashMap::new();
        let mut call_refs: HashMap<String, Vec<u32>> = HashMap::new();

        for symbol in &self.symbols {
            for ref_item in &symbol.references {
                let target_map = match ref_item.ref_type.as_str() {
                    "import" => &mut import_refs,
                    "type" => &mut type_refs,
                    "call" => &mut call_refs,
                    _ => continue,
                };

                target_map
                    .entry(ref_item.target.clone())
                    .or_insert_with(Vec::new)
                    .push(ref_item.at_line);
            }
        }

        // Convert to CrossReference entries
        if !import_refs.is_empty() {
            xrefs.insert(
                "import".to_string(),
                import_refs
                    .into_iter()
                    .map(|(target, lines)| CrossReference::new(target, lines))
                    .collect(),
            );
        }

        if !type_refs.is_empty() {
            xrefs.insert(
                "typeUse".to_string(),
                type_refs
                    .into_iter()
                    .map(|(target, lines)| CrossReference::new(target, lines))
                    .collect(),
            );
        }

        if !call_refs.is_empty() {
            xrefs.insert(
                "call".to_string(),
                call_refs
                    .into_iter()
                    .map(|(target, lines)| CrossReference::new(target, lines))
                    .collect(),
            );
        }

        xrefs
    }

    /// Build fast lookup index from symbols.
    fn build_index(&self) -> FastIndex {
        let mut index = FastIndex::new();

        for symbol in &self.symbols {
            // Index symbol by ID
            index.add_symbol(
                symbol.id.clone(),
                [symbol.range.lines[0], symbol.range.lines[1]],
            );

            // Index type references
            for ref_item in &symbol.references {
                if ref_item.ref_type == "type" {
                    index.add_type_reference(ref_item.target.clone(), ref_item.at_line);
                }
            }
        }

        index
    }
}

/// Builder for creating symbols with a fluent API.
///
/// Alternative to constructing `Symbol` directly.
#[allow(dead_code)]
pub struct SymbolBuilder {
    id: String,
    kind: String,
    name: String,
    owner: Option<String>,
    range: super::types::SourceRange,
    frames: Vec<super::types::ScopeFrame>,
    roles: Vec<String>,
    references: Vec<super::types::SymbolReference>,
    edges: Vec<super::types::SymbolEdge>,
    fingerprint: String,
    guard: Option<super::types::GuardInfo>,
}

#[allow(dead_code)]
impl SymbolBuilder {
    /// Create a new symbol builder.
    pub fn new(
        id: impl Into<String>,
        kind: impl Into<String>,
        name: impl Into<String>,
        range: super::types::SourceRange,
    ) -> Self {
        Self {
            id: id.into(),
            kind: kind.into(),
            name: name.into(),
            owner: None,
            range,
            frames: Vec::new(),
            roles: Vec::new(),
            references: Vec::new(),
            edges: Vec::new(),
            fingerprint: String::new(),
            guard: None,
        }
    }

    /// Set the owner symbol.
    pub fn owner(mut self, owner: impl Into<String>) -> Self {
        self.owner = Some(owner.into());
        self
    }

    /// Add scope frames.
    pub fn frames(mut self, frames: Vec<super::types::ScopeFrame>) -> Self {
        self.frames = frames;
        self
    }

    /// Add a role.
    pub fn role(mut self, role: impl Into<String>) -> Self {
        self.roles.push(role.into());
        self
    }

    /// Add a reference.
    pub fn reference(mut self, reference: super::types::SymbolReference) -> Self {
        self.references.push(reference);
        self
    }

    /// Add an edge.
    pub fn edge(mut self, edge: super::types::SymbolEdge) -> Self {
        self.edges.push(edge);
        self
    }

    /// Set the fingerprint.
    pub fn fingerprint(mut self, fingerprint: impl Into<String>) -> Self {
        self.fingerprint = fingerprint.into();
        self
    }

    /// Set guard info.
    pub fn guard(mut self, guard: super::types::GuardInfo) -> Self {
        self.guard = Some(guard);
        self
    }

    /// Compute fingerprint from content.
    pub fn compute_fingerprint(mut self, content: &str) -> Self {
        self.fingerprint = AnchorCompressor::hash_content(content);
        self
    }

    /// Build the symbol.
    pub fn build(self) -> Symbol {
        Symbol {
            id: self.id,
            kind: self.kind,
            name: self.name,
            owner: self.owner,
            range: self.range,
            frames: self.frames,
            roles: self.roles,
            references: self.references,
            edges: self.edges,
            fingerprint: self.fingerprint,
            guard: self.guard,
        }
    }
}

/// Batch builder for creating multiple symbols efficiently.
#[allow(dead_code)]
pub struct BatchSymbolBuilder {
    file_path: PathBuf,
    language: String,
    content: String,
    id_counter: u32,
    symbols: Vec<Symbol>,
}

#[allow(dead_code)]
impl BatchSymbolBuilder {
    /// Create a new batch builder.
    pub fn new(file_path: PathBuf, language: String, content: String) -> Self {
        Self {
            file_path,
            language,
            content,
            id_counter: 0,
            symbols: Vec::new(),
        }
    }

    /// Generate next symbol ID.
    fn next_id(&mut self, kind: &str) -> String {
        self.id_counter += 1;
        let prefix = match kind {
            "class" | "struct" => "C",
            "method" => "M",
            "function" => "F",
            "interface" | "trait" => "I",
            "enum" => "E",
            "type" => "T",
            "variable" | "field" => "V",
            _ => "S",
        };
        format!("{}{}", prefix, self.id_counter)
    }

    /// Add a class/struct symbol.
    pub fn add_class(
        &mut self,
        name: impl Into<String>,
        range: super::types::SourceRange,
        content_slice: &str,
    ) -> String {
        let id = self.next_id("class");
        self.symbols.push(Symbol::new(
            id.clone(),
            "class",
            name,
            range,
            AnchorCompressor::hash_content(content_slice),
        ));
        id
    }

    /// Add a method symbol.
    pub fn add_method(
        &mut self,
        name: impl Into<String>,
        owner: impl Into<String>,
        range: super::types::SourceRange,
        content_slice: &str,
    ) -> String {
        let id = self.next_id("method");
        self.symbols.push(
            Symbol::new(
                id.clone(),
                "method",
                name,
                range,
                AnchorCompressor::hash_content(content_slice),
            )
            .with_owner(owner),
        );
        id
    }

    /// Add a function symbol.
    pub fn add_function(
        &mut self,
        name: impl Into<String>,
        range: super::types::SourceRange,
        content_slice: &str,
    ) -> String {
        let id = self.next_id("function");
        self.symbols.push(Symbol::new(
            id.clone(),
            "function",
            name,
            range,
            AnchorCompressor::hash_content(content_slice),
        ));
        id
    }

    /// Get a mutable reference to the last added symbol.
    pub fn last_symbol_mut(&mut self) -> Option<&mut Symbol> {
        self.symbols.last_mut()
    }

    /// Build the anchor header from collected symbols.
    pub fn build_header(self) -> AnchorHeader {
        AnchorHeaderBuilder::new(self.file_path, self.language, self.content)
            .add_symbols(self.symbols)
            .build()
    }

    /// Get the collected symbols.
    pub fn into_symbols(self) -> Vec<Symbol> {
        self.symbols
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::anchor::types::{SourceRange, SymbolReference};

    #[test]
    fn test_anchor_header_builder() {
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
        .with_config(HashMap::from([("key".to_string(), "value".to_string())]))
        .build();

        assert_eq!(header.version, ANCHOR_VERSION);
        assert_eq!(header.language, "rust");
        assert_eq!(header.symbols.len(), 1);
        assert!(header.config.is_some());
    }

    #[test]
    fn test_xref_building() {
        let mut symbol = Symbol::new(
            "C1",
            "class",
            "MyClass",
            SourceRange::new(1, 10, 0, 200),
            "abc",
        );
        symbol.add_reference(SymbolReference::import("std::io", 1));
        symbol.add_reference(SymbolReference::type_use("String", 5));
        symbol.add_reference(SymbolReference::type_use("String", 8));

        let header = AnchorHeaderBuilder::new(
            PathBuf::from("test.rs"),
            "rust".to_string(),
            "content".to_string(),
        )
        .add_symbol(symbol)
        .build();

        assert!(header.xrefs.contains_key("import"));
        assert!(header.xrefs.contains_key("typeUse"));

        let type_refs = header.xrefs.get("typeUse").unwrap();
        let string_ref = type_refs.iter().find(|r| r.target == "String").unwrap();
        assert_eq!(string_ref.lines.len(), 2);
    }

    #[test]
    fn test_index_building() {
        let symbol = Symbol::new(
            "F1",
            "function",
            "process",
            SourceRange::new(10, 20, 100, 300),
            "xyz",
        );

        let header = AnchorHeaderBuilder::new(
            PathBuf::from("test.rs"),
            "rust".to_string(),
            "content".to_string(),
        )
        .add_symbol(symbol)
        .build();

        assert_eq!(header.index.get_symbol_range("F1"), Some([10, 20]));
    }

    #[test]
    fn test_symbol_builder() {
        let symbol = SymbolBuilder::new(
            "M1",
            "method",
            "process",
            SourceRange::new(10, 20, 100, 300),
        )
        .owner("C1")
        .role("handler")
        .role("async")
        .fingerprint("abc123")
        .build();

        assert_eq!(symbol.id, "M1");
        assert_eq!(symbol.owner.as_deref(), Some("C1"));
        assert_eq!(symbol.roles.len(), 2);
    }

    #[test]
    fn test_batch_symbol_builder() {
        let mut builder = BatchSymbolBuilder::new(
            PathBuf::from("test.rs"),
            "rust".to_string(),
            "struct User { fn new() {} }".to_string(),
        );

        let class_id = builder.add_class("User", SourceRange::new(1, 1, 0, 27), "struct User {}");

        let _method_id = builder.add_method(
            "new",
            class_id.clone(),
            SourceRange::new(1, 1, 14, 25),
            "fn new() {}",
        );

        let header = builder.build_header();

        assert_eq!(header.symbols.len(), 2);
        assert_eq!(header.symbols[0].id, "C1");
        assert_eq!(header.symbols[1].id, "M2"); // M2 because counter is global
        assert_eq!(header.symbols[1].owner.as_deref(), Some("C1"));
    }

    #[test]
    fn test_add_config() {
        let header = AnchorHeaderBuilder::new(
            PathBuf::from("test.rs"),
            "rust".to_string(),
            "content".to_string(),
        )
        .add_config("feature", "enabled")
        .add_config("version", "2.0")
        .build();

        let config = header.config.unwrap();
        assert_eq!(config.get("feature"), Some(&"enabled".to_string()));
        assert_eq!(config.get("version"), Some(&"2.0".to_string()));
    }
}
