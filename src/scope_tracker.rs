use crate::anchor::{ScopeFrame, SourceRange};
use tree_sitter::{Node, Tree, TreeCursor};
use std::collections::HashMap;
use anyhow::{Result, Context};

/// Tracks nested scope frames during AST traversal
pub struct ScopeTracker {
    /// Stack of active scopes
    scope_stack: Vec<ScopeFrame>,
    /// Language-specific node type mappings
    frame_mappings: HashMap<String, FrameKind>,
    /// Source code bytes for range calculation
    source_bytes: Vec<u8>,
}

#[derive(Debug, Clone, PartialEq)]
pub enum FrameKind {
    File,
    Module,
    Namespace,
    Class,
    Interface,
    Trait,
    Struct,
    Enum,
    Function,
    Method,
    Block,
    Lambda,
    IfBlock,
    LoopBlock,
}

impl FrameKind {
    pub fn as_str(&self) -> &'static str {
        match self {
            FrameKind::File => "file",
            FrameKind::Module => "module",
            FrameKind::Namespace => "namespace",
            FrameKind::Class => "class",
            FrameKind::Interface => "interface",
            FrameKind::Trait => "trait",
            FrameKind::Struct => "struct",
            FrameKind::Enum => "enum",
            FrameKind::Function => "function",
            FrameKind::Method => "method",
            FrameKind::Block => "block",
            FrameKind::Lambda => "lambda",
            FrameKind::IfBlock => "if",
            FrameKind::LoopBlock => "loop",
        }
    }

    pub fn precedence(&self) -> u8 {
        match self {
            FrameKind::File => 0,
            FrameKind::Module => 1,
            FrameKind::Namespace => 1,
            FrameKind::Class | FrameKind::Interface | FrameKind::Trait => 2,
            FrameKind::Struct | FrameKind::Enum => 2,
            FrameKind::Function | FrameKind::Method => 3,
            FrameKind::Lambda => 4,
            FrameKind::Block | FrameKind::IfBlock | FrameKind::LoopBlock => 5,
        }
    }
}

impl ScopeTracker {
    pub fn new(language: &str, source: &str) -> Self {
        let mut tracker = Self {
            scope_stack: Vec::new(),
            frame_mappings: HashMap::new(),
            source_bytes: source.as_bytes().to_vec(),
        };

        tracker.setup_language_mappings(language);
        
        // Initialize with file-level frame
        let file_frame = ScopeFrame {
            kind: FrameKind::File.as_str().to_string(),
            name: None,
            range: SourceRange {
                lines: [1, source.lines().count() as u32],
                bytes: [0, source.len() as u32],
            },
        };
        tracker.scope_stack.push(file_frame);

        tracker
    }

