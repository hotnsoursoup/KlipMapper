//! Validation and checking system for code analysis.
//!
//! This module provides validation capabilities for:
//! - Verifying anchor headers are up-to-date
//! - Checking analysis freshness against source changes
//! - Validating cross-reference integrity
//! - Batch checking with parallel execution
//!
//! # Example
//!
//! ```rust,ignore
//! use agentmap::checker::{Checker, CheckConfig};
//!
//! let checker = Checker::new()
//!     .with_verify_hashes(true)
//!     .with_verify_symbols(true);
//!
//! let summary = checker.check_paths(&[PathBuf::from("src/")])?;
//!
//! if summary.has_issues() {
//!     println!("Found {} issues", summary.total_issues());
//!     for (path, result, msg) in summary.issues() {
//!         println!("  {} - {:?}: {}", path.display(), result, msg);
//!     }
//! }
//! ```

mod types;
mod validator;

pub use types::{CheckResult, CheckSummary, CheckIssue, CheckConfig};
pub use validator::Checker;

#[cfg(test)]
mod tests {
    use super::*;
    use std::path::PathBuf;
    use tempfile::TempDir;
    use std::fs;

    #[test]
    fn test_check_result_ordering() {
        assert!(CheckResult::Valid < CheckResult::Outdated);
        assert!(CheckResult::Outdated < CheckResult::Missing);
        assert!(CheckResult::Missing < CheckResult::Invalid);
    }

    #[test]
    fn test_check_summary() {
        let mut summary = CheckSummary::new();

        summary.add(CheckIssue::new(
            PathBuf::from("a.rs"),
            CheckResult::Valid,
            None,
        ));
        summary.add(CheckIssue::new(
            PathBuf::from("b.rs"),
            CheckResult::Missing,
            Some("No anchor found".to_string()),
        ));
        summary.add(CheckIssue::new(
            PathBuf::from("c.rs"),
            CheckResult::Outdated,
            Some("Hash mismatch".to_string()),
        ));

        assert_eq!(summary.valid_count(), 1);
        assert_eq!(summary.missing_count(), 1);
        assert_eq!(summary.outdated_count(), 1);
        assert_eq!(summary.total_issues(), 2);
        assert!(summary.has_issues());
        assert_eq!(summary.exit_code(), 1);
    }

    #[test]
    fn test_check_summary_no_issues() {
        let mut summary = CheckSummary::new();

        summary.add(CheckIssue::new(
            PathBuf::from("a.rs"),
            CheckResult::Valid,
            None,
        ));
        summary.add(CheckIssue::new(
            PathBuf::from("b.rs"),
            CheckResult::Valid,
            None,
        ));

        assert_eq!(summary.valid_count(), 2);
        assert!(!summary.has_issues());
        assert_eq!(summary.exit_code(), 0);
    }

    #[test]
    fn test_checker_config() {
        let config = CheckConfig::default()
            .with_verify_hashes(true)
            .with_verify_symbols(true)
            .with_verify_xrefs(true);

        assert!(config.verify_hashes);
        assert!(config.verify_symbols);
        assert!(config.verify_xrefs);
    }

    #[test]
    fn test_checker_creation() {
        let checker = Checker::new();
        assert!(checker.config().verify_hashes);
    }

    #[test]
    fn test_check_nonexistent_file() {
        let checker = Checker::new();
        let result = checker.check_file(&PathBuf::from("nonexistent_file.rs"));

        assert_eq!(result.result, CheckResult::Invalid);
        assert!(result.message.is_some());
    }

    #[test]
    fn test_check_unsupported_file() {
        let temp = TempDir::new().unwrap();
        let path = temp.path().join("readme.txt");
        fs::write(&path, "Hello world").unwrap();

        let checker = Checker::new();
        let result = checker.check_file(&path);

        // Unsupported files are skipped (valid)
        assert_eq!(result.result, CheckResult::Skipped);
    }

    #[test]
    fn test_check_file_without_anchor() {
        let temp = TempDir::new().unwrap();
        let path = temp.path().join("main.rs");
        fs::write(&path, "fn main() {}").unwrap();

        let checker = Checker::new();
        let result = checker.check_file(&path);

        assert_eq!(result.result, CheckResult::Missing);
        assert!(result.message.is_some());
    }

    #[test]
    fn test_check_file_with_anchor() {
        let temp = TempDir::new().unwrap();
        let path = temp.path().join("lib.rs");

        // Create a file with an anchor header
        let content = r#"// agentmap:1
// gz64: H4sIAAAAAAAAA6tWKkktLlGyUlAqLU4tAQBb8U8iDQAAAA==
// total-bytes: 44 sha1:12345678

fn main() {}
"#;
        fs::write(&path, content).unwrap();

        let checker = Checker::new();
        let result = checker.check_file(&path);

        // Will fail to decompress but shows anchor detection works
        // In real usage, a properly compressed anchor would be used
        assert!(matches!(
            result.result,
            CheckResult::Invalid | CheckResult::Outdated
        ));
    }

    #[test]
    fn test_batch_check() {
        let temp = TempDir::new().unwrap();

        // Create a few test files
        fs::write(temp.path().join("a.rs"), "fn a() {}").unwrap();
        fs::write(temp.path().join("b.rs"), "fn b() {}").unwrap();
        fs::write(temp.path().join("readme.txt"), "Hello").unwrap();

        let checker = Checker::new();
        let summary = checker.check_paths(&[temp.path().to_path_buf()]).unwrap();

        // Two rust files should be checked (missing anchors), one txt skipped
        assert!(summary.files_checked() >= 2);
    }
}
