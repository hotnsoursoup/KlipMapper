//! Types for the file watching system.

use std::path::PathBuf;
use std::time::Duration;

/// Configuration for the file watcher.
#[derive(Debug, Clone)]
pub struct WatchConfig {
    /// Watch directories recursively.
    pub recursive: bool,
    /// Debounce time in milliseconds.
    pub debounce_ms: u64,
    /// Patterns to ignore (glob-style).
    pub ignore_patterns: Vec<String>,
    /// File extensions to watch (empty = all supported).
    pub extensions: Vec<String>,
    /// Show progress output.
    pub show_progress: bool,
    /// Show verbose output.
    pub verbose: bool,
    /// Run initial scan on start.
    pub initial_scan: bool,
}

impl WatchConfig {
    /// Create a new default config.
    pub fn new() -> Self {
        Self::default()
    }

    /// Set recursive mode.
    pub fn with_recursive(mut self, recursive: bool) -> Self {
        self.recursive = recursive;
        self
    }

    /// Set debounce duration.
    pub fn with_debounce(mut self, duration: Duration) -> Self {
        self.debounce_ms = duration.as_millis() as u64;
        self
    }

    /// Set debounce time in milliseconds.
    pub fn with_debounce_ms(mut self, ms: u64) -> Self {
        self.debounce_ms = ms;
        self
    }

    /// Add an ignore pattern.
    pub fn add_ignore(mut self, pattern: impl Into<String>) -> Self {
        self.ignore_patterns.push(pattern.into());
        self
    }

    /// Set ignore patterns.
    pub fn with_ignores(mut self, patterns: Vec<String>) -> Self {
        self.ignore_patterns = patterns;
        self
    }

    /// Add a file extension to watch.
    pub fn add_extension(mut self, ext: impl Into<String>) -> Self {
        self.extensions.push(ext.into());
        self
    }

    /// Set extensions to watch.
    pub fn with_extensions(mut self, extensions: Vec<String>) -> Self {
        self.extensions = extensions;
        self
    }

    /// Enable/disable progress output.
    pub fn with_progress(mut self, show: bool) -> Self {
        self.show_progress = show;
        self
    }

    /// Enable/disable verbose output.
    pub fn with_verbose(mut self, verbose: bool) -> Self {
        self.verbose = verbose;
        self
    }

    /// Enable/disable initial scan.
    pub fn with_initial_scan(mut self, scan: bool) -> Self {
        self.initial_scan = scan;
        self
    }

    /// Get debounce as Duration.
    pub fn debounce_duration(&self) -> Duration {
        Duration::from_millis(self.debounce_ms)
    }
}

impl Default for WatchConfig {
    fn default() -> Self {
        Self {
            recursive: true,
            debounce_ms: 300,
            ignore_patterns: vec![
                "node_modules".to_string(),
                "target".to_string(),
                ".git".to_string(),
                "vendor".to_string(),
                "__pycache__".to_string(),
                ".venv".to_string(),
                "build".to_string(),
                "dist".to_string(),
            ],
            extensions: Vec::new(), // Empty = all supported
            show_progress: true,
            verbose: false,
            initial_scan: true,
        }
    }
}

/// Kind of file watch event.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum WatchEventKind {
    /// File was created.
    Created,
    /// File was modified.
    Modified,
    /// File was removed.
    Removed,
    /// File was renamed.
    Renamed,
    /// Other event (metadata change, etc.).
    Other,
}

impl WatchEventKind {
    /// Check if this is a change event (created or modified).
    pub fn is_change(&self) -> bool {
        matches!(self, Self::Created | Self::Modified | Self::Renamed)
    }

    /// Check if this is a remove event.
    pub fn is_remove(&self) -> bool {
        matches!(self, Self::Removed)
    }

    /// Get an emoji representation.
    pub fn emoji(&self) -> &'static str {
        match self {
            Self::Created => "\u{2795}", // +
            Self::Modified => "\u{270F}\u{FE0F}", // pencil
            Self::Removed => "\u{2796}", // -
            Self::Renamed => "\u{1F4E6}", // package
            Self::Other => "\u{2139}\u{FE0F}", // info
        }
    }
}

impl std::fmt::Display for WatchEventKind {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Self::Created => write!(f, "created"),
            Self::Modified => write!(f, "modified"),
            Self::Removed => write!(f, "removed"),
            Self::Renamed => write!(f, "renamed"),
            Self::Other => write!(f, "other"),
        }
    }
}

/// A file watch event.
#[derive(Debug, Clone)]
pub struct WatchEvent {
    /// Kind of event.
    pub kind: WatchEventKind,
    /// Affected file paths.
    pub paths: Vec<PathBuf>,
}

impl WatchEvent {
    /// Create a new watch event.
    pub fn new(kind: WatchEventKind, paths: Vec<PathBuf>) -> Self {
        Self { kind, paths }
    }

