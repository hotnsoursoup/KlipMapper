//! AgentMap CLI binary.
//!
//! Commands:
//! - `analyze` - Analyze a file or directory
//! - `scan` - Quick scan to list symbols
//! - `check` - Validate analysis metadata is up-to-date
//! - `watch` - Watch files for changes
//! - `query` - Query symbols across the project
//! - `export` - Export analysis to various formats
//! - `stats` - Show analysis statistics

use clap::{Parser, Subcommand, ValueEnum};
use std::path::PathBuf;
use agentmap::{AgentMap, middleware::*};

#[derive(Parser)]
#[command(name = "agentmap")]
#[command(version = "2.0.0")]
#[command(about = "Multi-language code analysis for AI agents", long_about = None)]
#[command(author = "AgentMap Team")]
struct Cli {
    /// Enable verbose output
    #[arg(short, long, global = true)]
    verbose: bool,

    /// Configuration file path
    #[arg(short, long, global = true)]
    config: Option<PathBuf>,

    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    /// Analyze a file or directory for symbols and relationships
    Analyze {
        /// Path to analyze
        #[arg(default_value = ".")]
        path: PathBuf,

        /// Output format (json, yaml, summary)
        #[arg(short, long, default_value = "summary")]
        format: OutputFormat,

        /// Output file (stdout if not specified)
        #[arg(short, long)]
        output: Option<PathBuf>,

        /// Include hidden files
        #[arg(long)]
        include_hidden: bool,

        /// Maximum depth for directory traversal
        #[arg(long)]
        max_depth: Option<usize>,
    },

    /// Quick scan to list symbols (faster, less detail)
    Scan {
        /// Path to scan
        #[arg(default_value = ".")]
        path: PathBuf,

        /// Filter by symbol kind (function, class, etc.)
        #[arg(short, long)]
        kind: Option<String>,

        /// Filter by visibility (public, private)
        #[arg(long)]
        visibility: Option<String>,

        /// Don't write changes
        #[arg(long)]
        no_write: bool,

        /// Output as JSON
        #[arg(long, short)]
        json: bool,
    },

    /// Validate analysis metadata (anchors) is up-to-date
    Check {
        /// Paths to check
        path: Vec<PathBuf>,

        /// Verify content hashes
        #[arg(long)]
        verify_hashes: bool,

        /// Verify symbols exist
        #[arg(long)]
        verify_symbols: bool,

        /// Check anchor headers
        #[arg(long)]
        anchors: bool,

        /// Output as JSON
        #[arg(long, short)]
        json: bool,
    },

    /// Watch files for changes and trigger callbacks
    Watch {
        /// Paths to watch
        path: Vec<PathBuf>,

        /// Debounce time in milliseconds
        #[arg(long, default_value = "300")]
        debounce: u64,

        /// File extensions to watch (e.g., rs,py,ts)
        #[arg(long)]
        extensions: Option<String>,

        /// Watch non-recursively
        #[arg(long)]
        no_recursive: bool,

        /// Show verbose output
        #[arg(long)]
        show_progress: bool,
    },

    /// Query symbols across the project
    Query {
        /// Symbol name to search for
        #[arg(long)]
        symbol: Option<String>,

        /// Pattern to search (glob or regex)
        #[arg(long)]
        pattern: Option<String>,

        /// Search in specific file
        #[arg(long)]
        file: Option<PathBuf>,

        /// Match type (exact, prefix, fuzzy, glob, regex)
        #[arg(long, value_enum, default_value = "fuzzy")]
        match_type: MatchType,

        /// Output format
        #[arg(long, default_value = "text")]
        format: Option<String>,

        /// Paths to search
        path: Vec<PathBuf>,
    },

    /// Export analysis results
    Export {
        /// Path to analyze
        #[arg(default_value = ".")]
        path: PathBuf,

        /// Output format
        #[arg(short, long, value_enum, default_value = "json")]
        format: ExportFormatArg,

        /// Detail level
        #[arg(long, value_enum, default_value = "standard")]
        detail: DetailLevelArg,

        /// Output file (stdout if not specified)
        #[arg(short, long)]
        output: Option<PathBuf>,

        /// Maximum folder depth
        #[arg(long)]
        max_depth: Option<usize>,

        /// Exclude test files
        #[arg(long)]
        exclude_tests: bool,

        /// Include generated files
        #[arg(long)]
        include_generated: bool,

        /// File pattern filters
        #[arg(long)]
        filter: Vec<String>,

        /// Export for RAG (portable graph format)
        #[arg(long)]
        rag: bool,
    },

