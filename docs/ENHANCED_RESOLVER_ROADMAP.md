# Enhanced Symbol Resolver Roadmap

*Vision for Native High-Fidelity Semantic Analysis*

## 🎯 **Current Status**

### ✅ **Implemented (Advanced Architecture)**
- **Rich data structures** with compressed anchor headers (gzip + base64)
- **Scope frame tracking** (file→class→method→block hierarchy) 
- **Advanced symbol relationships** (SymbolReference + SymbolEdge)
- **Cross-reference indexing** with fast lookup optimization
- **Import alias resolution** and namespace tracking
- **Effect/guard analysis** for side effects and invariants
- **Symbol ownership tracking** (methods belonging to classes)
- **Content fingerprinting** for change detection

### ❌ **Current Limitation**
- **Enhanced SymbolResolver extracts 0 symbols** (tree-sitter integration incomplete)
- **Falling back to TsAdapter** for working symbol extraction
- **Using hybrid approach** to preserve advanced features

## 🚀 **Vision: Native Enhanced Resolver**

### **Why We Need This**
The current TsAdapter provides basic symbol extraction but lacks the semantic depth needed for advanced code analysis:

**TsAdapter Limitations:**
- Flat symbols with no hierarchical context
- Basic call edges only (no relationship types)
- No import alias resolution
- No symbol ownership tracking
- No effect analysis
- Linear search (no optimized indexing)

**Enhanced Resolver Goals:**
- **Semantic Understanding**: Distinguish between type usage, method calls, imports
- **Hierarchical Context**: Know exact scope nesting (method inside class inside namespace)
- **Relationship Mapping**: Track inheritance, composition, dependency relationships
- **Cross-Language Support**: Handle imports across language boundaries
- **Refactoring Safety**: Provide data needed for safe symbol renaming

## 📋 **Implementation Roadmap**

### **Phase 1: Tree-Sitter Integration Foundation**
- [ ] **Study existing TsAdapter query system** to understand proven patterns
- [ ] **Create language-specific query builders** using tree-sitter query syntax
- [ ] **Implement proper AST traversal** with cursor management
- [ ] **Add query result processing** that maps to our Symbol structures

**Key Files to Enhance:**
- `src/symbol_resolver.rs` - Add working tree-sitter query execution
- `queries/*.scm` - Expand queries for comprehensive symbol extraction

### **Phase 2: Advanced Semantic Analysis**
- [ ] **Scope tracking during traversal** - Build ScopeFrame hierarchy in real-time
- [ ] **Import resolution system** - Map import aliases to full qualified names
- [ ] **Symbol relationship detection** - Identify inheritance, composition, calls
- [ ] **Cross-reference building** - Create bidirectional relationship mapping
- [ ] **Effect analysis** - Detect IO operations, mutations, side effects

### **Phase 3: Multi-Language Support**
- [ ] **Language-agnostic abstractions** - Common symbol concepts across languages
- [ ] **Language-specific resolvers** - Handle unique language features
- [ ] **Cross-language mapping** - Track dependencies between languages
- [ ] **Module system analysis** - Understand import/export patterns per language

### **Phase 4: Performance Optimization**
- [ ] **Incremental parsing** - Only re-analyze changed sections
- [ ] **Caching system** - Cache symbol extraction results with fingerprinting
- [ ] **Index optimization** - Fast symbol lookup and cross-reference queries
- [ ] **Memory efficiency** - Streaming processing for large codebases

## 🧩 **Technical Architecture**

### **Enhanced Query System**
```rust
pub trait LanguageResolver {
    fn build_queries(&self) -> Vec<Query>;
    fn extract_symbols(&self, tree: &Tree, source: &str) -> Result<Vec<RawSymbol>>;
    fn resolve_relationships(&self, symbols: &[RawSymbol], tree: &Tree) -> Result<Vec<SymbolRelationship>>;
    fn analyze_effects(&self, node: Node, context: &ScopeContext) -> Result<Vec<Effect>>;
}

pub struct DartResolver;
impl LanguageResolver for DartResolver {
    fn build_queries(&self) -> Vec<Query> {
        vec![
            Query::new(DART_LANGUAGE, "(class_definition name: (identifier) @class.name)"),
            Query::new(DART_LANGUAGE, "(method_declaration name: (identifier) @method.name)"),
            Query::new(DART_LANGUAGE, "(import_specification (string_literal) @import.path)"),
            // ... comprehensive dart queries
        ]
    }
}
```

