# REF — Reference Cascade

Start with these, in order:

1) docs/OPTIMIZATION_QUICK_REFERENCE.md — Current status and commands
2) docs/OPTIMIZATION_TRACKING.md — Overview, metrics, history
3) docs/TECHNICAL_IMPLEMENTATION_LOG.md — Patterns, fixes, examples
4) docs/OPTIMIZATION_DECISIONS.json — Structured decisions and rationale

Key code locations:
- src/core/relationship_analyzer.rs — Inheritance & relationships
- src/parsers/treesitter_engine.rs — TreeSitter integration
- src/core/language.rs — Language abstractions
- src/core/symbol_types.rs — Symbol classification
- tests/relationship_analysis_test.rs — Core integration tests

Constraints:
- TreeSitter 0.22.6; target x86_64-unknown-linux-gnu
- Use anyhow::Result, Arc<DashMap>, async-first patterns

