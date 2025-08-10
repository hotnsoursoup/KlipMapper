# AgentMap 2025 Modernization & Refactor Roadmap

**Document Version:** 1.0  
**Date:** August 10, 2025  
**Status:** Draft  
**Author:** Analysis via Claude Code  

## Executive Summary

AgentMap shows promise as a code architecture analysis tool but requires comprehensive modernization to meet 2025 standards. Current implementation has fundamental parsing issues, outdated dependencies, and architectural limitations that prevent reliable code analysis. This document outlines a systematic refactor approach to create a robust, efficient, and modern code analysis platform.

## Current State Analysis

### Project Structure Overview
```
agentmap/
├── src/
│   ├── cli.rs                    # CLI interface and command handling
│   ├── adapters/                 # Language-specific adapters
│   ├── anchor.rs                 # Symbol annotation system
│   ├── architecture_exporter.rs  # Architecture export functionality
│   ├── config.rs                 # Configuration management
│   ├── query_pack.rs             # TreeSitter query management
│   ├── symbol_resolver.rs        # Symbol resolution logic
│   ├── symbol_table.rs           # Symbol storage and indexing
│   ├── scope_tracker.rs          # Code scope tracking
│   ├── wildcard_matcher.rs       # Pattern matching utilities
│   ├── watcher.rs                # File system watching
│   └── export_formats.rs         # Output format handling
├── Cargo.toml                    # Project dependencies
└── examples/                     # Test cases and examples
```

### Critical Issues Identified

#### 1. TreeSitter Integration Problems
**Severity: CRITICAL**

**Current State:**
- Using TreeSitter 0.22.6 (outdated by 2+ major versions)
- Poor symbol classification - everything marked as "function"
- Missing language-specific parsing logic
- No proper AST traversal patterns

**Evidence:**
```yaml
# From POS scan results - main.yaml
symbols:
- kind: function  # Should be "main_function" or "entry_point"
  name: main
- kind: function  # Should be "class_constructor" or "object_creation"
  name: WidgetsFlutterBinding
```

**Files Affected:**
- `src/adapters/treesitter.rs:45-67` - Core parsing logic
- `src/symbol_resolver.rs:51-86` - Symbol classification
- All language grammar dependencies in `Cargo.toml`

#### 2. Architecture Export Failures
**Severity: HIGH**

**Current State:**
- JSON exports show `symbols_count: 0` for all analyzed files
- No relationship detection between modules
- Missing import/export analysis
- Incomplete metadata collection

**Evidence:**
```json
// From pos_architecture.json
"metadata": {
  "languages": [],     // Should detect Dart, YAML, etc.
  "total_files": 0,    // Processed 555+ files but shows 0
  "total_lines": 0     // No line counting
}
```

**Files Affected:**
- `src/architecture_exporter.rs:1-962` - Complete rewrite needed
- `src/export_formats.rs:1-150` - Output formatting issues
- `src/cli.rs:154-162` - Export command handling

#### 3. Symbol Resolution System
**Severity: HIGH**

**Current State:**
- Over-granular parsing capturing every method call
- No type inference or analysis
- Missing cross-reference capabilities
- No pattern detection (Observer, Factory, etc.)

**Files Affected:**
- `src/symbol_resolver.rs` - Core logic flawed (600+ lines of unused code)
- `src/symbol_table.rs` - Storage inefficient
- `src/scope_tracker.rs` - Scope management unused

#### 4. Dependency Management
**Severity: MEDIUM**

**Current Dependencies (Outdated):**
```toml
tree-sitter = "0.22"           # Latest: 0.24+
tokio = { version = "1.0" }     # Latest: 1.47+
serde = { version = "1" }       # Latest: 1.0.219
tracing = "0.1"                 # Latest: 0.1.41
```

## 2025 Modernization Requirements

### Industry Standards Compliance

Based on Context7 research of current best practices:

1. **LSP Integration**: Modern code analysis tools provide Language Server Protocol support
2. **Incremental Analysis**: Real-time parsing with minimal recomputation
3. **Multi-Language Intelligence**: Unified analysis across polyglot codebases
4. **Performance Optimization**: Sub-second analysis for large codebases (100k+ files)
5. **Async-First Architecture**: Non-blocking operations throughout

