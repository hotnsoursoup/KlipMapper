use std::collections::HashMap;
use std::path::Path;
use tree_sitter::{Language, Parser, Query, QueryCursor, Node, Tree};
use anyhow::Result;

use crate::core::language::{SupportedLanguage, LanguageQueryPatterns};
use crate::core::symbol_types::{Symbol, SymbolKind, SourceLocation, Visibility, Parameter, Field};

pub struct ModernTreeSitterEngine {
    parsers: HashMap<SupportedLanguage, Parser>,
    queries: HashMap<SupportedLanguage, LanguageQueries>,
    cursor: QueryCursor,
}

#[derive(Debug)]
pub struct LanguageQueries {
    pub classes: Query,
    pub functions: Query,
    pub methods: Query,
    pub imports: Query,
    pub exports: Query,
    pub variables: Query,
    pub types: Query,
    pub annotations: Query,
}

#[derive(Debug, Clone)]
pub struct ParsedSymbol {
    pub symbol: Symbol,
    pub raw_node: String, // For debugging
    pub node_kind: String,
    pub capture_name: String,
}

impl ModernTreeSitterEngine {
    pub fn new() -> Result<Self> {
        let mut engine = Self {
            parsers: HashMap::new(),
            queries: HashMap::new(),
            cursor: QueryCursor::new(),
        };
        
        // Initialize supported languages
        for language in [
            SupportedLanguage::Dart,
            SupportedLanguage::TypeScript,
            SupportedLanguage::JavaScript,
            SupportedLanguage::Python,
            SupportedLanguage::Rust,
            SupportedLanguage::Go,
            SupportedLanguage::Java,
        ] {
            engine.load_language(&language)?;
        }
        
        Ok(engine)
    }

    fn load_language(&mut self, language: &SupportedLanguage) -> Result<()> {
        // Initialize parser
        let mut parser = Parser::new();
        let tree_sitter_lang = language.get_tree_sitter_language()?;
        parser.set_language(&tree_sitter_lang)?;
        self.parsers.insert(*language, parser);

        // Load queries
        let query_patterns = language.get_query_patterns();
        let queries = LanguageQueries::from_patterns(&tree_sitter_lang, &query_patterns)?;
        self.queries.insert(*language, queries);

        Ok(())
    }

    pub async fn analyze_file(&mut self, path: &Path, content: &str) -> Result<FileParseResult> {
        let language = SupportedLanguage::from_path(path)
            .ok_or_else(|| anyhow::anyhow!("Unsupported file type: {}", path.display()))?;

        let parser = self.parsers.get_mut(&language)
            .ok_or_else(|| anyhow::anyhow!("Parser not available for language: {:?}", language))?;

        let tree = parser.parse(content, None)
            .ok_or_else(|| anyhow::anyhow!("Failed to parse file: {}", path.display()))?;

        tracing::debug!("Parsing file: {} with language: {:?}", path.display(), language);

        // Perform actual symbol extraction without borrowing self mutably
        let queries = &self.queries[&language];
        let mut symbols = Vec::new();
        
        // Extract different symbol types using separate cursor for each operation
        symbols.extend(Self::extract_classes_static(&tree, queries, content, path).await?);
        symbols.extend(Self::extract_functions_static(&tree, queries, content, path).await?);
        symbols.extend(Self::extract_methods_static(&tree, queries, content, path).await?);
        symbols.extend(Self::extract_variables_static(&tree, queries, content, path).await?);
        
        let imports = Self::extract_imports_static(&tree, queries, content, path).await?;
        let annotations = Self::extract_annotations_static(&tree, queries, content, path).await?;

        Ok(FileParseResult {
            path: path.to_path_buf(),
            language,
            symbols,
            imports,
            annotations,
            tree_sitter_tree: tree,
        })
    }

