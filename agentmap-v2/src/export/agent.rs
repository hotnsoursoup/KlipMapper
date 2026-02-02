//! Agent-optimized export format.
//!
//! Produces token-efficient output designed for LLM agent consumption.
//! Focuses on structure, signatures, and relationships rather than full code.

use std::io::Write;
use anyhow::Result;
use serde::Serialize;

use crate::core::{CodeAnalysis, Symbol, SymbolKind, Visibility, RelationshipKind};
use super::Exporter;

/// Agent context exporter - produces token-efficient output for LLM agents.
pub struct AgentContextExporter {
    /// Include signatures for public API
    include_signatures: bool,
    /// Include relationship summary
    include_relationships: bool,
    /// Maximum signature length before truncation
    max_signature_len: usize,
}

impl AgentContextExporter {
    /// Create a new agent context exporter with default settings.
    pub fn new() -> Self {
        Self {
            include_signatures: true,
            include_relationships: true,
            max_signature_len: 200,
        }
    }

    /// Configure whether to include signatures.
    pub fn with_signatures(mut self, include: bool) -> Self {
        self.include_signatures = include;
        self
    }

    /// Configure whether to include relationships.
    pub fn with_relationships(mut self, include: bool) -> Self {
        self.include_relationships = include;
        self
    }

    /// Set maximum signature length.
    pub fn with_max_signature_len(mut self, len: usize) -> Self {
        self.max_signature_len = len;
        self
    }

    /// Extract a compact signature from code content.
    fn extract_signature(&self, symbol: &Symbol) -> String {
        let code = &symbol.code_content;

        // For functions/methods, extract just the signature line
        if symbol.kind.is_function() {
            // Find the opening brace or arrow
            if let Some(brace_pos) = code.find('{') {
                let sig = code[..brace_pos].trim();
                return self.truncate_signature(sig);
            }
            if let Some(arrow_pos) = code.find("=>") {
                let sig = code[..arrow_pos].trim();
                return self.truncate_signature(sig);
            }
        }

        // For structs/classes, extract just the declaration line
        if symbol.kind.is_type() {
            if let Some(first_line) = code.lines().next() {
                return self.truncate_signature(first_line.trim());
            }
        }

        // Fallback: first line or truncated content
        code.lines()
            .next()
            .map(|s| self.truncate_signature(s.trim()))
            .unwrap_or_default()
    }

    /// Truncate signature if too long.
    fn truncate_signature(&self, sig: &str) -> String {
        if sig.len() <= self.max_signature_len {
            sig.to_string()
        } else {
            format!("{}...", &sig[..self.max_signature_len])
        }
    }

    /// Build agent context from analysis.
    fn build_context(&self, analysis: &CodeAnalysis) -> AgentContext {
        let mut summary = SymbolSummary::default();
        let mut public_api = Vec::new();
        let mut all_symbols = Vec::new();

        for symbol in &analysis.symbols {
            // Count by kind
            match symbol.kind {
                SymbolKind::Function | SymbolKind::AsyncFunction => summary.functions += 1,
                SymbolKind::Method => summary.methods += 1,
                SymbolKind::Class => summary.classes += 1,
                SymbolKind::Struct => summary.structs += 1,
                SymbolKind::Interface | SymbolKind::Trait => summary.interfaces += 1,
                SymbolKind::Enum => summary.enums += 1,
                SymbolKind::Constant => summary.constants += 1,
                SymbolKind::Module => summary.modules += 1,
                _ => {}
            }

            // Collect public API signatures
            if self.include_signatures && symbol.visibility == Visibility::Public {
                public_api.push(ApiSignature {
                    name: symbol.name.clone(),
                    kind: symbol.kind.to_string(),
                    signature: self.extract_signature(symbol),
                    line: symbol.location.start_line,
                });
            }

            // Collect all symbol names for reference
            all_symbols.push(SymbolRef {
                name: symbol.name.clone(),
                kind: symbol.kind.to_string(),
                visibility: symbol.visibility.to_string(),
                line: symbol.location.start_line,
            });
        }

        // Build relationship summary
        let relationships = if self.include_relationships {
            self.summarize_relationships(analysis)
        } else {
            Vec::new()
        };

        AgentContext {
            file: analysis.file_path.to_string_lossy().to_string(),
            language: analysis.language.to_string(),
            lines: analysis.metadata.line_count,
            summary,
            public_api,
            symbols: all_symbols,
            relationships,
        }
    }

    /// Summarize relationships into a compact format.
    fn summarize_relationships(&self, analysis: &CodeAnalysis) -> Vec<RelationshipSummary> {
        let mut rels = Vec::new();

        for rel in &analysis.relationships {
            let from_name = rel.from.name().unwrap_or("?").to_string();
            let to_name = rel.to.name().unwrap_or("?").to_string();

            // Only include meaningful relationships
            match rel.kind {
                RelationshipKind::Inherits | RelationshipKind::Implements => {
                    rels.push(RelationshipSummary {
                        from: from_name,
                        kind: rel.kind.to_string(),
                        to: to_name,
                    });
                }
                RelationshipKind::Calls if rel.confidence > 0.8 => {
                    rels.push(RelationshipSummary {
                        from: from_name,
                        kind: "calls".to_string(),
                        to: to_name,
                    });
                }
                RelationshipKind::Uses if rel.confidence > 0.8 => {
                    rels.push(RelationshipSummary {
                        from: from_name,
                        kind: "uses".to_string(),
                        to: to_name,
                    });
                }
                _ => {}
            }
        }

        rels
    }
}