## Refactor Implementation Plan

### Phase 1: Foundation Modernization (Weeks 1-2)

#### 1.1 Dependency Updates
**Priority: CRITICAL**

**Files to Update:**
- `Cargo.toml`

**Changes:**
```toml
[dependencies]
# Core parsing
tree-sitter = "0.24"
tree-sitter-dart = "0.0.1"      # Update from git ref
tree-sitter-typescript = "0.24"
tree-sitter-rust = "0.24"
tree-sitter-python = "0.24"
tree-sitter-go = "0.24"
tree-sitter-java = "0.24"
tree-sitter-javascript = "0.24"

# Async runtime
tokio = { version = "1.47", features = ["full"] }
futures = "0.3.31"

# Serialization
serde = { version = "1.0.219", features = ["derive"] }
serde_json = "1.0.142"
serde_yaml = "0.9.34"

# Logging and tracing  
tracing = "0.1.41"
tracing-subscriber = "0.3.19"

# Performance
rayon = "1.10"
dashmap = "6.1"    # Concurrent HashMap
```

#### 1.2 Architecture Redesign
**Priority: HIGH**

**Create New Module Structure:**
```rust
src/
├── core/
│   ├── mod.rs
│   ├── analyzer.rs         # Core analysis engine
│   ├── language.rs         # Language abstraction
│   └── symbol_types.rs     # Modern symbol definitions
├── parsers/
│   ├── mod.rs
│   ├── treesitter_engine.rs  # Updated TreeSitter integration
│   ├── dart_parser.rs         # Language-specific parsers
│   ├── typescript_parser.rs
│   └── rust_parser.rs
├── analysis/
│   ├── mod.rs
│   ├── relationship_detector.rs  # Import/dependency analysis
│   ├── pattern_detector.rs       # Design pattern recognition
│   └── metrics_calculator.rs     # Code metrics
└── export/
    ├── mod.rs
    ├── formats/           # Multiple export formats
    └── streaming.rs       # Large dataset handling
```

### Phase 2: Core System Rewrite (Weeks 3-4)

#### 2.1 TreeSitter Engine Modernization
**File: `src/parsers/treesitter_engine.rs`**

**Current Issues:**
```rust
// src/adapters/treesitter.rs:45-67 - Problematic code
fn extract_symbols(&mut self, node: Node, symbols: &mut Vec<Symbol>) -> Result<()> {
    // Everything classified as "function" - WRONG
    match node.kind() {
        "identifier" => {
            symbols.push(Symbol {
                kind: "function".to_string(),  // ❌ Incorrect classification
                // ... rest of flawed logic
            });
        }
    }
}
```

