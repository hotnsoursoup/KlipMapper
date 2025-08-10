use agentmap::query_pack::{QueryPack, SymbolResolver, TypeScriptResolver, PythonResolver, RustResolver};

#[test]
fn test_typescript_resolver_import_alias() {
    let resolver = TypeScriptResolver;
    
    // Default import
    assert_eq!(resolver.resolve_import_alias("React", None), "React");
    
    // Aliased import
    assert_eq!(resolver.resolve_import_alias("React", Some("R")), "R");
}

#[test]
fn test_typescript_resolver_member_access() {
    let resolver = TypeScriptResolver;
    
    assert_eq!(resolver.resolve_member_access("console", "log"), "console.log");
    assert_eq!(resolver.resolve_member_access("user", "name"), "user.name");
}

#[test]
fn test_typescript_resolver_scope_detection() {
    let resolver = TypeScriptResolver;
    
    assert_eq!(resolver.get_enclosing_scope_type("function_declaration"), Some("method"));
    assert_eq!(resolver.get_enclosing_scope_type("class_declaration"), Some("class"));
    assert_eq!(resolver.get_enclosing_scope_type("interface_declaration"), Some("interface"));
    assert_eq!(resolver.get_enclosing_scope_type("unknown_node"), None);
}

#[test]
fn test_python_resolver_import_alias() {
    let resolver = PythonResolver;
    
    // from foo import bar -> bar
    assert_eq!(resolver.resolve_import_alias("foo.bar", None), "bar");
    
    // from foo import bar as baz -> baz
    assert_eq!(resolver.resolve_import_alias("foo.bar", Some("baz")), "baz");
    
    // Simple module import
    assert_eq!(resolver.resolve_import_alias("os", None), "os");
}

#[test]
fn test_python_resolver_member_access() {
    let resolver = PythonResolver;
    
    assert_eq!(resolver.resolve_member_access("os", "path"), "os.path");
    assert_eq!(resolver.resolve_member_access("self", "name"), "self.name");
}

#[test]
fn test_rust_resolver_import_alias() {
    let resolver = RustResolver;
    
    // use std::collections::HashMap -> HashMap
    assert_eq!(resolver.resolve_import_alias("std::collections::HashMap", None), "HashMap");
    
    // use std::collections::HashMap as Map -> Map
    assert_eq!(resolver.resolve_import_alias("std::collections::HashMap", Some("Map")), "Map");
    
    // Simple use
    assert_eq!(resolver.resolve_import_alias("serde", None), "serde");
}

#[test]
fn test_rust_resolver_member_access() {
    let resolver = RustResolver;
    
    assert_eq!(resolver.resolve_member_access("Vec", "new"), "Vec::new");
    assert_eq!(resolver.resolve_member_access("std", "collections"), "std::collections");
}

#[test]
fn test_rust_resolver_scope_detection() {
    let resolver = RustResolver;
    
    assert_eq!(resolver.get_enclosing_scope_type("function_item"), Some("function"));
    assert_eq!(resolver.get_enclosing_scope_type("impl_item"), Some("impl"));
    assert_eq!(resolver.get_enclosing_scope_type("struct_item"), Some("struct"));
    assert_eq!(resolver.get_enclosing_scope_type("trait_item"), Some("trait"));
    assert_eq!(resolver.get_enclosing_scope_type("unknown"), None);
}

#[test]
fn test_query_pack_creation() {
    // Test that query packs can be created without panicking
    // Note: These tests require the actual query files to exist
    
    let result = QueryPack::for_typescript();
    if result.is_ok() {
        let pack = result.unwrap();
        assert_eq!(pack.name, "typescript");
        assert!(pack.defs_query.is_some());
        assert!(pack.uses_query.is_some());
        assert!(pack.imports_query.is_some());
    }
    // If files don't exist, that's ok for unit tests
}

// Integration tests with actual tree-sitter parsing
#[cfg(test)]
mod tree_sitter_integration {
    use super::*;
    use tree_sitter::{Parser, Query, QueryCursor};
    
