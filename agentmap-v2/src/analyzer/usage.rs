//! Usage analyzer.
//!
//! Tracks symbol references and usage patterns.

use tree_sitter::Node;
use crate::core::{Result, Relationship, RelationshipKind, SymbolId, SourceLocation, Symbol};
use crate::parser::{ParsedFile, Language};
use std::path::Path;
use std::collections::HashSet;

/// Usage relationship extractor.
///
/// Detects:
/// - Variable references
/// - Type references
/// - Field access
pub struct UsageAnalyzer;

impl UsageAnalyzer {
    /// Create a new usage analyzer.
    pub fn new() -> Self {
        Self
    }

    /// Extract usage relationships from a parsed file.
    pub fn analyze(&self, parsed: &ParsedFile, file_path: &Path) -> Result<Vec<Relationship>> {
        let mut relationships = Vec::new();

        // Build a set of defined symbol names in this file for reference checking
        let defined_symbols: HashSet<String> = parsed.symbols
            .iter()
            .map(|s| s.name.clone())
            .collect();

        if let Some(tree) = &parsed.tree {
            let root = tree.root_node();
            self.walk_node(
                &root,
                &parsed.content,
                parsed.language,
                file_path,
                &defined_symbols,
                &parsed.symbols,
                &mut relationships,
                None
            );
        }

        Ok(relationships)
    }

    /// Recursively walk nodes to find usage patterns.
    fn walk_node(
        &self,
        node: &Node,
        content: &str,
        language: Language,
        file_path: &Path,
        defined_symbols: &HashSet<String>,
        symbols: &[Symbol],
        relationships: &mut Vec<Relationship>,
        current_function: Option<&str>,
    ) {
        // Track function context
        let new_function = self.get_function_name(node, content, language);
        let func_context = new_function.as_deref().or(current_function);

        // Check for type references
        if let Some(rel) = self.extract_type_reference(node, content, language, file_path, defined_symbols, func_context) {
            relationships.push(rel);
        }

        // Check for field access
        if let Some(rel) = self.extract_field_access(node, content, language, file_path, func_context) {
            relationships.push(rel);
        }

        // Recurse into children
        let mut cursor = node.walk();
        for child in node.children(&mut cursor) {
            self.walk_node(&child, content, language, file_path, defined_symbols, symbols, relationships, func_context);
        }
    }

    /// Get function name if this node defines a function.
    fn get_function_name(&self, node: &Node, content: &str, language: Language) -> Option<String> {
        let is_function = match (language, node.kind()) {
            (Language::Rust, "function_item") => true,
            (Language::Python, "function_definition") => true,
            (Language::TypeScript | Language::JavaScript, "function_declaration" | "method_definition") => true,
            (Language::Java, "method_declaration") => true,
            (Language::Go, "function_declaration" | "method_declaration") => true,
            (Language::Dart, "function_signature") => true,
            _ => false,
        };

        if is_function {
            node.child_by_field_name("name")
                .and_then(|n| n.utf8_text(content.as_bytes()).ok())
                .map(|s| s.to_string())
        } else {
            None
        }
    }

    /// Extract type reference relationships.
    fn extract_type_reference(
        &self,
        node: &Node,
        content: &str,
        language: Language,
        file_path: &Path,
        defined_symbols: &HashSet<String>,
        current_function: Option<&str>,
    ) -> Option<Relationship> {
        let is_type_ref = match (language, node.kind()) {
            // Rust
            (Language::Rust, "type_identifier") => true,

            // Python (type annotations)
            (Language::Python, "type") => true,

            // TypeScript
            (Language::TypeScript, "type_identifier" | "predefined_type") => true,

            // Java
            (Language::Java, "type_identifier") => true,

            // Go
            (Language::Go, "type_identifier") => true,

            // Dart
            (Language::Dart, "type_identifier") => true,

            _ => false,
        };

        if !is_type_ref {
            return None;
        }

        let type_name = node.utf8_text(content.as_bytes()).ok()?;

        // Skip primitive types
        if self.is_primitive_type(type_name, language) {
            return None;
        }

        // Only track references to types defined in this file or likely custom types
        // (starts with uppercase, not a common stdlib type)
        if !self.is_likely_custom_type(type_name) && !defined_symbols.contains(type_name) {
            return None;
        }

        let location = SourceLocation::from_node(file_path.to_path_buf(), node);

        let from = if let Some(func) = current_function {
            SymbolId::new(file_path.to_string_lossy().as_ref(), 0, func)
        } else {
            SymbolId::new(file_path.to_string_lossy().as_ref(), 0, "__file__")
        };

        let to = SymbolId::new("", 0, type_name);

        Some(Relationship::new(from, RelationshipKind::References, to, location))
    }

