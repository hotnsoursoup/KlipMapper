# AgentMap • Additional Files — Recommended Edits
*Prepared: 2025-08-11*

This is a pragmatic, implementation-ready pass over the files called out in
**Additional Files Enhancement Analysis (2025‑01‑11)**. It balances scope and
ROI, gives concrete edits (with short diffs), and slices the work into small PRs.

---

## Quick priorities (impact × effort)

| File                         | Impact | Effort | Why now                                                |
|-----------------------------|:------:|:------:|--------------------------------------------------------|
| `src/architecture_exporter.rs` |  🔥   |  🔧🔧  | Metrics/algos incomplete; drives most user value      |
| `src/query_pack.rs`         |  🔥   |  🔧🔧  | Unblock more langs + unify w/ modern TS engine        |
| `src/cli.rs`                |  🔥   |  🔧    | Wire real data, UX, progress, validations             |
| `src/config.rs`             |  🔶   |  🔧    | Validation, env/profile overrides, glob robustness    |
| `src/wildcard_matcher.rs`   |  🔶   |  🔧    | Perf + memory; better fuzzy & ranking                 |
| `src/export_formats.rs`     |  🔥   |  🔧    | Missing module blocks exporter delivery                |
| `src/symbol_table.rs`       |  🔥   |  🔧🔧  | Core XRef/index; needed by CLI/exporter               |

Legend: Impact 🔥 high / 🔶 medium; Effort wrench count≈relative effort.

---

## 1) `src/config.rs` — validation, env, profiles, robust globs

**Add crates:** `serde`, `serde_yaml`, `schemars`, `jsonschema`, `globset`,
`thiserror`, `camino`, `notify` (optional hot‑reload).

### Edits

**A. Schema & semantic validation**

```diff
 pub struct AgentMapConfig { /* ... */ }
 
 impl AgentMapConfig {
-  pub fn merge_defaults(mut self, defaults: Self) -> Self { /* ... */ }
+  pub fn merge_defaults(mut self, defaults: Self) -> Self { /* ... */ }
+
+  pub fn validate(&self) -> Result<(), ConfigError> {
+    self.validate_schema()?;
+    self.validate_semantics()?;
+    Ok(())
+  }
+
+  fn validate_schema(&self) -> Result<(), ConfigError> {
+    // optional: generate JSON Schema via schemars once; validate at load
+    Ok(())
+  }
+
+  fn validate_semantics(&self) -> Result<(), ConfigError> {
+    if let Some(langs) = &self.languages {
+      for l in langs {
+        ensure_supported_language(l)?;
+      }
+    }
+    // verify globs compile; paths exist when required, etc.
+    Ok(())
+  }
 }
```

**B. Env overrides + profiles**

```diff
 impl AgentMapConfig {
-  pub fn load(root: &Path) -> Result<Self> { /* yaml only */ }
+  pub fn load_with_env(root: &Path) -> Result<Self> {
+    let mut cfg = Self::load_yaml(root)?;
+    let profile = std::env::var("AGENTMAP_PROFILE")
+      .ok().unwrap_or_else(|| "default".into());
+    cfg.apply_profile(&profile);
+    cfg.apply_env_overrides("AGENTMAP_")?;
+    cfg.validate()?;
+    Ok(cfg)
+  }
+
+  fn apply_env_overrides(&mut self, prefix: &str) -> Result<()> {
+    // Map env like AGENTMAP_LANGUAGES=ts,py to fields; small hand-rolled parser
+    // avoids a heavy dep; use comma-split + trim.
+    if let Ok(val) = std::env::var(format!("{prefix}LANGUAGES")) {
+      self.languages = Some(val.split(',').map(|s| s.trim().to_string())
+                         .collect());
+    }
+    Ok(())
+  }
```

**C. Robust globs** (replace ad‑hoc with `globset`)

```diff
- fn glob_match(pattern: &str, path: &str) -> bool { /* manual */ }
+ fn build_globset(patterns: &[String]) -> Result<globset::GlobSet> {
+   let mut b = globset::GlobSetBuilder::new();
+   for p in patterns { b.add(globset::Glob::new(p)?); }
+   Ok(b.build()?)
+ }
```

**Optional D. Hot reload**

- Use `notify` watcher; debounce ~250ms; call `load_with_env()` and re‑emit a
  `ConfigUpdated` event.

