//! Data types for the anchor system.
//!
//! All types use compact serde field renaming to minimize compressed size.

use serde::{Deserialize, Serialize};
use std::collections::HashMap;

/// Schema version for anchor format.
/// Increment when making breaking changes to the schema.
pub const ANCHOR_VERSION: &str = "1.0";

/// Maximum size for inline anchor comments (bytes).
/// Anchors larger than this should use header format instead.
pub const MAX_INLINE_ANCHOR_SIZE: usize = 64;

/// Maximum size for a single header chunk before splitting.
/// Headers larger than this are split across multiple comment lines.
pub const MAX_HEADER_CHUNK_SIZE: usize = 8192;

/// Source location range within a file.
///
/// Tracks both line-based and byte-based ranges for precise navigation.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct SourceRange {
    /// Line range [start, end] (1-indexed, inclusive).
    #[serde(rename = "l")]
    pub lines: [u32; 2],
    /// Byte range [start, end] (0-indexed, inclusive).
    #[serde(rename = "b")]
    pub bytes: [u32; 2],
}

impl SourceRange {
    /// Create a new source range.
    pub fn new(start_line: u32, end_line: u32, start_byte: u32, end_byte: u32) -> Self {
        Self {
            lines: [start_line, end_line],
            bytes: [start_byte, end_byte],
        }
    }

    /// Get the start line (1-indexed).
    pub fn start_line(&self) -> u32 {
        self.lines[0]
    }

    /// Get the end line (1-indexed).
    pub fn end_line(&self) -> u32 {
        self.lines[1]
    }

    /// Get the start byte offset.
    pub fn start_byte(&self) -> u32 {
        self.bytes[0]
    }

    /// Get the end byte offset.
    pub fn end_byte(&self) -> u32 {
        self.bytes[1]
    }

    /// Get line count.
    pub fn line_count(&self) -> u32 {
        self.lines[1].saturating_sub(self.lines[0]) + 1
    }

    /// Get byte length.
    pub fn byte_len(&self) -> u32 {
        self.bytes[1].saturating_sub(self.bytes[0])
    }

    /// Check if a line is within this range.
    pub fn contains_line(&self, line: u32) -> bool {
        line >= self.lines[0] && line <= self.lines[1]
    }

    /// Check if a byte offset is within this range.
    pub fn contains_byte(&self, byte: u32) -> bool {
        byte >= self.bytes[0] && byte <= self.bytes[1]
    }

    /// Format as a compact range string (e.g., "10-50").
    pub fn to_range_string(&self) -> String {
        format!("{}-{}", self.lines[0], self.lines[1])
    }

    /// Parse from a compact range string.
    pub fn from_range_string(s: &str) -> Option<Self> {
        let parts: Vec<&str> = s.split('-').collect();
        if parts.len() == 2 {
            let start = parts[0].parse().ok()?;
            let end = parts[1].parse().ok()?;
            Some(Self::new(start, end, 0, 0))
        } else {
            None
        }
    }
}

impl Default for SourceRange {
    fn default() -> Self {
        Self::new(0, 0, 0, 0)
    }
}

/// A frame in the scope stack.
///
/// Represents a nesting level in the code structure (file, class, method, block).
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct ScopeFrame {
    /// Frame kind: "file", "class", "struct", "method", "function", "block", etc.
    #[serde(rename = "k")]
    pub kind: String,
    /// Optional frame name/identifier.
    #[serde(rename = "n", skip_serializing_if = "Option::is_none")]
    pub name: Option<String>,
    /// Frame source range.
    #[serde(rename = "r")]
    pub range: SourceRange,
}

impl ScopeFrame {
    /// Create a new scope frame.
    pub fn new(kind: impl Into<String>, name: Option<String>, range: SourceRange) -> Self {
        Self {
            kind: kind.into(),
            name,
            range,
        }
    }

    /// Create a file-level scope frame.
    pub fn file(range: SourceRange) -> Self {
        Self::new("file", None, range)
    }

