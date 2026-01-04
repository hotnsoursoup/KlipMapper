//! Export module for converting code analysis to various formats.
//!
//! Supports multiple output formats:
//! - JSON (pretty/compact)
//! - YAML
//! - GraphML (for Gephi, yEd)
//! - DOT (Graphviz)
//! - Mermaid diagrams
//! - PlantUML
//! - D2 diagrams
//! - CSV
//! - HTML reports
//! - Markdown documentation
//! - Cypher (Neo4j)

mod json;
mod graphml;
mod diagram;
mod tabular;
mod document;

use std::io::Write;
use anyhow::Result;

use crate::core::CodeAnalysis;

pub use diagram::{DotExporter, MermaidExporter, PlantUmlExporter, D2Exporter};
pub use graphml::GraphMlExporter;
pub use tabular::{CsvExporter, CypherExporter};
pub use document::{HtmlExporter, MarkdownExporter};
pub use json::JsonExporter;

/// Supported export formats.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum ExportFormat {
    /// Human-readable JSON with indentation
    Json,
    /// Compact JSON (minified)
    JsonCompact,
    /// YAML format
    Yaml,
    /// GraphML for graph visualization tools
    GraphML,
    /// DOT format for Graphviz
    Dot,
    /// Mermaid diagram format
    Mermaid,
    /// CSV format
    Csv,
    /// HTML report
    Html,
    /// Markdown documentation
    Markdown,
    /// PlantUML format
    PlantUml,
    /// D2 diagram language
    D2,
    /// Cypher queries for Neo4j
    Cypher,
}

impl ExportFormat {
    /// Get file extension for the format.
    pub fn extension(&self) -> &'static str {
        match self {
            ExportFormat::Json | ExportFormat::JsonCompact => "json",
            ExportFormat::Yaml => "yaml",
            ExportFormat::GraphML => "graphml",
            ExportFormat::Dot => "dot",
            ExportFormat::Mermaid => "mmd",
            ExportFormat::Csv => "csv",
            ExportFormat::Html => "html",
            ExportFormat::Markdown => "md",
            ExportFormat::PlantUml => "puml",
            ExportFormat::D2 => "d2",
            ExportFormat::Cypher => "cypher",
        }
    }

    /// Get MIME type for the format.
    pub fn mime_type(&self) -> &'static str {
        match self {
            ExportFormat::Json | ExportFormat::JsonCompact => "application/json",
            ExportFormat::Yaml => "text/yaml",
            ExportFormat::GraphML => "application/xml",
            ExportFormat::Dot | ExportFormat::Mermaid | ExportFormat::PlantUml |
            ExportFormat::D2 | ExportFormat::Cypher | ExportFormat::Csv => "text/plain",
            ExportFormat::Html => "text/html",
            ExportFormat::Markdown => "text/markdown",
        }
    }
}

impl std::fmt::Display for ExportFormat {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let name = match self {
            ExportFormat::Json => "JSON",
            ExportFormat::JsonCompact => "JSON (compact)",
            ExportFormat::Yaml => "YAML",
            ExportFormat::GraphML => "GraphML",
            ExportFormat::Dot => "DOT (Graphviz)",
            ExportFormat::Mermaid => "Mermaid",
            ExportFormat::Csv => "CSV",
            ExportFormat::Html => "HTML",
            ExportFormat::Markdown => "Markdown",
            ExportFormat::PlantUml => "PlantUML",
            ExportFormat::D2 => "D2",
            ExportFormat::Cypher => "Cypher",
        };
        write!(f, "{}", name)
    }
}

/// Trait for exporters.
pub trait Exporter {
    /// Export analysis to output.
    fn export(&self, analysis: &CodeAnalysis, output: &mut dyn Write) -> Result<()>;

    /// Export multiple analyses to output.
    fn export_all(&self, analyses: &[CodeAnalysis], output: &mut dyn Write) -> Result<()>;
}

/// Export analysis to any supported format.
pub fn export(
    analysis: &CodeAnalysis,
    format: ExportFormat,
    output: &mut dyn Write,
) -> Result<()> {
    match format {
        ExportFormat::Json => JsonExporter::new(true).export(analysis, output),
        ExportFormat::JsonCompact => JsonExporter::new(false).export(analysis, output),
        ExportFormat::Yaml => JsonExporter::yaml().export(analysis, output),
        ExportFormat::GraphML => GraphMlExporter.export(analysis, output),
        ExportFormat::Dot => DotExporter::new().export(analysis, output),
        ExportFormat::Mermaid => MermaidExporter::new().export(analysis, output),
        ExportFormat::Csv => CsvExporter.export(analysis, output),
        ExportFormat::Html => HtmlExporter::new().export(analysis, output),
        ExportFormat::Markdown => MarkdownExporter::new().export(analysis, output),
        ExportFormat::PlantUml => PlantUmlExporter::new().export(analysis, output),
        ExportFormat::D2 => D2Exporter::new().export(analysis, output),
        ExportFormat::Cypher => CypherExporter::new().export(analysis, output),
    }
}

/// Export multiple analyses to any supported format.
pub fn export_all(
    analyses: &[CodeAnalysis],
    format: ExportFormat,
    output: &mut dyn Write,
) -> Result<()> {
    match format {
        ExportFormat::Json => JsonExporter::new(true).export_all(analyses, output),
        ExportFormat::JsonCompact => JsonExporter::new(false).export_all(analyses, output),
        ExportFormat::Yaml => JsonExporter::yaml().export_all(analyses, output),
        ExportFormat::GraphML => GraphMlExporter.export_all(analyses, output),
        ExportFormat::Dot => DotExporter::new().export_all(analyses, output),
        ExportFormat::Mermaid => MermaidExporter::new().export_all(analyses, output),
        ExportFormat::Csv => CsvExporter.export_all(analyses, output),
        ExportFormat::Html => HtmlExporter::new().export_all(analyses, output),
        ExportFormat::Markdown => MarkdownExporter::new().export_all(analyses, output),
        ExportFormat::PlantUml => PlantUmlExporter::new().export_all(analyses, output),
        ExportFormat::D2 => D2Exporter::new().export_all(analyses, output),
        ExportFormat::Cypher => CypherExporter::new().export_all(analyses, output),
    }
}
