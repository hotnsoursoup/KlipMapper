//! Types for the validation system.

use std::path::PathBuf;
use std::cmp::Ordering;
use serde::Serialize;

/// Result of checking a single file.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize)]
pub enum CheckResult {
    /// File is valid and up-to-date.
    Valid,
    /// File was skipped (unsupported type).
    Skipped,
    /// Analysis is outdated (source changed).
    Outdated,
    /// Analysis is missing (no anchor/sidecar).
    Missing,
    /// Analysis is invalid (corrupt or error).
    Invalid,
}

impl CheckResult {
    /// Check if this result represents an issue.
    pub fn is_issue(&self) -> bool {
        !matches!(self, Self::Valid | Self::Skipped)
    }

    /// Check if this result is successful.
    pub fn is_ok(&self) -> bool {
        matches!(self, Self::Valid | Self::Skipped)
    }

    /// Get a human-readable description.
    pub fn description(&self) -> &'static str {
        match self {
            Self::Valid => "Valid and up-to-date",
            Self::Skipped => "Skipped (unsupported)",
            Self::Outdated => "Outdated (source changed)",
            Self::Missing => "Missing analysis",
            Self::Invalid => "Invalid or corrupt",
        }
    }

    /// Get an emoji indicator.
    pub fn emoji(&self) -> &'static str {
        match self {
            Self::Valid => "\u{2705}", // green checkmark
            Self::Skipped => "\u{23ED}", // skip
            Self::Outdated => "\u{26A0}\u{FE0F}", // warning
            Self::Missing => "\u{2754}", // question mark
            Self::Invalid => "\u{274C}", // red x
        }
    }

    /// Get severity level (higher = worse).
    pub fn severity(&self) -> u8 {
        match self {
            Self::Valid => 0,
            Self::Skipped => 0,
            Self::Outdated => 1,
            Self::Missing => 2,
            Self::Invalid => 3,
        }
    }
}

impl PartialOrd for CheckResult {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

impl Ord for CheckResult {
    fn cmp(&self, other: &Self) -> Ordering {
        self.severity().cmp(&other.severity())
    }
}

impl std::fmt::Display for CheckResult {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.description())
    }
}

/// A single check issue with details.
#[derive(Debug, Clone, Serialize)]
pub struct CheckIssue {
    /// File path that was checked.
    pub path: PathBuf,
    /// Result of the check.
    pub result: CheckResult,
    /// Optional detailed message.
    pub message: Option<String>,
    /// Time taken to check (in microseconds).
    pub duration_us: Option<u64>,
}

impl CheckIssue {
    /// Create a new check issue.
    pub fn new(path: PathBuf, result: CheckResult, message: Option<String>) -> Self {
        Self {
            path,
            result,
            message,
            duration_us: None,
        }
    }

    /// Create a valid result.
    pub fn valid(path: PathBuf) -> Self {
        Self::new(path, CheckResult::Valid, None)
    }

    /// Create a skipped result.
    pub fn skipped(path: PathBuf) -> Self {
        Self::new(path, CheckResult::Skipped, None)
    }

    /// Create a missing result.
    pub fn missing(path: PathBuf, message: impl Into<String>) -> Self {
        Self::new(path, CheckResult::Missing, Some(message.into()))
    }

    /// Create an outdated result.
    pub fn outdated(path: PathBuf, message: impl Into<String>) -> Self {
        Self::new(path, CheckResult::Outdated, Some(message.into()))
    }

    /// Create an invalid result.
    pub fn invalid(path: PathBuf, message: impl Into<String>) -> Self {
        Self::new(path, CheckResult::Invalid, Some(message.into()))
    }

    /// Set the duration.
    pub fn with_duration(mut self, duration_us: u64) -> Self {
        self.duration_us = Some(duration_us);
        self
    }

    /// Check if this is an issue.
    pub fn is_issue(&self) -> bool {
        self.result.is_issue()
    }

    /// Get the message or a default description.
    pub fn display_message(&self) -> &str {
        self.message.as_deref().unwrap_or_else(|| self.result.description())
    }
}

/// Summary of checking multiple files.
#[derive(Debug, Clone, Serialize)]
pub struct CheckSummary {
    /// All check results.
    issues: Vec<CheckIssue>,
    /// Count of valid files.
    valid: usize,
    /// Count of skipped files.
    skipped: usize,
    /// Count of outdated files.
    outdated: usize,
    /// Count of missing analyses.
    missing: usize,
    /// Count of invalid analyses.
    invalid: usize,
    /// Total duration (in microseconds).
    total_duration_us: u64,
}

