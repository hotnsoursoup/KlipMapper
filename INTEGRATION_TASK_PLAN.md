# AgentMap Integration Task Plan - 30 Tasks

*Generated: 2025-01-11*

This task plan integrates both documents from `/integrate` to create a comprehensive 30-task implementation plan. The tasks are split into two main integration phases - one for each document.

## Phase 1: Additional Files Enhancement (15 Tasks)
*Based on: AgentMap-Additional-Files-Edits.md*

### Configuration & Query Management (5 Tasks)

**Task 1: Config Validation System**
- **File:** `src/config.rs`
- **Goal:** Add schema and semantic validation with proper error handling
- **Implementation:**
  - Add `validate()` method with schema and semantic checks
  - Implement `ensure_supported_language()` validation
  - Add `ConfigError` enum for typed error handling
  - Validate glob patterns compile correctly
- **Tests:** Invalid language rejection, bad glob errors, validation edge cases
- **Estimated:** 2-3 hours

**Task 2: Environment & Profile Support**
- **File:** `src/config.rs`  
- **Goal:** Support environment variable overrides and configuration profiles
- **Implementation:**
  - Add `load_with_env()` method replacing `load_from_dir()`
  - Implement `apply_env_overrides()` for `AGENTMAP_*` variables
  - Add `apply_profile()` for development/production profiles
  - Support `AGENTMAP_PROFILE` environment variable
- **Tests:** Env override precedence, profile switching, variable parsing
- **Estimated:** 3-4 hours

**Task 3: Robust Glob Implementation**
- **File:** `src/config.rs`
- **Goal:** Replace manual glob matching with `globset` crate
- **Implementation:**
  - Replace `glob_match()` with `build_globset()`
  - Add proper error handling for invalid glob patterns
  - Implement `GlobSet` compilation and caching
  - Update path matching throughout config system
- **Tests:** Complex glob patterns, performance comparison, error cases
- **Estimated:** 2 hours

**Task 4: Query Provider Abstraction**
- **File:** `src/query_pack.rs`
- **Goal:** Abstract query sources with provider pattern
- **Implementation:**
  - Define `QueryProvider` trait with `defs()`, `refs()`, `exports()` methods
  - Implement `EmbeddedProvider` using `include_str!()`
  - Implement `FsProvider` for runtime query overrides
  - Add language expansion for Java, Go, JavaScript, Dart
- **Tests:** Provider switching, query loading, missing query errors
- **Estimated:** 4-5 hours

**Task 5: Query Caching System**
- **File:** `src/query_pack.rs`
- **Goal:** Implement LRU cache for compiled TreeSitter queries
- **Implementation:**
  - Create `QueryCache` struct with `lru::LruCache`
  - Implement cache key with language and content hash
  - Add query validation at startup for enabled languages
  - Provide clear error messages with file context
- **Tests:** Cache hit/miss behavior, invalidation on content changes
- **Estimated:** 3 hours

### Performance & Search Optimization (5 Tasks)

**Task 6: Wildcard Matcher Performance**
- **File:** `src/wildcard_matcher.rs`
- **Goal:** Optimize pattern caching and memory usage
- **Implementation:**
  - Replace `HashMap` with `lru::LruCache` for pattern cache
  - Add configurable cache size limits
  - Implement cache eviction strategies
  - Add performance metrics tracking
- **Tests:** Cache eviction behavior, memory usage bounds, performance benchmarks
- **Estimated:** 2-3 hours

**Task 7: Enhanced Fuzzy Matching**
- **File:** `src/wildcard_matcher.rs`
- **Goal:** Replace manual Levenshtein with `fuzzy-matcher` library
- **Implementation:**
  - Integrate `fuzzy_matcher::skim::SkimMatcherV2`
  - Replace `fuzzy_similarity()` and `levenshtein_distance()`
  - Add configurable fuzzy matching thresholds
  - Implement scoring normalization
- **Tests:** Fuzzy quality benchmarks, score consistency, threshold behavior
- **Estimated:** 2-3 hours

**Task 8: Parallel Search Implementation**
- **File:** `src/wildcard_matcher.rs`
- **Goal:** Add parallel search capabilities using rayon
- **Implementation:**
  - Implement `par_iter()` for multi-scope searches
  - Add worker chunking strategy
  - Implement bounded binary heap for top-k results
  - Add memory limits per worker
