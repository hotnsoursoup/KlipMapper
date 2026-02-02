//! End-to-end test for scanning a generated multi-language repository.
//!
//! This test verifies the full Scanner → DbKitMiddleware → PortableGraph workflow
//! across multiple languages.

use agentmap::{
    Scanner, ScanConfig,
    middleware::{MiddlewareStack, DbKitMiddleware, PortableGraph},
};
use std::fs::{self, File};
use std::io::Write;
use std::path::Path;
use std::sync::{Arc, Mutex};

/// Simple LCG-based RNG for deterministic test data.
struct Rng(u64);

impl Rng {
    fn new(seed: u64) -> Self { Self(seed) }

    fn next_u32(&mut self) -> u32 {
        self.0 = self.0.wrapping_mul(1664525).wrapping_add(1013904223);
        (self.0 >> 16) as u32
    }

    fn ident(&mut self, prefix: &str) -> String {
        let n = self.next_u32() % 10_000;
        format!("{prefix}_{n}")
    }
}

fn ensure_dir(p: &Path) {
    if let Some(parent) = p.parent() {
        let _ = fs::create_dir_all(parent);
    }
}

fn write_file(path: &Path, contents: &str) {
    ensure_dir(path);
    let mut f = File::create(path).unwrap();
    f.write_all(contents.as_bytes()).unwrap();
}

// Language-specific code generators

fn gen_python(mut r: Rng) -> String {
    format!(
        "import os\n\ndef {}():\n    return 1\n\nclass {}:\n    def {}(self):\n        return 2\n",
        r.ident("func"), r.ident("MyClass"), r.ident("method")
    )
}

fn gen_rust(mut r: Rng) -> String {
    format!(
        "fn {}() -> i32 {{ 1 }}\n\nstruct {} {{\n    value: i32,\n}}\n",
        r.ident("func"), r.ident("MyStruct")
    )
}

fn gen_typescript(mut r: Rng) -> String {
    format!(
        "function {}(): number {{ return 1; }}\n\nclass {} {{\n    {}(): void {{}}\n}}\n",
        r.ident("func"), r.ident("MyClass"), r.ident("method")
    )
}

fn gen_go(mut r: Rng) -> String {
    format!(
        "package main\n\nfunc {}() int {{ return 1 }}\n\ntype {} struct {{\n    Value int\n}}\n",
        r.ident("Func"), r.ident("MyStruct")
    )
}

fn gen_java(mut r: Rng) -> String {
    format!(
        "package test;\n\npublic class {} {{\n    public void {}() {{}}\n}}\n",
        r.ident("MyClass"), r.ident("method")
    )
}

fn gen_dart(mut r: Rng) -> String {
    format!(
        "class {} {{\n    {}() {{}}\n}}\n\n{}() {{}}\n",
        r.ident("MyClass"), r.ident("constructor"), r.ident("func")
    )
}

/// Generate a multi-language test repository.
fn generate_repo(root: &Path, files_per_lang: usize, seed: u64) -> usize {
    let langs = [
        ("python", "py", gen_python as fn(Rng) -> String),
        ("rust", "rs", gen_rust as fn(Rng) -> String),
        ("typescript", "ts", gen_typescript as fn(Rng) -> String),
        ("go", "go", gen_go as fn(Rng) -> String),
        ("java", "java", gen_java as fn(Rng) -> String),
        ("dart", "dart", gen_dart as fn(Rng) -> String),
    ];

    let mut total = 0;

    for (i, (lang_dir, ext, generator)) in langs.iter().enumerate() {
        for j in 0..files_per_lang {
            let rng = Rng::new(seed.wrapping_add((i as u64) << 32 | j as u64));
            let mut name_rng = Rng::new(seed.wrapping_add((i as u64) << 16 | j as u64));

            let file_name = format!("{}.{}", name_rng.ident("file"), ext);
            let contents = generator(rng);

            let path = root.join(lang_dir).join(&file_name);
            write_file(&path, &contents);
            total += 1;
        }
    }

    total
}

/// Middleware that captures analysis results for verification.
struct CaptureMiddleware {
    results: Arc<Mutex<Vec<PortableGraph>>>,
}

impl CaptureMiddleware {
    fn new() -> (Self, Arc<Mutex<Vec<PortableGraph>>>) {
        let results = Arc::new(Mutex::new(Vec::new()));
        (Self { results: results.clone() }, results)
    }
}