    /// Create a class/struct scope frame.
    pub fn class(name: impl Into<String>, range: SourceRange) -> Self {
        Self::new("class", Some(name.into()), range)
    }

    /// Create a method scope frame.
    pub fn method(name: impl Into<String>, range: SourceRange) -> Self {
        Self::new("method", Some(name.into()), range)
    }

    /// Create a function scope frame.
    pub fn function(name: impl Into<String>, range: SourceRange) -> Self {
        Self::new("function", Some(name.into()), range)
    }

    /// Create a block scope frame (loops, conditionals, etc.).
    pub fn block(range: SourceRange) -> Self {
        Self::new("block", None, range)
    }

    /// Check if this is a named scope (class, method, function, etc.).
    pub fn is_named(&self) -> bool {
        self.name.is_some()
    }

    /// Get the qualified name at this frame level.
    pub fn qualified_name(&self) -> Option<&str> {
        self.name.as_deref()
    }
}

/// A reference from a symbol to another entity.
///
/// Tracks imports, type usages, calls, and other references.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct SymbolReference {
    /// Reference type: "import", "type", "call", "read", "write", etc.
    #[serde(rename = "t")]
    pub ref_type: String,
    /// Target symbol/entity identifier.
    #[serde(rename = "q")]
    pub target: String,
    /// Line number where reference occurs.
    #[serde(rename = "at")]
    pub at_line: u32,
}

impl SymbolReference {
    /// Create a new symbol reference.
    pub fn new(ref_type: impl Into<String>, target: impl Into<String>, at_line: u32) -> Self {
        Self {
            ref_type: ref_type.into(),
            target: target.into(),
            at_line,
        }
    }

    /// Create an import reference.
    pub fn import(target: impl Into<String>, at_line: u32) -> Self {
        Self::new("import", target, at_line)
    }

    /// Create a type usage reference.
    pub fn type_use(target: impl Into<String>, at_line: u32) -> Self {
        Self::new("type", target, at_line)
    }

    /// Create a function/method call reference.
    pub fn call(target: impl Into<String>, at_line: u32) -> Self {
        Self::new("call", target, at_line)
    }

    /// Create a variable read reference.
    pub fn read(target: impl Into<String>, at_line: u32) -> Self {
        Self::new("read", target, at_line)
    }

    /// Create a variable write reference.
    pub fn write(target: impl Into<String>, at_line: u32) -> Self {
        Self::new("write", target, at_line)
    }
}

/// An edge from a symbol to another symbol.
///
/// Represents structural relationships like inheritance, method calls, etc.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct SymbolEdge {
    /// Edge type: "call", "inherit", "implement", "override", "uses-type", etc.
    #[serde(rename = "t")]
    pub edge_type: String,
    /// Target symbol identifier.
    #[serde(rename = "to")]
    pub target: String,
    /// Line number where edge originates.
    #[serde(rename = "at")]
    pub at_line: u32,
}

impl SymbolEdge {
    /// Create a new symbol edge.
    pub fn new(edge_type: impl Into<String>, target: impl Into<String>, at_line: u32) -> Self {
        Self {
            edge_type: edge_type.into(),
            target: target.into(),
            at_line,
        }
    }

    /// Create an inheritance edge.
    pub fn inherit(target: impl Into<String>, at_line: u32) -> Self {
        Self::new("inherit", target, at_line)
    }

    /// Create an implementation edge (interface implementation).
    pub fn implement(target: impl Into<String>, at_line: u32) -> Self {
        Self::new("implement", target, at_line)
    }

    /// Create a call edge.
    pub fn call(target: impl Into<String>, at_line: u32) -> Self {
        Self::new("call", target, at_line)
    }

    /// Create an override edge.
    pub fn override_of(target: impl Into<String>, at_line: u32) -> Self {
        Self::new("override", target, at_line)
    }

    /// Create a type usage edge.
    pub fn uses_type(target: impl Into<String>, at_line: u32) -> Self {
        Self::new("uses-type", target, at_line)
    }
}

