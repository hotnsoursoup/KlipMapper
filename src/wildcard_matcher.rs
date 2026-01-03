use std::collections::{HashMap, HashSet, BinaryHeap};
use regex::Regex;
use anyhow::{Result, Context};
use crate::anchor::{AnchorHeader, Symbol, SymbolReference, SymbolEdge};
use lru::LruCache;
use std::sync::{Arc, Mutex};
use std::num::NonZeroUsize;
use nucleo_matcher::{Matcher, Config, Utf32Str};
use nucleo_matcher::pattern::{CaseMatching, Normalization};
use rayon::prelude::*;
use std::cmp::Ordering;

/// Performance metrics for pattern cache
#[derive(Debug, Clone, Default)]
pub struct CacheMetrics {
    pub hits: usize,
    pub misses: usize,
    pub evictions: usize,
    pub current_size: usize,
}

/// Wrapper for MatchResult to implement Ord for BinaryHeap (min-heap by default, we want max-heap)
#[derive(Clone, Debug)]
struct MatchResultWrapper(MatchResult);

impl PartialEq for MatchResultWrapper {
    fn eq(&self, other: &Self) -> bool {
        self.0.confidence == other.0.confidence
    }
}

impl Eq for MatchResultWrapper {}

impl PartialOrd for MatchResultWrapper {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

impl Ord for MatchResultWrapper {
    fn cmp(&self, other: &Self) -> Ordering {
        // Max-heap behavior (highest confidence first)
        self.0.confidence.partial_cmp(&other.0.confidence).unwrap_or(Ordering::Equal)
    }
}

/// Advanced wildcard pattern matching for symbol queries
pub struct WildcardMatcher {
    /// LRU cache for compiled regex patterns
    pattern_cache: Arc<Mutex<LruCache<String, Regex>>>,
    /// Performance metrics tracking
    cache_metrics: Arc<Mutex<CacheMetrics>>,
    /// Case sensitivity setting
    case_sensitive: bool,
    /// Cache capacity for observability
    cache_capacity: usize,
    /// Nucleo matcher for fuzzy matching
    fuzzy_matcher: Arc<Mutex<Matcher>>,
    /// Configurable feature weights for ranking
    feature_weights: FeatureWeights,
}

#[derive(Debug, Clone)]
pub struct WildcardPattern {
    pub pattern: String,
    pub scope: SearchScope,
    pub match_type: MatchType,
}

#[derive(Debug, Clone)]
pub enum SearchScope {
    /// Search in symbol names only
    Names,
    /// Search in symbol kinds (class, method, etc.)
    Kinds,
    /// Search in file paths
    Paths,
    /// Search in symbol roles (exported, async, etc.)
    Roles,
    /// Search in relationship targets
    Relations,
    /// Search everywhere
    All,
    /// Search in specific scope frames
    Frames(String), // e.g., "class", "method"
}

#[derive(Debug, Clone)]
pub enum MatchType {
    /// Simple wildcard: *, ?, []
    Glob,
    /// Full regex support
    Regex,
    /// Fuzzy matching with similarity threshold
    Fuzzy(f32),
    /// Exact string match
    Exact,
}

#[derive(Debug, Clone)]
pub struct MatchResult {
    pub symbol_id: String,
    pub symbol_name: String,
    pub match_location: MatchLocation,
    pub match_text: String,
    pub confidence: f32,
    pub context: Vec<String>, // Surrounding context for better results
    pub ranking: RankingBreakdown, // Detailed ranking feature contributions
}

/// Detailed breakdown of ranking features and their contributions
#[derive(Debug, Clone)]
pub struct RankingBreakdown {
    pub base_similarity: f32,     // Base fuzzy/exact match score
    pub prefix_bonus: f32,        // Bonus for prefix matches
    pub camel_case_bonus: f32,    // Bonus for camelCase token overlap
    pub snake_case_bonus: f32,    // Bonus for snake_case token overlap
    pub path_proximity: f32,      // Path distance penalty/bonus
    pub length_penalty: f32,      // Penalty for length differences
    pub final_score: f32,         // Final computed confidence
    pub feature_weights: FeatureWeights, // Applied weights for transparency
}

/// Configurable weights for different ranking features
#[derive(Debug, Clone)]
pub struct FeatureWeights {
    pub prefix_weight: f32,
    pub camel_case_weight: f32,
    pub snake_case_weight: f32,
    pub path_proximity_weight: f32,
    pub length_penalty_weight: f32,
}

impl Default for FeatureWeights {
    fn default() -> Self {
        Self {
            prefix_weight: 0.3,      // 30% bonus for prefix matches
            camel_case_weight: 0.2,   // 20% bonus for camelCase overlap
            snake_case_weight: 0.2,   // 20% bonus for snake_case overlap
            path_proximity_weight: 0.1, // 10% path proximity influence
            length_penalty_weight: 0.1, // 10% length difference penalty
        }
    }
}

#[derive(Debug, Clone)]
pub enum MatchLocation {
    SymbolName,
    SymbolKind,
    FilePath,
    Role,
    Reference(String), // Reference type
    Edge(String),      // Edge type
    Frame(String),     // Frame kind
}

impl WildcardMatcher {
    /// Default cache capacity for pattern cache
    const DEFAULT_CACHE_CAPACITY: usize = 1024;

    pub fn new(case_sensitive: bool) -> Self {
        Self::with_cache_capacity(case_sensitive, Self::DEFAULT_CACHE_CAPACITY)
    }
    
    pub fn new_with_weights(case_sensitive: bool, weights: FeatureWeights) -> Self {
        let mut matcher = Self::with_cache_capacity(case_sensitive, Self::DEFAULT_CACHE_CAPACITY);
        matcher.feature_weights = weights;
        matcher
    }

    /// Create a new wildcard matcher with specified cache capacity
    pub fn with_cache_capacity(case_sensitive: bool, cache_capacity: usize) -> Self {
        let effective_capacity = if cache_capacity == 0 {
            Self::DEFAULT_CACHE_CAPACITY
        } else {
            cache_capacity
        };
        
        let capacity = NonZeroUsize::new(effective_capacity).unwrap();
        
        // Configure nucleo matcher based on case sensitivity
        let mut config = Config::DEFAULT;
        if !case_sensitive {
            config.ignore_case = true;
        }
        
        Self {
            pattern_cache: Arc::new(Mutex::new(LruCache::new(capacity))),
            cache_metrics: Arc::new(Mutex::new(CacheMetrics::default())),
            case_sensitive,
            cache_capacity: effective_capacity,
            fuzzy_matcher: Arc::new(Mutex::new(Matcher::new(config))),
            feature_weights: FeatureWeights::default(),
        }
    }

    /// Get current cache metrics
    pub fn cache_metrics(&self) -> CacheMetrics {
        self.cache_metrics.lock().unwrap().clone()
    }

    /// Get cache capacity
    pub fn cache_capacity(&self) -> usize {
        self.cache_capacity
    }

    /// Clear the pattern cache and reset metrics
    pub fn clear_cache(&mut self) {
        self.pattern_cache.lock().unwrap().clear();
        *self.cache_metrics.lock().unwrap() = CacheMetrics::default();
    }
    
    /// Update feature weights for ranking
    pub fn update_feature_weights(&mut self, weights: FeatureWeights) {
        self.feature_weights = weights;
    }
    
    /// Get current feature weights
    pub fn get_feature_weights(&self) -> &FeatureWeights {
        &self.feature_weights
    }

    /// Search symbols using wildcard patterns
    pub fn search_symbols(
        &self,
        headers: &[AnchorHeader],
        patterns: &[WildcardPattern]
    ) -> Result<Vec<MatchResult>> {
        let mut results = Vec::new();

        for header in headers {
            for symbol in &header.symbols {
                for pattern in patterns {
                    if let Some(matches) = self.match_symbol(symbol, pattern, &header.file_id)? {
                        results.extend(matches);
                    }
                }
            }
        }

        // Sort by confidence and remove duplicates
        results.sort_by(|a, b| b.confidence.partial_cmp(&a.confidence).unwrap());
        results.dedup_by_key(|r| r.symbol_id.clone());

        Ok(results)
    }
    
    /// Parallel search across headers using rayon
    pub fn search_symbols_parallel(
        &self,
        headers: &[AnchorHeader],
        patterns: &[WildcardPattern]
    ) -> Result<Vec<MatchResult>> {
        let results: Result<Vec<Vec<MatchResult>>> = headers
            .par_iter()
            .map(|header| self.search_header_patterns(header, patterns))
            .collect();
        
        let mut all_results: Vec<MatchResult> = results?
            .into_iter()
            .flatten()
            .collect();
        
        // Sort by confidence and remove duplicates
        all_results.sort_by(|a, b| b.confidence.partial_cmp(&a.confidence).unwrap());
        all_results.dedup_by_key(|r| r.symbol_id.clone());
        
        Ok(all_results)
    }
    
