# Detached Anchor System - DESIGN

**Status:** Draft / In-Design  
**Date:** 2026-01-28

## Goals

- Preserve **fast, deterministic navigation** without modifying source code.
- Separate **structure** (skeleton) from **semantics** (spirit).
- Keep enrichment **async, optional, and non-blocking**.
- Ensure anchors are **stable across edits**, **safe to update**, and **recoverable**.
- Enable **policy-driven semantics** with explicit provenance and confidence.

## Non-Goals (Current Phase)

- Full cross-repo indexing or remote indexing services
- IDE UI or UI authoring for Rule Book
- Real-time multi-user collaboration semantics

## Architecture Overview

### Layers

1. **Presentation**: CLI/UI consumers that read anchor data.
2. **Business Logic**: Anchor orchestration, enrichment pipeline, rule matching.
3. **Data**: Anchor file storage, schema versioning, cache lifecycle.

### Core Components

- **Watcher**: Detect file changes and send events (debounced).
- **Delta Detector**: Decides whether a file change is structural/semantic.
- **Anchor Manager**: Maps source paths to anchor files and handles atomic IO.
- **Syncer (Skeleton)**: Uses TreeSitter to update symbols/ranges deterministically.
- **Rule Book Parser**: Parses `.agentmap/policy.md` into matchable rules.
- **Enricher (Spirit)**: Async AI hook that emits semantic tags.
- **Merger**: Combines skeleton + semantic at read time or via overlay.

## Data Model (Conceptual)

### Anchor Identity

- **Primary identity** = stable symbol ID
  - Prefer fully-qualified symbol names + language-specific namespace.
  - Maintain fallbacks for anonymous/lambda symbols (hash of normalized signature).
- **Secondary identity** = byte range + content hash at time of indexing.

### Storage Separation

- **Skeleton file**: deterministic symbols/ranges.
- **Semantic file**: AI-generated tags, provenance, confidence, policy rule references.

## Workflows

### 1) File Change (Skeleton)

1. Watcher detects change.
2. Delta Detector decides if a structural reindex is required.
3. Syncer updates symbols/ranges.
4. Anchor Manager writes `.anchor.skeleton.json` atomically.

### 2) Enrichment (Spirit)

1. Rule Book matcher selects applicable rules.
2. Enrichment job enqueued (debounced + cancelable).
3. AI Hook processes file using matched rule set.
4. Semantic output validated + stored as `.anchor.semantic.json`.

### 3) Read Path

1. Consumer requests symbol data.
2. Merger reads skeleton + semantic (if present).
3. If semantic missing/stale, return skeleton and mark as “needs enrich”.

## Concurrency & Lifecycle

- **Debounce** file system events per path.
- **Cancel** in-flight enrichment when new edits arrive.
- **Idempotent cleanup**: anchor deletion safe on repeated calls.
- **Rename/Move detection**: update mapping and migrate anchor files.

## Performance Targets

- Skeleton update: < 50ms per file (local) in typical cases.
- Enrichment: async; should not block navigation operations.
- Anchor storage: constant-time file mapping; no global lock.

## Security & Privacy

- Keep Rule Book local by default.
- Do not upload source unless explicitly configured.
- Redact secrets in enrichment input if possible.

## Extensibility

- Pluggable policy parsers (YAML/Markdown).
- Multiple enrichment providers (local/remote, LLM, rules-only).

## Open Decisions

- Standard format adoption (SCIP/LSIF) vs custom schema.
- Default git behavior (commit vs ignore anchor files).
- Rule Book DSL format and parser strictness.

See `IMPLEMENTATION_PLAN.md` for phased improvements and validation steps.
