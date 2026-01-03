//! Scope tracking for symbol resolution.
//!
//! Tracks nested scope frames during AST traversal to enable
//! qualified name building and scope-aware resolution.

use std::collections::HashMap;
use crate::parser::Language;

/// Type of scope frame.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
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
    Impl,
}

impl FrameKind {
    /// Get string representation.
    pub fn as_str(&self) -> &'static str {
        match self {
            Self::File => "file",
            Self::Module => "module",
            Self::Namespace => "namespace",
            Self::Class => "class",
            Self::Interface => "interface",
            Self::Trait => "trait",
            Self::Struct => "struct",
            Self::Enum => "enum",
            Self::Function => "function",
            Self::Method => "method",
            Self::Block => "block",
            Self::Lambda => "lambda",
            Self::Impl => "impl",
        }
    }

    /// Get precedence (lower = higher level scope).
    pub fn precedence(&self) -> u8 {
        match self {
            Self::File => 0,
            Self::Module | Self::Namespace => 1,
            Self::Class | Self::Interface | Self::Trait | Self::Struct | Self::Enum | Self::Impl => 2,
            Self::Function | Self::Method => 3,
            Self::Lambda => 4,
            Self::Block => 5,
        }
    }

    /// Check if this frame kind defines a named scope (contributes to qualified name).
    pub fn is_named_scope(&self) -> bool {
        matches!(
            self,
            Self::Module
                | Self::Namespace
                | Self::Class
                | Self::Interface
                | Self::Trait
                | Self::Struct
                | Self::Enum
                | Self::Function
                | Self::Method
                | Self::Impl  // Rust impl blocks contribute to qualified names
        )
    }

    /// Check if this frame kind is a type definition.
    pub fn is_type(&self) -> bool {
        matches!(
            self,
            Self::Class | Self::Interface | Self::Trait | Self::Struct | Self::Enum
        )
    }

    /// Check if this frame kind is callable.
    pub fn is_callable(&self) -> bool {
        matches!(self, Self::Function | Self::Method | Self::Lambda)
    }
}

/// A single scope frame.
#[derive(Debug, Clone)]
pub struct ScopeFrame {
    /// Kind of scope.
    pub kind: FrameKind,

    /// Name of the scope (e.g., class name, function name).
    pub name: Option<String>,

    /// Start line (1-indexed).
    pub start_line: u32,

    /// End line (1-indexed).
    pub end_line: u32,
}

impl ScopeFrame {
    /// Create a new scope frame.
    pub fn new(kind: FrameKind, name: Option<String>, start_line: u32, end_line: u32) -> Self {
        Self {
            kind,
            name,
            start_line,
            end_line,
        }
    }

    /// Check if a line is within this scope.
    pub fn contains_line(&self, line: u32) -> bool {
        line >= self.start_line && line <= self.end_line
    }
}

/// Tracks nested scopes during AST traversal.
pub struct ScopeTracker {
    /// Stack of active scopes.
    stack: Vec<ScopeFrame>,

    /// Language-specific node type to FrameKind mappings.
    mappings: HashMap<&'static str, FrameKind>,
}

impl ScopeTracker {
    /// Create a new scope tracker for a language.
    pub fn new(language: Language) -> Self {
        let mut tracker = Self {
            stack: Vec::new(),
            mappings: HashMap::new(),
        };

        tracker.setup_language_mappings(language);
        tracker
    }

    /// Create with a file-level frame already pushed.
    pub fn with_file_scope(language: Language, file_lines: u32) -> Self {
        let mut tracker = Self::new(language);
        tracker.push(ScopeFrame::new(FrameKind::File, None, 1, file_lines));
        tracker
    }

