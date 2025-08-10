use agentmap::adapters::{Adapter, Analysis, FileCtx};
use agentmap::adapters::ts_adapter::TsAdapter;
use agentmap::sidecar::{Symbol, Region, Import};
use std::path::Path;

#[test]
fn test_typescript_adapter_creation() {
    let lang = tree_sitter_typescript::language_typescript();
    let query = include_str!("../../queries/typescript.scm");
    let adapter = TsAdapter::new(lang, &[".ts", ".tsx"], query);
    
    assert_eq!(adapter.name(), "treesitter");
}

#[test]
fn test_typescript_supports_extensions() {
    let lang = tree_sitter_typescript::language_typescript();
    let query = include_str!("../../queries/typescript.scm");
    let adapter = TsAdapter::new(lang, &[".ts", ".tsx"], query);
    
    assert!(adapter.supports(Path::new("test.ts")));
    assert!(adapter.supports(Path::new("test.tsx")));
    assert!(!adapter.supports(Path::new("test.js"))); // Not in extensions list
    assert!(!adapter.supports(Path::new("test.py")));
}

#[test]
fn test_typescript_function_extraction() {
    let lang = tree_sitter_typescript::language_typescript();
    let query = include_str!("../../queries/typescript.scm");
    let adapter = TsAdapter::new(lang, &[".ts"], query);
    
    let code = r#"
function hello(name: string): string {
    return `Hello, ${name}`;
}

class Greeter {
    greet(name: string) {
        return hello(name);
    }
}
"#;
    
    let path = Path::new("test.ts");
    let ctx = FileCtx { path, text: code };
    
    let result = adapter.analyze(&ctx).unwrap();
    
    // Should extract function and class symbols
    assert!(result.symbols.iter().any(|s| s.name == "hello" && s.kind == "function"));
    assert!(result.symbols.iter().any(|s| s.name == "greet" && s.kind == "function"));
    assert!(result.symbols.len() >= 2);
}

#[test]
fn test_python_function_extraction() {
    let lang = tree_sitter_python::language();
    let query = include_str!("../../queries/python.scm");
    let adapter = TsAdapter::new(lang, &[".py"], query);
    
    let code = r#"
def square(n: int) -> int:
    """Return n squared."""
    return n * n

class Calculator:
    def add(self, a, b):
        return a + b
"#;
    
    let path = Path::new("test.py");
    let ctx = FileCtx { path, text: code };
    
    let result = adapter.analyze(&ctx).unwrap();
    
    assert!(result.symbols.iter().any(|s| s.name == "square" && s.kind == "function"));
    assert!(result.symbols.iter().any(|s| s.name == "add" && s.kind == "function"));
}

#[test]
fn test_region_anchor_extraction() {
    let lang = tree_sitter_python::language();
    let query = include_str!("../../queries/python.scm");
    let adapter = TsAdapter::new(lang, &[".py"], query);
    
    let code = r#"
# <r:imports>
import os
import sys

# <r:functions>
def main():
    print("Hello World")

# <r:classes>
class App:
    def run(self):
        main()
"#;
    
    let path = Path::new("test.py");
    let ctx = FileCtx { path, text: code };
    
    let result = adapter.analyze(&ctx).unwrap();
    
    // Should extract 3 regions
    assert_eq!(result.regions.len(), 3);
    assert!(result.regions.iter().any(|r| r.name == "imports"));
    assert!(result.regions.iter().any(|r| r.name == "functions"));
    assert!(result.regions.iter().any(|r| r.name == "classes"));
}

#[test]
fn test_rust_symbol_extraction() {
    let lang = tree_sitter_rust::language();
    let query = include_str!("../../queries/rust.scm");
    let adapter = TsAdapter::new(lang, &[".rs"], query);
    
    let code = r#"
struct User {
    name: String,
    email: String,
}

impl User {
    fn new(name: String, email: String) -> Self {
        Self { name, email }
    }
}

fn create_user() -> User {
    User::new("Alice".to_string(), "alice@example.com".to_string())
}
"#;
    
    let path = Path::new("test.rs");
    let ctx = FileCtx { path, text: code };
    
    let result = adapter.analyze(&ctx).unwrap();
    
    // Should extract struct, impl, and function symbols
    assert!(result.symbols.iter().any(|s| s.name == "User" && s.kind == "class"));
    assert!(result.symbols.iter().any(|s| s.name == "new" && s.kind == "function"));
    assert!(result.symbols.iter().any(|s| s.name == "create_user" && s.kind == "function"));
}

#[test]
fn test_empty_file_handling() {
    let lang = tree_sitter_python::language();
    let query = include_str!("../../queries/python.scm");
    let adapter = TsAdapter::new(lang, &[".py"], query);
    
    let code = "";
    let path = Path::new("empty.py");
    let ctx = FileCtx { path, text: code };
    
    let result = adapter.analyze(&ctx).unwrap();
    
    // Empty file should produce empty analysis
    assert_eq!(result.symbols.len(), 0);
    assert_eq!(result.regions.len(), 0);
    assert_eq!(result.imports.len(), 0);
}

#[test]
fn test_malformed_code_handling() {
    let lang = tree_sitter_python::language();
    let query = include_str!("../../queries/python.scm");
    let adapter = TsAdapter::new(lang, &[".py"], query);
    
    // Intentionally malformed Python
    let code = r#"
def broken_function(
    # Missing closing parenthesis and body
"#;
    
    let path = Path::new("broken.py");
    let ctx = FileCtx { path, text: code };
    
    // Should handle gracefully without panicking
    let result = adapter.analyze(&ctx);
    assert!(result.is_ok()); // May not extract symbols, but shouldn't crash
}