# Symbol Resolution Design

> **Purpose**: Enhance v2's linking system with cross-file resolution, scope tracking, and import handling.

## Current State (v2)

**What exists:**
- `SymbolTable` - lookup by FQN, name, file (solid)
- `ResolutionContext` - has `imports` and `scope_stack` fields (empty, not populated)
- `ResolutionChain` - strategy pattern with 5 strategies (good architecture)
- `ResolutionStrategy` trait - extensible design

**What's missing:**
- Nothing populates `ResolutionContext.imports`
- Nothing populates `ResolutionContext.scope_stack`
- No `FrameKind` enum for scope types
- No language-specific frame mappings
- Single-pass analysis (no declaration pass first)

---

## Phase 1: Enhanced Scope Tracking

### Goal
Port v1's `ScopeTracker` to work with v2's middleware pattern.

### New Types

```rust
// src/extensions/linking/scope.rs

/// Type of scope frame
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub enum FrameKind {
    File,
    Module,
    Namespace,
    Class,
    Interface,
    Trait,
    Struct,
    Enum,
    Function,
    Method,
    Block,
    Lambda,
}

/// A single scope frame
#[derive(Debug, Clone)]
pub struct ScopeFrame {
    pub kind: FrameKind,
    pub name: Option<String>,
    pub start_line: u32,
    pub end_line: u32,
}

/// Tracks nested scopes during AST traversal
pub struct ScopeTracker {
    stack: Vec<ScopeFrame>,
    language_mappings: HashMap<&'static str, FrameKind>,
}
```

### Language Mappings (from v1)

| Language | Node Type | FrameKind |
|----------|-----------|-----------|
| Rust | `struct_item` | Struct |
| Rust | `impl_item` | Class |
| Rust | `function_item` | Function |
| TypeScript | `class_declaration` | Class |
| TypeScript | `function_declaration` | Function |
| TypeScript | `arrow_function` | Lambda |
| Python | `class_definition` | Class |
| Python | `function_definition` | Function |
| ... | ... | ... |

### Integration Point

The `ScopeTracker` should be used by analyzers during AST traversal. Each analyzer (inheritance, imports, calls) can use it to:
1. Know the current scope context
2. Build qualified names
3. Find enclosing class/function

### Tasks

- [x] Create `src/extensions/linking/scope.rs`
- [x] Define `FrameKind` enum
- [x] Define `ScopeFrame` struct
- [x] Define `ScopeTracker` with enter/exit methods
- [x] Add language mappings for 7 supported languages
- [x] Add tests for scope tracking

---

## Phase 2: Import Extraction

### Goal
Extract imports during parsing and populate `ResolutionContext.imports`.

### Import Types by Language

| Language | Import Syntax | Alias Syntax |
|----------|---------------|--------------|
| Rust | `use foo::Bar;` | `use foo::Bar as Baz;` |
| TypeScript | `import { Foo } from './mod'` | `import { Foo as Bar }` |
| Python | `from mod import Foo` | `from mod import Foo as Bar` |
| Go | `import "pkg"` | `import alias "pkg"` |
| Java | `import pkg.Class;` | N/A (no aliases) |
| Dart | `import 'pkg.dart'` | `import 'pkg.dart' as p` |

### New Analyzer

```rust
// src/analyzer/imports.rs (enhance existing)

/// Extracted import information
#[derive(Debug, Clone)]
pub struct ImportInfo {
    /// The module/file being imported
    pub source: String,

    /// What's being imported (None = entire module)
    pub imported_name: Option<String>,

    /// Local alias (None = use original name)
    pub alias: Option<String>,

    /// Line number
    pub line: u32,
}

impl ImportsAnalyzer {
    /// Extract imports and return as HashMap<alias, fully_qualified>
    pub fn extract_import_map(&self, ...) -> HashMap<String, String> {
        // For each import:
        // - If alias exists: alias -> fully_qualified
        // - Else: imported_name -> fully_qualified
    }
}
```

### Integration Point

After parsing, before analysis:
1. Run `ImportsAnalyzer.extract_import_map()`
2. Populate `ResolutionContext.imports` with result
3. Pass populated context to resolution strategies

### Tasks

- [x] Enhance `ImportInfo` struct with alias field (now `ImportedName` with per-name aliases)
- [x] Add `extract_import_map()` to ImportAnalyzer
- [x] Add language-specific import queries (Rust, Python, TS/JS with alias extraction)
- [x] Populate ResolutionContext.imports before resolution (via `LinkerMiddleware.build_context`)
- [x] Add tests for each language's import syntax

---

## Phase 3: Multi-Pass Analysis

### Goal
Implement declaration-first analysis so references can resolve to declarations.

### Current Flow (v2)
```
Parse → Single Pass Analysis → Done
```

### New Flow
```
Parse → Pass 1: Declarations → Build SymbolTable → Pass 2: References → Resolve
```

### Implementation