/// Guard/effect information for a symbol.
///
/// Tracks side effects and preconditions for methods/functions.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct GuardInfo {
    /// IO effects: "network", "file", "database", "console", etc.
    #[serde(rename = "io", skip_serializing_if = "Vec::is_empty", default)]
    pub io_effects: Vec<String>,
    /// Invariants/preconditions that must hold.
    #[serde(rename = "inv", skip_serializing_if = "Vec::is_empty", default)]
    pub invariants: Vec<String>,
}

impl GuardInfo {
    /// Create a new guard info with effects and invariants.
    pub fn new(io_effects: Vec<String>, invariants: Vec<String>) -> Self {
        Self {
            io_effects,
            invariants,
        }
    }

    /// Create guard info with only IO effects.
    pub fn with_effects(effects: Vec<String>) -> Self {
        Self::new(effects, Vec::new())
    }

    /// Create guard info with only invariants.
    pub fn with_invariants(invariants: Vec<String>) -> Self {
        Self::new(Vec::new(), invariants)
    }

    /// Check if this guard has any information.
    pub fn is_empty(&self) -> bool {
        self.io_effects.is_empty() && self.invariants.is_empty()
    }

    /// Add an IO effect.
    pub fn add_effect(&mut self, effect: impl Into<String>) {
        self.io_effects.push(effect.into());
    }

    /// Add an invariant.
    pub fn add_invariant(&mut self, invariant: impl Into<String>) {
        self.invariants.push(invariant.into());
    }
}

impl Default for GuardInfo {
    fn default() -> Self {
        Self::new(Vec::new(), Vec::new())
    }
}

/// A symbol in the anchor system.
///
/// Represents a code entity with its metadata, relationships, and fingerprint.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub struct Symbol {
    /// Short symbol ID (unique within file, e.g., "C1", "M2", "F3").
    #[serde(rename = "id")]
    pub id: String,
    /// Symbol kind: "class", "struct", "method", "function", "type", "enum", etc.
    #[serde(rename = "k")]
    pub kind: String,
    /// Symbol name.
    #[serde(rename = "n")]
    pub name: String,
    /// Owner symbol ID (for methods, fields, nested types).
    #[serde(rename = "own", skip_serializing_if = "Option::is_none")]
    pub owner: Option<String>,
    /// Source range of the symbol.
    #[serde(rename = "r")]
    pub range: SourceRange,
    /// Nested scope frames from file to this symbol.
    #[serde(rename = "fr")]
    pub frames: Vec<ScopeFrame>,
    /// Role annotations (e.g., "entity", "repository", "handler").
    #[serde(rename = "roles", skip_serializing_if = "Vec::is_empty", default)]
    pub roles: Vec<String>,
    /// References to external entities (imports, type uses, etc.).
    #[serde(rename = "refs", skip_serializing_if = "Vec::is_empty", default)]
    pub references: Vec<SymbolReference>,
    /// Outgoing edges to other symbols.
    #[serde(rename = "edges", skip_serializing_if = "Vec::is_empty", default)]
    pub edges: Vec<SymbolEdge>,
    /// Content fingerprint for change detection.
    #[serde(rename = "fg")]
    pub fingerprint: String,
    /// Optional guard/effect information.
    #[serde(rename = "guard", skip_serializing_if = "Option::is_none")]
    pub guard: Option<GuardInfo>,
}

