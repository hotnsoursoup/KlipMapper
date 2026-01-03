//! Middleware stack for composing multiple middleware.

use super::{Middleware, Context};
use crate::core::{Result, CodeAnalysis};
use crate::parser::ParsedFile;

/// Stack of middleware to execute in order.
pub struct MiddlewareStack {
    middleware: Vec<Box<dyn Middleware>>,
}

impl MiddlewareStack {
    /// Create a new empty stack.
    pub fn new() -> Self {
        Self {
            middleware: Vec::new(),
        }
    }

    /// Add middleware to the stack.
    pub fn push<M: Middleware + 'static>(&mut self, m: M) {
        self.middleware.push(Box::new(m));
    }

    /// Execute before_parse on all middleware.
    pub fn before_parse(&self, ctx: &mut Context) -> Result<()> {
        for m in &self.middleware {
            m.before_parse(ctx)?;
        }
        Ok(())
    }

    /// Execute after_parse on all middleware.
    pub fn after_parse(&self, ctx: &Context, parsed: &ParsedFile) -> Result<()> {
        for m in &self.middleware {
            m.after_parse(ctx, parsed)?;
        }
        Ok(())
    }

    /// Execute before_analyze on all middleware.
    pub fn before_analyze(&self, ctx: &mut Context) -> Result<()> {
        for m in &self.middleware {
            m.before_analyze(ctx)?;
        }
        Ok(())
    }

    /// Execute after_analyze on all middleware.
    pub fn after_analyze(&self, ctx: &Context, analysis: &CodeAnalysis) -> Result<()> {
        for m in &self.middleware {
            m.after_analyze(ctx, analysis)?;
        }
        Ok(())
    }

    /// Get number of middleware in stack.
    pub fn len(&self) -> usize {
        self.middleware.len()
    }

    /// Check if stack is empty.
    pub fn is_empty(&self) -> bool {
        self.middleware.is_empty()
    }
}

impl Default for MiddlewareStack {
    fn default() -> Self {
        Self::new()
    }
}
