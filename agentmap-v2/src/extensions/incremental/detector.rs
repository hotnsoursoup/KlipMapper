//! Delta detector trait.

use std::path::PathBuf;
use super::StateCache;

/// Result of delta detection.
#[derive(Debug, Clone, Default)]
pub struct DeltaPlan {
    /// Files that need analysis (changed or new).
    pub analyze: Vec<PathBuf>,
    /// Files that can use cached analysis.
    pub reuse: Vec<PathBuf>,
    /// Files that were deleted.
    pub deleted: Vec<PathBuf>,
    /// New files (temporary, merged into analyze).
    pub new: Vec<PathBuf>,
}

impl DeltaPlan {
    /// Check if any files need analysis.
    pub fn has_changes(&self) -> bool {
        !self.analyze.is_empty() || !self.deleted.is_empty()
    }

    /// Total files to process.
    pub fn total_files(&self) -> usize {
        self.analyze.len() + self.reuse.len()
    }
}

/// Change type for a file.
#[derive(Debug, Clone)]
pub enum FileChange {
    Added(PathBuf),
    Modified(PathBuf),
    Deleted(PathBuf),
    Unchanged(PathBuf),
}

/// Trait for detecting file changes.
pub trait DeltaDetector: Send + Sync {
    fn detect(&self, cache: &StateCache, files: &[PathBuf]) -> DeltaPlan;
    fn name(&self) -> &str;
}
