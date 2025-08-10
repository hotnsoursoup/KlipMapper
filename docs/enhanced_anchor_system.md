# Enhanced Anchor System - Implementation Guide

## Overview

The Enhanced Anchor System is a revolutionary approach to code analysis that embeds rich, compressed metadata directly into source code comments. This system creates a comprehensive code graph that enables AI agents and tools to perform precise refactoring, impact analysis, and code navigation without expensive parsing operations.

## Core Concepts

### 1. Rich Anchors vs Simple Metadata

**Traditional Approach (Sidecar Files):**
```yaml
# .agentmap/file.py.yaml
metadata:
  language: python
  symbols: ["User", "create_user"]
```

**Enhanced Anchor Approach (Embedded Comments):**
```python
# agentmap:1
# gz64: H4sIAJzwhGUC/62UX2+bQBCG/5Vwz3b2...<compressed JSON>...AA==
# total-bytes: 2384 sha1:6d8b1a90

class User:  # am:a=C1;fg=9f58;r=18-42
    def create(self):  # am:a=M1;fg=a7f2;r=25-35
        pass
```

### 2. Two-Tier Storage Strategy

**Header Index (Rich but Compact):**
- Full symbol graph with relationships
- Cross-reference mappings
- Scope frame hierarchies
- Gzip + Base64 compressed
- Typically 4-12KB even for large files

**Sparse Inline Anchors (Hot Spots Only):**
- Tiny anchors at critical locations
- Direct line number references
- 30-60 bytes each
- Only at API boundaries, mutation points, complex flows

## Implementation Architecture

### Core Modules

```
src/
├── anchor.rs              # Core anchor data structures and compression
├── scope_tracker.rs       # Nested scope frame tracking during AST traversal
├── symbol_resolver.rs     # Symbol extraction and relationship building
├── anchor_generator.rs    # [TODO] Generates embedded comments
├── anchor_parser.rs       # [TODO] Parses existing anchors
└── impact_analyzer.rs     # [TODO] Change impact analysis
```

### Key Data Structures

#### AnchorHeader (Compressed at file top)
```rust
pub struct AnchorHeader {
    pub version: String,                    // Schema version
    pub file_id: String,                    // File path + content hash
    pub language: String,                   // Programming language
    pub symbols: Vec<Symbol>,               // All symbols in file
    pub xrefs: HashMap<String, Vec<CrossReference>>,  // Fast lookups
    pub index: FastIndex,                   // Symbol/type mappings
    pub timestamp: u64,                     // Generation time
}
```

#### Symbol (Rich symbol metadata)
```rust
pub struct Symbol {
    pub id: String,                         // Short ID (C1, M1, F1)
    pub kind: String,                       // class, method, function, etc.
    pub name: String,                       // Symbol name
    pub range: SourceRange,                 // Lines + bytes
    pub frames: Vec<ScopeFrame>,           // Nested scopes (file→class→method)
    pub roles: Vec<String>,                // declaration, exported, async, etc.
    pub references: Vec<SymbolReference>,   // imports, type uses
    pub edges: Vec<SymbolEdge>,            // calls, inheritance, overrides
    pub fingerprint: String,                // Content hash for drift detection
    pub guard: Option<GuardInfo>,          // Side effects, invariants
}
```

#### ScopeFrame (Nested context tracking)
```rust
pub struct ScopeFrame {
    pub kind: String,                       // file, class, method, block
    pub name: Option<String>,               // Symbol name if applicable
    pub range: SourceRange,                 // Source span of this scope
}
```

## Language Support Strategy

### Current Implementation
- **Rust**: Full support (structs, traits, impls, functions)
- **TypeScript**: Classes, interfaces, functions, modules
- **Python**: Classes, functions, decorators, imports
- **Java**: Classes, interfaces, methods, packages
- **Dart**: Classes, methods, widgets, futures

### Language-Agnostic Extensions

