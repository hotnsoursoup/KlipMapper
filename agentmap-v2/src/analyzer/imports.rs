//! Import relationship analyzer.
//!
//! Extracts import statements and module dependencies.

use tree_sitter::Node;
use crate::core::{Result, Relationship, RelationshipKind, SymbolId, SourceLocation, Import, ImportedName};
use crate::parser::{ParsedFile, Language};
use std::path::Path;
use std::collections::HashMap;

/// Import relationship extractor.
pub struct ImportAnalyzer;

impl ImportAnalyzer {
    /// Create a new import analyzer.
    pub fn new() -> Self {
        Self
    }

    /// Extract import relationships from a parsed file.
    pub fn analyze(&self, parsed: &ParsedFile, file_path: &Path) -> Result<(Vec<Import>, Vec<Relationship>)> {
        let mut imports = Vec::new();
        let mut relationships = Vec::new();

        if let Some(tree) = &parsed.tree {
            let root = tree.root_node();
            self.walk_node(&root, &parsed.content, parsed.language, file_path, &mut imports, &mut relationships);
        }

        Ok((imports, relationships))
    }

    /// Extract a complete import map for symbol resolution.
    ///
    /// Returns a HashMap mapping local names (aliases or original names)
    /// to their fully qualified paths. This is used to populate
    /// `ResolutionContext.imports` for symbol resolution.
    pub fn extract_import_map(&self, parsed: &ParsedFile, file_path: &Path) -> Result<HashMap<String, String>> {
        let (imports, _) = self.analyze(parsed, file_path)?;

        let mut map = HashMap::new();
        for import in imports {
            map.extend(import.to_import_map());
        }

        Ok(map)
    }

    /// Recursively walk nodes to find import patterns.
    fn walk_node(
        &self,
        node: &Node,
        content: &str,
        language: Language,
        file_path: &Path,
        imports: &mut Vec<Import>,
        relationships: &mut Vec<Relationship>,
    ) {
        // Handle language-specific import patterns
        let extracted = match (language, node.kind()) {
            // Rust: use statements
            (Language::Rust, "use_declaration") => {
                self.extract_rust_use(node, content, file_path)
            }

            // Python: import/from statements
            (Language::Python, "import_statement" | "import_from_statement") => {
                self.extract_python_import(node, content, file_path)
            }

            // TypeScript/JavaScript: import/export statements
            (Language::TypeScript | Language::JavaScript, "import_statement") => {
                self.extract_js_import(node, content, file_path)
            }
            (Language::TypeScript | Language::JavaScript, "export_statement") => {
                self.extract_js_export(node, content, file_path)
            }

            // Java: import statements
            (Language::Java, "import_declaration") => {
                self.extract_java_import(node, content, file_path)
            }

            // Dart: import/export/part statements
            (Language::Dart, "import_or_export") => {
                self.extract_dart_import(node, content, file_path)
            }

            // Go: import statements
            (Language::Go, "import_declaration" | "import_spec") => {
                self.extract_go_import(node, content, file_path)
            }

            _ => None,
        };

        if let Some((import, relationship)) = extracted {
            imports.push(import);
            if let Some(rel) = relationship {
                relationships.push(rel);
            }
        }

        // Recurse into children
        let mut cursor = node.walk();
        for child in node.children(&mut cursor) {
            self.walk_node(&child, content, language, file_path, imports, relationships);
        }
    }

    /// Extract Rust use statements.
    fn extract_rust_use(&self, node: &Node, content: &str, file_path: &Path) -> Option<(Import, Option<Relationship>)> {
        let location = SourceLocation::from_node(file_path.to_path_buf(), node);

        // Find the use_tree
        let use_tree = node.child_by_field_name("argument")
            .or_else(|| {
                let mut cursor = node.walk();
                for child in node.children(&mut cursor) {
                    if matches!(child.kind(), "use_tree" | "scoped_use_list" | "scoped_identifier" | "identifier") {
                        return Some(child);
                    }
                }
                None
            })?;

        let (source, imported_names) = self.parse_rust_use_tree(&use_tree, content, "")?;

        let import = Import::new(&source, location.clone())
            .with_imported_names(imported_names);

        // Create import relationship
        let from = SymbolId::new(
            file_path.to_string_lossy().as_ref(),
            0,
            "__file__",
        );
        let to = SymbolId::new("", 0, &source);
        let relationship = Relationship::new(from, RelationshipKind::Imports, to, location);

        Some((import, Some(relationship)))
    }

