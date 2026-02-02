# Detached Anchor System & Semantic Enrichment (Overview)

**Status:** Proposed / In-Design  
**Date:** 2026-01-27

## Intent

The Detached Anchor System separates **deterministic structure** (the “skeleton”) from **semantic meaning** (the “spirit”). The goal is to keep navigation **fast and precise** without polluting source files, while enabling **semantic enrichment** that can evolve independently of the parser.

## Why This Exists

1. **Precision & Performance**: Inline anchors in v2 enabled instant lookup but polluted code and diffs.
2. **Developer Experience**: Embedded blobs/tags harm readability and version control hygiene.
3. **Semantics Gap**: Parsing provides syntax; we also want intent (security boundaries, data access, domain tags).

## What This Document Is

This file is an **overview**. Detailed design, schemas, testing, and plans live in the companion docs below.

## Related Docs

- `docs/features/anchors/DESIGN.md` — full architecture and workflows
- `docs/features/anchors/API.md` — anchor file schemas and internal interfaces
- `docs/features/anchors/VERSION_CONTROL.md` — versioning and git strategy
- `docs/features/anchors/IMPLEMENTATION_PLAN.md` — phased plan per improvement
- `docs/features/anchors/TESTING.md` — testing strategy
- `docs/features/anchors/CHANGELOG.md` — change log

## High-Level Architecture

**Skeleton (Deterministic):**
- Generated from TreeSitter.
- Tracks symbol identity, ranges, and structural metadata.
- Must be fast, stable, and reproducible.

**Spirit (Semantic):**
- Generated via AI hook + Rule Book.
- Tags and annotations about intent (auth, risk, public API, etc.).
- Async and non-blocking; stale semantics remain valid until refreshed.

## Storage Layout (Detached)

```
Project Root
|-- src/
|   |-- auth/
|   |   `-- login.rs
|   `-- main.rs
`-- .agentmap/
    |-- policy.md
    `-- anchors/
        |-- src/
        |   |-- auth/
        |   |   `-- login.rs.anchor.skeleton.json
        |   |   `-- login.rs.anchor.semantic.json
        |   `-- main.rs.anchor.skeleton.json
        `-- main.rs.anchor.semantic.json
```

## Component Roles (Summary)

| Component | Responsibility | Notes |
| :--- | :--- | :--- |
| Watcher | Detects file changes | `notify-rs` (debounced) |
| Delta Detector | Detects significant edits | content hash + AST edit ranges |
| Anchor Manager | Maps source paths to anchors | atomic IO, lifecycle management |
| Syncer (Skeleton) | Updates symbols/ranges | TreeSitter-based |
| Enricher (Spirit) | Applies semantics | AI hook + Rule Book |

## Scope Boundaries

**In scope:**
- Detached anchor storage and mapping
- Stable identifiers and range tracking
- Rule Book driven enrichment
- Async enrichment pipeline with safety guarantees

**Out of scope (for now):**
- Full cross-repo indexing
- IDE plug-in UI
- Policy authoring UI

## Open Questions

- Anchor format: internal JSON vs standardized schema (SCIP/LSIF hybrid).
- Git strategy: commit vs ignore anchors by default.
- Re-enrichment triggers: threshold and policy versioning rules.

See `IMPLEMENTATION_PLAN.md` for the proposed improvement roadmap.
