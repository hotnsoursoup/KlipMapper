use clap::{Parser, Subcommand, ValueEnum};
use std::path::PathBuf;
use std::io::Write;
use anyhow::Context;
use crate::fs_scan::scan_paths;
use crate::adapters::registry;
use crate::checker::{check_paths, CheckResult};
use crate::watcher::FileWatcher;
use crate::symbol_table::ProjectSymbolTable;
use crate::config::AgentMapConfig;
use crate::architecture_exporter::{ArchitectureExporter, DetailLevel};
use crate::export_formats::{ArchitectureFormatter, ExportFormat};

#[derive(Parser)]
#[command(name = "agentmap")]
pub struct App {
    #[command(subcommand)]
    cmd: Cmd,
}

#[derive(Subcommand)]
enum Cmd {
    /// Parse files and write sidecars. Exit 1 if edited.
    Scan {
        path: Vec<PathBuf>,
        #[arg(long)]
        no_write: bool,
        #[arg(long, short)]
        json: bool,
    },
    /// Validate sidecars are up-to-date; exit 1 if issues found.
    Check { 
        path: Vec<PathBuf>,
        #[arg(long, short)]
        json: bool,
    },
    /// Watch files for changes and auto-update sidecars.
    Watch {
        path: Vec<PathBuf>,
    },
    /// Query symbols across the project.
    Query {
        #[arg(long)]
        symbol: Option<String>,
        #[arg(long)]
        pattern: Option<String>,
        #[arg(long)]
        file: Option<PathBuf>,
        #[arg(long)]
        format: Option<String>,
        path: Vec<PathBuf>,
    },
    /// Export project architecture in various formats.
    Export {
        /// Path to export (defaults to current directory)
        path: Option<PathBuf>,
        /// Output format
        #[arg(long, value_enum, default_value = "json")]
        format: CliExportFormat,
        /// Level of detail to include
        #[arg(long, value_enum, default_value = "standard")]
        detail: CliDetailLevel,
        /// Output file (defaults to stdout)
        #[arg(long, short)]
        output: Option<PathBuf>,
        /// Maximum folder depth to traverse
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
    },
}

#[derive(Clone, Copy, Debug, ValueEnum)]
enum CliExportFormat {
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
}

impl From<CliExportFormat> for ExportFormat {
    fn from(format: CliExportFormat) -> Self {
        match format {
            CliExportFormat::Json => ExportFormat::Json,
            CliExportFormat::JsonCompact => ExportFormat::JsonCompact,
            CliExportFormat::Yaml => ExportFormat::Yaml,
            CliExportFormat::Graphml => ExportFormat::GraphML,
            CliExportFormat::Dot => ExportFormat::Dot,
            CliExportFormat::Mermaid => ExportFormat::Mermaid,
            CliExportFormat::Csv => ExportFormat::Csv,
            CliExportFormat::Html => ExportFormat::Html,
            CliExportFormat::Markdown => ExportFormat::Markdown,
            CliExportFormat::Plantuml => ExportFormat::PlantUml,
            CliExportFormat::D2 => ExportFormat::D2,
            CliExportFormat::Cypher => ExportFormat::Cypher,
        }
    }
}

#[derive(Clone, Copy, Debug, ValueEnum)]
enum CliDetailLevel {
    Minimal,
    Basic,
    Standard,
    Detailed,
    Complete,
}

impl From<CliDetailLevel> for DetailLevel {
    fn from(level: CliDetailLevel) -> Self {
        match level {
            CliDetailLevel::Minimal => DetailLevel::Minimal,
            CliDetailLevel::Basic => DetailLevel::Basic,
            CliDetailLevel::Standard => DetailLevel::Standard,
            CliDetailLevel::Detailed => DetailLevel::Detailed,
            CliDetailLevel::Complete => DetailLevel::Complete,
        }
    }
}

