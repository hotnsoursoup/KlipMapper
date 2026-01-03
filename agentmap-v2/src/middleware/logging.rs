//! Logging middleware for observability.

use crate::core::{Result, CodeAnalysis};
use crate::parser::ParsedFile;
use super::{Middleware, Context};

/// Middleware that logs analysis events.
///
/// Uses the tracing crate when the `tracing` feature is enabled,
/// otherwise falls back to no-op.
pub struct LoggingMiddleware {
    level: LogLevel,
}

/// Log level for middleware.
#[derive(Debug, Clone, Copy, Default)]
pub enum LogLevel {
    Debug,
    #[default]
    Info,
    Warn,
}

impl LoggingMiddleware {
    /// Create a new logging middleware with default level.
    pub fn new() -> Self {
        Self::default()
    }

    /// Create with a specific log level.
    pub fn with_level(level: LogLevel) -> Self {
        Self { level }
    }

    #[cfg(feature = "tracing")]
    fn log(&self, message: &str) {
        match self.level {
            LogLevel::Debug => tracing::debug!("{}", message),
            LogLevel::Info => tracing::info!("{}", message),
            LogLevel::Warn => tracing::warn!("{}", message),
        }
    }

    #[cfg(not(feature = "tracing"))]
    fn log(&self, message: &str) {
        match self.level {
            LogLevel::Debug => eprintln!("[DEBUG] {}", message),
            LogLevel::Info => eprintln!("[INFO] {}", message),
            LogLevel::Warn => eprintln!("[WARN] {}", message),
        }
    }
}

impl Default for LoggingMiddleware {
    fn default() -> Self {
        Self {
            level: LogLevel::default(),
        }
    }
}

impl Middleware for LoggingMiddleware {
    fn before_parse(&self, ctx: &mut Context) -> Result<()> {
        self.log(&format!("Parsing: {}", ctx.path.display()));
        Ok(())
    }

    fn after_parse(&self, ctx: &Context, parsed: &ParsedFile) -> Result<()> {
        self.log(&format!(
            "Parsed: {} - {} symbols in {}ms",
            ctx.path.display(),
            parsed.symbols.len(),
            ctx.elapsed_ms()
        ));
        Ok(())
    }

    fn before_analyze(&self, ctx: &mut Context) -> Result<()> {
        self.log(&format!("Analyzing: {}", ctx.path.display()));
        Ok(())
    }

    fn after_analyze(&self, ctx: &Context, analysis: &CodeAnalysis) -> Result<()> {
        self.log(&format!(
            "Analyzed: {} - {} symbols, {} relationships in {}ms",
            ctx.path.display(),
            analysis.symbols.len(),
            analysis.relationships.len(),
            ctx.elapsed_ms()
        ));
        Ok(())
    }

    fn name(&self) -> &str {
        "LoggingMiddleware"
    }
}
