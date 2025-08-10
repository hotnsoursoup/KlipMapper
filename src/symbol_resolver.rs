use crate::anchor::{Symbol, SymbolReference, SymbolEdge, GuardInfo, SourceRange, AnchorCompressor};
use crate::scope_tracker::{ScopeTracker, traverse_with_scope_tracking};
use tree_sitter::{Node, Tree, Query, QueryCursor};
use std::collections::{HashMap, HashSet};
use anyhow::{Result, Context};

/// Resolves symbols and builds relationship graphs from AST
pub struct SymbolResolver {
    language: String,
    source: String,
    source_bytes: Vec<u8>,
    symbols: Vec<Symbol>,
    symbol_counter: u32,
    /// Maps symbol names to their IDs for cross-referencing
    symbol_registry: HashMap<String, String>,
    /// Maps import aliases to full paths
    import_aliases: HashMap<String, String>,
    /// Tracks qualified names and namespaces
    namespace_stack: Vec<String>,
}

impl SymbolResolver {
    pub fn new(language: String, source: String) -> Self {
        Self {
            language,
            source_bytes: source.as_bytes().to_vec(),
            source,
            symbols: Vec::new(),
            symbol_counter: 0,
            symbol_registry: HashMap::new(),
            import_aliases: HashMap::new(),
            namespace_stack: Vec::new(),
        }
    }

    /// Analyze source and extract all symbols with relationships
    pub fn resolve_symbols(&mut self, tree: &Tree) -> Result<Vec<Symbol>> {
        // First pass: collect declarations and build symbol registry
        self.collect_declarations(tree)?;
        
        // Second pass: resolve references and build edges
        self.resolve_references(tree)?;
        
        // Third pass: analyze call patterns and side effects
        self.analyze_patterns(tree)?;

        Ok(self.symbols.clone())
    }

    /// First pass: collect all symbol declarations
    fn collect_declarations(&mut self, tree: &Tree) -> Result<()> {
        let source = self.source.clone();
        let language = self.language.clone();
        traverse_with_scope_tracking(tree, &source, &language, |node, tracker| {
            match node.kind() {
                // Class-like declarations
                "class_declaration" | "class_definition" | "struct_item" | "enum_item" | "interface_declaration" => {
                    self.process_type_declaration(node, tracker, "class")?;
                },
                "trait_item" | "interface_declaration" => {
                    self.process_type_declaration(node, tracker, "interface")?;
                },
                // Function declarations
                "function_declaration" | "function_definition" | "function_item" => {
                    self.process_function_declaration(node, tracker, false)?;
                },
                "method_declaration" | "method_definition" => {
                    self.process_function_declaration(node, tracker, true)?;
                },
                // Variable/field declarations
                "variable_declaration" | "field_declaration" | "let_declaration" => {
                    self.process_variable_declaration(node, tracker)?;
                },
                // Import declarations
                "import_declaration" | "use_declaration" | "import_statement" => {
                    self.process_import_declaration(node)?;
                },
                _ => {}
            }
            Ok(())
        })?;

        Ok(())
    }

    /// Second pass: resolve references and build edges
    fn resolve_references(&mut self, tree: &Tree) -> Result<()> {
        let source = self.source.clone();
        let language = self.language.clone();
        traverse_with_scope_tracking(tree, &source, &language, |node, tracker| {
            match node.kind() {
                // Function calls
                "call_expression" | "function_call" => {
                    self.process_function_call(node, tracker)?;
                },
                // Member access
                "member_expression" | "field_expression" => {
                    self.process_member_access(node, tracker)?;
                },
                // Type references
                "type_identifier" | "generic_type" => {
                    self.process_type_reference(node, tracker)?;
                },
                // Variable references
                "identifier" => {
                    self.process_identifier_reference(node, tracker)?;
                },
                _ => {}
            }
            Ok(())
        })?;

        Ok(())
    }

