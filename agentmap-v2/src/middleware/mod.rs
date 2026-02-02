//! Middleware system for extensibility.
//!
//! Middleware allows intercepting and extending the analysis pipeline
//! with cross-cutting concerns like logging, caching, metrics, and indexing.
//!
//! # Built-in Middleware
//!
//! - [`LoggingMiddleware`] - Logs analysis events
//! - [`CachingMiddleware`] - Caches analysis results by content hash
//! - [`MetricsMiddleware`] - Collects analysis metrics
//! - [`DbKitMiddleware`] - Converts to db-kit format for RAG
//!
//! # Example
//!
//! ```rust,ignore
//! use agentmap::{AgentMap, middleware::*};
//!
//! let mut agent = AgentMap::new();
//! agent.add_middleware(LoggingMiddleware::new());
//! agent.add_middleware(MetricsMiddleware::new());
//! ```

mod stack;
mod context;
mod logging;
mod caching;
mod metrics;
mod dbkit;

pub use stack::MiddlewareStack;
pub use context::Context;
pub use logging::{LoggingMiddleware, LogLevel};
pub use caching::{CachingMiddleware, CacheStats};
pub use metrics::{MetricsMiddleware, MetricsSnapshot};
pub use dbkit::{DbKitMiddleware, PortableGraph, PortableEntity, PortableRelationship};

use crate::core::{Result, CodeAnalysis};
use crate::parser::ParsedFile;

/// Middleware trait for intercepting analysis phases.
///
/// Implement this trait to add cross-cutting concerns like:
/// - Logging
/// - Caching
/// - Metrics
/// - db-kit indexing
pub trait Middleware: Send + Sync {
    /// Called before parsing a file.
    fn before_parse(&self, _ctx: &mut Context) -> Result<()> {
        Ok(())
    }

    /// Called after parsing a file.
    fn after_parse(&self, _ctx: &Context, _parsed: &ParsedFile) -> Result<()> {
        Ok(())
    }

    /// Called before analysis.
    fn before_analyze(&self, _ctx: &mut Context) -> Result<()> {
        Ok(())
    }

    /// Called after analysis.
    fn after_analyze(&self, _ctx: &Context, _analysis: &CodeAnalysis) -> Result<()> {
        Ok(())
    }

    /// Middleware name for debugging.
    fn name(&self) -> &str {
        std::any::type_name::<Self>()
    }
}
