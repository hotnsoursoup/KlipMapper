//! Symbol pattern matcher with caching.

use std::sync::Arc;
use std::num::NonZeroUsize;
use regex::Regex;
use parking_lot::Mutex;
use lru::LruCache;
use anyhow::{Result, Context};

use crate::core::{Symbol, CodeAnalysis};
use super::pattern::{Pattern, PatternType, SearchScope, MatchResult, MatchLocation, RankingBreakdown};

/// Cache metrics for monitoring.
#[derive(Debug, Clone, Default)]
pub struct CacheMetrics {
    /// Number of cache hits
    pub hits: usize,
    /// Number of cache misses
    pub misses: usize,
    /// Number of evictions
    pub evictions: usize,
    /// Current cache size
    pub current_size: usize,
}

/// Configuration for pattern matching.
#[derive(Debug, Clone)]
pub struct MatchConfig {
    /// Case-sensitive matching
    pub case_sensitive: bool,
    /// Cache capacity for compiled patterns
    pub cache_capacity: usize,
    /// Feature weights for ranking
    pub weights: FeatureWeights,
}

impl Default for MatchConfig {
    fn default() -> Self {
        Self {
            case_sensitive: false,
            cache_capacity: 1024,
            weights: FeatureWeights::default(),
        }
    }
}

/// Weights for ranking features.
#[derive(Debug, Clone)]
pub struct FeatureWeights {
    /// Weight for prefix match bonus
    pub prefix_weight: f32,
    /// Weight for camelCase token overlap
    pub camel_case_weight: f32,
    /// Weight for snake_case token overlap
    pub snake_case_weight: f32,
    /// Weight for length difference penalty
    pub length_penalty_weight: f32,
}

impl Default for FeatureWeights {
    fn default() -> Self {
        Self {
            prefix_weight: 0.3,
            camel_case_weight: 0.2,
            snake_case_weight: 0.2,
            length_penalty_weight: 0.1,
        }
    }
}

/// Symbol pattern matcher with LRU caching.
pub struct SymbolMatcher {
    /// LRU cache for compiled regex patterns
    pattern_cache: Arc<Mutex<LruCache<String, Regex>>>,
    /// Cache metrics
    metrics: Arc<Mutex<CacheMetrics>>,
    /// Configuration
    config: MatchConfig,
}

impl SymbolMatcher {
    /// Create a new matcher with default config.
    pub fn new() -> Self {
        Self::with_config(MatchConfig::default())
    }

    /// Create a matcher with custom config.
    pub fn with_config(config: MatchConfig) -> Self {
        let capacity = NonZeroUsize::new(config.cache_capacity.max(1)).unwrap();
        Self {
            pattern_cache: Arc::new(Mutex::new(LruCache::new(capacity))),
            metrics: Arc::new(Mutex::new(CacheMetrics::default())),
            config,
        }
    }

    /// Get current cache metrics.
    pub fn cache_metrics(&self) -> CacheMetrics {
        self.metrics.lock().clone()
    }

    /// Clear the pattern cache.
    pub fn clear_cache(&self) {
        self.pattern_cache.lock().clear();
        *self.metrics.lock() = CacheMetrics::default();
    }

    /// Search symbols in an analysis result.
    pub fn search_analysis(
        &self,
        analysis: &CodeAnalysis,
        pattern: &Pattern,
    ) -> Result<Vec<MatchResult>> {
        let mut results = Vec::new();
        let file_path = analysis.file_path.to_string_lossy().to_string();

        for symbol in &analysis.symbols {
            if let Some(result) = self.match_symbol(symbol, pattern, &file_path)? {
                results.push(result);
            }
        }

        // Sort by confidence (descending)
        results.sort_by(|a, b| b.confidence.partial_cmp(&a.confidence).unwrap_or(std::cmp::Ordering::Equal));

        Ok(results)
    }

    /// Search symbols across multiple analyses.
    pub fn search_all(
        &self,
        analyses: &[CodeAnalysis],
        pattern: &Pattern,
    ) -> Result<Vec<MatchResult>> {
        let mut results = Vec::new();

        for analysis in analyses {
            results.extend(self.search_analysis(analysis, pattern)?);
        }

        // Sort by confidence (descending)
        results.sort_by(|a, b| b.confidence.partial_cmp(&a.confidence).unwrap_or(std::cmp::Ordering::Equal));

        Ok(results)
    }

