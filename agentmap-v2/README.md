# AgentMap v2

Multi-language code analysis for AI agents with RAG integration.

## Features

- **7 Languages** - Rust, Python, TypeScript, JavaScript, Go, Java, Dart
- **4 Relationship Types** - Inheritance, imports, calls, usage
- **Middleware System** - Extensible analysis pipeline
- **db-kit Integration** - Ready for RAG indexing
- **CLI** - Analyze, scan, export, stats commands

## Installation

```bash
cargo install agentmap
```

## Quick Start

```bash
# Analyze a directory
agentmap analyze ./src

# Quick symbol scan
agentmap scan ./src --kind function

# Export for RAG
agentmap export ./src -o graph.json --rag

# Show statistics
agentmap stats ./src
```

## Library Usage

```rust
use agentmap::{AgentMap, middleware::*};

// Create analyzer with middleware
let mut agent = AgentMap::new();
agent.add_middleware(LoggingMiddleware::new());
agent.add_middleware(MetricsMiddleware::new());

// Analyze a file
let analysis = agent.analyze_file("src/main.rs")?;

for symbol in &analysis.symbols {
    println!("{}: {} at line {}",
        symbol.kind,
        symbol.name,
        symbol.location.start_line);
}
```

## Middleware

Built-in middleware:
- `LoggingMiddleware` - Logs analysis events
- `CachingMiddleware` - Caches results by content hash
- `MetricsMiddleware` - Collects statistics
- `DbKitMiddleware` - Converts to db-kit format
- `SidecarMiddleware` - Writes YAML sidecar files

## Configuration

Create `.agentmap.yaml`:

```yaml
exclude:
  - "**/node_modules/**"
  - "**/target/**"

cache:
  enabled: true
  max_entries: 1000

middleware:
  logging: true
  metrics: true

output:
  format: json
  sidecar: false
```

## Relationship Types

| Type | Description |
|------|-------------|
| `INHERITS` | Class extends class |
| `IMPLEMENTS` | Class implements interface |
| `IMPORTS` | File imports module |
| `CALLS` | Function calls function |
| `USES` | Symbol references symbol |
| `REFERENCES` | Type reference |

## License

MIT
