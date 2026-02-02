# Detached Anchor System - API & Schema

**Status:** Draft / Proposed  
**Date:** 2026-01-28

## Purpose

Define the anchor file schemas and internal interfaces for detached anchor storage and enrichment.

## File Types

- `*.anchor.skeleton.json` — deterministic symbols, ranges, hashes
- `*.anchor.semantic.json` — AI tags, provenance, confidence, policy rule references

## Skeleton Schema (Draft)

```json
{
  "schema_version": "1.0.0",
  "generator": {
    "name": "agentmap",
    "version": "0.0.0",
    "build": "<git-sha>",
    "indexed_at": "2026-01-28T00:00:00Z"
  },
  "source": {
    "path": "src/auth/login.rs",
    "language": "rust",
    "content_hash": "sha256:<hex>",
    "line_ending": "LF"
  },
  "symbols": [
    {
      "id": "<stable-id>",
      "name": "login",
      "kind": "function",
      "range": { "start": { "line": 10, "col": 0 }, "end": { "line": 30, "col": 1 } },
      "signature": "fn login(req: Request) -> Result<Response>"
    }
  ],
  "relationships": [],
  "diagnostics": []
}
```

## Semantic Schema (Draft)

```json
{
  "schema_version": "1.0.0",
  "generator": {
    "name": "agentmap",
    "version": "0.0.0",
    "model": "<model-id>",
    "policy_version": "sha256:<hex>",
    "enriched_at": "2026-01-28T00:00:00Z"
  },
  "source": {
    "path": "src/auth/login.rs",
    "content_hash": "sha256:<hex>"
  },
  "tags": [
    {
      "symbol_id": "<stable-id>",
      "labels": ["auth", "risk"],
      "confidence": 0.82,
      "provenance": {
        "rule_id": "backend-api",
        "rule_version": "1.0"
      }
    }
  ],
  "alerts": []
}
```

## Schema Rules

- **`schema_version` is required** and must be incremented for any breaking change.
- **`content_hash`** is required for drift detection.
- **`symbol_id`** is the join key between skeleton and semantic files.
- **Backward compatibility**: readers must accept minor version bumps when fields are additive.

## Internal Interfaces (Draft)

### Anchor Manager

- `map_source_to_anchor_paths(source_path) -> { skeleton_path, semantic_path }`
- `read_skeleton(path) -> SkeletonAnchor`
- `write_skeleton(path, data) -> Result<()>`
- `read_semantic(path) -> SemanticAnchor`
- `write_semantic(path, data) -> Result<()>`

### Rule Book Parser

- `parse_policy(path) -> RuleSet`
- `match_rules(rule_set, source_path) -> Vec<Rule>`

### Enrichment Pipeline

- `enqueue_enrichment(source_path, rule_ids) -> JobId`
- `cancel_enrichment(source_path)`
- `apply_semantics(source_path, semantic_data)`

## Validation Requirements

- Reject semantic output if `source.content_hash` mismatches latest skeleton.
- Reject anchors missing `schema_version`, `content_hash`, or `symbols[].id`.

## Open Decisions

- Adopt standard index format (SCIP/LSIF) or custom JSON schema.
- Normalize ranges to byte offsets vs line/column.
- Whether to store full AST snapshots or only symbol lists.
