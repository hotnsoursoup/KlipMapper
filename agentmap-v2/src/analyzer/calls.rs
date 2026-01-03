//! Call graph analyzer.
//!
//! Extracts function/method call relationships.

use tree_sitter::Node;
use crate::core::{Result, Relationship, RelationshipKind, SymbolId, SourceLocation};
use crate::parser::{ParsedFile, Language};
use std::path::Path;

/// Call relationship extractor.
///
/// Detects:
/// - Function calls
/// - Method calls
/// - Constructor invocations
pub struct CallAnalyzer;

impl CallAnalyzer {
    /// Create a new call analyzer.
    pub fn new() -> Self {
        Self
    }

    /// Extract call relationships from a parsed file.
    pub fn analyze(&self, parsed: &ParsedFile, file_path: &Path) -> Result<Vec<Relationship>> {
        let mut relationships = Vec::new();

        if let Some(tree) = &parsed.tree {
            let root = tree.root_node();
            // Track current function context for "from" side of calls
            self.walk_node(&root, &parsed.content, parsed.language, file_path, &mut relationships, None);
        }

        Ok(relationships)
    }

    /// Recursively walk nodes to find call expressions.
    fn walk_node(
        &self,
        node: &Node,
        content: &str,
        language: Language,
        file_path: &Path,
        relationships: &mut Vec<Relationship>,
        current_function: Option<&str>,
    ) {
        // Track function context
        let new_function = self.get_function_name(node, content, language);
        let func_context = new_function.as_deref().or(current_function);

        // Handle call expressions
        if let Some(rel) = self.extract_call(node, content, language, file_path, func_context) {
            relationships.push(rel);
        }

        // Recurse into children
        let mut cursor = node.walk();
        for child in node.children(&mut cursor) {
            self.walk_node(&child, content, language, file_path, relationships, func_context);
        }
    }

