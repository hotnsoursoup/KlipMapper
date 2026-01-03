// Relationship analysis module - connects symbols through various relationships
// This module analyzes code relationships like imports, inheritance, composition, and usage

use std::collections::{HashMap, HashSet};
use std::path::{Path, PathBuf};
use anyhow::Result;
use dashmap::DashMap;
use tokio::sync::RwLock;
use std::sync::Arc;

use crate::core::symbol_types::{Symbol, SymbolKind, SourceLocation, RelationshipType, RelationshipData};
use crate::parsers::treesitter_engine::{FileParseResult, ImportInfo};

/// Information about inheritance relationships extracted from code
#[derive(Debug, Clone)]
pub struct InheritanceInfo {
    pub child_class: String,
    pub superclass: Option<String>,
    pub interfaces: Vec<String>,
    pub location: SourceLocation,
}

#[derive(Debug, Clone)]
pub struct RelationshipAnalyzer {
    // Cache for resolved relationships to avoid recomputation
    relationship_cache: Arc<DashMap<String, Vec<RelationshipData>>>,
    // Map of symbol IDs to their definitions
    symbol_registry: Arc<RwLock<HashMap<String, Symbol>>>,
    // Map of file paths to their parse results
    file_registry: Arc<RwLock<HashMap<PathBuf, FileParseResult>>>,
}

#[derive(Debug, Clone)]
pub struct RelationshipGraph {
    // Adjacency list representation of symbol relationships
    pub relationships: HashMap<String, Vec<RelationshipData>>,
    // Reverse lookup: which symbols depend on a given symbol
    pub dependents: HashMap<String, HashSet<String>>,
    // File-level dependencies
    pub file_dependencies: HashMap<PathBuf, HashSet<PathBuf>>,
    // Import resolution cache
    pub import_cache: HashMap<String, String>, // import_path -> resolved_symbol_id
}

#[derive(Debug, Clone)]
pub struct RelationshipAnalysisResult {
    pub relationships: Vec<RelationshipData>,
    pub dependency_graph: RelationshipGraph,
    pub circular_dependencies: Vec<CircularDependency>,
    pub unresolved_references: Vec<UnresolvedReference>,
    pub metrics: RelationshipMetrics,
}

#[derive(Debug, Clone)]
pub struct CircularDependency {
    pub cycle: Vec<String>, // Symbol IDs in the cycle
    pub dependency_type: RelationshipType,
    pub severity: DependencySeverity,
}

#[derive(Debug, Clone)]
pub struct UnresolvedReference {
    pub reference: String,
    pub location: SourceLocation,
    pub context: String, // Context where the reference appears
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum DependencySeverity {
    Low,    // Soft dependencies that can be broken
    Medium, // Important dependencies that should be reviewed
    High,   // Critical dependencies that indicate design issues
}

#[derive(Debug, Clone)]
pub struct RelationshipMetrics {
    pub total_relationships: usize,
    pub import_relationships: usize,
    pub inheritance_relationships: usize,
    pub composition_relationships: usize,
    pub usage_relationships: usize,
    pub circular_dependencies: usize,
    pub unresolved_references: usize,
    pub coupling_score: f32, // Higher = more coupled
    pub cohesion_score: f32, // Higher = more cohesive
}

impl RelationshipAnalyzer {
    pub fn new() -> Self {
        Self {
            relationship_cache: Arc::new(DashMap::new()),
            symbol_registry: Arc::new(RwLock::new(HashMap::new())),
            file_registry: Arc::new(RwLock::new(HashMap::new())),
        }
    }

    /// Register a file's parse results for relationship analysis
    pub async fn register_file(&self, file_result: FileParseResult) -> Result<()> {
        let file_path = file_result.path.clone();
        
        // Register all symbols from this file
        {
            let mut symbol_registry = self.symbol_registry.write().await;
            for parsed_symbol in &file_result.symbols {
                symbol_registry.insert(
                    parsed_symbol.symbol.id.clone(), 
                    parsed_symbol.symbol.clone()
                );
            }
        }

        // Register the file result
        {
            let mut file_registry = self.file_registry.write().await;
            file_registry.insert(file_path, file_result);
        }

        Ok(())
    }