**Refactored Implementation:**
```rust
// New: src/parsers/treesitter_engine.rs
use std::collections::HashMap;
use tree_sitter::{Language, Parser, Query, QueryCursor, Node};

pub struct ModernTreeSitterEngine {
    parsers: HashMap<String, Parser>,
    queries: HashMap<String, LanguageQueries>,
    cursor: QueryCursor,
}

#[derive(Debug)]
pub struct LanguageQueries {
    pub classes: Query,
    pub functions: Query,
    pub imports: Query,
    pub exports: Query,
    pub types: Query,
}

impl ModernTreeSitterEngine {
    pub fn new() -> Result<Self> {
        let mut engine = Self {
            parsers: HashMap::new(),
            queries: HashMap::new(),
            cursor: QueryCursor::new(),
        };
        
        // Load language-specific queries
        engine.load_language_queries("dart")?;
        engine.load_language_queries("typescript")?;
        // ... other languages
        
        Ok(engine)
    }
    
    pub async fn analyze_file(&mut self, path: &Path, content: &str) -> Result<FileAnalysis> {
        let language = self.detect_language(path)?;
        let parser = self.parsers.get_mut(&language)
            .ok_or_else(|| anyhow!("Unsupported language: {}", language))?;
            
        let tree = parser.parse(content, None)
            .ok_or_else(|| anyhow!("Failed to parse file"))?;
            
        let queries = &self.queries[&language];
        
        // Multi-pass analysis
        let classes = self.extract_classes(&tree, queries).await?;
        let functions = self.extract_functions(&tree, queries).await?;
        let imports = self.extract_imports(&tree, queries).await?;
        let relationships = self.analyze_relationships(&tree, queries).await?;
        
        Ok(FileAnalysis {
            path: path.to_path_buf(),
            language,
            classes,
            functions,
            imports,
            relationships,
            metrics: self.calculate_metrics(&tree)?,
        })
    }
    
    fn load_dart_queries(&mut self) -> Result<()> {
        // Proper Dart-specific queries
        let classes = Query::new(
            &tree_sitter_dart::LANGUAGE.into(),
            r#"
            (class_definition 
                name: (identifier) @class.name
                superclass: (type_identifier)? @class.superclass
                body: (class_body) @class.body) @class.definition
            "#,
        )?;
        
        let functions = Query::new(
            &tree_sitter_dart::LANGUAGE.into(),
            r#"
            (function_declaration
                name: (identifier) @function.name
                parameters: (formal_parameter_list) @function.params
                body: (_) @function.body) @function.definition
                
            (method_declaration
                name: (identifier) @method.name
                parameters: (formal_parameter_list) @method.params
                body: (_) @method.body) @method.definition
            "#,
        )?;
        
        let imports = Query::new(
            &tree_sitter_dart::LANGUAGE.into(),
            r#"
            (import_specification
                library: (dotted_identifier) @import.library
                (import_combinator)? @import.combinator) @import
                
            (library_import
                uri: (string_literal) @import.uri
                (as_clause (identifier) @import.alias)?
                (show_clause (identifier_list))? @import.show
                (hide_clause (identifier_list))? @import.hide) @import
            "#,
        )?;
        
        self.queries.insert("dart".to_string(), LanguageQueries {
            classes, functions, imports,
            exports: Query::new(&tree_sitter_dart::LANGUAGE.into(), "")?, // TODO
            types: Query::new(&tree_sitter_dart::LANGUAGE.into(), "")?,    // TODO
        });
        
        Ok(())
    }
}
```

#### 2.2 Symbol Classification System
**File: `src/core/symbol_types.rs`**

```rust
use serde::{Deserialize, Serialize};
use std::collections::HashMap;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum SymbolKind {
    // Classes and Types
    Class { 
        is_abstract: bool, 
        superclass: Option<String>,
        interfaces: Vec<String>,
    },
    Interface,
    Enum { variants: Vec<String> },
    Struct { fields: Vec<Field> },
    Type { definition: String },
    
    // Functions and Methods
    Function { 
        is_async: bool,
        parameters: Vec<Parameter>,
        return_type: Option<String>,
    },
    Method { 
        visibility: Visibility,
        is_static: bool,
        is_async: bool,
        parameters: Vec<Parameter>,
        return_type: Option<String>,
    },
    Constructor { parameters: Vec<Parameter> },
    
    // Variables and Properties
    Variable { var_type: Option<String>, is_mutable: bool },
    Property { 
        visibility: Visibility,
        is_static: bool,
        property_type: Option<String>,
    },
    Constant { value: Option<String> },
    
    // Modules and Organization
    Module { exports: Vec<String> },
    Import { 
        source: String, 
        items: Vec<ImportItem>,
        is_wildcard: bool,
    },
    Export { items: Vec<String> },
    
    // Flutter/Dart Specific
    Widget { 
        is_stateful: bool,
        properties: Vec<Property>,
        build_method: Option<String>,
    },
    Provider { provided_type: String },
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Symbol {
    pub id: String,
    pub name: String,
    pub kind: SymbolKind,
    pub location: SourceLocation,
    pub documentation: Option<String>,
    pub annotations: Vec<Annotation>,
    pub visibility: Visibility,
    pub relationships: Vec<Relationship>,
    pub metrics: SymbolMetrics,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SourceLocation {
    pub file_path: PathBuf,
    pub start_line: u32,
    pub start_column: u32,
    pub end_line: u32,
    pub end_column: u32,
    pub byte_offset: u32,
    pub byte_length: u32,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum Relationship {
    Inherits { target: String },
    Implements { target: String },
    Imports { source: String, alias: Option<String> },
    Calls { target: String, call_type: CallType },
    References { target: String },
    Contains { children: Vec<String> },
    DependsOn { target: String, dependency_type: DependencyType },
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum CallType {
    Direct,
    Indirect,
    Constructor,
    Method,
    Function,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum DependencyType {
    Import,
    Inheritance,
    Composition,
    Aggregation,
    Usage,
}
```