impl CheckSummary {
    /// Create a new empty summary.
    pub fn new() -> Self {
        Self {
            issues: Vec::new(),
            valid: 0,
            skipped: 0,
            outdated: 0,
            missing: 0,
            invalid: 0,
            total_duration_us: 0,
        }
    }

    /// Add a check result.
    pub fn add(&mut self, issue: CheckIssue) {
        match issue.result {
            CheckResult::Valid => self.valid += 1,
            CheckResult::Skipped => self.skipped += 1,
            CheckResult::Outdated => self.outdated += 1,
            CheckResult::Missing => self.missing += 1,
            CheckResult::Invalid => self.invalid += 1,
        }
        if let Some(dur) = issue.duration_us {
            self.total_duration_us += dur;
        }
        self.issues.push(issue);
    }

    /// Merge another summary into this one.
    pub fn merge(&mut self, other: CheckSummary) {
        for issue in other.issues {
            self.add(issue);
        }
    }

    /// Get count of valid files.
    pub fn valid_count(&self) -> usize {
        self.valid
    }

    /// Get count of skipped files.
    pub fn skipped_count(&self) -> usize {
        self.skipped
    }

    /// Get count of outdated files.
    pub fn outdated_count(&self) -> usize {
        self.outdated
    }

    /// Get count of missing analyses.
    pub fn missing_count(&self) -> usize {
        self.missing
    }

    /// Get count of invalid analyses.
    pub fn invalid_count(&self) -> usize {
        self.invalid
    }

    /// Get total files checked.
    pub fn files_checked(&self) -> usize {
        self.issues.len()
    }

    /// Get total issues (non-valid, non-skipped).
    pub fn total_issues(&self) -> usize {
        self.outdated + self.missing + self.invalid
    }

    /// Check if there are any issues.
    pub fn has_issues(&self) -> bool {
        self.total_issues() > 0
    }

    /// Get exit code for CLI (0 = success, 1 = has issues).
    pub fn exit_code(&self) -> i32 {
        if self.has_issues() { 1 } else { 0 }
    }

    /// Get all issues.
    pub fn all(&self) -> &[CheckIssue] {
        &self.issues
    }

    /// Get only the issues (non-valid, non-skipped).
    pub fn issues(&self) -> impl Iterator<Item = &CheckIssue> {
        self.issues.iter().filter(|i| i.is_issue())
    }

    /// Get only valid results.
    pub fn valid_files(&self) -> impl Iterator<Item = &CheckIssue> {
        self.issues.iter().filter(|i| i.result == CheckResult::Valid)
    }

    /// Get total duration in milliseconds.
    pub fn duration_ms(&self) -> f64 {
        self.total_duration_us as f64 / 1000.0
    }

    /// Sort issues by severity (worst first).
    pub fn sort_by_severity(&mut self) {
        self.issues.sort_by(|a, b| b.result.cmp(&a.result));
    }

    /// Sort issues by path.
    pub fn sort_by_path(&mut self) {
        self.issues.sort_by(|a, b| a.path.cmp(&b.path));
    }

    /// Get a formatted summary string.
    pub fn summary_string(&self) -> String {
        let mut parts = Vec::new();

        if self.valid > 0 {
            parts.push(format!("{} valid", self.valid));
        }
        if self.outdated > 0 {
            parts.push(format!("{} outdated", self.outdated));
        }
        if self.missing > 0 {
            parts.push(format!("{} missing", self.missing));
        }
        if self.invalid > 0 {
            parts.push(format!("{} invalid", self.invalid));
        }
        if self.skipped > 0 {
            parts.push(format!("{} skipped", self.skipped));
        }

        if parts.is_empty() {
            "No files checked".to_string()
        } else {
            parts.join(", ")
        }
    }
}

impl Default for CheckSummary {
    fn default() -> Self {
        Self::new()
    }
}

impl std::fmt::Display for CheckSummary {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.summary_string())
    }
}

/// Configuration for the checker.
#[derive(Debug, Clone)]
pub struct CheckConfig {
    /// Verify content hashes match.
    pub verify_hashes: bool,
    /// Verify symbol counts match.
    pub verify_symbols: bool,
    /// Verify cross-references are valid.
    pub verify_xrefs: bool,
    /// Check anchor headers (vs sidecar files).
    pub check_anchors: bool,
    /// Check sidecar files.
    pub check_sidecars: bool,
    /// Run checks in parallel.
    pub parallel: bool,
    /// Include hidden files.
    pub include_hidden: bool,
    /// File extensions to check (empty = all supported).
    pub extensions: Vec<String>,
    /// Paths/patterns to ignore.
    pub ignore_patterns: Vec<String>,
}

