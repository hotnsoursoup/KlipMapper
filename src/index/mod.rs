use serde::Deserialize;
use std::{collections::BTreeSet, fs, path::Path};
use anyhow::Result;
use tree_sitter::Parser;
use walkdir::WalkDir;

#[derive(Default, Deserialize)]
pub struct AppConfig { 
    pub track: Option<Vec<String>> 
}

pub fn load_cfg(root: &Path) -> AppConfig {
    let p = root.join(".agentmap").join("config.yaml");
    fs::read_to_string(&p)
        .ok()
        .and_then(|s| serde_yaml::from_str(&s).ok())
        .unwrap_or_default()
}

pub fn auto_symbols_for_dart(root: &Path) -> Result<BTreeSet<String>> {
    let mut out = BTreeSet::new();
    let mut parser = Parser::new();
    
    // Set language with proper error handling
    parser.set_language(&tree_sitter_dart::language())?;
    
    for entry in WalkDir::new(root)
        .into_iter()
        .filter_map(Result::ok)
        .filter(|e| e.path().extension().map_or(false, |x| x == "dart"))
    {
        if let Ok(src) = fs::read_to_string(entry.path()) {
            if let Some(tree) = parser.parse(&src, None) {
                let root_node = tree.root_node();
                collect_dart_toplevel(&src, root_node, &mut out)?;
            }
        }
    }
    Ok(out)
}

fn collect_dart_toplevel(
    src: &str,
    node: tree_sitter::Node,
    out: &mut BTreeSet<String>,
) -> Result<()> {
    let mut cursor = node.walk();
    
    // Process current node
    if node.kind() == "class_definition" {
        // Look for name field
        for i in 0..node.child_count() {
            if let Some(child) = node.child(i) {
                if child.kind() == "identifier" {
                    if let Ok(name) = child.utf8_text(src.as_bytes()) {
                        out.insert(name.to_string());
                    }
                    break;
                }
            }
        }
    }
    
    // Process children
    if cursor.goto_first_child() {
        loop {
            collect_dart_toplevel(src, cursor.node(), out)?;
            if !cursor.goto_next_sibling() {
                break;
            }
        }
        cursor.goto_parent();
    }
    
    Ok(())
}