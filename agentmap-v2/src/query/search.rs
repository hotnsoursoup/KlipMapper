//! Query builder and parallel search.

use std::sync::Arc;
use rayon::prelude::*;
use parking_lot::Mutex;

use crate::core::{CodeAnalysis, Result};
use super::matcher::{SymbolMatcher, MatchConfig};
use super::pattern::{Pattern, SearchScope, MatchResult};

/// Aggregated search results.
#[derive(Debug, Default)]
pub struct SearchResults {
    /// Matched symbols sorted by confidence
    pub matches: Vec<MatchResult>,
    /// Total files searched
    pub files_searched: usize,
    /// Search duration in milliseconds
    pub duration_ms: u64,
}

impl SearchResults {
    /// Check if any matches were found.
    pub fn is_empty(&self) -> bool {
        self.matches.is_empty()
    }

    /// Get number of matches.
    pub fn len(&self) -> usize {
        self.matches.len()
    }

    /// Get top K results.
    pub fn top(&self, k: usize) -> Vec<&MatchResult> {
        self.matches.iter().take(k).collect()
    }
}

/// Builder for constructing symbol queries.
pub struct QueryBuilder {
    patterns: Vec<Pattern>,
    config: MatchConfig,
    top_k: Option<usize>,
}

impl QueryBuilder {
    /// Create a new query builder.
    pub fn new() -> Self {
        Self {
            patterns: Vec::new(),
            config: MatchConfig::default(),
            top_k: None,
        }
    }

    /// Set case sensitivity.
    pub fn case_sensitive(mut self, sensitive: bool) -> Self {
        self.config.case_sensitive = sensitive;
        self
    }

    /// Limit results to top K.
    pub fn top(mut self, k: usize) -> Self {
        self.top_k = Some(k);
        self
    }

    /// Add a glob pattern.
    pub fn glob(mut self, pattern: impl Into<String>) -> Self {
        self.patterns.push(Pattern::glob(pattern));
        self
    }

    /// Add a glob pattern with scope.
    pub fn glob_scope(mut self, pattern: impl Into<String>, scope: SearchScope) -> Self {
        self.patterns.push(Pattern::glob(pattern).with_scope(scope));
        self
    }

    /// Add a regex pattern.
    pub fn regex(mut self, pattern: impl Into<String>) -> Self {
        self.patterns.push(Pattern::regex(pattern));
        self
    }

    /// Add a regex pattern with scope.
    pub fn regex_scope(mut self, pattern: impl Into<String>, scope: SearchScope) -> Self {
        self.patterns.push(Pattern::regex(pattern).with_scope(scope));
        self
    }

    /// Add a fuzzy pattern.
    pub fn fuzzy(mut self, pattern: impl Into<String>, threshold: f32) -> Self {
        self.patterns.push(Pattern::fuzzy(pattern, threshold));
        self
    }

    /// Add a fuzzy pattern with scope.
    pub fn fuzzy_scope(mut self, pattern: impl Into<String>, threshold: f32, scope: SearchScope) -> Self {
        self.patterns.push(Pattern::fuzzy(pattern, threshold).with_scope(scope));
        self
    }

    /// Add an exact match pattern.
    pub fn exact(mut self, pattern: impl Into<String>) -> Self {
        self.patterns.push(Pattern::exact(pattern));
        self
    }

    /// Add an exact match pattern with scope.
    pub fn exact_scope(mut self, pattern: impl Into<String>, scope: SearchScope) -> Self {
        self.patterns.push(Pattern::exact(pattern).with_scope(scope));
        self
    }

    /// Add a custom pattern.
    pub fn pattern(mut self, pattern: Pattern) -> Self {
        self.patterns.push(pattern);
        self
    }

    /// Execute the search sequentially.
    pub fn search(self, analyses: &[CodeAnalysis]) -> Result<SearchResults> {
        let start = std::time::Instant::now();
        let matcher = SymbolMatcher::with_config(self.config);

        let mut all_results = Vec::new();
        for analysis in analyses {
            for pattern in &self.patterns {
                if let Ok(results) = matcher.search_analysis(analysis, pattern) {
                    all_results.extend(results);
                }
            }
        }

        // Sort by confidence and remove duplicates
        all_results.sort_by(|a, b| b.confidence.partial_cmp(&a.confidence).unwrap_or(std::cmp::Ordering::Equal));
        all_results.dedup_by_key(|r| r.symbol.id.clone());

        // Apply top K limit
        if let Some(k) = self.top_k {
            all_results.truncate(k);
        }

        Ok(SearchResults {
            matches: all_results,
            files_searched: analyses.len(),
            duration_ms: start.elapsed().as_millis() as u64,
        })
    }