    /// Third pass: analyze patterns and side effects
    fn analyze_patterns(&mut self, tree: &Tree) -> Result<()> {
        let source = self.source.clone();
        let language = self.language.clone();
        traverse_with_scope_tracking(tree, &source, &language, |node, tracker| {
            // Look for side effects and patterns
            self.analyze_side_effects(node, tracker)?;
            self.analyze_async_patterns(node, tracker)?;
            self.analyze_error_handling(node, tracker)?;
            Ok(())
        })?;

        Ok(())
    }

    fn process_type_declaration(&mut self, node: Node, tracker: &ScopeTracker, kind: &str) -> Result<()> {
        let name = self.extract_node_name(node)
            .context("Failed to extract type name")?;
        
        let symbol_id = self.generate_symbol_id(kind);
        let qualified_name = self.build_qualified_name(&name);
        
        let range = self.node_to_range(node)?;
        let frames = tracker.frames_for_node(node)?;
        
        let mut roles = vec!["declaration".to_string()];
        
        // Add specific roles based on context
        if self.is_exported(node)? {
            roles.push("exported".to_string());
        }
        if self.is_public(node)? {
            roles.push("public".to_string());
        }

        let symbol = Symbol {
            id: symbol_id.clone(),
            kind: kind.to_string(),
            name: name.clone(),
            owner: self.get_owner_symbol_id(tracker),
            range,
            frames,
            roles,
            references: Vec::new(),
            edges: Vec::new(),
            fingerprint: self.compute_node_fingerprint(node)?,
            guard: None,
        };

        self.symbols.push(symbol);
        self.symbol_registry.insert(qualified_name, symbol_id);
        
        Ok(())
    }

    fn process_function_declaration(&mut self, node: Node, tracker: &ScopeTracker, is_method: bool) -> Result<()> {
        let name = self.extract_node_name(node)
            .context("Failed to extract function name")?;
        
        let symbol_id = self.generate_symbol_id(if is_method { "method" } else { "function" });
        let qualified_name = self.build_qualified_name(&name);
        
        let range = self.node_to_range(node)?;
        let frames = tracker.frames_for_node(node)?;
        
        let mut roles = vec!["declaration".to_string()];
        
        // Analyze function characteristics
        if self.is_async_function(node)? {
            roles.push("async".to_string());
        }
        if self.is_exported(node)? {
            roles.push("exported".to_string());
        }
        if self.has_side_effects(node)? {
            roles.push("side-effect".to_string());
        }

        // Build guard information
        let guard = self.analyze_function_guard(node);

        let symbol = Symbol {
            id: symbol_id.clone(),
            kind: if is_method { "method".to_string() } else { "function".to_string() },
            name: name.clone(),
            owner: if is_method { self.get_owner_symbol_id(tracker) } else { None },
            range,
            frames,
            roles,
            references: Vec::new(),
            edges: Vec::new(),
            fingerprint: self.compute_node_fingerprint(node)?,
            guard,
        };

        self.symbols.push(symbol);
        self.symbol_registry.insert(qualified_name, symbol_id);
        
        Ok(())
    }

    fn process_variable_declaration(&mut self, node: Node, tracker: &ScopeTracker) -> Result<()> {
        let name = self.extract_node_name(node)
            .context("Failed to extract variable name")?;
        
        let symbol_id = self.generate_symbol_id("variable");
        let qualified_name = self.build_qualified_name(&name);
        
        let range = self.node_to_range(node)?;
        let frames = tracker.frames_for_node(node)?;
        
        let mut roles = vec!["declaration".to_string()];
        
        // Determine variable characteristics
        if self.is_constant(node)? {
            roles.push("constant".to_string());
        }
        if self.is_mutable(node)? {
            roles.push("mutable".to_string());
        }

        let symbol = Symbol {
            id: symbol_id.clone(),
            kind: "variable".to_string(),
            name: name.clone(),
            owner: self.get_owner_symbol_id(tracker),
            range,
            frames,
            roles,
            references: Vec::new(),
            edges: Vec::new(),
            fingerprint: self.compute_node_fingerprint(node)?,
            guard: None,
        };

        self.symbols.push(symbol);
        self.symbol_registry.insert(qualified_name, symbol_id);
        
        Ok(())
    }

