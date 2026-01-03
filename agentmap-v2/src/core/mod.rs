//! Core types with zero external dependencies.
//!
//! These types are the foundation of AgentMap and are designed to be
//! compatible with db-kit's entity and relationship types.

mod symbol;
mod relationship;
mod analysis;
mod location;
mod error;

pub use symbol::{Symbol, SymbolId, SymbolKind, Visibility};
pub use relationship::{Relationship, RelationshipKind};
pub use analysis::{CodeAnalysis, AnalysisMetadata, Import, ImportedName};
pub use location::SourceLocation;
pub use error::{Error, Result};
