//! Middleware context for passing data between phases.

use std::path::{Path, PathBuf};
use std::collections::HashMap;
use std::any::Any;

/// Context passed through middleware chain.
pub struct Context {
    /// Path being processed.
    pub path: PathBuf,

    /// Start time (for timing).
    pub start: std::time::Instant,

    /// Key-value store for middleware data.
    data: HashMap<String, Box<dyn Any + Send + Sync>>,
}

impl Context {
    /// Create a new context.
    pub fn new(path: &Path) -> Self {
        Self {
            path: path.to_path_buf(),
            start: std::time::Instant::now(),
            data: HashMap::new(),
        }
    }

    /// Set a value in the context.
    pub fn set<T: Any + Send + Sync>(&mut self, key: &str, value: T) {
        self.data.insert(key.to_string(), Box::new(value));
    }

    /// Get a value from the context.
    pub fn get<T: Any>(&self, key: &str) -> Option<&T> {
        self.data.get(key).and_then(|v| v.downcast_ref())
    }

    /// Get elapsed time in milliseconds.
    pub fn elapsed_ms(&self) -> u64 {
        self.start.elapsed().as_millis() as u64
    }
}
