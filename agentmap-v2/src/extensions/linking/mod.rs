//! Symbol resolution and linking.
//!
//! Resolves bare symbol names to fully qualified SymbolIds.

mod table;
mod chain;
mod strategies;
mod middleware;
mod scope;
mod project;

pub use table::SymbolTable;
pub use chain::{ResolutionChain, ResolutionStrategy, ResolvedReference};
pub use strategies::{
    LocalScopeStrategy, ImportAliasStrategy, QualifiedPathStrategy,
    RelativeImportStrategy, DefaultExportStrategy, ReExportStrategy,
    GoPackageStrategy, JavaFqnStrategy,
};
pub use middleware::LinkerMiddleware;
pub use scope::{FrameKind, ScopeFrame, ScopeTracker};
pub use project::{ProjectAnalyzer, ProjectResolution, AmbiguousReference, UnresolvedReference, ExternalReference};

use std::path::PathBuf;

/// Context for symbol resolution within a specific scope.
#[derive(Debug, Clone)]
pub struct ResolutionContext {
    /// Current file being analyzed.
    pub file: PathBuf,

    /// Import aliases active in this scope (alias -> fully qualified).
    pub imports: std::collections::HashMap<String, String>,

    /// Current scope chain (e.g., ["MyModule", "MyClass", "my_method"]).
    pub scope_stack: Vec<String>,

    /// Language of the current file.
    pub language: crate::parser::Language,
}

impl ResolutionContext {
    /// Create a new resolution context for a file.
    pub fn new(file: PathBuf, language: crate::parser::Language) -> Self {
        Self {
            file,
            imports: std::collections::HashMap::new(),
            scope_stack: Vec::new(),
            language,
        }
    }

    /// Create from a ScopeTracker.
    pub fn from_tracker(file: PathBuf, language: crate::parser::Language, tracker: &ScopeTracker) -> Self {
        Self {
            file,
            imports: std::collections::HashMap::new(),
            scope_stack: tracker.scope_path(),
            language,
        }
    }

    /// Add an import alias to the context.
    pub fn add_import(&mut self, alias: &str, fully_qualified: &str) {
        self.imports.insert(alias.to_string(), fully_qualified.to_string());
    }

    /// Add multiple imports from a map.
    pub fn add_imports(&mut self, imports: std::collections::HashMap<String, String>) {
        self.imports.extend(imports);
    }

    /// Push a scope onto the stack.
    pub fn push_scope(&mut self, name: &str) {
        self.scope_stack.push(name.to_string());
    }

    /// Pop a scope from the stack.
    pub fn pop_scope(&mut self) {
        self.scope_stack.pop();
    }

    /// Get the current fully qualified scope prefix.
    pub fn current_scope(&self) -> String {
        if self.scope_stack.is_empty() {
            self.file.to_string_lossy().to_string()
        } else {
            format!("{}::{}", self.file.to_string_lossy(), self.scope_stack.join("::"))
        }
    }

    /// Build a qualified name in the current scope.
    pub fn qualified_name(&self, name: &str) -> String {
        if self.scope_stack.is_empty() {
            name.to_string()
        } else {
            format!("{}::{}", self.scope_stack.join("::"), name)
        }
    }
}
