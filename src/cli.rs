use clap::{Parser, Subcommand};
use std::path::PathBuf;
use crate::fs_scan::scan_paths;
use crate::adapters::registry;
use crate::checker::{check_paths, CheckResult};
use crate::watcher::FileWatcher;

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
}

pub fn run() -> anyhow::Result<()> {
    let app = App::parse();
    let adapters = registry::all()?;
    match app.cmd {
        Cmd::Scan { path, no_write, json } => {
            let edited = scan_paths(path, &adapters, !no_write)?;
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
    }
    Ok(())
}
