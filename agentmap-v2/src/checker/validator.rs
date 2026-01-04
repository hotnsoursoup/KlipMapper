//! File validation implementation.

use std::fs;
use std::path::{Path, PathBuf};
use std::time::Instant;

use anyhow::Result;
use ignore::WalkBuilder;
use rayon::prelude::*;

use crate::anchor::{AnchorCompressor, AnchorHeader};
use crate::parser::Language;

use super::types::{CheckConfig, CheckIssue, CheckResult, CheckSummary};

/// File and analysis validator.
///
/// Checks that analysis metadata (anchors or sidecars) is valid and
/// up-to-date with the source files.
pub struct Checker {
    config: CheckConfig,
}

impl Checker {
    /// Create a new checker with default configuration.
    pub fn new() -> Self {
        Self {
            config: CheckConfig::default(),
        }
    }

    /// Create a checker with custom configuration.
    pub fn with_config(config: CheckConfig) -> Self {
        Self { config }
    }

    /// Get the current configuration.
    pub fn config(&self) -> &CheckConfig {
        &self.config
    }

    /// Enable hash verification.
    pub fn with_verify_hashes(mut self, verify: bool) -> Self {
        self.config.verify_hashes = verify;
        self
    }

    /// Enable symbol verification.
    pub fn with_verify_symbols(mut self, verify: bool) -> Self {
        self.config.verify_symbols = verify;
        self
    }

    /// Enable cross-reference verification.
    pub fn with_verify_xrefs(mut self, verify: bool) -> Self {
        self.config.verify_xrefs = verify;
        self
    }

    /// Check a single file.
    pub fn check_file(&self, path: &Path) -> CheckIssue {
        let start = Instant::now();
        let result = self.check_file_inner(path);
        let duration_us = start.elapsed().as_micros() as u64;

        result.with_duration(duration_us)
    }

    /// Internal implementation of file checking.
    fn check_file_inner(&self, path: &Path) -> CheckIssue {
        let path_buf = path.to_path_buf();

        // Check if file exists
        if !path.exists() {
            return CheckIssue::invalid(path_buf, "File does not exist");
        }

        // Check if it's a supported language
        if Language::detect_from_path(path).is_err() {
            return CheckIssue::skipped(path_buf);
        }

        // Check if extension is in our filter (if any)
        if !self.config.extensions.is_empty() {
            let ext = path.extension().and_then(|e| e.to_str()).unwrap_or("");
            if !self.config.extensions.iter().any(|e| e == ext) {
                return CheckIssue::skipped(path_buf);
            }
        }

        // Read the file content
        let content = match fs::read_to_string(path) {
            Ok(c) => c,
            Err(e) => return CheckIssue::invalid(path_buf, format!("Cannot read file: {}", e)),
        };

        // Check for anchor header
        if self.config.check_anchors {
            return self.check_anchor(path_buf, &content);
        }

        // Check for sidecar file
        if self.config.check_sidecars {
            return self.check_sidecar(path_buf, &content);
        }

        // No check method enabled
        CheckIssue::skipped(path_buf)
    }

    /// Check anchor header in a file.
    fn check_anchor(&self, path: PathBuf, content: &str) -> CheckIssue {
        // Check if file has anchor header
        if !AnchorCompressor::has_anchor_header(content) {
            return CheckIssue::missing(path, "No anchor header found");
        }

        // Extract and parse anchor
        let lines: Vec<&str> = content.lines().take(50).collect();
        let compressed = match AnchorCompressor::parse_header_comments(&lines) {
            Some(c) => c,
            None => return CheckIssue::invalid(path, "Failed to parse anchor header"),
        };

        let header: AnchorHeader = match AnchorCompressor::decompress_header(&compressed) {
            Ok(h) => h,
            Err(e) => return CheckIssue::invalid(path, format!("Failed to decompress anchor: {}", e)),
        };

        // Verify hash if enabled
        if self.config.verify_hashes {
            // Get content without anchor header (estimate)
            let content_to_hash = self.strip_anchor_header(content);
            let current_hash = AnchorCompressor::hash_content(&content_to_hash);
            let expected_hash = header.file_fingerprint
                .strip_prefix("sha1:")
                .unwrap_or(&header.file_fingerprint);

            if current_hash != expected_hash {
                return CheckIssue::outdated(
                    path,
                    format!("Content hash mismatch: expected {}, got {}", expected_hash, current_hash),
                );
            }
        }

        // Verify symbols if enabled
        if self.config.verify_symbols {
            if header.symbols.is_empty() {
                return CheckIssue::outdated(path, "Anchor has no symbols recorded");
            }
        }

        // Verify xrefs if enabled
        if self.config.verify_xrefs {
            if let Some(issues) = self.verify_xrefs(&header, content) {
                return CheckIssue::outdated(path, issues);
            }
        }

        CheckIssue::valid(path)
    }

