//! Relationship types for code element connections.

use serde::{Deserialize, Serialize};
use super::{SourceLocation, SymbolId};
use std::collections::HashMap;

/// A relationship between two symbols.
///
/// Maps directly to db-kit's Relationship type for graph indexing.
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub struct Relationship {
    /// Source symbol ID.
    pub from: SymbolId,

    /// Target symbol ID.
    pub to: SymbolId,

    /// Type of relationship.
    pub kind: RelationshipKind,

    /// Where this relationship was detected.
    pub location: SourceLocation,

    /// Confidence score (0.0 - 1.0).
    pub confidence: f32,

    /// Additional metadata.
    pub properties: HashMap<String, String>,
}

impl Relationship {
    /// Create a new relationship.
    pub fn new(from: SymbolId, kind: RelationshipKind, to: SymbolId, location: SourceLocation) -> Self {
        Self {
            from,
            to,
            kind,
            location,
            confidence: 1.0,
            properties: HashMap::new(),
        }
    }

    /// Set confidence score.
    pub fn with_confidence(mut self, confidence: f32) -> Self {
        self.confidence = confidence.clamp(0.0, 1.0);
        self
    }

    /// Add a property.
    pub fn with_property(mut self, key: impl Into<String>, value: impl Into<String>) -> Self {
        self.properties.insert(key.into(), value.into());
        self
    }
}

/// Type of relationship between symbols.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
#[serde(rename_all = "SCREAMING_SNAKE_CASE")]
pub enum RelationshipKind {
    // Inheritance
    /// Class extends another class.
    Inherits,
    /// Class implements an interface/trait.
    Implements,
    /// Type alias for another type.
    TypeOf,

    // Composition
    /// A field/property of a type.
    HasField,
    /// A method of a type.
    HasMethod,
    /// Contains (nested class, inner function).
    Contains,

    // Dependencies
    /// Imports a module/file.
    Imports,
    /// Uses a symbol from another module.
    Uses,
    /// Calls a function/method.
    Calls,
    /// Instantiates a type.
    Instantiates,

    // References
    /// References a type in signature.
    References,
    /// Returns a type.
    Returns,
    /// Takes a type as parameter.
    TakesParam,

    // Module structure
    /// Exports a symbol.
    Exports,
    /// Re-exports a symbol.
    ReExports,

    // Decoration
    /// Decorated by (Python decorators, Java annotations).
    DecoratedBy,

    // Generic fallback
    /// Unknown relationship type.
    Unknown,
}

impl RelationshipKind {
    /// Check if this is an inheritance relationship.
    pub fn is_inheritance(&self) -> bool {
        matches!(self, Self::Inherits | Self::Implements | Self::TypeOf)
    }

    /// Check if this is a dependency relationship.
    pub fn is_dependency(&self) -> bool {
        matches!(
            self,
            Self::Imports | Self::Uses | Self::Calls | Self::Instantiates
        )
    }

    /// Check if this creates a strong coupling.
    pub fn is_strong_coupling(&self) -> bool {
        matches!(
            self,
            Self::Inherits | Self::Implements | Self::HasField | Self::Instantiates
        )
    }
}

impl std::fmt::Display for RelationshipKind {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let s = match self {
            Self::Inherits => "INHERITS",
            Self::Implements => "IMPLEMENTS",
            Self::TypeOf => "TYPE_OF",
            Self::HasField => "HAS_FIELD",
            Self::HasMethod => "HAS_METHOD",
            Self::Contains => "CONTAINS",
            Self::Imports => "IMPORTS",
            Self::Uses => "USES",
            Self::Calls => "CALLS",
            Self::Instantiates => "INSTANTIATES",
            Self::References => "REFERENCES",
            Self::Returns => "RETURNS",
            Self::TakesParam => "TAKES_PARAM",
            Self::Exports => "EXPORTS",
            Self::ReExports => "RE_EXPORTS",
            Self::DecoratedBy => "DECORATED_BY",
            Self::Unknown => "UNKNOWN",
        };
        write!(f, "{s}")
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::path::PathBuf;

    #[test]
    fn test_relationship_creation() {
        let loc = SourceLocation::new(PathBuf::from("test.rs"), 1, 10);
        let from = SymbolId::new("test.rs", 1, "Child");
        let to = SymbolId::new("test.rs", 50, "Parent");

        let rel = Relationship::new(from, RelationshipKind::Inherits, to, loc)
            .with_confidence(0.95)
            .with_property("language", "rust");

        assert_eq!(rel.kind, RelationshipKind::Inherits);
        assert_eq!(rel.confidence, 0.95);
        assert_eq!(rel.properties.get("language"), Some(&"rust".to_string()));
    }

    #[test]
    fn test_relationship_categories() {
        assert!(RelationshipKind::Inherits.is_inheritance());
        assert!(RelationshipKind::Implements.is_inheritance());
        assert!(!RelationshipKind::Calls.is_inheritance());

        assert!(RelationshipKind::Calls.is_dependency());
        assert!(RelationshipKind::Imports.is_dependency());
    }
}
