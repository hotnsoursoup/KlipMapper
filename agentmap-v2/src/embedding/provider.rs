//! Embedding provider wrapper using enum pattern.
//!
//! This module provides an enum wrapper around db-kit's embedding providers
//! to handle the non-dyn-compatible async traits.

#[cfg(feature = "embedding")]
use db_kit_lib::embedding::{
    EmbeddingError, EmbeddingProvider,
    GeminiEmbeddings, GeminiModel,
};

#[cfg(all(feature = "embedding", feature = "embedding-openai"))]
use db_kit_lib::embedding::{OpenAiEmbeddings, OpenAiModel};

#[cfg(all(feature = "embedding", feature = "embedding-ollama"))]
use db_kit_lib::embedding::OllamaEmbeddings;

#[cfg(all(feature = "embedding", feature = "embedding-ollama"))]
use std::env;



/// Wrapper enum for embedding providers.
///
/// This pattern allows storing embedding providers in structs without
/// requiring `dyn Trait`, which isn't possible for async traits.
///
/// # Supported Providers
///
/// - `Gemini` - Google's text-embedding-004 (768 dims, default)
/// - `OpenAi` - OpenAI's text-embedding-3-small (requires `embedding-openai` feature)
/// - `Ollama` - Local Ollama server (requires `embedding-ollama` feature)
#[cfg(feature = "embedding")]
#[derive(Debug, Clone)]
pub enum EmbeddingProviderWrapper {
    /// Google Gemini embeddings (text-embedding-004)
    Gemini(GeminiEmbeddings),

    /// OpenAI embeddings (requires embedding-openai feature)
    #[cfg(feature = "embedding-openai")]
    OpenAi(OpenAiEmbeddings),

    /// Ollama local embeddings (requires embedding-ollama feature)
    #[cfg(feature = "embedding-ollama")]
    Ollama(OllamaEmbeddings),
}

#[cfg(feature = "embedding")]
impl EmbeddingProviderWrapper {
    /// Create from environment variables.
    ///
    /// Checks in order:
    /// 1. `GEMINI_API_KEY` or `GOOGLE_API_KEY` → Gemini provider
    /// 2. `OPENAI_API_KEY` → OpenAI provider (if feature enabled)
    /// 3. `OLLAMA_HOST` → Ollama provider (if feature enabled)
    ///
    /// Returns error if no provider can be configured.
    pub fn from_env() -> Result<Self, EmbeddingError> {
        // Try Gemini first (default)
        if let Ok(provider) = GeminiEmbeddings::from_env() {
            return Ok(Self::Gemini(provider));
        }

        // Try OpenAI if feature enabled
        #[cfg(feature = "embedding-openai")]
        if let Ok(provider) = OpenAiEmbeddings::from_env() {
            return Ok(Self::OpenAi(provider));
        }

        // Try Ollama if feature enabled
        #[cfg(feature = "embedding-ollama")]
        if env::var("OLLAMA_HOST").is_ok() || env::var("OLLAMA_URL").is_ok() {
            if let Ok(provider) = OllamaEmbeddings::from_env() {
                return Ok(Self::Ollama(provider));
            }
        }

        Err(EmbeddingError::config(
            "No embedding provider configured. Set GEMINI_API_KEY, OPENAI_API_KEY, or OLLAMA_HOST.",
        ))
    }

    /// Create a Gemini provider with explicit API key.
    pub fn gemini(api_key: impl Into<String>) -> Result<Self, EmbeddingError> {
        let provider = GeminiEmbeddings::new(api_key)?
            .with_model(GeminiModel::TextEmbedding004);
        Ok(Self::Gemini(provider))
    }

    /// Create an OpenAI provider with explicit API key.
    #[cfg(feature = "embedding-openai")]
    pub fn openai(api_key: impl Into<String>) -> Result<Self, EmbeddingError> {
        let provider = OpenAiEmbeddings::new(api_key)?
            .with_model(OpenAiModel::TextEmbedding3Small);
        Ok(Self::OpenAi(provider))
    }

    /// Create an Ollama provider connecting to local server.
    #[cfg(feature = "embedding-ollama")]
    pub fn ollama(host: impl Into<String>) -> Result<Self, EmbeddingError> {
        let provider = OllamaEmbeddings::new(host)?;
        Ok(Self::Ollama(provider))
    }

