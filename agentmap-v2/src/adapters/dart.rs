use std::collections::BTreeSet;
use std::path::Path;
use anyhow::Result;
use tree_sitter::Parser;
use ignore::WalkBuilder;

/// Auto-detect Dart symbols to track by scanning the project.
///
/// This mimics the legacy behavior of finding all class definitions in the project
/// and adding them to the tracked symbols list.
pub fn auto_symbols_for_dart(root: &Path) -> Result<BTreeSet<String>> {
    let mut out = BTreeSet::new();
    let mut parser = Parser::new();
    
    // We can assume tree-sitter-dart is available since we are in the dart adapter
    parser.set_language(&tree_sitter_dart::language())?;

    let walker = WalkBuilder::new(root)
        .hidden(false)
        .git_ignore(true)
        .build();

    for result in walker {
        match result {
            Ok(entry) => {
                let path = entry.path();
                if path.is_file() && path.extension().map_or(false, |e| e == "dart") {
                    // Swallow read errors to keep going
                    if let Ok(src) = std::fs::read_to_string(path) {
                        if let Some(tree) = parser.parse(&src, None) {
                            collect_dart_toplevel(&src, tree.root_node(), &mut out);
                        }
                    }
                }
            }
            Err(_) => {
                // Ignore walking errors
            }
        }
    }

    Ok(out)
}

fn collect_dart_toplevel(
    src: &str,
    node: tree_sitter::Node,
    out: &mut BTreeSet<String>,
) {
    let mut cursor = node.walk();

    // Check if current node is a class definition
    if node.kind() == "class_definition" {
        // Look for name field
        if let Some(name_node) = node.child_by_field_name("name") {
             if let Ok(name) = name_node.utf8_text(src.as_bytes()) {
                 out.insert(name.to_string());
             }
        }
    }

    // Recurse
    for child in node.children(&mut cursor) {
        collect_dart_toplevel(src, child, out);
    }
}
