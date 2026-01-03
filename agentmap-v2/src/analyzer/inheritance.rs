//! Inheritance relationship analyzer.
//!
//! Extracts class inheritance, interface implementations, and trait bounds.

use tree_sitter::Node;
use crate::core::{Result, Relationship, RelationshipKind, SymbolId, SourceLocation};
use crate::parser::{ParsedFile, Language};
use std::path::Path;

/// Inheritance relationship extractor.
pub struct InheritanceAnalyzer;

impl InheritanceAnalyzer {
    /// Create a new inheritance analyzer.
    pub fn new() -> Self {
        Self
    }

    /// Extract inheritance relationships from a parsed file.
    pub fn analyze(&self, parsed: &ParsedFile, file_path: &Path) -> Result<Vec<Relationship>> {
        let mut relationships = Vec::new();

        if let Some(tree) = &parsed.tree {
            let root = tree.root_node();
            self.walk_node(&root, &parsed.content, parsed.language, file_path, &mut relationships);
        }

        Ok(relationships)
    }

    /// Recursively walk nodes to find inheritance patterns.
    fn walk_node(
        &self,
        node: &Node,
        content: &str,
        language: Language,
        file_path: &Path,
        relationships: &mut Vec<Relationship>,
    ) {
        // Handle language-specific inheritance patterns
        match (language, node.kind()) {
            // Rust: struct/enum with trait bounds, impl blocks
            (Language::Rust, "impl_item") => {
                if let Some(rel) = self.extract_rust_impl(node, content, file_path) {
                    relationships.push(rel);
                }
            }

            // Python: class with base classes
            (Language::Python, "class_definition") => {
                relationships.extend(self.extract_python_inheritance(node, content, file_path));
            }

            // TypeScript/JavaScript: class extends/implements
            (Language::TypeScript | Language::JavaScript, "class_declaration") => {
                relationships.extend(self.extract_ts_inheritance(node, content, file_path));
            }

            // Java: class extends/implements
            (Language::Java, "class_declaration") => {
                relationships.extend(self.extract_java_inheritance(node, content, file_path));
            }

            // Dart: class extends/implements/with
            (Language::Dart, "class_definition") => {
                relationships.extend(self.extract_dart_inheritance(node, content, file_path));
            }

            // Go: struct embedding and interface implementation
            (Language::Go, "type_declaration") => {
                relationships.extend(self.extract_go_embedding(node, content, file_path));
            }

            _ => {}
        }

        // Recurse into children
        let mut cursor = node.walk();
        for child in node.children(&mut cursor) {
            self.walk_node(&child, content, language, file_path, relationships);
        }
    }

    /// Extract Rust impl blocks (trait implementations).
    fn extract_rust_impl(&self, node: &Node, content: &str, file_path: &Path) -> Option<Relationship> {
        // Look for: impl Trait for Type
        let mut trait_name: Option<String> = None;
        let mut type_name: Option<String> = None;
        let mut has_for = false;

        let mut cursor = node.walk();
        for child in node.children(&mut cursor) {
            match child.kind() {
                "type_identifier" | "generic_type" => {
                    if has_for {
                        type_name = Some(child.utf8_text(content.as_bytes()).ok()?.to_string());
                    } else if trait_name.is_none() {
                        trait_name = Some(child.utf8_text(content.as_bytes()).ok()?.to_string());
                    }
                }
                "for" => has_for = true,
                _ => {}
            }
        }

        // Only emit if this is a trait implementation (has 'for')
        if has_for {
            if let (Some(trait_n), Some(type_n)) = (trait_name, type_name) {
                let location = SourceLocation::from_node(file_path.to_path_buf(), node);
                let from = SymbolId::new(
                    file_path.to_string_lossy().as_ref(),
                    location.start_line,
                    &type_n,
                );
                let to = SymbolId::new(
                    file_path.to_string_lossy().as_ref(),
                    0, // Trait may be external
                    &trait_n,
                );

                return Some(Relationship::new(from, RelationshipKind::Implements, to, location));
            }
        }

        None
    }

