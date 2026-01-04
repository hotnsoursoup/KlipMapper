//! Pattern types and search scopes.

use crate::core::Symbol;

/// Pattern type for matching.
#[derive(Debug, Clone)]
pub enum PatternType {
    /// Simple wildcard: *, ?, []
    Glob,
    /// Full regex support
    Regex,
    /// Fuzzy matching with similarity threshold
    Fuzzy(f32),
    /// Exact string match
    Exact,
}

/// Search scope for pattern matching.
#[derive(Debug, Clone, Default)]
pub enum SearchScope {
    /// Search in symbol names only
    #[default]
    Names,
    /// Search in symbol kinds
    Kinds,
    /// Search in file paths
    Paths,
    /// Search in qualified names (module::class::method)
    Qualified,
    /// Search in code content
    Code,
    /// Search everywhere
    All,
}

/// A search pattern with scope and type.
#[derive(Debug, Clone)]
pub struct Pattern {
    /// The pattern string
    pub pattern: String,
    /// Where to search
    pub scope: SearchScope,
    /// How to match
    pub pattern_type: PatternType,
}

impl Pattern {
    /// Create a new glob pattern.
    pub fn glob(pattern: impl Into<String>) -> Self {
        Self {
            pattern: pattern.into(),
            scope: SearchScope::Names,
            pattern_type: PatternType::Glob,
        }
    }

    /// Create a new regex pattern.
    pub fn regex(pattern: impl Into<String>) -> Self {
        Self {
            pattern: pattern.into(),
            scope: SearchScope::Names,
            pattern_type: PatternType::Regex,
        }
    }

    /// Create a new fuzzy pattern.
    pub fn fuzzy(pattern: impl Into<String>, threshold: f32) -> Self {
        Self {
            pattern: pattern.into(),
            scope: SearchScope::Names,
            pattern_type: PatternType::Fuzzy(threshold),
        }
    }

    /// Create an exact match pattern.
    pub fn exact(pattern: impl Into<String>) -> Self {
        Self {
            pattern: pattern.into(),
            scope: SearchScope::Names,
            pattern_type: PatternType::Exact,
        }
    }

    /// Set the search scope.
    pub fn with_scope(mut self, scope: SearchScope) -> Self {
        self.scope = scope;
        self
    }
}

/// Where a match was found.
#[derive(Debug, Clone)]
pub enum MatchLocation {
    /// Match in symbol name
    Name,
    /// Match in symbol kind
    Kind,
    /// Match in file path
    Path,
    /// Match in qualified name
    Qualified,
    /// Match in code content
    Code,
}

/// A match result with confidence and context.
#[derive(Debug, Clone)]
pub struct MatchResult {
    /// The matched symbol
    pub symbol: Symbol,
    /// Where the match was found
    pub location: MatchLocation,
    /// The text that matched
    pub match_text: String,
    /// Confidence score (0.0 - 1.0)
    pub confidence: f32,
    /// File path containing the symbol
    pub file_path: String,
    /// Ranking breakdown for debugging
    pub ranking: RankingBreakdown,
}

/// Breakdown of ranking features.
#[derive(Debug, Clone, Default)]
pub struct RankingBreakdown {
    /// Base match score
    pub base_score: f32,
    /// Bonus for prefix match
    pub prefix_bonus: f32,
    /// Bonus for camelCase token overlap
    pub camel_case_bonus: f32,
    /// Bonus for snake_case token overlap
    pub snake_case_bonus: f32,
    /// Penalty for length difference
    pub length_penalty: f32,
    /// Final computed score
    pub final_score: f32,
}

impl RankingBreakdown {
    /// Create a simple ranking from base score only.
    pub fn from_base(score: f32) -> Self {
        Self {
            base_score: score,
            final_score: score,
            ..Default::default()
        }
    }
}

impl MatchResult {
    /// Create a new match result.
    pub fn new(
        symbol: Symbol,
        location: MatchLocation,
        match_text: String,
        confidence: f32,
        file_path: String,
    ) -> Self {
        Self {
            symbol,
            location,
            match_text,
            confidence,
            file_path,
            ranking: RankingBreakdown::from_base(confidence),
        }
    }

    /// Set detailed ranking breakdown.
    pub fn with_ranking(mut self, ranking: RankingBreakdown) -> Self {
        self.ranking = ranking;
        self
    }
}