    async fn extract_classes_static(
        tree: &Tree,
        queries: &LanguageQueries,
        content: &str,
        file_path: &Path,
    ) -> Result<Vec<ParsedSymbol>> {
        let mut symbols = Vec::new();
        
        let mut cursor = tree_sitter::QueryCursor::new();
        let matches: Vec<_> = cursor.matches(&queries.classes, tree.root_node(), content.as_bytes()).collect();
        
        for match_ in matches {
            let mut class_name = None;
            let mut superclass = None;
            let mut location = None;

            for capture in match_.captures {
                let node = capture.node;
                let node_text = node.utf8_text(content.as_bytes())?;
                let capture_name = queries.classes.capture_names().get(capture.index as usize).unwrap();

                match *capture_name {
                    "class.name" => class_name = Some(node_text.to_string()),
                    "class.superclass" => superclass = Some(node_text.to_string()),
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

            if let (Some(name), Some(loc)) = (class_name, location) {
                let symbol_id = format!("{}::{}", file_path.to_string_lossy(), name);
                
                let symbol_kind = SymbolKind::Class {
                    is_abstract: false, // TODO: Detect from modifiers
                    superclass,
                    interfaces: Vec::new(), // TODO: Extract interfaces
                    is_generic: false, // TODO: Detect generics
                };

                let symbol = Symbol::new(symbol_id, name, symbol_kind, loc)
                    .with_visibility(Visibility::Public); // TODO: Detect actual visibility

                symbols.push(ParsedSymbol {
                    symbol,
                    raw_node: "class_definition".to_string(),
                    node_kind: "class".to_string(),
                    capture_name: "class.definition".to_string(),
                });
            }
        }

        Ok(symbols)
    }

    async fn extract_functions_static(
        tree: &Tree,
        queries: &LanguageQueries,
        content: &str,
        file_path: &Path,
    ) -> Result<Vec<ParsedSymbol>> {
        let mut symbols = Vec::new();
        
        let mut cursor = tree_sitter::QueryCursor::new();
        let matches: Vec<_> = cursor.matches(&queries.functions, tree.root_node(), content.as_bytes()).collect();
        
        for match_ in matches {
            let mut function_name = None;
            let mut parameters = Vec::new();
            let mut location = None;

            for capture in match_.captures {
                let node = capture.node;
                let node_text = node.utf8_text(content.as_bytes())?;
                let capture_name = queries.functions.capture_names().get(capture.index as usize).unwrap();

                match *capture_name {
                    "function.name" => function_name = Some(node_text.to_string()),
                    "function.params" => {
                        // TODO: Parse parameters properly
                        // TODO: Parse parameters properly - for now skip to avoid borrow checker issue
                        // parameters = self.parse_parameters(node, content)?;
                    }
                    "function.definition" => {
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

            if let (Some(name), Some(loc)) = (function_name, location) {
                let symbol_id = format!("{}::{}", file_path.to_string_lossy(), name);
                
                let symbol_kind = SymbolKind::Function {
                    is_async: false, // TODO: Detect async functions
                    parameters,
                    return_type: None, // TODO: Extract return type
                    is_generator: false, // TODO: Detect generators
                };

                let symbol = Symbol::new(symbol_id, name, symbol_kind, loc)
                    .with_visibility(Visibility::Public);

                symbols.push(ParsedSymbol {
                    symbol,
                    raw_node: "function_definition".to_string(),
                    node_kind: "function".to_string(),
                    capture_name: "function.definition".to_string(),
                });
            }
        }

        Ok(symbols)
    }

    async fn extract_methods_static(
        tree: &Tree,
        queries: &LanguageQueries,
        content: &str,
        file_path: &Path,
    ) -> Result<Vec<ParsedSymbol>> {
        let mut symbols = Vec::new();
        
        let mut cursor = tree_sitter::QueryCursor::new();
        let matches: Vec<_> = cursor.matches(&queries.methods, tree.root_node(), content.as_bytes()).collect();
        
        for match_ in matches {
            let mut method_name = None;
            let mut parameters = Vec::new();
            let mut location = None;

            for capture in match_.captures {
                let node = capture.node;
                let node_text = node.utf8_text(content.as_bytes())?;
                let capture_name = queries.methods.capture_names().get(capture.index as usize).unwrap();

                match *capture_name {
                    "method.name" => method_name = Some(node_text.to_string()),
                    "method.params" => {
                        // TODO: Parse parameters properly - for now skip to avoid borrow checker issue
                        // parameters = self.parse_parameters(node, content)?;
                    }
                    "method.definition" => {
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

            if let (Some(name), Some(loc)) = (method_name, location) {
                let symbol_id = format!("{}::{}", file_path.to_string_lossy(), name);
                
                let symbol_kind = SymbolKind::Method {
                    visibility: Visibility::Public, // TODO: Detect visibility
                    is_static: false, // TODO: Detect static methods
                    is_async: false, // TODO: Detect async methods
                    is_abstract: false, // TODO: Detect abstract methods
                    parameters,
                    return_type: None, // TODO: Extract return type
                };

                let symbol = Symbol::new(symbol_id, name, symbol_kind, loc)
                    .with_visibility(Visibility::Public);

                symbols.push(ParsedSymbol {
                    symbol,
                    raw_node: "method_definition".to_string(),
                    node_kind: "method".to_string(),
                    capture_name: "method.definition".to_string(),
                });
            }
        }

        Ok(symbols)
    }

    async fn extract_variables_static(
        tree: &Tree,
        queries: &LanguageQueries,
        content: &str,
        file_path: &Path,
    ) -> Result<Vec<ParsedSymbol>> {
        let mut symbols = Vec::new();
        
        let mut cursor = tree_sitter::QueryCursor::new();
        let matches: Vec<_> = cursor.matches(&queries.variables, tree.root_node(), content.as_bytes()).collect();
        
        for match_ in matches {
            let mut var_name = None;
            let mut var_type = None;
            let mut location = None;

            for capture in match_.captures {
                let node = capture.node;
                let node_text = node.utf8_text(content.as_bytes())?;
                let capture_name = queries.variables.capture_names().get(capture.index as usize).unwrap();

                match *capture_name {
                    "variable.name" => var_name = Some(node_text.to_string()),
                    "variable.type" => var_type = Some(node_text.to_string()),
                    "variable.definition" => {
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

            if let (Some(name), Some(loc)) = (var_name, location) {
                let symbol_id = format!("{}::{}", file_path.to_string_lossy(), name);
                
                let symbol_kind = SymbolKind::Variable {
                    var_type,
                    is_mutable: true, // TODO: Detect mutability
                    is_nullable: false, // TODO: Detect nullability
                };

                let symbol = Symbol::new(symbol_id, name, symbol_kind, loc)
                    .with_visibility(Visibility::Public);

                symbols.push(ParsedSymbol {
                    symbol,
                    raw_node: "variable_definition".to_string(),
                    node_kind: "variable".to_string(),
                    capture_name: "variable.definition".to_string(),
                });
            }
        }

        Ok(symbols)
    }

    async fn extract_imports_static(
        tree: &Tree,
        queries: &LanguageQueries,
        content: &str,
        file_path: &Path,
    ) -> Result<Vec<ImportInfo>> {
        let mut imports = Vec::new();
        
        let mut cursor = tree_sitter::QueryCursor::new();
        let matches: Vec<_> = cursor.matches(&queries.imports, tree.root_node(), content.as_bytes()).collect();
        
        for match_ in matches {
            let mut source = None;
            let mut items = Vec::new();
            let mut alias = None;
            let mut location = None;

            for capture in match_.captures {
                let node = capture.node;
                let node_text = node.utf8_text(content.as_bytes())?;
                let capture_name = queries.imports.capture_names().get(capture.index as usize).unwrap();

                match *capture_name {
                    "import.source" | "import.uri" | "import.library" | "import.path" => {
                        source = Some(node_text.trim_matches('"').to_string());
                    }
                    "import.alias" => {
                        alias = Some(node_text.to_string());
                    }
                    "import.show" | "import.clause" => {
                        // Parse import items - simplified for now
                        items.push(node_text.to_string());
                    }
                    "import" => {
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

            if let (Some(src), Some(loc)) = (source, location) {
                imports.push(ImportInfo {
                    source: src,
                    items: if items.is_empty() { vec!["*".to_string()] } else { items },
                    alias,
                    location: loc,
                });
            }
        }

        Ok(imports)
    }

    async fn extract_annotations_static(
        tree: &Tree,
        queries: &LanguageQueries,
        content: &str,
        file_path: &Path,
    ) -> Result<Vec<AnnotationInfo>> {
        let mut annotations = Vec::new();
        
        let mut cursor = tree_sitter::QueryCursor::new();
        let matches: Vec<_> = cursor.matches(&queries.annotations, tree.root_node(), content.as_bytes()).collect();
        
        for match_ in matches {
            let mut annotation_name = None;
            let mut arguments = std::collections::HashMap::new();
            let mut location = None;

            for capture in match_.captures {
                let node = capture.node;
                let node_text = node.utf8_text(content.as_bytes())?;
                let capture_name = queries.annotations.capture_names().get(capture.index as usize).unwrap();

                match *capture_name {
                    "annotation.name" => {
                        annotation_name = Some(node_text.to_string());
                    }
                    "annotation.args" => {
                        // Parse arguments - simplified for now
                        arguments.insert("raw_args".to_string(), node_text.to_string());
                    }
                    "annotation" => {
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

            if let (Some(name), Some(loc)) = (annotation_name, location) {
                annotations.push(AnnotationInfo {
                    name,
                    arguments,
                    location: loc,
                });
            }
        }

        Ok(annotations)
    }

    fn parse_parameters_static(node: Node, content: &str) -> Result<Vec<Parameter>> {
        let mut parameters = Vec::new();
        
        // Walk through parameter list nodes
        let mut cursor = node.walk();
        for child in node.children(&mut cursor) {
            if child.kind().contains("parameter") || child.kind().contains("arg") {
                let param_text = child.utf8_text(content.as_bytes())?;
                
                // Simple parameter parsing - can be enhanced per language
                let param_name = if let Some(name_child) = child.child_by_field_name("name") {
                    name_child.utf8_text(content.as_bytes())?
                } else {
                    param_text
                };
                
                let param_type = if let Some(type_child) = child.child_by_field_name("type") {
                    Some(type_child.utf8_text(content.as_bytes())?.to_string())
                } else {
                    None
                };
                
                parameters.push(Parameter {
                    name: param_name.to_string(),
                    param_type,
                    is_optional: param_text.contains('?'), // Basic nullable detection
                    default_value: None, // TODO: Extract default values
                    is_named: true, // Most parameters are named
                });
            }
        }
        
        Ok(parameters)
    }
}

impl LanguageQueries {
    fn from_patterns(language: &Language, patterns: &LanguageQueryPatterns) -> Result<Self> {
        Ok(Self {
            classes: Query::new(language, patterns.classes)?,
            functions: Query::new(language, patterns.functions)?,
            methods: Query::new(language, patterns.methods)?,
            imports: Query::new(language, patterns.imports)?,
            exports: Query::new(language, patterns.exports)?,
            variables: Query::new(language, patterns.variables)?,
            types: Query::new(language, patterns.types)?,
            annotations: Query::new(language, patterns.annotations)?,
        })
    }
}

#[derive(Debug)]
pub struct FileParseResult {
    pub path: std::path::PathBuf,
    pub language: SupportedLanguage,
    pub symbols: Vec<ParsedSymbol>,
    pub imports: Vec<ImportInfo>,
    pub annotations: Vec<AnnotationInfo>,
    pub tree_sitter_tree: Tree,
}

#[derive(Debug, Clone)]
pub struct ImportInfo {
    pub source: String,
    pub items: Vec<String>,
    pub alias: Option<String>,
    pub location: SourceLocation,
}

#[derive(Debug, Clone)]
pub struct AnnotationInfo {
    pub name: String,
    pub arguments: HashMap<String, String>,
    pub location: SourceLocation,
}