    /// Parse a Rust use tree recursively.
    ///
    /// Handles patterns like:
    /// - `use foo::Bar;`
    /// - `use foo::Bar as Baz;`
    /// - `use foo::{Bar, Qux as Q};`
    /// - `use foo::*;`
    fn parse_rust_use_tree(&self, node: &Node, content: &str, prefix: &str) -> Option<(String, Vec<ImportedName>)> {
        let mut imported_names = Vec::new();
        let full_path;

        match node.kind() {
            "identifier" => {
                let name = node.utf8_text(content.as_bytes()).ok()?.to_string();
                full_path = if prefix.is_empty() {
                    name.clone()
                } else {
                    format!("{}::{}", prefix, name)
                };
                imported_names.push(ImportedName::new(name));
            }
            "scoped_identifier" => {
                // path::to::Name
                full_path = node.utf8_text(content.as_bytes()).ok()?.to_string();
                // Extract the last component as the imported name
                if let Some(last) = full_path.rsplit("::").next() {
                    imported_names.push(ImportedName::new(last.to_string()));
                }
            }
            "use_as_clause" => {
                // Name as Alias
                let path_node = node.child_by_field_name("path")?;
                let alias_node = node.child_by_field_name("alias")?;

                let path = path_node.utf8_text(content.as_bytes()).ok()?.to_string();
                let alias = alias_node.utf8_text(content.as_bytes()).ok()?.to_string();

                full_path = if prefix.is_empty() {
                    path.clone()
                } else {
                    format!("{}::{}", prefix, path)
                };

                // Get the original name (last component of path)
                let original_name = path.rsplit("::").next().unwrap_or(&path).to_string();
                imported_names.push(ImportedName::with_alias(original_name, alias));
            }
            "use_wildcard" => {
                // *
                full_path = if prefix.is_empty() {
                    "*".to_string()
                } else {
                    format!("{}::*", prefix)
                };
                // Wildcard doesn't produce a specific imported name
            }
            "use_list" => {
                // {A, B, C as D}
                full_path = prefix.to_string();
                let mut cursor = node.walk();
                for child in node.children(&mut cursor) {
                    if let Some((_, names)) = self.parse_rust_use_tree(&child, content, prefix) {
                        imported_names.extend(names);
                    }
                }
            }
            "scoped_use_list" => {
                // path::{A, B}
                let path_node = node.child_by_field_name("path")?;
                let list_node = node.child_by_field_name("list")?;

                let base_path = path_node.utf8_text(content.as_bytes()).ok()?.to_string();
                let new_prefix = if prefix.is_empty() {
                    base_path.clone()
                } else {
                    format!("{}::{}", prefix, base_path)
                };

                full_path = new_prefix.clone();

                if let Some((_, names)) = self.parse_rust_use_tree(&list_node, content, &new_prefix) {
                    imported_names.extend(names);
                }
            }
            "use_tree" => {
                // Wrapper - recurse into child
                let mut cursor = node.walk();
                for child in node.children(&mut cursor) {
                    if let Some((path, names)) = self.parse_rust_use_tree(&child, content, prefix) {
                        return Some((path, names));
                    }
                }
                return None;
            }
            _ => {
                // Try to get text content as fallback
                full_path = node.utf8_text(content.as_bytes()).ok()?.to_string();
                if let Some(last) = full_path.rsplit("::").next() {
                    imported_names.push(ImportedName::new(last.to_string()));
                }
            }
        }

        Some((full_path, imported_names))
    }