    /// Setup language-specific node type mappings.
    fn setup_language_mappings(&mut self, language: Language) {
        match language {
            Language::Rust => {
                self.mappings.insert("mod_item", FrameKind::Module);
                self.mappings.insert("struct_item", FrameKind::Struct);
                self.mappings.insert("enum_item", FrameKind::Enum);
                self.mappings.insert("trait_item", FrameKind::Trait);
                self.mappings.insert("impl_item", FrameKind::Impl);
                self.mappings.insert("function_item", FrameKind::Function);
                self.mappings.insert("closure_expression", FrameKind::Lambda);
                self.mappings.insert("block", FrameKind::Block);
            }
            Language::TypeScript | Language::JavaScript => {
                self.mappings.insert("module", FrameKind::Module);
                self.mappings.insert("namespace_declaration", FrameKind::Namespace);
                self.mappings.insert("class_declaration", FrameKind::Class);
                self.mappings.insert("interface_declaration", FrameKind::Interface);
                self.mappings.insert("function_declaration", FrameKind::Function);
                self.mappings.insert("method_definition", FrameKind::Method);
                self.mappings.insert("arrow_function", FrameKind::Lambda);
                self.mappings.insert("function_expression", FrameKind::Lambda);
                self.mappings.insert("statement_block", FrameKind::Block);
            }
            Language::Python => {
                self.mappings.insert("module", FrameKind::Module);
                self.mappings.insert("class_definition", FrameKind::Class);
                self.mappings.insert("function_definition", FrameKind::Function);
                self.mappings.insert("lambda", FrameKind::Lambda);
            }
            Language::Go => {
                self.mappings.insert("package_clause", FrameKind::Module);
                // Go type declarations - map to specific types when possible
                self.mappings.insert("type_declaration", FrameKind::Struct); // Fallback for generic type decl
                self.mappings.insert("struct_type", FrameKind::Struct);
                self.mappings.insert("interface_type", FrameKind::Interface);
                self.mappings.insert("function_declaration", FrameKind::Function);
                self.mappings.insert("method_declaration", FrameKind::Method);
                self.mappings.insert("func_literal", FrameKind::Lambda);
                self.mappings.insert("block", FrameKind::Block);
            }
            Language::Java => {
                self.mappings.insert("package_declaration", FrameKind::Module);
                self.mappings.insert("class_declaration", FrameKind::Class);
                self.mappings.insert("interface_declaration", FrameKind::Interface);
                self.mappings.insert("enum_declaration", FrameKind::Enum);
                self.mappings.insert("method_declaration", FrameKind::Method);
                self.mappings.insert("constructor_declaration", FrameKind::Method);
                self.mappings.insert("lambda_expression", FrameKind::Lambda);
                self.mappings.insert("block", FrameKind::Block);
            }
            Language::Dart => {
                self.mappings.insert("library_name", FrameKind::Module);
                self.mappings.insert("class_definition", FrameKind::Class);
                self.mappings.insert("enum_declaration", FrameKind::Enum);
                self.mappings.insert("mixin_declaration", FrameKind::Trait);
                self.mappings.insert("extension_declaration", FrameKind::Impl);
                // Dart function definitions - include both signatures and full definitions
                self.mappings.insert("function_signature", FrameKind::Function);
                self.mappings.insert("function_declaration", FrameKind::Function);
                self.mappings.insert("method_signature", FrameKind::Method);
                self.mappings.insert("method_definition", FrameKind::Method);
                self.mappings.insert("constructor_signature", FrameKind::Method);
                self.mappings.insert("function_expression", FrameKind::Lambda);
                self.mappings.insert("block", FrameKind::Block);
            }
        }
    }

    /// Get the FrameKind for a TreeSitter node type, if any.
    pub fn frame_kind_for_node(&self, node_type: &str) -> Option<FrameKind> {
        self.mappings.get(node_type).copied()
    }

    /// Push a new scope frame onto the stack.
    pub fn push(&mut self, frame: ScopeFrame) {
        self.stack.push(frame);
    }

    /// Pop the current scope frame.
    pub fn pop(&mut self) -> Option<ScopeFrame> {
        // Never pop the file frame
        if self.stack.len() > 1 {
            self.stack.pop()
        } else {
            None
        }
    }

    /// Enter a scope based on node type.
    pub fn enter_scope(&mut self, node_type: &str, name: Option<String>, start_line: u32, end_line: u32) {
        if let Some(kind) = self.frame_kind_for_node(node_type) {
            self.push(ScopeFrame::new(kind, name, start_line, end_line));
        }
    }

    /// Exit a scope based on node type.
    pub fn exit_scope(&mut self, node_type: &str) {
        if self.frame_kind_for_node(node_type).is_some() {
            self.pop();
        }
    }

    /// Get current stack depth.
    pub fn depth(&self) -> usize {
        self.stack.len()
    }

    /// Get all current frames (cloned).
    pub fn frames(&self) -> Vec<ScopeFrame> {
        self.stack.clone()
    }

    /// Get the current (innermost) frame.
    pub fn current(&self) -> Option<&ScopeFrame> {
        self.stack.last()
    }