    /// Show analysis statistics
    Stats {
        /// Path to analyze
        #[arg(default_value = ".")]
        path: PathBuf,
    },

    /// Detect design patterns and architectural conventions
    Patterns {
        /// Path to analyze
        #[arg(default_value = ".")]
        path: PathBuf,

        /// Output as JSON
        #[arg(long, short)]
        json: bool,

        /// Minimum confidence threshold (0.0 - 1.0)
        #[arg(long, default_value = "0.5")]
        min_confidence: f32,
    },
}

#[derive(Clone, Debug, Default)]
enum OutputFormat {
    #[default]
    Summary,
    Json,
    Yaml,
}

impl std::str::FromStr for OutputFormat {
    type Err = String;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        match s.to_lowercase().as_str() {
            "summary" => Ok(OutputFormat::Summary),
            "json" => Ok(OutputFormat::Json),
            "yaml" => Ok(OutputFormat::Yaml),
            _ => Err(format!("Unknown format: {}. Use summary, json, or yaml.", s)),
        }
    }
}

#[derive(Clone, Copy, Debug, Default, ValueEnum)]
enum ExportFormatArg {
    #[default]
    Json,
    JsonCompact,
    Yaml,
    Graphml,
    Dot,
    Mermaid,
    Csv,
    Html,
    Markdown,
    Plantuml,
    D2,
    Cypher,
    /// Token-efficient format for AI agents
    Agent,
}

impl From<ExportFormatArg> for agentmap::ExportFormat {
    fn from(format: ExportFormatArg) -> Self {
        match format {
            ExportFormatArg::Json => agentmap::ExportFormat::Json,
            ExportFormatArg::JsonCompact => agentmap::ExportFormat::JsonCompact,
            ExportFormatArg::Yaml => agentmap::ExportFormat::Yaml,
            ExportFormatArg::Graphml => agentmap::ExportFormat::GraphML,
            ExportFormatArg::Dot => agentmap::ExportFormat::Dot,
            ExportFormatArg::Mermaid => agentmap::ExportFormat::Mermaid,
            ExportFormatArg::Csv => agentmap::ExportFormat::Csv,
            ExportFormatArg::Html => agentmap::ExportFormat::Html,
            ExportFormatArg::Markdown => agentmap::ExportFormat::Markdown,
            ExportFormatArg::Plantuml => agentmap::ExportFormat::PlantUml,
            ExportFormatArg::D2 => agentmap::ExportFormat::D2,
            ExportFormatArg::Cypher => agentmap::ExportFormat::Cypher,
            ExportFormatArg::Agent => agentmap::ExportFormat::AgentContext,
        }
    }
}

#[derive(Clone, Copy, Debug, Default, ValueEnum)]
enum DetailLevelArg {
    Minimal,
    Basic,
    #[default]
    Standard,
    Detailed,
    Complete,
}

impl From<DetailLevelArg> for agentmap::DetailLevel {
    fn from(level: DetailLevelArg) -> Self {
        match level {
            DetailLevelArg::Minimal => agentmap::DetailLevel::Minimal,
            DetailLevelArg::Basic => agentmap::DetailLevel::Basic,
            DetailLevelArg::Standard => agentmap::DetailLevel::Standard,
            DetailLevelArg::Detailed => agentmap::DetailLevel::Detailed,
            DetailLevelArg::Complete => agentmap::DetailLevel::Complete,
        }
    }
}

#[derive(Clone, Copy, Debug, Default, ValueEnum)]
enum MatchType {
    Exact,
    Prefix,
    #[default]
    Fuzzy,
    Glob,
    Regex,
}

fn main() {
    let cli = Cli::parse();

    if let Err(e) = run(cli) {
        eprintln!("Error: {}", e);
        std::process::exit(1);
    }
}

