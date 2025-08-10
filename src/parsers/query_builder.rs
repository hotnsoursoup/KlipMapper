// Query builder for creating dynamic TreeSitter queries
// This module provides a fluent API for building complex queries

use std::collections::HashMap;
use anyhow::Result;
use tree_sitter::{Query, Language};

pub struct QueryBuilder {
    query_parts: Vec<String>,
    captures: HashMap<String, String>,
}

impl QueryBuilder {
    pub fn new() -> Self {
        Self {
            query_parts: Vec::new(),
            captures: HashMap::new(),
        }
    }

    pub fn add_pattern(mut self, pattern: &str) -> Self {
        self.query_parts.push(pattern.to_string());
        self
    }

    pub fn add_capture(mut self, name: &str, pattern: &str) -> Self {
        self.captures.insert(name.to_string(), pattern.to_string());
        self
    }

    pub fn build(self, language: &Language) -> Result<Query> {
        let query_string = self.query_parts.join("\n");
        Query::new(language, &query_string).map_err(Into::into)
    }
}

impl Default for QueryBuilder {
    fn default() -> Self {
        Self::new()
    }
}