**Tests**
- Invalid lang name rejected; bad glob errors; env overrides precedence.
- Profiles switch include/exclude sets correctly.

---

## 2) `src/query_pack.rs` — dynamic queries, more langs, caching

**Add crates:** `lru`, `anyhow`, `thiserror`, `include_dir` (optional embed),
`tree-sitter` language crates for Go/Java/JS/Dart.

### Edits

**A. Abstract query source**

```rust
pub trait QueryProvider: Send + Sync {
    fn defs(&self, lang: Lang) -> Result<String>;
    fn refs(&self, lang: Lang) -> Result<String>;
    fn exports(&self, lang: Lang) -> Result<String>;
}
```

Provide two impls:

- `EmbeddedProvider` using `include_str!()` or `include_dir!()`.
- `FsProvider { root: PathBuf }` for runtime overrides (`--queries <dir>`).

**B. Compiled query cache**

```rust
struct QueryCache {
    defs: lru::LruCache<(Lang, u64), tree_sitter::Query>,
    // key includes version hash of source text
}
```

**C. Language expansion**

- Add `Lang::{Java, Go, JavaScript, Dart}`.
- Wire per‑lang grammar and minimal baseline queries; fail gracefully with a
  clear error if a query is missing: “query `exports` for Dart not found”.

**D. Validation**

- Compile queries at startup for enabled languages; surface line/column on
  failure with a file hint (FsProvider) or embedded path (EmbeddedProvider).

**CLI hook**

- Add `--queries <dir>` and `--list-queries` to print what’s loaded.

**Tests**

- Round‑trip: FsProvider overrides EmbeddedProvider.
- Cache hit/miss when changing query file content (hash changes).

---

## 3) `src/wildcard_matcher.rs` — perf, fuzzy, ranking

**Add crates:** `lru`, `rayon`, `fuzzy-matcher` (Skim), `regex` or
`regex-automata`, `ahash` (hash map perf).

### Edits

**A. Bounded caches**

```diff
- pattern_cache: HashMap<String, Regex>
+ pattern_cache: lru::LruCache<String, Regex> // capacity via config
```

**B. Fuzzy matching via library**

```rust
use fuzzy_matcher::skim::SkimMatcherV2;
use fuzzy_matcher::FuzzyMatcher;

fn fuzzy_score(pat: &str, candidate: &str) -> Option<i64> {
    static MATCHER: once_cell::sync::Lazy<SkimMatcherV2> =
        once_cell::sync::Lazy::new(SkimMatcherV2::default);
    MATCHER.fuzzy_match(candidate, pat)
}
```

**C. Parallel search**

- When searching many scopes/files, chunk and `par_iter()` with `rayon`,
  returning top‑k with a bounded binary heap per worker to limit memory.

**D. Ranking function**

Add features (keep cheap): prefix bonus, camel/snake token overlap, path
proximity. Expose per‑feature breakdown to callers.

**Tests**

- Cache eviction predictable; fuzzy quality vs known benchmarks; parallel
  results consistent regardless of thread count.

---

## 4) `src/architecture_exporter.rs` — real metrics, cycles, patterns

**Add crates:** `petgraph`, `serde`, `serde_json`, `csv`, `itertools`,
`regex` (for some heuristics), `once_cell`.

### Edits

**A. Cognitive & cyclomatic complexity**

Implement minimal, language‑agnostic versions (good enough across TS/Rust/Py):

```rust
/// Cyclomatic: #decision points + 1
fn cyclomatic(stmt_nodes: &[Node]) -> u32 { /* count if/for/while/case && || */ }

/// Cognitive: Sonar-like heuristic: +nesting, +breaks in flow, +recursion
fn cognitive(stmt_nodes: &[Node]) -> u32 {
    let mut score = 0;
    let mut depth = 0;
    for n in preorder(stmt_nodes) {
        match n.kind {
            IF | LOOP | MATCH => { score += 1 + depth; depth += 1; }
            CATCH | CONTINUE | BREAK | GOTO => score += 1 + depth,
            RETURN if !n.is_tail => score += 1,
            _ => {}
        }
        if ends_block(n) { depth = depth.saturating_sub(1); }
    }
    score
}
```

Wire these where placeholders exist; average per symbol/file/module as needed.

**B. Circular dependencies**