#### 2.3 Analysis Engine
**File: `src/core/analyzer.rs`**

```rust
use tokio::sync::RwLock;
use dashmap::DashMap;
use std::sync::Arc;

pub struct AnalysisEngine {
    parsers: Arc<RwLock<ModernTreeSitterEngine>>,
    symbol_index: Arc<DashMap<String, Symbol>>,
    file_index: Arc<DashMap<PathBuf, FileAnalysis>>,
    relationship_graph: Arc<RwLock<RelationshipGraph>>,
    metrics_cache: Arc<DashMap<String, ProjectMetrics>>,
}

impl AnalysisEngine {
    pub async fn analyze_project(&self, root_path: &Path) -> Result<ProjectAnalysis> {
        let files = self.discover_files(root_path).await?;
        
        // Parallel processing with controlled concurrency
        let semaphore = Arc::new(tokio::sync::Semaphore::new(num_cpus::get()));
        let tasks: Vec<_> = files
            .into_iter()
            .map(|file_path| {
                let engine = Arc::clone(&self.parsers);
                let semaphore = Arc::clone(&semaphore);
                
                tokio::spawn(async move {
                    let _permit = semaphore.acquire().await?;
                    let content = tokio::fs::read_to_string(&file_path).await?;
                    
                    let mut parsers = engine.write().await;
                    parsers.analyze_file(&file_path, &content).await
                })
            })
            .collect();
            
        // Collect results
        let mut file_analyses = Vec::new();
        for task in tasks {
            match task.await? {
                Ok(analysis) => {
                    // Index symbols
                    for symbol in &analysis.symbols {
                        self.symbol_index.insert(symbol.id.clone(), symbol.clone());
                    }
                    
                    // Store file analysis
                    self.file_index.insert(analysis.path.clone(), analysis.clone());
                    file_analyses.push(analysis);
                },
                Err(e) => {
                    tracing::warn!("Failed to analyze file: {}", e);
                    continue;
                }
            }
        }
        
        // Phase 2: Relationship analysis
        let relationships = self.analyze_relationships(&file_analyses).await?;
        
        // Phase 3: Pattern detection
        let patterns = self.detect_patterns(&file_analyses, &relationships).await?;
        
        // Phase 4: Architecture metrics
        let metrics = self.calculate_project_metrics(&file_analyses, &relationships).await?;
        
        Ok(ProjectAnalysis {
            root_path: root_path.to_path_buf(),
            files: file_analyses,
            relationships,
            patterns,
            metrics,
            generated_at: chrono::Utc::now(),
        })
    }
    
    async fn analyze_relationships(
        &self, 
        file_analyses: &[FileAnalysis]
    ) -> Result<Vec<Relationship>> {
        // Cross-file relationship analysis
        let mut relationships = Vec::new();
        
        for analysis in file_analyses {
            // Import analysis
            for import in &analysis.imports {
                if let Some(target_file) = self.resolve_import_target(&import.source).await? {
                    relationships.push(Relationship::DependsOn {
                        source: analysis.path.to_string_lossy().to_string(),
                        target: target_file.to_string_lossy().to_string(),
                        dependency_type: DependencyType::Import,
                    });
                }
            }
            
            // Inheritance analysis
            for symbol in &analysis.symbols {
                if let SymbolKind::Class { superclass: Some(parent), .. } = &symbol.kind {
                    if let Some(parent_symbol) = self.resolve_symbol(parent).await? {
                        relationships.push(Relationship::Inherits {
                            source: symbol.id.clone(),
                            target: parent_symbol.id,
                        });
                    }
                }
            }
        }
        
        Ok(relationships)
    }
}
```

### Phase 3: Export System Modernization (Week 5)

#### 3.1 Streaming Export Architecture
**File: `src/export/streaming.rs`**

