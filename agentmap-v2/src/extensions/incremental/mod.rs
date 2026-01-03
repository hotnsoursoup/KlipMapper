//! Incremental analysis with caching.

mod cache;
mod detector;
mod middleware;

pub use cache::{StateCache, FileState};
pub use detector::{DeltaDetector, DeltaPlan, FileChange};
pub use middleware::IncrementalMiddleware;

/// Hybrid detector - uses mtime first, hash on change.
pub struct HybridDetector;

impl DeltaDetector for HybridDetector {
    fn detect(&self, cache: &StateCache, files: &[std::path::PathBuf]) -> DeltaPlan {
        use std::collections::HashSet;

        let mut plan = DeltaPlan::default();
        let cached_files: HashSet<_> = cache.files().into_iter().collect();
        let current_files: HashSet<_> = files.iter().cloned().collect();

        // Deleted files
        for path in cached_files.difference(&current_files) {
            plan.deleted.push(path.clone());
        }

        // New files
        for path in current_files.difference(&cached_files) {
            plan.new.push(path.clone());
        }

        // Check existing files for changes
        for path in current_files.intersection(&cached_files) {
            if let Some(state) = cache.get(path) {
                // Quick mtime check first
                if let Ok(meta) = std::fs::metadata(path) {
                    let mtime = meta.modified()
                        .map(|t| t.duration_since(std::time::UNIX_EPOCH).unwrap_or_default().as_secs())
                        .unwrap_or(0);

                    if mtime > state.mtime {
                        // Mtime changed - verify with hash
                        if let Ok(content) = std::fs::read_to_string(path) {
                            let hash = Self::hash_content(&content);
                            if hash != state.content_hash {
                                plan.analyze.push(path.clone());
                            } else {
                                plan.reuse.push(path.clone());
                            }
                        } else {
                            plan.analyze.push(path.clone());
                        }
                    } else {
                        plan.reuse.push(path.clone());
                    }
                } else {
                    plan.deleted.push(path.clone());
                }
            } else {
                plan.new.push(path.clone());
            }
        }

        // New files need analysis
        plan.analyze.extend(plan.new.drain(..));

        plan
    }

    fn name(&self) -> &str {
        "Hybrid"
    }
}

impl HybridDetector {
    fn hash_content(content: &str) -> String {
        use sha2::{Sha256, Digest};
        let mut hasher = Sha256::new();
        hasher.update(content.as_bytes());
        format!("{:x}", hasher.finalize())[..16].to_string()
    }
}
