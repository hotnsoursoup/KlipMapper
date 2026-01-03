# AgentMap v2 Backlog

> **Living document** - Updated as work progresses

## Priority 1: Foundation

- [ ] **File scanning with hash tracking** - Port from v1 `fs_scan.rs`
- [ ] **SymbolTable with cross-file indexing** - Enhance `extensions/linking/`
- [ ] **Scope tracking infrastructure** - Port from v1 `scope_tracker.rs`
- [ ] **Basic cross-file resolution** - Port from v1 `symbol_resolver.rs`

## Priority 2: Developer Experience

- [ ] **File watcher with incremental update** - Port from v1 `watcher.rs`
- [ ] **Check command** - Port validation framework from v1 `checker.rs`
- [ ] **Watch command** - Real-time analysis mode
- [ ] **Enhanced CLI options** - Depth, filters, output control

## Priority 3: Integration & Export

- [ ] **Export format registry** - Trait-based exporter system
- [ ] **GraphML exporter** - For Gephi/yEd
- [ ] **DOT exporter** - For Graphviz
- [ ] **Mermaid exporter** - For diagrams
- [ ] **HTML report generator** - Interactive reports
- [ ] **Query command** - Cross-project symbol queries

## Priority 4: Advanced Features

- [ ] **Anchor system** - Embedded metadata headers
- [ ] **Query caching with LRU** - Performance optimization
- [ ] **Fuzzy search** - Pattern matching
- [ ] **Cypher/Neo4j export** - Graph database integration

## Completed

- [x] Middleware stack architecture
- [x] TreeSitter parsing
- [x] Symbol extraction
- [x] Relationship detection
- [x] Incremental analysis
- [x] Embedding integration
- [x] Storage layer
- [x] Chunking strategies
