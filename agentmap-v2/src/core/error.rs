//! Error types for AgentMap.

use std::path::PathBuf;
use thiserror::Error;

/// Result type for AgentMap operations.
pub type Result<T> = std::result::Result<T, Error>;

/// Error type for AgentMap operations.
#[derive(Error, Debug)]
pub enum Error {
    /// File I/O error.
    #[error("I/O error reading {path}: {source}")]
    Io {
        path: PathBuf,
        #[source]
        source: std::io::Error,
    },

    /// Unsupported language.
    #[error("Unsupported language for file: {path}")]
    UnsupportedLanguage { path: PathBuf },

    /// Parse error from TreeSitter.
    #[error("Failed to parse {path}: {message}")]
    Parse {
        path: PathBuf,
        message: String,
    },

    /// Analysis error.
    #[error("Analysis failed for {path}: {message}")]
    Analysis {
        path: PathBuf,
        message: String,
    },

    /// Query error (TreeSitter query compilation).
    #[error("Query error: {0}")]
    Query(String),

    /// Middleware error.
    #[error("Middleware error: {0}")]
    Middleware(String),

    /// Configuration error.
    #[error("Configuration error: {0}")]
    Config(String),

    /// Database error.
    #[error("Database error: {0}")]
    Database(String),

    /// Internal error (should not happen).
    #[error("Internal error: {0}")]
    Internal(String),

    /// Generic error with context.
    #[error("{context}: {message}")]
    Other {
        context: String,
        message: String,
    },
}

impl Error {
    /// Create an I/O error.
    pub fn io(path: impl Into<PathBuf>, source: std::io::Error) -> Self {
        Self::Io {
            path: path.into(),
            source,
        }
    }

    /// Create an I/O error with operation context.
    pub fn io_error(operation: &str, source: std::io::Error) -> Self {
        Self::Other {
            context: format!("I/O error during {}", operation),
            message: source.to_string(),
        }
    }

    /// Create an unsupported language error.
    pub fn unsupported_language(path: impl Into<PathBuf>) -> Self {
        Self::UnsupportedLanguage { path: path.into() }
    }

    /// Create a parse error.
    pub fn parse(path: impl Into<PathBuf>, message: impl Into<String>) -> Self {
        Self::Parse {
            path: path.into(),
            message: message.into(),
        }
    }

    /// Create an analysis error.
    pub fn analysis(path: impl Into<PathBuf>, message: impl Into<String>) -> Self {
        Self::Analysis {
            path: path.into(),
            message: message.into(),
        }
    }

    /// Create a query error.
    pub fn query(message: impl Into<String>) -> Self {
        Self::Query(message.into())
    }

    /// Create a middleware error.
    pub fn middleware(message: impl Into<String>) -> Self {
        Self::Middleware(message.into())
    }

    /// Create a config error.
    pub fn config(message: impl Into<String>) -> Self {
        Self::Config(message.into())
    }

    /// Create a database error.
    pub fn database(message: impl Into<String>) -> Self {
        Self::Database(message.into())
    }

    /// Create an internal error.
    pub fn internal(message: impl Into<String>) -> Self {
        Self::Internal(message.into())
    }

    /// Create a generic error with context.
    pub fn other(context: impl Into<String>, message: impl Into<String>) -> Self {
        Self::Other {
            context: context.into(),
            message: message.into(),
        }
    }
}


impl From<std::io::Error> for Error {
    fn from(e: std::io::Error) -> Self {
        Self::Io {
            path: PathBuf::new(),
            source: e,
        }
    }
}
