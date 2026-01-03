//! Analyzer module for relationship detection.

mod pipeline;
mod inheritance;
mod imports;
mod calls;
mod usage;

pub use pipeline::DefaultAnalyzer;
pub use inheritance::InheritanceAnalyzer;
pub use imports::ImportAnalyzer;
pub use calls::CallAnalyzer;
pub use usage::UsageAnalyzer;

use crate::core::{Result, CodeAnalysis};
use crate::parser::ParsedFile;
use std::path::Path;

/// Analyzer trait for code analysis.
pub trait Analyzer: Send + Sync {
    /// Analyze a parsed file and produce a CodeAnalysis.
    fn analyze(&self, parsed: &ParsedFile, path: &Path) -> Result<CodeAnalysis>;
}