    /// Analyze relationships across all registered files
    pub async fn analyze_relationships(&self) -> Result<RelationshipAnalysisResult> {
        let mut all_relationships = Vec::new();
        let mut dependency_graph = RelationshipGraph::new();
        let mut unresolved_references = Vec::new();

        // Get all registered files
        let file_paths: Vec<PathBuf> = {
            let file_registry = self.file_registry.read().await;
            file_registry.keys().cloned().collect()
        };

        // Analyze relationships for each file
        for file_path in &file_paths {
            let file_registry = self.file_registry.read().await;
            if let Some(file_result) = file_registry.get(file_path) {
                // Analyze import relationships
                let import_relationships = self.analyze_import_relationships(file_path, &file_result.imports).await?;
                all_relationships.extend(import_relationships);

                // Analyze inheritance relationships
                let inheritance_relationships = self.analyze_inheritance_relationships(file_result).await?;
                all_relationships.extend(inheritance_relationships);

                // Analyze usage relationships
                let (usage_relationships, file_unresolved) = self.analyze_usage_relationships(file_result).await?;
                all_relationships.extend(usage_relationships);
                unresolved_references.extend(file_unresolved);
            }
        }

        // Build dependency graph
        for relationship in &all_relationships {
            dependency_graph.add_relationship(relationship.clone());
        }

        // Detect circular dependencies
        let circular_dependencies = self.detect_circular_dependencies(&dependency_graph).await?;

        // Calculate metrics
        let metrics = self.calculate_metrics(&all_relationships, &circular_dependencies, &unresolved_references);

        Ok(RelationshipAnalysisResult {
            relationships: all_relationships,
            dependency_graph,
            circular_dependencies,
            unresolved_references,
            metrics,
        })
    }

    /// Analyze import relationships from import statements
    async fn analyze_import_relationships(
        &self,
        file_path: &Path,
        imports: &[ImportInfo],
    ) -> Result<Vec<RelationshipData>> {
        let mut relationships = Vec::new();

        for import in imports {
            // Try to resolve the import to actual symbols
            if let Some(resolved_symbols) = self.resolve_import(&import.source).await? {
                for symbol_id in resolved_symbols {
                    let relationship = RelationshipData {
                        from_symbol: format!("file:{}", file_path.to_string_lossy()),
                        to_symbol: symbol_id,
                        relationship_type: RelationshipType::Import,
                        location: import.location.clone(),
                        metadata: {
                            let mut meta = HashMap::new();
                            meta.insert("import_source".to_string(), import.source.clone());
                            if let Some(alias) = &import.alias {
                                meta.insert("alias".to_string(), alias.clone());
                            }
                            meta
                        },
                    };
                    relationships.push(relationship);
                }
            }
        }

        Ok(relationships)
    }

    /// Analyze inheritance relationships from class definitions using TreeSitter AST
    async fn analyze_inheritance_relationships(
        &self,
        file_result: &FileParseResult,
    ) -> Result<Vec<RelationshipData>> {
        let mut relationships = Vec::new();

        // Use TreeSitter to extract inheritance patterns from the actual AST
        let inheritance_data = self.extract_inheritance_from_treesitter(&file_result.tree_sitter_tree, file_result).await?;
        
        for inheritance_info in inheritance_data {
            // Create relationship for superclass (extends/inherits)
            if let Some(superclass) = &inheritance_info.superclass {
                let relationship = RelationshipData {
                    from_symbol: inheritance_info.child_class.clone(),
                    to_symbol: superclass.clone(),
                    relationship_type: RelationshipType::Inherits,
                    location: inheritance_info.location.clone(),
                    metadata: {
                        let mut meta = HashMap::new();
                        meta.insert("inheritance_type".to_string(), "extends".to_string());
                        meta.insert("language".to_string(), file_result.language.as_str().to_string());
                        meta
                    },
                };
                relationships.push(relationship);
            }

            // Create relationships for interfaces/traits (implements)
            for interface in &inheritance_info.interfaces {
                let relationship = RelationshipData {
                    from_symbol: inheritance_info.child_class.clone(),
                    to_symbol: interface.clone(),
                    relationship_type: RelationshipType::Implements,
                    location: inheritance_info.location.clone(),
                    metadata: {
                        let mut meta = HashMap::new();
                        meta.insert("inheritance_type".to_string(), "implements".to_string());
                        meta.insert("language".to_string(), file_result.language.as_str().to_string());
                        meta
                    },
                };
                relationships.push(relationship);
            }
        }

        Ok(relationships)
    }