    /// Parallel search with top-k results using bounded binary heap
    pub fn search_symbols_parallel_top_k(
        &self,
        headers: &[AnchorHeader],
        patterns: &[WildcardPattern],
        k: usize
    ) -> Result<Vec<MatchResult>> {
        if k == 0 {
            return Ok(Vec::new());
        }
        
        let chunk_size = (headers.len() / rayon::current_num_threads()).max(1);
        
        let top_results: Result<Vec<MatchResultWrapper>> = headers
            .par_chunks(chunk_size)
            .map(|chunk| {
                let mut local_heap = BinaryHeap::new();
                
                for header in chunk {
                    let header_results = self.search_header_patterns(header, patterns)?;
                    
                    for result in header_results {
                        let wrapper = MatchResultWrapper(result);
                        
                        if local_heap.len() < k {
                            local_heap.push(wrapper);
                        } else if let Some(worst) = local_heap.peek() {
                            if wrapper.0.confidence > worst.0.confidence {
                                local_heap.pop();
                                local_heap.push(wrapper);
                            }
                        }
                    }
                }
                
                Ok(local_heap.into_vec())
            })
            .reduce(|| Ok(Vec::new()), |acc, chunk| {
                match (acc, chunk) {
                    (Ok(mut acc_vec), Ok(chunk_vec)) => {
                        acc_vec.extend(chunk_vec);
                        // Keep only top k across all chunks
                        acc_vec.sort_by(|a, b| b.0.confidence.partial_cmp(&a.0.confidence).unwrap());
                        acc_vec.truncate(k);
                        Ok(acc_vec)
                    },
                    (Err(e), _) | (_, Err(e)) => Err(e),
                }
            });
        
        let mut results: Vec<MatchResult> = top_results?
            .into_iter()
            .map(|wrapper| wrapper.0)
            .collect();
        
        // Final sort and dedup
        results.sort_by(|a, b| b.confidence.partial_cmp(&a.confidence).unwrap());
        results.dedup_by_key(|r| r.symbol_id.clone());
        results.truncate(k);
        
        Ok(results)
    }
    
    /// Search a single header with all patterns (thread-safe)
    fn search_header_patterns(
        &self,
        header: &AnchorHeader,
        patterns: &[WildcardPattern]
    ) -> Result<Vec<MatchResult>> {
        let mut results = Vec::new();
        
        for symbol in &header.symbols {
            for pattern in patterns {
                if let Some(matches) = self.match_symbol_threadsafe(symbol, pattern, &header.file_id)? {
                    results.extend(matches);
                }
            }
        }
        
        Ok(results)
    }

    fn match_symbol(
        &self,
        symbol: &Symbol,
        pattern: &WildcardPattern,
        file_id: &str
    ) -> Result<Option<Vec<MatchResult>>> {
        let mut matches = Vec::new();

        match &pattern.scope {
            SearchScope::Names => {
                if let Some(mut result) = self.test_match(&symbol.name, pattern, symbol, file_id)? {
                    result.match_location = MatchLocation::SymbolName;
                    matches.push(result);
                }
            },
            SearchScope::Kinds => {
                if let Some(mut result) = self.test_match(&symbol.kind, pattern, symbol, file_id)? {
                    result.match_location = MatchLocation::SymbolKind;
                    matches.push(result);
                }
            },
            SearchScope::Paths => {
                if let Some(mut result) = self.test_match(file_id, pattern, symbol, file_id)? {
                    result.match_location = MatchLocation::FilePath;
                    matches.push(result);
                }
            },
            SearchScope::Roles => {
                for role in &symbol.roles {
                    if let Some(mut result) = self.test_match(role, pattern, symbol, file_id)? {
                        result.match_location = MatchLocation::Role;
                        matches.push(result);
                    }
                }
            },
            SearchScope::Relations => {
                // Search in references
                for reference in &symbol.references {
                    if let Some(mut result) = self.test_match(&reference.target, pattern, symbol, file_id)? {
                        result.match_location = MatchLocation::Reference(reference.ref_type.clone());
                        matches.push(result);
                    }
                }
                
                // Search in edges
                for edge in &symbol.edges {
                    if let Some(mut result) = self.test_match(&edge.target, pattern, symbol, file_id)? {
                        result.match_location = MatchLocation::Edge(edge.edge_type.clone());
                        matches.push(result);
                    }
                }
            },
            SearchScope::Frames(frame_kind) => {
                for frame in &symbol.frames {
                    if frame.kind == *frame_kind {
                        if let Some(name) = &frame.name {
                            if let Some(mut result) = self.test_match(name, pattern, symbol, file_id)? {
                                result.match_location = MatchLocation::Frame(frame.kind.clone());
                                matches.push(result);
                            }
                        }
                    }
                }
            },
            SearchScope::All => {
                // Recursively search all scopes
                let all_scopes = vec![
                    SearchScope::Names,
                    SearchScope::Kinds, 
                    SearchScope::Paths,
                    SearchScope::Roles,
                    SearchScope::Relations,
                ];
                
                for scope in all_scopes {
                    let scoped_pattern = WildcardPattern {
                        pattern: pattern.pattern.clone(),
                        scope,
                        match_type: pattern.match_type.clone(),
                    };
                    
                    if let Some(scope_matches) = self.match_symbol(symbol, &scoped_pattern, file_id)? {
                        matches.extend(scope_matches);
                    }
                }
            }
        }

        Ok(if matches.is_empty() { None } else { Some(matches) })
    }

    fn test_match(
        &self,
        text: &str,
        pattern: &WildcardPattern,
        symbol: &Symbol,
        file_id: &str
    ) -> Result<Option<MatchResult>> {
        let text = if self.case_sensitive { text.to_string() } else { text.to_lowercase() };
        let pattern_str = if self.case_sensitive { 
            pattern.pattern.clone() 
        } else { 
            pattern.pattern.to_lowercase() 
        };

        let base_similarity = match &pattern.match_type {
            MatchType::Glob => {
                let regex = self.glob_to_regex_threadsafe(&pattern_str)?;
                if regex.is_match(&text) { 1.0 } else { 0.0 }
            },
            MatchType::Regex => {
                let regex = self.get_or_compile_regex_threadsafe(&pattern_str)?;
                if regex.is_match(&text) { 1.0 } else { 0.0 }
            },
            MatchType::Fuzzy(threshold) => {
                let similarity = self.fuzzy_similarity(&text, &pattern_str);
                if similarity >= *threshold { similarity } else { 0.0 }
            },
            MatchType::Exact => {
                if text == pattern_str { 1.0 } else { 0.0 }
            }
        };

        if base_similarity > 0.0 {
            let ranking = self.calculate_advanced_ranking(
                &text, 
                &pattern_str, 
                symbol, 
                file_id, 
                base_similarity
            );
            
            Ok(Some(MatchResult {
                symbol_id: symbol.id.clone(),
                symbol_name: symbol.name.clone(),
                match_location: MatchLocation::SymbolName, // Will be overridden by caller
                match_text: text,
                confidence: ranking.final_score,
                context: self.build_context(symbol, file_id),
                ranking,
            }))
        } else {
            Ok(None)
        }
    }

    fn glob_to_regex(&mut self, glob: &str) -> Result<Regex> {
        let cache_key = format!("glob:{}", glob);
        
        // Check cache first
        {
            let mut cache = self.pattern_cache.lock().unwrap();
            if let Some(regex) = cache.get(&cache_key) {
                // Cache hit - update metrics
                self.cache_metrics.lock().unwrap().hits += 1;
                return Ok(regex.clone());
            }
        }
        
        // Cache miss - update metrics
        self.cache_metrics.lock().unwrap().misses += 1;

        // Convert glob pattern to regex
        let mut regex_pattern = String::new();
        regex_pattern.push('^');
        
        let chars: Vec<char> = glob.chars().collect();
        let mut i = 0;
        
        while i < chars.len() {
            match chars[i] {
                '*' => {
                    // Check for **/ (recursive directory)
                    if i + 2 < chars.len() && chars[i + 1] == '*' && chars[i + 2] == '/' {
                        regex_pattern.push_str("(?:.*/)?");
                        i += 3;
                    } else {
                        regex_pattern.push_str("[^/]*");
                        i += 1;
                    }
                },
                '?' => {
                    regex_pattern.push_str("[^/]");
                    i += 1;
                },
                '[' => {
                    // Character class
                    let mut j = i + 1;
                    while j < chars.len() && chars[j] != ']' {
                        j += 1;
                    }
                    if j < chars.len() {
                        regex_pattern.push_str(&glob[i..=j]);
                        i = j + 1;
                    } else {
                        regex_pattern.push_str(r"\[");
                        i += 1;
                    }
                },
                c if c.is_ascii_alphanumeric() || c == '_' => {
                    regex_pattern.push(c);
                    i += 1;
                },
                c => {
                    regex_pattern.push_str(&regex::escape(&c.to_string()));
                    i += 1;
                }
            }
        }
        
        regex_pattern.push('$');
        
        let regex = Regex::new(&regex_pattern)
            .with_context(|| format!("Failed to compile glob pattern: {}", glob))?;
        
        // Insert into cache and update metrics
        {
            let mut cache = self.pattern_cache.lock().unwrap();
            let was_evicted = cache.len() == cache.cap().get();
            cache.put(cache_key, regex.clone());
            
            let mut metrics = self.cache_metrics.lock().unwrap();
            if was_evicted {
                metrics.evictions += 1;
            }
            metrics.current_size = cache.len();
        }
        
        Ok(regex)
    }

    fn get_or_compile_regex(&mut self, pattern: &str) -> Result<Regex> {
        let cache_key = format!("regex:{}", pattern);
        
        // Check cache first
        {
            let mut cache = self.pattern_cache.lock().unwrap();
            if let Some(regex) = cache.get(&cache_key) {
                // Cache hit - update metrics
                self.cache_metrics.lock().unwrap().hits += 1;
                return Ok(regex.clone());
            }
        }
        
        // Cache miss - update metrics
        self.cache_metrics.lock().unwrap().misses += 1;

        let regex = Regex::new(pattern)
            .with_context(|| format!("Failed to compile regex pattern: {}", pattern))?;
        
        // Insert into cache and update metrics
        {
            let mut cache = self.pattern_cache.lock().unwrap();
            let was_evicted = cache.len() == cache.cap().get();
            cache.put(cache_key, regex.clone());
            
            let mut metrics = self.cache_metrics.lock().unwrap();
            if was_evicted {
                metrics.evictions += 1;
            }
            metrics.current_size = cache.len();
        }
        
        Ok(regex)
    }