    fn setup_language_mappings(&mut self, language: &str) {
        match language {
            "rust" => {
                self.frame_mappings.insert("mod_item".to_string(), FrameKind::Module);
                self.frame_mappings.insert("struct_item".to_string(), FrameKind::Struct);
                self.frame_mappings.insert("enum_item".to_string(), FrameKind::Enum);
                self.frame_mappings.insert("trait_item".to_string(), FrameKind::Trait);
                self.frame_mappings.insert("impl_item".to_string(), FrameKind::Class);
                self.frame_mappings.insert("function_item".to_string(), FrameKind::Function);
                self.frame_mappings.insert("closure_expression".to_string(), FrameKind::Lambda);
                self.frame_mappings.insert("block".to_string(), FrameKind::Block);
                self.frame_mappings.insert("if_expression".to_string(), FrameKind::IfBlock);
                self.frame_mappings.insert("while_expression".to_string(), FrameKind::LoopBlock);
                self.frame_mappings.insert("for_expression".to_string(), FrameKind::LoopBlock);
            },
            "typescript" | "javascript" => {
                self.frame_mappings.insert("module".to_string(), FrameKind::Module);
                self.frame_mappings.insert("namespace_declaration".to_string(), FrameKind::Namespace);
                self.frame_mappings.insert("class_declaration".to_string(), FrameKind::Class);
                self.frame_mappings.insert("interface_declaration".to_string(), FrameKind::Interface);
                self.frame_mappings.insert("function_declaration".to_string(), FrameKind::Function);
                self.frame_mappings.insert("method_definition".to_string(), FrameKind::Method);
                self.frame_mappings.insert("arrow_function".to_string(), FrameKind::Lambda);
                self.frame_mappings.insert("function_expression".to_string(), FrameKind::Lambda);
                self.frame_mappings.insert("statement_block".to_string(), FrameKind::Block);
                self.frame_mappings.insert("if_statement".to_string(), FrameKind::IfBlock);
                self.frame_mappings.insert("while_statement".to_string(), FrameKind::LoopBlock);
                self.frame_mappings.insert("for_statement".to_string(), FrameKind::LoopBlock);
            },
            "python" => {
                self.frame_mappings.insert("module".to_string(), FrameKind::Module);
                self.frame_mappings.insert("class_definition".to_string(), FrameKind::Class);
                self.frame_mappings.insert("function_definition".to_string(), FrameKind::Function);
                self.frame_mappings.insert("lambda".to_string(), FrameKind::Lambda);
                self.frame_mappings.insert("if_statement".to_string(), FrameKind::IfBlock);
                self.frame_mappings.insert("while_statement".to_string(), FrameKind::LoopBlock);
                self.frame_mappings.insert("for_statement".to_string(), FrameKind::LoopBlock);
            },
            "java" => {
                self.frame_mappings.insert("package_declaration".to_string(), FrameKind::Module);
                self.frame_mappings.insert("class_declaration".to_string(), FrameKind::Class);
                self.frame_mappings.insert("interface_declaration".to_string(), FrameKind::Interface);
                self.frame_mappings.insert("enum_declaration".to_string(), FrameKind::Enum);
                self.frame_mappings.insert("method_declaration".to_string(), FrameKind::Method);
                self.frame_mappings.insert("lambda_expression".to_string(), FrameKind::Lambda);
                self.frame_mappings.insert("block".to_string(), FrameKind::Block);
                self.frame_mappings.insert("if_statement".to_string(), FrameKind::IfBlock);
                self.frame_mappings.insert("while_statement".to_string(), FrameKind::LoopBlock);
                self.frame_mappings.insert("for_statement".to_string(), FrameKind::LoopBlock);
            },
            "dart" => {
                self.frame_mappings.insert("library_name".to_string(), FrameKind::Module);
                self.frame_mappings.insert("class_definition".to_string(), FrameKind::Class);
                self.frame_mappings.insert("enum_declaration".to_string(), FrameKind::Enum);
                self.frame_mappings.insert("function_declaration".to_string(), FrameKind::Function);
                self.frame_mappings.insert("method_declaration".to_string(), FrameKind::Method);
                self.frame_mappings.insert("lambda_expression".to_string(), FrameKind::Lambda);
                self.frame_mappings.insert("block".to_string(), FrameKind::Block);
                self.frame_mappings.insert("if_statement".to_string(), FrameKind::IfBlock);
                self.frame_mappings.insert("while_statement".to_string(), FrameKind::LoopBlock);
                self.frame_mappings.insert("for_statement".to_string(), FrameKind::LoopBlock);
            },
            _ => {
                // Generic mappings for unknown languages
                self.frame_mappings.insert("class".to_string(), FrameKind::Class);
                self.frame_mappings.insert("function".to_string(), FrameKind::Function);
                self.frame_mappings.insert("method".to_string(), FrameKind::Method);
            }
        }
    }

    /// Enter a new scope frame
    pub fn enter_scope(&mut self, node: Node, name: Option<String>) -> Result<()> {
        let node_type = node.kind();
        
        if let Some(frame_kind) = self.frame_mappings.get(node_type).cloned() {
            let range = self.node_to_range(node)?;
            
            let frame = ScopeFrame {
                kind: frame_kind.as_str().to_string(),
                name,
                range,
            };

            self.scope_stack.push(frame);
        }

        Ok(())
    }

    /// Exit the current scope frame
    pub fn exit_scope(&mut self, node: Node) -> Result<()> {
        let node_type = node.kind();
        
        if self.frame_mappings.contains_key(node_type) {
            if self.scope_stack.len() > 1 { // Keep file frame
                self.scope_stack.pop();
            }
        }

        Ok(())
    }

    /// Get current scope frames (cloned)
    pub fn current_frames(&self) -> Vec<ScopeFrame> {
        self.scope_stack.clone()
    }

    /// Get frames appropriate for a specific node
    pub fn frames_for_node(&self, node: Node) -> Result<Vec<ScopeFrame>> {
        let mut frames = self.scope_stack.clone();
        
        // Add the node itself as a frame if it's a scope-defining node
        if let Some(frame_kind) = self.frame_mappings.get(node.kind()).cloned() {
            let name = self.extract_node_name(node);
            let range = self.node_to_range(node)?;
            
            let frame = ScopeFrame {
                kind: frame_kind.as_str().to_string(),
                name,
                range,
            };
            
            frames.push(frame);
        }

        Ok(frames)
    }

    /// Get the innermost frame of a specific kind
    pub fn find_enclosing_frame(&self, frame_kind: &str) -> Option<&ScopeFrame> {
        self.scope_stack.iter().rev()
            .find(|frame| frame.kind == frame_kind)
    }

    /// Check if currently inside a specific type of scope
    pub fn is_in_scope(&self, frame_kind: &str) -> bool {
        self.scope_stack.iter()
            .any(|frame| frame.kind == frame_kind)
    }

