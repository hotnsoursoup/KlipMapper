//! Project-level analysis with cross-file symbol resolution.
//!
//! Implements two-pass analysis:
//! 1. First pass: Collect all declarations and build global symbol table
//! 2. Second pass: Resolve references using the global table

use std::path::PathBuf;
use std::collections::HashMap;
use std::sync::Arc;
use crate::core::{Result, CodeAnalysis, Symbol};
use crate::parser::ParsedFile;
use super::{SymbolTable, ResolutionChain, ResolutionContext, ResolvedReference};
use crate::analyzer::{DefaultAnalyzer, Analyzer};

/// Project-wide analyzer that performs two-pass analysis.
///
/// This enables cross-file symbol resolution by:
/// 1. First collecting all declarations from all files
/// 2. Then resolving references with the full symbol table
pub struct ProjectAnalyzer {
    /// All file analyses keyed by path.
    file_analyses: HashMap<PathBuf, CodeAnalysis>,

    /// Global symbol table containing all symbols.
    global_table: SymbolTable,

    /// Resolution chain for symbol lookup.
    resolution_chain: ResolutionChain,

    /// Single-file analyzer for initial parsing.
    file_analyzer: DefaultAnalyzer,
}

impl ProjectAnalyzer {
    /// Create a new project analyzer.
    pub fn new() -> Self {
        Self {
            file_analyses: HashMap::new(),
            global_table: SymbolTable::new(),
            resolution_chain: ResolutionChain::default_chain(),
            file_analyzer: DefaultAnalyzer::new(),
        }
    }

    /// Analyze a single file (first pass).
    ///
    /// Extracts declarations and adds them to the global table.
    /// Does NOT resolve references yet.
    pub fn add_file(&mut self, parsed: &ParsedFile, path: &PathBuf) -> Result<()> {
        // Run basic analysis
        let analysis = self.file_analyzer.analyze(parsed, path)?;

        // Add symbols to global table
        self.global_table.add_analysis(&analysis);

        // Store analysis for later resolution
        self.file_analyses.insert(path.clone(), analysis);

        Ok(())
    }

    /// Add multiple files in batch (convenience method).
    pub fn add_files(&mut self, files: &[(ParsedFile, PathBuf)]) -> Result<()> {
        for (parsed, path) in files {
            self.add_file(parsed, path)?;
        }
        Ok(())
    }

    /// Resolve references across all files (second pass).
    ///
    /// This should be called after all files have been added.
    pub fn resolve_all(&mut self) -> Result<ProjectResolution> {
        let mut resolution = ProjectResolution::new();

        for (path, analysis) in &self.file_analyses {
            // Build resolution context for this file
            let mut ctx = ResolutionContext::new(path.clone(), analysis.language);

            // Add imports from the file
            for import in &analysis.imports {
                ctx.add_imports(import.to_import_map());
            }

            // Resolve each relationship target
            for rel in &analysis.relationships {
                let to_name = rel.to.name().unwrap_or("");
                if to_name.is_empty() {
                    continue;
                }

                // Check if already resolved (has file:line:name format)
                if rel.to.is_resolved() {
                    resolution.resolved_count += 1;
                    continue;
                }

                // Try to resolve
                match self.resolution_chain.resolve(to_name, &ctx, &self.global_table) {
                    ResolvedReference::Resolved(id) => {
                        resolution.resolved_count += 1;
                        resolution.resolutions.insert(
                            (path.clone(), rel.to.clone()),
                            id,
                        );
                    }
                    ResolvedReference::Ambiguous(candidates) => {
                        resolution.ambiguous_count += 1;
                        resolution.ambiguous.push(AmbiguousReference {
                            file: path.clone(),
                            name: to_name.to_string(),
                            candidates: candidates.iter().map(|c| c.0.clone()).collect(),
                        });
                    }
                    ResolvedReference::Unresolved { name, location: _ } => {
                        resolution.unresolved_count += 1;
                        resolution.unresolved.push(UnresolvedReference {
                            file: path.clone(),
                            name,
                        });
                    }
                    ResolvedReference::External { module, name } => {
                        resolution.external_count += 1;
                        resolution.external.push(ExternalReference {
                            file: path.clone(),
                            module,
                            name,
                        });
                    }
                }
            }
        }

        Ok(resolution)
    }

    /// Get analysis for a specific file.
    pub fn get_analysis(&self, path: &PathBuf) -> Option<&CodeAnalysis> {
        self.file_analyses.get(path)
    }