impl Symbol {
    /// Create a new symbol with minimal required fields.
    pub fn new(
        id: impl Into<String>,
        kind: impl Into<String>,
        name: impl Into<String>,
        range: SourceRange,
        fingerprint: impl Into<String>,
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
            fingerprint: fingerprint.into(),
            guard: None,
        }
    }

    /// Set the owner symbol.
    pub fn with_owner(mut self, owner: impl Into<String>) -> Self {
        self.owner = Some(owner.into());
        self
    }

    /// Add scope frames.
    pub fn with_frames(mut self, frames: Vec<ScopeFrame>) -> Self {
        self.frames = frames;
        self
    }

    /// Add roles.
    pub fn with_roles(mut self, roles: Vec<String>) -> Self {
        self.roles = roles;
        self
    }

    /// Add a role.
    pub fn add_role(&mut self, role: impl Into<String>) {
        self.roles.push(role.into());
    }

    /// Add a reference.
    pub fn add_reference(&mut self, reference: SymbolReference) {
        self.references.push(reference);
    }

    /// Add an edge.
    pub fn add_edge(&mut self, edge: SymbolEdge) {
        self.edges.push(edge);
    }

    /// Set guard info.
    pub fn with_guard(mut self, guard: GuardInfo) -> Self {
        self.guard = Some(guard);
        self
    }

    /// Get the qualified name by joining scope frame names.
    pub fn qualified_name(&self) -> String {
        self.frames
            .iter()
            .filter_map(|f| f.name.as_ref())
            .chain(std::iter::once(&self.name))
            .cloned()
            .collect::<Vec<_>>()
            .join("::")
    }

    /// Check if this symbol is a method (has an owner).
    pub fn is_method(&self) -> bool {
        self.owner.is_some()
    }

    /// Check if this symbol has a specific role.
    pub fn has_role(&self, role: &str) -> bool {
        self.roles.iter().any(|r| r == role)
    }
}

/// Cross-reference entry tracking all occurrences of an external reference.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct CrossReference {
    /// Target identifier (import path, type name, etc.).
    #[serde(rename = "q")]
    pub target: String,
    /// List of line numbers where it appears.
    #[serde(rename = "ls")]
    pub lines: Vec<u32>,
}

impl CrossReference {
    /// Create a new cross-reference.
    pub fn new(target: impl Into<String>, lines: Vec<u32>) -> Self {
        Self {
            target: target.into(),
            lines,
        }
    }

    /// Create a cross-reference with a single occurrence.
    pub fn single(target: impl Into<String>, line: u32) -> Self {
        Self::new(target, vec![line])
    }

    /// Add another occurrence line.
    pub fn add_line(&mut self, line: u32) {
        if !self.lines.contains(&line) {
            self.lines.push(line);
        }
    }

    /// Get the count of occurrences.
    pub fn count(&self) -> usize {
        self.lines.len()
    }
}

/// Fast lookup index for efficient symbol access.
///
/// Provides O(1) lookups by symbol ID and type references.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct FastIndex {
    /// Symbol ID -> line range [start, end] mapping.
    #[serde(rename = "bySym")]
    pub by_symbol: HashMap<String, [u32; 2]>,
    /// Type name -> line occurrences mapping.
    #[serde(rename = "byType")]
    pub by_type: HashMap<String, Vec<u32>>,
}

impl FastIndex {
    /// Create a new empty fast index.
    pub fn new() -> Self {
        Self {
            by_symbol: HashMap::new(),
            by_type: HashMap::new(),
        }
    }

    /// Look up a symbol's line range by ID.
    pub fn get_symbol_range(&self, id: &str) -> Option<[u32; 2]> {
        self.by_symbol.get(id).copied()
    }

    /// Look up all lines where a type is referenced.
    pub fn get_type_lines(&self, type_name: &str) -> Option<&Vec<u32>> {
        self.by_type.get(type_name)
    }

    /// Add a symbol to the index.
    pub fn add_symbol(&mut self, id: impl Into<String>, range: [u32; 2]) {
        self.by_symbol.insert(id.into(), range);
    }

    /// Add a type reference.
    pub fn add_type_reference(&mut self, type_name: impl Into<String>, line: u32) {
        self.by_type
            .entry(type_name.into())
            .or_insert_with(Vec::new)
            .push(line);
    }

    /// Get count of indexed symbols.
    pub fn symbol_count(&self) -> usize {
        self.by_symbol.len()
    }

