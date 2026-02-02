# Detached Anchor System - Testing

**Status:** Draft  
**Date:** 2026-01-28

## Goals

- Verify deterministic skeleton updates across edits.
- Validate semantic enrichment correctness and drift handling.
- Ensure lifecycle operations (rename/move/delete) are safe and idempotent.

## Test Types

### Unit Tests

- Anchor path mapping
- Schema validation and version handling
- Stable symbol ID generation
- Delta detection decisions

### Integration Tests

- Watcher ? Anchor Manager update flow
- Enrichment pipeline (mocked AI hook)
- Merge skeleton + semantic and read path

### Regression / Golden Tests

- Known code fixtures with expected skeleton output
- Policy rule matching results

### Concurrency / Lifecycle

- Debounce/cancel behavior under rapid edits
- Rename/move/delete handling and GC
- Idempotent cleanup on repeated calls

## Tooling

- Mock AI hook for deterministic tests
- Fixtures per language (Rust/TS/JS/Python/etc.)

## Required Commands

- `cargo test --test relationship_analysis_test --target x86_64-unknown-linux-gnu`
- `cargo test --target x86_64-unknown-linux-gnu`

## Open Questions

- Should semantic regression tests store model outputs or expected labels only?
- How to handle non-determinism from AI providers in CI?