    /// Extract Python import statements.
    fn extract_python_import(&self, node: &Node, content: &str, file_path: &Path) -> Option<(Import, Option<Relationship>)> {
        let location = SourceLocation::from_node(file_path.to_path_buf(), node);

        let _is_from = node.kind() == "import_from_statement";
        let mut source = String::new();
        let mut imported_names: Vec<ImportedName> = Vec::new();
        let mut module_alias: Option<String> = None;
        let mut is_wildcard = false;

        let mut cursor = node.walk();
        for child in node.children(&mut cursor) {
            match child.kind() {
                "dotted_name" if source.is_empty() => {
                    source = child.utf8_text(content.as_bytes()).ok()?.to_string();
                }
                "module_name" => {
                    source = child.utf8_text(content.as_bytes()).ok()?.to_string();
                }
                "aliased_import" => {
                    // Handle `import foo as bar` or `from mod import Foo as Bar`
                    let name = child.child_by_field_name("name")
                        .and_then(|n| n.utf8_text(content.as_bytes()).ok())
                        .map(|s| s.to_string());
                    let alias = child.child_by_field_name("alias")
                        .and_then(|n| n.utf8_text(content.as_bytes()).ok())
                        .map(|s| s.to_string());

                    if let Some(n) = name {
                        if source.is_empty() {
                            // `import foo as bar` - this is a module alias
                            source = n;
                            module_alias = alias;
                        } else if let Some(a) = alias {
                            // `from mod import Foo as Bar` - this is a name alias
                            imported_names.push(ImportedName::with_alias(n, a));
                        } else {
                            imported_names.push(ImportedName::new(n));
                        }
                    }
                }
                "import_from_names" | "wildcard_import" => {
                    if child.kind() == "wildcard_import" {
                        is_wildcard = true;
                    } else {
                        let mut inner_cursor = child.walk();
                        for import_child in child.children(&mut inner_cursor) {
                            match import_child.kind() {
                                "identifier" => {
                                    // Use if-let to avoid early return on parse failure
                                    if let Ok(text) = import_child.utf8_text(content.as_bytes()) {
                                        imported_names.push(ImportedName::new(text.to_string()));
                                    }
                                }
                                "aliased_import" => {
                                    let name = import_child.child_by_field_name("name")
                                        .and_then(|n| n.utf8_text(content.as_bytes()).ok())
                                        .map(|s| s.to_string());
                                    let alias = import_child.child_by_field_name("alias")
                                        .and_then(|n| n.utf8_text(content.as_bytes()).ok())
                                        .map(|s| s.to_string());

                                    if let Some(n) = name {
                                        if let Some(a) = alias {
                                            imported_names.push(ImportedName::with_alias(n, a));
                                        } else {
                                            imported_names.push(ImportedName::new(n));
                                        }
                                    }
                                }
                                _ => {}
                            }
                        }
                    }
                }
                _ => {}
            }
        }

        if source.is_empty() && !imported_names.is_empty() {
            // For plain `import foo, bar` statements in Python, each name is a module.
            // Use the first name as the source module. Note: this loses info about
            // subsequent modules in multi-import statements - a proper fix would
            // return Vec<Import> but that requires larger refactoring.
            // TODO: Refactor to support multiple imports per statement
            source = imported_names[0].name.clone();
        }

        let mut import = Import::new(&source, location.clone())
            .with_imported_names(imported_names);

        if let Some(a) = module_alias {
            import = import.with_module_alias(a);
        }
        if is_wildcard {
            import = import.as_wildcard();
        }

        // Create import relationship
        let from = SymbolId::new(
            file_path.to_string_lossy().as_ref(),
            0,
            "__file__",
        );
        let to = SymbolId::new("", 0, &source);
        let relationship = Relationship::new(from, RelationshipKind::Imports, to, location);

        Some((import, Some(relationship)))
    }