    /// Extract field access relationships.
    fn extract_field_access(
        &self,
        node: &Node,
        content: &str,
        language: Language,
        file_path: &Path,
        current_function: Option<&str>,
    ) -> Option<Relationship> {
        let is_field_access = match (language, node.kind()) {
            (Language::Rust, "field_expression") => true,
            (Language::Python, "attribute") => true,
            (Language::TypeScript | Language::JavaScript, "member_expression") => true,
            (Language::Java, "field_access") => true,
            (Language::Go, "selector_expression") => true,
            (Language::Dart, "property_access") => true,
            _ => false,
        };

        if !is_field_access {
            return None;
        }

        // Get the field/property name
        let field_name = match language {
            Language::Rust => node.child_by_field_name("field"),
            Language::Python => node.child_by_field_name("attribute"),
            Language::TypeScript | Language::JavaScript => node.child_by_field_name("property"),
            Language::Java => node.child_by_field_name("field"),
            Language::Go => node.child_by_field_name("field"),
            Language::Dart => node.child_by_field_name("name"),
        }.and_then(|n| n.utf8_text(content.as_bytes()).ok())?;

        // Get the object being accessed
        let object_name = match language {
            Language::Rust => node.child_by_field_name("value"),
            Language::Python => node.child_by_field_name("object").or_else(|| node.child(0)),
            Language::TypeScript | Language::JavaScript | Language::Java | Language::Go => node.child_by_field_name("object"),
            Language::Dart => node.child(0),
        }.and_then(|n| n.utf8_text(content.as_bytes()).ok())?;

        // Skip 'self' and 'this' references
        if matches!(object_name, "self" | "this" | "super") {
            return None;
        }

        let location = SourceLocation::from_node(file_path.to_path_buf(), node);

        let from = if let Some(func) = current_function {
            SymbolId::new(file_path.to_string_lossy().as_ref(), 0, func)
        } else {
            SymbolId::new(file_path.to_string_lossy().as_ref(), 0, "__file__")
        };

        // Record access as "uses" the field
        let to = SymbolId::new("", 0, &format!("{}.{}", object_name, field_name));

        Some(Relationship::new(from, RelationshipKind::Uses, to, location))
    }

    /// Check if a type name is a primitive type.
    fn is_primitive_type(&self, name: &str, language: Language) -> bool {
        match language {
            Language::Rust => matches!(name, "i8" | "i16" | "i32" | "i64" | "i128" | "isize" | "u8" | "u16" | "u32" | "u64" | "u128" | "usize" | "f32" | "f64" | "bool" | "char" | "str" | "String"),
            Language::Python => matches!(name, "int" | "float" | "str" | "bool" | "bytes" | "None" | "Any"),
            Language::TypeScript | Language::JavaScript => matches!(name, "number" | "string" | "boolean" | "void" | "null" | "undefined" | "any" | "never" | "unknown" | "object"),
            Language::Java => matches!(name, "int" | "long" | "short" | "byte" | "float" | "double" | "boolean" | "char" | "void" | "String" | "Object"),
            Language::Go => matches!(name, "int" | "int8" | "int16" | "int32" | "int64" | "uint" | "uint8" | "uint16" | "uint32" | "uint64" | "float32" | "float64" | "bool" | "string" | "byte" | "rune" | "error"),
            Language::Dart => matches!(name, "int" | "double" | "bool" | "String" | "void" | "dynamic" | "Object" | "Null"),
        }
    }

    /// Check if a type name is likely a custom type (not stdlib).
    fn is_likely_custom_type(&self, name: &str) -> bool {
        // Custom types typically start with uppercase and aren't common stdlib names
        let first_char = name.chars().next();
        first_char.map(|c| c.is_uppercase()).unwrap_or(false)
            && name.len() > 1
            && !matches!(name, "String" | "Object" | "Array" | "Map" | "Set" | "List" | "Int" | "Double" | "Boolean")
    }
}

impl Default for UsageAnalyzer {
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
    fn test_rust_type_references() {
        let parser = TreeSitterParser::new();
        let code = r#"
struct MyStruct {
    field: i32,
}

fn process(data: MyStruct) -> Result<MyStruct, Error> {
    todo!()
}
        "#;

        let parsed = parser.parse(code, Language::Rust).unwrap();
        let analyzer = UsageAnalyzer::new();
        let relationships = analyzer.analyze(&parsed, Path::new("test.rs")).unwrap();

        // Should find references to MyStruct
        let type_refs: Vec<_> = relationships.iter()
            .filter(|r| r.kind == RelationshipKind::References)
            .collect();
        assert!(!type_refs.is_empty());
    }

    #[test]
    fn test_python_attribute_access() {
        let parser = TreeSitterParser::new();
        let code = r#"
class Person:
    def __init__(self, name):
        self.name = name

def greet(person):
    return person.name
        "#;

        let parsed = parser.parse(code, Language::Python).unwrap();
        let analyzer = UsageAnalyzer::new();
        let relationships = analyzer.analyze(&parsed, Path::new("test.py")).unwrap();

        // Should find field access to person.name
        let uses: Vec<_> = relationships.iter()
            .filter(|r| r.kind == RelationshipKind::Uses)
            .collect();
        assert!(!uses.is_empty());
    }
}