    /// Create a created event.
    pub fn created(path: PathBuf) -> Self {
        Self::new(WatchEventKind::Created, vec![path])
    }

    /// Create a modified event.
    pub fn modified(path: PathBuf) -> Self {
        Self::new(WatchEventKind::Modified, vec![path])
    }

    /// Create a removed event.
    pub fn removed(path: PathBuf) -> Self {
        Self::new(WatchEventKind::Removed, vec![path])
    }

    /// Check if this is a change event.
    pub fn is_change(&self) -> bool {
        self.kind.is_change()
    }

    /// Check if this is a remove event.
    pub fn is_remove(&self) -> bool {
        self.kind.is_remove()
    }

    /// Get the first path (if any).
    pub fn first_path(&self) -> Option<&PathBuf> {
        self.paths.first()
    }

    /// Get a summary of affected files.
    pub fn summary(&self) -> String {
        if self.paths.is_empty() {
            return "no files".to_string();
        }

        let names: Vec<_> = self.paths
            .iter()
            .filter_map(|p| p.file_name())
            .filter_map(|n| n.to_str())
            .collect();

        if names.len() == 1 {
            names[0].to_string()
        } else if names.len() <= 3 {
            names.join(", ")
        } else {
            format!("{} and {} more", names[..2].join(", "), names.len() - 2)
        }
    }
}

/// Callback type for watch events.
pub type WatchCallback = Box<dyn Fn(WatchEvent) -> bool + Send + Sync>;

/// Statistics for a watch session.
#[derive(Debug, Clone, Default)]
pub struct WatchStats {
    /// Number of files changed.
    pub files_changed: usize,
    /// Number of files added.
    pub files_added: usize,
    /// Number of files removed.
    pub files_removed: usize,
    /// Number of scans performed.
    pub scans_performed: usize,
    /// Total scan duration in milliseconds.
    pub total_scan_ms: u64,
}

impl WatchStats {
    /// Create new stats.
    pub fn new() -> Self {
        Self::default()
    }

    /// Record a file event.
    pub fn record_event(&mut self, kind: WatchEventKind, count: usize) {
        match kind {
            WatchEventKind::Created => self.files_added += count,
            WatchEventKind::Modified => self.files_changed += count,
            WatchEventKind::Removed => self.files_removed += count,
            WatchEventKind::Renamed => self.files_changed += count,
            WatchEventKind::Other => {}
        }
    }

    /// Record a scan.
    pub fn record_scan(&mut self, duration_ms: u64) {
        self.scans_performed += 1;
        self.total_scan_ms += duration_ms;
    }

    /// Get average scan time.
    pub fn avg_scan_ms(&self) -> f64 {
        if self.scans_performed == 0 {
            0.0
        } else {
            self.total_scan_ms as f64 / self.scans_performed as f64
        }
    }

    /// Get total events.
    pub fn total_events(&self) -> usize {
        self.files_changed + self.files_added + self.files_removed
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_watch_config_builder() {
        let config = WatchConfig::new()
            .with_recursive(false)
            .with_debounce_ms(500)
            .with_verbose(true);

        assert!(!config.recursive);
        assert_eq!(config.debounce_ms, 500);
        assert!(config.verbose);
    }

    #[test]
    fn test_watch_event_kind() {
        assert!(WatchEventKind::Created.is_change());
        assert!(WatchEventKind::Modified.is_change());
        assert!(WatchEventKind::Renamed.is_change());
        assert!(!WatchEventKind::Removed.is_change());
        assert!(WatchEventKind::Removed.is_remove());
    }

    #[test]
    fn test_watch_event_summary() {
        let event = WatchEvent::new(
            WatchEventKind::Modified,
            vec![
                PathBuf::from("src/main.rs"),
                PathBuf::from("src/lib.rs"),
            ],
        );

        let summary = event.summary();
        assert!(summary.contains("main.rs"));
        assert!(summary.contains("lib.rs"));
    }

    #[test]
    fn test_watch_event_summary_many() {
        let event = WatchEvent::new(
            WatchEventKind::Modified,
            vec![
                PathBuf::from("a.rs"),
                PathBuf::from("b.rs"),
                PathBuf::from("c.rs"),
                PathBuf::from("d.rs"),
            ],
        );

        let summary = event.summary();
        assert!(summary.contains("more"));
    }

    #[test]
    fn test_watch_stats() {
        let mut stats = WatchStats::new();

        stats.record_event(WatchEventKind::Created, 2);
        stats.record_event(WatchEventKind::Modified, 5);
        stats.record_event(WatchEventKind::Removed, 1);
        stats.record_scan(100);
        stats.record_scan(200);

        assert_eq!(stats.files_added, 2);
        assert_eq!(stats.files_changed, 5);
        assert_eq!(stats.files_removed, 1);
        assert_eq!(stats.total_events(), 8);
        assert_eq!(stats.scans_performed, 2);
        assert_eq!(stats.avg_scan_ms(), 150.0);
    }
}
