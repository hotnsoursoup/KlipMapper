//! Daemon integration for continuous code analysis.
//!
//! Connects the file watcher to db-kit for real-time code indexing.
//!
//! # Example
//!
//! ```rust,ignore
//! use agentmap::integrations::{Daemon, DaemonConfig};
//!
//! let daemon = Daemon::new("./my-project", ".agentmap/index.db")
//!     .await?;
//!
//! // Start watching and indexing
//! daemon.start().await?;
//! ```

use std::path::{Path, PathBuf};
use std::sync::Arc;
use anyhow::{Context, Result};

use crate::watcher::{Watcher, WatchConfig, WatchEvent, WatchEventKind};
use crate::parser::{Language, Parser, TreeSitterParser};
use crate::analyzer::{Analyzer, DefaultAnalyzer};
use crate::scanner::{Scanner, ScanConfig};

#[cfg(feature = "db-kit")]
use super::dbkit::{DbKitBridge, BridgeConfig, open_bridge, compute_file_hash};

/// Configuration for the daemon.
#[derive(Debug, Clone)]
pub struct DaemonConfig {
    /// Path to the database file.
    pub db_path: PathBuf,

    /// Project name.
    pub project_name: String,

    /// Root path of the project.
    pub project_root: PathBuf,

    /// Watch configuration.
    pub watch_config: WatchConfig,

    /// Bridge configuration.
    #[cfg(feature = "db-kit")]
    pub bridge_config: BridgeConfig,

    /// Whether to show progress.
    pub show_progress: bool,

    /// Whether to run initial full scan.
    pub initial_scan: bool,
}

impl DaemonConfig {
    /// Create a new daemon configuration.
    pub fn new(project_root: impl Into<PathBuf>, db_path: impl Into<PathBuf>) -> Self {
        let root = project_root.into();
        let project_name = root
            .file_name()
            .and_then(|n| n.to_str())
            .unwrap_or("project")
            .to_string();

        Self {
            db_path: db_path.into(),
            project_name,
            project_root: root,
            watch_config: WatchConfig::default(),
            #[cfg(feature = "db-kit")]
            bridge_config: BridgeConfig::default(),
            show_progress: true,
            initial_scan: true,
        }
    }

    /// Set the project name.
    pub fn with_project_name(mut self, name: impl Into<String>) -> Self {
        self.project_name = name.into();
        self
    }

    /// Set watch configuration.
    pub fn with_watch_config(mut self, config: WatchConfig) -> Self {
        self.watch_config = config;
        self
    }

    /// Enable/disable progress output.
    pub fn with_progress(mut self, show: bool) -> Self {
        self.show_progress = show;
        self
    }

    /// Enable/disable initial scan.
    pub fn with_initial_scan(mut self, scan: bool) -> Self {
        self.initial_scan = scan;
        self
    }
}

/// Daemon for continuous code analysis and indexing.
#[cfg(feature = "db-kit")]
pub struct Daemon {
    config: DaemonConfig,
    bridge: Arc<DbKitBridge>,
    project_id: i64,
    parser: TreeSitterParser,
    analyzer: DefaultAnalyzer,
}

#[cfg(feature = "db-kit")]
impl Daemon {
    /// Create a new daemon with the given configuration.
    pub async fn new(config: DaemonConfig) -> Result<Self> {
        // Open or create the database
        let bridge = open_bridge(config.db_path.to_str().unwrap())
            .await
            .context("Failed to open database")?;

        // Ensure project exists
        let project_id = bridge.ensure_project(
            &config.project_name,
            config.project_root.to_str().unwrap()
        ).await.context("Failed to create project")?;

        let parser = TreeSitterParser::new();
        let analyzer = DefaultAnalyzer::new();

        Ok(Self {
            config,
            bridge: Arc::new(bridge),
            project_id,
            parser,
            analyzer,
        })
    }

    /// Create a daemon with simple path arguments.
    pub async fn simple(project_root: impl Into<PathBuf>, db_path: impl Into<PathBuf>) -> Result<Self> {
        let config = DaemonConfig::new(project_root, db_path);
        Self::new(config).await
    }

    /// Get the project ID.
    pub fn project_id(&self) -> i64 {
        self.project_id
    }

    /// Get the bridge for direct queries.
    pub fn bridge(&self) -> &DbKitBridge {
        &self.bridge
    }

    /// Index a single file.
    pub async fn index_file(&self, path: &Path) -> Result<IndexResult> {
        // Read file content
        let content = std::fs::read_to_string(path)
            .with_context(|| format!("Failed to read: {}", path.display()))?;

        // Detect language
        let language = Language::detect_from_path(path)
            .with_context(|| format!("Unsupported file type: {}", path.display()))?;

        // Parse the file
        let parsed = self.parser.parse(&content, language)
            .context("Failed to parse file")?;

        // Analyze the parsed file
        let analysis = self.analyzer.analyze(&parsed, path)
            .context("Failed to analyze file")?;

        // Compute hash
        let hash = compute_file_hash(&content);

        // Index to database
        let result = self.bridge.index_analysis(&analysis, self.project_id, &hash)
            .await
            .context("Failed to index analysis")?;

        Ok(IndexResult {
            path: path.to_path_buf(),
            symbol_count: result.symbol_count,
            relationship_count: result.relationship_count,
        })
    }

