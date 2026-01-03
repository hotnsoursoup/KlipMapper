//! Enrichment pipeline.

use crate::core::{Symbol, CodeAnalysis};
use super::{EnrichmentProvider, EnrichmentResult};

/// Pipeline that runs multiple enrichment providers.
pub struct EnrichmentPipeline {
    providers: Vec<Box<dyn EnrichmentProvider>>,
}

impl EnrichmentPipeline {
    /// Create empty pipeline.
    pub fn new() -> Self {
        Self {
            providers: Vec::new(),
        }
    }

    /// Create with default providers.
    pub fn default_pipeline() -> Self {
        use super::{ParentContextEnricher, SignatureEnricher, FilePathEnricher};

        let mut pipeline = Self::new();
        pipeline.add(Box::new(ParentContextEnricher));
        pipeline.add(Box::new(SignatureEnricher));
        pipeline.add(Box::new(FilePathEnricher));
        pipeline
    }

    /// Add a provider.
    pub fn add(&mut self, provider: Box<dyn EnrichmentProvider>) {
        self.providers.push(provider);
    }

    /// Enrich a symbol.
    pub fn enrich(&self, symbol: &Symbol, parent: Option<&Symbol>) -> EnrichmentResult {
        let mut result = EnrichmentResult::empty();

        for provider in &self.providers {
            let enrichment = provider.enrich(symbol, parent);
            result = result.merge(enrichment);
        }

        result
    }

    /// Enrich all symbols in an analysis.
    pub fn enrich_analysis(&self, analysis: &CodeAnalysis) -> Vec<(Symbol, EnrichmentResult)> {
        analysis.symbols.iter()
            .map(|symbol| {
                let parent = self.find_parent(symbol, analysis);
                let enrichment = self.enrich(symbol, parent);
                (symbol.clone(), enrichment)
            })
            .collect()
    }

    fn find_parent<'a>(&self, symbol: &Symbol, analysis: &'a CodeAnalysis) -> Option<&'a Symbol> {
        // Find containing symbol (class containing method, etc.)
        for candidate in &analysis.symbols {
            if candidate.id == symbol.id {
                continue;
            }

            // Check if candidate contains symbol
            if candidate.location.file_path == symbol.location.file_path
                && candidate.location.start_line <= symbol.location.start_line
                && candidate.location.end_line >= symbol.location.end_line
            {
                return Some(candidate);
            }
        }

        None
    }
}

impl Default for EnrichmentPipeline {
    fn default() -> Self {
        Self::default_pipeline()
    }
}
