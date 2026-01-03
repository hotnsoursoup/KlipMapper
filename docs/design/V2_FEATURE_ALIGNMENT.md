# AgentMap v2 Feature Alignment

> **Purpose**: Comprehensive design for aligning v2 architecture with v1 features, ensuring robust, well-designed, decoupled implementation.

## Architecture Principles

### Core Design Goals
1. **Middleware-first**: All cross-cutting concerns as composable middleware
2. **Trait-based abstraction**: Every major component behind a trait for testability
3. **Domain separation**: Clear boundaries between parsing, analysis, storage, export
4. **Feature-gated extensions**: Optional features don't bloat core binary

---

## Feature Categories

### Category 1: Core Analysis Pipeline
*Already in v2, needs enhancement*

| Feature | Status | Dedicated Doc? |
|---------|--------|----------------|
| TreeSitter parsing | Done | No |
| Symbol extraction | Done | No |
| Relationship detection | Done | No |
| Multi-language support | Done | No |

### Category 2: File Operations (Port from v1)
*Critical for developer workflow*

| Feature | Status | Dedicated Doc? |
|---------|--------|----------------|
| File scanning with hashing | Missing | **Yes** |
| File watching (real-time) | Missing | **Yes** |
| Sidecar generation | Partial | No (part of middleware) |

**Recommended Design Doc**: `FILE_OPERATIONS.md`
- FileScanner trait + implementations
- Watcher trait with debouncing
- Hash-based change detection
- Integration with incremental analysis

### Category 3: Symbol Resolution (Port from v1)
*Critical for cross-file analysis*

| Feature | Status | Dedicated Doc? |
|---------|--------|----------------|
| SymbolTable (project-wide) | Partial in extensions | **Yes** |
| Cross-file resolution | Missing | **Yes** |
| Import alias mapping | Missing | Part of resolution |
| Scope tracking | Missing | **Yes** |

**Recommended Design Doc**: `SYMBOL_RESOLUTION.md`
- SymbolTable structure and indexing
- ResolutionChain for tracking lookups
- ScopeTracker for nested context
- Namespace handling per language

### Category 4: Export System (Port from v1)
*Critical for tool integration*

| Feature | Status | Dedicated Doc? |
|---------|--------|----------------|
| JSON/YAML export | Done | No |
| GraphML (Gephi/yEd) | Missing | No |
| DOT (Graphviz) | Missing | No |
| Mermaid diagrams | Missing | No |
| Cypher (Neo4j) | Missing | No |
| HTML reports | Missing | No |
| CSV | Missing | No |
| PlantUML | Missing | No |

**Recommended Design Doc**: `EXPORT_FORMATS.md`
- Exporter trait with format registry
- Format-specific serializers
- Template-based generators (Mermaid, PlantUML)
- Streaming export for large codebases

### Category 5: CLI & Validation (Port from v1)
*Critical for usability*

| Feature | Status | Dedicated Doc? |
|---------|--------|----------------|
| analyze command | Done | No |
| scan command | Done | No |
| check command | Missing | No |
| watch command | Missing | No |
| query command | Missing | No |
| embed command | Missing | No |

**Recommended Design Doc**: `CLI_COMMANDS.md`
- Command structure and shared options
- Validation framework (CheckResult states)
- Exit codes for CI/CD
- Interactive vs batch modes

### Category 6: Anchor System (Port from v1)
*For embedded documentation*

| Feature | Status | Dedicated Doc? |
|---------|--------|----------------|
| Anchor headers | Missing | **Yes** |
| Compression (gzip+base64) | Missing | Part of anchors |
| Scope frames in anchors | Missing | Part of anchors |

**Recommended Design Doc**: `ANCHOR_SYSTEM.md`
- AnchorHeader structure
- Compression strategy
- Embedding locations per language
- Parser integration

### Category 7: Query & Caching (Port from v1)
*For performance*

| Feature | Status | Dedicated Doc? |
|---------|--------|----------------|
| Query caching (LRU) | Missing | No |
| Pattern matching | Missing | No |
| Fuzzy search | Missing | No |

**Recommended Design Doc**: `QUERY_CACHING.md`
- QueryCache with LRU eviction
- Content-based cache keys (SHA256)
- Fuzzy matcher integration

### Category 8: v2-Native Features
*New in v2, enhance further*

| Feature | Status | Dedicated Doc? |
|---------|--------|----------------|
| Middleware stack | Done | No (well-designed) |
| Incremental analysis | Done | No |
| Embedding integration | Done | No |
| Storage layer | Done | No |
| Chunking strategies | Done | No |

---

## Recommended Design Documents

Based on complexity and scope, these features warrant dedicated design docs:

### Tier 1: High Complexity (Full Design Doc)