    /// Execute the search in parallel.
    pub fn search_parallel(self, analyses: &[CodeAnalysis]) -> Result<SearchResults> {
        let start = std::time::Instant::now();
        let matcher = Arc::new(SymbolMatcher::with_config(self.config));
        let patterns = Arc::new(self.patterns);

        let results: Vec<Vec<MatchResult>> = analyses
            .par_iter()
            .map(|analysis| {
                let mut analysis_results = Vec::new();
                for pattern in patterns.iter() {
                    if let Ok(results) = matcher.search_analysis(analysis, pattern) {
                        analysis_results.extend(results);
                    }
                }
                analysis_results
            })
            .collect();

        let mut all_results: Vec<MatchResult> = results.into_iter().flatten().collect();

        // Sort by confidence and remove duplicates
        all_results.sort_by(|a, b| b.confidence.partial_cmp(&a.confidence).unwrap_or(std::cmp::Ordering::Equal));
        all_results.dedup_by_key(|r| r.symbol.id.clone());

        // Apply top K limit
        if let Some(k) = self.top_k {
            all_results.truncate(k);
        }

        Ok(SearchResults {
            matches: all_results,
            files_searched: analyses.len(),
            duration_ms: start.elapsed().as_millis() as u64,
        })
    }

    /// Execute search with parallel top K (memory efficient).
    pub fn search_parallel_top_k(self, analyses: &[CodeAnalysis], k: usize) -> Result<SearchResults> {
        if k == 0 {
            return Ok(SearchResults::default());
        }

        let start = std::time::Instant::now();
        let matcher = Arc::new(SymbolMatcher::with_config(self.config));
        let patterns = Arc::new(self.patterns);
        let top_results = Arc::new(Mutex::new(Vec::with_capacity(k * 2)));

        analyses
            .par_iter()
            .for_each(|analysis| {
                let mut local_results = Vec::new();
                for pattern in patterns.iter() {
                    if let Ok(results) = matcher.search_analysis(analysis, pattern) {
                        local_results.extend(results);
                    }
                }

                // Merge local results into global top K
                if !local_results.is_empty() {
                    local_results.sort_by(|a, b| b.confidence.partial_cmp(&a.confidence).unwrap_or(std::cmp::Ordering::Equal));

                    let mut global = top_results.lock();
                    global.extend(local_results.into_iter().take(k));
                    global.sort_by(|a, b| b.confidence.partial_cmp(&a.confidence).unwrap_or(std::cmp::Ordering::Equal));
                    global.truncate(k * 2); // Keep some buffer for merging
                }
            });

        let mut final_results = match Arc::try_unwrap(top_results) {
            Ok(mutex) => mutex.into_inner(),
            Err(arc) => arc.lock().clone(),
        };

        final_results.sort_by(|a, b| b.confidence.partial_cmp(&a.confidence).unwrap_or(std::cmp::Ordering::Equal));
        final_results.dedup_by_key(|r| r.symbol.id.clone());
        final_results.truncate(k);

        Ok(SearchResults {
            matches: final_results,
            files_searched: analyses.len(),
            duration_ms: start.elapsed().as_millis() as u64,
        })
    }
}

impl Default for QueryBuilder {
    fn default() -> Self {
        Self::new()
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::core::{Symbol, SymbolKind, SourceLocation, Visibility};
    use crate::parser::Language;
    use std::path::PathBuf;

    fn create_test_analysis() -> CodeAnalysis {
        let mut analysis = CodeAnalysis::new(PathBuf::from("test.rs"), Language::Rust);
        analysis.symbols.push(
            Symbol::new("UserService", SymbolKind::Class, SourceLocation::new(PathBuf::from("test.rs"), 1, 10))
        );
        analysis.symbols.push(
            Symbol::new("create_user", SymbolKind::Function, SourceLocation::new(PathBuf::from("test.rs"), 15, 20))
        );
        analysis.symbols.push(
            Symbol::new("MAX_USERS", SymbolKind::Constant, SourceLocation::new(PathBuf::from("test.rs"), 25, 26))
        );
        analysis
    }

    #[test]
    fn test_sequential_search() {
        let analyses = vec![create_test_analysis()];

        let results = QueryBuilder::new()
            .glob("User*")
            .search(&analyses)
            .unwrap();

        assert_eq!(results.len(), 1);
        assert_eq!(results.matches[0].symbol.name, "UserService");
    }

    #[test]
    fn test_parallel_search() {
        let analyses = vec![create_test_analysis()];

        let results = QueryBuilder::new()
            .glob("create_*")
            .search_parallel(&analyses)
            .unwrap();

        assert_eq!(results.len(), 1);
        assert_eq!(results.matches[0].symbol.name, "create_user");
    }

    #[test]
    fn test_multiple_patterns() {
        let analyses = vec![create_test_analysis()];

        let results = QueryBuilder::new()
            .glob("User*")
            .glob("create_*")
            .search(&analyses)
            .unwrap();

        assert_eq!(results.len(), 2);
    }

    #[test]
    fn test_top_k() {
        let analyses = vec![create_test_analysis()];

        let results = QueryBuilder::new()
            .glob("*")
            .top(1)
            .search(&analyses)
            .unwrap();

        assert_eq!(results.len(), 1);
    }

    #[test]
    fn test_regex_search() {
        let analyses = vec![create_test_analysis()];

        // Case-sensitive search for ALL_CAPS pattern
        let results = QueryBuilder::new()
            .case_sensitive(true)
            .regex(r"^[A-Z_]+$")
            .search(&analyses)
            .unwrap();

        assert_eq!(results.len(), 1);
        assert_eq!(results.matches[0].symbol.name, "MAX_USERS");
    }
}
