//! AgentMap CLI binary.
//!
//! Commands:
//! - `analyze` - Analyze a file or directory
//! - `scan` - Quick scan to list symbols
//! - `export` - Export analysis to JSON/YAML
//! - `stats` - Show analysis statistics

use clap::{Parser, Subcommand};
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
    },

    /// Export analysis results
    Export {
        /// Path to analyze
        #[arg(default_value = ".")]
        path: PathBuf,

        /// Output format
        #[arg(short, long, default_value = "json")]
        format: OutputFormat,

        /// Output file
        #[arg(short, long)]
        output: PathBuf,

        /// Export format for RAG (portable graph format)
        #[arg(long)]
        rag: bool,
    },

    /// Show analysis statistics
    Stats {
        /// Path to analyze
        #[arg(default_value = ".")]
        path: PathBuf,
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
        Commands::Scan { path, kind, visibility } => {
            run_scan(&agent, &path, kind.as_deref(), visibility.as_deref())
        }
        Commands::Export { path, format, output, rag } => {
            run_export(&agent, &path, format, &output, rag)
        }
        Commands::Stats { path } => {
            run_stats(&agent, &path, &metrics)
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
        OutputFormat::Yaml => {
            #[cfg(feature = "sidecar")]
            { serde_yaml::to_string(&analyses)? }
            #[cfg(not(feature = "sidecar"))]
            { "YAML format requires 'sidecar' feature".to_string() }
        }
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
) -> Result<(), Box<dyn std::error::Error>> {
    let analyses = if path.is_file() {
        vec![agent.analyze_file(path)?]
    } else {
        agent.analyze_directory(path)?
    };

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

fn run_export(
    agent: &AgentMap,
    path: &PathBuf,
    format: OutputFormat,
    output: &PathBuf,
    rag: bool,
) -> Result<(), Box<dyn std::error::Error>> {
    let analyses = if path.is_file() {
        vec![agent.analyze_file(path)?]
    } else {
        agent.analyze_directory(path)?
    };

    let output_str = if rag {
        // Export as portable graph format for RAG
        let graphs: Vec<_> = analyses.iter()
            .map(|a| DbKitMiddleware::analysis_to_portable(a))
            .collect();
        serde_json::to_string_pretty(&graphs)?
    } else {
        match format {
            OutputFormat::Json => serde_json::to_string_pretty(&analyses)?,
            OutputFormat::Yaml => {
                #[cfg(feature = "sidecar")]
                { serde_yaml::to_string(&analyses)? }
                #[cfg(not(feature = "sidecar"))]
                { serde_json::to_string_pretty(&analyses)? }
            }
            OutputFormat::Summary => format_summary(&analyses),
        }
    };

    std::fs::write(output, &output_str)?;
    println!("Exported {} files to: {}", analyses.len(), output.display());

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
