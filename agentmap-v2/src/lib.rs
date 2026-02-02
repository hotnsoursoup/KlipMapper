//! AgentMap v2 - Multi-language code analysis for AI agents
//!
//! This crate provides language-aware code parsing and relationship analysis
//! with direct integration to RAG systems via db-kit.
//!
//! # Example
//!
//! ```rust,ignore
//! use agentmap::AgentMap;
//!
//! let agent = AgentMap::new();
//! let analysis = agent.analyze_file("src/main.rs")?;
//!
//! for symbol in &analysis.symbols {
//!     println!("{}: {} at line {}",
//!         symbol.kind,
//!         symbol.name,
//!         symbol.location.start_line);
//! }
//! ```
//!
//! # Features
//!
//! - `cli` - Command-line interface (default)
//! - `db-kit` - Integration with db-kit for RAG indexing
//! - `tracing` - Observability via tracing crate

pub mod core;
pub mod parser;
pub mod analyzer;
pub mod middleware;
pub mod config;
pub mod extensions;
pub mod adapters;
pub mod scanner;
pub mod query;
pub mod util;
pub mod export;
pub mod anchor;
pub mod checker;
pub mod watcher;
pub mod architecture;

#[cfg(feature = "embedding")]
pub mod embedding;

#[cfg(feature = "embedding")]
pub mod storage;

#[cfg(feature = "db-kit")]
pub mod integrations;
// Re-export core types at crate root
pub use core::{
    Symbol, SymbolId, SymbolKind, Visibility,
    Relationship, RelationshipKind,
    CodeAnalysis, AnalysisMetadata,
    SourceLocation,
    Error, Result,
};

pub use parser::{Parser, Language};
pub use analyzer::Analyzer;
pub use middleware::{Middleware, MiddlewareStack};
pub use config::Config;
pub use scanner::{Scanner, ScanConfig, ScanResult};
pub use query::{QueryBuilder, SymbolMatcher, Pattern, SearchResults};
pub use export::{ExportFormat, Exporter, export, export_all, AgentContextExporter, AgentContext, ProjectContext};
pub use anchor::{
    AnchorHeader, AnchorHeaderBuilder, AnchorCompressor,
    InlineAnchor, Symbol as AnchorSymbol, SourceRange as AnchorSourceRange,
    ANCHOR_VERSION,
};
pub use checker::{Checker, CheckConfig, CheckResult, CheckSummary, CheckIssue};
pub use watcher::{Watcher, WatchConfig, WatchEvent, WatchEventKind};
pub use architecture::{
    ArchitectureExporter, ExporterConfig, ProjectArchitecture,
    DetailLevel, ArchitectureSymbol, ArchitectureRelationship,
    ArchitectureLayer, ArchitecturePattern, PatternType,
};

/// Main entry point for code analysis.
pub struct AgentMap {
    parser: Box<dyn Parser>,
    analyzer: Box<dyn Analyzer>,
    middleware: MiddlewareStack,
}

impl AgentMap {
    /// Create a new AgentMap with default configuration.
    pub fn new() -> Self {
        Self {
            parser: Box::new(parser::TreeSitterParser::new()),
            analyzer: Box::new(analyzer::DefaultAnalyzer::new()),
            middleware: MiddlewareStack::new(),
        }
    }

    /// Create with custom middleware stack.
    pub fn with_middleware(mut self, middleware: MiddlewareStack) -> Self {
        self.middleware = middleware;
        self
    }

    /// Add a middleware to the stack.
    pub fn add_middleware<M: Middleware + 'static>(&mut self, middleware: M) {
        self.middleware.push(middleware);
    }

    /// Analyze a single file.
    pub fn analyze_file(&self, path: impl AsRef<std::path::Path>) -> Result<CodeAnalysis> {
        let path = path.as_ref();
        let content = std::fs::read_to_string(path)?;
        let language = Language::detect_from_path(path)?;

        // Run middleware before_parse
        let mut ctx = middleware::Context::new(path);
        self.middleware.before_parse(&mut ctx)?;

        // Parse
        let parsed = self.parser.parse(&content, language)?;
        self.middleware.after_parse(&ctx, &parsed)?;

        // Analyze
        self.middleware.before_analyze(&mut ctx)?;
        let analysis = self.analyzer.analyze(&parsed, path)?;
        self.middleware.after_analyze(&ctx, &analysis)?;

        Ok(analysis)
    }

    /// Analyze all supported files in a directory.
    pub fn analyze_directory(&self, path: impl AsRef<std::path::Path>) -> Result<Vec<CodeAnalysis>> {
        let path = path.as_ref();
        let mut results = Vec::new();

        for entry in walkdir(path)? {
            if let Ok(analysis) = self.analyze_file(&entry) {
                results.push(analysis);
            }
        }

        Ok(results)
    }
}

impl Default for AgentMap {
    fn default() -> Self {
        Self::new()
    }
}

// Simple directory walker (avoids extra dependency)
fn walkdir(path: &std::path::Path) -> Result<Vec<std::path::PathBuf>> {
    let mut files = Vec::new();

    if path.is_file() {
        files.push(path.to_path_buf());
        return Ok(files);
    }

    for entry in std::fs::read_dir(path)? {
        let entry = entry?;
        let entry_path = entry.path();

        if entry_path.is_dir() {
            // Skip hidden directories
            if entry_path.file_name()
                .and_then(|n| n.to_str())
                .map(|n| n.starts_with('.'))
                .unwrap_or(false)
            {
                continue;
            }
            files.extend(walkdir(&entry_path)?);
        } else if entry_path.is_file()
            && Language::detect_from_path(&entry_path).is_ok() {
                files.push(entry_path);
            }
    }

    Ok(files)
}