    /// Extract JavaScript/TypeScript import statements.
    fn extract_js_import(&self, node: &Node, content: &str, file_path: &Path) -> Option<(Import, Option<Relationship>)> {
        let location = SourceLocation::from_node(file_path.to_path_buf(), node);

        let mut source = String::new();
        let mut imported_names: Vec<ImportedName> = Vec::new();
        let mut module_alias: Option<String> = None;
        let mut is_wildcard = false;

        let mut cursor = node.walk();
        for child in node.children(&mut cursor) {
            match child.kind() {
                "string" | "string_literal" => {
                    let text = child.utf8_text(content.as_bytes()).ok()?;
                    // Remove quotes
                    source = text.trim_matches(|c| c == '"' || c == '\'').to_string();
                }
                "import_clause" => {
                    let mut inner_cursor = child.walk();
                    for import_child in child.children(&mut inner_cursor) {
                        match import_child.kind() {
                            "identifier" => {
                                // Default import: `import React from 'react'`
                                let name = import_child.utf8_text(content.as_bytes()).ok()?.to_string();
                                imported_names.push(ImportedName::with_alias("default", name));
                            }
                            "namespace_import" => {
                                // `import * as utils from './utils'`
                                is_wildcard = true;
                                // Find the alias identifier
                                let mut ns_cursor = import_child.walk();
                                for ns_child in import_child.children(&mut ns_cursor) {
                                    if ns_child.kind() == "identifier" {
                                        module_alias = Some(ns_child.utf8_text(content.as_bytes()).ok()?.to_string());
                                    }
                                }
                            }
                            "named_imports" => {
                                // `import { Foo, Bar as Baz } from 'mod'`
                                let mut named_cursor = import_child.walk();
                                for named_child in import_child.children(&mut named_cursor) {
                                    if named_child.kind() == "import_specifier" {
                                        let name = named_child.child_by_field_name("name")
                                            .and_then(|n| n.utf8_text(content.as_bytes()).ok())
                                            .map(|s| s.to_string());
                                        let alias = named_child.child_by_field_name("alias")
                                            .and_then(|n| n.utf8_text(content.as_bytes()).ok())
                                            .map(|s| s.to_string());

                                        if let Some(n) = name {
                                            if let Some(a) = alias {
                                                imported_names.push(ImportedName::with_alias(n, a));
                                            } else {
                                                imported_names.push(ImportedName::new(n));
                                            }
                                        }
                                    }
                                }
                            }
                            _ => {}
                        }
                    }
                }
                _ => {}
            }
        }

        if source.is_empty() {
            return None;
        }

        let mut import = Import::new(&source, location.clone())
            .with_imported_names(imported_names);

        if let Some(a) = module_alias {
            import = import.with_module_alias(a);
        }
        if is_wildcard {
            import = import.as_wildcard();
        }

        // Create import relationship
        let from = SymbolId::new(
            file_path.to_string_lossy().as_ref(),
            0,
            "__file__",
        );
        let to = SymbolId::new("", 0, &source);
        let relationship = Relationship::new(from, RelationshipKind::Imports, to, location);

        Some((import, Some(relationship)))
    }

    /// Extract JavaScript/TypeScript export statements.
    fn extract_js_export(&self, node: &Node, content: &str, file_path: &Path) -> Option<(Import, Option<Relationship>)> {
        let location = SourceLocation::from_node(file_path.to_path_buf(), node);

        // Check if this is a re-export (export ... from '...')
        let mut source: Option<String> = None;
        let mut cursor = node.walk();
        for child in node.children(&mut cursor) {
            if matches!(child.kind(), "string" | "string_literal") {
                let text = child.utf8_text(content.as_bytes()).ok()?;
                source = Some(text.trim_matches(|c| c == '"' || c == '\'').to_string());
            }
        }

        // Only create import if this is a re-export
        if let Some(src) = source {
            let import = Import::new(&src, location.clone());

            let from = SymbolId::new(
                file_path.to_string_lossy().as_ref(),
                0,
                "__file__",
            );
            let to = SymbolId::new("", 0, &src);
            let relationship = Relationship::new(from, RelationshipKind::ReExports, to, location);

            return Some((import, Some(relationship)));
        }

        None
    }