```rust
use petgraph::graphmap::DiGraphMap;
use petgraph::algo::kosaraju_scc;

fn find_cycles(edges: &[(SymbolId, SymbolId)]) -> Vec<Vec<SymbolId>> {
    let mut g = DiGraphMap::new();
    for (a,b) in edges { g.add_edge(*a, *b, ()); }
    kosaraju_scc(&g).into_iter().filter(|c| c.len() > 1).collect()
}
```

**C. Pattern detection (AST + graph), not names**

- **Singleton:** class with private/new‑restricted constructor + static
  accessor; in TS/Java detect `private constructor` + `static instance`.
- **Factory:** function/method returning subtype or trait impl.
- **Observer:** edge pattern: subject has collection of listeners; calls
  `on*` methods inside a notify loop.
- Implement as pluggable detectors:
  `trait PatternDetector { fn run(&self, model: &Model) -> Vec<Finding>; }`

**D. Source snippet extraction**

- Keep `SourceMap` of `(file_id, byte_range)` from parser; extract lines with
  context; trim with ellipses when long.

**E. Outputs**

- JSON (machine), CSV (metrics), DOT/Mermaid (graphs). Factor via an
  `export_formats` module (see below).

**Tests**

- Golden files for JSON/CSV; small synthetic code for each pattern; SCC
  fixtures; metrics sanity (monotonic w.r.t adding branches).

---

## 5) `src/cli.rs` — real data path, UX, validation

**Add crates:** `clap` (derive), `anyhow`, `thiserror`, `indicatif`, `miette`
(optional diagnostics).

### Edits

**A. Wire real symbol table**

```diff
- let headers = vec![]; // TODO
- let mut symbol_table = demo_symbol_table();
+ let headers = load_anchor_headers_from_sidecars(&export_path)?;
+ let symbol_table = symbol_table::build_from_anchor_headers(&headers)?;
```

**B. Progress & logging**

- Use `indicatif::ProgressBar` for long ops; show #files, #symbols, phase.
- Add `--quiet/--verbose` flags; `--json-errors` for tooling.

**C. Command validation**

- Disallow incompatible flags early with helpful messages.
- Validate output format against subcommand (`export --format csv/json/dot`).

**D. Errors**

- Convert internal errors to user‑friendly diagnostics with context
  (file, line, hint).

**Tests**

- CLI help coverage; argument matrices; progress bar not emitted under `--quiet`.

---

## 6) New: `src/export_formats.rs` — pluggable exporters

```rust
pub enum ExportFormat { Json, Csv, Dot, Mermaid }

pub trait Exporter {
    fn export<W: std::io::Write>(
        &self,
        model: &ArchitectureModel,
        out: &mut W,
    ) -> anyhow::Result<()>;
}

pub fn for_format(fmt: ExportFormat) -> Box<dyn Exporter> { /* ... */ }
```

- Implement Json (serde_json), Csv (metrics rows), Dot/Mermaid for graphs.
- Keep zero‑alloc-ish writers; stream rows to avoid big buffers.

---

## 7) New: `src/symbol_table.rs` — xref & bindings

Sketch the minimal shape to unblock CLI/exporter (aligns with modern engine).

```rust
pub struct SymbolTable {
    // numeric ids are faster; keep maps for name->ids
    by_id: Vec<Symbol>,
    name_idx: indexmap::IndexMap<String, Vec<SymbolId>>,
    bindings: indexmap::IndexMap<BindingId, SymbolId>,
    edges: Vec<(SymbolId, SymbolId, Relationship)>,
}

impl SymbolTable {
    pub fn build_from_anchor_headers(headers: &[AnchorHeader]) -> Result<Self> { /* ... */ }
    pub fn lookup_name(&self, name: &str) -> &[SymbolId] { /* ... */ }
    pub fn outgoing(&self, id: SymbolId) -> impl Iterator<Item=SymbolId> { /* ... */ }
}
```

Tests: load tiny fixtures; check that bindings resolve and edges exist.

---

## 8) Integration edges & data flow

- **Config → QueryPack:** allow `config.queries_dir` to override FsProvider.
- **QueryPack → SymbolTable:** standardize `Symbol`, `BindingId` types.
- **SymbolTable → Exporter:** exporter only reads the model; no parsing logic.
- **CLI → Everything:** subcommands call build → report progress → export.

---