impl agentmap::Middleware for CaptureMiddleware {
    fn after_analyze(
        &self,
        _ctx: &agentmap::middleware::Context,
        analysis: &agentmap::CodeAnalysis,
    ) -> agentmap::Result<()> {
        let graph = DbKitMiddleware::analysis_to_portable(analysis);
        self.results.lock().unwrap().push(graph);
        Ok(())
    }

    fn name(&self) -> &str {
        "CaptureMiddleware"
    }
}

#[test]
fn test_scan_with_dbkit_middleware() {
    // Create temp directory
    let temp_dir = tempfile::tempdir().expect("failed to create temp dir");
    let root = temp_dir.path();

    // Generate test files (5 per language, 6 languages = 30 files)
    let total_files = generate_repo(root, 5, 12345);
    assert_eq!(total_files, 30, "Should generate 30 test files");

    // Setup middleware stack with DbKit conversion
    let mut middleware = MiddlewareStack::new();
    let (capture, results) = CaptureMiddleware::new();
    middleware.push(DbKitMiddleware::new());
    middleware.push(capture);

    // Configure scanner
    let config = ScanConfig::quick();
    let scanner = Scanner::with_config(config).with_middleware(middleware);

    // Scan the generated repository
    let scan_result = scanner.scan_directory(root).expect("scan failed");

    // Verify scan results
    assert_eq!(
        scan_result.success_count(),
        total_files,
        "Should successfully scan all {} files, got {}",
        total_files,
        scan_result.success_count()
    );
    assert!(
        scan_result.errors.is_empty(),
        "Should have no errors, got: {:?}",
        scan_result.errors
    );

    // Verify captured portable graphs
    let captured = results.lock().unwrap();
    assert_eq!(
        captured.len(),
        total_files,
        "Should capture {} graphs, got {}",
        total_files,
        captured.len()
    );

    // Verify each graph has entities (symbols)
    for (i, graph) in captured.iter().enumerate() {
        assert!(
            !graph.entities.is_empty(),
            "Graph {} should have entities",
            i
        );

        // Each file should have at least a function or class
        let has_function = graph.entities.iter().any(|e| e.entity_type == "function");
        let has_class = graph.entities.iter().any(|e|
            e.entity_type == "class" || e.entity_type == "struct"
        );
        assert!(
            has_function || has_class,
            "Graph {} should have a function or class/struct",
            i
        );
    }

    // Count total entities across all files
    let total_entities: usize = captured.iter().map(|g| g.entities.len()).sum();
    assert!(
        total_entities >= total_files,
        "Should have at least {} entities (one per file), got {}",
        total_files,
        total_entities
    );
}

#[test]
fn test_portable_graph_structure() {
    // Create a single test file
    let temp_dir = tempfile::tempdir().expect("failed to create temp dir");
    let test_file = temp_dir.path().join("test.rs");

    fs::write(&test_file, r#"
        pub fn my_function() -> i32 { 42 }

        pub struct MyStruct {
            pub value: String,
        }

        impl MyStruct {
            pub fn new() -> Self {
                Self { value: String::new() }
            }
        }
    "#).unwrap();

    // Setup middleware
    let mut middleware = MiddlewareStack::new();
    let (capture, results) = CaptureMiddleware::new();
    middleware.push(DbKitMiddleware::new());
    middleware.push(capture);

    // Scan single file
    let config = ScanConfig::quick();
    let scanner = Scanner::with_config(config).with_middleware(middleware);
    let scan_result = scanner.scan_directory(temp_dir.path()).expect("scan failed");

    assert_eq!(scan_result.success_count(), 1);

    // Verify graph structure
    let captured = results.lock().unwrap();
    assert_eq!(captured.len(), 1);

    let graph = &captured[0];

    // Should have function and struct
    let function = graph.entities.iter().find(|e| e.name == "my_function");
    assert!(function.is_some(), "Should find my_function");

    let my_struct = graph.entities.iter().find(|e| e.name == "MyStruct");
    assert!(my_struct.is_some(), "Should find MyStruct");

    // Verify entity properties
    let func = function.unwrap();
    assert_eq!(func.entity_type, "function");
    assert!(func.properties.contains_key("visibility"));
    assert!(func.properties.contains_key("file"));
    assert!(func.properties.contains_key("line"));
}
