# Detached Anchor System - Implementation Plan

**Status:** Draft / Proposed  
**Date:** 2026-01-28

## Improvements (Scope List)

- **IMP-01 Schema versioning + file split** (skeleton vs semantic)
- **IMP-02 Stable symbol identifiers** (join key and drift handling)
- **IMP-03 Delta detection + incremental updates**
- **IMP-04 Rule Book parser + matcher**
- **IMP-05 Enrichment pipeline (queue, cancel, debounce)**
- **IMP-06 Semantic provenance + manual overrides**
- **IMP-07 Rename/move/delete lifecycle + GC**
- **IMP-08 Version control integration**
- **IMP-09 Migration from inline anchors**
- **IMP-10 Observability + diagnostics**

## Phased Plan (Each Phase Includes Verification)

1. **Phase 1 — Anchor Schema & Storage (IMP-01)**
   - Define schema versioning rules and compatibility policy.
   - Implement separate skeleton and semantic files.
   - Add atomic write + checksum validation.
   - **Build and check for errors** (e.g., `cargo check --target x86_64-unknown-linux-gnu`).

2. **Phase 2 — Stable IDs & Delta Detection (IMP-02, IMP-03)**
   - Implement stable symbol IDs per language.
   - Add delta detection based on content hash + AST edit ranges.
   - Update anchor mapping to handle line/byte drift.
   - **Build and check for errors**.

3. **Phase 3 — Rule Book & Enrichment Pipeline (IMP-04, IMP-05)**
   - Implement Rule Book parser + matcher.
   - Add async queue with debounce + cancellation.
   - Validate enrichment output against schema.
   - **Build and check for errors**.

4. **Phase 4 — Provenance & Overrides (IMP-06)**
   - Add provenance metadata (`rule_id`, `policy_version`, `model_id`).
   - Implement manual override layer and precedence rules.
   - Add confidence scoring and drift detection.
   - **Build and check for errors**.

5. **Phase 5 — Lifecycle & GC (IMP-07)**
   - Handle rename/move/delete events.
   - Ensure cascade cleanup of anchors and references.
   - Add garbage collection for orphaned anchors.
   - **Build and check for errors**.

6. **Phase 6 — Version Control & Tooling (IMP-08)**
   - Implement `.gitignore` updates in `agentmap init` (optional/flagged).
   - Add CLI commands for rebuild and purge.
   - Document git merge strategy and regeneration steps.
   - **Build and check for errors**.

7. **Phase 7 — Migration Path (IMP-09)**
   - Provide conversion from inline anchors to detached format.
   - Add fallback behavior when anchors are missing or invalid.
   - **Build and check for errors**.

8. **Phase 8 — Observability (IMP-10)**
   - Add structured logging and metrics for anchor updates.
   - Add diagnostics for stale semantic data.
   - **Build and check for errors**.

## Final Verification

- Run test suite for anchor pipeline + relationship analysis.
- Run code quality checklist (code-quality skill).

## Risks & Mitigations

- **Schema churn** ? use versioning + migration tooling.
- **Enrichment drift** ? store policy/model hashes and re-enrich on changes.
- **Merge conflicts** ? default ignore in git, rebuild post-merge.

## Open Decisions

- Choose standard schema (SCIP/LSIF) vs custom.
- Decide default version control behavior for anchors.
- Decide whether semantic overlays can be committed.
