
# AgentMap vNext — Identity, Resolution & Graph (Integrated Spec)

Status: ready to implement in small PRs
Scope: folds in identity semantics, incremental SCC scheduling, multi-edge
graph, URI encoding, and ranking updates.

---

## 0) Overview (What changed vs previous docs)
- **File identity split**: `FileId` (stable) vs `FileSnapshot` (mutable).
- **Canonical IDs**: optional `sig=` hash for overloads/impls; proper URI
  encoding; separate `SymbolId` and `BindingId` (exports).
- **Module path rules**: TS defaults/re-exports, JS namespace exports,
  Python PEP420, Go named-type methods, Rust trait vs impl.
- **Incremental scheduling**: dynamic dep tracking + on-demand SCC batching.
- **Graph**: multi-edge per `(from,to,kind)` keyed by `origin: FileId` +
  `by_origin` index; reverse map uses `(to, kind)`; RCU-like visibility via
  a `gen` counter.
- **Ranking**: adds frequency/doc/edit signals; per-feature contributions.

---

## 1) Identity

### 1.1 File identity & snapshot

```rust
/// Platform-neutral, stable across edits; aims to survive renames on
/// case-sensitive filesystems (nfc_abs changes, but dev/inode stays).
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub struct FileId {
  /// Absolute path, Unicode NFC, '/' separators, case preserved.
  pub nfc_abs: String,
  /// Unicode full casefold of the absolute path (for matching).
  pub casefold_abs: String,
  /// Device+inode or OS equivalent. Windows: 128-bit file index.
  pub dev_inode: Option<(u64, u128)>,
  /// Whether underlying FS is case-insensitive (diagnostics only).
  pub fs_case_insensitive: bool,
}

/// Mutable snapshot used for cache invalidation & change detection.
#[derive(Debug, Clone)]
pub struct FileSnapshot {
  pub file_id: FileId,
  pub sha256_hex: String,
  pub size: u64,
  pub mtime_unix_secs: u64,
}
```

**Keys in registries/edges use `FileId`**, not `FileSnapshot`. Maintain
bidirectional maps:
- `AbsPath → FileId` (NFC + casefold logic)
- `FileId → AbsPath` (OS-accurate for IO)

**Moves/renames:** Canonical IDs embed `abs_path` → **IDs change**. We
treat it as new content; remove old edges by origin and rebuild. Optional
fast-path: "relocation" if `sha256` unchanged; still produces new IDs.

### 1.2 Canonical IDs

#### 1.2.1 SymbolId (declaration identity)

External string form (URI-like; reserved chars percent-encoded per RFC 3986):

```
urn:agentmap:symbol:<lang>:<abs_path>#<qualified_scope>::<name>(<kind>)[sig=<h>]
```

- `lang`: `dart|ts|js|py|rust|go|java`
- `abs_path`: NFC normalized absolute path (percent-encoded)
- `qualified_scope`: module path + nested containers (`::` separators)
- `name`: identifier (percent-encoded)
- `kind`: from canonical set (see §1.4)
- `[sig=<h>]`: optional short stable hash for overload/impl disambiguation

> The legacy form `<lang>://<abs_path>#...` remains accepted but `urn:` is
> the normative form to avoid host ambiguity.

#### 1.2.2 BindingId (exported binding identity)

```
urn:agentmap:binding:<lang>:<abs_path>#<module_path>::<export_name>
```

- Identifies a **binding in module scope** (e.g., `export {foo as bar}`).
- Resolves to a `SymbolId` (possibly via re-export chain).

Maintain tables:
- `ModuleExports: BindingId → SymbolId`
- `ModuleReexports: BindingId → BindingId` (chained resolution allowed)

### 1.3 Qualified scope (precise)

```
qualified_scope := module_path [ "::" container ]*
container       := namespace | class | trait | interface | struct | enum | fn
```

**Module path rules by language**
- **Rust**: `<crate>` from `Cargo.toml [package].name`; then module tree
  (`mod` paths). `src/svc/repo.rs` → `mycrate::svc::repo`.
- **TS/JS**: computed via Node/TS resolution (respect `tsconfig.baseUrl`,
  `paths`, `package.json#exports` conditions). The logical module path from
  project root without extension, `app/view` → `app::view`.
- **Python**: supports **PEP 420** namespace packages (no `__init__.py`).
  Module path derived from configured workspace roots and package dirs,
  joined by dots → `pkg::mod::sub`.
