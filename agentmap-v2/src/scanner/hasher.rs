//! Content hashing for incremental update detection.

use sha2::{Digest, Sha256};
use std::collections::HashMap;
use std::path::{Path, PathBuf};
use parking_lot::RwLock;

/// Content hasher for tracking file changes.
///
/// Uses SHA-256 truncated to 16 hex chars for compact storage.
#[derive(Default)]
pub struct ContentHasher {
    /// Cache of path -> content hash
    cache: RwLock<HashMap<PathBuf, String>>,
}

impl ContentHasher {
    /// Create a new content hasher.
    pub fn new() -> Self {
        Self::default()
    }

    /// Compute hash of content (SHA-256, first 16 hex chars).
    pub fn hash(content: &str) -> String {
        let digest = Sha256::digest(content.as_bytes());
        format!("{:x}", digest)[..16].to_string()
    }

    /// Compute and cache hash for a file path.
    pub fn hash_file(&self, path: &Path, content: &str) -> String {
        let hash = Self::hash(content);
        self.cache.write().insert(path.to_path_buf(), hash.clone());
        hash
    }

    /// Check if content has changed from cached hash.
    pub fn has_changed(&self, path: &Path, content: &str) -> bool {
        let new_hash = Self::hash(content);
        let cache = self.cache.read();
        match cache.get(path) {
            Some(cached) => cached != &new_hash,
            None => true, // Not in cache = treat as changed
        }
    }

    /// Get cached hash for a path.
    pub fn get_hash(&self, path: &Path) -> Option<String> {
        self.cache.read().get(path).cloned()
    }

    /// Update cache with new hash.
    pub fn update(&self, path: &Path, hash: String) {
        self.cache.write().insert(path.to_path_buf(), hash);
    }

    /// Clear the cache.
    pub fn clear(&self) {
        self.cache.write().clear();
    }

    /// Get number of cached entries.
    pub fn len(&self) -> usize {
        self.cache.read().len()
    }

    /// Check if cache is empty.
    pub fn is_empty(&self) -> bool {
        self.cache.read().is_empty()
    }

    /// Load cached hashes from a sidecar manifest.
    pub fn load_manifest(&self, manifest: &HashMap<PathBuf, String>) {
        let mut cache = self.cache.write();
        for (path, hash) in manifest {
            cache.insert(path.clone(), hash.clone());
        }
    }

    /// Export current cache as manifest.
    pub fn export_manifest(&self) -> HashMap<PathBuf, String> {
        self.cache.read().clone()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_hash_deterministic() {
        let h1 = ContentHasher::hash("fn main() {}");
        let h2 = ContentHasher::hash("fn main() {}");
        assert_eq!(h1, h2);
        assert_eq!(h1.len(), 16);
    }

    #[test]
    fn test_hash_different_content() {
        let h1 = ContentHasher::hash("fn main() {}");
        let h2 = ContentHasher::hash("fn test() {}");
        assert_ne!(h1, h2);
    }

    #[test]
    fn test_has_changed() {
        let hasher = ContentHasher::new();
        let path = Path::new("test.rs");

        // First time - always changed
        assert!(hasher.has_changed(path, "fn main() {}"));

        // Cache it
        hasher.hash_file(path, "fn main() {}");

        // Same content - not changed
        assert!(!hasher.has_changed(path, "fn main() {}"));

        // Different content - changed
        assert!(hasher.has_changed(path, "fn test() {}"));
    }
}
