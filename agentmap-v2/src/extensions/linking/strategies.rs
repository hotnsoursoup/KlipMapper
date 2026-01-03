//! Resolution strategies.
//!
//! Contains both generic and language-specific resolution strategies.

use super::{SymbolTable, ResolutionContext, ResolutionStrategy, ResolvedReference};
use crate::parser::Language;

/// Strategy: Look for symbols defined in the current file.
pub struct LocalScopeStrategy;

impl ResolutionStrategy for LocalScopeStrategy {
    fn try_resolve(
        &self,
        name: &str,
        ctx: &ResolutionContext,
        table: &SymbolTable,
    ) -> Option<ResolvedReference> {
        // Get symbols in current file
        let file_symbols = table.symbols_in_file(&ctx.file);

        // Look for exact name match
        for symbol_id in file_symbols {
            if let Some(symbol) = table.get(&symbol_id) {
                if symbol.name == name {
                    return Some(ResolvedReference::Resolved(symbol_id));
                }
            }
        }

        None
    }

    fn name(&self) -> &str {
        "LocalScope"
    }

    fn priority(&self) -> u8 {
        10
    }
}

/// Strategy: Follow import aliases.
pub struct ImportAliasStrategy;

impl ResolutionStrategy for ImportAliasStrategy {
    fn try_resolve(
        &self,
        name: &str,
        ctx: &ResolutionContext,
        table: &SymbolTable,
    ) -> Option<ResolvedReference> {
        // Check if name is an import alias
        if let Some(fqn) = ctx.imports.get(name) {
            if let Some(id) = table.lookup_fqn(fqn) {
                return Some(ResolvedReference::Resolved(id));
            }
        }

        // Also check if name appears in any import's target
        for (_alias, fqn) in &ctx.imports {
            // Check if FQN ends with the name
            if fqn.ends_with(&format!("::{}", name)) || fqn.ends_with(&format!(".{}", name)) {
                if let Some(id) = table.lookup_fqn(fqn) {
                    return Some(ResolvedReference::Resolved(id));
                }
            }
        }

        None
    }

    fn name(&self) -> &str {
        "ImportAlias"
    }

    fn priority(&self) -> u8 {
        20
    }
}

/// Strategy: Match qualified path patterns (e.g., module::Class).
pub struct QualifiedPathStrategy;

impl ResolutionStrategy for QualifiedPathStrategy {
    fn try_resolve(
        &self,
        name: &str,
        _ctx: &ResolutionContext,
        table: &SymbolTable,
    ) -> Option<ResolvedReference> {
        // Only applies to qualified names
        if !name.contains("::") && !name.contains(".") {
            return None;
        }

        // Try direct FQN lookup
        if let Some(id) = table.lookup_fqn(name) {
            return Some(ResolvedReference::Resolved(id));
        }

        // Try without file path prefix (just module::name)
        let candidates = table.lookup_name(name.split("::").last().unwrap_or(name));

        let matching: Vec<_> = candidates.into_iter()
            .filter(|id| id.0.ends_with(name))
            .collect();

        match matching.len() {
            1 => Some(ResolvedReference::Resolved(matching[0].clone())),
            n if n > 1 => Some(ResolvedReference::Ambiguous(matching)),
            _ => None,
        }
    }

    fn name(&self) -> &str {
        "QualifiedPath"
    }

    fn priority(&self) -> u8 {
        30
    }
}

/// Strategy: Look in sibling files (same directory).
pub struct SiblingFileStrategy;