    /// Check sidecar file for a source file.
    fn check_sidecar(&self, path: PathBuf, content: &str) -> CheckIssue {
        // Find sidecar path
        let sidecar_path = self.sidecar_path(&path, content);

        // Check if sidecar exists
        if !sidecar_path.exists() {
            return CheckIssue::missing(path, format!("Sidecar not found: {}", sidecar_path.display()));
        }

        // Read sidecar content
        let sidecar_content = match fs::read_to_string(&sidecar_path) {
            Ok(c) => c,
            Err(e) => return CheckIssue::invalid(path, format!("Cannot read sidecar: {}", e)),
        };

        // Parse sidecar YAML
        let sidecar: serde_yaml::Value = match serde_yaml::from_str(&sidecar_content) {
            Ok(v) => v,
            Err(e) => return CheckIssue::invalid(path, format!("Invalid sidecar YAML: {}", e)),
        };

        // Verify hash if enabled
        if self.config.verify_hashes {
            if let Some(stored_hash) = sidecar.get("source_hash").and_then(|v| v.as_str()) {
                let current_hash = AnchorCompressor::hash_content(content);
                // Compare first 16 chars (SHA-256 truncated)
                let stored_short = &stored_hash[..stored_hash.len().min(16)];
                if !current_hash.starts_with(stored_short) {
                    return CheckIssue::outdated(path, "Source hash mismatch - file has changed");
                }
            }
        }

        CheckIssue::valid(path)
    }

    /// Calculate sidecar file path.
    fn sidecar_path(&self, source: &Path, content: &str) -> PathBuf {
        // Check frontmatter for agentmap reference
        let head: String = content.lines().take(80).collect::<Vec<_>>().join("\n");

        if let Some(fm) = crate::util::parse_frontmatter(&head) {
            if let Some(agentmap_ref) = fm.get_string("agentmap") {
                if let Some(parent) = source.parent() {
                    return parent.join(agentmap_ref);
                }
            }
        }

        // Default sidecar location
        let mut sidecar = PathBuf::from(".agentmap");
        sidecar.push(source);
        sidecar.set_extension("yaml");
        sidecar
    }