- **Go**: `<module>` from `go.mod` + package dir segments → `m::p::q`.
  Methods on named types use the package scope.
- **Java**: `package` statement → `com::acme::util`.
- **Dart**: `pubspec.yaml name` + path under `lib/`, or explicit `library`.

### 1.4 Canonical kinds (stable values)

| kind         | applies to                         | notes                        |
|--------------|------------------------------------|------------------------------|
| `module`     | module/library/package             | TS/JS module, Python module  |
| `namespace`  | TS namespace                        | decl merging allowed         |
| `class`      | class/type                          |                              |
| `interface`  | interface                           |                              |
| `trait`      | Rust trait                          |                              |
| `struct`     | Rust/Go struct                      |                              |
| `enum`       | enum                                |                              |
| `type`       | alias/typedef                       | TS `type`, Rust `type`       |
| `function`   | top-level function                  |                              |
| `method`     | method (instance or static)         |                              |
| `constructor`| ctor/initializer                    |                              |
| `property`   | property/getter/setter (collapsed)  | keep accessor metadata       |
| `field`      | struct/record/class field           |                              |
| `variable`   | local/global variable               |                              |
| `constant`   | const/final                         |                              |
| `mixin`      | Dart mixin                          |                              |
| `extension`  | Dart extension                      |                              |

### 1.5 Signature hash (`sig`)

Purpose: disambiguate overloads/impls while keeping IDs readable.

- **Method/function key**: `(receiver_type?, name, arity, param_types[], ret?)`
- **Param type normalization**: erase generics where the language erases at
  runtime; canonicalize primitives/aliases; fully qualify type names.
- **Rust impl**: include `trait` (if any) and `impl_for` type in the tuple.
- **TS/Java overloads**: include parameter types; for TS, use declared types
  (not inference).

Hashing:
- Serialize tuple as UTF-8 with separators; `blake3` → hex; take 10 chars.
- Omit `[sig=...]` when the symbol is unique by `(scope,name,kind)`.

---

## 2) Imports, Exports & Language Edge Cases

### 2.1 TS/JS specifics
- **Default export**: create a `BindingId` with `export_name="default"`.
- **`export * as ns from '...'`**: create `BindingId` `ns` pointing to a **proxy
  namespace** that maps members; resolve via member access.
- **Declaration merging / module augmentation**: represent as a **single
  `SymbolId`** with multiple source ranges; union members on merge.

### 2.2 Python specifics
- **PEP 420**: allow namespace pkgs across multiple roots; module path may
  resolve to several physical directories; exports are unioned.
- **`sys.path` / venv**: workspace config sets roots; resolution stays
  deterministic within the workspace.

### 2.3 Go specifics
- **Methods on named non-struct types**: add container kind `named_type`
  (internally) but emit as `method` under package scope; receiver is the
  named type.

### 2.4 Rust specifics
- Distinguish **trait method declarations** vs **impl methods**.
- For impls, record `impl_for` in `sig` tuple and set relationship
  `Implements` to the trait (if present).

---

## 3) Two-Pass Pipeline with Incremental SCC

### 3.1 Data flow
- **Index (per file)**: parse → symbols/imports/exports/scopes → `FileEnv`
  → publish deps `file_deps[file_id] = { imported_file_ids }`.
- **Resolve**: as soon as a file’s **direct imports** are indexed, schedule
  it (or its SCC batch) for resolve.

### 3.2 Dynamic scheduling

```rust
// pseudo-code
struct Scheduler {
  pending_deps: HashMap<FileId, usize>,
  dependents: HashMap<FileId, HashSet<FileId>>,
  indexed: HashSet<FileId>,
  q: tokio::sync::mpsc::Sender<FileId>, // candidates
  limit: tokio::sync::Semaphore,        // backpressure
}

fn on_index_done(file: FileId, imports: HashSet<FileId>) {
  indexed.insert(file.clone());
  for dep in &imports { dependents.entry(dep.clone()).or_default().insert(file.clone()); }
  pending_deps.entry(file.clone()).or_insert(imports.len());
  for d in dependents.get(&file).cloned().unwrap_or_default() {
    let e = pending_deps.get_mut(&d).unwrap();
    *e -= 1;
    if *e == 0 { q.send(d).await; } // candidate-ready
  }
}

async fn resolve_worker() {
  while let Some(f) = q.recv().await {
    let _permit = limit.acquire().await.unwrap();
    // Compute SCC only over the subgraph of INDEXED files reachable from f.
    let batch = scc_from_seed(f, &indexed, &file_deps);
    resolve_batch(batch).await;
  }
}
```

