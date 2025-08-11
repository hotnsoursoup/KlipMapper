use std::collections::HashMap;
use regex::Regex;
use anyhow::{Result, Context};
use crate::anchor::{AnchorHeader, Symbol, SymbolReference, SymbolEdge};

/// Advanced wildcard pattern matching for symbol queries
pub struct WildcardMatcher {
    /// Compiled regex patterns for performance
    pattern_cache: HashMap<String, Regex>,
    /// Case sensitivity setting
    case_sensitive: bool,
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
    pub fn new(case_sensitive: bool) -> Self {
        Self {
            pattern_cache: HashMap::new(),
            case_sensitive,
        }
    }

    /// Search symbols using wildcard patterns
    pub fn search_symbols(
        &mut self,
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

    fn match_symbol(
        &mut self,
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
        &mut self,
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

        let (is_match, confidence) = match &pattern.match_type {
            MatchType::Glob => {
                let regex = self.glob_to_regex(&pattern_str)?;
                (regex.is_match(&text), if regex.is_match(&text) { 1.0 } else { 0.0 })
            },
            MatchType::Regex => {
                let regex = self.get_or_compile_regex(&pattern_str)?;
                (regex.is_match(&text), if regex.is_match(&text) { 1.0 } else { 0.0 })
            },
            MatchType::Fuzzy(threshold) => {
                let similarity = self.fuzzy_similarity(&text, &pattern_str);
                (similarity >= *threshold, similarity)
            },
            MatchType::Exact => {
                let matches = text == pattern_str;
                (matches, if matches { 1.0 } else { 0.0 })
            }
        };

        if is_match {
            Ok(Some(MatchResult {
                symbol_id: symbol.id.clone(),
                symbol_name: symbol.name.clone(),
                match_location: MatchLocation::SymbolName, // Will be overridden by caller
                match_text: text,
                confidence,
                context: self.build_context(symbol, file_id),
            }))
        } else {
            Ok(None)
        }
    }

    fn glob_to_regex(&mut self, glob: &str) -> Result<Regex> {
        let cache_key = format!("glob:{}", glob);
        
        if let Some(regex) = self.pattern_cache.get(&cache_key) {
            return Ok(regex.clone());
        }

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
        
        self.pattern_cache.insert(cache_key, regex.clone());
        Ok(regex)
    }

    fn get_or_compile_regex(&mut self, pattern: &str) -> Result<Regex> {
        let cache_key = format!("regex:{}", pattern);
        
        if let Some(regex) = self.pattern_cache.get(&cache_key) {
            return Ok(regex.clone());
        }

        let regex = Regex::new(pattern)
            .with_context(|| format!("Failed to compile regex pattern: {}", pattern))?;
        
        self.pattern_cache.insert(cache_key, regex.clone());
        Ok(regex)
    }

    fn fuzzy_similarity(&self, text1: &str, text2: &str) -> f32 {
        // Simple Levenshtein distance-based similarity
        let len1 = text1.len();
        let len2 = text2.len();
        
        if len1 == 0 { return if len2 == 0 { 1.0 } else { 0.0 }; }
        if len2 == 0 { return 0.0; }
        
        let max_len = len1.max(len2);
        let distance = self.levenshtein_distance(text1, text2);
        
        1.0 - (distance as f32 / max_len as f32)
    }

    fn levenshtein_distance(&self, s1: &str, s2: &str) -> usize {
        let chars1: Vec<char> = s1.chars().collect();
        let chars2: Vec<char> = s2.chars().collect();
        let len1 = chars1.len();
        let len2 = chars2.len();

        let mut matrix = vec![vec![0; len2 + 1]; len1 + 1];

        for i in 0..=len1 {
            matrix[i][0] = i;
        }
        for j in 0..=len2 {
            matrix[0][j] = j;
        }

        for i in 1..=len1 {
            for j in 1..=len2 {
                let cost = if chars1[i - 1] == chars2[j - 1] { 0 } else { 1 };
                matrix[i][j] = (matrix[i - 1][j] + 1)
                    .min(matrix[i][j - 1] + 1)
                    .min(matrix[i - 1][j - 1] + cost);
            }
        }

        matrix[len1][len2]
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
}

impl WildcardQueryBuilder {
    pub fn new() -> Self {
        Self {
            patterns: Vec::new(),
            case_sensitive: true,
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

    /// Execute the search
    pub fn search(self, headers: &[AnchorHeader]) -> Result<Vec<MatchResult>> {
        let mut matcher = WildcardMatcher::new(self.case_sensitive);
        matcher.search_symbols(headers, &self.patterns)
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
            .fuzzy("UserServic", SearchScope::Names, 0.8)
            .search(&[header])
            .unwrap();

        assert_eq!(results.len(), 1);
        assert_eq!(results[0].symbol_name, "UserService");
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
}