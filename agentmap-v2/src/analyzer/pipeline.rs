//! Default analysis pipeline.

use std::path::Path;
use crate::core::{Result, CodeAnalysis, AnalysisMetadata};
use crate::parser::ParsedFile;
use super::{Analyzer, InheritanceAnalyzer, ImportAnalyzer, CallAnalyzer, UsageAnalyzer};
use sha2::{Sha256, Digest};

/// Default analyzer implementation.
///
/// This analyzer chains together sub-analyzers for:
/// - Inheritance relationships (extends, implements)
/// - Import relationships (import statements)
/// - Call relationships (function/method calls)
/// - Usage tracking (type references, field access)
pub struct DefaultAnalyzer {
    inheritance_analyzer: InheritanceAnalyzer,
    import_analyzer: ImportAnalyzer,
    call_analyzer: CallAnalyzer,
    usage_analyzer: UsageAnalyzer,
}

impl DefaultAnalyzer {
    /// Create a new default analyzer.
    pub fn new() -> Self {
        Self {
            inheritance_analyzer: InheritanceAnalyzer::new(),
            import_analyzer: ImportAnalyzer::new(),
            call_analyzer: CallAnalyzer::new(),
            usage_analyzer: UsageAnalyzer::new(),
        }
    }

    /// Compute content hash for caching.
    fn compute_hash(content: &str) -> String {
        let mut hasher = Sha256::new();
        hasher.update(content.as_bytes());
        format!("{:x}", hasher.finalize())[..16].to_string()
    }
}

impl Default for DefaultAnalyzer {
    fn default() -> Self {
        Self::new()
    }
}

impl Analyzer for DefaultAnalyzer {
    fn analyze(&self, parsed: &ParsedFile, path: &Path) -> Result<CodeAnalysis> {
        let start = std::time::Instant::now();

        let mut analysis = CodeAnalysis::new(
            path.to_path_buf(),
            parsed.language,
        );

        // Copy symbols from parsed file
        analysis.symbols = parsed.symbols.clone();

        // Extract inheritance relationships
        let inheritance_rels = self.inheritance_analyzer.analyze(parsed, path)?;
        analysis.relationships.extend(inheritance_rels);

        // Extract imports and import relationships
        let (imports, import_rels) = self.import_analyzer.analyze(parsed, path)?;
        analysis.imports = imports;
        analysis.relationships.extend(import_rels);

        // Extract call relationships
        let call_rels = self.call_analyzer.analyze(parsed, path)?;
        analysis.relationships.extend(call_rels);

        // Extract usage relationships
        let usage_rels = self.usage_analyzer.analyze(parsed, path)?;
        analysis.relationships.extend(usage_rels);

        // Set metadata
        let line_count = parsed.content.lines().count() as u32;
        let hash = Self::compute_hash(&parsed.content);
        let elapsed = start.elapsed().as_millis() as u64;

        analysis.metadata = AnalysisMetadata::default()
            .with_lines(line_count)
            .with_hash(hash)
            .with_time(elapsed);

        Ok(analysis)
    }
}