- **Backpressure**: bound concurrent resolves via `Semaphore`.
- **Cycles**: when a candidate lies in a non-trivial SCC, schedule the whole
  SCC (all indexed) together.

---

## 4) Relationship Graph (multi-edge, removal-safe, snapshots)

### 4.1 Data structures

```rust
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub struct EdgeKey {
  pub from: String,                  // SymbolId
  pub to: String,                    // SymbolId or BindingId target
  pub kind: RelationshipType,        // Import, Calls, Implements, ...
}

#[derive(Debug, Clone)]
pub struct EdgeValue {
  pub location: SourceLocation,      // includes origin path, byte range
  pub meta: std::collections::HashMap<String, String>,
  pub origin: FileId,                // file that created this edge
  pub gen: u64,                      // update generation
}

#[derive(Debug, Default)]
pub struct RelationshipGraph {
  pub edges: std::collections::HashMap<
      EdgeKey, std::collections::HashMap<FileId, EdgeValue>>,
  pub by_origin: std::collections::HashMap<FileId,
      std::collections::HashSet<EdgeKey>>,
  pub reverse: std::collections::HashMap<
      (String /*to*/, RelationshipType),
      std::collections::HashSet<String /*from*/>>,
  pub committed_gen: std::sync::atomic::AtomicU64,
}
```

### 4.2 Ops

```rust
impl RelationshipGraph {
  pub fn add(&mut self, key: EdgeKey, val: EdgeValue) {
    let entry = self.edges.entry(key.clone()).or_default();
    // prefer newer gen for the same origin
    match entry.get(&val.origin) {
      Some(old) if old.gen > val.gen => { /* keep old */ }
      _ => { entry.insert(val.origin.clone(), val.clone()); }
    }
    self.by_origin.entry(val.origin.clone())
      .or_default().insert(key.clone());
    self.reverse.entry((key.to.clone(), key.kind.clone()))
      .or_default().insert(key.from.clone());
  }

  pub fn remove_by_origin(&mut self, origin: &FileId) {
    if let Some(keys) = self.by_origin.remove(origin) {
      for k in keys {
        if let Some(map) = self.edges.get_mut(&k) {
          map.remove(origin);
          if map.is_empty() { self.edges.remove(&k); }
        }
        if let Some(rs) = self.reverse.get_mut(&(k.to.clone(), k.kind.clone())) {
          rs.remove(&k.from);
          if rs.is_empty() { self.reverse.remove(&(k.to, k.kind)); }
        }
      }
    }
  }

  /// Read visibility fence: readers only consider edges with gen <= committed.
  pub fn committed(&self) -> u64 {
    self.committed_gen.load(std::sync::atomic::Ordering::Acquire)
  }

  pub fn commit(&self, gen: u64) {
    self.committed_gen.store(gen, std::sync::atomic::Ordering::Release);
  }
}
```

**RCU-style reads:** Query paths take a snapshot `g = graph.committed()` and
filter edge values `val.gen <= g`. Updates insert edges with their `gen`,
perform removals, then `commit(gen)` once a batch is complete.

---

## 5) Ranking (top‑k; explainable)

Score (0..1):
```
w_name*name_sim + w_scope*same_scope + w_pkg*same_module +
w_lang*same_language + w_path*same_dir + w_kind*kind_compat +
w_usage*usage_hint + w_export*is_exported +
w_type*type_compat + w_freq*popularity + w_doc*doc_overlap +
w_edit*edit_bonus + w_dist*import_distance
```

New signals:
- `w_freq` popularity prior (`log1p(usage)/log1p(max)`).
- `w_doc` doc/context token overlap (tf-idf on short window).
- `w_edit` single-token edit distance bonus (prefix/abbrev).
- `w_dist` negative weight for distant modules in import graph.

Per-language defaults (suggested starting points):

| signal        | TS/Java | Python | Rust |
|---------------|---------|--------|------|
| `w_kind`      | 0.15    | 0.08   | 0.12 |
| `w_usage`     | 0.10    | 0.05   | 0.08 |
| `w_type`      | 0.12    | 0.04   | 0.10 |
| `w_freq`      | 0.05    | 0.05   | 0.05 |
| `w_doc`       | 0.04    | 0.06   | 0.03 |
| `w_edit`      | 0.03    | 0.03   | 0.03 |
| `w_dist`      | -0.03   | -0.02  | -0.02 |