- **Tests:** Parallel consistency, performance scaling, memory bounds
- **Estimated:** 4 hours

**Task 9: Advanced Ranking System**
- **File:** `src/wildcard_matcher.rs`
- **Goal:** Implement sophisticated result ranking with feature breakdown
- **Implementation:**
  - Add prefix bonus, camel/snake case token overlap
  - Implement path proximity scoring
  - Add per-feature contribution tracking
  - Expose ranking breakdown to callers
- **Tests:** Ranking consistency, feature contribution accuracy
- **Estimated:** 3 hours

**Task 10: Architecture Metrics Implementation**
- **File:** `src/architecture_exporter.rs`
- **Goal:** Replace placeholder metrics with real implementations
- **Implementation:**
  - Implement `cyclomatic_complexity()` with decision point counting
  - Add `cognitive_complexity()` with Sonar-like heuristics
  - Implement circular dependency detection using `petgraph`
  - Add real source snippet extraction with `SourceMap`
- **Tests:** Metrics accuracy, SCC detection, snippet extraction
- **Estimated:** 5-6 hours

### Integration & Export Systems (5 Tasks)

**Task 11: Pattern Detection Algorithms**
- **File:** `src/architecture_exporter.rs`  
- **Goal:** Implement AST-based pattern recognition
- **Implementation:**
  - Create `PatternDetector` trait framework
  - Implement Singleton pattern detection (private constructor + static accessor)
  - Add Factory pattern detection (subtype/trait returning methods)
  - Implement Observer pattern detection (subject-listener collections)
- **Tests:** Pattern recognition accuracy, false positive/negative rates
- **Estimated:** 4-5 hours

**Task 12: Export Formats Module**
- **File:** `src/export_formats.rs` (new)
- **Goal:** Create pluggable export system for architecture data
- **Implementation:**
  - Define `Exporter` trait with `export()` method
  - Implement JSON, CSV, DOT, Mermaid exporters
  - Add streaming writers for memory efficiency
  - Implement `for_format()` factory function
- **Tests:** Format consistency, streaming behavior, output validation
- **Estimated:** 3-4 hours

**Task 13: Symbol Table Foundation**
- **File:** `src/symbol_table.rs` (new)
- **Goal:** Create core cross-reference and indexing system
- **Implementation:**
  - Design `SymbolTable` with numeric IDs for performance
  - Implement `build_from_anchor_headers()` integration
  - Add `lookup_name()`, `outgoing()` query methods
  - Create binding resolution with `BindingId` support
- **Tests:** Symbol resolution, cross-reference accuracy, binding chains
- **Estimated:** 5-6 hours

**Task 14: CLI Data Integration**
- **File:** `src/cli.rs`
- **Goal:** Replace demo data with real symbol resolution
- **Implementation:**
  - Wire real `load_anchor_headers_from_sidecars()`
  - Replace demo `SymbolTable` with `build_from_anchor_headers()`
  - Integrate architecture exporter with real headers
  - Add progress indicators using `indicatif`
- **Tests:** End-to-end CLI workflows, progress display, error handling
- **Estimated:** 3-4 hours

**Task 15: CLI UX Improvements**
- **File:** `src/cli.rs`
- **Goal:** Enhance user experience with validation and diagnostics
- **Implementation:**
  - Add comprehensive command validation
  - Implement user-friendly error messages with context
  - Add `--quiet/--verbose` flags with proper logging levels
  - Integrate configuration system with CLI commands
- **Tests:** Command validation, error message clarity, logging levels
- **Estimated:** 2-3 hours

---

## Phase 2: Identity & Resolution System (15 Tasks) 
*Based on: AgentMap_vNext_Identity_Resolve_Graph.md*

### File Identity & URI System (5 Tasks)

**Task 16: File Identity System**
- **Files:** `src/core/symbol_types.rs`, new `src/identity.rs`
- **Goal:** Implement stable file identity across edits and renames
- **Implementation:**
  - Create `FileId` struct with NFC path normalization
  - Add `FileSnapshot` for mutable change detection
  - Implement device/inode tracking for rename detection
  - Add case-sensitive/insensitive filesystem handling
