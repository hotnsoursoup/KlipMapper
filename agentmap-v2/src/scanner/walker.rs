//! Directory walker with parallel processing and gitignore support.

use std::path::{Path, PathBuf};
use std::sync::Arc;
use ignore::WalkBuilder;
use rayon::prelude::*;
use parking_lot::Mutex;

use crate::core::{CodeAnalysis, Error, Result};
use crate::parser::{Language, Parser, TreeSitterParser};
use crate::analyzer::{Analyzer, DefaultAnalyzer};
use crate::middleware::{Context, MiddlewareStack};
use super::hasher::ContentHasher;
use super::progress::{ScanProgress, ProgressStyle};

/// Configuration for directory scanning.
#[derive(Debug, Clone)]
pub struct ScanConfig {
    /// Follow symlinks during traversal.
    pub follow_symlinks: bool,
    /// Use gitignore rules.
    pub use_gitignore: bool,
    /// Respect global gitignore.
    pub use_global_gitignore: bool,
    /// Include hidden files/directories.
    pub include_hidden: bool,
    /// Maximum depth to traverse (None = unlimited).
    pub max_depth: Option<usize>,
    /// File extensions to include (empty = all supported languages).
    pub extensions: Vec<String>,
    /// Paths/patterns to exclude.
    pub exclude_patterns: Vec<String>,
    /// Progress reporting style.
    pub progress_style: ProgressStyle,
    /// Enable incremental scanning (skip unchanged files).
    pub incremental: bool,
    /// Number of parallel threads (0 = auto).
    pub threads: usize,
}

impl Default for ScanConfig {
    fn default() -> Self {
        Self {
            follow_symlinks: false,
            use_gitignore: true,
            use_global_gitignore: true,
            include_hidden: false,
            max_depth: None,
            extensions: Vec::new(),
            exclude_patterns: Vec::new(),
            progress_style: ProgressStyle::Bar,
            incremental: false,
            threads: 0, // Auto-detect
        }
    }
}

impl ScanConfig {
    /// Create config for quick scanning (minimal features).
    pub fn quick() -> Self {
        Self {
            progress_style: ProgressStyle::Silent,
            ..Default::default()
        }
    }

    /// Create config for thorough scanning.
    pub fn thorough() -> Self {
        Self {
            follow_symlinks: true,
            include_hidden: true,
            ..Default::default()
        }
    }

    /// Set maximum traversal depth.
    pub fn with_max_depth(mut self, depth: usize) -> Self {
        self.max_depth = Some(depth);
        self
    }

    /// Set extensions to filter.
    pub fn with_extensions(mut self, exts: Vec<String>) -> Self {
        self.extensions = exts;
        self
    }

    /// Add exclude pattern.
    pub fn exclude(mut self, pattern: impl Into<String>) -> Self {
        self.exclude_patterns.push(pattern.into());
        self
    }

    /// Enable incremental mode.
    pub fn incremental(mut self) -> Self {
        self.incremental = true;
        self
    }

    /// Set progress style.
    pub fn with_progress(mut self, style: ProgressStyle) -> Self {
        self.progress_style = style;
        self
    }
}

/// Result of scanning a directory.
#[derive(Debug, Default)]
pub struct ScanResult {
    /// Successfully analyzed files.
    pub analyses: Vec<CodeAnalysis>,
    /// Files that failed to process.
    pub errors: Vec<(PathBuf, String)>,
    /// Files skipped (already up-to-date in incremental mode).
    pub skipped: usize,
    /// Total files discovered.
    pub total_files: usize,
    /// Processing time in milliseconds.
    pub duration_ms: u64,
}

impl ScanResult {
    /// Get count of successfully analyzed files.
    pub fn success_count(&self) -> usize {
        self.analyses.len()
    }

    /// Get count of failed files.
    pub fn error_count(&self) -> usize {
        self.errors.len()
    }

    /// Check if scan completed without errors.
    pub fn is_success(&self) -> bool {
        self.errors.is_empty()
    }

    /// Merge another scan result into this one.
    pub fn merge(&mut self, other: ScanResult) {
        self.analyses.extend(other.analyses);
        self.errors.extend(other.errors);
        self.skipped += other.skipped;
        self.total_files += other.total_files;
    }
}

/// Directory scanner with parallel processing.
pub struct Scanner {
    parser: Arc<dyn Parser + Send + Sync>,
    analyzer: Arc<dyn Analyzer + Send + Sync>,
    middleware: Arc<MiddlewareStack>,
    hasher: Arc<ContentHasher>,
    config: ScanConfig,
}

impl Scanner {
    /// Create a new scanner with default configuration.
    pub fn new() -> Self {
        Self {
            parser: Arc::new(TreeSitterParser::new()),
            analyzer: Arc::new(DefaultAnalyzer::new()),
            middleware: Arc::new(MiddlewareStack::new()),
            hasher: Arc::new(ContentHasher::new()),
            config: ScanConfig::default(),
        }
    }

