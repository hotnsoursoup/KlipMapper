//! Embedding configuration for code analysis.

/// Configuration for embedding generation.
#[derive(Debug, Clone)]
pub struct EmbeddingConfig {
    /// Batch size for embedding API calls.
    pub batch_size: usize,

    /// Skip symbols larger than this token count.
    pub max_tokens: usize,

    /// Skip symbols with empty code content.
    pub skip_empty: bool,

    /// Include documentation in embedding text.
    pub include_docs: bool,

    /// Include file path context in embedding text.
    pub include_file_context: bool,

    /// Database path for storing embeddings.
    /// Default: `.agentmap/embeddings.db` in project root.
    pub database_path: Option<std::path::PathBuf>,
}

impl Default for EmbeddingConfig {
    fn default() -> Self {
        Self {
            batch_size: 10,
            max_tokens: 8000,
            skip_empty: true,
            include_docs: true,
            include_file_context: true,
            database_path: None,
        }
    }
}

impl EmbeddingConfig {
    /// Create a new config with default values.
    pub fn new() -> Self {
        Self::default()
    }

    /// Set the batch size.
    pub fn with_batch_size(mut self, size: usize) -> Self {
        self.batch_size = size.max(1);
        self
    }

    /// Set the maximum token limit for symbols.
    pub fn with_max_tokens(mut self, max: usize) -> Self {
        self.max_tokens = max;
        self
    }

    /// Set whether to include documentation.
    pub fn with_docs(mut self, include: bool) -> Self {
        self.include_docs = include;
        self
    }

    /// Set whether to include file context.
    pub fn with_file_context(mut self, include: bool) -> Self {
        self.include_file_context = include;
        self
    }

    /// Set the database path.
    pub fn with_database_path(mut self, path: impl Into<std::path::PathBuf>) -> Self {
        self.database_path = Some(path.into());
        self
    }

    /// Get the effective database path.
    ///
    /// Returns the configured path, or defaults to `.agentmap/embeddings.db`
    /// in the current directory.
    pub fn effective_database_path(&self) -> std::path::PathBuf {
        self.database_path.clone().unwrap_or_else(|| {
            std::path::PathBuf::from(".agentmap/embeddings.db")
        })
    }

    /// Prepare text for embedding from a symbol.
    ///
    /// Combines code content with optional documentation and file context.
    pub fn prepare_embedding_text(
        &self,
        code: &str,
        name: &str,
        kind: &str,
        file_path: Option<&str>,
        documentation: Option<&str>,
    ) -> String {
        let mut parts = Vec::new();

        // Add file context
        if self.include_file_context {
            if let Some(path) = file_path {
                parts.push(format!("// File: {}", path));
            }
        }

        // Add symbol header
        parts.push(format!("// {} ({})", name, kind));

        // Add documentation
        if self.include_docs {
            if let Some(docs) = documentation {
                if !docs.is_empty() {
                    parts.push(format!("// {}", docs.lines().take(3).collect::<Vec<_>>().join(" ")));
                }
            }
        }

        // Add code
        parts.push(code.to_string());

        parts.join("\n")
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_default_config() {
        let config = EmbeddingConfig::default();
        assert_eq!(config.batch_size, 10);
        assert_eq!(config.max_tokens, 8000);
        assert!(config.skip_empty);
        assert!(config.include_docs);
    }

    #[test]
    fn test_builder_pattern() {
        let config = EmbeddingConfig::new()
            .with_batch_size(5)
            .with_max_tokens(4000)
            .with_docs(false);

        assert_eq!(config.batch_size, 5);
        assert_eq!(config.max_tokens, 4000);
        assert!(!config.include_docs);
    }

    #[test]
    fn test_database_path() {
        let config = EmbeddingConfig::new()
            .with_database_path("/tmp/test.db");

        assert_eq!(
            config.effective_database_path(),
            std::path::PathBuf::from("/tmp/test.db")
        );
    }

    #[test]
    fn test_prepare_embedding_text() {
        let config = EmbeddingConfig::new();

        let text = config.prepare_embedding_text(
            "fn example() {}",
            "example",
            "Function",
            Some("src/lib.rs"),
            Some("An example function"),
        );

        assert!(text.contains("File: src/lib.rs"));
        assert!(text.contains("example (Function)"));
        assert!(text.contains("An example function"));
        assert!(text.contains("fn example() {}"));
    }
}
