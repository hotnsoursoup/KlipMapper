//! Metrics middleware for monitoring.

use std::sync::atomic::{AtomicU64, Ordering};
use std::sync::Arc;
use parking_lot::RwLock;
use crate::core::{Result, CodeAnalysis};
use crate::parser::ParsedFile;
use super::{Middleware, Context};

/// Middleware that collects analysis metrics.
pub struct MetricsMiddleware {
    inner: Arc<MetricsInner>,
}

struct MetricsInner {
    files_parsed: AtomicU64,
    files_analyzed: AtomicU64,
    total_symbols: AtomicU64,
    total_relationships: AtomicU64,
    total_parse_time_ms: AtomicU64,
    total_analyze_time_ms: AtomicU64,
    language_counts: RwLock<std::collections::HashMap<String, u64>>,
}

impl MetricsMiddleware {
    /// Create a new metrics middleware.
    pub fn new() -> Self {
        Self {
            inner: Arc::new(MetricsInner {
                files_parsed: AtomicU64::new(0),
                files_analyzed: AtomicU64::new(0),
                total_symbols: AtomicU64::new(0),
                total_relationships: AtomicU64::new(0),
                total_parse_time_ms: AtomicU64::new(0),
                total_analyze_time_ms: AtomicU64::new(0),
                language_counts: RwLock::new(std::collections::HashMap::new()),
            }),
        }
    }

    /// Get current metrics snapshot.
    pub fn snapshot(&self) -> MetricsSnapshot {
        MetricsSnapshot {
            files_parsed: self.inner.files_parsed.load(Ordering::Relaxed),
            files_analyzed: self.inner.files_analyzed.load(Ordering::Relaxed),
            total_symbols: self.inner.total_symbols.load(Ordering::Relaxed),
            total_relationships: self.inner.total_relationships.load(Ordering::Relaxed),
            total_parse_time_ms: self.inner.total_parse_time_ms.load(Ordering::Relaxed),
            total_analyze_time_ms: self.inner.total_analyze_time_ms.load(Ordering::Relaxed),
            language_counts: self.inner.language_counts.read().clone(),
        }
    }

    /// Reset all metrics.
    pub fn reset(&self) {
        self.inner.files_parsed.store(0, Ordering::Relaxed);
        self.inner.files_analyzed.store(0, Ordering::Relaxed);
        self.inner.total_symbols.store(0, Ordering::Relaxed);
        self.inner.total_relationships.store(0, Ordering::Relaxed);
        self.inner.total_parse_time_ms.store(0, Ordering::Relaxed);
        self.inner.total_analyze_time_ms.store(0, Ordering::Relaxed);
        self.inner.language_counts.write().clear();
    }
}

/// Snapshot of current metrics.
#[derive(Debug, Clone)]
pub struct MetricsSnapshot {
    pub files_parsed: u64,
    pub files_analyzed: u64,
    pub total_symbols: u64,
    pub total_relationships: u64,
    pub total_parse_time_ms: u64,
    pub total_analyze_time_ms: u64,
    pub language_counts: std::collections::HashMap<String, u64>,
}

impl MetricsSnapshot {
    /// Get average parse time per file.
    pub fn avg_parse_time_ms(&self) -> f64 {
        if self.files_parsed == 0 {
            0.0
        } else {
            self.total_parse_time_ms as f64 / self.files_parsed as f64
        }
    }

    /// Get average analyze time per file.
    pub fn avg_analyze_time_ms(&self) -> f64 {
        if self.files_analyzed == 0 {
            0.0
        } else {
            self.total_analyze_time_ms as f64 / self.files_analyzed as f64
        }
    }

    /// Get average symbols per file.
    pub fn avg_symbols_per_file(&self) -> f64 {
        if self.files_analyzed == 0 {
            0.0
        } else {
            self.total_symbols as f64 / self.files_analyzed as f64
        }
    }
}

impl Default for MetricsMiddleware {
    fn default() -> Self {
        Self::new()
    }
}

impl Clone for MetricsMiddleware {
    fn clone(&self) -> Self {
        Self {
            inner: Arc::clone(&self.inner),
        }
    }
}

impl Middleware for MetricsMiddleware {
    fn after_parse(&self, ctx: &Context, parsed: &ParsedFile) -> Result<()> {
        self.inner.files_parsed.fetch_add(1, Ordering::Relaxed);
        self.inner.total_parse_time_ms.fetch_add(ctx.elapsed_ms(), Ordering::Relaxed);

        // Track language usage
        let lang = parsed.language.to_string();
        let mut counts = self.inner.language_counts.write();
        *counts.entry(lang).or_insert(0) += 1;

        Ok(())
    }

    fn after_analyze(&self, ctx: &Context, analysis: &CodeAnalysis) -> Result<()> {
        self.inner.files_analyzed.fetch_add(1, Ordering::Relaxed);
        self.inner.total_symbols.fetch_add(analysis.symbols.len() as u64, Ordering::Relaxed);
        self.inner.total_relationships.fetch_add(analysis.relationships.len() as u64, Ordering::Relaxed);
        self.inner.total_analyze_time_ms.fetch_add(ctx.elapsed_ms(), Ordering::Relaxed);

        Ok(())
    }

    fn name(&self) -> &str {
        "MetricsMiddleware"
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_metrics_snapshot() {
        let metrics = MetricsMiddleware::new();
        let snapshot = metrics.snapshot();
        assert_eq!(snapshot.files_parsed, 0);
        assert_eq!(snapshot.files_analyzed, 0);
    }
}
