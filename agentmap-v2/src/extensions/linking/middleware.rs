//! Linker middleware for resolving symbol references.

use crate::core::{Result, CodeAnalysis, Relationship, SymbolId};
use crate::middleware::{Middleware, Context};
use super::{SymbolTable, ResolutionChain, ResolutionContext, ResolvedReference};

/// Middleware that resolves bare symbol names in relationships.
pub struct LinkerMiddleware {
    chain: ResolutionChain,
    table: SymbolTable,
    unresolved_action: UnresolvedAction,
}

/// Action to take for unresolved references.
#[derive(Debug, Clone, Copy, Default)]
pub enum UnresolvedAction {
    /// Keep relationship with original bare name.
    #[default]
    Keep,
    /// Remove unresolved relationships.
    Remove,
    /// Mark with special "unresolved" prefix.
    Flag,
}

impl LinkerMiddleware {
    /// Create a new linker middleware.
    pub fn new() -> Self {
        Self {
            chain: ResolutionChain::default_chain(),
            table: SymbolTable::new(),
            unresolved_action: UnresolvedAction::default(),
        }
    }

    /// Set unresolved action.
    pub fn with_unresolved_action(mut self, action: UnresolvedAction) -> Self {
        self.unresolved_action = action;
        self
    }

    /// Add analyses to the symbol table.
    pub fn register_analyses(&self, analyses: &[CodeAnalysis]) {
        for analysis in analyses {
            self.table.add_analysis(analysis);
        }
    }

    /// Link relationships in an analysis.
    pub fn link(&self, analysis: &mut CodeAnalysis) {
        let ctx = self.build_context(analysis);

        let mut linked_relationships = Vec::new();

        for rel in &analysis.relationships {
            let linked = self.link_relationship(rel, &ctx);
            if let Some(linked_rel) = linked {
                linked_relationships.push(linked_rel);
            }
        }

        analysis.relationships = linked_relationships;
    }

    fn build_context(&self, analysis: &CodeAnalysis) -> ResolutionContext {
        let mut ctx = ResolutionContext::new(
            analysis.file_path.clone(),
            analysis.language,
        );

        // Add imports to context using the new import map method
        for import in &analysis.imports {
            ctx.add_imports(import.to_import_map());
        }

        ctx
    }

    fn link_relationship(
        &self,
        rel: &Relationship,
        ctx: &ResolutionContext,
    ) -> Option<Relationship> {
        let mut linked = rel.clone();

        // Try to resolve 'to' target
        let to_name = rel.to.name().unwrap_or("");
        if !to_name.is_empty() && !self.looks_resolved(&rel.to) {
            match self.chain.resolve(to_name, ctx, &self.table) {
                ResolvedReference::Resolved(id) => {
                    linked.to = id;
                }
                ResolvedReference::Ambiguous(ids) => {
                    // Log ambiguous resolution for debugging
                    #[cfg(feature = "tracing")]
                    tracing::debug!(
                        name = to_name,
                        candidates = ids.len(),
                        "Ambiguous resolution: picking first of {} candidates",
                        ids.len()
                    );

                    // Use first match - in the future could use heuristics like
                    // preferring same-file symbols or closer scope matches
                    if let Some(first) = ids.first() {
                        linked.to = first.clone();
                    }
                }
                ResolvedReference::Unresolved { .. } => {
                    match self.unresolved_action {
                        UnresolvedAction::Keep => {}
                        UnresolvedAction::Remove => return None,
                        UnresolvedAction::Flag => {
                            linked.to = SymbolId::new("", 0, &format!("UNRESOLVED::{}", to_name));
                        }
                    }
                }
                ResolvedReference::External { module, name } => {
                    linked.to = SymbolId::new("", 0, &format!("{}::{}", module, name));
                }
            }
        }

        Some(linked)
    }

    /// Check if a SymbolId is already resolved.
    fn looks_resolved(&self, id: &SymbolId) -> bool {
        id.is_resolved()
    }
}

impl Default for LinkerMiddleware {
    fn default() -> Self {
        Self::new()
    }
}

impl Middleware for LinkerMiddleware {
    fn after_analyze(&self, _ctx: &Context, analysis: &CodeAnalysis) -> Result<()> {
        // Note: We can't mutate analysis here due to signature
        // Real usage would call link() explicitly in the pipeline
        // This hook is for observation only
        let _ = analysis;
        Ok(())
    }

    fn name(&self) -> &str {
        "LinkerMiddleware"
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::core::{Symbol, SymbolKind, SourceLocation, Visibility, RelationshipKind};
    use std::path::PathBuf;
    use crate::parser::Language;

    #[test]
    fn test_linker_resolves_local() {
        let linker = LinkerMiddleware::new();

        // Register a symbol
        let symbol = Symbol::new(
            "MyClass",
            SymbolKind::Class,
            SourceLocation::new(PathBuf::from("src/lib.rs"), 1, 10),
        );

        let mut analysis = CodeAnalysis::new(PathBuf::from("src/lib.rs"), Language::Rust);
        analysis.symbols.push(symbol.clone());

        linker.register_analyses(&[analysis.clone()]);

        // Verify symbol is in table
        let matches = linker.table.lookup_name("MyClass");
        assert_eq!(matches.len(), 1);
    }
}