#### 1. Universal Symbol Types
```rust
pub enum UniversalSymbolKind {
    // Core language constructs
    Type,           // class, struct, interface, type alias
    Function,       // function, method, procedure
    Variable,       // variable, field, property, constant
    Module,         // module, namespace, package
    
    // Framework-specific
    Component,      // React component, Vue component, Flutter widget
    Route,          // API endpoint, URL route
    Database,       // table, column, index, view
    Config,         // configuration entry, environment variable
    
    // Behavioral
    Event,          // event handler, signal, callback
    State,          // state variable, store, observable
    Effect,         // side effect, mutation, IO operation
}
```

#### 2. Cross-Language Relationship Types
```rust
pub enum UniversalEdgeType {
    // Direct relationships
    Calls,          // function calls function
    Inherits,       // class extends class
    Implements,     // class implements interface
    Uses,           // imports/references symbol
    
    // Data flow
    Reads,          // reads variable/property
    Writes,         // modifies variable/property
    Returns,        // function returns type
    Accepts,        // function accepts parameter type
    
    // Framework relationships
    Renders,        // component renders component
    Routes,         // route handler serves endpoint
    Queries,        // code queries database table
    Configures,     // code uses configuration
    
    // Semantic relationships  
    Similar,        // symbols with similar purpose across languages
    Equivalent,     // exact same concept in different languages
    Depends,        // depends on external resource
}
```

#### 3. Multi-Language Project Analysis

**Cross-Language Symbol Mapping:**
```rust
pub struct CrossLanguageMapping {
    pub rust_symbol: String,        // "struct User"
    pub typescript_symbol: String,  // "interface User"  
    pub python_symbol: String,      // "class User"
    pub equivalence_type: EquivalenceType,  // Exact, Similar, Related
    pub confidence: f32,            // 0.0 to 1.0
}
```

**Project-Wide Impact Analysis:**
```rust
pub struct ProjectGraph {
    pub languages: HashMap<String, LanguageGraph>,
    pub cross_refs: Vec<CrossLanguageMapping>,
    pub shared_types: HashMap<String, Vec<SymbolReference>>,
    pub api_boundaries: Vec<APIBoundary>,
}
```

## Advanced Features

### 1. Framework-Specific Analyzers

**Flutter/Dart Analyzer:**
- Widget tree relationships
- State management patterns (Provider, BLoC, Riverpod)
- Navigation routes
- Asset references

**React/TypeScript Analyzer:**
- Component hierarchy
- Hook dependencies
- Context providers
- Props flow

**Django/Python Analyzer:**
- Model relationships
- URL routing
- Template rendering
- Database migrations

### 2. Database Integration Support

**ORM/Schema Tracking:**
```rust
pub struct DatabaseReference {
    pub table: String,              // "users" 
    pub column: Option<String>,     // "id", "email"
    pub operation: DbOperation,     // Read, Write, Create, Delete
    pub orm_model: Option<String>,  // "User" (model class)
    pub migration: Option<String>,  // Migration file reference
}

pub enum DbOperation {
    Query,      // SELECT
    Insert,     // INSERT
    Update,     // UPDATE  
    Delete,     // DELETE
    Schema,     // CREATE TABLE, ALTER, etc.
}
```

**Migration Impact Analysis:**
- Find all code referencing a database field
- Identify type conversion requirements
- Generate migration checklist
- Validate referential integrity

### 3. Configuration and Environment Tracking

**Config Reference Tracking:**
```rust
pub struct ConfigReference {
    pub key: String,                // "DATABASE_URL"
    pub source: ConfigSource,       // Environment, File, Runtime
    pub usage_type: ConfigUsage,    // Required, Optional, Default
    pub validation: Option<String>, // Type or format requirements
}
```

### 4. Error Propagation Analysis

**Exception Flow Tracking:**
```rust
pub struct ErrorFlow {
    pub error_type: String,         // Exception class or error enum
    pub source: SymbolReference,    // Where error originates
    pub handlers: Vec<SymbolReference>,  // Catch blocks, error handlers
    pub propagation: Vec<SymbolReference>,  // Functions that re-throw
}
```

## Performance Optimizations

### 1. Incremental Updates
- Track file modification times
- Only reprocess changed files
- Merge updates into existing graphs
- Preserve unchanged relationships

