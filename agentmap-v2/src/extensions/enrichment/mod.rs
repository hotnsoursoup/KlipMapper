//! Contextual enrichment for embeddings.

mod provider;
mod pipeline;

pub use provider::{EnrichmentProvider, EnrichmentResult};
pub use pipeline::EnrichmentPipeline;

use crate::core::Symbol;

/// Parent context enricher.
pub struct ParentContextEnricher;

impl EnrichmentProvider for ParentContextEnricher {
    fn enrich(&self, symbol: &Symbol, parent: Option<&Symbol>) -> EnrichmentResult {
        if let Some(parent) = parent {
            EnrichmentResult {
                context_text: Some(format!("{}.{}", parent.name, symbol.name)),
                metadata: {
                    let mut m = std::collections::HashMap::new();
                    m.insert("parent".to_string(), parent.name.clone());
                    m
                },
            }
        } else {
            EnrichmentResult::empty()
        }
    }

    fn name(&self) -> &str {
        "ParentContext"
    }
}

/// Signature enricher - adds full function signature.
pub struct SignatureEnricher;

impl EnrichmentProvider for SignatureEnricher {
    fn enrich(&self, symbol: &Symbol, _parent: Option<&Symbol>) -> EnrichmentResult {
        // Extract signature from code content
        if symbol.code_content.is_empty() {
            return EnrichmentResult::empty();
        }

        // Get first line (usually contains signature)
        let first_line = symbol.code_content.lines().next().unwrap_or("");

        EnrichmentResult {
            context_text: Some(first_line.to_string()),
            metadata: std::collections::HashMap::new(),
        }
    }

    fn name(&self) -> &str {
        "Signature"
    }
}

/// File path enricher - adds module context.
pub struct FilePathEnricher;

impl EnrichmentProvider for FilePathEnricher {
    fn enrich(&self, symbol: &Symbol, _parent: Option<&Symbol>) -> EnrichmentResult {
        let path = symbol.location.file_path.to_string_lossy();

        EnrichmentResult {
            context_text: Some(format!("in {}", path)),
            metadata: {
                let mut m = std::collections::HashMap::new();
                m.insert("file".to_string(), path.to_string());
                m
            },
        }
    }

    fn name(&self) -> &str {
        "FilePath"
    }
}
