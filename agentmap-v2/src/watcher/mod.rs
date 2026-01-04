//! File watching system for real-time code analysis.
//!
//! This module provides file system watching capabilities for:
//! - Detecting file changes (create, modify, delete)
//! - Incremental re-analysis on changes
//! - Debouncing rapid changes
//! - Progress reporting with console output
//!
//! # Example
//!
//! ```rust,ignore
//! use agentmap::watcher::{Watcher, WatchConfig};
//!
//! let watcher = Watcher::new(WatchConfig::default())
//!     .add_path("src/")
//!     .add_path("lib/");
//!
//! // Start watching (blocks until Ctrl+C)
//! watcher.watch(|event| {
//!     println!("Changed: {:?}", event.paths);
//!     // Re-run analysis...
//! })?;
//! ```

mod types;
mod handler;

pub use types::{WatchConfig, WatchEvent, WatchEventKind, WatchCallback};
pub use handler::Watcher;

#[cfg(test)]
mod tests {
    use super::*;
    use std::path::PathBuf;
    use std::time::Duration;
    use tempfile::TempDir;
    use std::fs;

    #[test]
    fn test_watch_config_default() {
        let config = WatchConfig::default();
        assert!(config.recursive);
        assert_eq!(config.debounce_ms, 300);
        assert!(config.ignore_patterns.iter().any(|p| p == "node_modules"));
    }

    #[test]
    fn test_watch_config_builder() {
        let config = WatchConfig::new()
            .with_recursive(false)
            .with_debounce(Duration::from_millis(500))
            .add_ignore("*.log")
            .add_extension("rs")
            .add_extension("ts");

        assert!(!config.recursive);
        assert_eq!(config.debounce_ms, 500);
        assert!(config.ignore_patterns.contains(&"*.log".to_string()));
        assert_eq!(config.extensions.len(), 2);
    }

    #[test]
    fn test_watch_event() {
        let event = WatchEvent {
            kind: WatchEventKind::Modified,
            paths: vec![PathBuf::from("src/main.rs")],
        };

        assert!(event.is_change());
        assert!(!event.is_remove());
        assert_eq!(event.paths.len(), 1);
    }

    #[test]
    fn test_watcher_creation() {
        let watcher = Watcher::new(WatchConfig::default());
        assert!(watcher.paths().is_empty());
    }

    #[test]
    fn test_watcher_add_path() {
        let watcher = Watcher::new(WatchConfig::default())
            .add_path("src/")
            .add_path("lib/");

        assert_eq!(watcher.paths().len(), 2);
    }

    #[test]
    fn test_is_supported_file() {
        let config = WatchConfig::new()
            .add_extension("rs")
            .add_extension("ts");

        let watcher = Watcher::new(config);

        // Create temp files
        let temp = TempDir::new().unwrap();
        let rs_file = temp.path().join("test.rs");
        let ts_file = temp.path().join("test.ts");
        let txt_file = temp.path().join("test.txt");

        fs::write(&rs_file, "fn main() {}").unwrap();
        fs::write(&ts_file, "const x = 1;").unwrap();
        fs::write(&txt_file, "hello").unwrap();

        assert!(watcher.is_supported_file(&rs_file));
        assert!(watcher.is_supported_file(&ts_file));
        assert!(!watcher.is_supported_file(&txt_file));
    }

    #[test]
    fn test_is_ignored() {
        let config = WatchConfig::new()
            .add_ignore("node_modules")
            .add_ignore("*.log");

        let watcher = Watcher::new(config);

        assert!(watcher.is_ignored(&PathBuf::from("node_modules/foo.js")));
        assert!(watcher.is_ignored(&PathBuf::from("debug.log")));
        assert!(!watcher.is_ignored(&PathBuf::from("src/main.rs")));
    }

    #[test]
    fn test_watch_event_kind() {
        assert!(WatchEventKind::Created.is_change());
        assert!(WatchEventKind::Modified.is_change());
        assert!(!WatchEventKind::Removed.is_change());
        assert!(WatchEventKind::Removed.is_remove());
    }
}