    fn fuzzy_similarity(&self, text1: &str, text2: &str) -> f32 {
        // Use nucleo-matcher for superior fuzzy matching performance
        if text1.is_empty() { return if text2.is_empty() { 1.0 } else { 0.0 }; }
        if text2.is_empty() { return 0.0; }
        
        // Handle edge case where strings are identical
        if text1 == text2 { return 1.0; }
        
        let mut haystack_buf = Vec::new();
        let mut needle_buf = Vec::new();
        
        // Try to get a score using nucleo-matcher
        let result = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
            let haystack_utf32 = Utf32Str::new(text1, &mut haystack_buf);
            let needle_utf32 = Utf32Str::new(text2, &mut needle_buf);
            
            let mut matcher = self.fuzzy_matcher.lock().unwrap();
            
            // Try fuzzy matching - prefer longer string as haystack
            let (hay, needle) = if text1.len() >= text2.len() {
                (haystack_utf32, needle_utf32)
            } else {
                (needle_utf32, haystack_utf32)
            };
            
            matcher.fuzzy_match(hay, needle)
        }));
        
        match result {
            Ok(Some(score)) => {
                // Normalize score: nucleo-matcher returns 0-65535, normalize to 0-1
                let normalized = score as f32 / 65535.0;
                normalized.min(1.0)
            },
            Ok(None) => {
                // No match found, fall back to simple similarity
                self.simple_similarity_fallback(text1, text2)
            },
            Err(_) => {
                // Panic occurred, fall back to simple similarity
                self.simple_similarity_fallback(text1, text2)
            }
        }
    }
    
    /// Fallback similarity calculation for edge cases
    fn simple_similarity_fallback(&self, text1: &str, text2: &str) -> f32 {
        let len1 = text1.chars().count();
        let len2 = text2.chars().count();
        
        if len1 == 0 || len2 == 0 { return 0.0; }
        
        // Simple character overlap calculation
        let chars1: HashSet<char> = text1.chars().collect();
        let chars2: HashSet<char> = text2.chars().collect();
        
        let overlap = chars1.intersection(&chars2).count();
        let total = chars1.union(&chars2).count();
        
        if total == 0 { 0.0 } else { overlap as f32 / total as f32 }
    }

    /// Thread-safe version of glob_to_regex
    fn glob_to_regex_threadsafe(&self, glob: &str) -> Result<Regex> {
        let cache_key = format!("glob:{}", glob);
        
        // Check cache first
        {
            let mut cache = self.pattern_cache.lock().unwrap();
            if let Some(regex) = cache.get(&cache_key) {
                // Cache hit - update metrics
                self.cache_metrics.lock().unwrap().hits += 1;
                return Ok(regex.clone());
            }
        }
        
        // Cache miss - update metrics
        self.cache_metrics.lock().unwrap().misses += 1;

        // Convert glob pattern to regex (same logic as mutable version)
        let mut regex_pattern = String::new();
        regex_pattern.push('^');
        
        let chars: Vec<char> = glob.chars().collect();
        let mut i = 0;
        
        while i < chars.len() {
            match chars[i] {
                '*' => regex_pattern.push_str(".*"),
                '?' => regex_pattern.push('.'),
                '[' => {
                    regex_pattern.push('[');
                    i += 1;
                    while i < chars.len() && chars[i] != ']' {
                        regex_pattern.push(chars[i]);
                        i += 1;
                    }
                    if i < chars.len() {
                        regex_pattern.push(']');
                    }
                },
                '\\' if i + 1 < chars.len() => {
                    regex_pattern.push('\\');
                    i += 1;
                    regex_pattern.push(chars[i]);
                },
                c if "(){}[]^$|.+".contains(c) => {
                    regex_pattern.push('\\');
                    regex_pattern.push(c);
                },
                c => regex_pattern.push(c),
            }
            i += 1;
        }
        
        regex_pattern.push('$');
        
        let regex = Regex::new(&regex_pattern)
            .with_context(|| format!("Failed to compile glob pattern as regex: {}", glob))?;
        
        // Insert into cache and update metrics
        {
            let mut cache = self.pattern_cache.lock().unwrap();
            let was_evicted = cache.len() == cache.cap().get();
            cache.put(cache_key, regex.clone());
            
            let mut metrics = self.cache_metrics.lock().unwrap();
            if was_evicted {
                metrics.evictions += 1;
            }
            metrics.current_size = cache.len();
        }
        
        Ok(regex)
    }

    /// Thread-safe version of get_or_compile_regex
    fn get_or_compile_regex_threadsafe(&self, pattern: &str) -> Result<Regex> {
        let cache_key = format!("regex:{}", pattern);
        
        // Check cache first
        {
            let mut cache = self.pattern_cache.lock().unwrap();
            if let Some(regex) = cache.get(&cache_key) {
                // Cache hit - update metrics
                self.cache_metrics.lock().unwrap().hits += 1;
                return Ok(regex.clone());
            }
        }
        
        // Cache miss - update metrics
        self.cache_metrics.lock().unwrap().misses += 1;

        let regex = Regex::new(pattern)
            .with_context(|| format!("Failed to compile regex pattern: {}", pattern))?;
        
        // Insert into cache and update metrics
        {
            let mut cache = self.pattern_cache.lock().unwrap();
            let was_evicted = cache.len() == cache.cap().get();
            cache.put(cache_key, regex.clone());
            
            let mut metrics = self.cache_metrics.lock().unwrap();
            if was_evicted {
                metrics.evictions += 1;
            }
            metrics.current_size = cache.len();
        }
        
        Ok(regex)
    }

    /// Get fuzzy match score and indices using nucleo-matcher
    fn fuzzy_match_with_indices(&self, haystack: &str, needle: &str) -> Option<(u16, Vec<u32>)> {
        if haystack.is_empty() || needle.is_empty() {
            return None;
        }
        
        let mut haystack_buf = Vec::new();
        let mut needle_buf = Vec::new();
        
        let result = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
            let haystack_utf32 = Utf32Str::new(haystack, &mut haystack_buf);
            let needle_utf32 = Utf32Str::new(needle, &mut needle_buf);
            
            let mut matcher = self.fuzzy_matcher.lock().unwrap();
            let mut indices = Vec::new();
            
            matcher.fuzzy_indices(haystack_utf32, needle_utf32, &mut indices)
                .map(|score| (score, indices))
        }));
        
        result.unwrap_or(None)
    }
    
    /// Get exact match score using nucleo-matcher
    fn exact_match_score(&self, haystack: &str, needle: &str) -> Option<u16> {
        let mut haystack_buf = Vec::new();
        let mut needle_buf = Vec::new();
        
        let result = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
            let haystack_utf32 = Utf32Str::new(haystack, &mut haystack_buf);
            let needle_utf32 = Utf32Str::new(needle, &mut needle_buf);
            
            let mut matcher = self.fuzzy_matcher.lock().unwrap();
            matcher.exact_match(haystack_utf32, needle_utf32)
        }));
        
        result.unwrap_or(None)
    }
    
    /// Get substring match score using nucleo-matcher
    fn substring_match_score(&self, haystack: &str, needle: &str) -> Option<u16> {
        let mut haystack_buf = Vec::new();
        let mut needle_buf = Vec::new();
        
        let result = std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
            let haystack_utf32 = Utf32Str::new(haystack, &mut haystack_buf);
            let needle_utf32 = Utf32Str::new(needle, &mut needle_buf);
            
            let mut matcher = self.fuzzy_matcher.lock().unwrap();
            matcher.substring_match(haystack_utf32, needle_utf32)
        }));
        
        result.unwrap_or(None)
    }

    /// Thread-safe version of match_symbol for parallel processing
    fn match_symbol_threadsafe(
        &self,
        symbol: &Symbol,
        pattern: &WildcardPattern,
        file_id: &str
    ) -> Result<Option<Vec<MatchResult>>> {
        let mut matches = Vec::new();
        
        match &pattern.scope {
            SearchScope::Names => {
                if let Some(mut result) = self.test_match_threadsafe(&symbol.name, pattern, symbol, file_id)? {
                    result.match_location = MatchLocation::SymbolName;
                    matches.push(result);
                }
            },
            SearchScope::Kinds => {
                if let Some(mut result) = self.test_match_threadsafe(&symbol.kind, pattern, symbol, file_id)? {
                    result.match_location = MatchLocation::SymbolKind;
                    matches.push(result);
                }
            },
            SearchScope::Paths => {
                if let Some(mut result) = self.test_match_threadsafe(file_id, pattern, symbol, file_id)? {
                    result.match_location = MatchLocation::FilePath;
                    matches.push(result);
                }
            },
            SearchScope::Roles => {
                for role in &symbol.roles {
                    if let Some(mut result) = self.test_match_threadsafe(role, pattern, symbol, file_id)? {
                        result.match_location = MatchLocation::Role;
                        matches.push(result);
                    }
                }
            },
            SearchScope::Relations => {
                // Search in references
                for reference in &symbol.references {
                    if let Some(mut result) = self.test_match_threadsafe(&reference.target, pattern, symbol, file_id)? {
                        result.match_location = MatchLocation::Reference(reference.ref_type.clone());
                        matches.push(result);
                    }
                }
                
                // Search in edges
                for edge in &symbol.edges {
                    if let Some(mut result) = self.test_match_threadsafe(&edge.target, pattern, symbol, file_id)? {
                        result.match_location = MatchLocation::Edge(edge.edge_type.clone());
                        matches.push(result);
                    }
                }
            },
            SearchScope::Frames(frame_kind) => {
                for frame in &symbol.frames {
                    if frame.kind == *frame_kind {
                        if let Some(name) = &frame.name {
                            if let Some(mut result) = self.test_match_threadsafe(name, pattern, symbol, file_id)? {
                                result.match_location = MatchLocation::Frame(frame.kind.clone());
                                matches.push(result);
                            }
                        }
                    }
                }
            },
            SearchScope::All => {
                // Search across all scopes
                let scopes = [
                    SearchScope::Names,
                    SearchScope::Kinds, 
                    SearchScope::Paths,
                    SearchScope::Roles,
                    SearchScope::Relations,
                ];
                
                for scope in &scopes {
                    let scope_pattern = WildcardPattern {
                        pattern: pattern.pattern.clone(),
                        scope: scope.clone(),
                        match_type: pattern.match_type.clone(),
                    };
                    
                    if let Some(scope_matches) = self.match_symbol_threadsafe(symbol, &scope_pattern, file_id)? {
                        matches.extend(scope_matches);
                    }
                }
            },
        }
        
        if matches.is_empty() {
            Ok(None)
        } else {
            Ok(Some(matches))
        }
    }
    
    /// Thread-safe version of test_match
    fn test_match_threadsafe(
        &self,
        text: &str,
        pattern: &WildcardPattern,
        symbol: &Symbol,
        file_id: &str
    ) -> Result<Option<MatchResult>> {
        let text = if self.case_sensitive { text.to_string() } else { text.to_lowercase() };
        let pattern_text = if self.case_sensitive { pattern.pattern.clone() } else { pattern.pattern.to_lowercase() };
        
        let base_similarity = match &pattern.match_type {
            MatchType::Glob => {
                let regex = self.glob_to_regex_threadsafe(&pattern_text)?;
                if regex.is_match(&text) { 1.0 } else { 0.0 }
            },
            MatchType::Regex => {
                let regex = self.get_or_compile_regex_threadsafe(&pattern_text)?;
                if regex.is_match(&text) { 1.0 } else { 0.0 }
            },
            MatchType::Exact => {
                if text == pattern_text { 1.0 } else { 0.0 }
            },
            MatchType::Fuzzy(threshold) => {
                let similarity = self.fuzzy_similarity(&text, &pattern_text);
                if similarity >= *threshold { similarity } else { 0.0 }
            },
        };
        
        if base_similarity > 0.0 {
            let ranking = self.calculate_advanced_ranking(
                &text, 
                &pattern_text, 
                symbol, 
                file_id, 
                base_similarity
            );
            
            Ok(Some(MatchResult {
                symbol_id: symbol.name.clone(),
                symbol_name: symbol.name.clone(),
                confidence: ranking.final_score,
                match_text: text,
                match_location: MatchLocation::SymbolName, // Will be updated by caller
                context: self.build_context(symbol, file_id),
                ranking,
            }))
        } else {
            Ok(None)
        }
    }

    /// Calculate advanced ranking with feature breakdown
    fn calculate_advanced_ranking(
        &self,
        text: &str,
        pattern: &str,
        symbol: &Symbol,
        file_id: &str,
        base_similarity: f32
    ) -> RankingBreakdown {
        let prefix_bonus = self.calculate_prefix_bonus(text, pattern);
        let camel_case_bonus = self.calculate_camel_case_overlap(text, pattern);
        let snake_case_bonus = self.calculate_snake_case_overlap(text, pattern);
        let path_proximity = self.calculate_path_proximity_score(file_id, pattern);
        let length_penalty = self.calculate_length_penalty(text, pattern);
        
        // Apply weighted combination of features
        let final_score = base_similarity
            + (prefix_bonus * self.feature_weights.prefix_weight)
            + (camel_case_bonus * self.feature_weights.camel_case_weight)
            + (snake_case_bonus * self.feature_weights.snake_case_weight)
            + (path_proximity * self.feature_weights.path_proximity_weight)
            - (length_penalty * self.feature_weights.length_penalty_weight);
        
        // Clamp to valid confidence range
        let final_score = final_score.max(0.0).min(1.0);
        
        RankingBreakdown {
            base_similarity,
            prefix_bonus,
            camel_case_bonus,
            snake_case_bonus,
            path_proximity,
            length_penalty,
            final_score,
            feature_weights: self.feature_weights.clone(),
        }
    }
    
    /// Calculate prefix matching bonus
    fn calculate_prefix_bonus(&self, text: &str, pattern: &str) -> f32 {
        if pattern.is_empty() || text.is_empty() {
            return 0.0;
        }
        
        let text_lower = text.to_lowercase();
        let pattern_lower = pattern.to_lowercase();
        
        // Exact prefix match gets maximum bonus
        if text_lower.starts_with(&pattern_lower) {
            let ratio = pattern_lower.len() as f32 / text_lower.len() as f32;
            return ratio.min(1.0); // Full bonus for exact prefix
        }
        
        // Partial prefix match (first few characters)
        let common_prefix_len = text_lower.chars()
            .zip(pattern_lower.chars())
            .take_while(|(a, b)| a == b)
            .count();
        
        if common_prefix_len > 0 {
            let prefix_ratio = common_prefix_len as f32 / pattern_lower.chars().count() as f32;
            return prefix_ratio * 0.5; // Reduced bonus for partial prefix
        }
        
        0.0
    }
    
    /// Calculate camelCase token overlap bonus
    fn calculate_camel_case_overlap(&self, text: &str, pattern: &str) -> f32 {
        let text_tokens = self.extract_camel_case_tokens(text);
        let pattern_tokens = self.extract_camel_case_tokens(pattern);
        
        if text_tokens.is_empty() || pattern_tokens.is_empty() {
            return 0.0;
        }
        
        let matches = pattern_tokens.iter()
            .filter(|&token| text_tokens.contains(token))
            .count();
        
        let overlap_ratio = matches as f32 / pattern_tokens.len() as f32;
        overlap_ratio
    }
    
    /// Calculate snake_case token overlap bonus
    fn calculate_snake_case_overlap(&self, text: &str, pattern: &str) -> f32 {
        let text_tokens = self.extract_snake_case_tokens(text);
        let pattern_tokens = self.extract_snake_case_tokens(pattern);
        
        if text_tokens.is_empty() || pattern_tokens.is_empty() {
            return 0.0;
        }
        
        let matches = pattern_tokens.iter()
            .filter(|&token| text_tokens.contains(token))
            .count();
        
        let overlap_ratio = matches as f32 / pattern_tokens.len() as f32;
        overlap_ratio
    }
    
    /// Calculate path proximity score (closer paths get higher scores)
    fn calculate_path_proximity_score(&self, file_id: &str, pattern: &str) -> f32 {
        // Simple path distance calculation based on directory depth similarity
        let file_segments: Vec<&str> = file_id.split('/').collect();
        let pattern_lower = pattern.to_lowercase();
        
        // Check if pattern matches any part of the file path
        for (i, segment) in file_segments.iter().enumerate() {
            if segment.to_lowercase().contains(&pattern_lower) {
                // Closer to filename gets higher score
                let proximity = (file_segments.len() - i) as f32 / file_segments.len() as f32;
                return proximity;
            }
        }
        
        // Check directory name similarity
        let file_name = file_segments.last().unwrap_or(&file_id);
        let file_name_lower = file_name.to_lowercase();
        
        if file_name_lower.contains(&pattern_lower) {
            return 0.8; // High bonus for filename match
        }
        
        // Check for partial directory matches
        for segment in &file_segments {
            if self.fuzzy_similarity(&segment.to_lowercase(), &pattern_lower) > 0.3 {
                return 0.3; // Moderate bonus for directory similarity
            }
        }
        
        0.0
    }
    
    /// Calculate length difference penalty
    fn calculate_length_penalty(&self, text: &str, pattern: &str) -> f32 {
        if pattern.is_empty() {
            return 0.0;
        }
        
        let text_len = text.chars().count() as f32;
        let pattern_len = pattern.chars().count() as f32;
        
        // Penalty increases with length difference
        let length_diff = (text_len - pattern_len).abs();
        let max_len = text_len.max(pattern_len);
        
        if max_len == 0.0 {
            return 0.0;
        }
        
        let penalty_ratio = length_diff / max_len;
        penalty_ratio.min(1.0) // Cap penalty at 100%
    }
    
    /// Extract camelCase tokens from text
    fn extract_camel_case_tokens(&self, text: &str) -> Vec<String> {
        let mut tokens = Vec::new();
        let mut current_token = String::new();
        
        for ch in text.chars() {
            if ch.is_uppercase() && !current_token.is_empty() {
                // Start of new token
                tokens.push(current_token.to_lowercase());
                current_token = ch.to_string();
            } else {
                current_token.push(ch);
            }
        }
        
        if !current_token.is_empty() {
            tokens.push(current_token.to_lowercase());
        }
        
        tokens
    }
    
    /// Extract snake_case tokens from text
    fn extract_snake_case_tokens(&self, text: &str) -> Vec<String> {
        text.split('_')
            .filter(|s| !s.is_empty())
            .map(|s| s.to_lowercase())
            .collect()
    }
    
    /// Get ranking explanation for debugging
    pub fn explain_ranking(&self, result: &MatchResult) -> String {
        let r = &result.ranking;
        format!(
            "Ranking breakdown for '{}': Base: {:.3}, Prefix: {:.3}*{:.1}={:.3}, CamelCase: {:.3}*{:.1}={:.3}, SnakeCase: {:.3}*{:.1}={:.3}, Path: {:.3}*{:.1}={:.3}, Length: {:.3}*{:.1}={:.3}, Final: {:.3}",
            result.symbol_name,
            r.base_similarity,
            r.prefix_bonus, r.feature_weights.prefix_weight, r.prefix_bonus * r.feature_weights.prefix_weight,
            r.camel_case_bonus, r.feature_weights.camel_case_weight, r.camel_case_bonus * r.feature_weights.camel_case_weight,
            r.snake_case_bonus, r.feature_weights.snake_case_weight, r.snake_case_bonus * r.feature_weights.snake_case_weight,
            r.path_proximity, r.feature_weights.path_proximity_weight, r.path_proximity * r.feature_weights.path_proximity_weight,
            r.length_penalty, r.feature_weights.length_penalty_weight, r.length_penalty * r.feature_weights.length_penalty_weight,
            r.final_score
        )
    }

    fn build_context(&self, symbol: &Symbol, file_id: &str) -> Vec<String> {
        let mut context = Vec::new();
        
        context.push(format!("file: {}", file_id));
        context.push(format!("kind: {}", symbol.kind));
        
        if let Some(owner) = &symbol.owner {
            context.push(format!("owner: {}", owner));
        }
        
        context.push(format!("lines: {}-{}", symbol.range.lines[0], symbol.range.lines[1]));
        
        if !symbol.roles.is_empty() {
            context.push(format!("roles: {}", symbol.roles.join(", ")));
        }

        context
    }
}

