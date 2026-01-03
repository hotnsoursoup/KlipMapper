//! Storage layer for embedding persistence.
//!
//! Provides SQLite-based storage for code embeddings with:
//! - Symbol metadata (name, kind, file, content hash)
//! - Vector embeddings (768-dim f32 arrays as BLOB)
//! - Code relationships (calls, imports, extends)
//!
//! # Example
//!
//! ```rust,ignore
//! use agentmap::storage::EmbeddingRepository;
//!
//! let repo = EmbeddingRepository::open(".agentmap/embeddings.db").await?;
//!
//! // Store embedding
//! repo.store_embedding("sym_123", &embedding, metadata).await?;
//!
//! // Search similar
//! let results = repo.search_similar(&query_embedding, 10).await?;
//! ```

mod repository;
mod vector;
mod schema;

pub use repository::{EmbeddingRepository, EmbeddingMetadata, SearchResult};
pub use vector::{
    embedding_to_blob,
    try_blob_to_embedding,
    cosine_similarity,
    BlobConversionError,
};

// Re-export deprecated function for backward compatibility
#[allow(deprecated)]
pub use vector::blob_to_embedding;
