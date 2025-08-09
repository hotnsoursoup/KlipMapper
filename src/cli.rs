use clap::{Parser, Subcommand};
use std::path::PathBuf;
use crate::fs_scan::scan_paths;
use crate::adapters::registry;

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
    },
    /// Validate sidecars; non-zero on mismatch (todo).
    Check { path: Vec<PathBuf> },
}

pub fn run() -> anyhow::Result<()> {
    let app = App::parse();
    let adapters = registry::all()?;
    match app.cmd {
        Cmd::Scan { path, no_write } => {
            let edited = scan_paths(path, &adapters, !no_write)?;
            if edited > 0 {
                // fail once (autofix pattern)
                std::process::exit(1);
            }
        }
        Cmd::Check { path } => {
            // MVP: reuse scan with no writes for now
            let _ = scan_paths(path, &adapters, false)?;
        }
    }
    Ok(())
}