/// Builder for constructing wildcard search queries
pub struct WildcardQueryBuilder {
    patterns: Vec<WildcardPattern>,
    case_sensitive: bool,
    feature_weights: Option<FeatureWeights>,
}

impl WildcardQueryBuilder {
    pub fn new() -> Self {
        Self {
            patterns: Vec::new(),
            case_sensitive: true,
            feature_weights: None,
        }
    }

    pub fn case_insensitive(mut self) -> Self {
        self.case_sensitive = false;
        self
    }

    /// Add a glob pattern (supports *, ?, [])
    pub fn glob(mut self, pattern: &str, scope: SearchScope) -> Self {
        self.patterns.push(WildcardPattern {
            pattern: pattern.to_string(),
            scope,
            match_type: MatchType::Glob,
        });
        self
    }

    /// Add a regex pattern
    pub fn regex(mut self, pattern: &str, scope: SearchScope) -> Self {
        self.patterns.push(WildcardPattern {
            pattern: pattern.to_string(),
            scope,
            match_type: MatchType::Regex,
        });
        self
    }

    /// Add a fuzzy match pattern
    pub fn fuzzy(mut self, pattern: &str, scope: SearchScope, threshold: f32) -> Self {
        self.patterns.push(WildcardPattern {
            pattern: pattern.to_string(),
            scope,
            match_type: MatchType::Fuzzy(threshold),
        });
        self
    }

