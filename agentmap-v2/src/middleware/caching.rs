//! Caching middleware for performance.

use std::collections::HashMap;
use std::sync::Arc;
use parking_lot::RwLock;
use crate::core::{Result, CodeAnalysis};
use super::{Middleware, Context};

/// Middleware that caches analysis results.
///
/// Uses content hash as cache key for invalidation.
pub struct CachingMiddleware {
    cache: Arc<RwLock<HashMap<String, CacheEntry>>>,
    max_entries: usize,
}

/// A cached analysis result.
#[derive(Clone)]
struct CacheEntry {
    analysis: CodeAnalysis,
    hits: u64,
}

impl CachingMiddleware {
    /// Create a new caching middleware with default settings.
    pub fn new() -> Self {
        Self {
            cache: Arc::new(RwLock::new(HashMap::new())),
            max_entries: 1000,
        }
    }

    /// Create with a specific cache size limit.
    pub fn with_max_entries(max_entries: usize) -> Self {
        Self {
            cache: Arc::new(RwLock::new(HashMap::new())),
            max_entries,
        }
    }

    /// Get a cached result by content hash.
    pub fn get(&self, content_hash: &str) -> Option<CodeAnalysis> {
        let mut cache = self.cache.write();
        if let Some(entry) = cache.get_mut(content_hash) {
            entry.hits += 1;
            return Some(entry.analysis.clone());
        }
        None
    }

    /// Store a result in the cache.
    pub fn set(&self, content_hash: String, analysis: CodeAnalysis) {
        let mut cache = self.cache.write();

        // Evict if at capacity (LRU-ish based on hit count)
        if cache.len() >= self.max_entries {
            // Find entry with lowest hits
            if let Some(key) = cache.iter()
                .min_by_key(|(_, e)| e.hits)
                .map(|(k, _)| k.clone())
            {
                cache.remove(&key);
            }
        }

        cache.insert(content_hash, CacheEntry {
            analysis,
            hits: 0,
        });
    }

    /// Get cache statistics.
    pub fn stats(&self) -> CacheStats {
        let cache = self.cache.read();
        let total_hits: u64 = cache.values().map(|e| e.hits).sum();
        CacheStats {
            entries: cache.len(),
            total_hits,
            max_entries: self.max_entries,
        }
    }

    /// Clear the cache.
    pub fn clear(&self) {
        self.cache.write().clear();
    }
}

/// Cache statistics.
#[derive(Debug, Clone)]
pub struct CacheStats {
    pub entries: usize,
    pub total_hits: u64,
    pub max_entries: usize,
}

impl Default for CachingMiddleware {
    fn default() -> Self {
        Self::new()
    }
}

impl Middleware for CachingMiddleware {
    fn before_parse(&self, ctx: &mut Context) -> Result<()> {
        // Pre-compute content hash for cache lookup
        // The actual cache check happens in the analyzer
        ctx.set("cache_middleware_enabled", true);
        Ok(())
    }

    fn after_analyze(&self, ctx: &Context, analysis: &CodeAnalysis) -> Result<()> {
        // Cache the analysis result
        if !analysis.metadata.content_hash.is_empty() {
            self.set(analysis.metadata.content_hash.clone(), analysis.clone());
        }
        Ok(())
    }

    fn name(&self) -> &str {
        "CachingMiddleware"
    }
}
