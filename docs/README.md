# Documentation Structure

## Folder Organization

| Folder | Purpose | Lifecycle | Timestamp? |
|--------|---------|-----------|------------|
| `architecture/` | System design, ADRs, integration specs | Permanent until superseded | No |
| `design/` | Feature specs, design docs | Living until implemented | Optional |
| `evaluations/` | Spike results, tech comparisons, options analysis | Read-only after creation | **Required** |
| `issues/` | Active problem investigations, debugging notes | Delete when resolved | **Required** |
| `planning/` | Backlogs, roadmaps, task tracking | Continuously updated | No |
| `guides/` | How-to docs, dev setup, testing standards | Updated as process changes | No |
| `status/` | Progress reports, milestone snapshots | Read-only snapshots | **Required** |

## Document Types

### Permanent Documents (No timestamp)
- **ADRs**: `architecture/ADR-NNNN-short-title.md`
- **System Design**: `architecture/SYSTEM_DESIGN.md`
- **Feature Specs**: `design/FEATURE_NAME.md`
- **Guides**: `guides/TOPIC.md`
- **Backlogs**: `planning/BACKLOG.md`

### Transient Documents (Timestamp required: YYYYMMDD)
- **Evaluations**: `evaluations/TOPIC_YYYYMMDD.md`
- **Issues**: `issues/ISSUE_NAME_YYYYMMDD.md`
- **Status Reports**: `status/MILESTONE_YYYYMMDD.md`

## Naming Conventions

- **UPPERCASE** for documentation files: `FEATURE_NAME.md`, `ADR-0001.md`
- **Date format**: `YYYYMMDD` or `YYYYMMDD_HHMM` for precision
- **ADR format**: `ADR-NNNN-short-kebab-title.md`

## When to Create What

| Situation | Document Type | Location |
|-----------|--------------|----------|
| Major architectural decision | ADR | `architecture/` |
| New feature design | Feature spec | `design/` |
| Comparing tech options | Evaluation | `evaluations/` |
| Debugging a problem | Issue doc | `issues/` |
| Recording milestone | Status report | `status/` |
| Process documentation | Guide | `guides/` |
| Task tracking | Backlog item | `planning/` |