    /// Get function name if this node defines a function.
    fn get_function_name(&self, node: &Node, content: &str, language: Language) -> Option<String> {
        let is_function = match (language, node.kind()) {
            (Language::Rust, "function_item" | "impl_item") => true,
            (Language::Python, "function_definition" | "async_function_definition") => true,
            (Language::TypeScript | Language::JavaScript, "function_declaration" | "method_definition" | "arrow_function") => true,
            (Language::Java, "method_declaration" | "constructor_declaration") => true,
            (Language::Go, "function_declaration" | "method_declaration") => true,
            (Language::Dart, "function_signature" | "method_signature") => true,
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

    /// Extract a call relationship from a call expression.
    fn extract_call(
        &self,
        node: &Node,
        content: &str,
        language: Language,
        file_path: &Path,
        current_function: Option<&str>,
    ) -> Option<Relationship> {
        let is_call = match (language, node.kind()) {
            // Rust
            (Language::Rust, "call_expression" | "macro_invocation") => true,

            // Python
            (Language::Python, "call") => true,

            // TypeScript/JavaScript
            (Language::TypeScript | Language::JavaScript, "call_expression" | "new_expression") => true,

            // Java
            (Language::Java, "method_invocation" | "object_creation_expression") => true,

            // Go
            (Language::Go, "call_expression") => true,

            // Dart
            (Language::Dart, "invocation_expression" | "constructor_invocation") => true,

            _ => false,
        };

        if !is_call {
            return None;
        }

        // Get the called function name
        let callee = self.get_callee_name(node, content, language)?;

        // Skip common built-ins that add noise
        if self.is_builtin(&callee, language) {
            return None;
        }

        let location = SourceLocation::from_node(file_path.to_path_buf(), node);

        // Create from symbol (current function or __file__)
        let from = if let Some(func) = current_function {
            SymbolId::new(file_path.to_string_lossy().as_ref(), 0, func)
        } else {
            SymbolId::new(file_path.to_string_lossy().as_ref(), 0, "__file__")
        };

        let to = SymbolId::new("", 0, &callee);

        Some(Relationship::new(from, RelationshipKind::Calls, to, location))
    }

    /// Extract the callee name from a call expression.
    fn get_callee_name(&self, node: &Node, content: &str, language: Language) -> Option<String> {
        match language {
            Language::Rust => {
                // call_expression has function field
                node.child_by_field_name("function")
                    .or_else(|| node.child(0))
                    .and_then(|n| {
                        // Handle method calls (a.b())
                        if n.kind() == "field_expression" {
                            n.child_by_field_name("field")
                        } else {
                            Some(n)
                        }
                    })
                    .and_then(|n| n.utf8_text(content.as_bytes()).ok())
                    .map(|s| s.to_string())
            }
            Language::Python => {
                node.child_by_field_name("function")
                    .and_then(|n| {
                        // Handle method calls (obj.method)
                        if n.kind() == "attribute" {
                            n.child_by_field_name("attribute")
                        } else {
                            Some(n)
                        }
                    })
                    .and_then(|n| n.utf8_text(content.as_bytes()).ok())
                    .map(|s| s.to_string())
            }
            Language::TypeScript | Language::JavaScript => {
                node.child_by_field_name("function")
                    .or_else(|| node.child(0))
                    .and_then(|n| {
                        // Handle member expressions (obj.method)
                        if n.kind() == "member_expression" {
                            n.child_by_field_name("property")
                        } else {
                            Some(n)
                        }
                    })
                    .and_then(|n| n.utf8_text(content.as_bytes()).ok())
                    .map(|s| s.to_string())
            }
            Language::Java => {
                // method_invocation: object.method(args)
                node.child_by_field_name("name")
                    .or_else(|| node.child_by_field_name("type"))
                    .and_then(|n| n.utf8_text(content.as_bytes()).ok())
                    .map(|s| s.to_string())
            }
            Language::Go => {
                node.child_by_field_name("function")
                    .and_then(|n| {
                        if n.kind() == "selector_expression" {
                            n.child_by_field_name("field")
                        } else {
                            Some(n)
                        }
                    })
                    .and_then(|n| n.utf8_text(content.as_bytes()).ok())
                    .map(|s| s.to_string())
            }
            Language::Dart => {
                node.child(0)
                    .and_then(|n| {
                        if n.kind() == "assignable_selector_part" || n.kind() == "selector" {
                            n.child_by_field_name("name")
                        } else {
                            Some(n)
                        }
                    })
                    .and_then(|n| n.utf8_text(content.as_bytes()).ok())
                    .map(|s| s.to_string())
            }
        }
    }

    /// Check if a function name is a common built-in to skip.
    fn is_builtin(&self, name: &str, language: Language) -> bool {
        match language {
            Language::Python => matches!(name, "print" | "len" | "str" | "int" | "float" | "list" | "dict" | "set" | "range" | "enumerate" | "zip" | "type" | "isinstance" | "getattr" | "setattr" | "hasattr"),
            Language::JavaScript | Language::TypeScript => matches!(name, "console" | "log" | "parseInt" | "parseFloat" | "String" | "Number" | "Boolean" | "Array" | "Object" | "JSON" | "Math" | "Date" | "Promise" | "setTimeout" | "setInterval"),
            Language::Rust => matches!(name, "println" | "print" | "format" | "vec" | "Some" | "None" | "Ok" | "Err" | "Box" | "Arc" | "Rc" | "clone" | "unwrap"),
            Language::Java => matches!(name, "println" | "print" | "toString" | "equals" | "hashCode" | "getClass"),
            Language::Go => matches!(name, "println" | "print" | "printf" | "sprintf" | "len" | "cap" | "make" | "new" | "append" | "copy" | "delete" | "panic" | "recover"),
            Language::Dart => matches!(name, "print" | "debugPrint" | "toString"),
        }
    }
}

impl Default for CallAnalyzer {
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
    fn test_rust_calls() {
        let parser = TreeSitterParser::new();
        let code = r#"
fn main() {
    let result = process_data();
    handle_result(result);
}

fn process_data() -> i32 {
    calculate_value()
}
        "#;

        let parsed = parser.parse(code, Language::Rust).unwrap();
        let analyzer = CallAnalyzer::new();
        let relationships = analyzer.analyze(&parsed, Path::new("test.rs")).unwrap();

        // Should find calls to process_data, handle_result, calculate_value
        assert!(!relationships.is_empty());
        assert!(relationships.iter().any(|r| r.to.0.contains("process_data")));
    }

    #[test]
    fn test_python_calls() {
        let parser = TreeSitterParser::new();
        let code = r#"
def main():
    data = fetch_data()
    result = process(data)
    save_result(result)

def fetch_data():
    return get_from_api()
        "#;

        let parsed = parser.parse(code, Language::Python).unwrap();
        let analyzer = CallAnalyzer::new();
        let relationships = analyzer.analyze(&parsed, Path::new("test.py")).unwrap();

        assert!(!relationships.is_empty());
    }

    #[test]
    fn test_js_calls() {
        let parser = TreeSitterParser::new();
        let code = r#"
function main() {
    const data = fetchData();
    const result = processData(data);
    return saveResult(result);
}
        "#;

        let parsed = parser.parse(code, Language::JavaScript).unwrap();
        let analyzer = CallAnalyzer::new();
        let relationships = analyzer.analyze(&parsed, Path::new("test.js")).unwrap();

        assert!(!relationships.is_empty());
    }
}
