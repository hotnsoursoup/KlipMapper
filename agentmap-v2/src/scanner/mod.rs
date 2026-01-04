//! Scanner module for directory-based code analysis.
//!
//! Provides parallel, gitignore-aware scanning with progress reporting
//! and incremental update support via content hashing.

mod walker;
mod hasher;
mod progress;

pub use walker::{Scanner, ScanConfig, ScanResult};
pub use hasher::ContentHasher;
pub use progress::{ScanProgress, ProgressStyle};