    /// Extract Java import statements.
    fn extract_java_import(&self, node: &Node, content: &str, file_path: &Path) -> Option<(Import, Option<Relationship>)> {
        let location = SourceLocation::from_node(file_path.to_path_buf(), node);

        // Get the import path
        let mut cursor = node.walk();
        let mut source = String::new();
        let mut is_wildcard = false;

        for child in node.children(&mut cursor) {
            match child.kind() {
                "scoped_identifier" | "identifier" => {
                    source = child.utf8_text(content.as_bytes()).ok()?.to_string();
                }
                "asterisk" => {
                    is_wildcard = true;
                }
                _ => {}
            }
        }

        if source.is_empty() {
            return None;
        }

        let mut import = Import::new(&source, location.clone());
        if is_wildcard {
            import = import.as_wildcard();
        }

        let from = SymbolId::new(
            file_path.to_string_lossy().as_ref(),
            0,
            "__file__",
        );
        let to = SymbolId::new("", 0, &source);
        let relationship = Relationship::new(from, RelationshipKind::Imports, to, location);

        Some((import, Some(relationship)))
    }

    /// Extract Dart import statements.
    fn extract_dart_import(&self, node: &Node, content: &str, file_path: &Path) -> Option<(Import, Option<Relationship>)> {
        let location = SourceLocation::from_node(file_path.to_path_buf(), node);

        let mut source = String::new();
        let mut alias: Option<String> = None;

        let mut cursor = node.walk();
        for child in node.children(&mut cursor) {
            match child.kind() {
                "string_literal" | "string" => {
                    let text = child.utf8_text(content.as_bytes()).ok()?;
                    source = text.trim_matches(|c| c == '"' || c == '\'').to_string();
                }
                "as" => {
                    // Next identifier is the alias
                }
                "identifier" if alias.is_none() && !source.is_empty() => {
                    alias = Some(child.utf8_text(content.as_bytes()).ok()?.to_string());
                }
                _ => {}
            }
        }

        if source.is_empty() {
            return None;
        }

        let mut import = Import::new(&source, location.clone());
        if let Some(a) = alias {
            import = import.with_alias(a);
        }

        let from = SymbolId::new(
            file_path.to_string_lossy().as_ref(),
            0,
            "__file__",
        );
        let to = SymbolId::new("", 0, &source);
        let relationship = Relationship::new(from, RelationshipKind::Imports, to, location);

        Some((import, Some(relationship)))
    }

    /// Extract Go import statements.
    fn extract_go_import(&self, node: &Node, content: &str, file_path: &Path) -> Option<(Import, Option<Relationship>)> {
        let location = SourceLocation::from_node(file_path.to_path_buf(), node);

        let mut source = String::new();
        let mut alias: Option<String> = None;

        // Handle import_spec for individual imports
        if node.kind() == "import_spec" {
            let mut cursor = node.walk();
            for child in node.children(&mut cursor) {
                match child.kind() {
                    "interpreted_string_literal" => {
                        let text = child.utf8_text(content.as_bytes()).ok()?;
                        source = text.trim_matches('"').to_string();
                    }
                    "package_identifier" | "blank_identifier" | "dot" => {
                        alias = Some(child.utf8_text(content.as_bytes()).ok()?.to_string());
                    }
                    _ => {}
                }
            }
        } else {
            // Handle import_declaration with import_spec_list
            let mut cursor = node.walk();
            for child in node.children(&mut cursor) {
                if child.kind() == "import_spec_list" {
                    // This will be handled by recursion into import_spec
                    return None;
                }
                if child.kind() == "import_spec" {
                    return self.extract_go_import(&child, content, file_path);
                }
                if child.kind() == "interpreted_string_literal" {
                    let text = child.utf8_text(content.as_bytes()).ok()?;
                    source = text.trim_matches('"').to_string();
                }
            }
        }

        if source.is_empty() {
            return None;
        }

        let mut import = Import::new(&source, location.clone());
        if let Some(a) = alias {
            import = import.with_alias(a);
        }

        let from = SymbolId::new(
            file_path.to_string_lossy().as_ref(),
            0,
            "__file__",
        );
        let to = SymbolId::new("", 0, &source);
        let relationship = Relationship::new(from, RelationshipKind::Imports, to, location);

        Some((import, Some(relationship)))
    }
}