    /// Find the innermost frame of a specific kind.
    pub fn find_enclosing(&self, kind: FrameKind) -> Option<&ScopeFrame> {
        self.stack.iter().rev().find(|f| f.kind == kind)
    }

    /// Find the innermost frame that matches a predicate.
    pub fn find_enclosing_where<F>(&self, predicate: F) -> Option<&ScopeFrame>
    where
        F: Fn(&ScopeFrame) -> bool,
    {
        self.stack.iter().rev().find(|f| predicate(f))
    }

    /// Find the enclosing type (class, struct, trait, etc.).
    pub fn enclosing_type(&self) -> Option<&ScopeFrame> {
        self.find_enclosing_where(|f| f.kind.is_type())
    }

    /// Find the enclosing callable (function, method, lambda).
    pub fn enclosing_callable(&self) -> Option<&ScopeFrame> {
        self.find_enclosing_where(|f| f.kind.is_callable())
    }

    /// Check if currently inside a scope of the given kind.
    pub fn is_in_scope(&self, kind: FrameKind) -> bool {
        self.stack.iter().any(|f| f.kind == kind)
    }

    /// Build the fully qualified name from the current scope stack.
    pub fn qualified_name(&self, name: &str) -> String {
        let prefix: Vec<_> = self
            .stack
            .iter()
            .filter(|f| f.kind.is_named_scope())
            .filter_map(|f| f.name.as_ref())
            .cloned()
            .collect();

        if prefix.is_empty() {
            name.to_string()
        } else {
            format!("{}::{}", prefix.join("::"), name)
        }
    }

    /// Get the current scope path as a vector of names.
    pub fn scope_path(&self) -> Vec<String> {
        self.stack
            .iter()
            .filter(|f| f.kind.is_named_scope())
            .filter_map(|f| f.name.clone())
            .collect()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_frame_kind_properties() {
        assert!(FrameKind::Class.is_type());
        assert!(FrameKind::Function.is_callable());
        assert!(!FrameKind::Block.is_named_scope());
        assert!(FrameKind::File.precedence() < FrameKind::Class.precedence());
    }

    #[test]
    fn test_scope_tracker_rust() {
        let tracker = ScopeTracker::new(Language::Rust);

        assert!(tracker.frame_kind_for_node("struct_item").is_some());
        assert!(tracker.frame_kind_for_node("function_item").is_some());
        assert!(tracker.frame_kind_for_node("unknown_node").is_none());
    }

    #[test]
    fn test_scope_stack() {
        let mut tracker = ScopeTracker::with_file_scope(Language::Rust, 100);

        assert_eq!(tracker.depth(), 1);
        assert!(tracker.is_in_scope(FrameKind::File));

        // Enter a struct
        tracker.enter_scope("struct_item", Some("User".to_string()), 10, 50);
        assert_eq!(tracker.depth(), 2);
        assert!(tracker.is_in_scope(FrameKind::Struct));

        // Enter a method (impl item treated as function in this test)
        tracker.push(ScopeFrame::new(FrameKind::Method, Some("new".to_string()), 12, 20));
        assert_eq!(tracker.depth(), 3);

        // Test qualified name
        assert_eq!(tracker.qualified_name("helper"), "User::new::helper");

        // Test enclosing lookups
        assert!(tracker.enclosing_type().is_some());
        assert_eq!(tracker.enclosing_type().unwrap().name, Some("User".to_string()));

        // Exit method
        tracker.pop();
        assert_eq!(tracker.depth(), 2);

        // Exit struct
        tracker.exit_scope("struct_item");
        assert_eq!(tracker.depth(), 1);
    }

    #[test]
    fn test_scope_path() {
        let mut tracker = ScopeTracker::with_file_scope(Language::TypeScript, 100);

        tracker.enter_scope("class_declaration", Some("UserService".to_string()), 5, 80);
        tracker.enter_scope("method_definition", Some("create".to_string()), 10, 30);

        let path = tracker.scope_path();
        assert_eq!(path, vec!["UserService", "create"]);
    }

    #[test]
    fn test_language_mappings() {
        // Test that all languages have mappings
        for lang in Language::all() {
            let tracker = ScopeTracker::new(*lang);
            // Each language should have at least function/class mappings
            assert!(
                !tracker.mappings.is_empty(),
                "Language {:?} has no mappings",
                lang
            );
        }
    }
}