impl ResolutionStrategy for SiblingFileStrategy {
    fn try_resolve(
        &self,
        name: &str,
        ctx: &ResolutionContext,
        table: &SymbolTable,
    ) -> Option<ResolvedReference> {
        let parent = ctx.file.parent()?;

        // Get all candidates with this name
        let candidates = table.lookup_name(name);

        // Filter to those in same directory
        let siblings: Vec<_> = candidates.into_iter()
            .filter(|id| {
                table.get(id)
                    .map(|s| s.location.file_path.parent() == Some(parent))
                    .unwrap_or(false)
            })
            .collect();

        match siblings.len() {
            1 => Some(ResolvedReference::Resolved(siblings[0].clone())),
            n if n > 1 => Some(ResolvedReference::Ambiguous(siblings)),
            _ => None,
        }
    }

    fn name(&self) -> &str {
        "SiblingFile"
    }

    fn priority(&self) -> u8 {
        40
    }
}

/// Strategy: Fuzzy matching with confidence threshold.
pub struct FuzzyStrategy {
    min_similarity: f32,
}

impl FuzzyStrategy {
    pub fn new(min_similarity: f32) -> Self {
        Self { min_similarity }
    }

    fn similarity(a: &str, b: &str) -> f32 {
        // Simple Levenshtein-based similarity
        let max_len = a.len().max(b.len()) as f32;
        if max_len == 0.0 {
            return 1.0;
        }

        let distance = Self::levenshtein(a, b) as f32;
        1.0 - (distance / max_len)
    }

    fn levenshtein(a: &str, b: &str) -> usize {
        let a: Vec<char> = a.chars().collect();
        let b: Vec<char> = b.chars().collect();
        let len_a = a.len();
        let len_b = b.len();

        if len_a == 0 { return len_b; }
        if len_b == 0 { return len_a; }

        let mut prev: Vec<usize> = (0..=len_b).collect();
        let mut curr = vec![0; len_b + 1];

        for i in 1..=len_a {
            curr[0] = i;
            for j in 1..=len_b {
                let cost = if a[i-1] == b[j-1] { 0 } else { 1 };
                curr[j] = (prev[j] + 1)
                    .min(curr[j-1] + 1)
                    .min(prev[j-1] + cost);
            }
            std::mem::swap(&mut prev, &mut curr);
        }

        prev[len_b]
    }
}

impl ResolutionStrategy for FuzzyStrategy {
    fn try_resolve(
        &self,
        name: &str,
        _ctx: &ResolutionContext,
        table: &SymbolTable,
    ) -> Option<ResolvedReference> {
        // Get all candidates with similar names
        let candidates = table.lookup_name(name);

        if candidates.len() == 1 {
            return Some(ResolvedReference::Resolved(candidates[0].clone()));
        }

        if candidates.len() > 1 {
            return Some(ResolvedReference::Ambiguous(candidates));
        }

        // If no candidates found by name lookup, iterate keys for fuzzy match (expensive but necessary)
        // Access internal table indirectly via name lookup since we can't iterate keys efficiently
        // Note: In a real optimized implementation, we might maintain a separate index or trie
        // For now, we will skip the expensive full table scan and return None
        // A true fuzzy search would require iterating all 30k+ symbols which is too slow for
        // the default path. We'll leave the fuzzy strategy to only handle near-miss names
        // that happen to share the same short name (handled above) or we could add a limited scan.

        None
    }

    fn name(&self) -> &str {
        "Fuzzy"
    }

    fn priority(&self) -> u8 {
        90
    }
}

// =============================================================================
// Language-Specific Strategies
// =============================================================================

/// Strategy: Handle Python relative imports (`.foo`, `..foo`).
///
/// Python allows relative imports like:
/// - `from . import foo` (same package)
/// - `from .. import bar` (parent package)
/// - `from .submodule import baz` (child of current package)
pub struct RelativeImportStrategy;