## 9) PR slicing (approx order)

1. Config validation + globset + env/profile; unit tests.
2. QueryPack refactor (provider + cache) + add JS/Go; `--queries` flag.
3. SymbolTable skeleton + CLI wiring (replace demo); minimal tests.
4. Export formats module (JSON/CSV/DOT); hook into CLI.
5. ArchitectureExporter: cyclomatic/cognitive + SCC detection + snippets.
6. Wildcard matcher perf (LRU + fuzzy matcher + rayon) behind feature flag.
7. Pattern detectors v1 (singleton/factory/observer) + fixtures.
8. Polishing: diagnostics, progress, help, docs.

---

## 10) Suggested dependencies (Cargo)

Add as needed (no versions pinned here):
- Core: `serde`, `serde_yaml`, `serde_json`, `thiserror`, `anyhow`
- FS/paths: `globset`, `camino`, `notify`
- Search: `regex`, `regex-automata`, `lru`, `fuzzy-matcher`, `rayon`, `ahash`
- Graph/algos: `petgraph`, `itertools`
- CLI/UX: `clap`, `indicatif`, `miette`
- Parsing: `tree-sitter` + lang crates (ts/js/py/rust/go/java/dart)

---

## 11) Minimal diffs you can paste

> These are illustrative; adjust to your codebase types and error enums.

**`src/config.rs` (env + validate hook):**
```diff
 pub fn load(root: &Path) -> Result<Self> {
-   let cfg = load_yaml_at(root.join("agentmap.yaml"))?;
-   Ok(cfg.merge_defaults(Self::default()))
+   let mut cfg = load_yaml_at(root.join("agentmap.yaml"))?;
+   cfg = cfg.merge_defaults(Self::default());
+   cfg.apply_env_overrides("AGENTMAP_")?;
+   cfg.validate()?;
+   Ok(cfg)
 }
```

**`src/query_pack.rs` (provider select):**
```diff
-pub struct QueryPack { /* hardcoded paths */ }
+pub enum QuerySource { Embedded, Fs(PathBuf) }
+pub struct QueryPack { provider: Arc<dyn QueryProvider>, cache: QueryCache }
```

**`src/wildcard_matcher.rs` (LRU):**
```diff
-let mut cache: HashMap<String, Regex> = HashMap::new();
+let mut cache: lru::LruCache<String, Regex> = lru::LruCache::new(cap);
```

**`src/architecture_exporter.rs` (cycles):**
```diff
-// TODO circular dependencies
+let cycles = find_cycles(&self.edges);
+report.add_cycles(cycles);
```

**`src/cli.rs` (real data path):**
```diff
-let headers = vec![]; // TODO
-let table = demo_table();
+let headers = load_anchor_headers_from_sidecars(&export_path)?;
+let table = symbol_table::build_from_anchor_headers(&headers)?;
```

---

## 12) Test plan (quick)

- Unit: config validation, env/profile overrides, glob compilation errors.
- Unit: query compilation fail surfaces file & line; cache invalidation.
- Unit: matcher LRU eviction; fuzzy scores monotonic on edits.
- Unit: exporter metrics math; SCCs on tiny graphs.
- CLI: snapshot help text; invalid arg combos; progress under slow mock.
- Golden: JSON/CSV/DOT outputs for a tiny sample repo (commit to repo).

---

## 13) Risks & mitigations

- **Config churn:** pin semantics; add `--print-config` for debugging.
- **Query fragility:** ship embedded defaults; allow override dir with version.
- **Perf regressions:** gate rayon/fuzzy under a config flag; add benches.
- **UX noise:** progress bars suppressed with `--quiet`; JSON errors for CI.

---

## 14) Done‑definition per component

- **Config:** schema+semantic validation; env/profile; globset; tests.
- **QueryPack:** provider+cache; adds 2 new langs; `--queries` works.
- **SymbolTable:** builds from headers; name lookup; edges usable by exporter.
- **Exporter:** JSON/CSV/DOT; cycles & metrics present; source snippets show.
- **CLI:** no demo data; progress & validations; helpful errors.
- **Matcher:** LRU + fuzzy + parallel (hidden behind config/feature).

---

This plan keeps diffs small, makes correctness visible (metrics & cycles),
and unblocks delivery paths (CLI/exporter) while leaving room for deeper
algorithms later.