    fn process_import_declaration(&mut self, node: Node) -> Result<()> {
        // Extract import path and aliases
        if let Some(import_path) = self.extract_import_path(node)? {
            if let Some(alias) = self.extract_import_alias(node)? {
                self.import_aliases.insert(alias, import_path);
            }
        }
        
        Ok(())
    }

    fn process_function_call(&mut self, node: Node, tracker: &ScopeTracker) -> Result<()> {
        if let Some(function_name) = self.extract_call_target(node)? {
            let caller_id = self.find_enclosing_symbol(tracker);
            
            if let Some(caller) = caller_id.and_then(|id| self.find_symbol_by_id_mut(&id)) {
                let at_line = node.start_position().row as u32 + 1;
                
                // Add call edge
                let edge = SymbolEdge {
                    edge_type: "call".to_string(),
                    target: function_name.clone(),
                    at_line,
                };
                caller.edges.push(edge);

                // Add function reference
                let reference = SymbolReference {
                    ref_type: "call".to_string(),
                    target: function_name,
                    at_line,
                };
                caller.references.push(reference);
            }
        }
        
        Ok(())
    }

    fn process_member_access(&mut self, node: Node, tracker: &ScopeTracker) -> Result<()> {
        if let (Some(object), Some(member)) = (self.extract_object_name(node)?, self.extract_member_name(node)?) {
            let accessor_id = self.find_enclosing_symbol(tracker);
            
            if let Some(accessor) = accessor_id.and_then(|id| self.find_symbol_by_id_mut(&id)) {
                let at_line = node.start_position().row as u32 + 1;
                
                // Build qualified member name
                let qualified_member = format!("{}.{}", object, member);
                
                let edge = SymbolEdge {
                    edge_type: "member-access".to_string(),
                    target: qualified_member.clone(),
                    at_line,
                };
                accessor.edges.push(edge);

                let reference = SymbolReference {
                    ref_type: "member".to_string(),
                    target: qualified_member,
                    at_line,
                };
                accessor.references.push(reference);
            }
        }
        
        Ok(())
    }

    fn process_type_reference(&mut self, node: Node, tracker: &ScopeTracker) -> Result<()> {
        if let Some(type_name) = self.extract_node_name(node) {
            let referrer_id = self.find_enclosing_symbol(tracker);
            
            if let Some(referrer) = referrer_id.and_then(|id| self.find_symbol_by_id_mut(&id)) {
                let at_line = node.start_position().row as u32 + 1;
                
                let edge = SymbolEdge {
                    edge_type: "uses-type".to_string(),
                    target: type_name.clone(),
                    at_line,
                };
                referrer.edges.push(edge);

                let reference = SymbolReference {
                    ref_type: "type".to_string(),
                    target: type_name,
                    at_line,
                };
                referrer.references.push(reference);
            }
        }
        
        Ok(())
    }

    fn process_identifier_reference(&mut self, node: Node, tracker: &ScopeTracker) -> Result<()> {
        // Only process if not part of a declaration
        if !self.is_part_of_declaration(node) {
            if let Some(identifier) = self.extract_node_name(node) {
                let referrer_id = self.find_enclosing_symbol(tracker);
                
                // Determine if this is a read or write first
                let ref_type = if self.is_assignment_target(node)? {
                    "write"
                } else {
                    "read"
                };
                
                if let Some(referrer) = referrer_id.and_then(|id| self.find_symbol_by_id_mut(&id)) {
                    let at_line = node.start_position().row as u32 + 1;
                    
                    let reference = SymbolReference {
                        ref_type: ref_type.to_string(),
                        target: identifier,
                        at_line,
                    };
                    referrer.references.push(reference);
                }
            }
        }
        
        Ok(())
    }