    /// Get count of indexed types.
    pub fn type_count(&self) -> usize {
        self.by_type.len()
    }
}

impl Default for FastIndex {
    fn default() -> Self {
        Self::new()
    }
}

/// Complete anchor header containing all file analysis metadata.
///
/// This is the main data structure that gets compressed and embedded in source files.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub struct AnchorHeader {
    /// Schema version for compatibility checking.
    #[serde(rename = "v")]
    pub version: String,
    /// File identifier with hash (e.g., "src/lib.rs@a1b2c3d4").
    #[serde(rename = "fid")]
    pub file_id: String,
    /// File content fingerprint for change detection.
    #[serde(rename = "fp")]
    pub file_fingerprint: String,
    /// Programming language.
    #[serde(rename = "lang")]
    pub language: String,
    /// Optional configuration metadata.
    #[serde(rename = "cfg", skip_serializing_if = "Option::is_none")]
    pub config: Option<HashMap<String, String>>,
    /// Symbols defined in this file.
    #[serde(rename = "sym")]
    pub symbols: Vec<Symbol>,
    /// Cross-reference index by category (import, typeUse, etc.).
    #[serde(rename = "xrefs")]
    pub xrefs: HashMap<String, Vec<CrossReference>>,
    /// Fast lookup index.
    #[serde(rename = "idx")]
    pub index: FastIndex,
    /// Unix timestamp when generated.
    #[serde(rename = "ts")]
    pub timestamp: u64,
}

impl AnchorHeader {
    /// Get a symbol by ID.
    pub fn get_symbol(&self, id: &str) -> Option<&Symbol> {
        self.symbols.iter().find(|s| s.id == id)
    }

    /// Get all symbols of a given kind.
    pub fn symbols_of_kind(&self, kind: &str) -> Vec<&Symbol> {
        self.symbols.iter().filter(|s| s.kind == kind).collect()
    }

    /// Get cross-references by category.
    pub fn get_xrefs(&self, category: &str) -> Option<&Vec<CrossReference>> {
        self.xrefs.get(category)
    }

    /// Check if the header matches the current file content.
    pub fn matches_fingerprint(&self, content_hash: &str) -> bool {
        self.file_fingerprint.ends_with(content_hash)
    }

    /// Get total symbol count.
    pub fn symbol_count(&self) -> usize {
        self.symbols.len()
    }

    /// Get total reference count across all symbols.
    pub fn reference_count(&self) -> usize {
        self.symbols.iter().map(|s| s.references.len()).sum()
    }

    /// Get total edge count across all symbols.
    pub fn edge_count(&self) -> usize {
        self.symbols.iter().map(|s| s.edges.len()).sum()
    }
}

/// Lightweight inline anchor for marking individual symbols.
///
/// Embedded as a comment next to a symbol definition for quick lookups.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct InlineAnchor {
    /// Symbol ID reference.
    #[serde(rename = "a")]
    pub anchor_id: String,
    /// Short fingerprint for change detection.
    #[serde(rename = "fg")]
    pub fingerprint: String,
    /// Line range hint (e.g., "42-118").
    #[serde(rename = "r")]
    pub range: String,
}

impl InlineAnchor {
    /// Create a new inline anchor.
    pub fn new(anchor_id: impl Into<String>, fingerprint: impl Into<String>, range: impl Into<String>) -> Self {
        Self {
            anchor_id: anchor_id.into(),
            fingerprint: fingerprint.into(),
            range: range.into(),
        }
    }

    /// Create from a symbol.
    pub fn from_symbol(symbol: &Symbol) -> Self {
        Self::new(
            symbol.id.clone(),
            symbol.fingerprint.clone(),
            symbol.range.to_range_string(),
        )
    }

