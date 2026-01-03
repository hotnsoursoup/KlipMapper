//! State cache for incremental analysis.

use std::collections::HashMap;
use std::path::{Path, PathBuf};
use serde::{Serialize, Deserialize};

/// Cached state of a file.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct FileState {
    pub path: PathBuf,
    pub content_hash: String,
    pub mtime: u64,
    pub size: u64,
    pub output_hash: String,
}

/// State cache stored on disk.
pub struct StateCache {
    pub cache_path: PathBuf,
    states: HashMap<PathBuf, FileState>,
}

impl StateCache {
    /// Create new cache.
    pub fn new(cache_path: PathBuf) -> Self {
        let states = Self::load_from_disk(&cache_path).unwrap_or_default();
        Self { cache_path, states }
    }

    /// Get state for a file.
    pub fn get(&self, path: &Path) -> Option<&FileState> {
        self.states.get(path)
    }

    /// Set state for a file.
    pub fn set(&mut self, state: FileState) {
        self.states.insert(state.path.clone(), state);
    }

    /// Remove state for a file.
    pub fn remove(&mut self, path: &Path) {
        self.states.remove(path);
    }

    /// Get all cached file paths.
    pub fn files(&self) -> Vec<PathBuf> {
        self.states.keys().cloned().collect()
    }

    /// Save cache to disk.
    pub fn save(&self) -> std::io::Result<()> {
        let json = serde_json::to_string_pretty(&self.states)?;
        if let Some(parent) = self.cache_path.parent() {
            std::fs::create_dir_all(parent)?;
        }
        std::fs::write(&self.cache_path, json)?;
        Ok(())
    }

    fn load_from_disk(path: &Path) -> Option<HashMap<PathBuf, FileState>> {
        let content = std::fs::read_to_string(path).ok()?;
        serde_json::from_str(&content).ok()
    }
}