pub fn run() -> anyhow::Result<()> {
    let app = App::parse();
    println!("DEBUG: Parsed CLI args");
    let adapters = registry::all().context("Failed to initialize adapters")?;
    println!("DEBUG: Loaded {} adapters", adapters.len());
    match app.cmd {
        Cmd::Scan { path, no_write, json } => {
            println!("DEBUG: Starting scan with paths: {:?}, write: {}", path, !no_write);
            let edited = scan_paths(path, &adapters, !no_write).context("Failed to scan paths")?;
            if edited > 0 {
                // fail once (autofix pattern)
                std::process::exit(1);
            }
        }
        Cmd::Check { path, json } => {
            let summary = check_paths(path, &adapters)?;
            
            // Print summary
            println!("Check Results:");
            println!("  ✅ Valid: {}", summary.valid);
            if summary.missing > 0 {
                println!("  ❌ Missing: {}", summary.missing);
            }
            if summary.outdated > 0 {
                println!("  ⚠️  Outdated: {}", summary.outdated);
            }
            if summary.invalid > 0 {
                println!("  💥 Invalid: {}", summary.invalid);
            }
            
            // Print details for issues
            if summary.has_issues() {
                println!("\nIssues found:");
                for (path, result, message) in &summary.details {
                    match result {
                        CheckResult::Valid => continue,
                        CheckResult::Missing => println!("  ❌ {}: {}", path.display(), message.as_deref().unwrap_or("Missing sidecar")),
                        CheckResult::Outdated => println!("  ⚠️  {}: {}", path.display(), message.as_deref().unwrap_or("Outdated")),
                        CheckResult::Invalid => println!("  💥 {}: {}", path.display(), message.as_deref().unwrap_or("Invalid")),
                    }
                }
                std::process::exit(summary.exit_code());
            } else {
                println!("\n🎉 All sidecars are valid and up-to-date!");
            }
        }
        Cmd::Watch { path } => {
            let watcher = FileWatcher::new(path, adapters);
            watcher.start_watching()?;
        }
        Cmd::Query { symbol, pattern, file, format, path } => {
            let config = AgentMapConfig::load_from_dir(&std::env::current_dir()?)?;
            
            // Load or build symbol table
            let symbol_table = load_symbol_table(&path, &adapters, &config)?;
            
            if let Some(symbol_name) = symbol {
                let cross_refs = symbol_table.get_cross_references(&symbol_name);
                
                match format.as_deref() {
                    Some("json") => {
                        println!("{}", serde_json::to_string_pretty(&cross_refs)?);
                    }
                    Some("lines") => {
                        for usage in &cross_refs.usages {
                            println!("{}:{}", usage.file.display(), usage.line);
                        }
                    }
                    _ => {
                        println!("Symbol: {}", cross_refs.symbol);
                        println!("Definitions: {}", cross_refs.definitions.len());
                        println!("Usages: {} across {} files", cross_refs.total_refs, cross_refs.files_count);
                        
                        for def in &cross_refs.definitions {
                            println!("  def: {}:{}:{} ({})", def.file.display(), def.line, def.end_line, def.kind);
                        }
                        
                        for usage in &cross_refs.usages {
                            println!("  use: {}:{} ({})", usage.file.display(), usage.line, usage.context.usage_type);
                        }
                    }
                }
            } else if let Some(search_pattern) = pattern {
                let matches = symbol_table.query_symbols_by_pattern(&search_pattern);
                println!("Symbols matching '{}':", search_pattern);
                for symbol in matches {
                    println!("  {}", symbol);
                }
            } else if let Some(file_path) = file {
                let symbols = symbol_table.get_symbols_in_file(&file_path);
                println!("Symbols in {}:", file_path.display());
                for symbol in symbols {
                    println!("  {}:{} {} ({})", symbol.line, symbol.end_line, symbol.name, symbol.kind);
                }
            } else {
                let stats = symbol_table.get_usage_stats();
                println!("Project Symbol Statistics:");
                println!("  Total symbols: {}", stats.total_symbols);
                println!("  Total definitions: {}", stats.total_definitions);
                println!("  Total usages: {}", stats.total_usages);
                if let Some((name, count)) = stats.most_used_symbol {
                    println!("  Most used: {} ({} usages)", name, count);
                }
            }
        }
        Cmd::Export { path, format, detail, output, max_depth, exclude_tests, include_generated, filter } => {
            let export_path = path.unwrap_or_else(|| std::env::current_dir().unwrap());
            
            // First, we need to scan the project to generate anchor data
            println!("🔍 Scanning project for symbol extraction...");
            let _edited = scan_paths(vec![export_path.clone()], &adapters, true)?;
            
            println!("📊 Analyzing project architecture...");
            
            // Create exporter with options
            let mut exporter = ArchitectureExporter::new(export_path)
                .with_detail_level(detail.into());
            
            if exclude_tests {
                exporter = exporter.exclude_tests();
            }
            if include_generated {
                exporter = exporter.include_generated();
            }
            if let Some(depth) = max_depth {
                exporter = exporter.max_depth(depth);
            }
            for pattern in filter {
                exporter = exporter.add_file_filter(pattern);
            }
            
            // For now, we'll work with empty headers since we need to integrate 
            // the anchor system with the existing sidecar system
            let headers = vec![]; // TODO: Load anchor headers from sidecar files
            
            // Export architecture
            let architecture = exporter.export(&headers)?;
            
            // Write output
            match output {
                Some(output_path) => {
                    let mut file = std::fs::File::create(&output_path)?;
                    ArchitectureFormatter::export(&architecture, format.into(), &mut file)?;
                    println!("✅ Architecture exported to: {}", output_path.display());
                }
                None => {
                    ArchitectureFormatter::export(&architecture, format.into(), &mut std::io::stdout())?;
                }
            }
        }
    }
    Ok(())
}

fn load_symbol_table(
    paths: &[PathBuf], 
    adapters: &[Box<dyn crate::adapters::Adapter>], 
    _config: &AgentMapConfig
) -> anyhow::Result<ProjectSymbolTable> {
    // For now, return a basic symbol table
    // In a real implementation, this would:
    // 1. Check for cached symbol table
    // 2. Build symbol table by parsing files with query packs
    // 3. Resolve cross-references and aliases
    
    let mut symbol_table = ProjectSymbolTable::new();
    
    // Demo data for now
    use crate::symbol_table::{SymbolDefinition, SymbolUsage, UsageContext, EnclosingScope};
    
    symbol_table.add_definition(SymbolDefinition {
        name: "Employee".to_string(),
        kind: "class".to_string(),
        file: PathBuf::from("lib/models/employee.dart"),
        line: 5,
        end_line: 25,
        scope: None,
    });
    
    symbol_table.add_usage(SymbolUsage {
        symbol: "Employee".to_string(),
        file: PathBuf::from("lib/ui/dashboard.dart"),
        line: 134,
        context: UsageContext {
            usage_type: "reference".to_string(),
            enclosing: Some(EnclosingScope {
                scope_type: "method".to_string(),
                name: "buildEmployeeCard".to_string(),
                range: (130, 140),
            }),
        },
    });
    
    Ok(symbol_table)
}