    /// Get mutable analysis for a specific file.
    pub fn get_analysis_mut(&mut self, path: &PathBuf) -> Option<&mut CodeAnalysis> {
        self.file_analyses.get_mut(path)
    }

    /// Get all file paths in the project.
    pub fn files(&self) -> impl Iterator<Item = &PathBuf> {
        self.file_analyses.keys()
    }

    /// Get the global symbol table.
    pub fn symbol_table(&self) -> &SymbolTable {
        &self.global_table
    }

    /// Lookup a symbol by fully qualified name.
    pub fn lookup_symbol(&self, fqn: &str) -> Option<Arc<Symbol>> {
        self.global_table.lookup_fqn(fqn)
            .and_then(|id| self.global_table.get(&id))
    }

    /// Clear all analyses.
    pub fn clear(&mut self) {
        self.file_analyses.clear();
        self.global_table = SymbolTable::new();
    }

    /// Get symbol count.
    pub fn symbol_count(&self) -> usize {
        self.global_table.len()
    }

    /// Get file count.
    pub fn file_count(&self) -> usize {
        self.file_analyses.len()
    }
}

impl Default for ProjectAnalyzer {
    fn default() -> Self {
        Self::new()
    }
}

/// Results from project-wide resolution.
#[derive(Debug, Default)]
pub struct ProjectResolution {
    /// Map of (file, original_id) -> resolved_id.
    pub resolutions: HashMap<(PathBuf, crate::core::SymbolId), crate::core::SymbolId>,

    /// Count of successfully resolved references.
    pub resolved_count: usize,

    /// Count of ambiguous references.
    pub ambiguous_count: usize,

    /// Count of unresolved references.
    pub unresolved_count: usize,

    /// Count of external references.
    pub external_count: usize,

    /// Details of ambiguous references.
    pub ambiguous: Vec<AmbiguousReference>,

    /// Details of unresolved references.
    pub unresolved: Vec<UnresolvedReference>,

    /// Details of external references.
    pub external: Vec<ExternalReference>,
}

impl ProjectResolution {
    fn new() -> Self {
        Self::default()
    }

    /// Get resolution success rate.
    pub fn success_rate(&self) -> f32 {
        let total = self.resolved_count + self.ambiguous_count + self.unresolved_count + self.external_count;
        if total == 0 {
            1.0
        } else {
            (self.resolved_count + self.external_count) as f32 / total as f32
        }
    }

    /// Check if all references were resolved.
    pub fn is_complete(&self) -> bool {
        self.unresolved_count == 0 && self.ambiguous_count == 0
    }
}

/// An ambiguous reference (multiple candidates).
#[derive(Debug)]
pub struct AmbiguousReference {
    pub file: PathBuf,
    pub name: String,
    pub candidates: Vec<String>,
}

/// An unresolved reference.
#[derive(Debug)]
pub struct UnresolvedReference {
    pub file: PathBuf,
    pub name: String,
}

/// An external reference (outside project).
#[derive(Debug)]
pub struct ExternalReference {
    pub file: PathBuf,
    pub module: String,
    pub name: String,
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::parser::{TreeSitterParser, Parser, Language};

    #[test]
    fn test_project_analyzer_basic() {
        let project = ProjectAnalyzer::new();
        assert_eq!(project.file_count(), 0);
        assert_eq!(project.symbol_count(), 0);
    }

    #[test]
    fn test_multi_file_analysis() {
        let parser = TreeSitterParser::new();
        let mut project = ProjectAnalyzer::new();

        // Add first file
        let code1 = r#"
class User:
    def __init__(self, name: str):
        self.name = name
"#;
        let parsed1 = parser.parse(code1, Language::Python).unwrap();
        project.add_file(&parsed1, &PathBuf::from("models/user.py")).unwrap();

        // Add second file
        let code2 = r#"
from models.user import User

def create_user(name: str) -> User:
    return User(name)
"#;
        let parsed2 = parser.parse(code2, Language::Python).unwrap();
        project.add_file(&parsed2, &PathBuf::from("services/user_service.py")).unwrap();

        assert_eq!(project.file_count(), 2);
        assert!(project.symbol_count() > 0);

        // Resolve references
        let resolution = project.resolve_all().unwrap();

        // Check resolution stats
        println!(
            "Resolved: {}, Unresolved: {}, Ambiguous: {}, External: {}",
            resolution.resolved_count,
            resolution.unresolved_count,
            resolution.ambiguous_count,
            resolution.external_count
        );
    }
}