    /// Extract inheritance information from TreeSitter AST for all supported languages
    async fn extract_inheritance_from_treesitter(
        &self,
        tree: &tree_sitter::Tree,
        file_result: &FileParseResult,
    ) -> Result<Vec<InheritanceInfo>> {
        use crate::core::language::SupportedLanguage;
        
        let mut inheritance_infos = Vec::new();
        
        // For testing, we'll create simple inheritance data from existing symbol data
        // In production, this would read file content and use TreeSitter parsing
        if !file_result.path.exists() {
            // Mock inheritance analysis for testing
            return self.extract_inheritance_from_symbols(file_result).await;
        }
        
        let file_content = std::fs::read(&file_result.path)?;
        let content = std::str::from_utf8(&file_content)?;
        
        match file_result.language {
            SupportedLanguage::Dart => {
                inheritance_infos.extend(self.extract_dart_inheritance(tree, content, &file_result.path).await?);
            }
            SupportedLanguage::TypeScript | SupportedLanguage::JavaScript => {
                inheritance_infos.extend(self.extract_js_ts_inheritance(tree, content, &file_result.path).await?);
            }
            SupportedLanguage::Python => {
                inheritance_infos.extend(self.extract_python_inheritance(tree, content, &file_result.path).await?);
            }
            SupportedLanguage::Rust => {
                inheritance_infos.extend(self.extract_rust_inheritance(tree, content, &file_result.path).await?);
            }
            SupportedLanguage::Go => {
                inheritance_infos.extend(self.extract_go_inheritance(tree, content, &file_result.path).await?);
            }
            SupportedLanguage::Java => {
                inheritance_infos.extend(self.extract_java_inheritance(tree, content, &file_result.path).await?);
            }
        }

        Ok(inheritance_infos)
    }

    /// Extract inheritance information from already parsed symbols (for testing)
    async fn extract_inheritance_from_symbols(
        &self,
        file_result: &FileParseResult,
    ) -> Result<Vec<InheritanceInfo>> {
        let mut inheritance_infos = Vec::new();
        
        for parsed_symbol in &file_result.symbols {
            if let SymbolKind::Class { superclass, interfaces, .. } = &parsed_symbol.symbol.kind {
                let inheritance_info = InheritanceInfo {
                    child_class: parsed_symbol.symbol.id.clone(),
                    superclass: superclass.clone(),
                    interfaces: interfaces.clone(),
                    location: parsed_symbol.symbol.location.clone(),
                };
                inheritance_infos.push(inheritance_info);
            }
        }
        
        Ok(inheritance_infos)
    }