    /// Strip anchor header from content for hashing.
    fn strip_anchor_header<'a>(&self, content: &'a str) -> &'a str {
        let lines: Vec<&str> = content.lines().collect();

        // Find end of anchor header
        let mut header_end = 0;
        let mut in_header = false;

        for (i, line) in lines.iter().enumerate() {
            let trimmed = line.trim();
            if trimmed.contains("agentmap:1") || trimmed.contains("agentmap:2") {
                in_header = true;
            }
            if in_header && trimmed.contains("total-bytes:") {
                header_end = i + 1;
                break;
            }
        }

        if header_end > 0 && header_end < lines.len() {
            // Skip blank lines after header
            let mut content_start = header_end;
            while content_start < lines.len() && lines[content_start].trim().is_empty() {
                content_start += 1;
            }

            // Find start byte of content
            let bytes_to_skip: usize = lines[..content_start].iter()
                .map(|l| l.len() + 1) // +1 for newline
                .sum();

            if bytes_to_skip < content.len() {
                return &content[bytes_to_skip..];
            }
        }

        content
    }

    /// Verify cross-references in anchor.
    fn verify_xrefs(&self, header: &AnchorHeader, _content: &str) -> Option<String> {
        // Check that all symbol IDs in xrefs exist
        for (category, refs) in &header.xrefs {
            for xref in refs {
                if xref.lines.is_empty() {
                    return Some(format!(
                        "Cross-reference {} in category {} has no line numbers",
                        xref.target, category
                    ));
                }
            }
        }

        // Check that index matches symbols
        for (symbol_id, range) in &header.index.by_symbol {
            let symbol_exists = header.symbols.iter().any(|s| &s.id == symbol_id);
            if !symbol_exists {
                return Some(format!(
                    "Index references non-existent symbol: {} at lines {:?}",
                    symbol_id, range
                ));
            }
        }

        None
    }

    /// Check multiple paths (files or directories).
    pub fn check_paths(&self, paths: &[PathBuf]) -> Result<CheckSummary> {
        // Collect all files to check
        let files = self.collect_files(paths)?;

        // Check files (parallel or sequential)
        let issues: Vec<CheckIssue> = if self.config.parallel {
            files.par_iter()
                .map(|path| self.check_file(path))
                .collect()
        } else {
            files.iter()
                .map(|path| self.check_file(path))
                .collect()
        };

        // Build summary
        let mut summary = CheckSummary::new();
        for issue in issues {
            summary.add(issue);
        }

        Ok(summary)
    }

    /// Collect all files from paths.
    fn collect_files(&self, paths: &[PathBuf]) -> Result<Vec<PathBuf>> {
        let mut files = Vec::new();

        for path in paths {
            if path.is_file() {
                files.push(path.clone());
            } else if path.is_dir() {
                let walker = WalkBuilder::new(path)
                    .standard_filters(true)
                    .hidden(!self.config.include_hidden)
                    .build();

                for entry in walker {
                    let entry = entry?;
                    if entry.file_type().map(|t| t.is_file()).unwrap_or(false) {
                        let file_path = entry.into_path();

                        // Check ignore patterns
                        let path_str = file_path.to_string_lossy();
                        let ignored = self.config.ignore_patterns.iter().any(|pattern| {
                            path_str.contains(pattern)
                        });

                        if !ignored {
                            files.push(file_path);
                        }
                    }
                }
            }
        }

        Ok(files)
    }
}

impl Default for Checker {
    fn default() -> Self {
        Self::new()
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use tempfile::TempDir;

    #[test]
    fn test_checker_new() {
        let checker = Checker::new();
        assert!(checker.config.verify_hashes);
        assert!(checker.config.parallel);
    }

    #[test]
    fn test_checker_with_config() {
        let config = CheckConfig::new()
            .with_verify_hashes(false)
            .with_parallel(false);

        let checker = Checker::with_config(config);
        assert!(!checker.config.verify_hashes);
        assert!(!checker.config.parallel);
    }

    #[test]
    fn test_collect_files() {
        let temp = TempDir::new().unwrap();

        // Create test files
        fs::write(temp.path().join("a.rs"), "fn a() {}").unwrap();
        fs::write(temp.path().join("b.rs"), "fn b() {}").unwrap();
        fs::create_dir(temp.path().join("sub")).unwrap();
        fs::write(temp.path().join("sub/c.rs"), "fn c() {}").unwrap();

        let checker = Checker::new();
        let files = checker.collect_files(&[temp.path().to_path_buf()]).unwrap();

        assert!(files.len() >= 3);
    }

    #[test]
    fn test_strip_anchor_header() {
        let content = r#"// agentmap:1
// gz64: data
// total-bytes: 10 sha1:abc

fn main() {}
"#;

        let checker = Checker::new();
        let stripped = checker.strip_anchor_header(content);

        assert!(stripped.contains("fn main()"));
        assert!(!stripped.contains("agentmap:1"));
    }

    #[test]
    fn test_sidecar_path_default() {
        let checker = Checker::new();
        let source = PathBuf::from("src/main.rs");
        let content = "fn main() {}";

        let sidecar = checker.sidecar_path(&source, content);

        assert!(sidecar.to_string_lossy().contains(".agentmap"));
        assert!(sidecar.to_string_lossy().contains("main.yaml"));
    }
}