- **Tests:** Path round-trip, Unicode handling, rename detection
- **Estimated:** 4-5 hours

**Task 17: Canonical URI System**
- **Files:** `src/identity.rs`, `src/core/symbol_types.rs`
- **Goal:** Implement URN-based canonical identifiers
- **Implementation:**
  - Design `SymbolId` with URN format: `urn:agentmap:symbol:...`
  - Implement `BindingId` for exported bindings
  - Add RFC 3986 percent-encoding for special characters
  - Create parser/formatter with round-trip tests
- **Tests:** URI parsing, encoding edge cases, round-trip validation
- **Estimated:** 3-4 hours

**Task 18: Qualified Scope Rules**
- **Files:** `src/core/symbol_types.rs`, `src/parsers/`
- **Goal:** Implement language-specific module path resolution
- **Implementation:**
  - Add TypeScript/JavaScript Node resolution with `tsconfig` support
  - Implement Python PEP 420 namespace package support
  - Add Go module path from `go.mod` + package directories
  - Implement Rust crate + module tree resolution
- **Tests:** Module resolution per language, complex import paths
- **Estimated:** 5-6 hours

**Task 19: Signature Hash System**
- **Files:** `src/identity.rs`
- **Goal:** Implement disambiguation hashing for overloads
- **Implementation:**
  - Create signature tuple extraction per language
  - Implement parameter type normalization
  - Add `blake3` hashing with 10-character hex output
  - Handle method overloads, Rust trait vs impl methods
- **Tests:** Hash stability, overload disambiguation, type normalization
- **Estimated:** 3-4 hours

**Task 20: Canonical Kind System**
- **Files:** `src/core/symbol_types.rs`
- **Goal:** Standardize symbol kinds across languages
- **Implementation:**
  - Define canonical kind enum with stable string values
  - Map language-specific AST node types to canonical kinds
  - Add kind compatibility scoring for ranking
  - Implement accessor metadata preservation
- **Tests:** Kind mapping consistency, compatibility scoring
- **Estimated:** 2 hours

### Multi-Edge Graph & Scheduling (5 Tasks)

**Task 21: Multi-Edge Graph Structure**
- **Files:** `src/core/relationship_analyzer.rs`, new `src/graph.rs`
- **Goal:** Implement multi-edge graph with origin tracking
- **Implementation:**
  - Create `EdgeKey` and `EdgeValue` structures
  - Implement `RelationshipGraph` with `by_origin` indexing
  - Add reverse index for efficient reverse lookups
  - Implement RCU-style visibility with generation counters
- **Tests:** Edge insertion, origin-based removal, visibility consistency
- **Estimated:** 4-5 hours

**Task 22: Incremental SCC Scheduling**
- **Files:** `src/core/relationship_analyzer.rs`, new `src/scheduler.rs`
- **Goal:** Dynamic dependency tracking with on-demand SCC resolution
- **Implementation:**
  - Create `Scheduler` with pending dependency tracking
  - Implement dynamic candidate queue with backpressure
  - Add SCC computation over indexed subgraphs
  - Use `tokio::sync` for async coordination
- **Tests:** Dependency resolution order, SCC batching, backpressure
- **Estimated:** 5-6 hours

**Task 23: Generation-Based Visibility**
- **Files:** `src/graph.rs`
- **Goal:** Implement RCU-style consistent reads during updates
- **Implementation:**
  - Add generation counter to graph structure
  - Implement atomic `committed_gen` with acquire/release semantics
  - Filter edge visibility based on generation in queries
  - Add batch commit operations
- **Tests:** Read consistency, generation ordering, concurrent access
- **Estimated:** 3 hours

**Task 24: Language-Specific Edge Cases**
- **Files:** `src/parsers/*.rs`
- **Goal:** Handle complex import/export patterns per language
- **Implementation:**
  - TypeScript: default exports, namespace exports, declaration merging
  - Python: PEP 420 namespace packages, `sys.path` resolution
  - Go: methods on named non-struct types
  - Rust: trait declarations vs impl methods
- **Tests:** Complex import patterns, re-export chains, edge case handling
- **Estimated:** 6 hours

