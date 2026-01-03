//! Resolution chain for symbol resolution.

use crate::core::{SymbolId, SourceLocation};
use super::{SymbolTable, ResolutionContext};

/// Result of attempting to resolve a symbol reference.
#[derive(Debug, Clone)]
pub enum ResolvedReference {
    /// Successfully resolved to a single symbol.
    Resolved(SymbolId),

    /// Multiple candidates found (ambiguous).
    Ambiguous(Vec<SymbolId>),

    /// No matching symbol found in project.
    Unresolved {
        name: String,
        location: Option<SourceLocation>,
    },

    /// External symbol (not in project, e.g., stdlib).
    External {
        module: String,
        name: String,
    },
}

impl ResolvedReference {
    /// Check if resolution was successful.
    pub fn is_resolved(&self) -> bool {
        matches!(self, ResolvedReference::Resolved(_))
    }

    /// Get the resolved SymbolId if successful.
    pub fn symbol_id(&self) -> Option<&SymbolId> {
        match self {
            ResolvedReference::Resolved(id) => Some(id),
            _ => None,
        }
    }
}

/// Strategy for resolving symbol references.
pub trait ResolutionStrategy: Send + Sync {
    /// Attempt to resolve a name in context.
    fn try_resolve(
        &self,
        name: &str,
        ctx: &ResolutionContext,
        table: &SymbolTable,
    ) -> Option<ResolvedReference>;

    /// Strategy name for debugging.
    fn name(&self) -> &str;

    /// Priority (lower = tried first).
    fn priority(&self) -> u8 {
        100
    }
}

/// Chain of resolution strategies tried in order.
pub struct ResolutionChain {
    strategies: Vec<Box<dyn ResolutionStrategy>>,
}

impl ResolutionChain {
    /// Create a new empty chain.
    pub fn new() -> Self {
        Self {
            strategies: Vec::new(),
        }
    }

    /// Create chain with default strategies.
    ///
    /// Strategies are ordered by priority (lower = tried first):
    /// 1. LocalScope (10) - symbols in current file
    /// 2. RelativeImport (15) - Python relative imports
    /// 3. DefaultExport (18) - TS/JS default exports
    /// 4. ImportAlias (20) - general import aliases
    /// 5. GoPackage (22) - Go package.Symbol patterns
    /// 6. JavaFqn (24) - Java fully-qualified names
    /// 7. ReExport (25) - TypeScript/Rust re-exports
    /// 8. QualifiedPath (30) - module::name patterns
    /// 9. SiblingFile (40) - same directory files
    /// 10. Fuzzy (90) - fuzzy matching fallback
    pub fn default_chain() -> Self {
        use super::strategies::*;

        let mut chain = Self::new();

        // Core strategies
        chain.add(Box::new(LocalScopeStrategy));
        chain.add(Box::new(ImportAliasStrategy));
        chain.add(Box::new(QualifiedPathStrategy));
        chain.add(Box::new(SiblingFileStrategy));

        // Language-specific strategies
        chain.add(Box::new(RelativeImportStrategy));    // Python
        chain.add(Box::new(DefaultExportStrategy));     // TS/JS
        chain.add(Box::new(ReExportStrategy));          // TS/JS/Rust
        chain.add(Box::new(GoPackageStrategy));         // Go
        chain.add(Box::new(JavaFqnStrategy));           // Java

        // Fallback
        chain.add(Box::new(FuzzyStrategy::new(0.8)));

        chain
    }

    /// Add a strategy to the chain.
    pub fn add(&mut self, strategy: Box<dyn ResolutionStrategy>) {
        self.strategies.push(strategy);
        // Sort by priority
        self.strategies.sort_by_key(|s| s.priority());
    }

    /// Resolve a name using the strategy chain.
    pub fn resolve(
        &self,
        name: &str,
        ctx: &ResolutionContext,
        table: &SymbolTable,
    ) -> ResolvedReference {
        for strategy in &self.strategies {
            if let Some(result) = strategy.try_resolve(name, ctx, table) {
                match &result {
                    ResolvedReference::Resolved(_) | ResolvedReference::Ambiguous(_) => {
                        return result;
                    }
                    _ => continue,
                }
            }
        }

        ResolvedReference::Unresolved {
            name: name.to_string(),
            location: None,
        }
    }

    /// Resolve with location context for better error reporting.
    pub fn resolve_at(
        &self,
        name: &str,
        location: SourceLocation,
        ctx: &ResolutionContext,
        table: &SymbolTable,
    ) -> ResolvedReference {
        let result = self.resolve(name, ctx, table);

        match result {
            ResolvedReference::Unresolved { name, .. } => {
                ResolvedReference::Unresolved {
                    name,
                    location: Some(location),
                }
            }
            other => other,
        }
    }
}

impl Default for ResolutionChain {
    fn default() -> Self {
        Self::default_chain()
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::path::PathBuf;
    use crate::parser::Language;

    #[test]
    fn test_resolution_chain_order() {
        let chain = ResolutionChain::default_chain();
        assert!(!chain.strategies.is_empty());
    }

    #[test]
    fn test_unresolved_fallback() {
        let chain = ResolutionChain::new(); // Empty chain
        let table = SymbolTable::new();
        let ctx = ResolutionContext::new(PathBuf::from("test.rs"), Language::Rust);

        let result = chain.resolve("NonExistent", &ctx, &table);
        assert!(matches!(result, ResolvedReference::Unresolved { .. }));
    }
}