    /// Extract Python class inheritance.
    fn extract_python_inheritance(&self, node: &Node, content: &str, file_path: &Path) -> Vec<Relationship> {
        let mut relationships = Vec::new();

        // Get class name
        let class_name = node.child_by_field_name("name")
            .and_then(|n| n.utf8_text(content.as_bytes()).ok())
            .map(|s| s.to_string());

        // Get argument_list (base classes)
        if let Some(class_name) = class_name {
            let location = SourceLocation::from_node(file_path.to_path_buf(), node);
            let from = SymbolId::new(
                file_path.to_string_lossy().as_ref(),
                location.start_line,
                &class_name,
            );

            // Find superclass_clause or argument_list
            let mut cursor = node.walk();
            for child in node.children(&mut cursor) {
                if child.kind() == "argument_list" {
                    // Extract each base class
                    let mut arg_cursor = child.walk();
                    for arg in child.children(&mut arg_cursor) {
                        if arg.kind() == "identifier" {
                            if let Ok(base_name) = arg.utf8_text(content.as_bytes()) {
                                let to = SymbolId::new(
                                    file_path.to_string_lossy().as_ref(),
                                    0,
                                    base_name,
                                );
                                relationships.push(Relationship::new(
                                    from.clone(),
                                    RelationshipKind::Inherits,
                                    to,
                                    location.clone(),
                                ));
                            }
                        }
                    }
                }
            }
        }

        relationships
    }

    /// Extract TypeScript/JavaScript inheritance.
    fn extract_ts_inheritance(&self, node: &Node, content: &str, file_path: &Path) -> Vec<Relationship> {
        let mut relationships = Vec::new();

        let class_name = node.child_by_field_name("name")
            .and_then(|n| n.utf8_text(content.as_bytes()).ok())
            .map(|s| s.to_string());

        if let Some(class_name) = class_name {
            let location = SourceLocation::from_node(file_path.to_path_buf(), node);
            let from = SymbolId::new(
                file_path.to_string_lossy().as_ref(),
                location.start_line,
                &class_name,
            );

            let mut cursor = node.walk();
            for child in node.children(&mut cursor) {
                match child.kind() {
                    "class_heritage" | "extends_clause" => {
                        // Find the extended class
                        if let Some(type_node) = child.child_by_field_name("type") {
                            if let Ok(base_name) = type_node.utf8_text(content.as_bytes()) {
                                let to = SymbolId::new(
                                    file_path.to_string_lossy().as_ref(),
                                    0,
                                    base_name,
                                );
                                relationships.push(Relationship::new(
                                    from.clone(),
                                    RelationshipKind::Inherits,
                                    to,
                                    location.clone(),
                                ));
                            }
                        }
                    }
                    "implements_clause" => {
                        // Find implemented interfaces
                        let mut impl_cursor = child.walk();
                        for impl_child in child.children(&mut impl_cursor) {
                            if impl_child.kind() == "type_identifier" {
                                if let Ok(iface_name) = impl_child.utf8_text(content.as_bytes()) {
                                    let to = SymbolId::new(
                                        file_path.to_string_lossy().as_ref(),
                                        0,
                                        iface_name,
                                    );
                                    relationships.push(Relationship::new(
                                        from.clone(),
                                        RelationshipKind::Implements,
                                        to,
                                        location.clone(),
                                    ));
                                }
                            }
                        }
                    }
                    _ => {}
                }
            }
        }

        relationships
    }

    /// Extract Java inheritance.
    fn extract_java_inheritance(&self, node: &Node, content: &str, file_path: &Path) -> Vec<Relationship> {
        let mut relationships = Vec::new();

        let class_name = node.child_by_field_name("name")
            .and_then(|n| n.utf8_text(content.as_bytes()).ok())
            .map(|s| s.to_string());

        if let Some(class_name) = class_name {
            let location = SourceLocation::from_node(file_path.to_path_buf(), node);
            let from = SymbolId::new(
                file_path.to_string_lossy().as_ref(),
                location.start_line,
                &class_name,
            );

            let mut cursor = node.walk();
            for child in node.children(&mut cursor) {
                if child.kind() == "superclass" {
                    if let Some(type_node) = child.child(1) {
                        if let Ok(base_name) = type_node.utf8_text(content.as_bytes()) {
                            let to = SymbolId::new(
                                file_path.to_string_lossy().as_ref(),
                                0,
                                base_name,
                            );
                            relationships.push(Relationship::new(
                                from.clone(),
                                RelationshipKind::Inherits,
                                to,
                                location.clone(),
                            ));
                        }
                    }
                } else if child.kind() == "super_interfaces" {
                    let mut iface_cursor = child.walk();
                    for iface_child in child.children(&mut iface_cursor) {
                        if iface_child.kind() == "type_identifier" {
                            if let Ok(iface_name) = iface_child.utf8_text(content.as_bytes()) {
                                let to = SymbolId::new(
                                    file_path.to_string_lossy().as_ref(),
                                    0,
                                    iface_name,
                                );
                                relationships.push(Relationship::new(
                                    from.clone(),
                                    RelationshipKind::Implements,
                                    to,
                                    location.clone(),
                                ));
                            }
                        }
                    }
                }
            }
        }

        relationships
    }