    /// Match a single symbol against a pattern.
    fn match_symbol(
        &self,
        symbol: &Symbol,
        pattern: &Pattern,
        file_path: &str,
    ) -> Result<Option<MatchResult>> {
        let (text, location) = match pattern.scope {
            SearchScope::Names => (symbol.name.clone(), MatchLocation::Name),
            SearchScope::Kinds => (symbol.kind.to_string(), MatchLocation::Kind),
            SearchScope::Paths => (file_path.to_string(), MatchLocation::Path),
            SearchScope::Qualified => {
                let qualified = format!("{}::{}", file_path, symbol.name);
                (qualified, MatchLocation::Qualified)
            }
            SearchScope::Code => (symbol.code_content.clone(), MatchLocation::Code),
            SearchScope::All => {
                // Try all scopes and return the best match
                let scopes = [
                    SearchScope::Names,
                    SearchScope::Kinds,
                    SearchScope::Paths,
                    SearchScope::Qualified,
                ];

                let mut best_match: Option<MatchResult> = None;
                for scope in scopes {
                    let scoped_pattern = Pattern {
                        pattern: pattern.pattern.clone(),
                        scope,
                        pattern_type: pattern.pattern_type.clone(),
                    };
                    if let Some(result) = self.match_symbol(symbol, &scoped_pattern, file_path)? {
                        if best_match.as_ref().map(|m| result.confidence > m.confidence).unwrap_or(true) {
                            best_match = Some(result);
                        }
                    }
                }
                return Ok(best_match);
            }
        };

        // Apply case sensitivity
        let (text, pattern_str) = if self.config.case_sensitive {
            (text, pattern.pattern.clone())
        } else {
            (text.to_lowercase(), pattern.pattern.to_lowercase())
        };

        // Get base similarity score
        let base_score = match &pattern.pattern_type {
            PatternType::Glob => {
                let regex = self.glob_to_regex(&pattern_str)?;
                if regex.is_match(&text) { 1.0 } else { 0.0 }
            }
            PatternType::Regex => {
                let regex = self.get_or_compile_regex(&pattern_str)?;
                if regex.is_match(&text) { 1.0 } else { 0.0 }
            }
            PatternType::Exact => {
                if text == pattern_str { 1.0 } else { 0.0 }
            }
            PatternType::Fuzzy(threshold) => {
                let similarity = self.fuzzy_similarity(&text, &pattern_str);
                if similarity >= *threshold { similarity } else { 0.0 }
            }
        };

        if base_score > 0.0 {
            let ranking = self.calculate_ranking(&text, &pattern_str, base_score);
            Ok(Some(MatchResult {
                symbol: symbol.clone(),
                location,
                match_text: text,
                confidence: ranking.final_score,
                file_path: file_path.to_string(),
                ranking,
            }))
        } else {
            Ok(None)
        }
    }

    /// Convert a glob pattern to regex.
    fn glob_to_regex(&self, glob: &str) -> Result<Regex> {
        let cache_key = format!("glob:{}", glob);

        // Check cache
        {
            let mut cache = self.pattern_cache.lock();
            if let Some(regex) = cache.get(&cache_key) {
                self.metrics.lock().hits += 1;
                return Ok(regex.clone());
            }
        }

        self.metrics.lock().misses += 1;

        // Convert glob to regex
        let mut regex_pattern = String::from("^");
        let chars: Vec<char> = glob.chars().collect();
        let mut i = 0;

        while i < chars.len() {
            match chars[i] {
                '*' => {
                    // Check for ** (recursive)
                    if i + 1 < chars.len() && chars[i + 1] == '*' {
                        regex_pattern.push_str(".*");
                        i += 2;
                    } else {
                        regex_pattern.push_str("[^/]*");
                        i += 1;
                    }
                }
                '?' => {
                    regex_pattern.push_str("[^/]");
                    i += 1;
                }
                '[' => {
                    // Character class
                    let start = i;
                    i += 1;
                    while i < chars.len() && chars[i] != ']' {
                        i += 1;
                    }
                    if i < chars.len() {
                        let class: String = chars[start..=i].iter().collect();
                        regex_pattern.push_str(&class);
                        i += 1;
                    } else {
                        regex_pattern.push_str(r"\[");
                        i = start + 1;
                    }
                }
                c if "(){}^$|.+\\".contains(c) => {
                    regex_pattern.push('\\');
                    regex_pattern.push(c);
                    i += 1;
                }
                c => {
                    regex_pattern.push(c);
                    i += 1;
                }
            }
        }
        regex_pattern.push('$');

        let regex = Regex::new(&regex_pattern)
            .with_context(|| format!("Failed to compile glob pattern: {}", glob))?;

        // Cache the regex
        {
            let mut cache = self.pattern_cache.lock();
            let was_evicted = cache.len() == cache.cap().get();
            cache.put(cache_key, regex.clone());
            let mut metrics = self.metrics.lock();
            if was_evicted {
                metrics.evictions += 1;
            }
            metrics.current_size = cache.len();
        }

        Ok(regex)
    }