    /// Create scanner with custom configuration.
    pub fn with_config(config: ScanConfig) -> Self {
        Self {
            config,
            ..Self::new()
        }
    }

    /// Set custom parser.
    pub fn with_parser<P: Parser + Send + Sync + 'static>(mut self, parser: P) -> Self {
        self.parser = Arc::new(parser);
        self
    }

    /// Set custom analyzer.
    pub fn with_analyzer<A: Analyzer + Send + Sync + 'static>(mut self, analyzer: A) -> Self {
        self.analyzer = Arc::new(analyzer);
        self
    }

    /// Set middleware stack.
    pub fn with_middleware(mut self, middleware: MiddlewareStack) -> Self {
        self.middleware = Arc::new(middleware);
        self
    }

    /// Get the content hasher for incremental updates.
    pub fn hasher(&self) -> &ContentHasher {
        &self.hasher
    }

    /// Scan multiple paths (files or directories).
    pub fn scan(&self, paths: Vec<PathBuf>) -> Result<ScanResult> {
        let start = std::time::Instant::now();

        // Collect all files first
        let files = self.collect_files(&paths)?;
        let total_files = files.len();

        if files.is_empty() {
            return Ok(ScanResult {
                total_files: 0,
                duration_ms: start.elapsed().as_millis() as u64,
                ..Default::default()
            });
        }

        // Set up thread pool if custom thread count specified
        if self.config.threads > 0 {
            rayon::ThreadPoolBuilder::new()
                .num_threads(self.config.threads)
                .build_global()
                .ok(); // Ignore error if already initialized
        }

        // Process files in parallel
        let progress = Arc::new(Mutex::new(ScanProgress::new(
            self.config.progress_style,
            total_files as u64,
        )));
        let analyses = Arc::new(Mutex::new(Vec::new()));
        let errors = Arc::new(Mutex::new(Vec::new()));
        let skipped = Arc::new(Mutex::new(0usize));

        files.par_iter().for_each(|path| {
            let result = self.process_file(path);

            match result {
                Ok(Some(analysis)) => {
                    analyses.lock().push(analysis);
                }
                Ok(None) => {
                    // Skipped (incremental mode, unchanged)
                    *skipped.lock() += 1;
                }
                Err(e) => {
                    errors.lock().push((path.clone(), e.to_string()));
                }
            }

            let mut prog = progress.lock();
            prog.inc();
            if matches!(self.config.progress_style, ProgressStyle::Verbose) {
                prog.set_message(path.to_string_lossy().to_string());
            }
        });

        // Finish progress reporting
        progress.lock().finish();

        let duration_ms = start.elapsed().as_millis() as u64;
        let skipped_count = *skipped.lock();

        Ok(ScanResult {
            analyses: Arc::try_unwrap(analyses).unwrap().into_inner(),
            errors: Arc::try_unwrap(errors).unwrap().into_inner(),
            skipped: skipped_count,
            total_files,
            duration_ms,
        })
    }

    /// Scan a single directory.
    pub fn scan_directory(&self, path: impl AsRef<Path>) -> Result<ScanResult> {
        self.scan(vec![path.as_ref().to_path_buf()])
    }

    /// Collect all matching files from paths.
    fn collect_files(&self, paths: &[PathBuf]) -> Result<Vec<PathBuf>> {
        let mut files = Vec::new();

        for path in paths {
            if !path.exists() {
                return Err(Error::io(path, std::io::Error::new(
                    std::io::ErrorKind::NotFound,
                    format!("Path does not exist: {}", path.display())
                )));
            }

            if path.is_file() {
                if self.should_include(path) {
                    files.push(path.clone());
                }
            } else if path.is_dir() {
                files.extend(self.walk_directory(path)?);
            }
        }

        Ok(files)
    }

    /// Walk a directory using ignore crate.
    fn walk_directory(&self, path: &Path) -> Result<Vec<PathBuf>> {
        let mut builder = WalkBuilder::new(path);

        // Configure walker
        builder
            .follow_links(self.config.follow_symlinks)
            .git_ignore(self.config.use_gitignore)
            .git_global(self.config.use_global_gitignore)
            .hidden(!self.config.include_hidden)
            .standard_filters(true);

        if let Some(depth) = self.config.max_depth {
            builder.max_depth(Some(depth));
        }

        // Add exclude patterns
        for pattern in &self.config.exclude_patterns {
            let mut overrides = ignore::overrides::OverrideBuilder::new(path);
            if let Err(e) = overrides.add(&format!("!{}", pattern)) {
                eprintln!("Warning: Invalid exclude pattern '{}': {}", pattern, e);
            }
        }

        let files: Vec<PathBuf> = builder
            .build()
            .filter_map(|entry| entry.ok())
            .filter(|entry| entry.file_type().map(|t| t.is_file()).unwrap_or(false))
            .map(|entry| entry.into_path())
            .filter(|p| self.should_include(p))
            .collect();

        Ok(files)
    }

    /// Check if a file should be included based on config.
    fn should_include(&self, path: &Path) -> bool {
        // Check language support
        if Language::detect_from_path(path).is_err() {
            return false;
        }

        // Check extension filter
        if !self.config.extensions.is_empty() {
            if let Some(ext) = path.extension().and_then(|e| e.to_str()) {
                if !self.config.extensions.iter().any(|e| e.eq_ignore_ascii_case(ext)) {
                    return false;
                }
            } else {
                return false;
            }
        }

        true
    }

    /// Process a single file.
    fn process_file(&self, path: &Path) -> Result<Option<CodeAnalysis>> {
        // Read file content
        let content = std::fs::read_to_string(path)
            .map_err(|e| Error::io(path, e))?;

        // Check if unchanged (incremental mode)
        if self.config.incremental && !self.hasher.has_changed(path, &content) {
            return Ok(None);
        }

        // Detect language
        let language = Language::detect_from_path(path)?;

        // Run middleware before_parse
        let mut ctx = Context::new(path);
        self.middleware.before_parse(&mut ctx)?;

        // Parse
        let parsed = self.parser.parse(&content, language)?;
        self.middleware.after_parse(&ctx, &parsed)?;

        // Analyze
        self.middleware.before_analyze(&mut ctx)?;
        let analysis = self.analyzer.analyze(&parsed, path)?;
        self.middleware.after_analyze(&ctx, &analysis)?;

        // Update hash cache
        self.hasher.hash_file(path, &content);

        Ok(Some(analysis))
    }
}

