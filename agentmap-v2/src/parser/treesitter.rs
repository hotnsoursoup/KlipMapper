//! TreeSitter-based parser implementation.

use std::path::PathBuf;
use tree_sitter::{Parser as TsParser, Tree, QueryCursor};
use crate::core::{Error, Result, Symbol, SymbolKind, SourceLocation, Visibility};
use super::{Language, ParsedFile, Parser, QueryLoader, QueryType};

/// TreeSitter-based parser with query support.
pub struct TreeSitterParser {
    parsers: parking_lot::RwLock<std::collections::HashMap<Language, TsParser>>,
    queries: QueryLoader,
}

impl TreeSitterParser {
    /// Create a new TreeSitter parser.
    pub fn new() -> Self {
        Self {
            parsers: parking_lot::RwLock::new(std::collections::HashMap::new()),
            queries: QueryLoader::default(),
        }
    }

    /// Create with custom query loader.
    pub fn with_queries(queries: QueryLoader) -> Self {
        Self {
            parsers: parking_lot::RwLock::new(std::collections::HashMap::new()),
            queries,
        }
    }

    /// Get or create a parser for a language.
    fn get_parser(&self, language: Language) -> Result<()> {
        let mut parsers = self.parsers.write();
        if let std::collections::hash_map::Entry::Vacant(e) = parsers.entry(language) {
            let mut parser = TsParser::new();
            parser.set_language(&language.tree_sitter_language())
                .map_err(|e| Error::query(format!("Failed to set language: {e}")))?;
            e.insert(parser);
        }
        Ok(())
    }

    /// Extract symbols from a TreeSitter tree using queries (preferred).
    fn extract_symbols_with_queries(
        &self,
        tree: &Tree,
        content: &str,
        language: Language,
        file_path: &std::path::Path,
    ) -> Vec<Symbol> {
        let mut symbols = Vec::new();

        // Try query-based extraction first
        if let Some(query) = self.queries.get(language, QueryType::Definitions) {
            let mut cursor = QueryCursor::new();
            let matches = cursor.matches(query, tree.root_node(), content.as_bytes());

            for match_ in matches {
                for capture in match_.captures {
                    let node = capture.node;
                    let capture_name = &query.capture_names()[capture.index as usize];

                    // Map capture names to symbol kinds
                    if let Some(kind) = self.capture_to_kind(capture_name) {
                        if let Some(name) = node.utf8_text(content.as_bytes()).ok() {
                            // Get the parent node for full context
                            let context_node = node.parent().unwrap_or(node);
                            let location = SourceLocation::from_node(file_path.to_path_buf(), &context_node);
                            let code_content = context_node.utf8_text(content.as_bytes())
                                .unwrap_or("")
                                .to_string();

                            let symbol = Symbol::new(name.to_string(), kind, location)
                                .with_code(code_content);
                            symbols.push(symbol);
                        }
                    }
                }
            }
        }

        // If no symbols found via queries, fall back to manual walking
        if symbols.is_empty() {
            let root = tree.root_node();
            self.walk_node(&root, content, language, file_path, &mut symbols);
        }

        symbols
    }

    /// Map query capture names to symbol kinds.
    fn capture_to_kind(&self, capture_name: &str) -> Option<SymbolKind> {
        match capture_name {
            "def.fn" | "func_name" => Some(SymbolKind::Function),
            "def.struct" | "struct_name" => Some(SymbolKind::Struct),
            "def.enum" | "enum_name" => Some(SymbolKind::Enum),
            "def.trait" | "trait_name" => Some(SymbolKind::Trait),
            "def.module" | "module_name" => Some(SymbolKind::Module),
            "def.const" => Some(SymbolKind::Constant),
            "def.static" => Some(SymbolKind::Constant),
            "def.type_alias" => Some(SymbolKind::TypeAlias),
            "def.macro" => Some(SymbolKind::Macro),
            "class_name" => Some(SymbolKind::Class),
            "def.impl_type" => None, // Skip impl types for now
            _ => None,
        }
    }