impl CheckConfig {
    /// Create a new default config.
    pub fn new() -> Self {
        Self::default()
    }

    /// Enable hash verification.
    pub fn with_verify_hashes(mut self, verify: bool) -> Self {
        self.verify_hashes = verify;
        self
    }

    /// Enable symbol verification.
    pub fn with_verify_symbols(mut self, verify: bool) -> Self {
        self.verify_symbols = verify;
        self
    }

    /// Enable cross-reference verification.
    pub fn with_verify_xrefs(mut self, verify: bool) -> Self {
        self.verify_xrefs = verify;
        self
    }

    /// Enable/disable checking anchor headers.
    pub fn with_check_anchors(mut self, check: bool) -> Self {
        self.check_anchors = check;
        self
    }

    /// Enable/disable checking sidecar files.
    pub fn with_check_sidecars(mut self, check: bool) -> Self {
        self.check_sidecars = check;
        self
    }

    /// Enable/disable parallel execution.
    pub fn with_parallel(mut self, parallel: bool) -> Self {
        self.parallel = parallel;
        self
    }

    /// Set extensions to check.
    pub fn with_extensions(mut self, extensions: Vec<String>) -> Self {
        self.extensions = extensions;
        self
    }

    /// Add an ignore pattern.
    pub fn add_ignore(mut self, pattern: impl Into<String>) -> Self {
        self.ignore_patterns.push(pattern.into());
        self
    }
}

impl Default for CheckConfig {
    fn default() -> Self {
        Self {
            verify_hashes: true,
            verify_symbols: false,
            verify_xrefs: false,
            check_anchors: true,
            check_sidecars: false,
            parallel: true,
            include_hidden: false,
            extensions: Vec::new(),
            ignore_patterns: vec![
                "node_modules".to_string(),
                "target".to_string(),
                ".git".to_string(),
                "vendor".to_string(),
            ],
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_check_result_severity() {
        assert_eq!(CheckResult::Valid.severity(), 0);
        assert_eq!(CheckResult::Skipped.severity(), 0);
        assert_eq!(CheckResult::Outdated.severity(), 1);
        assert_eq!(CheckResult::Missing.severity(), 2);
        assert_eq!(CheckResult::Invalid.severity(), 3);
    }

    #[test]
    fn test_check_result_is_issue() {
        assert!(!CheckResult::Valid.is_issue());
        assert!(!CheckResult::Skipped.is_issue());
        assert!(CheckResult::Outdated.is_issue());
        assert!(CheckResult::Missing.is_issue());
        assert!(CheckResult::Invalid.is_issue());
    }

    #[test]
    fn test_check_issue_constructors() {
        let valid = CheckIssue::valid(PathBuf::from("a.rs"));
        assert_eq!(valid.result, CheckResult::Valid);
        assert!(valid.message.is_none());

        let missing = CheckIssue::missing(PathBuf::from("b.rs"), "No anchor");
        assert_eq!(missing.result, CheckResult::Missing);
        assert_eq!(missing.message.as_deref(), Some("No anchor"));
    }

    #[test]
    fn test_check_summary_merge() {
        let mut summary1 = CheckSummary::new();
        summary1.add(CheckIssue::valid(PathBuf::from("a.rs")));

        let mut summary2 = CheckSummary::new();
        summary2.add(CheckIssue::missing(PathBuf::from("b.rs"), "Missing"));

        summary1.merge(summary2);

        assert_eq!(summary1.valid_count(), 1);
        assert_eq!(summary1.missing_count(), 1);
        assert_eq!(summary1.files_checked(), 2);
    }

    #[test]
    fn test_check_config_builder() {
        let config = CheckConfig::new()
            .with_verify_hashes(true)
            .with_verify_symbols(true)
            .with_parallel(false)
            .add_ignore("*.log");

        assert!(config.verify_hashes);
        assert!(config.verify_symbols);
        assert!(!config.parallel);
        assert!(config.ignore_patterns.contains(&"*.log".to_string()));
    }

    #[test]
    fn test_check_summary_display() {
        let mut summary = CheckSummary::new();
        summary.add(CheckIssue::valid(PathBuf::from("a.rs")));
        summary.add(CheckIssue::missing(PathBuf::from("b.rs"), "Missing"));

        let display = summary.to_string();
        assert!(display.contains("1 valid"));
        assert!(display.contains("1 missing"));
    }
}