### 2. Lazy Loading
- Load headers first (lightweight)
- Parse inline anchors on demand
- Stream large symbol graphs
- Cache frequently accessed symbols

### 3. Parallel Processing
- Process files concurrently by language
- Parallel symbol resolution
- Background relationship building
- Async impact analysis

## CLI Interface Design

### Basic Commands
```bash
# Generate anchors for entire project
agentmap anchor --project-root . --languages rust,typescript,python

# Query symbol relationships
agentmap query --symbol "User" --relations calls,inherits --format json

# Impact analysis for changes
agentmap impact --symbol "DatabaseUser.id" --change-type "int->string"

# Validate anchor integrity
agentmap validate --check-drift --repair-missing

# Extract just the graph without source
agentmap export --format graphml --output project-graph.xml
```

### Advanced Queries
```bash
# Find all database access points
agentmap query --pattern "*.sql" --edge-type queries

# Cross-language type consistency
agentmap lint --check cross-language-types --strict

# Find unused exports
agentmap query --symbol-type exported --filter unused

# Security analysis
agentmap security --find "sql-injection,xss,path-traversal"
```

## Agent Integration Patterns

### 1. Smart Refactoring
```python
# Agent can query: "Find all references to User.email field"
references = agentmap.query_symbol("field.User.email", relations=["reads", "writes"])
# Then perform precise edits at exact line numbers
for ref in references:
    edit_file(ref.file_path, ref.range.lines, new_content)
```

### 2. Architecture Analysis
```python
# Agent can ask: "What depends on this database table?"
impact = agentmap.impact_analysis("table.users", depth=3)
print(f"Changing 'users' table affects {len(impact.symbols)} symbols")
```

### 3. Code Generation
```python
# Agent can generate consistent APIs across languages
rust_api = agentmap.get_symbol("api.UserService")
typescript_types = agentmap.generate_equivalent(rust_api, target_lang="typescript")
```

## Migration Strategy

### Phase 1: Core Infrastructure ✅
- [x] Anchor data structures
- [x] Compression/decompression 
- [x] Scope tracking
- [x] Symbol resolution
- [ ] Anchor generation
- [ ] Anchor parsing

### Phase 2: Language Support
- [ ] Enhanced tree-sitter queries per language
- [ ] Framework-specific analyzers
- [ ] Cross-language mappings
- [ ] Database/ORM integration

### Phase 3: Advanced Features  
- [ ] Real-time impact analysis
- [ ] IDE plugins
- [ ] CI/CD integration
- [ ] Security analysis
- [ ] Performance profiling

### Phase 4: AI Agent Optimization
- [ ] Natural language query interface
- [ ] Automated refactoring suggestions
- [ ] Code quality recommendations
- [ ] Architecture pattern detection

## Benefits Over Traditional AST Parsing

### For AI Agents:
1. **Speed**: No parsing required, direct JSON access
2. **Context**: Rich scope and relationship information
3. **Precision**: Exact line numbers and byte ranges
4. **Consistency**: Standardized across all languages
5. **Freshness**: Built-in drift detection

### For Developers:
1. **Transparency**: Anchors visible in source code
2. **Portability**: No external database dependencies
3. **Incremental**: Works with partial codebases
4. **Traceable**: Clear change attribution
5. **Debuggable**: Human-readable (when decompressed)

### For Tools:
1. **Interoperability**: Standard format across tools
2. **Extensibility**: Plugin architecture for new languages
3. **Scalability**: Handles massive codebases efficiently
4. **Reliability**: Checksums prevent corruption
5. **Flexibility**: Multiple compression/encoding options

## Next Steps

1. **Complete Core Implementation**: Finish anchor generation and parsing
2. **Language Expansion**: Add C++, C#, Go, Swift, Kotlin support
3. **Framework Integration**: React, Vue, Django, Spring Boot analyzers
4. **Tool Ecosystem**: VS Code extension, CLI enhancements, CI plugins  
5. **Agent Optimization**: Fine-tune for LLM consumption patterns

This enhanced anchor system represents a paradigm shift from external metadata to embedded, living documentation that evolves with the code and provides unprecedented precision for automated code analysis and refactoring.