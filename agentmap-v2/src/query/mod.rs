//! Query module for symbol search and pattern matching.
//!
//! Provides advanced wildcard pattern matching with:
//! - Glob patterns (*, ?, [])
//! - Regex patterns
//! - Fuzzy matching
//! - Parallel search with rayon
//! - LRU cache for compiled patterns

mod matcher;
mod pattern;
mod search;

pub use matcher::{SymbolMatcher, MatchConfig, CacheMetrics};
pub use pattern::{Pattern, PatternType, SearchScope, MatchResult, MatchLocation};
pub use search::{QueryBuilder, SearchResults};
