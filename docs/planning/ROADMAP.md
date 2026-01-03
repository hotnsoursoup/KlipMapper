# AgentMap v2 Roadmap

## Phase 1: Foundation
**Goal**: Cross-file symbol resolution and file management

- File scanning with SHA256 hashing
- SymbolTable with project-wide indexing
- ScopeTracker for nested context
- Cross-file symbol resolution
- Sidecar generation middleware

## Phase 2: Developer Experience
**Goal**: Real-time workflow support

- File watcher with debouncing
- Incremental re-analysis on change
- Check command for CI/CD
- Watch command for live updates
- Validation framework with exit codes

## Phase 3: Export & Integration
**Goal**: Tool ecosystem integration

- Exporter trait with format registry
- GraphML, DOT, Mermaid, HTML formats
- Query command for symbol search
- Architecture layer detection

## Phase 4: Advanced Features
**Goal**: Power user features

- Anchor embedding system
- Query caching with LRU
- Fuzzy pattern matching
- Neo4j/Cypher export
- Design pattern detection