### **Advanced Scope Tracking**
```rust
pub struct ScopeTracker {
    frame_stack: Vec<ScopeFrame>,
    symbol_registry: HashMap<String, String>,
    import_mappings: HashMap<String, String>,
}

impl ScopeTracker {
    fn enter_scope(&mut self, node: Node, kind: FrameKind, name: Option<String>) {
        let frame = ScopeFrame {
            kind: kind.as_str().to_string(),
            name,
            range: self.node_to_range(node),
        };
        self.frame_stack.push(frame);
    }
    
    fn current_context(&self) -> ScopeContext {
        ScopeContext {
            frames: self.frame_stack.clone(),
            qualified_name: self.build_qualified_name(),
            imports: self.import_mappings.clone(),
        }
    }
}
```

### **Semantic Relationship Detection**
```rust
pub fn detect_relationships(symbols: &[Symbol], tree: &Tree) -> Vec<SymbolEdge> {
    let mut relationships = Vec::new();
    
    // Inheritance detection
    for class in symbols.iter().filter(|s| s.kind == "class") {
        if let Some(parent) = find_parent_class(class, tree) {
            relationships.push(SymbolEdge {
                edge_type: "inherits".to_string(),
                target: parent.id,
                at_line: class.range.lines[0],
            });
        }
    }
    
    // Method call detection
    for method_call in find_method_calls(tree) {
        if let Some(target_method) = resolve_method_target(&method_call, symbols) {
            relationships.push(SymbolEdge {
                edge_type: "calls".to_string(),
                target: target_method.id,
                at_line: method_call.line,
            });
        }
    }
    
    relationships
}
```

## 🎯 **Success Metrics**

### **Quantitative Goals**
- [ ] **Symbol extraction accuracy**: 95%+ of symbols found compared to IDE analysis
- [ ] **Relationship detection**: 90%+ of inheritance, composition, calls identified
- [ ] **Cross-reference completeness**: All import/usage relationships mapped
- [ ] **Performance**: <100ms per 1000 LOC for incremental updates

### **Qualitative Goals**
- [ ] **Semantic queries**: Enable "find all uses of Employee as a type" vs variable
- [ ] **Refactoring safety**: Provide data needed for symbol renaming across files
- [ ] **Cross-language analysis**: Track dependencies between Dart→TypeScript→Python
- [ ] **Architecture export**: Generate accurate diagrams from symbol relationships

## ⚠️ **Implementation Risks & Mitigations**

### **Risk 1: Tree-Sitter Query Complexity**
- **Issue**: Different languages have very different AST structures
- **Mitigation**: Start with one language (Dart) and perfect it before expanding
- **Fallback**: Keep TsAdapter working as backup for unsupported analysis

### **Risk 2: Performance with Large Codebases**  
- **Issue**: Full semantic analysis may be slow on 100K+ line projects
- **Mitigation**: Implement incremental analysis and caching from the start
- **Fallback**: Provide fast/detailed analysis modes for different use cases

### **Risk 3: Language Feature Coverage**
- **Issue**: Languages have many edge cases (generics, macros, metaprogramming)
- **Mitigation**: Focus on common patterns first, expand iteratively
- **Fallback**: Graceful degradation to basic symbol extraction for complex cases

## 🏆 **Expected Outcomes**

### **Short Term** (1-2 sprints)
- Native Dart symbol extraction working (replacing 0 symbols with 100+ real symbols)
- Basic scope frame tracking functional
- Import resolution for common patterns

### **Medium Term** (3-6 sprints)  
- Full relationship detection (inheritance, calls, composition)
- Multi-language foundation (Dart + TypeScript)
- Performance optimization with caching

### **Long Term** (6+ sprints)
- Complete language coverage (7+ languages)
- Advanced semantic queries ("find Employee used as type")
- Cross-language dependency analysis
- Real-time incremental updates

## 📚 **Research & References**

### **Tree-Sitter Resources**
- [Tree-sitter Query Syntax](https://tree-sitter.github.io/tree-sitter/using-parsers#query-syntax)
- [Language-specific grammar repositories](https://github.com/tree-sitter)
- [Existing semantic analysis tools](https://github.com/github/semantic) for reference patterns

### **Similar Tools Analysis**
- **Language Server Protocol implementations** - How do they build semantic models?
- **Static analysis tools** (SonarQube, CodeQL) - Query pattern approaches
- **IDE semantic analysis** - What relationships do they track?

---

*This roadmap preserves our vision for native high-fidelity semantic analysis while acknowledging the current hybrid approach is necessary for immediate functionality. The enhanced resolver remains the long-term goal for beating grep with true semantic understanding.*