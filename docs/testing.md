Testing strategy

- Goal: exercise scanners and checkers across many small, syntactically valid files for each supported language, then validate sidecars are up-to-date.

- Generator: `gen-fixtures` binary creates batches of files under `examples/generated/<lang>/`.
  - Build: `cargo run --bin gen-fixtures -- --per-lang 200 --seed 42`
  - Options: `--out <dir>`, `--per-lang <n>`, `--seed <u64>`.

- Stress test: unit test `scan_then_check_on_generated_repo` generates a temporary multi-language repo, runs `scan_paths` to write sidecars, then `check_paths` to verify no issues.

- Notes:
  - Region anchors use line comments like `// <r:name>` or `# <r:name>` to remain valid for all languages.
  - Unsupported files are treated as valid/skipped by the checker.
  - Tests avoid external crates to keep builds self-contained.