    /// Get or compile a regex pattern.
    fn get_or_compile_regex(&self, pattern: &str) -> Result<Regex> {
        let cache_key = format!("regex:{}", pattern);

        // Check cache
        {
            let mut cache = self.pattern_cache.lock();
            if let Some(regex) = cache.get(&cache_key) {
                self.metrics.lock().hits += 1;
                return Ok(regex.clone());
            }
        }

        self.metrics.lock().misses += 1;

        let regex = Regex::new(pattern)
            .with_context(|| format!("Failed to compile regex: {}", pattern))?;

        // Cache the regex
        {
            let mut cache = self.pattern_cache.lock();
            let was_evicted = cache.len() == cache.cap().get();
            cache.put(cache_key, regex.clone());
            let mut metrics = self.metrics.lock();
            if was_evicted {
                metrics.evictions += 1;
            }
            metrics.current_size = cache.len();
        }

        Ok(regex)
    }

    /// Calculate fuzzy similarity between two strings.
    fn fuzzy_similarity(&self, text: &str, pattern: &str) -> f32 {
        if text.is_empty() && pattern.is_empty() {
            return 1.0;
        }
        if text.is_empty() || pattern.is_empty() {
            return 0.0;
        }
        if text == pattern {
            return 1.0;
        }

        // Simple character overlap (Jaccard-style)
        use std::collections::HashSet;
        let text_chars: HashSet<char> = text.chars().collect();
        let pattern_chars: HashSet<char> = pattern.chars().collect();

        let intersection = text_chars.intersection(&pattern_chars).count();
        let union = text_chars.union(&pattern_chars).count();

        if union == 0 {
            0.0
        } else {
            intersection as f32 / union as f32
        }
    }

    /// Calculate ranking with feature bonuses.
    fn calculate_ranking(&self, text: &str, pattern: &str, base_score: f32) -> RankingBreakdown {
        let prefix_bonus = self.calculate_prefix_bonus(text, pattern);
        let camel_case_bonus = self.calculate_camel_case_overlap(text, pattern);
        let snake_case_bonus = self.calculate_snake_case_overlap(text, pattern);
        let length_penalty = self.calculate_length_penalty(text, pattern);

        let weights = &self.config.weights;
        let final_score = base_score
            + (prefix_bonus * weights.prefix_weight)
            + (camel_case_bonus * weights.camel_case_weight)
            + (snake_case_bonus * weights.snake_case_weight)
            - (length_penalty * weights.length_penalty_weight);

        let final_score = final_score.clamp(0.0, 1.0);

        RankingBreakdown {
            base_score,
            prefix_bonus,
            camel_case_bonus,
            snake_case_bonus,
            length_penalty,
            final_score,
        }
    }

    /// Calculate prefix match bonus.
    fn calculate_prefix_bonus(&self, text: &str, pattern: &str) -> f32 {
        if pattern.is_empty() || text.is_empty() {
            return 0.0;
        }

        let text_lower = text.to_lowercase();
        let pattern_lower = pattern.to_lowercase();

        if text_lower.starts_with(&pattern_lower) {
            (pattern_lower.len() as f32 / text_lower.len() as f32).min(1.0)
        } else {
            let common = text_lower
                .chars()
                .zip(pattern_lower.chars())
                .take_while(|(a, b)| a == b)
                .count();
            if common > 0 {
                (common as f32 / pattern_lower.len() as f32) * 0.5
            } else {
                0.0
            }
        }
    }

    /// Calculate camelCase token overlap.
    fn calculate_camel_case_overlap(&self, text: &str, pattern: &str) -> f32 {
        let text_tokens = self.extract_camel_case_tokens(text);
        let pattern_tokens = self.extract_camel_case_tokens(pattern);

        if text_tokens.is_empty() || pattern_tokens.is_empty() {
            return 0.0;
        }

        let matches = pattern_tokens
            .iter()
            .filter(|t| text_tokens.contains(t))
            .count();

        matches as f32 / pattern_tokens.len() as f32
    }