    /// Extract Dart inheritance patterns (extends, implements, with)
    async fn extract_dart_inheritance(
        &self,
        tree: &tree_sitter::Tree,
        content: &str,
        file_path: &std::path::Path,
    ) -> Result<Vec<InheritanceInfo>> {
        let mut inheritance_infos = Vec::new();
        let mut cursor = tree_sitter::QueryCursor::new();
        
        // TreeSitter query for Dart class definitions with inheritance
        let language = tree_sitter_dart::language();
        let query = tree_sitter::Query::new(&language, r#"
            (class_definition
              name: (type_identifier) @class.name
              superclass: (superclass 
                (type_identifier) @superclass.name)?
              interfaces: (interfaces 
                (type_list 
                  (type_identifier) @interface.name)*)?
            ) @class.definition
        "#)?;

        let matches: Vec<_> = cursor.matches(&query, tree.root_node(), content.as_bytes()).collect();

        for match_ in matches {
            let mut class_name = None;
            let mut superclass = None;
            let mut interfaces = Vec::new();
            let mut location = None;

            for capture in match_.captures {
                let node = capture.node;
                let capture_name = query.capture_names().get(capture.index as usize).unwrap();
                
                match *capture_name {
                    "class.name" => {
                        if let Ok(name) = node.utf8_text(content.as_bytes()) {
                            class_name = Some(format!("{}::{}", file_path.to_string_lossy(), name));
                        }
                    }
                    "superclass.name" => {
                        if let Ok(name) = node.utf8_text(content.as_bytes()) {
                            superclass = Some(name.to_string());
                        }
                    }
                    "interface.name" => {
                        if let Ok(name) = node.utf8_text(content.as_bytes()) {
                            interfaces.push(name.to_string());
                        }
                    }
                    "class.definition" => {
                        location = Some(SourceLocation {
                            file_path: file_path.to_path_buf(),
                            start_line: node.start_position().row as u32 + 1,
                            start_column: node.start_position().column as u32,
                            end_line: node.end_position().row as u32 + 1,
                            end_column: node.end_position().column as u32,
                            byte_offset: node.start_byte() as u32,
                            byte_length: (node.end_byte() - node.start_byte()) as u32,
                        });
                    }
                    _ => {}
                }
            }

            if let (Some(class_name), Some(location)) = (class_name, location) {
                inheritance_infos.push(InheritanceInfo {
                    child_class: class_name,
                    superclass,
                    interfaces,
                    location,
                });
            }
        }

        Ok(inheritance_infos)
    }

    /// Extract TypeScript/JavaScript inheritance patterns (extends, implements)
    async fn extract_js_ts_inheritance(
        &self,
        tree: &tree_sitter::Tree,
        content: &str,
        file_path: &std::path::Path,
    ) -> Result<Vec<InheritanceInfo>> {
        let mut inheritance_infos = Vec::new();
        let mut cursor = tree_sitter::QueryCursor::new();
        
        // TreeSitter query for TS/JS class definitions with inheritance
        let language = tree_sitter_typescript::language_typescript();
        let query = tree_sitter::Query::new(&language, r#"
            (class_declaration
              name: (type_identifier) @class.name
              superclass: (extends_clause 
                (identifier) @superclass.name)?
              implements: (implements_clause 
                (identifier) @interface.name)*
            ) @class.definition
        "#)?;

        let matches: Vec<_> = cursor.matches(&query, tree.root_node(), content.as_bytes()).collect();

        for match_ in matches {
            let mut class_name = None;
            let mut superclass = None;
            let mut interfaces = Vec::new();
            let mut location = None;

            for capture in match_.captures {
                let node = capture.node;
                let capture_name = query.capture_names().get(capture.index as usize).unwrap();
                
                match *capture_name {
                    "class.name" => {
                        if let Ok(name) = node.utf8_text(content.as_bytes()) {
                            class_name = Some(format!("{}::{}", file_path.to_string_lossy(), name));
                        }
                    }
                    "superclass.name" => {
                        if let Ok(name) = node.utf8_text(content.as_bytes()) {
                            superclass = Some(name.to_string());
                        }
                    }
                    "interface.name" => {
                        if let Ok(name) = node.utf8_text(content.as_bytes()) {
                            interfaces.push(name.to_string());
                        }
                    }
                    "class.definition" => {
                        location = Some(SourceLocation {
                            file_path: file_path.to_path_buf(),
                            start_line: node.start_position().row as u32 + 1,
                            start_column: node.start_position().column as u32,
                            end_line: node.end_position().row as u32 + 1,
                            end_column: node.end_position().column as u32,
                            byte_offset: node.start_byte() as u32,
                            byte_length: (node.end_byte() - node.start_byte()) as u32,
                        });
                    }
                    _ => {}
                }
            }

            if let (Some(class_name), Some(location)) = (class_name, location) {
                inheritance_infos.push(InheritanceInfo {
                    child_class: class_name,
                    superclass,
                    interfaces,
                    location,
                });
            }
        }

        Ok(inheritance_infos)
    }

    /// Extract Python inheritance patterns (class inheritance via parentheses)
    async fn extract_python_inheritance(
        &self,
        tree: &tree_sitter::Tree,
        content: &str,
        file_path: &std::path::Path,
    ) -> Result<Vec<InheritanceInfo>> {
        let mut inheritance_infos = Vec::new();
        let mut cursor = tree_sitter::QueryCursor::new();
        
        // TreeSitter query for Python class definitions with inheritance
        let language = tree_sitter_python::language();
        let query = tree_sitter::Query::new(&language, r#"
            (class_definition
              name: (identifier) @class.name
              superclasses: (argument_list 
                (identifier) @parent.name)*
            ) @class.definition
        "#)?;

        let matches: Vec<_> = cursor.matches(&query, tree.root_node(), content.as_bytes()).collect();

        for match_ in matches {
            let mut class_name = None;
            let mut parents = Vec::new();
            let mut location = None;

            for capture in match_.captures {
                let node = capture.node;
                let capture_name = query.capture_names().get(capture.index as usize).unwrap();
                
                match *capture_name {
                    "class.name" => {
                        if let Ok(name) = node.utf8_text(content.as_bytes()) {
                            class_name = Some(format!("{}::{}", file_path.to_string_lossy(), name));
                        }
                    }
                    "parent.name" => {
                        if let Ok(name) = node.utf8_text(content.as_bytes()) {
                            parents.push(name.to_string());
                        }
                    }
                    "class.definition" => {
                        location = Some(SourceLocation {
                            file_path: file_path.to_path_buf(),
                            start_line: node.start_position().row as u32 + 1,
                            start_column: node.start_position().column as u32,
                            end_line: node.end_position().row as u32 + 1,
                            end_column: node.end_position().column as u32,
                            byte_offset: node.start_byte() as u32,
                            byte_length: (node.end_byte() - node.start_byte()) as u32,
                        });
                    }
                    _ => {}
                }
            }

            if let (Some(class_name), Some(location)) = (class_name, location) {
                // In Python, all parents are treated as superclasses (multiple inheritance)
                let superclass = parents.get(0).cloned();
                let interfaces = if parents.len() > 1 { parents[1..].to_vec() } else { Vec::new() };
                
                inheritance_infos.push(InheritanceInfo {
                    child_class: class_name,
                    superclass,
                    interfaces,
                    location,
                });
            }
        }

        Ok(inheritance_infos)
    }

    /// Extract Rust inheritance patterns (trait implementation)
    async fn extract_rust_inheritance(
        &self,
        tree: &tree_sitter::Tree,
        content: &str,
        file_path: &std::path::Path,
    ) -> Result<Vec<InheritanceInfo>> {
        let mut inheritance_infos = Vec::new();
        let mut cursor = tree_sitter::QueryCursor::new();
        
        // TreeSitter query for Rust impl blocks
        let language = tree_sitter_rust::language();
        let query = tree_sitter::Query::new(&language, r#"
            (impl_item
              trait: (type_identifier) @trait.name
              type: (type_identifier) @impl.type
            ) @impl.definition
        "#)?;

        let matches: Vec<_> = cursor.matches(&query, tree.root_node(), content.as_bytes()).collect();

        for match_ in matches {
            let mut trait_name = None;
            let mut type_name = None;
            let mut location = None;

            for capture in match_.captures {
                let node = capture.node;
                let capture_name = query.capture_names().get(capture.index as usize).unwrap();
                
                match *capture_name {
                    "trait.name" => {
                        if let Ok(name) = node.utf8_text(content.as_bytes()) {
                            trait_name = Some(name.to_string());
                        }
                    }
                    "impl.type" => {
                        if let Ok(name) = node.utf8_text(content.as_bytes()) {
                            type_name = Some(format!("{}::{}", file_path.to_string_lossy(), name));
                        }
                    }
                    "impl.definition" => {
                        location = Some(SourceLocation {
                            file_path: file_path.to_path_buf(),
                            start_line: node.start_position().row as u32 + 1,
                            start_column: node.start_position().column as u32,
                            end_line: node.end_position().row as u32 + 1,
                            end_column: node.end_position().column as u32,
                            byte_offset: node.start_byte() as u32,
                            byte_length: (node.end_byte() - node.start_byte()) as u32,
                        });
                    }
                    _ => {}
                }
            }

            if let (Some(type_name), Some(trait_name), Some(location)) = (type_name, trait_name, location) {
                // In Rust, trait implementation is like interface implementation
                inheritance_infos.push(InheritanceInfo {
                    child_class: type_name,
                    superclass: None, // Rust doesn't have class inheritance
                    interfaces: vec![trait_name],
                    location,
                });
            }
        }

        Ok(inheritance_infos)
    }

    /// Extract Go inheritance patterns (interface implementation and struct embedding)
    async fn extract_go_inheritance(
        &self,
        tree: &tree_sitter::Tree,
        content: &str,
        file_path: &std::path::Path,
    ) -> Result<Vec<InheritanceInfo>> {
        let mut inheritance_infos = Vec::new();
        let mut cursor = tree_sitter::QueryCursor::new();
        
        // TreeSitter query for Go struct embedding
        let language = tree_sitter_go::language();
        let query = tree_sitter::Query::new(&language, r#"
            (type_declaration
              (type_spec
                name: (type_identifier) @struct.name
                type: (struct_type
                  (field_declaration_list
                    (field_declaration
                      type: (type_identifier) @embedded.type
                    )*
                  )
                )
              )
            ) @struct.definition
        "#)?;

        let matches: Vec<_> = cursor.matches(&query, tree.root_node(), content.as_bytes()).collect();

        for match_ in matches {
            let mut struct_name = None;
            let mut embedded_types = Vec::new();
            let mut location = None;

            for capture in match_.captures {
                let node = capture.node;
                let capture_name = query.capture_names().get(capture.index as usize).unwrap();
                
                match *capture_name {
                    "struct.name" => {
                        if let Ok(name) = node.utf8_text(content.as_bytes()) {
                            struct_name = Some(format!("{}::{}", file_path.to_string_lossy(), name));
                        }
                    }
                    "embedded.type" => {
                        if let Ok(name) = node.utf8_text(content.as_bytes()) {
                            embedded_types.push(name.to_string());
                        }
                    }
                    "struct.definition" => {
                        location = Some(SourceLocation {
                            file_path: file_path.to_path_buf(),
                            start_line: node.start_position().row as u32 + 1,
                            start_column: node.start_position().column as u32,
                            end_line: node.end_position().row as u32 + 1,
                            end_column: node.end_position().column as u32,
                            byte_offset: node.start_byte() as u32,
                            byte_length: (node.end_byte() - node.start_byte()) as u32,
                        });
                    }
                    _ => {}
                }
            }

            if let (Some(struct_name), Some(location)) = (struct_name, location) {
                if !embedded_types.is_empty() {
                    // In Go, struct embedding is composition-like inheritance
                    let superclass = embedded_types.get(0).cloned();
                    let interfaces = if embedded_types.len() > 1 { embedded_types[1..].to_vec() } else { Vec::new() };
                    
                    inheritance_infos.push(InheritanceInfo {
                        child_class: struct_name,
                        superclass,
                        interfaces,
                        location,
                    });
                }
            }
        }

        Ok(inheritance_infos)
    }

    /// Extract Java inheritance patterns (extends, implements)
    async fn extract_java_inheritance(
        &self,
        tree: &tree_sitter::Tree,
        content: &str,
        file_path: &std::path::Path,
    ) -> Result<Vec<InheritanceInfo>> {
        let mut inheritance_infos = Vec::new();
        let mut cursor = tree_sitter::QueryCursor::new();
        
        // TreeSitter query for Java class definitions with inheritance
        let language = tree_sitter_java::language();
        let query = tree_sitter::Query::new(&language, r#"
            (class_declaration
              name: (identifier) @class.name
              superclass: (superclass 
                (type_identifier) @superclass.name)?
              interfaces: (super_interfaces
                (interface_type_list
                  (type_identifier) @interface.name)*)?
            ) @class.definition
        "#)?;

        let matches: Vec<_> = cursor.matches(&query, tree.root_node(), content.as_bytes()).collect();

        for match_ in matches {
            let mut class_name = None;
            let mut superclass = None;
            let mut interfaces = Vec::new();
            let mut location = None;

            for capture in match_.captures {
                let node = capture.node;
                let capture_name = query.capture_names().get(capture.index as usize).unwrap();
                
                match *capture_name {
                    "class.name" => {
                        if let Ok(name) = node.utf8_text(content.as_bytes()) {
                            class_name = Some(format!("{}::{}", file_path.to_string_lossy(), name));
                        }
                    }
                    "superclass.name" => {
                        if let Ok(name) = node.utf8_text(content.as_bytes()) {
                            superclass = Some(name.to_string());
                        }
                    }
                    "interface.name" => {
                        if let Ok(name) = node.utf8_text(content.as_bytes()) {
                            interfaces.push(name.to_string());
                        }
                    }
                    "class.definition" => {
                        location = Some(SourceLocation {
                            file_path: file_path.to_path_buf(),
                            start_line: node.start_position().row as u32 + 1,
                            start_column: node.start_position().column as u32,
                            end_line: node.end_position().row as u32 + 1,
                            end_column: node.end_position().column as u32,
                            byte_offset: node.start_byte() as u32,
                            byte_length: (node.end_byte() - node.start_byte()) as u32,
                        });
                    }
                    _ => {}
                }
            }

            if let (Some(class_name), Some(location)) = (class_name, location) {
                inheritance_infos.push(InheritanceInfo {
                    child_class: class_name,
                    superclass,
                    interfaces,
                    location,
                });
            }
        }

        Ok(inheritance_infos)
    }

    /// Analyze usage relationships (method calls, field access, etc.)
    async fn analyze_usage_relationships(
        &self,
        _file_result: &FileParseResult,
    ) -> Result<(Vec<RelationshipData>, Vec<UnresolvedReference>)> {
        // TODO: Implement usage relationship analysis
        // This would involve analyzing the TreeSitter AST for:
        // - Method calls
        // - Field access
        // - Constructor calls
        // - Variable references
        
        Ok((Vec::new(), Vec::new()))
    }

    /// Resolve an import path to actual symbol IDs
    async fn resolve_import(&self, import_path: &str) -> Result<Option<Vec<String>>> {
        // TODO: Implement import resolution logic
        // This would involve:
        // 1. Resolving relative/absolute paths
        // 2. Looking up symbols in the target file
        // 3. Handling different import styles (named, default, wildcard)
        
        // For now, return None to indicate unresolved
        let _ = import_path; // Suppress unused warning
        Ok(None)
    }

    /// Resolve a symbol reference to its actual symbol ID
    async fn resolve_symbol_reference(&self, reference: &str, _context_file: &Path) -> Result<Option<String>> {
        // TODO: Implement symbol reference resolution
        // This would involve:
        // 1. Looking up symbols in the current file
        // 2. Looking up imported symbols
        // 3. Handling scoped references
        
        // For now, return None to indicate unresolved
        let _ = reference; // Suppress unused warning
        Ok(None)
    }

    /// Detect circular dependencies in the relationship graph
    pub async fn detect_circular_dependencies(&self, graph: &RelationshipGraph) -> Result<Vec<CircularDependency>> {
        let mut cycles = Vec::new();
        let mut visited = HashSet::new();
        let mut rec_stack = HashSet::new();

        // Perform DFS to detect cycles
        for symbol_id in graph.relationships.keys() {
            if !visited.contains(symbol_id) {
                self.detect_cycle_dfs(
                    symbol_id,
                    graph,
                    &mut visited,
                    &mut rec_stack,
                    &mut Vec::new(),
                    &mut cycles,
                );
            }
        }

        Ok(cycles)
    }

    /// DFS helper for cycle detection
    fn detect_cycle_dfs(
        &self,
        current: &str,
        graph: &RelationshipGraph,
        visited: &mut HashSet<String>,
        rec_stack: &mut HashSet<String>,
        path: &mut Vec<String>,
        cycles: &mut Vec<CircularDependency>,
    ) {
        visited.insert(current.to_string());
        rec_stack.insert(current.to_string());
        path.push(current.to_string());

        if let Some(relationships) = graph.relationships.get(current) {
            for relationship in relationships {
                let target = &relationship.to_symbol;
                
                if !visited.contains(target) {
                    self.detect_cycle_dfs(target, graph, visited, rec_stack, path, cycles);
                } else if rec_stack.contains(target) {
                    // Found a cycle
                    let cycle_start = path.iter().position(|x| x == target).unwrap();
                    let cycle = path[cycle_start..].to_vec();
                    
                    let severity = match relationship.relationship_type {
                        RelationshipType::Import => DependencySeverity::Medium,
                        RelationshipType::Inherits | RelationshipType::Implements => DependencySeverity::High,
                        _ => DependencySeverity::Low,
                    };

                    cycles.push(CircularDependency {
                        cycle,
                        dependency_type: relationship.relationship_type.clone(),
                        severity,
                    });
                }
            }
        }

        path.pop();
        rec_stack.remove(current);
    }

    /// Calculate relationship metrics
    pub fn calculate_metrics(
        &self,
        relationships: &[RelationshipData],
        circular_dependencies: &[CircularDependency],
        unresolved_references: &[UnresolvedReference],
    ) -> RelationshipMetrics {
        let mut import_count = 0;
        let mut inheritance_count = 0;
        let mut composition_count = 0;
        let mut usage_count = 0;

        for relationship in relationships {
            match relationship.relationship_type {
                RelationshipType::Import => import_count += 1,
                RelationshipType::Inherits | RelationshipType::Implements => inheritance_count += 1,
                RelationshipType::Composition | RelationshipType::Aggregation => composition_count += 1,
                RelationshipType::Uses | RelationshipType::Calls => usage_count += 1,
                _ => {}
            }
        }

        // Calculate coupling score (simplified)
        let coupling_score = relationships.len() as f32 / 100.0; // Normalize to reasonable range

        // Calculate cohesion score (simplified)
        let cohesion_score = 1.0 - (circular_dependencies.len() as f32 / relationships.len().max(1) as f32);

        RelationshipMetrics {
            total_relationships: relationships.len(),
            import_relationships: import_count,
            inheritance_relationships: inheritance_count,
            composition_relationships: composition_count,
            usage_relationships: usage_count,
            circular_dependencies: circular_dependencies.len(),
            unresolved_references: unresolved_references.len(),
            coupling_score,
            cohesion_score,
        }
    }
}

impl RelationshipGraph {
    pub fn new() -> Self {
        Self {
            relationships: HashMap::new(),
            dependents: HashMap::new(),
            file_dependencies: HashMap::new(),
            import_cache: HashMap::new(),
        }
    }

    /// Add a relationship to the graph
    pub fn add_relationship(&mut self, relationship: RelationshipData) {
        // Add to forward relationships
        self.relationships
            .entry(relationship.from_symbol.clone())
            .or_insert_with(Vec::new)
            .push(relationship.clone());

        // Add to reverse dependencies
        self.dependents
            .entry(relationship.to_symbol.clone())
            .or_insert_with(HashSet::new)
            .insert(relationship.from_symbol.clone());
    }

    /// Get all relationships from a symbol
    pub fn get_relationships(&self, symbol_id: &str) -> Option<&Vec<RelationshipData>> {
        self.relationships.get(symbol_id)
    }

    /// Get all symbols that depend on a given symbol
    pub fn get_dependents(&self, symbol_id: &str) -> Option<&HashSet<String>> {
        self.dependents.get(symbol_id)
    }
}

impl Default for RelationshipAnalyzer {
    fn default() -> Self {
        Self::new()
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::core::symbol_types::{SourceLocation, Visibility};
    use crate::parsers::treesitter_engine::ParsedSymbol;
    use std::path::PathBuf;

    #[tokio::test]
    async fn test_relationship_analyzer_creation() {
        let analyzer = RelationshipAnalyzer::new();
        assert!(analyzer.relationship_cache.is_empty());
    }

    #[tokio::test]
    async fn test_register_file() {
        let analyzer = RelationshipAnalyzer::new();
        
        // Create a test symbol
        let location = SourceLocation {
            file_path: PathBuf::from("test.dart"),
            start_line: 1,
            start_column: 1,
            end_line: 10,
            end_column: 1,
            byte_offset: 0,
            byte_length: 100,
        };

        let symbol = Symbol::new(
            "test::TestClass".to_string(),
            "TestClass".to_string(),
            SymbolKind::Class {
                is_abstract: false,
                superclass: None,
                interfaces: Vec::new(),
                is_generic: false,
            },
            location.clone(),
        );

        let parsed_symbol = ParsedSymbol {
            symbol,
            raw_node: "class_definition".to_string(),
            node_kind: "class".to_string(),
            capture_name: "class.definition".to_string(),
        };

        let file_result = FileParseResult {
            path: PathBuf::from("test.dart"),
            language: crate::core::language::SupportedLanguage::Dart,
            symbols: vec![parsed_symbol],
            imports: Vec::new(),
            annotations: Vec::new(),
            tree_sitter_tree: {
                // Create a minimal valid tree for testing
                let mut parser = tree_sitter::Parser::new();
                parser.set_language(&tree_sitter_dart::language()).unwrap();
                parser.parse("class Test {}", None).unwrap()
            },
        };

        let result = analyzer.register_file(file_result).await;
        assert!(result.is_ok());

        // Verify symbol was registered
        let symbol_registry = analyzer.symbol_registry.read().await;
        assert!(symbol_registry.contains_key("test::TestClass"));
    }

    #[tokio::test]
    async fn test_relationship_graph() {
        let mut graph = RelationshipGraph::new();
        
        let relationship = RelationshipData {
            from_symbol: "ClassA".to_string(),
            to_symbol: "ClassB".to_string(),
            relationship_type: RelationshipType::Inherits,
            location: SourceLocation {
                file_path: PathBuf::from("test.dart"),
                start_line: 5,
                start_column: 1,
                end_line: 5,
                end_column: 20,
                byte_offset: 100,
                byte_length: 20,
            },
            metadata: HashMap::new(),
        };

        graph.add_relationship(relationship);

        // Test forward relationship
        assert!(graph.get_relationships("ClassA").is_some());
        assert_eq!(graph.get_relationships("ClassA").unwrap().len(), 1);

        // Test reverse dependency
        assert!(graph.get_dependents("ClassB").is_some());
        assert!(graph.get_dependents("ClassB").unwrap().contains("ClassA"));
    }

    #[tokio::test]
    async fn test_circular_dependency_detection() {
        let analyzer = RelationshipAnalyzer::new();
        let mut graph = RelationshipGraph::new();

        // Create a circular dependency: A -> B -> A
        let rel1 = RelationshipData {
            from_symbol: "A".to_string(),
            to_symbol: "B".to_string(),
            relationship_type: RelationshipType::Import,
            location: SourceLocation {
                file_path: PathBuf::from("a.dart"),
                start_line: 1,
                start_column: 1,
                end_line: 1,
                end_column: 10,
                byte_offset: 0,
                byte_length: 10,
            },
            metadata: HashMap::new(),
        };

        let rel2 = RelationshipData {
            from_symbol: "B".to_string(),
            to_symbol: "A".to_string(),
            relationship_type: RelationshipType::Import,
            location: SourceLocation {
                file_path: PathBuf::from("b.dart"),
                start_line: 1,
                start_column: 1,
                end_line: 1,
                end_column: 10,
                byte_offset: 0,
                byte_length: 10,
            },
            metadata: HashMap::new(),
        };

        graph.add_relationship(rel1);
        graph.add_relationship(rel2);

        let cycles = analyzer.detect_circular_dependencies(&graph).await.unwrap();
        assert!(!cycles.is_empty());
        assert_eq!(cycles[0].dependency_type, RelationshipType::Import);
    }

    #[test]
    fn test_relationship_metrics_calculation() {
        let analyzer = RelationshipAnalyzer::new();
        
        let relationships = vec![
            RelationshipData {
                from_symbol: "A".to_string(),
                to_symbol: "B".to_string(),
                relationship_type: RelationshipType::Import,
                location: SourceLocation {
                    file_path: PathBuf::from("test.dart"),
                    start_line: 1,
                    start_column: 1,
                    end_line: 1,
                    end_column: 10,
                    byte_offset: 0,
                    byte_length: 10,
                },
                metadata: HashMap::new(),
            }
        ];

        let circular_deps = Vec::new();
        let unresolved_refs = Vec::new();

        let metrics = analyzer.calculate_metrics(&relationships, &circular_deps, &unresolved_refs);
        
        assert_eq!(metrics.total_relationships, 1);
        assert_eq!(metrics.import_relationships, 1);
        assert_eq!(metrics.circular_dependencies, 0);
        assert!(metrics.coupling_score > 0.0);
        assert!(metrics.cohesion_score <= 1.0);
    }
}