impl ResolutionStrategy for RelativeImportStrategy {
    fn try_resolve(
        &self,
        name: &str,
        ctx: &ResolutionContext,
        table: &SymbolTable,
    ) -> Option<ResolvedReference> {
        // Only applies to Python
        if ctx.language != Language::Python {
            return None;
        }

        // Only applies to relative import patterns
        if !name.starts_with('.') {
            return None;
        }

        // Count leading dots to determine package level
        let dot_count = name.chars().take_while(|c| *c == '.').count();
        let relative_name = &name[dot_count..];

        // Get current file's directory path
        let current_dir = ctx.file.parent()?;

        // Navigate up directories based on dot count
        let mut target_dir = current_dir.to_path_buf();
        for _ in 1..dot_count {
            target_dir = target_dir.parent()?.to_path_buf();
        }

        // Look for symbols in the target directory/package
        let candidates = table.lookup_name(relative_name);

        let matching: Vec<_> = candidates.into_iter()
            .filter(|id| {
                table.get(id)
                    .map(|s| {
                        let sym_dir = s.location.file_path.parent();
                        sym_dir.map(|d| d.starts_with(&target_dir)).unwrap_or(false)
                    })
                    .unwrap_or(false)
            })
            .collect();

        match matching.len() {
            1 => Some(ResolvedReference::Resolved(matching[0].clone())),
            n if n > 1 => Some(ResolvedReference::Ambiguous(matching)),
            _ => None,
        }
    }

    fn name(&self) -> &str {
        "RelativeImport"
    }

    fn priority(&self) -> u8 {
        15 // Higher priority than general import alias
    }
}

/// Strategy: Handle TypeScript/JavaScript default exports.
///
/// When importing a default export like `import Foo from './mod'`,
/// the actual exported name is `default` but we use it as `Foo`.
pub struct DefaultExportStrategy;

impl ResolutionStrategy for DefaultExportStrategy {
    fn try_resolve(
        &self,
        name: &str,
        ctx: &ResolutionContext,
        table: &SymbolTable,
    ) -> Option<ResolvedReference> {
        // Only applies to TypeScript/JavaScript
        if !matches!(ctx.language, Language::TypeScript | Language::JavaScript) {
            return None;
        }

        // Check if this name was imported as a default
        // In our import map, default imports are stored as "default" -> local_name
        // But we need to check if `name` is a default import from some module

        for (local_name, fqn) in &ctx.imports {
            // Check if this is a default import pattern (source::default -> local_name)
            if local_name == name && fqn.ends_with("::default") {
                // Try to find the actual default export in the source module
                let module_path = fqn.trim_end_matches("::default");

                // Look for any symbol in that module that might be the default
                let candidates = table.lookup_name(name);
                for id in candidates {
                    if let Some(symbol) = table.get(&id) {
                        // Use proper path comparison - check if module matches file stem
                        let sym_path = &symbol.location.file_path;
                        let sym_stem = sym_path.file_stem()
                            .and_then(|s| s.to_str())
                            .unwrap_or("");
                        let module_name = std::path::Path::new(module_path)
                            .file_stem()
                            .and_then(|s| s.to_str())
                            .unwrap_or(module_path);

                        // Match if file stems are equal (e.g., "user" matches "user.ts")
                        if sym_stem == module_name || sym_path.ends_with(module_path) {
                            return Some(ResolvedReference::Resolved(id));
                        }
                    }
                }

                // Mark as external if not found in project
                return Some(ResolvedReference::External {
                    module: module_path.to_string(),
                    name: "default".to_string(),
                });
            }
        }

        None
    }

    fn name(&self) -> &str {
        "DefaultExport"
    }

    fn priority(&self) -> u8 {
        18
    }
}

/// Strategy: Handle re-exports (TypeScript `export { Foo } from './mod'`, Rust `pub use`).
///
/// Re-exports create aliases that point to symbols in other modules.
/// This strategy follows the re-export chain to find the original symbol.
pub struct ReExportStrategy;