**Task 25: Binding Resolution System**
- **Files:** `src/core/symbol_types.rs`, `src/identity.rs`
- **Goal:** Implement export binding resolution with re-export chains
- **Implementation:**
  - Create `ModuleExports` and `ModuleReexports` tables
  - Implement `BindingId` → `SymbolId` resolution
  - Add re-export chain following with cycle detection
  - Handle proxy namespaces for wildcard exports
- **Tests:** Re-export chains, cycle detection, proxy namespace resolution
- **Estimated:** 4 hours

### Advanced Ranking & Analysis (5 Tasks)

**Task 26: Enhanced Ranking Signals**
- **Files:** `src/wildcard_matcher.rs`, new `src/ranking.rs`
- **Goal:** Implement comprehensive ranking with explainable features
- **Implementation:**
  - Add frequency/popularity signal from usage data
  - Implement document/context token overlap with TF-IDF
  - Add single-token edit distance bonuses
  - Implement import distance penalties
- **Tests:** Signal accuracy, ranking stability, feature contributions
- **Estimated:** 4-5 hours

**Task 27: Per-Language Ranking Weights**
- **Files:** `src/ranking.rs`
- **Goal:** Optimize ranking weights per programming language
- **Implementation:**
  - Define language-specific weight profiles
  - Implement weight configuration system
  - Add ranking explanation with contribution breakdown
  - Provide English summary generation for rankings
- **Tests:** Language-specific accuracy, explanation quality
- **Estimated:** 2-3 hours

**Task 28: Usage Analysis System**
- **Files:** `src/core/relationship_analyzer.rs`
- **Goal:** Resolve usage sites to bindings with diagnostic context
- **Implementation:**
  - Implement usage site → `BindingId` resolution
  - Add binding → symbol resolution with re-export tracking
  - Create diagnostic messages for re-export chains
  - Track usage frequency for ranking signals
- **Tests:** Usage resolution accuracy, diagnostic quality, frequency tracking
- **Estimated:** 4 hours

**Task 29: Two-Pass Pipeline Integration**
- **Files:** `src/core/relationship_analyzer.rs`, `src/scheduler.rs`
- **Goal:** Integrate indexing and resolution with incremental scheduling
- **Implementation:**
  - Implement index phase with dependency publication
  - Add resolve phase with SCC-aware scheduling
  - Integrate with existing TreeSitter engine
  - Add progress tracking and error handling
- **Tests:** End-to-end pipeline, incremental updates, error recovery
- **Estimated:** 5-6 hours

**Task 30: Integration Testing & Validation**
- **Files:** `tests/integration/`
- **Goal:** Comprehensive integration tests for full system
- **Implementation:**
  - Create multi-language test fixtures with complex scenarios
  - Test file identity across filesystem operations
  - Validate URI encoding/decoding round-trips
  - Test incremental updates and graph consistency
  - Add performance benchmarks for large codebases
- **Tests:** Complete system validation, performance regression tests
- **Estimated:** 4-5 hours

---

## Implementation Order & Dependencies

### Sprint 1: Foundation (Tasks 1-10)
*Config system, query management, performance optimizations*

### Sprint 2: Architecture & Export (Tasks 11-15) 
*Pattern detection, export systems, CLI integration*

### Sprint 3: Identity System (Tasks 16-20)
*File identity, URI system, signature hashing*

### Sprint 4: Graph & Scheduling (Tasks 21-25)
*Multi-edge graph, incremental processing, binding resolution*

### Sprint 5: Advanced Features (Tasks 26-30)
*Enhanced ranking, usage analysis, integration testing*

## Success Metrics

- **Phase 1 Complete:** All placeholder implementations replaced, real metrics operational
- **Phase 2 Complete:** Incremental analysis working, identity system stable  
- **Full Integration:** End-to-end symbol resolution with consistent URIs
- **Performance:** Sub-second analysis on medium codebases (1000+ files)
- **Correctness:** 95%+ accuracy on symbol resolution test suite

## Risk Mitigation

1. **Complex Integration:** Each task includes focused unit tests before integration
2. **Performance Regression:** Benchmarks run on each major change
3. **URI Compatibility:** Extensive round-trip testing with edge cases
4. **Memory Usage:** Bounded caches and streaming operations throughout
5. **Incremental Correctness:** Comprehensive test fixtures for update scenarios

This plan provides a structured path to integrate both enhancement documents into a cohesive, production-ready symbol resolution system.