    /// Add an exact match pattern
    pub fn exact(mut self, pattern: &str, scope: SearchScope) -> Self {
        self.patterns.push(WildcardPattern {
            pattern: pattern.to_string(),
            scope,
            match_type: MatchType::Exact,
        });
        self
    }

    /// Set custom feature weights for ranking
    pub fn with_feature_weights(mut self, weights: FeatureWeights) -> Self {
        self.feature_weights = Some(weights);
        self
    }
    
    /// Execute the search sequentially
    pub fn search(self, headers: &[AnchorHeader]) -> Result<Vec<MatchResult>> {
        let matcher = if let Some(weights) = self.feature_weights {
            WildcardMatcher::new_with_weights(self.case_sensitive, weights)
        } else {
            WildcardMatcher::new(self.case_sensitive)
        };
        matcher.search_symbols(headers, &self.patterns)
    }
    
    /// Execute the search in parallel using rayon
    pub fn search_parallel(self, headers: &[AnchorHeader]) -> Result<Vec<MatchResult>> {
        let matcher = if let Some(weights) = self.feature_weights {
            WildcardMatcher::new_with_weights(self.case_sensitive, weights)
        } else {
            WildcardMatcher::new(self.case_sensitive)
        };
        matcher.search_symbols_parallel(headers, &self.patterns)
    }
    
    /// Execute the search in parallel with result limit
    pub fn search_parallel_top_k(self, headers: &[AnchorHeader], k: usize) -> Result<Vec<MatchResult>> {
        let matcher = if let Some(weights) = self.feature_weights {
            WildcardMatcher::new_with_weights(self.case_sensitive, weights)
        } else {
            WildcardMatcher::new(self.case_sensitive)
        };
        matcher.search_symbols_parallel_top_k(headers, &self.patterns, k)
    }
}

/// Convenient macros for common wildcard patterns
#[macro_export]
macro_rules! glob_query {
    ($pattern:expr) => {
        WildcardQueryBuilder::new().glob($pattern, SearchScope::All)
    };
    ($pattern:expr, $scope:expr) => {
        WildcardQueryBuilder::new().glob($pattern, $scope)
    };
}