fn run(cli: Cli) -> Result<(), Box<dyn std::error::Error>> {
    // Create AgentMap with appropriate middleware
    let mut agent = AgentMap::new();

    // Add logging middleware if verbose
    if cli.verbose {
        agent.add_middleware(LoggingMiddleware::with_level(LogLevel::Debug));
    }

    // Add metrics middleware for stats
    let metrics = MetricsMiddleware::new();
    agent.add_middleware(metrics.clone());

    match cli.command {
        Commands::Analyze { path, format, output, include_hidden: _, max_depth: _ } => {
            run_analyze(&agent, &path, format, output.as_deref())
        }
        Commands::Scan { path, kind, visibility, no_write: _, json } => {
            run_scan(&agent, &path, kind.as_deref(), visibility.as_deref(), json)
        }
        Commands::Check { path, verify_hashes, verify_symbols, anchors, json } => {
            run_check(&path, verify_hashes, verify_symbols, anchors, json)
        }
        Commands::Watch { path, debounce, extensions, no_recursive, show_progress } => {
            run_watch(&path, debounce, extensions.as_deref(), no_recursive, show_progress)
        }
        Commands::Query { symbol, pattern, file, match_type, format, path } => {
            run_query(&agent, symbol.as_deref(), pattern.as_deref(), file.as_deref(), match_type, format.as_deref(), &path)
        }
        Commands::Export { path, format, detail, output, max_depth, exclude_tests, include_generated, filter, rag } => {
            run_export_enhanced(&agent, &path, format, detail, output.as_deref(), max_depth, exclude_tests, include_generated, &filter, rag)
        }
        Commands::Stats { path } => {
            run_stats(&agent, &path, &metrics)
        }
        Commands::Patterns { path, json, min_confidence } => {
            run_patterns(&agent, &path, json, min_confidence)
        }
    }
}

fn run_analyze(
    agent: &AgentMap,
    path: &PathBuf,
    format: OutputFormat,
    output: Option<&std::path::Path>,
) -> Result<(), Box<dyn std::error::Error>> {
    let analyses = if path.is_file() {
        vec![agent.analyze_file(path)?]
    } else {
        agent.analyze_directory(path)?
    };

    let output_str = match format {
        OutputFormat::Summary => format_summary(&analyses),
        OutputFormat::Json => serde_json::to_string_pretty(&analyses)?,
        OutputFormat::Yaml => serde_yaml::to_string(&analyses)?,
    };

    if let Some(out_path) = output {
        std::fs::write(out_path, &output_str)?;
        println!("Output written to: {}", out_path.display());
    } else {
        println!("{}", output_str);
    }

    Ok(())
}

fn run_scan(
    agent: &AgentMap,
    path: &PathBuf,
    kind_filter: Option<&str>,
    visibility_filter: Option<&str>,
    json: bool,
) -> Result<(), Box<dyn std::error::Error>> {
    let analyses = if path.is_file() {
        vec![agent.analyze_file(path)?]
    } else {
        agent.analyze_directory(path)?
    };

    if json {
        println!("{}", serde_json::to_string_pretty(&analyses)?);
        return Ok(());
    }

    println!("Symbols found:\n");

    for analysis in &analyses {
        for symbol in &analysis.symbols {
            // Apply filters
            if let Some(kind) = kind_filter {
                if !symbol.kind.to_string().contains(kind) {
                    continue;
                }
            }
            if let Some(vis) = visibility_filter {
                if !symbol.visibility.to_string().contains(vis) {
                    continue;
                }
            }

            println!(
                "  {} {} [{}] - {}:{}",
                symbol.visibility,
                symbol.kind,
                symbol.name,
                analysis.file_path.file_name().unwrap_or_default().to_string_lossy(),
                symbol.location.start_line
            );
        }
    }

    let total_symbols: usize = analyses.iter().map(|a| a.symbols.len()).sum();
    println!("\nTotal: {} symbols in {} files", total_symbols, analyses.len());

    Ok(())
}