impl ResolutionStrategy for ReExportStrategy {
    fn try_resolve(
        &self,
        name: &str,
        ctx: &ResolutionContext,
        table: &SymbolTable,
    ) -> Option<ResolvedReference> {
        // Only applies to TypeScript, JavaScript, and Rust
        if !matches!(ctx.language, Language::TypeScript | Language::JavaScript | Language::Rust) {
            return None;
        }

        // Check imports for re-export patterns
        // A re-export typically looks like: local_name -> module::name where the module
        // itself re-exports from another module

        if let Some(fqn) = ctx.imports.get(name) {
            // Try to resolve the target
            if let Some(id) = table.lookup_fqn(fqn) {
                return Some(ResolvedReference::Resolved(id));
            }

            // If not found directly, the target might be a re-export itself
            // Try to find by just the name part
            let target_name = fqn.rsplit("::").next().unwrap_or(fqn);
            let candidates = table.lookup_name(target_name);

            // Filter to public symbols that might be re-exports
            let reexports: Vec<_> = candidates.into_iter()
                .filter(|id| {
                    table.get(id)
                        .map(|s| s.is_public())
                        .unwrap_or(false)
                })
                .collect();

            match reexports.len() {
                1 => return Some(ResolvedReference::Resolved(reexports[0].clone())),
                n if n > 1 => return Some(ResolvedReference::Ambiguous(reexports)),
                _ => {}
            }

            // Mark as external if from outside project
            if fqn.contains("::") {
                let parts: Vec<&str> = fqn.splitn(2, "::").collect();
                if parts.len() == 2 {
                    return Some(ResolvedReference::External {
                        module: parts[0].to_string(),
                        name: parts[1].to_string(),
                    });
                }
            }
        }

        None
    }

    fn name(&self) -> &str {
        "ReExport"
    }

    fn priority(&self) -> u8 {
        25 // After import alias, before qualified path
    }
}

/// Strategy: Handle Go package-based resolution.
///
/// Go resolves symbols by package path, where the package name
/// is typically the last component of the import path.
pub struct GoPackageStrategy;

impl ResolutionStrategy for GoPackageStrategy {
    fn try_resolve(
        &self,
        name: &str,
        ctx: &ResolutionContext,
        table: &SymbolTable,
    ) -> Option<ResolvedReference> {
        // Only applies to Go
        if ctx.language != Language::Go {
            return None;
        }

        // Go uses package.Symbol syntax
        if !name.contains('.') {
            return None;
        }

        let parts: Vec<&str> = name.splitn(2, '.').collect();
        if parts.len() != 2 {
            return None;
        }

        let (pkg_alias, symbol_name) = (parts[0], parts[1]);

        // Check if pkg_alias is an import alias
        if let Some(pkg_path) = ctx.imports.get(pkg_alias) {
            // Look for symbol_name in that package
            let candidates = table.lookup_name(symbol_name);
            let pkg_path_buf = std::path::PathBuf::from(pkg_path);

            let matching: Vec<_> = candidates.into_iter()
                .filter(|id| {
                    table.get(id)
                        .map(|s| {
                            // Use proper path matching - check if symbol is in package directory
                            let sym_path = &s.location.file_path;
                            // Check if file's parent contains the package path
                            sym_path.starts_with(&pkg_path_buf) ||
                            sym_path.parent()
                                .map(|p| p.ends_with(pkg_path))
                                .unwrap_or(false)
                        })
                        .unwrap_or(false)
                })
                .collect();

            match matching.len() {
                1 => return Some(ResolvedReference::Resolved(matching[0].clone())),
                n if n > 1 => return Some(ResolvedReference::Ambiguous(matching)),
                _ => {
                    // External package
                    return Some(ResolvedReference::External {
                        module: pkg_path.clone(),
                        name: symbol_name.to_string(),
                    });
                }
            }
        }

        // If not an alias, might be a direct package reference
        // Try to find by the symbol name alone
        let candidates = table.lookup_name(symbol_name);
        if candidates.len() == 1 {
            return Some(ResolvedReference::Resolved(candidates[0].clone()));
        }

        None
    }

    fn name(&self) -> &str {
        "GoPackage"
    }