1. **`SYMBOL_RESOLUTION.md`**
   - SymbolTable architecture
   - Cross-file resolution algorithm
   - Import/namespace handling
   - Scope tracking integration
   - Language-specific quirks

2. **`FILE_OPERATIONS.md`**
   - FileScanner design
   - Watcher implementation
   - Hash-based diffing
   - Sidecar lifecycle

3. **`EXPORT_FORMATS.md`**
   - Exporter trait design
   - Format registry pattern
   - Template-based generation
   - Streaming for scale

### Tier 2: Medium Complexity (Section in parent doc or standalone)

4. **`ANCHOR_SYSTEM.md`**
   - Embedded metadata design
   - Compression approach
   - IDE integration

5. **`CLI_COMMANDS.md`**
   - Command patterns
   - Validation framework
   - Exit code conventions

### Tier 3: Low Complexity (No dedicated doc)

- Query caching (inline in architecture doc)
- Individual export formats (subsection of EXPORT_FORMATS)
- Middleware additions (follow existing patterns)

---

## Implementation Order

### Phase 1: Foundation (File + Symbol)
1. File scanning with hash tracking
2. SymbolTable with cross-file indexing
3. Scope tracking infrastructure
4. Basic cross-file resolution

### Phase 2: Developer Experience
5. File watcher with incremental update
6. Check command with validation
7. Watch command for real-time
8. Enhanced CLI options

### Phase 3: Integration & Export
9. Export format registry
10. GraphML, DOT, Mermaid exporters
11. HTML report generator
12. Query command

### Phase 4: Advanced Features
13. Anchor system
14. Query caching with LRU
15. Fuzzy search
16. Cypher/Neo4j export

---

## Module Organization

```
agentmap-v2/src/
├── core/                    # Data types (done)
├── parser/                  # TreeSitter integration (done)
├── analyzer/                # Analysis pipeline (done)
├── middleware/              # Cross-cutting concerns (done)
├── extensions/
│   ├── linking/             # Symbol resolution (enhance)
│   ├── incremental/         # Delta analysis (done)
│   ├── chunking/            # LLM chunking (done)
│   └── enrichment/          # Context enrichment (done)
├── io/                      # NEW: File operations
│   ├── scanner.rs           # File discovery + hashing
│   ├── watcher.rs           # Real-time watching
│   └── sidecar.rs           # YAML sidecar I/O
├── export/                  # NEW: Export system
│   ├── mod.rs               # Exporter trait + registry
│   ├── json.rs              # JSON format
│   ├── graphml.rs           # GraphML format
│   ├── dot.rs               # Graphviz DOT
│   ├── mermaid.rs           # Mermaid diagrams
│   └── html.rs              # HTML reports
├── validation/              # NEW: Check framework
│   ├── checker.rs           # Sidecar validation
│   └── result.rs            # CheckResult types
├── anchor/                  # NEW: Anchor system
│   ├── header.rs            # AnchorHeader struct
│   ├── compress.rs          # Compression utils
│   └── embed.rs             # Embedding logic
├── query/                   # NEW: Query system
│   ├── cache.rs             # LRU query cache
│   └── matcher.rs           # Pattern matching
└── cli/                     # CLI (enhance)
    ├── commands/
    │   ├── analyze.rs
    │   ├── scan.rs
    │   ├── check.rs         # NEW
    │   ├── watch.rs         # NEW
    │   └── query.rs         # NEW
    └── mod.rs
```

---

## Service Layer Design

### Shared Services

```rust
// Configuration provider
trait ConfigProvider: Send + Sync {
    fn get_config(&self) -> &Config;
}

// Symbol table service
trait SymbolService: Send + Sync {
    fn register(&self, symbol: Symbol);
    fn lookup(&self, name: &str) -> Option<&Symbol>;
    fn resolve(&self, reference: &str, context: &ScopeContext) -> Option<&Symbol>;
}

// File service
trait FileService: Send + Sync {
    fn scan(&self, paths: &[PathBuf]) -> Vec<ScannedFile>;
    fn hash(&self, path: &Path) -> FileHash;
    fn is_changed(&self, path: &Path, cached_hash: &FileHash) -> bool;
}

// Export service
trait ExportService: Send + Sync {
    fn export(&self, analysis: &CodeAnalysis, format: ExportFormat) -> Result<String>;
    fn register_format(&mut self, format: Box<dyn Exporter>);
}
```

### Dependency Injection

```rust
struct ServiceContainer {
    config: Arc<dyn ConfigProvider>,
    symbols: Arc<dyn SymbolService>,
    files: Arc<dyn FileService>,
    export: Arc<dyn ExportService>,
}
```

---

## Next Steps

1. Review and approve this feature alignment
2. Create individual design docs for Tier 1 features
3. Begin Phase 1 implementation
4. Update CLAUDE.md to reference v2 docs structure
