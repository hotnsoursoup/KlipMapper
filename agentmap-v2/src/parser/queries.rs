//! TreeSitter query loader for language-specific symbol extraction.
//!
//! Loads `.scm` query files from the queries/ directory.

use std::collections::HashMap;
use std::path::Path;
use tree_sitter::Query;
use crate::core::{Result, Error};
use crate::parser::Language;

/// Query types for different extraction purposes.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum QueryType {
    /// Symbol definitions (functions, classes, structs)
    Definitions,
    /// Import statements
    Imports,
    /// Symbol usages (calls, field access)
    Uses,
}

impl QueryType {
    /// Get filename for this query type.
    pub fn filename(&self) -> &'static str {
        match self {
            Self::Definitions => "defs.scm",
            Self::Imports => "imports.scm",
            Self::Uses => "uses.scm",
        }
    }
}

/// Loaded query cache.
pub struct QueryLoader {
    queries: HashMap<(Language, QueryType), Query>,
}

impl QueryLoader {
    /// Create a new query loader.
    pub fn new() -> Self {
        Self {
            queries: HashMap::new(),
        }
    }

    /// Load queries from a directory.
    pub fn load_from_dir(&mut self, base_dir: &Path) -> Result<()> {
        for lang in Language::all() {
            let lang_dir = base_dir.join(lang.name().to_lowercase());

            if lang_dir.exists() {
                for query_type in [QueryType::Definitions, QueryType::Imports, QueryType::Uses] {
                    let query_file = lang_dir.join(query_type.filename());
                    if query_file.exists() {
                        self.load_query(*lang, query_type, &query_file)?;
                    }
                }
            }
        }

        Ok(())
    }

    /// Load a single query from a file.
    fn load_query(&mut self, lang: Language, query_type: QueryType, path: &Path) -> Result<()> {
        let content = std::fs::read_to_string(path)
            .map_err(|e| Error::io(path, e))?;

        let ts_language = lang.tree_sitter_language();

        let query = Query::new(&ts_language, &content)
            .map_err(|e| Error::parse(path.to_path_buf(), format!("Query parse error: {:?}", e)))?;

        self.queries.insert((lang, query_type), query);

        Ok(())
    }

    /// Load queries from embedded strings (compile-time).
    pub fn load_embedded(&mut self) {
        // Rust queries
        self.load_embedded_query(Language::Rust, QueryType::Definitions, include_str!("../../queries/rust/defs.scm"));
        self.load_embedded_query(Language::Rust, QueryType::Imports, include_str!("../../queries/rust/imports.scm"));
        self.load_embedded_query(Language::Rust, QueryType::Uses, include_str!("../../queries/rust/uses.scm"));

        // Python queries
        self.load_embedded_query(Language::Python, QueryType::Definitions, include_str!("../../queries/python/defs.scm"));
        self.load_embedded_query(Language::Python, QueryType::Imports, include_str!("../../queries/python/imports.scm"));
        self.load_embedded_query(Language::Python, QueryType::Uses, include_str!("../../queries/python/uses.scm"));

        // TypeScript queries
        self.load_embedded_query(Language::TypeScript, QueryType::Definitions, include_str!("../../queries/typescript/defs.scm"));
        self.load_embedded_query(Language::TypeScript, QueryType::Imports, include_str!("../../queries/typescript/imports.scm"));
        self.load_embedded_query(Language::TypeScript, QueryType::Uses, include_str!("../../queries/typescript/uses.scm"));

        // Dart queries
        self.load_embedded_query(Language::Dart, QueryType::Definitions, include_str!("../../queries/dart/defs.scm"));
        self.load_embedded_query(Language::Dart, QueryType::Imports, include_str!("../../queries/dart/imports.scm"));
        self.load_embedded_query(Language::Dart, QueryType::Uses, include_str!("../../queries/dart/uses.scm"));
    }

    fn load_embedded_query(&mut self, lang: Language, query_type: QueryType, content: &str) {
        let ts_lang = lang.tree_sitter_language();
        if let Ok(query) = Query::new(&ts_lang, content) {
            self.queries.insert((lang, query_type), query);
        }
    }

    /// Get a query for a language and type.
    pub fn get(&self, lang: Language, query_type: QueryType) -> Option<&Query> {
        self.queries.get(&(lang, query_type))
    }

    /// Check if queries are loaded for a language.
    pub fn has_queries(&self, lang: Language) -> bool {
        self.queries.keys().any(|(l, _)| *l == lang)
    }

    /// Get all loaded query keys.
    pub fn loaded_queries(&self) -> Vec<(Language, QueryType)> {
        self.queries.keys().cloned().collect()
    }
}

impl Default for QueryLoader {
    fn default() -> Self {
        let mut loader = Self::new();
        loader.load_embedded();
        loader
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_embedded_queries_load() {
        let loader = QueryLoader::default();

        // Should have Rust queries
        assert!(loader.has_queries(Language::Rust));
        assert!(loader.get(Language::Rust, QueryType::Definitions).is_some());
    }
}