fn run_check(
    paths: &[PathBuf],
    verify_hashes: bool,
    verify_symbols: bool,
    anchors: bool,
    json: bool,
) -> Result<(), Box<dyn std::error::Error>> {
    use agentmap::{Checker, CheckConfig, CheckResult};

    let paths = if paths.is_empty() {
        vec![PathBuf::from(".")]
    } else {
        paths.to_vec()
    };

    let config = CheckConfig::new()
        .with_verify_hashes(verify_hashes || !verify_symbols)
        .with_verify_symbols(verify_symbols)
        .with_check_anchors(anchors);

    let checker = Checker::with_config(config);
    let summary = checker.check_paths(&paths)?;

    if json {
        println!("{}", serde_json::to_string_pretty(&summary)?);
        return Ok(());
    }

    println!("Check Results:");
    println!("  \u{2705} Valid: {}", summary.valid_count());
    if summary.missing_count() > 0 {
        println!("  \u{274C} Missing: {}", summary.missing_count());
    }
    if summary.outdated_count() > 0 {
        println!("  \u{26A0}\u{FE0F}  Outdated: {}", summary.outdated_count());
    }
    if summary.invalid_count() > 0 {
        println!("  \u{1F4A5} Invalid: {}", summary.invalid_count());
    }

    if summary.has_issues() {
        println!("\nIssues found:");
        for issue in summary.issues() {
            match issue.result {
                CheckResult::Valid | CheckResult::Skipped => continue,
                CheckResult::Missing => {
                    println!("  \u{274C} {}: {}",
                        issue.path.display(),
                        issue.message.as_deref().unwrap_or("Missing metadata")
                    );
                }
                CheckResult::Outdated => {
                    println!("  \u{26A0}\u{FE0F}  {}: {}",
                        issue.path.display(),
                        issue.message.as_deref().unwrap_or("Outdated")
                    );
                }
                CheckResult::Invalid => {
                    println!("  \u{1F4A5} {}: {}",
                        issue.path.display(),
                        issue.message.as_deref().unwrap_or("Invalid")
                    );
                }
            }
        }
        std::process::exit(1);
    } else {
        println!("\n\u{1F389} All metadata is valid and up-to-date!");
    }

    Ok(())
}

fn run_watch(
    paths: &[PathBuf],
    debounce_ms: u64,
    extensions: Option<&str>,
    no_recursive: bool,
    show_progress: bool,
) -> Result<(), Box<dyn std::error::Error>> {
    use agentmap::{Watcher, WatchConfig, WatchEventKind};

    let paths = if paths.is_empty() {
        vec![PathBuf::from(".")]
    } else {
        paths.to_vec()
    };

    let mut config = WatchConfig::new()
        .with_debounce_ms(debounce_ms)
        .with_recursive(!no_recursive)
        .with_progress(show_progress)
        .with_verbose(show_progress);

    if let Some(exts) = extensions {
        for ext in exts.split(',') {
            config = config.add_extension(ext.trim());
        }
    }

    let mut watcher = Watcher::new(config);
    for path in paths {
        watcher = watcher.add_path(path);
    }

    println!("Watching for file changes... Press Ctrl+C to stop.\n");

    watcher.watch(|event| {
        let emoji = match event.kind {
            WatchEventKind::Created => "\u{2795}",
            WatchEventKind::Modified => "\u{270F}\u{FE0F}",
            WatchEventKind::Removed => "\u{2796}",
            WatchEventKind::Renamed => "\u{1F4E6}",
            WatchEventKind::Other => "\u{2139}\u{FE0F}",
        };

        println!("{} {} {}", emoji, event.kind, event.summary());
        true // Continue watching
    })?;

    Ok(())
}