impl Default for ImportAnalyzer {
    fn default() -> Self {
        Self::new()
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::parser::TreeSitterParser;
    use crate::parser::Parser;

    #[test]
    fn test_python_import() {
        let parser = TreeSitterParser::new();
        let code = r#"
import os
from pathlib import Path
from typing import Optional, List
        "#;

        let parsed = parser.parse(code, Language::Python).unwrap();
        let analyzer = ImportAnalyzer::new();
        let (imports, relationships) = analyzer.analyze(&parsed, Path::new("test.py")).unwrap();

        assert!(!imports.is_empty());
        assert!(!relationships.is_empty());
    }

    #[test]
    fn test_python_import_alias() {
        let parser = TreeSitterParser::new();
        let code = r#"
from typing import Optional as Opt, List as L
import numpy as np
        "#;

        let parsed = parser.parse(code, Language::Python).unwrap();
        let analyzer = ImportAnalyzer::new();
        let import_map = analyzer.extract_import_map(&parsed, Path::new("test.py")).unwrap();

        // Check that aliases are correctly mapped
        assert!(import_map.contains_key("np"), "Should have 'np' alias for numpy");
    }

    #[test]
    fn test_js_import() {
        let parser = TreeSitterParser::new();
        let code = r#"
import React from 'react';
import { useState, useEffect } from 'react';
import * as utils from './utils';
        "#;

        let parsed = parser.parse(code, Language::JavaScript).unwrap();
        let analyzer = ImportAnalyzer::new();
        let (imports, _) = analyzer.analyze(&parsed, Path::new("test.js")).unwrap();

        assert!(!imports.is_empty());
    }

    #[test]
    fn test_js_import_alias() {
        let parser = TreeSitterParser::new();
        let code = r#"
import { Foo as Bar, Baz } from 'mod';
import * as helpers from './helpers';
        "#;

        let parsed = parser.parse(code, Language::JavaScript).unwrap();
        let analyzer = ImportAnalyzer::new();
        let import_map = analyzer.extract_import_map(&parsed, Path::new("test.js")).unwrap();

        // Check that 'Bar' maps to 'mod::Foo' (alias for Foo)
        assert!(import_map.contains_key("Bar"), "Should have 'Bar' alias");
        if let Some(fqn) = import_map.get("Bar") {
            assert!(fqn.contains("Foo"), "Bar should map to Foo: got {}", fqn);
        }

        // Check that 'Baz' maps to 'mod::Baz' (no alias)
        assert!(import_map.contains_key("Baz"), "Should have 'Baz'");

        // Check wildcard alias
        assert!(import_map.contains_key("helpers"), "Should have 'helpers' namespace alias");
    }

    #[test]
    fn test_import_to_map() {
        use crate::core::SourceLocation;
        use std::path::PathBuf;

        let location = SourceLocation::new(PathBuf::from("test.ts"), 1, 1);

        // Test module alias
        let import = Import::new("react", location.clone())
            .with_module_alias("R");
        let map = import.to_import_map();
        assert_eq!(map.get("R"), Some(&"react".to_string()));

        // Test imported names with alias
        let import = Import::new("mod", location.clone())
            .add_aliased_name("Foo", "Bar")
            .add_name("Baz");
        let map = import.to_import_map();
        assert_eq!(map.get("Bar"), Some(&"mod::Foo".to_string()));
        assert_eq!(map.get("Baz"), Some(&"mod::Baz".to_string()));
    }
}