```rust
use tokio::io::{AsyncWrite, AsyncWriteExt};
use serde_json::ser::Serializer;

pub struct StreamingExporter<W: AsyncWrite + Unpin> {
    writer: W,
    format: ExportFormat,
    buffer_size: usize,
}

impl<W: AsyncWrite + Unpin> StreamingExporter<W> {
    pub async fn export_project_analysis(
        &mut self,
        analysis: &ProjectAnalysis,
    ) -> Result<()> {
        match self.format {
            ExportFormat::JSON => self.export_json_streaming(analysis).await,
            ExportFormat::YAML => self.export_yaml_streaming(analysis).await,
            ExportFormat::GraphML => self.export_graphml_streaming(analysis).await,
            ExportFormat::PlantUML => self.export_plantuml_streaming(analysis).await,
        }
    }
    
    async fn export_json_streaming(&mut self, analysis: &ProjectAnalysis) -> Result<()> {
        // Stream large datasets without loading entire project in memory
        self.writer.write_all(b"{\n").await?;
        
        // Metadata first (small)
        self.writer.write_all(b"  \"metadata\": ").await?;
        let metadata_json = serde_json::to_string(&analysis.metadata)?;
        self.writer.write_all(metadata_json.as_bytes()).await?;
        self.writer.write_all(b",\n").await?;
        
        // Stream files in chunks
        self.writer.write_all(b"  \"files\": [\n").await?;
        
        let mut first = true;
        for chunk in analysis.files.chunks(100) { // Process 100 files at a time
            if !first {
                self.writer.write_all(b",\n").await?;
            }
            first = false;
            
            for (i, file_analysis) in chunk.iter().enumerate() {
                if i > 0 {
                    self.writer.write_all(b",\n").await?;
                }
                
                let file_json = serde_json::to_string(file_analysis)?;
                self.writer.write_all(b"    ").await?;
                self.writer.write_all(file_json.as_bytes()).await?;
            }
            
            // Flush buffer periodically
            self.writer.flush().await?;
        }
        
        self.writer.write_all(b"\n  ],\n").await?;
        
        // Relationships
        self.stream_relationships(&analysis.relationships).await?;
        
        // Patterns
        self.stream_patterns(&analysis.patterns).await?;
        
        // Metrics (summary)
        self.writer.write_all(b"  \"metrics\": ").await?;
        let metrics_json = serde_json::to_string(&analysis.metrics)?;
        self.writer.write_all(metrics_json.as_bytes()).await?;
        
        self.writer.write_all(b"\n}").await?;
        Ok(())
    }
}
```

### Phase 4: Performance Optimization (Week 6)

#### 4.1 Caching and Incremental Analysis
**File: `src/core/caching.rs`**

```rust
use serde::{Deserialize, Serialize};
use std::time::SystemTime;

#[derive(Debug, Serialize, Deserialize)]
pub struct CacheEntry {
    pub file_path: PathBuf,
    pub last_modified: SystemTime,
    pub content_hash: u64,
    pub analysis: FileAnalysis,
}

pub struct AnalysisCache {
    cache_dir: PathBuf,
    entries: Arc<DashMap<PathBuf, CacheEntry>>,
}

impl AnalysisCache {
    pub async fn get_or_analyze(
        &self,
        file_path: &Path,
        analyzer: &AnalysisEngine,
    ) -> Result<FileAnalysis> {
        let metadata = tokio::fs::metadata(file_path).await?;
        let modified_time = metadata.modified()?;
        
        // Check cache
        if let Some(entry) = self.entries.get(file_path) {
            if entry.last_modified >= modified_time {
                tracing::debug!("Cache hit for {}", file_path.display());
                return Ok(entry.analysis.clone());
            }
        }
        
        // Cache miss - perform analysis
        tracing::debug!("Cache miss for {}, analyzing", file_path.display());
        let content = tokio::fs::read_to_string(file_path).await?;
        let content_hash = seahash::hash(content.as_bytes());
        
        let analysis = analyzer.analyze_file(file_path, &content).await?;
        
        // Store in cache
        let entry = CacheEntry {
            file_path: file_path.to_path_buf(),
            last_modified: modified_time,
            content_hash,
            analysis: analysis.clone(),
        };
        
        self.entries.insert(file_path.to_path_buf(), entry);
        self.persist_entry(file_path).await?;
        
        Ok(analysis)
    }
    
    pub async fn invalidate_project(&self, root_path: &Path) -> Result<()> {
        // Smart invalidation based on dependency graph
        let mut to_invalidate = Vec::new();
        
        for entry in self.entries.iter() {
            if entry.file_path.starts_with(root_path) {
                let metadata = tokio::fs::metadata(&entry.file_path).await?;
                if metadata.modified()? > entry.last_modified {
                    to_invalidate.push(entry.file_path.clone());
                }
            }
        }
        
        // Cascade invalidation to dependent files
        for path in &to_invalidate {
            self.invalidate_cascade(path).await?;
        }
        
        Ok(())
    }
}
```