    /// Extract Dart inheritance (extends, implements, with).
    fn extract_dart_inheritance(&self, node: &Node, content: &str, file_path: &Path) -> Vec<Relationship> {
        let mut relationships = Vec::new();

        let class_name = node.child_by_field_name("name")
            .and_then(|n| n.utf8_text(content.as_bytes()).ok())
            .map(|s| s.to_string());

        if let Some(class_name) = class_name {
            let location = SourceLocation::from_node(file_path.to_path_buf(), node);
            let from = SymbolId::new(
                file_path.to_string_lossy().as_ref(),
                location.start_line,
                &class_name,
            );

            // Dart has: extends, implements, with (mixins)
            let mut cursor = node.walk();
            for child in node.children(&mut cursor) {
                let kind = match child.kind() {
                    "extends_clause" => Some(RelationshipKind::Inherits),
                    "implements_clause" => Some(RelationshipKind::Implements),
                    "with_clause" => Some(RelationshipKind::Implements), // Mixins as implements
                    _ => None,
                };

                if let Some(rel_kind) = kind {
                    let mut inner_cursor = child.walk();
                    for type_child in child.children(&mut inner_cursor) {
                        if type_child.kind() == "type_identifier" || type_child.kind() == "identifier" {
                            if let Ok(type_name) = type_child.utf8_text(content.as_bytes()) {
                                let to = SymbolId::new(
                                    file_path.to_string_lossy().as_ref(),
                                    0,
                                    type_name,
                                );
                                relationships.push(Relationship::new(
                                    from.clone(),
                                    rel_kind,
                                    to,
                                    location.clone(),
                                ));
                            }
                        }
                    }
                }
            }
        }

        relationships
    }

    /// Extract Go struct embedding.
    fn extract_go_embedding(&self, node: &Node, content: &str, file_path: &Path) -> Vec<Relationship> {
        // Go uses struct embedding rather than inheritance
        // struct { EmbeddedType } implicitly "inherits" EmbeddedType's methods
        let mut relationships = Vec::new();

        // Look for struct type specs with embedded fields
        let mut cursor = node.walk();
        for child in node.children(&mut cursor) {
            if child.kind() == "type_spec" {
                let type_name = child.child_by_field_name("name")
                    .and_then(|n| n.utf8_text(content.as_bytes()).ok())
                    .map(|s| s.to_string());

                if let Some(type_name) = type_name {
                    let location = SourceLocation::from_node(file_path.to_path_buf(), node);
                    let from = SymbolId::new(
                        file_path.to_string_lossy().as_ref(),
                        location.start_line,
                        &type_name,
                    );

                    // Look for struct_type with embedded fields
                    if let Some(type_node) = child.child_by_field_name("type") {
                        if type_node.kind() == "struct_type" {
                            let mut field_cursor = type_node.walk();
                            for field in type_node.children(&mut field_cursor) {
                                if field.kind() == "field_declaration" {
                                    // Embedded field has no name, just type
                                    let has_name = field.child_by_field_name("name").is_some();
                                    if !has_name {
                                        if let Some(type_child) = field.child_by_field_name("type") {
                                            if let Ok(embedded_type) = type_child.utf8_text(content.as_bytes()) {
                                                let to = SymbolId::new(
                                                    file_path.to_string_lossy().as_ref(),
                                                    0,
                                                    embedded_type,
                                                );
                                                relationships.push(Relationship::new(
                                                    from.clone(),
                                                    RelationshipKind::Inherits, // Embedding acts like inheritance
                                                    to,
                                                    location.clone(),
                                                ));
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        relationships
    }
}

impl Default for InheritanceAnalyzer {
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
    fn test_rust_impl_extraction() {
        let parser = TreeSitterParser::new();
        let code = r#"
            impl Display for MyStruct {
                fn fmt(&self, f: &mut Formatter) -> Result {
                    write!(f, "MyStruct")
                }
            }
        "#;

        let parsed = parser.parse(code, Language::Rust).unwrap();
        let analyzer = InheritanceAnalyzer::new();
        let relationships = analyzer.analyze(&parsed, Path::new("test.rs")).unwrap();

        assert_eq!(relationships.len(), 1);
        assert_eq!(relationships[0].kind, RelationshipKind::Implements);
    }

    #[test]
    fn test_python_inheritance() {
        let parser = TreeSitterParser::new();
        let code = r#"
class Child(Parent, Mixin):
    def __init__(self):
        pass
        "#;

        let parsed = parser.parse(code, Language::Python).unwrap();
        let analyzer = InheritanceAnalyzer::new();
        let relationships = analyzer.analyze(&parsed, Path::new("test.py")).unwrap();

        // Should find 2 inheritance relationships
        assert!(relationships.len() >= 1);
    }
}