fn run_query(
    agent: &AgentMap,
    symbol: Option<&str>,
    pattern: Option<&str>,
    _file: Option<&std::path::Path>,
    match_type: MatchType,
    format: Option<&str>,
    paths: &[PathBuf],
) -> Result<(), Box<dyn std::error::Error>> {
    use agentmap::query::QueryBuilder;

    let search_term = symbol.or(pattern).unwrap_or("");
    if search_term.is_empty() {
        println!("Please provide --symbol or --pattern to search");
        return Ok(());
    }

    // Collect analyses from paths
    let paths = if paths.is_empty() {
        vec![PathBuf::from(".")]
    } else {
        paths.to_vec()
    };

    let mut analyses = Vec::new();
    for path in &paths {
        if path.is_file() {
            if let Ok(analysis) = agent.analyze_file(path) {
                analyses.push(analysis);
            }
        } else {
            if let Ok(dir_analyses) = agent.analyze_directory(path) {
                analyses.extend(dir_analyses);
            }
        }
    }

    if analyses.is_empty() {
        println!("No files found to search in");
        return Ok(());
    }

    // Build query based on match type using the correct factory methods
    let query = match match_type {
        MatchType::Exact => QueryBuilder::new().exact(search_term),
        MatchType::Prefix => QueryBuilder::new().glob(format!("{}*", search_term)),
        MatchType::Fuzzy => QueryBuilder::new().fuzzy(search_term, 0.5),
        MatchType::Glob => QueryBuilder::new().glob(search_term),
        MatchType::Regex => QueryBuilder::new().regex(search_term),
    };

    // Execute search
    let results = query.search_parallel(&analyses)?;

    if format == Some("json") {
        // Serialize results as JSON
        #[derive(serde::Serialize)]
        struct QueryOutput {
            search_term: String,
            match_type: String,
            files_searched: usize,
            duration_ms: u64,
            matches: Vec<MatchOutput>,
        }
        #[derive(serde::Serialize)]
        struct MatchOutput {
            symbol_name: String,
            symbol_kind: String,
            file_path: String,
            confidence: f32,
        }

        let output = QueryOutput {
            search_term: search_term.to_string(),
            match_type: format!("{:?}", match_type),
            files_searched: results.files_searched,
            duration_ms: results.duration_ms,
            matches: results.matches.iter().map(|m| MatchOutput {
                symbol_name: m.symbol.name.clone(),
                symbol_kind: m.symbol.kind.to_string(),
                file_path: m.file_path.clone(),
                confidence: m.confidence,
            }).collect(),
        };

        println!("{}", serde_json::to_string_pretty(&output)?);
    } else {
        println!("Query for '{}' (match type: {:?})", search_term, match_type);
        println!("Searched {} files in {}ms\n", results.files_searched, results.duration_ms);

        if results.is_empty() {
            println!("No matches found.");
        } else {
            println!("Found {} matches:\n", results.len());
            for m in &results.matches {
                println!(
                    "  {} [{}] in {} (confidence: {:.2})",
                    m.symbol.name,
                    m.symbol.kind,
                    m.file_path,
                    m.confidence
                );
            }
        }
    }

    Ok(())
}

fn run_export_enhanced(
    agent: &AgentMap,
    path: &PathBuf,
    format: ExportFormatArg,
    detail: DetailLevelArg,
    output: Option<&std::path::Path>,
    max_depth: Option<usize>,
    exclude_tests: bool,
    include_generated: bool,
    filters: &[String],
    rag: bool,
) -> Result<(), Box<dyn std::error::Error>> {
    use agentmap::{ArchitectureExporter, ExporterConfig, export_all};

    if rag {
        // Export as portable graph format for RAG
        let analyses = if path.is_file() {
            vec![agent.analyze_file(path)?]
        } else {
            agent.analyze_directory(path)?
        };

        let graphs: Vec<_> = analyses.iter()
            .map(|a| DbKitMiddleware::analysis_to_portable(a))
            .collect();

        let output_str = serde_json::to_string_pretty(&graphs)?;

        if let Some(out_path) = output {
            std::fs::write(out_path, &output_str)?;
            println!("\u{2705} RAG export written to: {}", out_path.display());
        } else {
            println!("{}", output_str);
        }

        return Ok(());
    }

    // Check if this is a file-level export (use CodeAnalysis export) or architecture export
    let is_architecture_format = matches!(
        format,
        ExportFormatArg::Json
            | ExportFormatArg::JsonCompact
            | ExportFormatArg::Yaml
    );

    // For diagram/document formats, use CodeAnalysis export
    if !is_architecture_format {
        let analyses = if path.is_file() {
            vec![agent.analyze_file(path)?]
        } else {
            agent.analyze_directory(path)?
        };

        let export_format: agentmap::ExportFormat = format.into();

        if let Some(out_path) = output {
            let mut file = std::fs::File::create(out_path)?;
            export_all(&analyses, export_format, &mut file)?;
            println!("\u{2705} Exported to: {}", out_path.display());
        } else {
            let mut stdout = std::io::stdout();
            export_all(&analyses, export_format, &mut stdout)?;
        }

        return Ok(());
    }

    // Architecture export for JSON/YAML
    let mut config = ExporterConfig::new()
        .with_detail_level(detail.into());

    if exclude_tests {
        config = config.exclude_tests();
    }
    if include_generated {
        config = config.include_generated();
    }
    if let Some(depth) = max_depth {
        config = config.with_max_depth(depth);
    }
    for filter in filters {
        config = config.add_filter(filter.clone());
    }

    let exporter = ArchitectureExporter::with_config(path.clone(), config);

    // Export with empty headers (would need to load from database)
    let architecture = exporter.export(&[])?;

    // Serialize architecture to the requested format
    let output_str = match format {
        ExportFormatArg::Json => serde_json::to_string_pretty(&architecture)?,
        ExportFormatArg::JsonCompact => serde_json::to_string(&architecture)?,
        ExportFormatArg::Yaml => serde_yaml::to_string(&architecture)?,
        _ => unreachable!(), // Already handled above
    };

    if let Some(out_path) = output {
        std::fs::write(out_path, &output_str)?;
        println!("\u{2705} Architecture exported to: {}", out_path.display());
    } else {
        println!("{}", output_str);
    }

    Ok(())
}

