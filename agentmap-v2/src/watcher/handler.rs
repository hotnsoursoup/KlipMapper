//! File watcher implementation.

use std::collections::HashMap;
use std::path::{Path, PathBuf};
use std::sync::mpsc::{channel, Receiver};
use std::sync::{Arc, Mutex};
use std::time::{Duration, Instant};

use anyhow::{Context, Result};
use console::style;
use indicatif::{ProgressBar, ProgressStyle};
use notify::{Config, Event, EventKind, RecommendedWatcher, RecursiveMode, Watcher as NotifyWatcher};

use crate::parser::Language;

use super::types::{WatchCallback, WatchConfig, WatchEvent, WatchEventKind, WatchStats};

// Emoji constants for output
const WATCHING: &str = "\u{1F440}"; // eyes
#[allow(dead_code)]
const ANALYZING: &str = "\u{1F50D}"; // magnifying glass
const SUCCESS: &str = "\u{2705}"; // check
const ERROR: &str = "\u{274C}"; // x
const INFO: &str = "\u{2139}\u{FE0F}"; // info

/// File watcher for real-time code analysis.
///
/// Watches specified paths for file changes and triggers callbacks
/// when relevant files are modified.
pub struct Watcher {
    /// Paths to watch.
    paths: Vec<PathBuf>,
    /// Watch configuration.
    config: WatchConfig,
    /// Debounce state for each path.
    debounce: Arc<Mutex<HashMap<PathBuf, Instant>>>,
    /// Statistics.
    stats: Arc<Mutex<WatchStats>>,
}

impl Watcher {
    /// Create a new watcher with the given configuration.
    pub fn new(config: WatchConfig) -> Self {
        Self {
            paths: Vec::new(),
            config,
            debounce: Arc::new(Mutex::new(HashMap::new())),
            stats: Arc::new(Mutex::new(WatchStats::new())),
        }
    }

    /// Create with default configuration.
    pub fn default_config() -> Self {
        Self::new(WatchConfig::default())
    }

    /// Add a path to watch.
    pub fn add_path(mut self, path: impl Into<PathBuf>) -> Self {
        self.paths.push(path.into());
        self
    }

    /// Add multiple paths to watch.
    pub fn add_paths(mut self, paths: impl IntoIterator<Item = PathBuf>) -> Self {
        self.paths.extend(paths);
        self
    }

    /// Get the watched paths.
    pub fn paths(&self) -> &[PathBuf] {
        &self.paths
    }

    /// Get the configuration.
    pub fn config(&self) -> &WatchConfig {
        &self.config
    }

    /// Get current statistics.
    pub fn stats(&self) -> WatchStats {
        self.stats.lock().unwrap().clone()
    }

    /// Start watching with a callback.
    ///
    /// This method blocks until the callback returns `false` or an error occurs.
    pub fn watch<F>(&self, callback: F) -> Result<()>
    where
        F: Fn(WatchEvent) -> bool + Send + Sync,
    {
        self.watch_with_stop(callback, None)
    }

