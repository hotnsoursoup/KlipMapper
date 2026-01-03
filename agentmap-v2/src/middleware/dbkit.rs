//! db-kit integration middleware.
//!
//! This middleware converts AgentMap symbols and relationships
//! to db-kit entities and relationships for RAG indexing.

#[cfg(feature = "db-kit")]
use db_kit_lib as db_kit;

use crate::core::{Result, CodeAnalysis, Symbol, Relationship, RelationshipKind, SymbolKind};
use crate::parser::ParsedFile;
use super::{Middleware, Context};
use std::collections::HashMap;


/// Middleware that converts analysis results to db-kit format.
///
/// This enables direct indexing of code symbols for RAG retrieval.
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

    /// Convert AgentMap Symbol to db-kit Entity format.
    #[cfg(feature = "db-kit")]
    pub fn symbol_to_entity(symbol: &Symbol) -> db_kit::entity::Entity {
        use db_kit::entity::{Entity, EntityType};

        let entity_type = match symbol.kind {
            SymbolKind::Function | SymbolKind::Method | SymbolKind::AsyncFunction => EntityType::Function,
            SymbolKind::Class | SymbolKind::Struct | SymbolKind::Interface | SymbolKind::Trait => EntityType::Type,
            SymbolKind::Module | SymbolKind::Namespace | SymbolKind::Package => EntityType::Module,
            _ => EntityType::Unknown,
        };

        let mut entity = Entity::new(symbol.name.clone(), entity_type);

        // Add properties
        entity = entity.with_property("kind", symbol.kind.to_string());
        entity = entity.with_property("visibility", symbol.visibility.to_string());
        entity = entity.with_property("file", symbol.location.file_path.to_string_lossy().to_string());
        entity = entity.with_property("line", symbol.location.start_line.to_string());

        // Add code content for embeddings
        if !symbol.code_content.is_empty() {
            entity = entity.with_property("code", symbol.code_content.clone());
        }

        // Add documentation
        if let Some(ref docs) = symbol.documentation {
            entity = entity.with_property("documentation", docs.clone());
        }

        // Set span for source tracking
        entity = entity.with_span(
            symbol.location.byte_offset as usize,
            (symbol.location.byte_offset + symbol.location.byte_length) as usize,
        );

        entity
    }

    /// Convert AgentMap Relationship to db-kit Relationship format.
    #[cfg(feature = "db-kit")]
    pub fn relationship_to_dbkit(rel: &Relationship) -> db_kit::entity::Relationship {
        let rel_type = match rel.kind {
            RelationshipKind::Inherits => "INHERITS",
            RelationshipKind::Implements => "IMPLEMENTS",
            RelationshipKind::Imports => "IMPORTS",
            RelationshipKind::Uses => "USES",
            RelationshipKind::Calls => "CALLS",
            RelationshipKind::Contains => "CONTAINS",
            RelationshipKind::References => "REFERENCES",
            _ => "RELATED_TO",
        };

        db_kit::entity::Relationship::new(
            rel.from.0.clone(),
            rel.to.0.clone(),
            rel_type.to_string(),
        )
    }

    /// Convert a full CodeAnalysis to db-kit ExtractedGraph.
    #[cfg(feature = "db-kit")]
    pub fn analysis_to_graph(analysis: &CodeAnalysis) -> db_kit::entity::ExtractedGraph {
        let entities: Vec<_> = analysis.symbols
            .iter()
            .map(|s| Self::symbol_to_entity(s))
            .collect();

        let relationships: Vec<_> = analysis.relationships
            .iter()
            .map(|r| Self::relationship_to_dbkit(r))
            .collect();

        db_kit::entity::ExtractedGraph {
            entities,
            relationships,
        }
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
    use crate::core::{SourceLocation, Visibility};
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