    /// Extract symbols using manual AST walking (fallback).
    /// Reserved for future use when query-based extraction isn't available.
    #[allow(dead_code)]
    fn extract_symbols(
        &self,
        tree: &Tree,
        content: &str,
        language: Language,
        file_path: &std::path::Path,
    ) -> Vec<Symbol> {
        let mut symbols = Vec::new();
        let root = tree.root_node();
        self.walk_node(&root, content, language, file_path, &mut symbols);
        symbols
    }

    /// Recursively walk AST nodes.
    fn walk_node(
        &self,
        node: &tree_sitter::Node,
        content: &str,
        language: Language,
        file_path: &std::path::Path,
        symbols: &mut Vec<Symbol>,
    ) {
        // Check if this node is a symbol we care about
        if let Some(symbol) = self.node_to_symbol(node, content, language, file_path) {
            symbols.push(symbol);
        }

        // Recurse into children
        let mut cursor = node.walk();
        for child in node.children(&mut cursor) {
            self.walk_node(&child, content, language, file_path, symbols);
        }
    }

    /// Convert a TreeSitter node to a Symbol (if applicable).
    fn node_to_symbol(
        &self,
        node: &tree_sitter::Node,
        content: &str,
        language: Language,
        file_path: &std::path::Path,
    ) -> Option<Symbol> {
        let kind = match (language, node.kind()) {
            // Rust
            (Language::Rust, "function_item") => Some(SymbolKind::Function),
            (Language::Rust, "struct_item") => Some(SymbolKind::Struct),
            (Language::Rust, "enum_item") => Some(SymbolKind::Enum),
            (Language::Rust, "trait_item") => Some(SymbolKind::Trait),
            (Language::Rust, "impl_item") => None, // Skip impl blocks for now
            (Language::Rust, "mod_item") => Some(SymbolKind::Module),
            (Language::Rust, "const_item") => Some(SymbolKind::Constant),
            (Language::Rust, "static_item") => Some(SymbolKind::Constant),
            (Language::Rust, "type_item") => Some(SymbolKind::TypeAlias),

            // Python
            (Language::Python, "function_definition") => Some(SymbolKind::Function),
            (Language::Python, "class_definition") => Some(SymbolKind::Class),
            (Language::Python, "async_function_definition") => Some(SymbolKind::AsyncFunction),

            // TypeScript/JavaScript
            (Language::TypeScript | Language::JavaScript, "function_declaration") => Some(SymbolKind::Function),
            (Language::TypeScript | Language::JavaScript, "class_declaration") => Some(SymbolKind::Class),
            (Language::TypeScript | Language::JavaScript, "interface_declaration") => Some(SymbolKind::Interface),
            (Language::TypeScript | Language::JavaScript, "type_alias_declaration") => Some(SymbolKind::TypeAlias),
            (Language::TypeScript | Language::JavaScript, "enum_declaration") => Some(SymbolKind::Enum),

            // Go
            (Language::Go, "function_declaration") => Some(SymbolKind::Function),
            (Language::Go, "method_declaration") => Some(SymbolKind::Method),
            (Language::Go, "type_declaration") => Some(SymbolKind::Struct), // Simplified

            // Java
            (Language::Java, "class_declaration") => Some(SymbolKind::Class),
            (Language::Java, "interface_declaration") => Some(SymbolKind::Interface),
            (Language::Java, "method_declaration") => Some(SymbolKind::Method),
            (Language::Java, "enum_declaration") => Some(SymbolKind::Enum),

            // Dart
            (Language::Dart, "class_definition") => Some(SymbolKind::Class),
            (Language::Dart, "function_signature") => Some(SymbolKind::Function),
            (Language::Dart, "method_signature") => Some(SymbolKind::Method),

            _ => None,
        }?;

        // Get the name of the symbol
        let name = self.get_symbol_name(node, content, language)?;

        // Get the source location
        let location = SourceLocation::from_node(file_path.to_path_buf(), node);

        // Get the code content
        let code_content = node.utf8_text(content.as_bytes()).ok()?.to_string();

        // Determine visibility
        let visibility = self.get_visibility(node, content, language);

        let symbol = Symbol::new(name, kind, location)
            .with_code(code_content)
            .with_visibility(visibility);

        Some(symbol)
    }