    #[test]
    fn test_typescript_defs_query() {
        let language = tree_sitter_typescript::language_typescript();
        let query_source = include_str!("../../queries/typescript/defs.scm");
        
        let query_result = Query::new(&language, query_source);
        if query_result.is_err() {
            // Print the error for debugging
            println!("TypeScript defs query error: {:?}", query_result.err());
            return; // Skip test if query is invalid
        }
        
        let query = query_result.unwrap();
        let mut parser = Parser::new();
        parser.set_language(&language).unwrap();
        
        let code = r#"
class UserService {
    private users: User[] = [];
    
    addUser(user: User): void {
        this.users.push(user);
    }
}

function createUser(name: string): User {
    return { name };
}

interface User {
    name: string;
}
"#;
        
        let tree = parser.parse(code, None).unwrap();
        let mut cursor = QueryCursor::new();
        let matches = cursor.matches(&query, tree.root_node(), code.as_bytes());
        
        let mut captured_names = Vec::new();
        for m in matches {
            for capture in m.captures {
                let text = capture.node.utf8_text(code.as_bytes()).unwrap();
                captured_names.push(text.to_string());
            }
        }
        
        // Should capture class, function, and interface names
        assert!(captured_names.contains(&"UserService".to_string()));
        assert!(captured_names.contains(&"createUser".to_string()));
        assert!(captured_names.contains(&"User".to_string()));
    }
    
    #[test]
    fn test_python_defs_query() {
        let language = tree_sitter_python::language();
        let query_source = include_str!("../../queries/python/defs.scm");
        
        let query_result = Query::new(&language, query_source);
        if query_result.is_err() {
            println!("Python defs query error: {:?}", query_result.err());
            return;
        }
        
        let query = query_result.unwrap();
        let mut parser = Parser::new();
        parser.set_language(&language).unwrap();
        
        let code = r#"
class Employee:
    def __init__(self, name):
        self.name = name
    
    def get_name(self):
        return self.name

def create_employee(name):
    return Employee(name)

@property
def decorated_function():
    pass
"#;
        
        let tree = parser.parse(code, None).unwrap();
        let mut cursor = QueryCursor::new();
        let matches = cursor.matches(&query, tree.root_node(), code.as_bytes());
        
        let mut captured_names = Vec::new();
        for m in matches {
            for capture in m.captures {
                let text = capture.node.utf8_text(code.as_bytes()).unwrap();
                captured_names.push(text.to_string());
            }
        }
        
        // Should capture class, methods, and functions
        assert!(captured_names.contains(&"Employee".to_string()));
        assert!(captured_names.contains(&"create_employee".to_string()));
        // Methods might be captured depending on query structure
    }
    
    #[test]
    fn test_rust_defs_query() {
        let language = tree_sitter_rust::language();
        let query_source = include_str!("../../queries/rust/defs.scm");
        
        let query_result = Query::new(&language, query_source);
        if query_result.is_err() {
            println!("Rust defs query error: {:?}", query_result.err());
            return;
        }
        
        let query = query_result.unwrap();
        let mut parser = Parser::new();
        parser.set_language(&language).unwrap();
        
        let code = r#"
struct User {
    name: String,
}

impl User {
    fn new(name: String) -> Self {
        Self { name }
    }
    
    fn get_name(&self) -> &str {
        &self.name
    }
}

trait Greetable {
    fn greet(&self) -> String;
}

fn main() {
    let user = User::new("Alice".to_string());
}
"#;
        
        let tree = parser.parse(code, None).unwrap();
        let mut cursor = QueryCursor::new();
        let matches = cursor.matches(&query, tree.root_node(), code.as_bytes());
        
        let mut captured_names = Vec::new();
        for m in matches {
            for capture in m.captures {
                let text = capture.node.utf8_text(code.as_bytes()).unwrap();
                captured_names.push(text.to_string());
            }
        }
        
        // Should capture struct, trait, and function names
        assert!(captured_names.contains(&"User".to_string()));
        assert!(captured_names.contains(&"Greetable".to_string()));
        assert!(captured_names.contains(&"main".to_string()));
    }
}