**Explainability:** return a contribution map per candidate:
`{ "name_sim": 0.42, "kind_compat": 0.15, ... }` plus an English summary.

---

## 6) URI & escaping spec

- Apply percent-encoding per RFC 3986 for components (path, scope parts,
  names). Separator tokens `::`, `#`, `?`, `(`, `)`, `<`, `>`, `,`, space
  **must** be encoded if appearing inside names.
- Generics: keep original surface text and encode (`Foo<T>` → `Foo%3CT%3E`).
- Operators (e.g., `operator+`): encode `+` as `%2B` in names.
- Provide parser/formatter round-trip tests.

**Optional VCS locator:** alongside URN, allow a `git:` locator for portability:
`git:<commit>/<repo_rel_path>#...` (not part of canonical ID; auxiliary).

---

## 7) Usage analysis & bindings

- Resolve **usage sites** primarily to **BindingId** in the current module;
  then follow binding → symbol (with re-export chains) to create edges.
- Keeps name-based reasoning honest; allows diagnostics like
  “`bar` is re-export of `foo` from `./x`”.

---

## 8) Minimal schema (illustrative)

```rust
pub struct SymbolId { pub lang: String, pub module_path: String,
  pub scope_chain: Vec<String>, pub name: String, pub kind: String,
  pub sig: Option<String> }

pub struct BindingId { pub lang: String, pub module_path: String,
  pub export_name: String }

pub enum RelationshipType { Import, Export, Inherits, Implements,
  Extends, Uses, Calls, References, Composition, Aggregation, Association,
  Dependency }
```

---

## 9) Tests you want

- **Path round-trip** incl. mixed Unicode; macOS/Windows/Linux.
- **Case collision** `Foo.ts`/`foo.ts` on case-insensitive FS → distinct `FileId`.
- **TS default export + re-export**: BindingId → SymbolId chain.
- **Java overloads**: `sig` inclusion and disambiguation.
- **Python PEP420** across two dirs; stable module path.
- **Incremental edit**: inode stable; only edges from origin replaced.
- **Cycle readiness**: `A↔B` resolves immediately after both indexed.
- **RCU visibility**: readers never see half-applied removals.

---

## 10) Worked examples

**TS default export & namespace export**
```
/app/view.ts
export default class App {}
export * as ui from './ui';

// IDs
BindingId: urn:agentmap:binding:ts:/abs/app/view.ts#app::view::default
SymbolId:  urn:agentmap:symbol:ts:/abs/app/view.ts#app::view::App(class)
```

**Java overloads**
```
package com.acme;
class A { void f(int x) {}; void f(String s) {}; }

// Possible IDs
urn:agentmap:symbol:java:/abs/A.java#com::acme::A::f(method)[sig=4a19d7a2f0]
urn:agentmap:symbol:java:/abs/A.java#com::acme::A::f(method)[sig=9c01b3c4ab]
```

**Rust trait vs impl**
```
trait Svc { fn run(&self); }
struct Repo;
impl Svc for Repo { fn run(&self) {} }

// method decl (trait item) vs impl method
sig decl:  (trait=Svc, recv=&Self, name=run, arity=0)
sig impl : (impl_for=Repo, trait=Svc, recv=&Repo, name=run, arity=0)
```

---

## 11) Action items (PR-sized)

1. Introduce `FileId` / `FileSnapshot`; refactor registries to key by `FileId`.
2. Implement URI encode/decode + round-trip tests.
3. Add `sig` hashing util + per-language normalizers.
4. Introduce `BindingId` and export/re-export tables.
5. Replace graph with multi-edge + `by_origin`; add `committed_gen` fence.
6. Implement dynamic scheduler (pending deps, candidate queue, SCC-from-seed).
7. Add ranking extras (freq/doc/edit) and per-feature contributions.
8. Extend language resolvers per §2 (TS/JS defaults, PEP420, named-type recv).

---

## 12) Notes & formalities

- Windows file identity: use BY_HANDLE_FILE_INFORMATION’s FileIndex (128-bit).
- Keep NFC; record FS case behavior for diagnostics.
- Intern symbol IDs to numeric handles for memory efficiency in big repos.

---
