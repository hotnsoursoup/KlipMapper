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
    /// Embed compressed anchor headers directly in source files.
    Embed {
        /// Paths to process
        path: Vec<PathBuf>,
        /// Preview changes without modifying files
        #[arg(long)]
        dry_run: bool,
        /// Force overwrite existing anchors
        #[arg(long)]
        force: bool,
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
        Cmd::Embed { path, dry_run, force } => {
            println!("🔗 Embedding compressed anchor headers in source files...");
            
            // Process files to embed anchors
            let embedded = embed_anchor_headers(path, &adapters, !dry_run, force)?;
            
            if dry_run {
                println!("🔍 Dry run complete: {} files would be modified", embedded);
            } else {
                println!("✅ Successfully embedded anchors in {} files", embedded);
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

fn embed_anchor_headers(
    paths: Vec<PathBuf>,
    adapters: &[Box<dyn crate::adapters::Adapter>],
    write: bool,
    force: bool,
) -> anyhow::Result<usize> {
    use crate::anchor::{AnchorHeaderBuilder, AnchorCompressor};
    use crate::symbol_resolver::SymbolResolver;
    use ignore::WalkBuilder;
    use std::fs;
    
    println!("DEBUG: embed_anchor_headers called with {} paths, write: {}, force: {}", 
             paths.len(), write, force);
    
    // Collect all files to process
    let files: Vec<PathBuf> = paths
        .into_iter()
        .flat_map(|p| {
            if p.is_dir() {
                let walker_files: Vec<PathBuf> = WalkBuilder::new(&p)
                    .standard_filters(true)
                    .build()
                    .filter_map(|e| e.ok())
                    .filter(|e| e
                        .file_type()
                        .map(|t| t.is_file())
                        .unwrap_or(false))
                    .map(|e| e.into_path())
                    // Only process source files that adapters support
                    .filter(|path| adapters.iter().any(|adapter| adapter.supports(path)))
                    .collect();
                println!("DEBUG: Found {} supported files in directory {}", walker_files.len(), p.display());
                walker_files
            } else {
                vec![p]
            }
        })
        .collect();

    println!("DEBUG: Total files to process: {}", files.len());
    
    if files.is_empty() {
        anyhow::bail!("No supported files found to embed anchors");
    }

    let mut modified_count = 0;

    for file_path in files {
        println!("DEBUG: Processing {}", file_path.display());
        
        // Read current file content
        let content = match fs::read_to_string(&file_path) {
            Ok(content) => content,
            Err(e) => {
                eprintln!("WARN: Failed to read file {}: {}", file_path.display(), e);
                continue;
            }
        };

        // Check if file already has anchors and handle force flag
        if content.contains("agentmap:1") && !force {
            println!("DEBUG: File {} already has anchors, skipping (use --force to overwrite)", file_path.display());
            continue;
        }

        // Find matching adapter
        let adapter = adapters.iter().find(|a| a.supports(&file_path));
        let adapter = match adapter {
            Some(a) => a,
            None => {
                println!("DEBUG: No adapter found for {}", file_path.display());
                continue;
            }
        };

        println!("DEBUG: Using adapter {} for {}", adapter.name(), file_path.display());

        // HYBRID APPROACH: Use working TsAdapter + enhance with our advanced features
        
        // Step 1: Get working symbol extraction from TsAdapter
        let ctx = crate::adapters::FileCtx { 
            path: &file_path, 
            text: &content 
        };
        
        let basic_analysis = match adapter.analyze(&ctx) {
            Ok(analysis) => analysis,
            Err(e) => {
                eprintln!("WARN: TsAdapter analysis failed for {}: {}", file_path.display(), e);
                continue;
            }
        };

        println!("DEBUG: TsAdapter extracted {} symbols, {} imports, {} calls", 
                 basic_analysis.symbols.len(), 
                 basic_analysis.imports.len(), 
                 basic_analysis.calls.len());

        // Step 2: Filter and convert only important symbols to enhanced format
        let symbols = convert_to_enhanced_symbols(&basic_analysis, &file_path, &content);

        println!("DEBUG: Extracted {} symbols from {}", symbols.len(), file_path.display());

        // Build anchor header
        let mut builder = AnchorHeaderBuilder::new(
            file_path.clone(),
            file_path.extension()
                .and_then(|ext| ext.to_str())
                .unwrap_or("unknown")
                .to_string(),
            content.clone(),
        );

        for symbol in symbols {
            builder = builder.add_symbol(symbol);
        }

        let header = builder.build();

        // Compress header for embedding
        let compressed = match AnchorCompressor::compress_header(&header) {
            Ok(compressed) => compressed,
            Err(e) => {
                eprintln!("WARN: Failed to compress header for {}: {}", file_path.display(), e);
                continue;
            }
        };

        // Generate comment lines for the language
        let header_comments = AnchorCompressor::format_header_comments(
            &compressed,
            file_path.extension()
                .and_then(|ext| ext.to_str())
                .unwrap_or("unknown")
        );

        // Embed comments at the beginning of the file (after any existing file header comments)
        let mut new_content = String::new();
        let lines: Vec<&str> = content.lines().collect();
        let mut insert_at = 0;

        // Skip any existing file header comments to insert after them
        for (i, line) in lines.iter().enumerate() {
            if line.trim().starts_with("//") || line.trim().starts_with("#") {
                insert_at = i + 1;
            } else if line.trim().is_empty() {
                // Allow empty lines in header area
                continue;
            } else {
                break;
            }
        }

        // Add original content up to insertion point
        for line in lines.iter().take(insert_at) {
            new_content.push_str(line);
            new_content.push('\n');
        }

        // Add anchor header comments
        new_content.push('\n');
        for comment in header_comments {
            new_content.push_str(&comment);
            new_content.push('\n');
        }
        new_content.push('\n');

        // Add remaining content
        for line in lines.iter().skip(insert_at) {
            new_content.push_str(line);
            new_content.push('\n');
        }

        // Write the modified content if requested
        if write {
            match fs::write(&file_path, &new_content) {
                Ok(_) => {
                    println!("DEBUG: Embedded anchor header in {}", file_path.display());
                    modified_count += 1;
                }
                Err(e) => {
                    eprintln!("WARN: Failed to write modified file {}: {}", file_path.display(), e);
                }
            }
        } else {
            println!("DEBUG: Would embed anchor header in {} ({} bytes)", 
                     file_path.display(), new_content.len());
            modified_count += 1;
        }
    }

    Ok(modified_count)
}

fn convert_to_enhanced_symbols(
    basic_analysis: &crate::adapters::Analysis,
    file_path: &PathBuf,
    content: &str,
) -> Vec<crate::anchor::Symbol> {
    use crate::anchor::{Symbol, SourceRange, ScopeFrame, SymbolReference, SymbolEdge, GuardInfo};
    use crate::symbol_resolver::SymbolResolver;
    
    let mut enhanced_symbols = Vec::new();
    
    // Debug: Show first 10 symbol types to understand what TsAdapter produces
    println!("DEBUG: First 10 symbol types from TsAdapter:");
    for (i, symbol) in basic_analysis.symbols.iter().take(10).enumerate() {
        println!("  {}: {} ({})", i, symbol.kind, symbol.name);
    }

    // Filter for only important symbols using smart analysis
    let important_symbols: Vec<_> = basic_analysis.symbols.iter()
        .filter(|symbol| is_important_symbol_smart(symbol))
        .collect();

    println!("DEBUG: Filtered {} important symbols from {} total", important_symbols.len(), basic_analysis.symbols.len());

    // Convert filtered symbols to enhanced format
    for (i, basic_symbol) in important_symbols.iter().enumerate() {
        // Generate unique ID for this symbol
        let symbol_id = format!("s{}", i + 1);
        
        // Create enhanced source range with both line and byte positions
        let range = SourceRange {
            lines: [basic_symbol.range.0, basic_symbol.range.1],
            bytes: [
                byte_offset_for_line(content, basic_symbol.range.0 as usize),
                byte_offset_for_line(content, basic_symbol.range.1 as usize),
            ],
        };
        
        // Build scope frames - for now, create basic file-level frame
        // TODO: Enhanced resolver will build proper nested scope hierarchy
        let frames = vec![ScopeFrame {
            kind: "file".to_string(),
            name: Some(file_path.file_name()
                .and_then(|n| n.to_str())
                .unwrap_or("unknown")
                .to_string()),
            range: SourceRange {
                lines: [1, content.lines().count() as u32],
                bytes: [0, content.len() as u32],
            },
        }];
        
        // Build symbol references from imports
        let mut references = Vec::new();
        for import in &basic_analysis.imports {
            references.push(SymbolReference {
                ref_type: "import".to_string(),
                target: import.name.clone(),
                at_line: 1, // TODO: Get actual import line from AST
            });
        }
        
        // Build symbol edges from call graph
        let mut edges = Vec::new();
        for call in &basic_analysis.calls {
            if call.caller == basic_symbol.name {
                edges.push(SymbolEdge {
                    edge_type: "calls".to_string(),
                    target: call.target.clone(),
                    at_line: call.line,
                });
            }
        }
        
        // Create content fingerprint
        let fingerprint = crate::anchor::AnchorCompressor::hash_content(&format!("{}:{}", basic_symbol.name, basic_symbol.kind));
        
        // Determine roles based on symbol kind
        let roles = match basic_symbol.kind.as_str() {
            "function" | "method" => vec!["executable".to_string()],
            "class" | "interface" => vec!["entity".to_string()],
            "variable" | "field" => vec!["data".to_string()],
            _ => vec!["symbol".to_string()],
        };
        
        // Create enhanced symbol
        let enhanced_symbol = Symbol {
            id: symbol_id,
            kind: basic_symbol.kind.clone(),
            name: basic_symbol.name.clone(),
            owner: None, // TODO: Enhanced resolver will track ownership relationships
            range,
            frames,
            roles,
            references,
            edges,
            fingerprint,
            guard: None, // TODO: Enhanced resolver will analyze effects
        };
        
        enhanced_symbols.push(enhanced_symbol);
    }
    
    println!("DEBUG: Converted {} basic symbols to enhanced format", enhanced_symbols.len());
    enhanced_symbols
}

fn byte_offset_for_line(content: &str, line_num: usize) -> u32 {
    if line_num == 0 {
        return 0;
    }
    
    let mut byte_offset = 0;
    let mut current_line = 1;
    
    for byte in content.bytes() {
        if current_line >= line_num {
            break;
        }
        if byte == b'\n' {
            current_line += 1;
        }
        byte_offset += 1;
    }
    
    byte_offset
}

/// Determines if a symbol is important enough to include in anchor headers
/// We only want significant symbols that are useful for code analysis
/// Since TsAdapter labels everything as "function", we need smarter filtering
fn is_important_symbol(symbol_kind: &str) -> bool {
    match symbol_kind {
        // Always include classes, interfaces, enums - these are key types
        "class" | "interface" | "enum" | "struct" | "trait" => true,
        
        // Include functions and methods - these are callable units
        "function" | "method" | "constructor" | "getter" | "setter" => true,
        
        // Include important variable types
        "field" | "property" | "constant" => true,
        
        // Include imports - these show dependencies
        "import" => true,
        
        // Include type definitions
        "typedef" | "type_alias" => true,
        
        // Skip noise: variables, expressions, statements, etc.
        "variable" | "parameter" | "local" | "expression" | 
        "statement" | "block" | "literal" | "identifier" |
        "argument" | "assignment" | "call" | "access" |
        "return_statement" | "if_statement" | "for_statement" |
        "while_statement" | "switch_statement" | "case" |
        "binary_expression" | "unary_expression" => false,
        
        // Default: include unknown types to be safe, but log them
        _ => {
            println!("DEBUG: Unknown symbol type '{}' - including by default", symbol_kind);
            true
        }
    }
}

/// Smart filtering for TsAdapter symbols which often mislabels everything as "function"
/// We need to look at the symbol name patterns to determine what's actually important
fn is_important_symbol_smart(symbol: &crate::sidecar::Symbol) -> bool {
    // First check the basic type
    let basic_important = is_important_symbol(&symbol.kind);
    
    // If it's not a generic "function", trust the basic filter
    if symbol.kind != "function" {
        return basic_important;
    }
    
    // For "function" symbols, analyze the name to determine real importance
    let name = &symbol.name;
    
    // Skip very short names - likely not important declarations
    if name.len() <= 3 {
        return false;
    }
    
    // Skip common patterns that are noise
    if matches!(name.as_str(), 
        "null" | "true" | "false" | "this" | "super" | "new" |
        "get" | "set" | "return" | "if" | "else" | "for" | "while" |
        "int" | "String" | "bool" | "double" | "var" | "final" | "const" |
        "void" | "async" | "await" | "class" | "enum" | "typedef" |
        "static" | "public" | "private" | "protected" | "override"
    ) {
        return false;
    }
    
    // Skip single lowercase words without underscores (likely variables/parameters)
    if name.chars().all(|c| c.is_lowercase() || c == '_') && !name.contains('_') {
        return false;
    }
    
    // Skip single letters and very common variable patterns
    if name.len() == 1 || matches!(name.as_str(), "i" | "j" | "k" | "x" | "y" | "z" | "e" | "ex") {
        return false;
    }
    
    // Include PascalCase names (likely classes/types)
    if name.chars().next().unwrap_or('a').is_uppercase() {
        return true;
    }
    
    // Include camelCase names that look like methods/functions
    if name.contains(char::is_uppercase) || name.len() > 6 {
        return true;
    }
    
    // Default: skip this symbol
    false
}