    /// Get scope depth
    pub fn depth(&self) -> usize {
        self.scope_stack.len()
    }

    /// Convert tree-sitter node to source range
    fn node_to_range(&self, node: Node) -> Result<SourceRange> {
        let start_point = node.start_position();
        let end_point = node.end_position();
        
        let start_line = start_point.row as u32 + 1; // Convert to 1-indexed
        let end_line = end_point.row as u32 + 1;
        
        let start_byte = node.start_byte() as u32;
        let end_byte = node.end_byte() as u32;

        Ok(SourceRange {
            lines: [start_line, end_line],
            bytes: [start_byte, end_byte],
        })
    }

    /// Extract name from a node (identifier, type name, etc.)
    fn extract_node_name(&self, node: Node) -> Option<String> {
        // Try to find a name field
        for i in 0..node.child_count() {
            if let Some(child) = node.child(i) {
                match child.kind() {
                    "identifier" | "type_identifier" | "field_identifier" => {
                        if let Ok(name) = child.utf8_text(&self.source_bytes) {
                            return Some(name.to_string());
                        }
                    },
                    _ => continue,
                }
            }
        }

        // Try named child
        if let Some(name_node) = node.child_by_field_name("name") {
            if let Ok(name) = name_node.utf8_text(&self.source_bytes) {
                return Some(name.to_string());
            }
        }

        None
    }
}

/// Traverse AST and track scopes automatically
pub fn traverse_with_scope_tracking<F>(
    tree: &Tree, 
    source: &str, 
    language: &str,
    mut visitor: F
) -> Result<()> 
where
    F: FnMut(Node, &ScopeTracker) -> Result<()>
{
    let mut tracker = ScopeTracker::new(language, source);
    let mut cursor = tree.walk();

    fn visit_node<F>(
        cursor: &mut TreeCursor,
        tracker: &mut ScopeTracker,
        visitor: &mut F,
        depth: usize
    ) -> Result<()>
    where
        F: FnMut(Node, &ScopeTracker) -> Result<()>
    {
        let node = cursor.node();
        
        // Extract name for scope entry
        let name = tracker.extract_node_name(node);
        
        // Enter scope if this node defines one
        tracker.enter_scope(node, name)?;
        
        // Visit this node
        visitor(node, tracker)?;

        // Visit children
        if cursor.goto_first_child() {
            loop {
                visit_node(cursor, tracker, visitor, depth + 1)?;
                
                if !cursor.goto_next_sibling() {
                    break;
                }
            }
            cursor.goto_parent();
        }

        // Exit scope
        tracker.exit_scope(node)?;

        Ok(())
    }

    visit_node(&mut cursor, &mut tracker, &mut visitor, 0)
        .context("Failed to traverse AST with scope tracking")
}

#[cfg(test)]
mod tests {
    use super::*;
    use tree_sitter::Parser;

    #[test]
    fn test_scope_tracker_rust() {
        let mut tracker = ScopeTracker::new("rust", "struct Test {}");
        
        assert_eq!(tracker.depth(), 1); // File scope
        assert!(tracker.is_in_scope("file"));
        assert!(!tracker.is_in_scope("struct"));
    }

    #[test]
    fn test_frame_precedence() {
        assert!(FrameKind::File.precedence() < FrameKind::Class.precedence());
        assert!(FrameKind::Class.precedence() < FrameKind::Method.precedence());
        assert!(FrameKind::Method.precedence() < FrameKind::Block.precedence());
    }

    #[test]
    fn test_language_mappings() {
        let tracker = ScopeTracker::new("rust", "");
        assert!(tracker.frame_mappings.contains_key("struct_item"));
        assert!(tracker.frame_mappings.contains_key("function_item"));
        
        let tracker_ts = ScopeTracker::new("typescript", "");
        assert!(tracker_ts.frame_mappings.contains_key("class_declaration"));
        assert!(tracker_ts.frame_mappings.contains_key("interface_declaration"));
    }

    #[test] 
    fn test_rust_scope_traversal() {
        let code = r#"
struct User {
    name: String,
}

impl User {
    fn new(name: String) -> Self {
        Self { name }
    }
}
"#;

        let mut parser = Parser::new();
        parser.set_language(&tree_sitter_rust::language()).unwrap();
        let tree = parser.parse(code, None).unwrap();

        let mut visited_scopes = Vec::new();
        
        traverse_with_scope_tracking(&tree, code, "rust", |node, tracker| {
            if matches!(node.kind(), "struct_item" | "impl_item" | "function_item") {
                visited_scopes.push((node.kind().to_string(), tracker.depth()));
            }
            Ok(())
        }).unwrap();

        assert!(!visited_scopes.is_empty());
        // Should visit struct, impl, and function with increasing depth
    }
}