//! db-kit integration middleware.
//!
//! This middleware converts AgentMap symbols and relationships
//! to a portable format for RAG indexing.
//!
//! For full db-kit integration (async storage, queries), use the
//! `integrations::dbkit` module with `DbKitBridge` instead.

use crate::core::{Result, CodeAnalysis};
use super::{Middleware, Context};
use std::collections::HashMap;


/// Middleware that converts analysis results to a portable format.
///
/// This enables direct serialization of code symbols for RAG retrieval.
/// For async db-kit storage, use `integrations::DbKitBridge` instead.
#[derive(Default)]
pub struct DbKitMiddleware {
    /// Whether to generate embeddings (requires async context).
    #[allow(dead_code)]
    generate_embeddings: bool,
}

impl DbKitMiddleware {
    /// Create a new db-kit middleware.
    pub fn new() -> Self {
        Self::default()
    }

    /// Enable embedding generation.
    pub fn with_embeddings(mut self) -> Self {
        self.generate_embeddings = true;
        self
    }

    /// Convert without db-kit feature (returns JSON-serializable format).
    pub fn analysis_to_portable(analysis: &CodeAnalysis) -> PortableGraph {
        let entities: Vec<_> = analysis.symbols
            .iter()
            .map(|s| PortableEntity {
                id: s.id.0.clone(),
                name: s.name.clone(),
                entity_type: s.kind.to_string(),
                properties: {
                    let mut props = s.properties.clone();
                    props.insert("visibility".to_string(), s.visibility.to_string());
                    props.insert("file".to_string(), s.location.file_path.to_string_lossy().to_string());
                    props.insert("line".to_string(), s.location.start_line.to_string());
                    if !s.code_content.is_empty() {
                        props.insert("code".to_string(), s.code_content.clone());
                    }
                    props
                },
            })
            .collect();

        let relationships: Vec<_> = analysis.relationships
            .iter()
            .map(|r| PortableRelationship {
                from: r.from.0.clone(),
                to: r.to.0.clone(),
                rel_type: r.kind.to_string(),
                confidence: r.confidence,
            })
            .collect();

        PortableGraph { entities, relationships }
    }
}

/// Portable entity format for serialization without db-kit.
#[derive(Debug, Clone, serde::Serialize, serde::Deserialize)]
pub struct PortableEntity {
    pub id: String,
    pub name: String,
    pub entity_type: String,
    pub properties: HashMap<String, String>,
}

/// Portable relationship format for serialization without db-kit.
#[derive(Debug, Clone, serde::Serialize, serde::Deserialize)]
pub struct PortableRelationship {
    pub from: String,
    pub to: String,
    pub rel_type: String,
    pub confidence: f32,
}

/// Portable graph format for serialization without db-kit.
#[derive(Debug, Clone, serde::Serialize, serde::Deserialize)]
pub struct PortableGraph {
    pub entities: Vec<PortableEntity>,
    pub relationships: Vec<PortableRelationship>,
}

impl Middleware for DbKitMiddleware {
    fn after_analyze(&self, _ctx: &Context, analysis: &CodeAnalysis) -> Result<()> {
        // In a real implementation, this would index the analysis
        // For now, we just validate the conversion works
        let _graph = Self::analysis_to_portable(analysis);
        Ok(())
    }

    fn name(&self) -> &str {
        "DbKitMiddleware"
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::core::{Symbol, SymbolKind, SourceLocation, Visibility};
    use std::path::PathBuf;

    #[test]
    fn test_symbol_to_portable() {
        let symbol = Symbol::new(
            "test_func",
            SymbolKind::Function,
            SourceLocation::new(PathBuf::from("test.rs"), 1, 10),
        ).with_visibility(Visibility::Public)
         .with_code("fn test_func() {}");

        let analysis = CodeAnalysis::new(PathBuf::from("test.rs"), crate::parser::Language::Rust);
        let mut analysis = analysis;
        analysis.symbols.push(symbol);

        let graph = DbKitMiddleware::analysis_to_portable(&analysis);
        assert_eq!(graph.entities.len(), 1);
        assert_eq!(graph.entities[0].name, "test_func");
    }
}