```rust
// In DefaultAnalyzer or new TwoPassAnalyzer

pub async fn analyze_with_resolution(&self, parsed: &ParsedFile) -> Result<CodeAnalysis> {
    // Pass 1: Collect declarations only
    let declarations = self.collect_declarations(parsed)?;

    // Build symbol table from declarations
    let symbol_table = SymbolTable::from_symbols(&declarations);

    // Extract imports for resolution context
    let imports = self.extract_imports(parsed)?;

    // Build resolution context
    let ctx = ResolutionContext {
        file: parsed.path.clone(),
        imports,
        scope_stack: vec![],
        language: parsed.language,
    };

    // Pass 2: Resolve references
    let relationships = self.resolve_references(parsed, &symbol_table, &ctx)?;

    Ok(CodeAnalysis {
        symbols: declarations,
        relationships,
        ..
    })
}
```

### Project-Wide Resolution

For cross-file resolution, need project-level coordination:

```rust
pub struct ProjectAnalyzer {
    file_analyses: HashMap<PathBuf, CodeAnalysis>,
    global_table: SymbolTable,
}

impl ProjectAnalyzer {
    /// Analyze all files and resolve cross-file references
    pub async fn analyze_project(&mut self, files: &[PathBuf]) -> Result<()> {
        // Pass 1: Analyze all files, collect symbols
        for file in files {
            let analysis = self.analyze_file(file).await?;
            self.global_table.add_analysis(&analysis);
            self.file_analyses.insert(file.clone(), analysis);
        }

        // Pass 2: Resolve cross-file references
        for (path, analysis) in &mut self.file_analyses {
            self.resolve_cross_file_refs(analysis, &self.global_table)?;
        }

        Ok(())
    }
}
```

### Tasks

- [x] Add `collect_declarations()` method to analyzer (via DefaultAnalyzer)
- [x] Add `resolve_references()` method with table + context (via ProjectAnalyzer.resolve_all)
- [x] Create `ProjectAnalyzer` for multi-file coordination
- [x] Update middleware to support two-pass mode (via project.add_file/resolve_all pattern)
- [x] Add tests for cross-file resolution

---

## Phase 4: Language-Specific Resolution Rules

### Goal
Handle language quirks in resolution.

### Language Quirks

| Language | Quirk | Handling |
|----------|-------|----------|
| TypeScript | Re-exports (`export { Foo } from './mod'`) | Follow re-export chain |
| TypeScript | Default exports | Map `default` to actual name |
| Python | Relative imports (`from . import foo`) | Resolve relative to file |
| Python | `__init__.py` | Package namespace |
| Rust | `pub use` re-exports | Follow pub use chain |
| Go | Package = directory | Resolve by package path |
| Java | Fully qualified names in code | Direct lookup |

### Strategy Enhancement

```rust
// New strategy for re-exports
pub struct ReExportStrategy;

impl ResolutionStrategy for ReExportStrategy {
    fn try_resolve(&self, name: &str, ctx: &ResolutionContext, table: &SymbolTable)
        -> Option<ResolvedReference>
    {
        // Check if any import is a re-export
        // Follow the chain until we find the original
    }
}

// New strategy for relative imports (Python)
pub struct RelativeImportStrategy;

impl ResolutionStrategy for RelativeImportStrategy {
    fn try_resolve(&self, name: &str, ctx: &ResolutionContext, table: &SymbolTable)
        -> Option<ResolvedReference>
    {
        // Only for Python
        if ctx.language != Language::Python {
            return None;
        }

        // Handle `.foo`, `..foo` relative imports
    }
}
```

### Tasks

- [x] Document all language quirks (in strategy implementations)
- [x] Add `ReExportStrategy` for TS/JS/Rust
- [x] Add `RelativeImportStrategy` for Python
- [x] Add `GoPackageStrategy` for Go
- [x] Add `DefaultExportStrategy` for TS/JS
- [x] Add `JavaFqnStrategy` for Java FQN handling
- [x] Add tests for each language quirk (language guard tests)

---

## Implementation Order

1. **Phase 1** (Foundation): ScopeTracker
   - Enables everything else
   - Relatively isolated change

2. **Phase 2** (Data): Import Extraction
   - Populates the context
   - Unlocks existing ImportAliasStrategy

3. **Phase 3** (Architecture): Multi-Pass
   - Biggest change
   - Enables cross-file resolution

4. **Phase 4** (Polish): Language Quirks
   - Can be done incrementally per language
   - Improves accuracy

---

## Testing Strategy

### Unit Tests
- ScopeTracker: enter/exit scope, frame queries
- Import extraction: per-language import parsing
- Resolution strategies: each strategy in isolation

### Integration Tests
- Full file analysis with scope tracking
- Cross-file resolution in test project
- Language-specific quirk handling

### Test Fixtures
```
tests/fixtures/
├── rust/
│   ├── simple_imports.rs
│   └── pub_use_reexport.rs
├── typescript/
│   ├── named_imports.ts
│   ├── default_export.ts
│   └── reexports.ts
├── python/
│   ├── relative_imports/
│   └── package_imports/
└── ...
```
