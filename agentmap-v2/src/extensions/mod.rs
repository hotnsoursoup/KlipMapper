//! Phase 5 Extensions for enhanced analysis.
//!
//! This module provides advanced features:
//! - Symbol resolution and linking
//! - Contextual enrichment for embeddings
//! - AST-aware code chunking
//! - Incremental analysis with caching

pub mod linking;
pub mod enrichment;
pub mod chunking;
pub mod incremental;

pub use linking::{SymbolTable, ResolutionChain, ResolvedReference, LinkerMiddleware};
pub use enrichment::{EnrichmentProvider, EnrichmentPipeline};
pub use chunking::{ChunkStrategy, CodeChunk, ChunkConfig};
pub use incremental::{StateCache, DeltaDetector, IncrementalMiddleware};
