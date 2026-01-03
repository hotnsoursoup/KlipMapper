//! Integration tests for AgentMap v2.
//!
//! These tests verify end-to-end functionality by analyzing real codebases.

use agentmap::{AgentMap, Language, CodeAnalysis};
use std::path::Path;

/// Test analyzing a single Rust file.
#[test]
fn test_analyze_single_rust_file() {
    let agent = AgentMap::new();
    let result = agent.analyze_file("src/lib.rs");

    assert!(result.is_ok(), "Failed to analyze lib.rs: {:?}", result.err());

    let analysis = result.unwrap();

    // Should find AgentMap struct
    let has_agentmap = analysis.symbols.iter()
        .any(|s| s.name == "AgentMap");
    assert!(has_agentmap, "Should find AgentMap struct");

    // Should have relationships
    assert!(!analysis.relationships.is_empty(), "Should have relationships");
}

/// Test analyzing a directory.
#[test]
fn test_analyze_directory() {
    let agent = AgentMap::new();
    let result = agent.analyze_directory("src/core");

    assert!(result.is_ok(), "Failed to analyze core directory: {:?}", result.err());

    let analyses = result.unwrap();

    // Should analyze multiple files
    assert!(analyses.len() >= 5, "Should analyze at least 5 core files, got {}", analyses.len());

    // Total symbols should be significant
    let total_symbols: usize = analyses.iter().map(|a| a.symbols.len()).sum();
    assert!(total_symbols >= 10, "Should find at least 10 symbols, got {}", total_symbols);
}

/// Test that all supported languages parse without error.
#[test]
fn test_all_languages_parse() {
    use agentmap::parser::{TreeSitterParser, Parser};

    let parser = TreeSitterParser::new();

    // Rust
    let rust_code = "fn main() { println!(\"hello\"); }";
    assert!(parser.parse(rust_code, Language::Rust).is_ok());

    // Python
    let python_code = "def hello():\n    print('hello')";
    assert!(parser.parse(python_code, Language::Python).is_ok());

    // TypeScript
    let ts_code = "function hello(): void { console.log('hello'); }";
    assert!(parser.parse(ts_code, Language::TypeScript).is_ok());

    // JavaScript
    let js_code = "function hello() { console.log('hello'); }";
    assert!(parser.parse(js_code, Language::JavaScript).is_ok());

    // Go
    let go_code = "package main\nfunc main() {}";
    assert!(parser.parse(go_code, Language::Go).is_ok());

    // Java
    let java_code = "public class Main { public static void main(String[] args) {} }";
    assert!(parser.parse(java_code, Language::Java).is_ok());
}

/// Test relationship extraction.
#[test]
fn test_relationship_extraction() {
    let agent = AgentMap::new();
    let analysis = agent.analyze_file("src/analyzer/pipeline.rs").unwrap();

    // Should have call relationships
    let has_calls = analysis.relationships.iter()
        .any(|r| matches!(r.kind, agentmap::RelationshipKind::Calls));
    assert!(has_calls, "Should find call relationships");
}

/// Test query loader integration.
#[test]
fn test_query_loader_available() {
    use agentmap::parser::{TreeSitterParser, QueryType};

    let parser = TreeSitterParser::new();

    // Verify queries are loaded
    assert!(parser.queries().has_queries(Language::Rust));
    assert!(parser.queries().has_queries(Language::Python));
    assert!(parser.queries().has_queries(Language::TypeScript));

    // Verify specific query types exist
    assert!(parser.queries().get(Language::Rust, QueryType::Definitions).is_some());
}

/// Test middleware integration.
#[test]
fn test_middleware_stack() {
    use agentmap::middleware::{MetricsMiddleware, MiddlewareStack};

    let mut agent = AgentMap::new();

    let metrics = MetricsMiddleware::new();
    let metrics_clone = metrics.clone();

    agent.add_middleware(metrics);

    // Analyze a file
    let _ = agent.analyze_file("src/lib.rs");

    // Check metrics were recorded
    let snapshot = metrics_clone.snapshot();
    assert!(snapshot.files_analyzed >= 1);
}

/// Benchmark: Analyze entire codebase.
#[test]
#[ignore] // Run with: cargo test --release -- --ignored
fn benchmark_full_codebase() {
    use std::time::Instant;

    let agent = AgentMap::new();
    let start = Instant::now();

    let analyses = agent.analyze_directory("src").unwrap();

    let elapsed = start.elapsed();
    let total_symbols: usize = analyses.iter().map(|a| a.symbols.len()).sum();
    let total_rels: usize = analyses.iter().map(|a| a.relationships.len()).sum();

    println!("\n=== Benchmark Results ===");
    println!("Files: {}", analyses.len());
    println!("Symbols: {}", total_symbols);
    println!("Relationships: {}", total_rels);
    println!("Total time: {:?}", elapsed);
    println!("Avg per file: {:?}", elapsed / analyses.len() as u32);
}