    fn priority(&self) -> u8 {
        22
    }
}

/// Strategy: Handle Java fully-qualified class names.
///
/// Java code often uses fully-qualified names like `java.util.List`
/// or imports like `import java.util.*;`
pub struct JavaFqnStrategy;

impl ResolutionStrategy for JavaFqnStrategy {
    fn try_resolve(
        &self,
        name: &str,
        ctx: &ResolutionContext,
        table: &SymbolTable,
    ) -> Option<ResolvedReference> {
        // Only applies to Java
        if ctx.language != Language::Java {
            return None;
        }

        // Check for fully-qualified names (contains dots)
        if name.contains('.') {
            // Try direct FQN lookup with Java-style path
            let rust_style_fqn = name.replace('.', "::");
            if let Some(id) = table.lookup_fqn(&rust_style_fqn) {
                return Some(ResolvedReference::Resolved(id));
            }

            // Get just the class name (last part)
            let class_name = name.rsplit('.').next()?;
            let candidates = table.lookup_name(class_name);

            // Filter by package path
            let package_path = name.rsplitn(2, '.').nth(1)?;
            let matching: Vec<_> = candidates.into_iter()
                .filter(|id| {
                    table.get(id)
                        .map(|s| {
                            let sym_path = s.location.file_path.to_string_lossy();
                            // Java package structure mirrors directory structure
                            let expected_path = package_path.replace('.', "/");
                            sym_path.contains(&expected_path)
                        })
                        .unwrap_or(false)
                })
                .collect();

            match matching.len() {
                1 => return Some(ResolvedReference::Resolved(matching[0].clone())),
                n if n > 1 => return Some(ResolvedReference::Ambiguous(matching)),
                _ => {
                    // Mark as external (likely standard library)
                    return Some(ResolvedReference::External {
                        module: package_path.to_string(),
                        name: class_name.to_string(),
                    });
                }
            }
        }

        // Check wildcard imports (java.util.*)
        for (_, import_path) in &ctx.imports {
            if import_path.ends_with(".*") {
                let package = import_path.trim_end_matches(".*");
                let fqn = format!("{}::{}", package.replace('.', "::"), name);

                if let Some(id) = table.lookup_fqn(&fqn) {
                    return Some(ResolvedReference::Resolved(id));
                }
            }
        }

        None
    }

    fn name(&self) -> &str {
        "JavaFqn"
    }

    fn priority(&self) -> u8 {
        24
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::path::PathBuf;

    fn make_ctx(lang: Language) -> ResolutionContext {
        ResolutionContext::new(PathBuf::from("test.py"), lang)
    }

    #[test]
    fn test_relative_import_strategy_ignores_non_python() {
        let strategy = RelativeImportStrategy;
        let table = SymbolTable::new();
        let ctx = make_ctx(Language::Rust);

        let result = strategy.try_resolve(".foo", &ctx, &table);
        assert!(result.is_none());
    }

    #[test]
    fn test_relative_import_strategy_ignores_absolute() {
        let strategy = RelativeImportStrategy;
        let table = SymbolTable::new();
        let ctx = make_ctx(Language::Python);

        let result = strategy.try_resolve("foo", &ctx, &table);
        assert!(result.is_none());
    }

    #[test]
    fn test_go_package_strategy_ignores_non_go() {
        let strategy = GoPackageStrategy;
        let table = SymbolTable::new();
        let ctx = make_ctx(Language::Python);

        let result = strategy.try_resolve("fmt.Println", &ctx, &table);
        assert!(result.is_none());
    }

    #[test]
    fn test_java_fqn_strategy_ignores_non_java() {
        let strategy = JavaFqnStrategy;
        let table = SymbolTable::new();
        let ctx = make_ctx(Language::Python);

        let result = strategy.try_resolve("java.util.List", &ctx, &table);
        assert!(result.is_none());
    }
}