    /// Start the daemon (blocks until stopped).
    pub fn start(&self) -> Result<()> {
        let bridge = Arc::clone(&self.bridge);
        let project_id = self.project_id;
        let config = self.config.clone();
        let parser = TreeSitterParser::new();
        let analyzer = DefaultAnalyzer::new();

        // Create watcher
        let mut watch_config = config.watch_config.clone();
        watch_config.show_progress = config.show_progress;
        watch_config.initial_scan = config.initial_scan;

        let watcher = Watcher::new(watch_config)
            .add_path(&config.project_root);

        // Create the callback
        let callback = move |event: WatchEvent| -> bool {
            // Handle file removals
            if event.kind == WatchEventKind::Removed {
                for path in &event.paths {
                    let path_str = path.to_string_lossy().to_string();
                    let bridge = Arc::clone(&bridge);

                    // Use tokio runtime to run async code
                    let rt = tokio::runtime::Handle::try_current();
                    match rt {
                        Ok(handle) => {
                            let result = handle.block_on(async {
                                bridge.delete_file_by_path(&path_str).await
                            });

                            match result {
                                Ok(deleted) => {
                                    if deleted && config.show_progress {
                                        println!("  Removed: {}", path.display());
                                    }
                                }
                                Err(e) => {
                                    eprintln!("Failed to remove {}: {}", path.display(), e);
                                }
                            }
                        }
                        Err(_) => {
                            eprintln!("No tokio runtime available for async deletion");
                        }
                    }
                }
                return true;
            }

            for path in &event.paths {
                // Skip directories
                if path.is_dir() {
                    continue;
                }

                // Read file content
                let content = match std::fs::read_to_string(path) {
                    Ok(c) => c,
                    Err(e) => {
                        eprintln!("Failed to read {}: {}", path.display(), e);
                        continue;
                    }
                };

                // Detect language
                let language = match Language::detect_from_path(path) {
                    Ok(l) => l,
                    Err(_) => continue, // Skip unsupported files
                };

                // Parse the file
                let parsed = match parser.parse(&content, language) {
                    Ok(p) => p,
                    Err(e) => {
                        eprintln!("Failed to parse {}: {}", path.display(), e);
                        continue;
                    }
                };

                // Analyze the parsed file
                let analysis = match analyzer.analyze(&parsed, path) {
                    Ok(a) => a,
                    Err(e) => {
                        eprintln!("Failed to analyze {}: {}", path.display(), e);
                        continue;
                    }
                };

                // Index (need to block on async)
                let hash = compute_file_hash(&content);
                let bridge = Arc::clone(&bridge);

                // Use tokio runtime to run async code
                let rt = tokio::runtime::Handle::try_current();
                match rt {
                    Ok(handle) => {
                        let result = handle.block_on(async {
                            bridge.index_analysis(&analysis, project_id, &hash).await
                        });

                        match result {
                            Ok(r) => {
                                if config.show_progress {
                                    println!(
                                        "  Indexed: {} ({} symbols, {} relationships, {} imports)",
                                        path.display(),
                                        r.symbol_count,
                                        r.relationship_count,
                                        r.import_count
                                    );
                                }
                            }
                            Err(e) => {
                                eprintln!("Failed to index {}: {}", path.display(), e);
                            }
                        }
                    }
                    Err(_) => {
                        eprintln!("No tokio runtime available for async indexing");
                    }
                }
            }

            true // Continue watching
        };

        // Start watching
        watcher.watch(callback)
    }

    /// Run an initial full scan of the project.
    ///
    /// This scans all files and indexes them to the database.
    /// The Scanner already produces CodeAnalysis objects, so we can
    /// directly index them to db-kit.
    pub async fn full_scan(&self) -> Result<ScanResult> {
        let scan_config = ScanConfig::default();
        let scanner = Scanner::with_config(scan_config);

        // Scan the project root
        let paths = vec![self.config.project_root.clone()];
        let scan_result = scanner.scan(paths)?;

        let mut indexed = 0;
        let mut failed = 0;
        let mut total_symbols = 0;
        let mut total_relationships = 0;
        let total = scan_result.analyses.len();

        // Index each analysis result
        for analysis in &scan_result.analyses {
            // Compute hash from the analysis metadata or file
            let content = std::fs::read_to_string(&analysis.file_path)
                .unwrap_or_default();
            let hash = compute_file_hash(&content);

            match self.bridge.index_analysis(analysis, self.project_id, &hash).await {
                Ok(result) => {
                    indexed += 1;
                    total_symbols += result.symbol_count;
                    total_relationships += result.relationship_count;

                    if self.config.show_progress {
                        println!(
                            "  [{}/{}] {} ({} symbols)",
                            indexed,
                            total,
                            analysis.file_path.display(),
                            result.symbol_count
                        );
                    }
                }
                Err(e) => {
                    failed += 1;
                    if self.config.show_progress {
                        eprintln!("  Failed: {} - {}", analysis.file_path.display(), e);
                    }
                }
            }
        }

        // Also count scanner errors
        failed += scan_result.errors.len();

        Ok(ScanResult {
            indexed,
            failed,
            total_symbols,
            total_relationships,
        })
    }
}

/// Result of indexing a single file.
#[derive(Debug, Clone)]
pub struct IndexResult {
    /// Path that was indexed.
    pub path: PathBuf,
    /// Number of symbols indexed.
    pub symbol_count: usize,
    /// Number of relationships indexed.
    pub relationship_count: usize,
}

/// Result of a full project scan.
#[derive(Debug, Clone)]
pub struct ScanResult {
    /// Number of files successfully indexed.
    pub indexed: usize,
    /// Number of files that failed.
    pub failed: usize,
    /// Total symbols indexed.
    pub total_symbols: usize,
    /// Total relationships indexed.
    pub total_relationships: usize,
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_daemon_config() {
        let config = DaemonConfig::new("./my-project", "./index.db")
            .with_project_name("my-project")
            .with_progress(true);

        assert_eq!(config.project_name, "my-project");
        assert!(config.show_progress);
    }
}