impl Default for AgentContextExporter {
    fn default() -> Self {
        Self::new()
    }
}

impl Exporter for AgentContextExporter {
    fn export(&self, analysis: &CodeAnalysis, output: &mut dyn Write) -> Result<()> {
        let context = self.build_context(analysis);
        let json = serde_json::to_string_pretty(&context)?;
        writeln!(output, "{}", json)?;
        Ok(())
    }

    fn export_all(&self, analyses: &[CodeAnalysis], output: &mut dyn Write) -> Result<()> {
        let contexts: Vec<AgentContext> = analyses
            .iter()
            .map(|a| self.build_context(a))
            .collect();

        // Create project summary
        let project = ProjectContext {
            files: contexts.len(),
            total_lines: contexts.iter().map(|c| c.lines).sum(),
            total_symbols: contexts.iter().map(|c| c.symbols.len()).sum(),
            summary: self.aggregate_summary(&contexts),
            files_detail: contexts,
        };

        let json = serde_json::to_string_pretty(&project)?;
        writeln!(output, "{}", json)?;
        Ok(())
    }
}

impl AgentContextExporter {
    /// Aggregate summaries from multiple files.
    fn aggregate_summary(&self, contexts: &[AgentContext]) -> SymbolSummary {
        let mut summary = SymbolSummary::default();
        for ctx in contexts {
            summary.functions += ctx.summary.functions;
            summary.methods += ctx.summary.methods;
            summary.classes += ctx.summary.classes;
            summary.structs += ctx.summary.structs;
            summary.interfaces += ctx.summary.interfaces;
            summary.enums += ctx.summary.enums;
            summary.constants += ctx.summary.constants;
            summary.modules += ctx.summary.modules;
        }
        summary
    }
}

/// Token-efficient context for a single file.
#[derive(Debug, Serialize)]
pub struct AgentContext {
    /// File path
    pub file: String,
    /// Programming language
    pub language: String,
    /// Line count
    pub lines: u32,
    /// Symbol counts by kind
    pub summary: SymbolSummary,
    /// Public API signatures (token-efficient)
    pub public_api: Vec<ApiSignature>,
    /// All symbols (compact reference)
    pub symbols: Vec<SymbolRef>,
    /// Key relationships
    pub relationships: Vec<RelationshipSummary>,
}

/// Token-efficient context for a project.
#[derive(Debug, Serialize)]
pub struct ProjectContext {
    /// Number of files
    pub files: usize,
    /// Total lines of code
    pub total_lines: u32,
    /// Total symbol count
    pub total_symbols: usize,
    /// Aggregated symbol summary
    pub summary: SymbolSummary,
    /// Per-file details
    pub files_detail: Vec<AgentContext>,
}

/// Summary of symbol counts by kind.
#[derive(Debug, Default, Serialize)]
pub struct SymbolSummary {
    #[serde(skip_serializing_if = "is_zero")]
    pub functions: usize,
    #[serde(skip_serializing_if = "is_zero")]
    pub methods: usize,
    #[serde(skip_serializing_if = "is_zero")]
    pub classes: usize,
    #[serde(skip_serializing_if = "is_zero")]
    pub structs: usize,
    #[serde(skip_serializing_if = "is_zero")]
    pub interfaces: usize,
    #[serde(skip_serializing_if = "is_zero")]
    pub enums: usize,
    #[serde(skip_serializing_if = "is_zero")]
    pub constants: usize,
    #[serde(skip_serializing_if = "is_zero")]
    pub modules: usize,
}

fn is_zero(n: &usize) -> bool {
    *n == 0
}

/// Compact API signature.
#[derive(Debug, Serialize)]
pub struct ApiSignature {
    pub name: String,
    pub kind: String,
    pub signature: String,
    pub line: u32,
}

/// Compact symbol reference.
#[derive(Debug, Serialize)]
pub struct SymbolRef {
    pub name: String,
    pub kind: String,
    pub visibility: String,
    pub line: u32,
}

/// Compact relationship summary.
#[derive(Debug, Serialize)]
pub struct RelationshipSummary {
    pub from: String,
    pub kind: String,
    pub to: String,
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::parser::Language;
    use std::path::PathBuf;

    #[test]
    fn test_agent_context_export() {
        let analysis = CodeAnalysis::new(PathBuf::from("test.rs"), Language::Rust);
        let exporter = AgentContextExporter::new();

        let mut output = Vec::new();
        exporter.export(&analysis, &mut output).unwrap();

        let json = String::from_utf8(output).unwrap();
        assert!(json.contains("\"file\""));
        assert!(json.contains("\"summary\""));
    }
}