    /// Parse the line range.
    pub fn parse_range(&self) -> Option<(u32, u32)> {
        let parts: Vec<&str> = self.range.split('-').collect();
        if parts.len() == 2 {
            let start = parts[0].parse().ok()?;
            let end = parts[1].parse().ok()?;
            Some((start, end))
        } else {
            None
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_source_range() {
        let range = SourceRange::new(10, 50, 200, 1000);
        assert_eq!(range.start_line(), 10);
        assert_eq!(range.end_line(), 50);
        assert_eq!(range.line_count(), 41);
        assert_eq!(range.byte_len(), 800);
        assert!(range.contains_line(25));
        assert!(!range.contains_line(5));
        assert_eq!(range.to_range_string(), "10-50");
    }

    #[test]
    fn test_source_range_parse() {
        let range = SourceRange::from_range_string("10-50").unwrap();
        assert_eq!(range.start_line(), 10);
        assert_eq!(range.end_line(), 50);
    }

    #[test]
    fn test_scope_frame_constructors() {
        let file_frame = ScopeFrame::file(SourceRange::new(1, 100, 0, 5000));
        assert_eq!(file_frame.kind, "file");
        assert!(file_frame.name.is_none());

        let class_frame = ScopeFrame::class("MyClass", SourceRange::new(10, 50, 100, 2000));
        assert_eq!(class_frame.kind, "class");
        assert_eq!(class_frame.name.as_deref(), Some("MyClass"));

        let method_frame = ScopeFrame::method("doSomething", SourceRange::new(15, 25, 200, 500));
        assert!(method_frame.is_named());
    }

    #[test]
    fn test_symbol_reference_constructors() {
        let import_ref = SymbolReference::import("std::collections::HashMap", 1);
        assert_eq!(import_ref.ref_type, "import");

        let type_ref = SymbolReference::type_use("String", 10);
        assert_eq!(type_ref.ref_type, "type");

        let call_ref = SymbolReference::call("helper_function", 15);
        assert_eq!(call_ref.ref_type, "call");
    }

    #[test]
    fn test_symbol_edge_constructors() {
        let inherit = SymbolEdge::inherit("BaseClass", 10);
        assert_eq!(inherit.edge_type, "inherit");

        let impl_edge = SymbolEdge::implement("Trait", 10);
        assert_eq!(impl_edge.edge_type, "implement");
    }

    #[test]
    fn test_guard_info() {
        let mut guard = GuardInfo::default();
        assert!(guard.is_empty());

        guard.add_effect("network");
        guard.add_invariant("user != null");
        assert!(!guard.is_empty());
        assert_eq!(guard.io_effects.len(), 1);
        assert_eq!(guard.invariants.len(), 1);
    }

    #[test]
    fn test_symbol_qualified_name() {
        let symbol = Symbol::new(
            "M1",
            "method",
            "process",
            SourceRange::new(15, 25, 200, 500),
            "abc123",
        )
        .with_frames(vec![
            ScopeFrame::class("MyClass", SourceRange::new(10, 50, 100, 2000)),
        ]);

        assert_eq!(symbol.qualified_name(), "MyClass::process");
    }

    #[test]
    fn test_fast_index() {
        let mut index = FastIndex::new();
        index.add_symbol("C1", [10, 50]);
        index.add_type_reference("String", 15);
        index.add_type_reference("String", 20);

        assert_eq!(index.get_symbol_range("C1"), Some([10, 50]));
        assert_eq!(index.get_type_lines("String").map(|v| v.len()), Some(2));
        assert_eq!(index.symbol_count(), 1);
        assert_eq!(index.type_count(), 1);
    }

    #[test]
    fn test_inline_anchor_from_symbol() {
        let symbol = Symbol::new(
            "C1",
            "class",
            "TestClass",
            SourceRange::new(10, 50, 200, 1000),
            "abc123",
        );

        let anchor = InlineAnchor::from_symbol(&symbol);
        assert_eq!(anchor.anchor_id, "C1");
        assert_eq!(anchor.fingerprint, "abc123");
        assert_eq!(anchor.range, "10-50");

        let (start, end) = anchor.parse_range().unwrap();
        assert_eq!(start, 10);
        assert_eq!(end, 50);
    }
}