    /// Get the name of a symbol from its node.
    fn get_symbol_name(&self, node: &tree_sitter::Node, content: &str, language: Language) -> Option<String> {
        // Find the name child based on language
        let name_field = match language {
            Language::Rust | Language::Python | Language::Go | Language::Java | Language::Dart => "name",
            Language::TypeScript | Language::JavaScript => "name",
        };

        let name_node = node.child_by_field_name(name_field)?;
        name_node.utf8_text(content.as_bytes()).ok().map(|s| s.to_string())
    }

    /// Determine visibility of a symbol.
    fn get_visibility(&self, node: &tree_sitter::Node, content: &str, language: Language) -> Visibility {
        match language {
            Language::Rust => {
                // Check for pub keyword
                let mut cursor = node.walk();
                for child in node.children(&mut cursor) {
                    if child.kind() == "visibility_modifier" {
                        if let Ok(text) = child.utf8_text(content.as_bytes()) {
                            if text.starts_with("pub") {
                                return Visibility::Public;
                            }
                        }
                    }
                }
                Visibility::Private
            }
            Language::Python => {
                // Python uses naming conventions
                if let Some(name) = self.get_symbol_name(node, content, language) {
                    if name.starts_with("__") && !name.ends_with("__") {
                        return Visibility::Private;
                    } else if name.starts_with('_') {
                        return Visibility::Protected;
                    }
                }
                Visibility::Public
            }
            Language::TypeScript | Language::JavaScript => {
                // Check for export keyword (simplified)
                if let Some(parent) = node.parent() {
                    if parent.kind() == "export_statement" {
                        return Visibility::Public;
                    }
                }
                Visibility::Private
            }
            Language::Java => {
                // Check for access modifiers
                let mut cursor = node.walk();
                for child in node.children(&mut cursor) {
                    if child.kind() == "modifiers" {
                        if let Ok(text) = child.utf8_text(content.as_bytes()) {
                            if text.contains("public") {
                                return Visibility::Public;
                            } else if text.contains("private") {
                                return Visibility::Private;
                            } else if text.contains("protected") {
                                return Visibility::Protected;
                            }
                        }
                    }
                }
                Visibility::Internal
            }
            _ => Visibility::Unspecified,
        }
    }

    /// Get a reference to the query loader.
    pub fn queries(&self) -> &QueryLoader {
        &self.queries
    }
}

impl Default for TreeSitterParser {
    fn default() -> Self {
        Self::new()
    }
}

impl Parser for TreeSitterParser {
    fn parse(&self, content: &str, language: Language) -> Result<ParsedFile> {
        self.get_parser(language)?;

        let mut parsers = self.parsers.write();
        let parser = parsers.get_mut(&language)
            .ok_or_else(|| Error::query("Parser not initialized"))?;

        let tree = parser.parse(content, None)
            .ok_or_else(|| Error::parse(PathBuf::new(), "TreeSitter parse failed"))?;

        // Use query-based extraction (with manual fallback)
        let symbols = self.extract_symbols_with_queries(&tree, content, language, &PathBuf::new());

        let mut parsed = ParsedFile::new(PathBuf::new(), language, content.to_string());
        parsed.tree = Some(tree);
        parsed.symbols = symbols;

        Ok(parsed)
    }

    fn supported_languages(&self) -> &[Language] {
        Language::all()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_parse_rust() {
        let parser = TreeSitterParser::new();
        let code = r#"
            pub fn hello() {
                println!("Hello, world!");
            }

            struct MyStruct {
                field: i32,
            }
        "#;

        let result = parser.parse(code, Language::Rust).unwrap();
        assert!(!result.symbols.is_empty());

        let fn_symbol = result.symbols.iter().find(|s| s.name == "hello");
        assert!(fn_symbol.is_some());
        assert_eq!(fn_symbol.unwrap().kind, SymbolKind::Function);
    }

    #[test]
    fn test_parse_python() {
        let parser = TreeSitterParser::new();
        let code = r#"
def greet(name):
    print(f"Hello, {name}!")

class Person:
    def __init__(self, name):
        self.name = name
        "#;

        let result = parser.parse(code, Language::Python).unwrap();
        assert!(!result.symbols.is_empty());
    }

    #[test]
    fn test_query_loader_integration() {
        let parser = TreeSitterParser::new();

        // Verify queries are loaded
        assert!(parser.queries().has_queries(Language::Rust));
        assert!(parser.queries().has_queries(Language::Python));
    }
}
