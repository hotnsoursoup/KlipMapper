//! Symbol table for global symbol lookup.

use std::collections::HashMap;
use std::path::{Path, PathBuf};
use std::sync::Arc;
use parking_lot::RwLock;
use crate::core::{Symbol, SymbolId, CodeAnalysis};

/// Global symbol table built from all analyses.
///
/// Provides multiple lookup strategies for symbol resolution.
pub struct SymbolTable {
    /// Fully qualified name -> SymbolId
    by_fqn: RwLock<HashMap<String, SymbolId>>,

    /// Short name -> Vec<SymbolId> (for ambiguous lookups)
    by_name: RwLock<HashMap<String, Vec<SymbolId>>>,

    /// File path -> symbols defined in that file
    by_file: RwLock<HashMap<PathBuf, Vec<SymbolId>>>,

    /// SymbolId -> full Symbol data
    symbols: RwLock<HashMap<SymbolId, Arc<Symbol>>>,
}

impl SymbolTable {
    /// Create an empty symbol table.
    pub fn new() -> Self {
        Self {
            by_fqn: RwLock::new(HashMap::new()),
            by_name: RwLock::new(HashMap::new()),
            by_file: RwLock::new(HashMap::new()),
            symbols: RwLock::new(HashMap::new()),
        }
    }

    /// Build symbol table from a collection of analyses.
    pub fn from_analyses(analyses: &[CodeAnalysis]) -> Self {
        let table = Self::new();
        for analysis in analyses {
            table.add_analysis(analysis);
        }
        table
    }

    /// Add symbols from a single analysis.
    pub fn add_analysis(&self, analysis: &CodeAnalysis) {
        for symbol in &analysis.symbols {
            self.add_symbol(symbol.clone());
        }
    }

    /// Add a single symbol to the table.
    pub fn add_symbol(&self, symbol: Symbol) {
        let id = symbol.id.clone();
        let name = symbol.name.clone();
        let file = symbol.location.file_path.clone();
        let fqn = symbol.fully_qualified_name();

        // Store symbol data
        self.symbols.write().insert(id.clone(), Arc::new(symbol));

        // Index by FQN
        self.by_fqn.write().insert(fqn, id.clone());

        // Index by short name
        self.by_name.write()
            .entry(name)
            .or_insert_with(Vec::new)
            .push(id.clone());

        // Index by file
        self.by_file.write()
            .entry(file)
            .or_insert_with(Vec::new)
            .push(id);
    }

    /// Lookup by exact fully qualified name.
    pub fn lookup_fqn(&self, fqn: &str) -> Option<SymbolId> {
        self.by_fqn.read().get(fqn).cloned()
    }

    /// Lookup by short name (may return multiple matches).
    pub fn lookup_name(&self, name: &str) -> Vec<SymbolId> {
        self.by_name.read()
            .get(name)
            .cloned()
            .unwrap_or_default()
    }

    /// Get all symbols defined in a file.
    pub fn symbols_in_file(&self, path: &Path) -> Vec<SymbolId> {
        self.by_file.read()
            .get(path)
            .cloned()
            .unwrap_or_default()
    }

    /// Get symbol data by ID.
    pub fn get(&self, id: &SymbolId) -> Option<Arc<Symbol>> {
        self.symbols.read().get(id).cloned()
    }

    /// Get total number of symbols.
    pub fn len(&self) -> usize {
        self.symbols.read().len()
    }

    /// Check if table is empty.
    pub fn is_empty(&self) -> bool {
        self.symbols.read().is_empty()
    }

    /// Clear the table.
    pub fn clear(&self) {
        self.by_fqn.write().clear();
        self.by_name.write().clear();
        self.by_file.write().clear();
        self.symbols.write().clear();
    }
}

impl Default for SymbolTable {
    fn default() -> Self {
        Self::new()
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::core::{SymbolKind, SourceLocation, Visibility};

    #[test]
    fn test_symbol_table_lookup() {
        let table = SymbolTable::new();

        let symbol = Symbol::new(
            "MyClass",
            SymbolKind::Class,
            SourceLocation::new(PathBuf::from("src/lib.rs"), 1, 10),
        ).with_visibility(Visibility::Public);

        table.add_symbol(symbol);

        // Lookup by name
        let matches = table.lookup_name("MyClass");
        assert_eq!(matches.len(), 1);

        // Get symbol data
        let sym = table.get(&matches[0]).unwrap();
        assert_eq!(sym.name, "MyClass");
    }
}
