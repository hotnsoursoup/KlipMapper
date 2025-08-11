// Debug tool to inspect TreeSitter parse tree and node names
// This helps us understand the actual grammar structure

use tree_sitter::{Parser, Language, Tree, Node};

fn debug_parse_tree() -> Result<(), Box<dyn std::error::Error>> {
    // Initialize Dart parser
    let mut parser = Parser::new();
    let language = tree_sitter_dart::language();
    parser.set_language(&language)?;
    
    // Simple Dart code to parse
    let dart_code = r#"
class UserModel {
  final String name;
  
  UserModel(this.name);
  
  String getName() {
    return name;
  }
}
"#;
    
    // Parse the code
    let tree = parser.parse(dart_code, None).unwrap();
    let root_node = tree.root_node();
    
    println!("Root node: {}", root_node.kind());
    println!("Parse tree:");
    print_node(root_node, dart_code, 0);
    
    Ok(())
}

fn print_node(node: Node, source: &str, depth: usize) {
    let indent = "  ".repeat(depth);
    
    if node.child_count() == 0 {
        // Leaf node - print its text
        if let Ok(text) = node.utf8_text(source.as_bytes()) {
            println!("{}{}[{}]: '{}'", indent, node.kind(), node.id(), text.trim());
        }
    } else {
        // Internal node
        println!("{}{}[{}] ({}..{}) {} children", 
                 indent, node.kind(), node.id(), 
                 node.start_byte(), node.end_byte(), node.child_count());
        
        // Print all children
        let mut cursor = node.walk();
        for child in node.children(&mut cursor) {
            print_node(child, source, depth + 1);
        }
    }
}

fn main() {
    if let Err(e) = debug_parse_tree() {
        eprintln!("Error: {}", e);
    }
}