fn run_stats(
    agent: &AgentMap,
    path: &PathBuf,
    metrics: &MetricsMiddleware,
) -> Result<(), Box<dyn std::error::Error>> {
    // Analyze first to gather metrics
    let analyses = if path.is_file() {
        vec![agent.analyze_file(path)?]
    } else {
        agent.analyze_directory(path)?
    };

    let snapshot = metrics.snapshot();

    println!("=== AgentMap Analysis Statistics ===\n");
    println!("Files analyzed: {}", snapshot.files_analyzed);
    println!("Total symbols:  {}", snapshot.total_symbols);
    println!("Total relationships: {}", snapshot.total_relationships);
    println!("Avg symbols/file: {:.1}", snapshot.avg_symbols_per_file());
    println!("Avg parse time: {:.2}ms", snapshot.avg_parse_time_ms());
    println!("Avg analyze time: {:.2}ms", snapshot.avg_analyze_time_ms());

    println!("\nLanguage breakdown:");
    for (lang, count) in &snapshot.language_counts {
        println!("  {}: {} files", lang, count);
    }

    // Relationship type summary
    let mut rel_types: std::collections::HashMap<String, usize> = std::collections::HashMap::new();
    for analysis in &analyses {
        for rel in &analysis.relationships {
            *rel_types.entry(rel.kind.to_string()).or_insert(0) += 1;
        }
    }

    if !rel_types.is_empty() {
        println!("\nRelationship breakdown:");
        for (kind, count) in &rel_types {
            println!("  {}: {}", kind, count);
        }
    }

    Ok(())
}

fn format_summary(analyses: &[agentmap::CodeAnalysis]) -> String {
    let mut out = String::new();

    for analysis in analyses {
        out.push_str(&format!("\n=== {} ({}) ===\n",
            analysis.file_path.display(),
            analysis.language
        ));

        out.push_str(&format!("Lines: {}, Symbols: {}, Relationships: {}\n",
            analysis.metadata.line_count,
            analysis.symbols.len(),
            analysis.relationships.len()
        ));

        if !analysis.symbols.is_empty() {
            out.push_str("\nSymbols:\n");
            for symbol in &analysis.symbols {
                out.push_str(&format!("  {} {} [{}] L{}\n",
                    symbol.visibility,
                    symbol.kind,
                    symbol.name,
                    symbol.location.start_line
                ));
            }
        }

        if !analysis.relationships.is_empty() {
            out.push_str("\nRelationships:\n");
            for rel in analysis.relationships.iter().take(10) {
                out.push_str(&format!("  {} --[{}]--> {}\n",
                    rel.from.name().unwrap_or("?"),
                    rel.kind,
                    rel.to.name().unwrap_or("?")
                ));
            }
            if analysis.relationships.len() > 10 {
                out.push_str(&format!("  ... and {} more\n", analysis.relationships.len() - 10));
            }
        }
    }

    out
}