    fn analyze_side_effects(&mut self, node: Node, tracker: &ScopeTracker) -> Result<()> {
        let has_io = self.has_io_effects(node)?;
        let has_mutation = self.has_mutation_effects(node)?;
        let has_network = self.has_network_effects(node)?;
        
        if has_io || has_mutation || has_network {
            if let Some(symbol_id) = self.find_enclosing_symbol(tracker) {
                if let Some(symbol) = self.find_symbol_by_id_mut(&symbol_id) {
                    let guard = symbol.guard.get_or_insert_with(|| GuardInfo {
                        io_effects: Vec::new(),
                        invariants: Vec::new(),
                    });

                    if has_io {
                        guard.io_effects.push("io".to_string());
                    }
                    if has_mutation {
                        guard.io_effects.push("mutation".to_string());
                    }
                    if has_network {
                        guard.io_effects.push("network".to_string());
                    }
                }
            }
        }
        
        Ok(())
    }

    fn analyze_async_patterns(&mut self, node: Node, tracker: &ScopeTracker) -> Result<()> {
        if self.is_async_operation(node)? {
            if let Some(symbol_id) = self.find_enclosing_symbol(tracker) {
                if let Some(symbol) = self.find_symbol_by_id_mut(&symbol_id) {
                    if !symbol.roles.contains(&"async".to_string()) {
                        symbol.roles.push("async".to_string());
                    }
                }
            }
        }
        
        Ok(())
    }

    fn analyze_error_handling(&mut self, node: Node, tracker: &ScopeTracker) -> Result<()> {
        if self.has_error_handling(node)? {
            if let Some(symbol_id) = self.find_enclosing_symbol(tracker) {
                if let Some(symbol) = self.find_symbol_by_id_mut(&symbol_id) {
                    if !symbol.roles.contains(&"error-handling".to_string()) {
                        symbol.roles.push("error-handling".to_string());
                    }
                }
            }
        }
        
        Ok(())
    }

    // Helper methods

    fn generate_symbol_id(&mut self, prefix: &str) -> String {
        self.symbol_counter += 1;
        format!("{}{}", prefix.chars().next().unwrap().to_uppercase(), self.symbol_counter)
    }

    fn build_qualified_name(&self, name: &str) -> String {
        if self.namespace_stack.is_empty() {
            name.to_string()
        } else {
            format!("{}.{}", self.namespace_stack.join("."), name)
        }
    }

    fn extract_node_name(&self, node: Node) -> Option<String> {
        // Try various ways to extract name
        if let Some(name_node) = node.child_by_field_name("name") {
            if let Ok(name) = name_node.utf8_text(&self.source_bytes) {
                return Some(name.to_string());
            }
        }

        // Look for identifier children
        for i in 0..node.child_count() {
            if let Some(child) = node.child(i) {
                if matches!(child.kind(), "identifier" | "type_identifier" | "field_identifier") {
                    if let Ok(name) = child.utf8_text(&self.source_bytes) {
                        return Some(name.to_string());
                    }
                }
            }
        }

        None
    }

    fn node_to_range(&self, node: Node) -> Result<SourceRange> {
        Ok(SourceRange {
            lines: [node.start_position().row as u32 + 1, node.end_position().row as u32 + 1],
            bytes: [node.start_byte() as u32, node.end_byte() as u32],
        })
    }

    fn compute_node_fingerprint(&self, node: Node) -> Result<String> {
        if let Ok(content) = node.utf8_text(&self.source_bytes) {
            Ok(AnchorCompressor::hash_content(content))
        } else {
            Ok("unknown".to_string())
        }
    }

    fn find_symbol_by_id_mut(&mut self, id: &str) -> Option<&mut Symbol> {
        self.symbols.iter_mut().find(|s| s.id == id)
    }

    fn find_enclosing_symbol(&self, tracker: &ScopeTracker) -> Option<String> {
        // Find the innermost function or method scope
        for frame in tracker.current_frames().iter().rev() {
            if matches!(frame.kind.as_str(), "function" | "method") {
                // Look up symbol by frame name
                if let Some(name) = &frame.name {
                    if let Some(id) = self.symbol_registry.get(name) {
                        return Some(id.clone());
                    }
                }
            }
        }
        None
    }

    fn get_owner_symbol_id(&self, tracker: &ScopeTracker) -> Option<String> {
        // Find the enclosing class or struct
        for frame in tracker.current_frames().iter().rev() {
            if matches!(frame.kind.as_str(), "class" | "struct" | "interface") {
                if let Some(name) = &frame.name {
                    if let Some(id) = self.symbol_registry.get(name) {
                        return Some(id.clone());
                    }
                }
            }
        }
        None
    }