    /// Extract camelCase tokens from text.
    fn extract_camel_case_tokens(&self, text: &str) -> Vec<String> {
        let mut tokens = Vec::new();
        let mut current = String::new();

        for ch in text.chars() {
            if ch.is_uppercase() && !current.is_empty() {
                tokens.push(current.to_lowercase());
                current = ch.to_string();
            } else {
                current.push(ch);
            }
        }

        if !current.is_empty() {
            tokens.push(current.to_lowercase());
        }

        tokens
    }

    /// Calculate snake_case token overlap.
    fn calculate_snake_case_overlap(&self, text: &str, pattern: &str) -> f32 {
        let text_tokens: Vec<_> = text.split('_').filter(|s| !s.is_empty()).map(|s| s.to_lowercase()).collect();
        let pattern_tokens: Vec<_> = pattern.split('_').filter(|s| !s.is_empty()).map(|s| s.to_lowercase()).collect();

        if text_tokens.is_empty() || pattern_tokens.is_empty() {
            return 0.0;
        }

        let matches = pattern_tokens
            .iter()
            .filter(|t| text_tokens.contains(t))
            .count();

        matches as f32 / pattern_tokens.len() as f32
    }

    /// Calculate length difference penalty.
    fn calculate_length_penalty(&self, text: &str, pattern: &str) -> f32 {
        if pattern.is_empty() {
            return 0.0;
        }

        let diff = (text.len() as isize - pattern.len() as isize).abs() as f32;
        let max_len = text.len().max(pattern.len()) as f32;

        if max_len == 0.0 {
            0.0
        } else {
            (diff / max_len).min(1.0)
        }
    }
}

impl Default for SymbolMatcher {
    fn default() -> Self {
        Self::new()
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::core::{SymbolKind, SourceLocation, Visibility};
    use std::path::PathBuf;

    fn create_test_symbol(name: &str, kind: SymbolKind) -> Symbol {
        Symbol::new(
            name,
            kind,
            SourceLocation::new(PathBuf::from("test.rs"), 1, 10),
        )
    }

    #[test]
    fn test_glob_matching() {
        let matcher = SymbolMatcher::new();
        let symbol = create_test_symbol("UserService", SymbolKind::Class);
        let pattern = Pattern::glob("User*");

        let result = matcher.match_symbol(&symbol, &pattern, "test.rs").unwrap();
        assert!(result.is_some());
        let result = result.unwrap();
        assert_eq!(result.symbol.name, "UserService");
        assert!(result.confidence > 0.0);
    }

    #[test]
    fn test_exact_matching() {
        let matcher = SymbolMatcher::new();
        let symbol = create_test_symbol("test_function", SymbolKind::Function);
        let pattern = Pattern::exact("test_function");

        let result = matcher.match_symbol(&symbol, &pattern, "test.rs").unwrap();
        assert!(result.is_some());
    }

    #[test]
    fn test_fuzzy_matching() {
        let matcher = SymbolMatcher::new();
        let symbol = create_test_symbol("UserService", SymbolKind::Class);
        let pattern = Pattern::fuzzy("UserSrv", 0.3);

        let result = matcher.match_symbol(&symbol, &pattern, "test.rs").unwrap();
        assert!(result.is_some());
    }

    #[test]
    fn test_regex_matching() {
        let matcher = SymbolMatcher::new();
        let symbol = create_test_symbol("MAX_USERS", SymbolKind::Constant);
        let pattern = Pattern::regex(r"^[A-Z_]+$");

        let result = matcher.match_symbol(&symbol, &pattern, "test.rs").unwrap();
        assert!(result.is_some());
    }

    #[test]
    fn test_cache_hit() {
        let matcher = SymbolMatcher::new();

        // First call - miss
        let _ = matcher.glob_to_regex("test*").unwrap();
        let metrics = matcher.cache_metrics();
        assert_eq!(metrics.misses, 1);
        assert_eq!(metrics.hits, 0);

        // Second call - hit
        let _ = matcher.glob_to_regex("test*").unwrap();
        let metrics = matcher.cache_metrics();
        assert_eq!(metrics.hits, 1);
    }

    #[test]
    fn test_prefix_bonus() {
        let matcher = SymbolMatcher::new();
        let bonus = matcher.calculate_prefix_bonus("UserService", "User");
        assert!(bonus > 0.0);
    }

    #[test]
    fn test_camel_case_extraction() {
        let matcher = SymbolMatcher::new();
        let tokens = matcher.extract_camel_case_tokens("UserService");
        assert_eq!(tokens, vec!["user", "service"]);
    }
}
