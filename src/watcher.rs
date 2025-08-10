use anyhow::Result;
use notify::{Config, Event, EventKind, RecommendedWatcher, RecursiveMode, Watcher};
use std::path::{Path, PathBuf};
use std::sync::mpsc::{channel, Receiver};
use std::time::Duration;
use crate::adapters::Adapter;
use crate::fs_scan::scan_paths;
use console::{style, Emoji};
use indicatif::{ProgressBar, ProgressStyle};

static WATCHING: Emoji<'_, '_> = Emoji("👀 ", "");
static ANALYZING: Emoji<'_, '_> = Emoji("🔍 ", "");
static SUCCESS: Emoji<'_, '_> = Emoji("✅ ", "");
static ERROR: Emoji<'_, '_> = Emoji("❌ ", "");

pub struct FileWatcher {
    paths: Vec<PathBuf>,
    adapters: Vec<Box<dyn Adapter>>,
}

impl FileWatcher {
    pub fn new(paths: Vec<PathBuf>, adapters: Vec<Box<dyn Adapter>>) -> Self {
        Self { paths, adapters }
    }

    pub fn start_watching(&self) -> Result<()> {
        let (tx, rx) = channel();
        let mut watcher = RecommendedWatcher::new(tx, Config::default())?;

        // Watch all specified paths
        for path in &self.paths {
            println!("{} {}Watching {}", WATCHING, style("WATCH").bold().dim(), path.display());
            watcher.watch(path, RecursiveMode::Recursive)?;
        }

        println!("{}Press Ctrl+C to stop watching...\n", style("INFO").blue().bold());

        // Run initial scan
        self.run_scan("Initial scan")?;

        // Handle file events
        loop {
            match rx.recv_timeout(Duration::from_secs(1)) {
                Ok(event) => {
                    if let Ok(event) = event {
                        self.handle_event(event)?;
                    }
                }
                Err(std::sync::mpsc::RecvTimeoutError::Timeout) => {
                    // Continue watching
                }
                Err(std::sync::mpsc::RecvTimeoutError::Disconnected) => {
                    break;
                }
            }
        }

        Ok(())
    }

    fn handle_event(&self, event: Event) -> Result<()> {
        match event.kind {
            EventKind::Create(_) | EventKind::Modify(_) => {
                // Filter for supported file types
                let relevant_files: Vec<_> = event.paths.into_iter()
                    .filter(|path| self.is_supported_file(path))
                    .collect();

                if !relevant_files.is_empty() {
                    let files_str = relevant_files.iter()
                        .map(|p| p.file_name().unwrap_or_default().to_string_lossy())
                        .collect::<Vec<_>>()
                        .join(", ");
                    
                    self.run_scan(&format!("Changed: {}", files_str))?;
                }
            }
            _ => {}
        }
        Ok(())
    }

    fn is_supported_file(&self, path: &Path) -> bool {
        if !path.is_file() {
            return false;
        }
        
        self.adapters.iter().any(|adapter| adapter.supports(path))
    }

    fn run_scan(&self, reason: &str) -> Result<()> {
        let pb = ProgressBar::new_spinner();
        pb.set_style(
            ProgressStyle::default_spinner()
                .tick_strings(&["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"])
                .template("{spinner:.blue} {msg}")
                .unwrap()
        );
        pb.set_message(format!("{} {}", ANALYZING, reason));
        pb.enable_steady_tick(Duration::from_millis(120));

        let start = std::time::Instant::now();
        let result = scan_paths(self.paths.clone(), &self.adapters, true);
        let duration = start.elapsed();

        pb.finish_and_clear();

        match result {
            Ok(changes) => {
                if changes > 0 {
                    println!(
                        "{} {} Updated {} files in {:.2}s",
                        SUCCESS,
                        style("SCAN").green().bold(),
                        style(changes).bold(),
                        duration.as_secs_f64()
                    );
                } else {
                    println!(
                        "{} {} No changes detected ({:.2}s)",
                        SUCCESS,
                        style("SCAN").green().bold(),
                        duration.as_secs_f64()
                    );
                }
            }
            Err(e) => {
                println!(
                    "{} {} Error: {} ({:.2}s)",
                    ERROR,
                    style("SCAN").red().bold(),
                    e,
                    duration.as_secs_f64()
                );
            }
        }

        Ok(())
    }
}