### Phase 5: Testing and Quality Assurance (Week 7)

#### 5.1 Comprehensive Test Suite
**File: `tests/integration_tests.rs`**

```rust
#[cfg(test)]
mod tests {
    use super::*;
    use tempfile::TempDir;
    
    #[tokio::test]
    async fn test_dart_flutter_analysis() {
        let temp_dir = TempDir::new().unwrap();
        let dart_file = temp_dir.path().join("widget.dart");
        
        tokio::fs::write(&dart_file, r#"
            import 'package:flutter/material.dart';
            
            class MyWidget extends StatelessWidget {
              final String title;
              
              const MyWidget({Key? key, required this.title}) : super(key: key);
              
              @override
              Widget build(BuildContext context) {
                return Scaffold(
                  appBar: AppBar(title: Text(title)),
                  body: Center(child: Text('Hello, World!')),
                );
              }
            }
            
            class MyStatefulWidget extends StatefulWidget {
              @override
              _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
            }
            
            class _MyStatefulWidgetState extends State<MyStatefulWidget> {
              int _counter = 0;
              
              void _incrementCounter() {
                setState(() {
                  _counter++;
                });
              }
              
              @override
              Widget build(BuildContext context) {
                return Text('$_counter');
              }
            }
        "#).await.unwrap();
        
        let engine = AnalysisEngine::new().await.unwrap();
        let analysis = engine.analyze_project(temp_dir.path()).await.unwrap();
        
        // Verify correct symbol detection
        assert_eq!(analysis.files.len(), 1);
        
        let file_analysis = &analysis.files[0];
        let symbols: HashMap<String, &Symbol> = file_analysis.symbols
            .iter()
            .map(|s| (s.name.clone(), s))
            .collect();
            
        // Check import detection
        assert!(file_analysis.imports.iter().any(|imp| 
            imp.source.contains("flutter/material.dart")));
            
        // Check class detection
        let my_widget = symbols.get("MyWidget").expect("MyWidget not found");
        match &my_widget.kind {
            SymbolKind::Widget { is_stateful, .. } => {
                assert!(!is_stateful, "MyWidget should be stateless");
            }
            _ => panic!("MyWidget should be classified as Widget"),
        }
        
        let stateful_widget = symbols.get("MyStatefulWidget").expect("MyStatefulWidget not found");
        match &stateful_widget.kind {
            SymbolKind::Widget { is_stateful, .. } => {
                assert!(*is_stateful, "MyStatefulWidget should be stateful");
            }
            _ => panic!("MyStatefulWidget should be classified as Widget"),
        }
        
        // Check method detection
        let build_method = symbols.get("build").expect("build method not found");
        match &build_method.kind {
            SymbolKind::Method { is_async, return_type, .. } => {
                assert!(!is_async, "build method should not be async");
                assert_eq!(return_type.as_ref().unwrap(), "Widget");
            }
            _ => panic!("build should be classified as Method"),
        }
        
        // Check relationship detection
        let relationships = &analysis.relationships;
        assert!(relationships.iter().any(|rel| match rel {
            Relationship::Inherits { source, target } => {
                source == "MyWidget" && target == "StatelessWidget"
            }
            _ => false,
        }));
    }
    
    #[tokio::test]
    async fn test_large_project_performance() {
        // Test with the POS example project
        let pos_path = Path::new("examples/dart/pos");
        if !pos_path.exists() {
            return; // Skip if example not available
        }
        
        let start_time = std::time::Instant::now();
        let engine = AnalysisEngine::new().await.unwrap();
        let analysis = engine.analyze_project(pos_path).await.unwrap();
        let duration = start_time.elapsed();
        
        // Performance requirements
        assert!(duration < std::time::Duration::from_secs(30), 
            "Analysis took too long: {:?}", duration);
        assert!(analysis.files.len() > 100, 
            "Should analyze many files, got {}", analysis.files.len());
        assert!(analysis.relationships.len() > 50,
            "Should detect many relationships, got {}", analysis.relationships.len());
            
        println!("Analyzed {} files in {:?}", analysis.files.len(), duration);
    }
    
    #[tokio::test] 
    async fn test_incremental_analysis() {
        let temp_dir = TempDir::new().unwrap();
        let cache = AnalysisCache::new(temp_dir.path().join("cache")).await.unwrap();
        let engine = AnalysisEngine::new().await.unwrap();
        
        let file_path = temp_dir.path().join("test.dart");
        tokio::fs::write(&file_path, "class TestClass {}").await.unwrap();
        
        // First analysis - should be slow
        let start = std::time::Instant::now();
        let analysis1 = cache.get_or_analyze(&file_path, &engine).await.unwrap();
        let first_duration = start.elapsed();
        
        // Second analysis - should be from cache
        let start = std::time::Instant::now();
        let analysis2 = cache.get_or_analyze(&file_path, &engine).await.unwrap();
        let second_duration = start.elapsed();
        
        assert!(second_duration < first_duration / 10, 
            "Cache should be much faster: {:?} vs {:?}", 
            second_duration, first_duration);
        assert_eq!(analysis1.symbols.len(), analysis2.symbols.len());
    }
}
```