    /// Embed a single text into a vector.
    pub async fn embed_one(&self, text: &str) -> Result<Vec<f32>, EmbeddingError> {
        match self {
            Self::Gemini(provider) => provider.embed_one(text).await,
            #[cfg(feature = "embedding-openai")]
            Self::OpenAi(provider) => provider.embed_one(text).await,
            #[cfg(feature = "embedding-ollama")]
            Self::Ollama(provider) => provider.embed_one(text).await,
        }
    }

    /// Embed multiple texts into vectors (batch operation).
    pub async fn embed(&self, texts: &[&str]) -> Result<Vec<Vec<f32>>, EmbeddingError> {
        match self {
            Self::Gemini(provider) => provider.embed(texts).await,
            #[cfg(feature = "embedding-openai")]
            Self::OpenAi(provider) => provider.embed(texts).await,
            #[cfg(feature = "embedding-ollama")]
            Self::Ollama(provider) => provider.embed(texts).await,
        }
    }

    /// Get the embedding dimensions for this provider.
    pub fn dimensions(&self) -> usize {
        match self {
            Self::Gemini(provider) => provider.dimensions(),
            #[cfg(feature = "embedding-openai")]
            Self::OpenAi(provider) => provider.dimensions(),
            #[cfg(feature = "embedding-ollama")]
            Self::Ollama(provider) => provider.dimensions(),
        }
    }

    /// Get the maximum input tokens for this provider.
    pub fn max_input_tokens(&self) -> usize {
        match self {
            Self::Gemini(provider) => provider.max_input_tokens(),
            #[cfg(feature = "embedding-openai")]
            Self::OpenAi(provider) => provider.max_input_tokens(),
            #[cfg(feature = "embedding-ollama")]
            Self::Ollama(provider) => provider.max_input_tokens(),
        }
    }

    /// Get the provider name.
    pub fn name(&self) -> &str {
        match self {
            Self::Gemini(_) => "gemini",
            #[cfg(feature = "embedding-openai")]
            Self::OpenAi(_) => "openai",
            #[cfg(feature = "embedding-ollama")]
            Self::Ollama(_) => "ollama",
        }
    }

    /// Get the model name.
    pub fn model_name(&self) -> &str {
        match self {
            Self::Gemini(_) => "text-embedding-004",
            #[cfg(feature = "embedding-openai")]
            Self::OpenAi(_) => "text-embedding-3-small",
            #[cfg(feature = "embedding-ollama")]
            Self::Ollama(_) => "nomic-embed-text",
        }
    }

    /// Check if the provider is available and configured.
    pub fn is_available(&self) -> bool {
        match self {
            Self::Gemini(provider) => provider.is_available(),
            #[cfg(feature = "embedding-openai")]
            Self::OpenAi(provider) => provider.is_available(),
            #[cfg(feature = "embedding-ollama")]
            Self::Ollama(provider) => provider.is_available(),
        }
    }
}

/// Stub for when embedding feature is disabled.
#[cfg(not(feature = "embedding"))]
#[derive(Debug, Clone, Default)]
pub struct EmbeddingProviderWrapper;

#[cfg(not(feature = "embedding"))]
impl EmbeddingProviderWrapper {
    pub fn from_env() -> Result<Self, String> {
        Err("Embedding feature not enabled. Compile with --features embedding".to_string())
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    #[cfg(feature = "embedding")]
    fn test_gemini_provider_creation() {
        // This will fail without a valid API key, but tests the construction
        let result = EmbeddingProviderWrapper::gemini("test-key");
        assert!(result.is_ok());

        let provider = result.unwrap();
        assert_eq!(provider.name(), "gemini");
        assert_eq!(provider.dimensions(), 768);
    }

    #[test]
    #[cfg(feature = "embedding")]
    fn test_from_env_no_keys() {
        // Clear relevant env vars for this test
        std::env::remove_var("GEMINI_API_KEY");
        std::env::remove_var("GOOGLE_API_KEY");
        std::env::remove_var("OPENAI_API_KEY");
        std::env::remove_var("OLLAMA_HOST");

        let result = EmbeddingProviderWrapper::from_env();
        assert!(result.is_err());
    }
}
