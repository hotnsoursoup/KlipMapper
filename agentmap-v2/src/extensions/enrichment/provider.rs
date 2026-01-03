//! Enrichment provider trait.

use crate::core::Symbol;
use std::collections::HashMap;

/// Result of enrichment.
#[derive(Debug, Clone, Default)]
pub struct EnrichmentResult {
    /// Additional text context for embedding.
    pub context_text: Option<String>,

    /// Metadata enrichments.
    pub metadata: HashMap<String, String>,
}

impl EnrichmentResult {
    /// Create empty result.
    pub fn empty() -> Self {
        Self::default()
    }

    /// Merge with another result.
    pub fn merge(mut self, other: EnrichmentResult) -> Self {
        if let Some(text) = other.context_text {
            self.context_text = Some(match self.context_text {
                Some(existing) => format!("{} {}", existing, text),
                None => text,
            });
        }
        self.metadata.extend(other.metadata);
        self
    }
}

/// Provider that adds context to symbols.
pub trait EnrichmentProvider: Send + Sync {
    /// Enrich a symbol with additional context.
    fn enrich(&self, symbol: &Symbol, parent: Option<&Symbol>) -> EnrichmentResult;

    /// Provider name.
    fn name(&self) -> &str;
}