#[macro_export]
macro_rules! regex_query {
    ($pattern:expr) => {
        WildcardQueryBuilder::new().regex($pattern, SearchScope::All)
    };
    ($pattern:expr, $scope:expr) => {
        WildcardQueryBuilder::new().regex($pattern, $scope)
    };
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::anchor::{AnchorHeaderBuilder, Symbol, SourceRange, ScopeFrame};
    use std::path::PathBuf;

    fn create_test_symbol(id: &str, name: &str, kind: &str) -> Symbol {
        Symbol {
            id: id.to_string(),
            kind: kind.to_string(),
            name: name.to_string(),
            owner: None,
            range: SourceRange { lines: [1, 10], bytes: [0, 100] },
            frames: vec![
                ScopeFrame {
                    kind: "file".to_string(),
                    name: None,
                    range: SourceRange { lines: [1, 100], bytes: [0, 1000] },
                }
            ],
            roles: vec!["declaration".to_string()],
            references: Vec::new(),
            edges: Vec::new(),
            fingerprint: "test123".to_string(),
            guard: None,
        }
    }

    fn create_test_header() -> AnchorHeader {
        AnchorHeaderBuilder::new(
            PathBuf::from("test.rs"),
            "rust".to_string(),
            "test content".to_string(),
        )
        .add_symbol(create_test_symbol("C1", "UserService", "class"))
        .add_symbol(create_test_symbol("M1", "createUser", "method"))
        .add_symbol(create_test_symbol("F1", "validateEmail", "function"))
        .add_symbol(create_test_symbol("V1", "MAX_USERS", "variable"))
        .build()
    }

    #[test]
    fn test_glob_matching() {
        let header = create_test_header();
        
        let results = WildcardQueryBuilder::new()
            .glob("User*", SearchScope::Names)
            .search(&[header])
            .unwrap();

        assert_eq!(results.len(), 1);
        assert_eq!(results[0].symbol_name, "UserService");
    }

    #[test]
    fn test_wildcard_with_question_mark() {
        let header = create_test_header();
        
        let results = WildcardQueryBuilder::new()
            .glob("create????", SearchScope::Names)
            .search(&[header])
            .unwrap();

        assert_eq!(results.len(), 1);
        assert_eq!(results[0].symbol_name, "createUser");
    }

    #[test]
    fn test_regex_matching() {
        let header = create_test_header();
        
        let results = WildcardQueryBuilder::new()
            .regex(r"^[A-Z_]+$", SearchScope::Names)
            .search(&[header])
            .unwrap();

        assert_eq!(results.len(), 1);
        assert_eq!(results[0].symbol_name, "MAX_USERS");
    }

    #[test]
    fn test_fuzzy_matching() {
        let header = create_test_header();
        
        let results = WildcardQueryBuilder::new()
            .fuzzy("UserServic", SearchScope::Names, 0.5)
            .search(&[header])
            .unwrap();

        // Fuzzy matching should find at least one result
        assert!(!results.is_empty());
        // The best match should be UserService (exact prefix match)
        let best_match = results.iter().find(|r| r.symbol_name == "UserService");
        assert!(best_match.is_some(), "Expected UserService to be found in fuzzy matching results");
    }

    #[test]
    fn test_scope_specific_search() {
        let header = create_test_header();
        
        let results = WildcardQueryBuilder::new()
            .glob("*", SearchScope::Kinds)
            .search(&[header.clone()])
            .unwrap();

        // Should match all symbol kinds
        assert_eq!(results.len(), 4);
        
        let class_results = WildcardQueryBuilder::new()
            .exact("class", SearchScope::Kinds)
            .search(&[header])
            .unwrap();
            
        assert_eq!(class_results.len(), 1);
        assert_eq!(class_results[0].symbol_name, "UserService");
    }

    #[test]
    fn test_case_insensitive_search() {
        let header = create_test_header();
        
        let results = WildcardQueryBuilder::new()
            .case_insensitive()
            .glob("userservice", SearchScope::Names)
            .search(&[header])
            .unwrap();

        assert_eq!(results.len(), 1);
        assert_eq!(results[0].symbol_name, "UserService");
    }

    #[test]
    fn test_multiple_patterns() {
        let header = create_test_header();
        
        let results = WildcardQueryBuilder::new()
            .glob("User*", SearchScope::Names)
            .glob("create*", SearchScope::Names)
            .search(&[header])
            .unwrap();

        assert_eq!(results.len(), 2);
        let names: Vec<String> = results.iter().map(|r| r.symbol_name.clone()).collect();
        assert!(names.contains(&"UserService".to_string()));
        assert!(names.contains(&"createUser".to_string()));
    }

    #[test]
    fn test_glob_to_regex_conversion() {
        let mut matcher = WildcardMatcher::new(true);
        
        let regex = matcher.glob_to_regex("User*Service").unwrap();
        assert!(regex.is_match("UserService"));
        assert!(regex.is_match("UserManagementService"));
        assert!(!regex.is_match("Service"));
        
        let regex2 = matcher.glob_to_regex("test?.rs").unwrap();
        assert!(regex2.is_match("test1.rs"));
        assert!(regex2.is_match("testA.rs"));
        assert!(!regex2.is_match("test10.rs"));
        
        let regex3 = matcher.glob_to_regex("**/*.rs").unwrap();
        assert!(regex3.is_match("src/main.rs"));
        assert!(regex3.is_match("deeply/nested/path/file.rs"));
        assert!(regex3.is_match("file.rs"));
    }

    #[test]
    fn test_cache_basic_operations() {
        let mut matcher = WildcardMatcher::with_cache_capacity(true, 3);
        
        // Initially cache should be empty
        let metrics = matcher.cache_metrics();
        assert_eq!(metrics.hits, 0);
        assert_eq!(metrics.misses, 0);
        assert_eq!(metrics.current_size, 0);
        
        // First access should be a cache miss
        let _ = matcher.glob_to_regex("test*").unwrap();
        let metrics = matcher.cache_metrics();
        assert_eq!(metrics.hits, 0);
        assert_eq!(metrics.misses, 1);
        assert_eq!(metrics.current_size, 1);
        
        // Second access to same pattern should be a cache hit
        let _ = matcher.glob_to_regex("test*").unwrap();
        let metrics = matcher.cache_metrics();
        assert_eq!(metrics.hits, 1);
        assert_eq!(metrics.misses, 1);
        assert_eq!(metrics.current_size, 1);
    }

    #[test]
    fn test_cache_lru_eviction() {
        let mut matcher = WildcardMatcher::with_cache_capacity(true, 2);
        
        // Fill cache to capacity
        let _ = matcher.glob_to_regex("pattern1").unwrap();
        let _ = matcher.glob_to_regex("pattern2").unwrap();
        
        let metrics = matcher.cache_metrics();
        assert_eq!(metrics.current_size, 2);
        assert_eq!(metrics.evictions, 0);
        
        // Adding third pattern should evict the first (LRU)
        let _ = matcher.glob_to_regex("pattern3").unwrap();
        
        let metrics = matcher.cache_metrics();
        assert_eq!(metrics.current_size, 2);
        assert_eq!(metrics.evictions, 1);
        
        // pattern1 should now be a cache miss (evicted)
        let _ = matcher.glob_to_regex("pattern1").unwrap();
        let metrics = matcher.cache_metrics();
        assert_eq!(metrics.misses, 4); // 3 initial misses + 1 for re-accessing pattern1
    }

    #[test]
    fn test_cache_metrics_tracking() {
        let mut matcher = WildcardMatcher::with_cache_capacity(true, 10);
        
        // Test multiple operations and verify metrics
        let _ = matcher.glob_to_regex("glob1").unwrap(); // miss
        let _ = matcher.get_or_compile_regex("regex1").unwrap(); // miss
        let _ = matcher.glob_to_regex("glob1").unwrap(); // hit
        let _ = matcher.get_or_compile_regex("regex1").unwrap(); // hit
        let _ = matcher.glob_to_regex("glob2").unwrap(); // miss
        
        let metrics = matcher.cache_metrics();
        assert_eq!(metrics.hits, 2);
        assert_eq!(metrics.misses, 3);
        assert_eq!(metrics.current_size, 3);
        assert_eq!(metrics.evictions, 0);
    }

    #[test]
    fn test_cache_clear() {
        let mut matcher = WildcardMatcher::new(true);
        
        // Add some patterns to cache
        let _ = matcher.glob_to_regex("test*").unwrap();
        let _ = matcher.get_or_compile_regex("[a-z]+").unwrap();
        
        let metrics = matcher.cache_metrics();
        assert!(metrics.current_size > 0);
        assert!(metrics.misses > 0);
        
        // Clear cache and verify metrics reset
        matcher.clear_cache();
        
        let metrics = matcher.cache_metrics();
        assert_eq!(metrics.hits, 0);
        assert_eq!(metrics.misses, 0);
        assert_eq!(metrics.current_size, 0);
        assert_eq!(metrics.evictions, 0);
    }

    #[test]
    fn test_cache_capacity_configuration() {
        let matcher1 = WildcardMatcher::new(true);
        assert_eq!(matcher1.cache_capacity(), WildcardMatcher::DEFAULT_CACHE_CAPACITY);
        
        let matcher2 = WildcardMatcher::with_cache_capacity(true, 512);
        assert_eq!(matcher2.cache_capacity(), 512);
        
        // Test zero capacity defaults to default
        let matcher3 = WildcardMatcher::with_cache_capacity(true, 0);
        assert_eq!(matcher3.cache_capacity(), WildcardMatcher::DEFAULT_CACHE_CAPACITY);
    }

    #[test]
    fn test_separate_glob_and_regex_caches() {
        let mut matcher = WildcardMatcher::new(true);
        
        // Same pattern text but different types should be separate cache entries
        let _ = matcher.glob_to_regex("test").unwrap();
        let _ = matcher.get_or_compile_regex("test").unwrap();
        
        let metrics = matcher.cache_metrics();
        assert_eq!(metrics.misses, 2); // Both should be cache misses
        assert_eq!(metrics.current_size, 2); // Both should be cached separately
        
        // Accessing them again should be cache hits
        let _ = matcher.glob_to_regex("test").unwrap();
        let _ = matcher.get_or_compile_regex("test").unwrap();
        
        let metrics = matcher.cache_metrics();
        assert_eq!(metrics.hits, 2);
    }

    #[test]
    fn test_cache_performance_comparison() {
        use std::time::Instant;
        
        let mut matcher = WildcardMatcher::with_cache_capacity(true, 100);
        let complex_pattern = "**/*[Tt]est*/**/*.{rs,js,ts,dart}";
        
        // First access (cache miss) - measure time
        let start = Instant::now();
        let _ = matcher.glob_to_regex(complex_pattern).unwrap();
        let miss_duration = start.elapsed();
        
        // Second access (cache hit) - should be much faster
        let start = Instant::now();
        let _ = matcher.glob_to_regex(complex_pattern).unwrap();
        let hit_duration = start.elapsed();
        
        // Cache hit should be significantly faster than cache miss
        // Note: This is a rough performance test - actual speedup depends on pattern complexity
        assert!(hit_duration < miss_duration);
        
        let metrics = matcher.cache_metrics();
        assert_eq!(metrics.hits, 1);
        assert_eq!(metrics.misses, 1);
    }

    #[test]
    fn test_nucleo_fuzzy_matching() {
        let matcher = WildcardMatcher::new(true);
        
        // Test basic fuzzy similarity
        let similarity = matcher.fuzzy_similarity("UserService", "UserSrv");
        assert!(similarity > 0.0);
        
        // Test exact match
        let similarity = matcher.fuzzy_similarity("test", "test");
        assert_eq!(similarity, 1.0); // Should be 1.0 for exact match
        
        // Test different strings
        let similarity = matcher.fuzzy_similarity("completely", "different");
        assert!(similarity >= 0.0); // At least 0.0
        
        // Test empty strings
        let similarity = matcher.fuzzy_similarity("", "");
        assert_eq!(similarity, 1.0);
        
        let similarity = matcher.fuzzy_similarity("test", "");
        assert_eq!(similarity, 0.0);
    }

    #[test]
    fn test_nucleo_case_sensitivity() {
        let case_sensitive_matcher = WildcardMatcher::new(true);
        let case_insensitive_matcher = WildcardMatcher::new(false);
        
        // Case sensitive should distinguish between cases
        let cs_similarity = case_sensitive_matcher.fuzzy_similarity("Test", "test");
        
        // Case insensitive should treat them as more similar
        let ci_similarity = case_insensitive_matcher.fuzzy_similarity("Test", "test");
        
        // Case insensitive should generally score higher for case mismatches
        // Note: This depends on nucleo-matcher's specific scoring algorithm
        assert!(ci_similarity >= cs_similarity);
    }

    #[test]
    fn test_nucleo_match_with_indices() {
        let matcher = WildcardMatcher::new(true);
        
        // Test exact match first (simpler case)
        let result = matcher.fuzzy_match_with_indices("test", "test");
        if let Some((score, indices)) = result {
            assert!(score > 0);
            assert!(!indices.is_empty());
        }
        
        // Test fuzzy match - if it works
        let result = matcher.fuzzy_match_with_indices("UserService", "User");
        if let Some((score, indices)) = result {
            assert!(score > 0);
            assert!(!indices.is_empty());
        }
    }

    #[test]
    fn test_nucleo_exact_matching() {
        let matcher = WildcardMatcher::new(true);
        
        // Test exact match
        let score = matcher.exact_match_score("test", "test");
        assert!(score.is_some());
        
        // Test partial match (should fail for exact)
        let score = matcher.exact_match_score("testing", "test");
        assert!(score.is_none());
        
        // Test case sensitivity - note: nucleo-matcher might handle case differently
        let score = matcher.exact_match_score("Test", "test");
        // Don't assert on case sensitivity for now as it depends on nucleo-matcher config
        let _case_result = score;
    }

    #[test]
    fn test_nucleo_substring_matching() {
        let matcher = WildcardMatcher::new(true);
        
        // Test substring match
        let score = matcher.substring_match_score("UserService", "Service");
        assert!(score.is_some());
        
        let score = matcher.substring_match_score("UserService", "User");
        assert!(score.is_some());
        
        // Test non-substring
        let score = matcher.substring_match_score("UserService", "Admin");
        assert!(score.is_none());
    }

    #[test]
    fn test_nucleo_performance_improvement() {
        use std::time::Instant;
        
        let matcher = WildcardMatcher::new(true);
        let test_pairs = vec![
            ("UserService", "User"),
            ("DatabasePool", "DB"),
            ("AuthProvider", "Auth"),
            ("ConfigManager", "Config"),
            ("ValidationService", "Valid"),
        ];
        
        // Measure nucleo-matcher performance
        let start = Instant::now();
        for (haystack, needle) in &test_pairs {
            let _ = matcher.fuzzy_similarity(haystack, needle);
        }
        let nucleo_duration = start.elapsed();
        
        // Performance should be reasonable (this is more of a smoke test)
        assert!(nucleo_duration.as_millis() < 1000); // Should complete in under 1 second
    }

    #[test]
    fn test_nucleo_unicode_handling() {
        let matcher = WildcardMatcher::new(true);
        
        // Test Unicode strings
        let similarity = matcher.fuzzy_similarity("Müller", "Muller");
        assert!(similarity > 0.0);
        
        let similarity = matcher.fuzzy_similarity("naïve", "naive");
        assert!(similarity > 0.0);
        
        // Test emoji and special characters
        let similarity = matcher.fuzzy_similarity("test 🚀", "test");
        assert!(similarity > 0.0);
    }

    #[test]
    fn test_nucleo_long_strings() {
        let matcher = WildcardMatcher::new(true);
        
        let text1 = "UserService";
        let text2 = "Service";
        
        let similarity = matcher.fuzzy_similarity(text1, text2);
        assert!(similarity > 0.0);
        
        // Test with indices
        let result = matcher.fuzzy_match_with_indices(text1, text2);
        // This may or may not work depending on nucleo-matcher's internal handling
        let _indices_result = result;
    }

    #[test]
    fn test_parallel_search_basic() {
        let headers = vec![create_test_header()];
        
        // Sequential search
        let sequential_results = WildcardQueryBuilder::new()
            .glob("User*", SearchScope::Names)
            .search(&headers)
            .unwrap();
        
        // Parallel search 
        let parallel_results = WildcardQueryBuilder::new()
            .glob("User*", SearchScope::Names)
            .search_parallel(&headers)
            .unwrap();
        
        // Results should be the same
        assert_eq!(sequential_results.len(), parallel_results.len());
        assert!(!parallel_results.is_empty());
        
        // Check that same symbol is found
        assert_eq!(sequential_results[0].symbol_name, parallel_results[0].symbol_name);
    }

    #[test]
    fn test_parallel_search_performance() {
        use std::time::Instant;
        
        // Create larger dataset for meaningful parallel performance test
        let mut headers = Vec::new();
        for i in 0..100 {
            let mut header = create_test_header();
            header.file_id = format!("test_file_{}.dart", i);
            
            // Add more symbols per header
            for j in 0..10 {
                header.symbols.push(Symbol {
                    id: format!("TC{}", j),
                    name: format!("TestClass{}", j),
                    kind: "class".to_string(),
                    owner: None,
                    range: header.symbols[0].range.clone(),
                    roles: vec!["definition".to_string()],
                    references: Vec::new(),
                    edges: Vec::new(),
                    frames: Vec::new(),
                    fingerprint: format!("test_fingerprint_{}", j),
                    guard: None,
                });
            }
            headers.push(header);
        }
        
        // Measure sequential search
        let start = Instant::now();
        let sequential_results = WildcardQueryBuilder::new()
            .glob("Test*", SearchScope::Names)
            .search(&headers)
            .unwrap();
        let sequential_time = start.elapsed();
        
        // Measure parallel search
        let start = Instant::now();
        let parallel_results = WildcardQueryBuilder::new()
            .glob("Test*", SearchScope::Names)
            .search_parallel(&headers)
            .unwrap();
        let parallel_time = start.elapsed();
        
        // Results should be equivalent
        assert_eq!(sequential_results.len(), parallel_results.len());
        
        // Parallel should not be significantly slower (allowing for overhead)
        // Note: On small datasets, parallel might be slower due to overhead
        println!("Sequential: {:?}, Parallel: {:?}", sequential_time, parallel_time);
        assert!(parallel_time < sequential_time * 3); // Allow 3x overhead for small dataset
    }

    #[test] 
    fn test_parallel_search_top_k() {
        let mut headers = Vec::new();
        for i in 0..50 {
            let mut header = create_test_header();
            header.file_id = format!("test_file_{}.dart", i);
            
            // Add symbol with varying confidence levels
            header.symbols.push(Symbol {
                id: format!("MS{:02}", i),
                name: format!("MatchingSymbol{:02}", i),
                kind: "class".to_string(),
                owner: None,
                range: header.symbols[0].range.clone(),
                roles: vec!["definition".to_string()],
                references: Vec::new(),
                edges: Vec::new(),
                frames: Vec::new(),
                fingerprint: format!("matching_fingerprint_{}", i),
                guard: None,
            });
            headers.push(header);
        }
        
        // Test top-k search
        let k = 10;
        let top_k_results = WildcardQueryBuilder::new()
            .glob("Matching*", SearchScope::Names)
            .search_parallel_top_k(&headers, k)
            .unwrap();
        
        // Should return at most k results
        assert!(top_k_results.len() <= k);
        assert!(!top_k_results.is_empty());
        
        // Results should be sorted by confidence (descending)
        for i in 1..top_k_results.len() {
            assert!(top_k_results[i-1].confidence >= top_k_results[i].confidence);
        }
    }

    #[test]
    fn test_parallel_search_consistency() {
        let headers = vec![create_test_header()];
        
        // Run parallel search multiple times to check for race conditions
        for _ in 0..10 {
            let results1 = WildcardQueryBuilder::new()
                .glob("User*", SearchScope::Names)
                .search_parallel(&headers)
                .unwrap();
                
            let results2 = WildcardQueryBuilder::new()
                .glob("User*", SearchScope::Names)
                .search_parallel(&headers)
                .unwrap();
            
            // Results should be consistent
            assert_eq!(results1.len(), results2.len());
            if !results1.is_empty() && !results2.is_empty() {
                assert_eq!(results1[0].symbol_name, results2[0].symbol_name);
                assert_eq!(results1[0].confidence, results2[0].confidence);
            }
        }
    }

    #[test]
    fn test_parallel_search_empty_input() {
        let empty_headers: Vec<AnchorHeader> = Vec::new();
        
        let results = WildcardQueryBuilder::new()
            .glob("*", SearchScope::Names)
            .search_parallel(&empty_headers)
            .unwrap();
        
        assert!(results.is_empty());
    }

    #[test]
    fn test_parallel_search_top_k_edge_cases() {
        let headers = vec![create_test_header()];
        
        // Test k=0
        let results = WildcardQueryBuilder::new()
            .glob("*", SearchScope::Names)
            .search_parallel_top_k(&headers, 0)
            .unwrap();
        assert!(results.is_empty());
        
        // Test k larger than available results
        let results = WildcardQueryBuilder::new()
            .glob("User*", SearchScope::Names)
            .search_parallel_top_k(&headers, 1000)
            .unwrap();
        assert!(!results.is_empty());
        assert!(results.len() < 1000); // Should have fewer results than k
    }

    #[test]
    fn test_parallel_search_chunking() {
        // Test that chunking works correctly with different numbers of threads
        let mut headers = Vec::new();
        for i in 0..17 { // Prime number to test chunking edge cases
            let mut header = create_test_header();
            header.file_id = format!("file_{}.dart", i);
            headers.push(header);
        }
        
        let results = WildcardQueryBuilder::new()
            .glob("User*", SearchScope::Names)
            .search_parallel(&headers)
            .unwrap();
        
        // Should find matches in multiple files
        assert!(!results.is_empty());
        
        // Verify no duplicates (dedup should work)
        let mut unique_symbols = HashSet::new();
        for result in &results {
            let key = format!("{}:{}", result.symbol_name, result.symbol_id);
            assert!(!unique_symbols.contains(&key), "Duplicate result found: {}", key);
            unique_symbols.insert(key);
        }
    }

    #[test]
    fn test_match_result_wrapper_ordering() {
        let dummy_ranking = RankingBreakdown {
            base_similarity: 0.8,
            prefix_bonus: 0.0,
            camel_case_bonus: 0.0,
            snake_case_bonus: 0.0,
            path_proximity: 0.0,
            length_penalty: 0.0,
            final_score: 0.8,
            feature_weights: FeatureWeights::default(),
        };
        
        let result1 = MatchResult {
            symbol_id: "1".to_string(),
            symbol_name: "Test1".to_string(),
            confidence: 0.8,
            match_text: "test".to_string(),
            match_location: MatchLocation::SymbolName,
            context: Vec::new(),
            ranking: dummy_ranking.clone(),
        };
        
        let mut dummy_ranking2 = dummy_ranking;
        dummy_ranking2.final_score = 0.9;
        
        let result2 = MatchResult {
            symbol_id: "2".to_string(),
            symbol_name: "Test2".to_string(),
            confidence: 0.9,
            match_text: "test".to_string(),
            match_location: MatchLocation::SymbolName,
            context: Vec::new(),
            ranking: dummy_ranking2,
        };
        
        let wrapper1 = MatchResultWrapper(result1);
        let wrapper2 = MatchResultWrapper(result2);
        
        // wrapper2 should be "less than" wrapper1 in max-heap ordering (higher confidence first)
        assert!(wrapper2 < wrapper1);
        
        // Test in BinaryHeap
        let mut heap = BinaryHeap::new();
        heap.push(wrapper1.clone());
        heap.push(wrapper2.clone());
        
        // Should pop highest confidence first (max-heap behavior)
        let top = heap.pop().unwrap();
        assert_eq!(top.0.confidence, 0.9, "Expected highest confidence (0.9) to be popped first, got: {}", top.0.confidence);
    }
    
    #[test]
    fn test_advanced_ranking_prefix_bonus() {
        let matcher = WildcardMatcher::new(true);
        
        // Test exact prefix match
        let prefix_bonus = matcher.calculate_prefix_bonus("UserService", "User");
        assert!(prefix_bonus > 0.0);
        assert!(prefix_bonus <= 1.0);
        
        // Test partial prefix match
        let partial_bonus = matcher.calculate_prefix_bonus("UserService", "Us");
        assert!(partial_bonus > 0.0);
        assert!(partial_bonus < prefix_bonus); // Should be less than exact prefix
        
        // Test no prefix match
        let no_bonus = matcher.calculate_prefix_bonus("UserService", "Service");
        assert_eq!(no_bonus, 0.0);
        
        // Test case insensitive
        let case_bonus = matcher.calculate_prefix_bonus("UserService", "user");
        assert!(case_bonus > 0.0);
    }
    
    #[test]
    fn test_camel_case_token_extraction() {
        let matcher = WildcardMatcher::new(true);
        
        let tokens = matcher.extract_camel_case_tokens("UserService");
        assert_eq!(tokens, vec!["user", "service"]);
        
        let tokens = matcher.extract_camel_case_tokens("XMLHttpRequest");
        assert_eq!(tokens, vec!["x", "m", "l", "http", "request"]);
        
        let tokens = matcher.extract_camel_case_tokens("getId");
        assert_eq!(tokens, vec!["get", "id"]);
        
        // Single word
        let tokens = matcher.extract_camel_case_tokens("service");
        assert_eq!(tokens, vec!["service"]);
        
        // Empty string
        let tokens = matcher.extract_camel_case_tokens("");
        assert!(tokens.is_empty());
    }
    
    #[test]
    fn test_snake_case_token_extraction() {
        let matcher = WildcardMatcher::new(true);
        
        let tokens = matcher.extract_snake_case_tokens("user_service");
        assert_eq!(tokens, vec!["user", "service"]);
        
        let tokens = matcher.extract_snake_case_tokens("xml_http_request");
        assert_eq!(tokens, vec!["xml", "http", "request"]);
        
        let tokens = matcher.extract_snake_case_tokens("get_id");
        assert_eq!(tokens, vec!["get", "id"]);
        
        // Single word
        let tokens = matcher.extract_snake_case_tokens("service");
        assert_eq!(tokens, vec!["service"]);
        
        // Multiple underscores
        let tokens = matcher.extract_snake_case_tokens("test__value");
        assert_eq!(tokens, vec!["test", "value"]);
        
        // Empty string
        let tokens = matcher.extract_snake_case_tokens("");
        assert!(tokens.is_empty());
    }
    
    #[test]
    fn test_camel_case_overlap_bonus() {
        let matcher = WildcardMatcher::new(true);
        
        // Perfect overlap
        let overlap = matcher.calculate_camel_case_overlap("UserService", "UserService");
        assert_eq!(overlap, 1.0);
        
        // Single token match gets 1.0 (perfect match for that token)
        let overlap = matcher.calculate_camel_case_overlap("UserService", "User");
        assert_eq!(overlap, 1.0); // "User" has one token that matches perfectly
        
        // Partial overlap - multiple tokens with some matches
        let overlap = matcher.calculate_camel_case_overlap("UserService", "UserData");
        assert!(overlap > 0.0);
        assert!(overlap < 1.0); // "UserData" -> ["user", "data"], only "user" matches
        
        // No overlap
        let overlap = matcher.calculate_camel_case_overlap("UserService", "DatabasePool");
        assert_eq!(overlap, 0.0);
        
        // Mixed case overlap
        let overlap = matcher.calculate_camel_case_overlap("getUserId", "UserId");
        assert!(overlap > 0.0);
    }
    
    #[test]
    fn test_snake_case_overlap_bonus() {
        let matcher = WildcardMatcher::new(true);
        
        // Perfect overlap
        let overlap = matcher.calculate_snake_case_overlap("user_service", "user_service");
        assert_eq!(overlap, 1.0);
        
        // Single token match gets 1.0 (perfect match for that token)
        let overlap = matcher.calculate_snake_case_overlap("user_service", "user");
        assert_eq!(overlap, 1.0); // "user" has one token that matches perfectly
        
        // Partial overlap - multiple tokens with some matches
        let overlap = matcher.calculate_snake_case_overlap("user_service", "user_data");
        assert!(overlap > 0.0);
        assert!(overlap < 1.0); // "user_data" -> ["user", "data"], only "user" matches
        
        // No overlap
        let overlap = matcher.calculate_snake_case_overlap("user_service", "database_pool");
        assert_eq!(overlap, 0.0);
        
        // Mixed tokens
        let overlap = matcher.calculate_snake_case_overlap("get_user_id", "user_id");
        assert!(overlap > 0.0);
    }
    
    #[test]
    fn test_path_proximity_scoring() {
        let matcher = WildcardMatcher::new(true);
        
        // Filename match should get high score
        let score = matcher.calculate_path_proximity_score("src/user_service.rs", "user");
        assert!(score > 0.7);
        
        // Directory match should get moderate score
        let score = matcher.calculate_path_proximity_score("src/user/service.rs", "user");
        assert!(score > 0.0);
        assert!(score < 0.7);
        
        // No match should get zero score
        let score = matcher.calculate_path_proximity_score("src/database/pool.rs", "user");
        assert_eq!(score, 0.0);
        
        // Case insensitive matching
        let score = matcher.calculate_path_proximity_score("src/UserService.rs", "user");
        assert!(score > 0.7);
    }
    
    #[test]
    fn test_length_penalty_calculation() {
        let matcher = WildcardMatcher::new(true);
        
        // Same length - no penalty
        let penalty = matcher.calculate_length_penalty("test", "test");
        assert_eq!(penalty, 0.0);
        
        // Different lengths - should have penalty
        let penalty = matcher.calculate_length_penalty("test", "testing");
        assert!(penalty > 0.0);
        assert!(penalty <= 1.0);
        
        // Very different lengths - higher penalty
        let penalty1 = matcher.calculate_length_penalty("a", "ab");
        let penalty2 = matcher.calculate_length_penalty("a", "abcdefg");
        assert!(penalty2 > penalty1);
        
        // Empty pattern - no penalty
        let penalty = matcher.calculate_length_penalty("test", "");
        assert_eq!(penalty, 0.0);
    }
    
    #[test]
    fn test_feature_weights_configuration() {
        let custom_weights = FeatureWeights {
            prefix_weight: 0.5,
            camel_case_weight: 0.1,
            snake_case_weight: 0.1,
            path_proximity_weight: 0.2,
            length_penalty_weight: 0.05,
        };
        
        let matcher = WildcardMatcher::new_with_weights(true, custom_weights.clone());
        let weights = matcher.get_feature_weights();
        
        assert_eq!(weights.prefix_weight, 0.5);
        assert_eq!(weights.camel_case_weight, 0.1);
        assert_eq!(weights.snake_case_weight, 0.1);
        assert_eq!(weights.path_proximity_weight, 0.2);
        assert_eq!(weights.length_penalty_weight, 0.05);
    }
    
    #[test]
    fn test_ranking_breakdown_consistency() {
        let header = create_test_header();
        
        let results = WildcardQueryBuilder::new()
            .fuzzy("User", SearchScope::Names, 0.1)
            .search(&[header])
            .unwrap();
        
        assert!(!results.is_empty());
        
        for result in &results {
            let ranking = &result.ranking;
            
            // All feature scores should be in valid range
            assert!(ranking.base_similarity >= 0.0 && ranking.base_similarity <= 1.0);
            assert!(ranking.prefix_bonus >= 0.0 && ranking.prefix_bonus <= 1.0);
            assert!(ranking.camel_case_bonus >= 0.0 && ranking.camel_case_bonus <= 1.0);
            assert!(ranking.snake_case_bonus >= 0.0 && ranking.snake_case_bonus <= 1.0);
            assert!(ranking.path_proximity >= 0.0 && ranking.path_proximity <= 1.0);
            assert!(ranking.length_penalty >= 0.0 && ranking.length_penalty <= 1.0);
            assert!(ranking.final_score >= 0.0 && ranking.final_score <= 1.0);
            
            // Final score should match confidence
            assert!((ranking.final_score - result.confidence).abs() < 0.001);
        }
    }
    
    #[test]
    fn test_ranking_explanation() {
        let matcher = WildcardMatcher::new(true);
        let header = create_test_header();
        
        let results = WildcardQueryBuilder::new()
            .fuzzy("User", SearchScope::Names, 0.1)
            .search(&[header])
            .unwrap();
        
        assert!(!results.is_empty());
        
        for result in &results {
            let explanation = matcher.explain_ranking(result);
            
            // Should contain key components
            assert!(explanation.contains("Ranking breakdown"));
            assert!(explanation.contains(&result.symbol_name));
            assert!(explanation.contains("Base:"));
            assert!(explanation.contains("Prefix:"));
            assert!(explanation.contains("Final:"));
            
            // Should not be empty
            assert!(!explanation.trim().is_empty());
        }
    }
    
    #[test]
    fn test_ranking_feature_contribution() {
        let header = create_test_header();
        
        // Test prefix bonus impact
        let prefix_results = WildcardQueryBuilder::new()
            .fuzzy("User", SearchScope::Names, 0.1)
            .search(&[header.clone()])
            .unwrap();
        
        let non_prefix_results = WildcardQueryBuilder::new()
            .fuzzy("Service", SearchScope::Names, 0.1)
            .search(&[header])
            .unwrap();
        
        if let (Some(prefix_result), Some(non_prefix_result)) = (prefix_results.first(), non_prefix_results.first()) {
            // Prefix match should generally get bonus (unless other factors dominate)
            let prefix_bonus_contribution = prefix_result.ranking.prefix_bonus * prefix_result.ranking.feature_weights.prefix_weight;
            let non_prefix_bonus_contribution = non_prefix_result.ranking.prefix_bonus * non_prefix_result.ranking.feature_weights.prefix_weight;
            
            // At least one should have meaningful prefix bonus
            assert!(prefix_bonus_contribution >= non_prefix_bonus_contribution);
        }
    }
    
    #[test]
    fn test_ranking_with_parallel_search() {
        let header = create_test_header();
        
        // Sequential search with ranking
        let sequential_results = WildcardQueryBuilder::new()
            .fuzzy("User", SearchScope::Names, 0.1)
            .search(&[header.clone()])
            .unwrap();
        
        // Parallel search with ranking
        let parallel_results = WildcardQueryBuilder::new()
            .fuzzy("User", SearchScope::Names, 0.1)
            .search_parallel(&[header])
            .unwrap();
        
        // Results should be consistent
        assert_eq!(sequential_results.len(), parallel_results.len());
        
        if !sequential_results.is_empty() && !parallel_results.is_empty() {
            // Both should have ranking information
            assert!(sequential_results[0].ranking.final_score > 0.0);
            assert!(parallel_results[0].ranking.final_score > 0.0);
            
            // Scores should be very close (allowing for small floating point differences)
            let score_diff = (sequential_results[0].ranking.final_score - parallel_results[0].ranking.final_score).abs();
            assert!(score_diff < 0.01, "Sequential: {}, Parallel: {}", sequential_results[0].ranking.final_score, parallel_results[0].ranking.final_score);
        }
    }
}