//! Incremental analysis middleware.

use std::path::PathBuf;
use crate::core::{Result, CodeAnalysis};
use crate::middleware::{Middleware, Context};
use super::{StateCache, DeltaDetector, DeltaPlan, FileState};

/// Middleware for incremental analysis.
pub struct IncrementalMiddleware {
    cache: StateCache,
    detector: Box<dyn DeltaDetector>,
}

impl IncrementalMiddleware {
    /// Create with hybrid detector.
    pub fn new(cache_path: PathBuf) -> Self {
        Self {
            cache: StateCache::new(cache_path),
            detector: Box::new(super::HybridDetector),
        }
    }

    /// Create with custom detector.
    pub fn with_detector(cache_path: PathBuf, detector: Box<dyn DeltaDetector>) -> Self {
        Self {
            cache: StateCache::new(cache_path),
            detector,
        }
    }

    /// Get analysis plan for files.
    pub fn plan(&self, files: &[PathBuf]) -> DeltaPlan {
        self.detector.detect(&self.cache, files)
    }

    /// Update cache after analysis.
    pub fn update_cache(&mut self, analysis: &CodeAnalysis) {
        let path = &analysis.file_path;

        if let Ok(meta) = std::fs::metadata(path) {
            let mtime = meta.modified()
                .map(|t| t.duration_since(std::time::UNIX_EPOCH).unwrap_or_default().as_secs())
                .unwrap_or(0);

            let state = FileState {
                path: path.clone(),
                content_hash: analysis.metadata.content_hash.clone(),
                mtime,
                size: meta.len(),
                output_hash: Self::hash_analysis(analysis),
            };

            self.cache.set(state);
        }
    }

    /// Save cache to disk.
    pub fn save(&self) -> Result<()> {
        self.cache.save().map_err(|e| crate::core::Error::io(&self.cache.cache_path, e))
    }

    fn hash_analysis(analysis: &CodeAnalysis) -> String {
        use sha2::{Sha256, Digest};
        let mut hasher = Sha256::new();
        hasher.update(format!("{:?}", analysis.symbols.len()).as_bytes());
        hasher.update(format!("{:?}", analysis.relationships.len()).as_bytes());
        format!("{:x}", hasher.finalize())[..16].to_string()
    }
}

impl Middleware for IncrementalMiddleware {
    fn after_analyze(&self, _ctx: &Context, _analysis: &CodeAnalysis) -> Result<()> {
        // Cache update is done explicitly via update_cache
        Ok(())
    }

    fn name(&self) -> &str {
        "IncrementalMiddleware"
    }
}