    /// Start watching with a callback and optional stop signal.
    ///
    /// If a stop receiver is provided, watching stops when a message is received.
    pub fn watch_with_stop<F>(
        &self,
        callback: F,
        stop_rx: Option<Receiver<()>>,
    ) -> Result<()>
    where
        F: Fn(WatchEvent) -> bool + Send + Sync,
    {
        if self.paths.is_empty() {
            anyhow::bail!("No paths to watch");
        }

        let (tx, rx) = channel();
        let mut watcher = RecommendedWatcher::new(
            tx,
            Config::default().with_poll_interval(Duration::from_secs(1)),
        )
        .context("Failed to create file watcher")?;

        // Watch all paths
        let mode = if self.config.recursive {
            RecursiveMode::Recursive
        } else {
            RecursiveMode::NonRecursive
        };

        for path in &self.paths {
            if self.config.show_progress {
                println!(
                    "{} {} Watching {}",
                    WATCHING,
                    style("WATCH").bold().dim(),
                    path.display()
                );
            }
            watcher
                .watch(path, mode)
                .with_context(|| format!("Failed to watch: {}", path.display()))?;
        }

        if self.config.show_progress {
            println!(
                "{} {} Press Ctrl+C to stop watching...\n",
                INFO,
                style("INFO").blue().bold()
            );
        }

        // Run initial scan if configured
        if self.config.initial_scan {
            let event = WatchEvent::new(WatchEventKind::Other, self.paths.clone());
            if !callback(event) {
                return Ok(());
            }
        }

        // Event loop
        let debounce_duration = self.config.debounce_duration();

        loop {
            // Check stop signal
            if let Some(ref stop) = stop_rx {
                if stop.try_recv().is_ok() {
                    if self.config.show_progress {
                        println!("\n{} {} Stopping watcher...", INFO, style("STOP").yellow().bold());
                    }
                    break;
                }
            }

            // Wait for events
            match rx.recv_timeout(Duration::from_secs(1)) {
                Ok(Ok(event)) => {
                    if let Some(watch_event) = self.process_event(event, debounce_duration) {
                        // Update stats
                        {
                            let mut stats = self.stats.lock().unwrap();
                            stats.record_event(watch_event.kind, watch_event.paths.len());
                        }

                        // Call callback
                        if !callback(watch_event) {
                            break;
                        }
                    }
                }
                Ok(Err(e)) => {
                    if self.config.verbose {
                        eprintln!("{} {} Watch error: {}", ERROR, style("ERROR").red().bold(), e);
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

    /// Process a notify event into a watch event.
    fn process_event(&self, event: Event, debounce: Duration) -> Option<WatchEvent> {
        // Convert event kind
        let kind = match event.kind {
            EventKind::Create(_) => WatchEventKind::Created,
            EventKind::Modify(_) => WatchEventKind::Modified,
            EventKind::Remove(_) => WatchEventKind::Removed,
            EventKind::Access(_) => return None, // Ignore access events
            EventKind::Other => WatchEventKind::Other,
            EventKind::Any => WatchEventKind::Other,
        };

        // Filter relevant paths
        let paths: Vec<PathBuf> = event
            .paths
            .into_iter()
            .filter(|p| !self.is_ignored(p))
            .filter(|p| self.is_supported_file(p))
            .filter(|p| self.check_debounce(p, debounce))
            .collect();

        if paths.is_empty() {
            return None;
        }

        Some(WatchEvent::new(kind, paths))
    }

    /// Check if a path should be ignored.
    pub fn is_ignored(&self, path: &Path) -> bool {
        let path_str = path.to_string_lossy();

        for pattern in &self.config.ignore_patterns {
            // Simple glob-style matching
            if pattern.starts_with("*.") {
                // Extension pattern
                let ext = &pattern[2..];
                if path.extension().map(|e| e == ext).unwrap_or(false) {
                    return true;
                }
            } else if path_str.contains(pattern) {
                return true;
            }
        }

        false
    }

    /// Check if a file is supported for watching.
    pub fn is_supported_file(&self, path: &Path) -> bool {
        // Must be a file (or not exist yet for create events)
        if path.is_dir() {
            return false;
        }

        // Check extension filter
        if !self.config.extensions.is_empty() {
            let ext = path.extension().and_then(|e| e.to_str()).unwrap_or("");
            if !self.config.extensions.iter().any(|e| e == ext) {
                return false;
            }
        }

        // Check if it's a supported language
        if self.config.extensions.is_empty() {
            // If no extension filter, use language detection
            Language::detect_from_path(path).is_ok()
        } else {
            true
        }
    }

    /// Check debounce for a path.
    fn check_debounce(&self, path: &Path, debounce: Duration) -> bool {
        let now = Instant::now();
        let mut debounce_map = self.debounce.lock().unwrap();

        if let Some(last_time) = debounce_map.get(path) {
            if now.duration_since(*last_time) < debounce {
                return false;
            }
        }

        debounce_map.insert(path.to_path_buf(), now);
        true
    }

    /// Create a progress spinner.
    pub fn create_spinner(&self, message: &str) -> Option<ProgressBar> {
        if !self.config.show_progress {
            return None;
        }

        let pb = ProgressBar::new_spinner();
        pb.set_style(
            ProgressStyle::default_spinner()
                .tick_strings(&["\u{28FF}", "\u{28FE}", "\u{28FC}", "\u{28F8}", "\u{28F0}", "\u{28E0}", "\u{28C0}", "\u{2880}", "\u{2800}", "\u{2880}", "\u{28C0}", "\u{28E0}", "\u{28F0}", "\u{28F8}", "\u{28FC}", "\u{28FE}"])
                .template("{spinner:.blue} {msg}")
                .unwrap(),
        );
        pb.set_message(message.to_string());
        pb.enable_steady_tick(Duration::from_millis(80));

        Some(pb)
    }

    /// Print a success message.
    pub fn print_success(&self, message: &str) {
        if self.config.show_progress {
            println!("{} {} {}", SUCCESS, style("OK").green().bold(), message);
        }
    }

    /// Print an error message.
    pub fn print_error(&self, message: &str) {
        if self.config.show_progress {
            println!("{} {} {}", ERROR, style("ERR").red().bold(), message);
        }
    }

    /// Print an info message.
    pub fn print_info(&self, message: &str) {
        if self.config.verbose {
            println!("{} {} {}", INFO, style("INFO").dim(), message);
        }
    }
}

impl Default for Watcher {
    fn default() -> Self {
        Self::default_config()
    }
}

/// Builder for creating a watcher with callback handling.
#[allow(dead_code)]
pub struct WatcherBuilder {
    watcher: Watcher,
    on_change: Option<WatchCallback>,
    on_remove: Option<WatchCallback>,
}

#[allow(dead_code)]
impl WatcherBuilder {
    /// Create a new builder.
    pub fn new() -> Self {
        Self {
            watcher: Watcher::default(),
            on_change: None,
            on_remove: None,
        }
    }

    /// Set the configuration.
    pub fn config(mut self, config: WatchConfig) -> Self {
        self.watcher = Watcher::new(config);
        self
    }

    /// Add a path to watch.
    pub fn path(mut self, path: impl Into<PathBuf>) -> Self {
        self.watcher = self.watcher.add_path(path);
        self
    }

    /// Set the change callback.
    pub fn on_change<F>(mut self, callback: F) -> Self
    where
        F: Fn(WatchEvent) -> bool + Send + Sync + 'static,
    {
        self.on_change = Some(Box::new(callback));
        self
    }

    /// Set the remove callback.
    pub fn on_remove<F>(mut self, callback: F) -> Self
    where
        F: Fn(WatchEvent) -> bool + Send + Sync + 'static,
    {
        self.on_remove = Some(Box::new(callback));
        self
    }

    /// Build and start watching.
    pub fn start(self) -> Result<()> {
        let on_change = self.on_change;
        let on_remove = self.on_remove;

        self.watcher.watch(move |event| {
            if event.is_change() {
                if let Some(ref cb) = on_change {
                    return cb(event);
                }
            } else if event.is_remove() {
                if let Some(ref cb) = on_remove {
                    return cb(event);
                }
            }
            true
        })
    }
}

impl Default for WatcherBuilder {
    fn default() -> Self {
        Self::new()
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use tempfile::TempDir;
    use std::fs;

    #[test]
    fn test_watcher_new() {
        let watcher = Watcher::new(WatchConfig::default());
        assert!(watcher.paths.is_empty());
        assert!(watcher.config.recursive);
    }

    #[test]
    fn test_watcher_add_paths() {
        let watcher = Watcher::default()
            .add_path("src/")
            .add_path("lib/")
            .add_paths(vec![PathBuf::from("tests/")]);

        assert_eq!(watcher.paths.len(), 3);
    }

    #[test]
    fn test_is_ignored_pattern() {
        let config = WatchConfig::new()
            .add_ignore("node_modules")
            .add_ignore("*.log");

        let watcher = Watcher::new(config);

        assert!(watcher.is_ignored(&PathBuf::from("node_modules/package.json")));
        assert!(watcher.is_ignored(&PathBuf::from("debug.log")));
        assert!(!watcher.is_ignored(&PathBuf::from("src/main.rs")));
    }

    #[test]
    fn test_is_supported_with_extensions() {
        let temp = TempDir::new().unwrap();

        let rs_file = temp.path().join("test.rs");
        let py_file = temp.path().join("test.py");
        let txt_file = temp.path().join("test.txt");

        fs::write(&rs_file, "fn main() {}").unwrap();
        fs::write(&py_file, "print('hello')").unwrap();
        fs::write(&txt_file, "hello").unwrap();

        let config = WatchConfig::new()
            .add_extension("rs")
            .add_extension("py");

        let watcher = Watcher::new(config);

        assert!(watcher.is_supported_file(&rs_file));
        assert!(watcher.is_supported_file(&py_file));
        assert!(!watcher.is_supported_file(&txt_file));
    }

    #[test]
    fn test_debounce() {
        let watcher = Watcher::new(WatchConfig::new().with_debounce_ms(100));
        let path = PathBuf::from("test.rs");

        // First call should pass
        assert!(watcher.check_debounce(&path, Duration::from_millis(100)));

        // Immediate second call should be debounced
        assert!(!watcher.check_debounce(&path, Duration::from_millis(100)));

        // After waiting, should pass again
        std::thread::sleep(Duration::from_millis(150));
        assert!(watcher.check_debounce(&path, Duration::from_millis(100)));
    }

    #[test]
    fn test_watcher_builder() {
        let builder = WatcherBuilder::new()
            .config(WatchConfig::new().with_verbose(true))
            .path("src/");

        assert_eq!(builder.watcher.paths.len(), 1);
        assert!(builder.watcher.config.verbose);
    }

    #[test]
    fn test_process_event_filters() {
        let config = WatchConfig::new()
            .add_ignore("node_modules")
            .add_extension("rs");

        let watcher = Watcher::new(config);

        // Create a temp file for testing
        let temp = TempDir::new().unwrap();
        let rs_file = temp.path().join("test.rs");
        fs::write(&rs_file, "fn main() {}").unwrap();

        // Create a notify event
        let notify_event = Event {
            kind: EventKind::Modify(notify::event::ModifyKind::Data(notify::event::DataChange::Any)),
            paths: vec![rs_file.clone()],
            attrs: Default::default(),
        };

        let watch_event = watcher.process_event(notify_event, Duration::from_millis(0));

        assert!(watch_event.is_some());
        let event = watch_event.unwrap();
        assert_eq!(event.kind, WatchEventKind::Modified);
        assert_eq!(event.paths.len(), 1);
    }
}
