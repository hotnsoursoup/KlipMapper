//! Analysis result types.

use std::path::PathBuf;
use std::collections::HashMap;
use serde::{Deserialize, Serialize};
use super::{Symbol, Relationship, SourceLocation};
use crate::parser::Language;

/// Complete analysis result for a file.
///
/// This is the main output type of AgentMap, containing all symbols,
/// relationships, and metadata needed for RAG indexing.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CodeAnalysis {
    /// Path to the analyzed file.
    pub file_path: PathBuf,

    /// Detected language.
    pub language: Language,

    /// All extracted symbols.
    pub symbols: Vec<Symbol>,

    /// All detected relationships.
    pub relationships: Vec<Relationship>,

    /// Import statements.
    pub imports: Vec<Import>,

    /// Analysis metadata.
    pub metadata: AnalysisMetadata,
}

impl CodeAnalysis {
    /// Create a new analysis result.
    pub fn new(file_path: PathBuf, language: Language) -> Self {
        Self {
            file_path,
            language,
            symbols: Vec::new(),
            relationships: Vec::new(),
            imports: Vec::new(),
            metadata: AnalysisMetadata::default(),
        }
    }

    /// Add a symbol.
    pub fn add_symbol(&mut self, symbol: Symbol) {
        self.symbols.push(symbol);
    }

    /// Add a relationship.
    pub fn add_relationship(&mut self, relationship: Relationship) {
        self.relationships.push(relationship);
    }

    /// Add an import.
    pub fn add_import(&mut self, import: Import) {
        self.imports.push(import);
    }

    /// Get symbols by kind.
    pub fn symbols_of_kind(&self, kind: super::SymbolKind) -> Vec<&Symbol> {
        self.symbols.iter().filter(|s| s.kind == kind).collect()
    }

    /// Get public symbols only.
    pub fn public_symbols(&self) -> Vec<&Symbol> {
        self.symbols.iter().filter(|s| s.is_public()).collect()
    }

    /// Get relationships from a symbol.
    pub fn relationships_from(&self, symbol_id: &super::SymbolId) -> Vec<&Relationship> {
        self.relationships.iter().filter(|r| &r.from == symbol_id).collect()
    }

    /// Get relationships to a symbol.
    pub fn relationships_to(&self, symbol_id: &super::SymbolId) -> Vec<&Relationship> {
        self.relationships.iter().filter(|r| &r.to == symbol_id).collect()
    }
}

/// A single imported name with optional alias.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub struct ImportedName {
    /// The original name being imported.
    pub name: String,

    /// Local alias (if renamed, e.g., `Foo as Bar`).
    pub alias: Option<String>,
}

impl ImportedName {
    /// Create a new imported name without alias.
    pub fn new(name: impl Into<String>) -> Self {
        Self {
            name: name.into(),
            alias: None,
        }
    }

    /// Create a new imported name with alias.
    pub fn with_alias(name: impl Into<String>, alias: impl Into<String>) -> Self {
        Self {
            name: name.into(),
            alias: Some(alias.into()),
        }
    }

    /// Get the local name (alias if present, otherwise original name).
    pub fn local_name(&self) -> &str {
        self.alias.as_deref().unwrap_or(&self.name)
    }
}

/// An import statement in the source file.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub struct Import {
    /// The import path/module name.
    pub source: String,

    /// Imported names with their optional aliases.
    pub imported_names: Vec<ImportedName>,

    /// Module-level alias (e.g., `import * as utils` or `import 'pkg' as p`).
    pub module_alias: Option<String>,

    /// Whether this is a wildcard import.
    pub is_wildcard: bool,

    /// Location in source.
    pub location: SourceLocation,
}

impl Import {
    /// Create a new import.
    pub fn new(source: impl Into<String>, location: SourceLocation) -> Self {
        Self {
            source: source.into(),
            imported_names: Vec::new(),
            module_alias: None,
            is_wildcard: false,
            location,
        }
    }

    /// Add an imported name without alias.
    pub fn add_name(mut self, name: impl Into<String>) -> Self {
        self.imported_names.push(ImportedName::new(name));
        self
    }

    /// Add an imported name with alias.
    pub fn add_aliased_name(mut self, name: impl Into<String>, alias: impl Into<String>) -> Self {
        self.imported_names.push(ImportedName::with_alias(name, alias));
        self
    }

    /// Set specific imported names (for backward compatibility).
    pub fn with_names(mut self, names: Vec<String>) -> Self {
        self.imported_names = names.into_iter().map(ImportedName::new).collect();
        self
    }

    /// Set imported names with aliases.
    pub fn with_imported_names(mut self, names: Vec<ImportedName>) -> Self {
        self.imported_names = names;
        self
    }

    /// Set module-level alias (e.g., `import * as utils`).
    pub fn with_module_alias(mut self, alias: impl Into<String>) -> Self {
        self.module_alias = Some(alias.into());
        self
    }

    /// Backward compatible: Set alias (now sets module_alias).
    pub fn with_alias(mut self, alias: impl Into<String>) -> Self {
        self.module_alias = Some(alias.into());
        self
    }

    /// Mark as wildcard import.
    pub fn as_wildcard(mut self) -> Self {
        self.is_wildcard = true;
        self
    }

    /// Build an import map (local_name -> fully_qualified) for resolution.
    ///
    /// This is used to populate ResolutionContext.imports.
    pub fn to_import_map(&self) -> std::collections::HashMap<String, String> {
        let mut map = std::collections::HashMap::new();

        // If there's a module alias, map it to the source
        if let Some(alias) = &self.module_alias {
            map.insert(alias.clone(), self.source.clone());
        }

        // Map each imported name (using local name) to fully qualified path
        for imported in &self.imported_names {
            let local = imported.local_name().to_string();
            let fqn = format!("{}::{}", self.source, imported.name);
            map.insert(local, fqn);
        }

        map
    }
}

/// Metadata about the analysis.
#[derive(Debug, Clone, Default, Serialize, Deserialize)]
pub struct AnalysisMetadata {
    /// Total lines of code.
    pub line_count: u32,

    /// Time taken to analyze (milliseconds).
    pub analysis_time_ms: u64,

    /// Content hash for caching.
    pub content_hash: String,

    /// Additional key-value metadata.
    pub properties: HashMap<String, String>,
}

impl AnalysisMetadata {
    /// Set line count.
    pub fn with_lines(mut self, count: u32) -> Self {
        self.line_count = count;
        self
    }

    /// Set analysis time.
    pub fn with_time(mut self, ms: u64) -> Self {
        self.analysis_time_ms = ms;
        self
    }

    /// Set content hash.
    pub fn with_hash(mut self, hash: impl Into<String>) -> Self {
        self.content_hash = hash.into();
        self
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_code_analysis_creation() {
        let analysis = CodeAnalysis::new(
            PathBuf::from("src/main.rs"),
            Language::Rust,
        );

        assert!(analysis.symbols.is_empty());
        assert!(analysis.relationships.is_empty());
    }
}