    // Language-specific analysis methods (simplified implementations)
    
    fn is_exported(&self, node: Node) -> Result<bool> {
        // Check for export keywords based on language
        Ok(self.node_has_keyword(node, &["export", "pub", "public"]))
    }

    fn is_public(&self, node: Node) -> Result<bool> {
        Ok(self.node_has_keyword(node, &["public", "pub"]))
    }

    fn is_async_function(&self, node: Node) -> Result<bool> {
        Ok(self.node_has_keyword(node, &["async"]))
    }

    fn is_constant(&self, node: Node) -> Result<bool> {
        Ok(self.node_has_keyword(node, &["const", "final", "readonly"]))
    }

    fn is_mutable(&self, node: Node) -> Result<bool> {
        Ok(self.node_has_keyword(node, &["mut", "var", "let"]))
    }

    fn has_side_effects(&self, _node: Node) -> Result<bool> {
        // Simplified - would need deeper analysis
        Ok(false)
    }

    fn analyze_function_guard(&self, _node: Node) -> Option<GuardInfo> {
        // Would analyze function body for effects
        None
    }

    fn node_has_keyword(&self, node: Node, keywords: &[&str]) -> bool {
        // Simplified keyword checking
        if let Ok(text) = node.utf8_text(&self.source_bytes) {
            keywords.iter().any(|&kw| text.contains(kw))
        } else {
            false
        }
    }

    fn extract_import_path(&self, _node: Node) -> Result<Option<String>> {
        // Language-specific import path extraction
        Ok(None)
    }

    fn extract_import_alias(&self, _node: Node) -> Result<Option<String>> {
        // Language-specific import alias extraction
        Ok(None)
    }

    fn extract_call_target(&self, _node: Node) -> Result<Option<String>> {
        // Extract function being called
        Ok(None)
    }

    fn extract_object_name(&self, _node: Node) -> Result<Option<String>> {
        // Extract object in member access
        Ok(None)
    }

    fn extract_member_name(&self, _node: Node) -> Result<Option<String>> {
        // Extract member in member access
        Ok(None)
    }

    fn is_part_of_declaration(&self, _node: Node) -> bool {
        // Check if identifier is part of declaration
        false
    }

    fn is_assignment_target(&self, _node: Node) -> Result<bool> {
        // Check if identifier is being assigned to
        Ok(false)
    }

    fn has_io_effects(&self, _node: Node) -> Result<bool> {
        // Check for IO operations
        Ok(false)
    }

    fn has_mutation_effects(&self, _node: Node) -> Result<bool> {
        // Check for state mutations
        Ok(false)
    }

    fn has_network_effects(&self, _node: Node) -> Result<bool> {
        // Check for network operations
        Ok(false)
    }

    fn is_async_operation(&self, _node: Node) -> Result<bool> {
        // Check for async operations
        Ok(false)
    }

    fn has_error_handling(&self, _node: Node) -> Result<bool> {
        // Check for error handling patterns
        Ok(false)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use tree_sitter::Parser;

    #[test]
    fn test_symbol_resolver_creation() {
        let resolver = SymbolResolver::new("rust".to_string(), "fn main() {}".to_string());
        assert_eq!(resolver.language, "rust");
        assert_eq!(resolver.symbols.len(), 0);
    }

    #[test]
    fn test_rust_function_resolution() {
        let code = r#"
pub fn hello_world() {
    println!("Hello, world!");
}
"#;

        let mut parser = Parser::new();
        parser.set_language(&tree_sitter_rust::language()).unwrap();
        let tree = parser.parse(code, None).unwrap();

        let mut resolver = SymbolResolver::new("rust".to_string(), code.to_string());
        let symbols = resolver.resolve_symbols(&tree).unwrap();

        // Should find the function declaration
        assert!(!symbols.is_empty());
        let func_symbol = symbols.iter().find(|s| s.kind == "function");
        assert!(func_symbol.is_some());
    }
}