# AgentMap v2 Backlog

> **Living document** - Updated as work progresses

## Priority 1: Foundation

- [x] **File scanning with hash tracking** - Ported to `scanner/` module with rayon parallel processing, gitignore support, indicatif progress, incremental updates
- [x] **SymbolTable with cross-file indexing** - Implemented in `extensions/linking/symbol_table.rs`
- [x] **Scope tracking infrastructure** - Implemented in `extensions/linking/scope.rs`
- [x] **Basic cross-file resolution** - Implemented in `extensions/linking/` with 10 resolution strategies

## Priority 2: Developer Experience

- [x] **File watcher with incremental update** - Ported to `watcher/` module with notify integration, debouncing, 20 tests
- [x] **Check command** - Ported to `checker/` module with parallel validation, anchor/sidecar support, 21 tests
- [ ] **Watch command** - Real-time analysis mode
- [ ] **Enhanced CLI options** - Depth, filters, output control

## Priority 3: Integration & Export

- [x] **Export format registry** - Trait-based `Exporter` system in `export/` module (12 formats)
- [x] **JSON/YAML export** - Implemented in `export/json.rs`
- [x] **GraphML exporter** - Implemented in `export/graphml.rs` for Gephi/yEd
- [x] **DOT exporter** - Implemented in `export/diagram.rs` for Graphviz
- [x] **Mermaid exporter** - Implemented in `export/diagram.rs`
- [x] **PlantUML exporter** - Implemented in `export/diagram.rs`
- [x] **D2 exporter** - Implemented in `export/diagram.rs`
- [x] **CSV exporter** - Implemented in `export/tabular.rs`
- [x] **Cypher/Neo4j exporter** - Implemented in `export/tabular.rs`
- [x] **HTML report generator** - Implemented in `export/document.rs`
- [x] **Markdown exporter** - Implemented in `export/document.rs`
- [x] **Query command** - Cross-project symbol queries in `query/` module

## Priority 4: Advanced Features

- [x] **Anchor system** - Ported to `anchor/` module with compression (gzip+base64), inline anchors, cross-reference indexing, builder pattern
- [x] **Query caching with LRU** - Ported to `query/` module with glob, regex, fuzzy matching
- [x] **Fuzzy search** - Implemented in `query/matcher.rs` with Jaccard similarity
- [x] **Frontmatter parsing** - Implemented in `util/frontmatter.rs`

## Priority 5: Differentiation Features

> Core differentiators vs Windsurf Codemaps, CodeNav, etc.

- [ ] **Pattern detection** - Auto-detect implementation patterns (e.g., "all services extend BaseService")
- [ ] **Pattern drift detection** - Flag code that deviates from established patterns
- [ ] **Compact agent output** - Minimal context format for LLM consumption
- [ ] **Type lineage tracking** - Track type transformations through call stack
  - Type coercions: `Int → Long → i64`
  - Parameter renames: `id → userId → user_id`
  - Lossy conversion detection
  - Refactoring impact analysis
- [ ] **Multi-language pattern matching** - Detect equivalent patterns across languages

## Priority 6: db-kit Integration

> Replace YAML sidecars with db-kit for persistent, queryable storage

- [ ] **AgentMap db-kit extension** - Custom extension module (don't use generic entities)
  - `symbols` table - Functions, classes, methods, variables
  - `relationships` table - calls, extends, implements, imports, uses
  - `patterns` table - Detected implementation patterns
  - `files` table - File metadata with hash tracking
- [ ] **Schema design** - Code-specific schema, not generic entity model
- [ ] **Indexer → db-kit bridge** - Wire TreeSitter output to db-kit storage
- [ ] **Incremental updates** - Update only changed files on re-index
- [ ] **Hybrid query support** - Leverage db-kit's vector + graph + FTS
- [ ] **Embedding pipeline** - Generate embeddings for symbol signatures

### Why Custom Extension
db-kit's generic entity/relationship model is too abstract for code analysis.
Need code-specific schema with proper types, language awareness, and optimized indexes.

### Location
`E:/shared-libs/sqlite-pool/db-kit/src/extensions/agentmap/` (new extension)

---

## Priority 7: Agentic Graph Layer

> Knowledge Graph + AI Agent integration for intelligent codebase navigation

- [ ] **Graph query interface** - Expose codebase as queryable knowledge graph
- [ ] **Agentic traversal API** - Let LLMs choose traversal strategy (BFS, pattern match, type trace)
- [ ] **Query classification** - Agent categorizes query type to select optimal retrieval
- [ ] **Multi-strategy retrieval** - Support vector search, graph traversal, schema queries
- [ ] **Feedback loops** - Retry with alternative strategy on failure
- [ ] **Grounded responses** - Audit trail linking answers back to source code
- [ ] **MCP integration** - Expose as Model Context Protocol server for any LLM client

### Architecture Vision
```
┌─────────────────────────────────────────┐
│         AI Agent (LLM Client)           │
│  - Query classification                 │
│  - Strategy selection                   │
│  - Failure handling                     │
└──────────────────┬──────────────────────┘
                   │ MCP / API
                   ▼
┌─────────────────────────────────────────┐
│         Agentic Graph Layer             │
│  - Route to optimal retrieval method    │
│  - Combine results from multiple tools  │
└──────────────────┬──────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────┐
│         AgentMap Core                   │
│  - Codebase index                       │
│  - Relationships & patterns             │
│  - Type flows & dependencies            │
└─────────────────────────────────────────┘
```

## Completed

- [x] Middleware stack architecture
- [x] TreeSitter parsing
- [x] Symbol extraction
- [x] Relationship detection
- [x] Incremental analysis
- [x] Embedding integration
- [x] Storage layer
- [x] Chunking strategies
- [x] Directory scanner with rayon parallelism (`scanner/`)
- [x] Query system with LRU cache (`query/`)
- [x] Frontmatter parsing (`util/frontmatter.rs`)
- [x] Export system with 12 formats (`export/`)
- [x] Symbol resolution with 10 strategies (`extensions/linking/`)
- [x] Anchor system with compression (`anchor/`) - 37 tests
- [x] Architecture analysis (`architecture/`) - 25 tests, metrics, patterns, layers