impl Default for Scanner {
    fn default() -> Self {
        Self::new()
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use tempfile::TempDir;
    use std::fs;

    fn create_test_file(dir: &Path, name: &str, content: &str) -> PathBuf {
        let path = dir.join(name);
        if let Some(parent) = path.parent() {
            fs::create_dir_all(parent).unwrap();
        }
        fs::write(&path, content).unwrap();
        path
    }

    #[test]
    fn test_scan_single_file() {
        let temp = TempDir::new().unwrap();
        let file = create_test_file(temp.path(), "test.rs", "fn main() {}");

        let scanner = Scanner::with_config(ScanConfig::quick());
        let result = scanner.scan(vec![file]).unwrap();

        assert_eq!(result.total_files, 1);
        assert_eq!(result.success_count(), 1);
        assert!(result.is_success());
    }

    #[test]
    fn test_scan_directory() {
        let temp = TempDir::new().unwrap();
        create_test_file(temp.path(), "a.rs", "fn a() {}");
        create_test_file(temp.path(), "b.rs", "fn b() {}");
        create_test_file(temp.path(), "sub/c.rs", "fn c() {}");

        let scanner = Scanner::with_config(ScanConfig::quick());
        let result = scanner.scan_directory(temp.path()).unwrap();

        assert_eq!(result.total_files, 3);
        assert_eq!(result.success_count(), 3);
    }

    #[test]
    fn test_extension_filter() {
        let temp = TempDir::new().unwrap();
        create_test_file(temp.path(), "a.rs", "fn a() {}");
        create_test_file(temp.path(), "b.py", "def b(): pass");
        create_test_file(temp.path(), "c.txt", "text");

        let config = ScanConfig::quick().with_extensions(vec!["rs".into()]);
        let scanner = Scanner::with_config(config);
        let result = scanner.scan_directory(temp.path()).unwrap();

        assert_eq!(result.total_files, 1);
    }

    #[test]
    fn test_incremental_scan() {
        let temp = TempDir::new().unwrap();
        let file = create_test_file(temp.path(), "test.rs", "fn main() {}");

        let config = ScanConfig::quick().incremental();
        let scanner = Scanner::with_config(config);

        // First scan - should process
        let result1 = scanner.scan(vec![file.clone()]).unwrap();
        assert_eq!(result1.success_count(), 1);
        assert_eq!(result1.skipped, 0);

        // Second scan - should skip (unchanged)
        let result2 = scanner.scan(vec![file.clone()]).unwrap();
        assert_eq!(result2.success_count(), 0);
        assert_eq!(result2.skipped, 1);

        // Modify file
        fs::write(&file, "fn updated() {}").unwrap();

        // Third scan - should process (changed)
        let result3 = scanner.scan(vec![file]).unwrap();
        assert_eq!(result3.success_count(), 1);
        assert_eq!(result3.skipped, 0);
    }
}
