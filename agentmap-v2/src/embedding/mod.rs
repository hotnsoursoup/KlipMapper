//! Embedding provider infrastructure.
//!
//! Uses db-kit's EmbeddingProvider with enum wrapper pattern
//! to handle non-dyn-compatible async traits.
//!
//! # Example
//!
//! ```rust,ignore
//! use agentmap::embedding::{EmbeddingProviderWrapper, EmbeddingConfig};
//!
//! // Initialize from environment
//! let provider = EmbeddingProviderWrapper::from_env()?;
//!
//! // Generate embedding
//! let embedding = provider.embed_one("fn parse() -> Result<()>").await?;
//! ```

mod provider;
mod config;

pub use provider::EmbeddingProviderWrapper;
pub use config::EmbeddingConfig;

#[cfg(feature = "embedding")]
pub use db_kit_lib::embedding::EmbeddingError;
