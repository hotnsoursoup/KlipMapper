# agentmap (MVP)

Fast, language-agnostic code metadata sidecars for agentic coding.
- Inline Agent Card (first lines, optional) → points to sidecar.
- Sidecar `.agentmap/<relpath>.yaml` with regions, symbols, imports.
- Tree-sitter adapters for Dart(Flutter), Python, TS/JS.
- CLI + pre-commit hook. Exits 1 if it edits sidecars (autofix).

## Build
```bash
cargo build --release
```

## Run
```bash
./target/release/agentmap scan .
./target/release/agentmap check .
```

## Test queries
Use the samples in `examples/`:
```bash
./target/release/agentmap scan examples
```