## Migration Strategy

### Step-by-Step Migration

1. **Week 1: Dependency Updates**
   - Update `Cargo.toml` with modern versions
   - Fix compilation issues
   - Update CI/CD pipelines

2. **Week 2: Core Architecture**
   - Implement new module structure
   - Create modern symbol types
   - Set up async architecture

3. **Week 3-4: Parser Rewrite**
   - Implement new TreeSitter engine
   - Add language-specific parsers
   - Comprehensive symbol classification

4. **Week 5: Export System**
   - Streaming exports for large projects
   - Multiple output formats
   - Performance optimization

5. **Week 6: Caching & Performance**
   - Intelligent caching system
   - Incremental analysis
   - Parallel processing optimization

6. **Week 7: Testing & Validation**
   - Comprehensive test suite
   - Performance benchmarks
   - Integration testing with POS example

### Risk Mitigation

**Breaking Changes:**
- Maintain backward compatibility for CLI interface
- Provide migration script for existing configurations
- Document all API changes

**Performance Risks:**
- Implement feature flags for experimental features
- Maintain fallback to simple analysis mode
- Comprehensive benchmarking at each phase

**Quality Assurance:**
- Automated testing at every commit
- Manual testing with real-world projects
- Community testing with beta releases

## Success Metrics

### Functional Requirements
- ✅ Correctly classify 95%+ of symbols in test suite
- ✅ Detect import/export relationships accurately
- ✅ Support all major languages (Dart, TypeScript, Rust, Python, Go, Java, JavaScript)
- ✅ Export to multiple formats (JSON, YAML, GraphML, PlantUML)

### Performance Requirements
- ✅ Analyze 1000+ file projects in <30 seconds
- ✅ Incremental analysis in <5 seconds for file changes
- ✅ Memory usage <2GB for large projects
- ✅ Cache hit ratio >80% for repeated analysis

### Quality Requirements
- ✅ Zero critical bugs in production
- ✅ 90%+ code coverage in tests
- ✅ All dependencies up-to-date
- ✅ Full documentation coverage

## Conclusion

This refactor roadmap addresses all critical issues identified in the current AgentMap implementation while positioning it as a modern, efficient code analysis tool for 2025. The systematic approach ensures minimal disruption while delivering significant improvements in accuracy, performance, and maintainability.

**Key Benefits of This Refactor:**
1. **Accuracy**: Proper symbol classification and relationship detection
2. **Performance**: Sub-30-second analysis of large projects
3. **Scalability**: Streaming exports and intelligent caching
4. **Maintainability**: Modern async architecture with comprehensive testing
5. **Extensibility**: Plugin architecture for new languages and analysis types

**Estimated Timeline:** 7 weeks  
**Estimated Effort:** 2-3 full-time developers  
**Priority:** High - Current implementation is not production-ready

The investment in this refactor will result in a tool that meets industry standards for code analysis and provides real value to development teams working with complex, multi-language codebases.