fn run_patterns(
    agent: &AgentMap,
    path: &PathBuf,
    json: bool,
    min_confidence: f32,
) -> Result<(), Box<dyn std::error::Error>> {
    // Analyze the codebase
    let analyses = if path.is_file() {
        vec![agent.analyze_file(path)?]
    } else {
        agent.analyze_directory(path)?
    };

    // Detect patterns by examining naming conventions and relationships
    let mut patterns: Vec<DetectedPattern> = Vec::new();

    // Collect all symbols and their info
    let mut factories = Vec::new();
    let mut repositories = Vec::new();
    let mut services = Vec::new();
    let mut controllers = Vec::new();
    let mut singletons = Vec::new();
    let mut builders = Vec::new();
    let mut handlers = Vec::new();
    let mut providers = Vec::new();

    for analysis in &analyses {
        for symbol in &analysis.symbols {
            let name_lower = symbol.name.to_lowercase();
            let file_path = analysis.file_path.to_string_lossy().to_string();

            let info = PatternInstance {
                name: symbol.name.clone(),
                file: file_path,
                line: symbol.location.start_line,
                kind: symbol.kind.to_string(),
            };

            if name_lower.contains("factory") {
                factories.push(info);
            } else if name_lower.contains("repository") || name_lower.contains("repo") {
                repositories.push(info);
            } else if name_lower.contains("service") {
                services.push(info);
            } else if name_lower.contains("controller") {
                controllers.push(info);
            } else if name_lower.contains("singleton") {
                singletons.push(info);
            } else if name_lower.contains("builder") {
                builders.push(info);
            } else if name_lower.contains("handler") {
                handlers.push(info);
            } else if name_lower.contains("provider") {
                providers.push(info);
            }
        }
    }

    // Create pattern entries
    if !factories.is_empty() {
        patterns.push(DetectedPattern {
            name: "Factory".to_string(),
            pattern_type: "creational".to_string(),
            confidence: 0.9,
            instances: factories,
            description: "Creates objects without specifying exact classes".to_string(),
        });
    }

    if !repositories.is_empty() {
        patterns.push(DetectedPattern {
            name: "Repository".to_string(),
            pattern_type: "architectural".to_string(),
            confidence: 0.9,
            instances: repositories,
            description: "Encapsulates data access logic".to_string(),
        });
    }

    if !services.is_empty() {
        patterns.push(DetectedPattern {
            name: "Service".to_string(),
            pattern_type: "architectural".to_string(),
            confidence: 0.85,
            instances: services,
            description: "Encapsulates business logic".to_string(),
        });
    }

    if !controllers.is_empty() {
        patterns.push(DetectedPattern {
            name: "Controller".to_string(),
            pattern_type: "architectural".to_string(),
            confidence: 0.9,
            instances: controllers,
            description: "Handles requests and coordinates responses (MVC)".to_string(),
        });
    }

    if !singletons.is_empty() {
        patterns.push(DetectedPattern {
            name: "Singleton".to_string(),
            pattern_type: "creational".to_string(),
            confidence: 0.85,
            instances: singletons,
            description: "Ensures only one instance exists".to_string(),
        });
    }

    if !builders.is_empty() {
        patterns.push(DetectedPattern {
            name: "Builder".to_string(),
            pattern_type: "creational".to_string(),
            confidence: 0.9,
            instances: builders,
            description: "Constructs complex objects step by step".to_string(),
        });
    }

    if !handlers.is_empty() {
        patterns.push(DetectedPattern {
            name: "Handler".to_string(),
            pattern_type: "behavioral".to_string(),
            confidence: 0.8,
            instances: handlers,
            description: "Processes requests or events".to_string(),
        });
    }

    if !providers.is_empty() {
        patterns.push(DetectedPattern {
            name: "Provider".to_string(),
            pattern_type: "architectural".to_string(),
            confidence: 0.8,
            instances: providers,
            description: "Supplies dependencies or services".to_string(),
        });
    }

    // Filter by confidence
    patterns.retain(|p| p.confidence >= min_confidence);

    // Output
    if json {
        let output = PatternReport {
            files_analyzed: analyses.len(),
            patterns_found: patterns.len(),
            patterns,
        };
        println!("{}", serde_json::to_string_pretty(&output)?);
    } else {
        println!("Pattern Analysis");
        println!("================");
        println!("Files analyzed: {}", analyses.len());
        println!("Patterns found: {}\n", patterns.len());

        for pattern in &patterns {
            println!("{} ({}) - {:.0}% confidence",
                pattern.name,
                pattern.pattern_type,
                pattern.confidence * 100.0
            );
            println!("  {}", pattern.description);
            println!("  Instances:");
            for inst in &pattern.instances {
                println!("    - {} [{}] at {}:{}", inst.name, inst.kind, inst.file, inst.line);
            }
            println!();
        }

        if patterns.is_empty() {
            println!("No patterns detected above {:.0}% confidence threshold.", min_confidence * 100.0);
        }
    }

    Ok(())
}

#[derive(serde::Serialize)]
struct PatternReport {
    files_analyzed: usize,
    patterns_found: usize,
    patterns: Vec<DetectedPattern>,
}

#[derive(serde::Serialize)]
struct DetectedPattern {
    name: String,
    pattern_type: String,
    confidence: f32,
    instances: Vec<PatternInstance>,
    description: String,
}

#[derive(serde::Serialize)]
struct PatternInstance {
    name: String,
    file: String,
    line: u32,
    kind: String,
}
