//! Document exporters: HTML, Markdown.

use std::io::Write;
use std::collections::HashMap;
use anyhow::Result;
use crate::core::{CodeAnalysis, SymbolKind, RelationshipKind};
use super::Exporter;

/// HTML report exporter.
pub struct HtmlExporter {
    title: Option<String>,
}

impl HtmlExporter {
    pub fn new() -> Self {
        Self { title: None }
    }

    pub fn with_title(mut self, title: impl Into<String>) -> Self {
        self.title = Some(title.into());
        self
    }

    fn escape(text: &str) -> String {
        text.replace('&', "&amp;")
            .replace('<', "&lt;")
            .replace('>', "&gt;")
            .replace('"', "&quot;")
    }

    fn write_styles(output: &mut dyn Write) -> Result<()> {
        writeln!(output, "  <style>")?;
        writeln!(output, "body {{ font-family: system-ui, -apple-system, sans-serif; margin: 0; padding: 20px; background: #f5f5f5; }}")?;
        writeln!(output, ".container {{ max-width: 1200px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }}")?;
        writeln!(output, "h1 {{ color: #333; border-bottom: 3px solid #007acc; padding-bottom: 10px; }}")?;
        writeln!(output, "h2 {{ color: #555; margin-top: 30px; }}")?;
        writeln!(output, ".stats {{ display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin: 20px 0; }}")?;
        writeln!(output, ".stat {{ background: #f8f9fa; padding: 15px; border-radius: 4px; border-left: 4px solid #007acc; }}")?;
        writeln!(output, ".stat h3 {{ margin: 0 0 5px 0; color: #666; font-size: 12px; text-transform: uppercase; }}")?;
        writeln!(output, ".stat .value {{ font-size: 24px; font-weight: bold; color: #333; }}")?;
        writeln!(output, "table {{ width: 100%; border-collapse: collapse; margin: 20px 0; }}")?;
        writeln!(output, "th, td {{ padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }}")?;
        writeln!(output, "th {{ background: #f1f3f4; font-weight: 600; }}")?;
        writeln!(output, ".symbol-name {{ font-family: 'SF Mono', Monaco, monospace; font-weight: bold; }}")?;
        writeln!(output, ".symbol-kind {{ padding: 4px 8px; border-radius: 4px; font-size: 12px; text-transform: uppercase; }}")?;
        writeln!(output, ".kind-class {{ background: #e3f2fd; color: #1976d2; }}")?;
        writeln!(output, ".kind-function {{ background: #e8f5e8; color: #2e7d32; }}")?;
        writeln!(output, ".kind-interface {{ background: #f3e5f5; color: #7b1fa2; }}")?;
        writeln!(output, "  </style>")?;
        Ok(())
    }

    fn kind_class(kind: SymbolKind) -> &'static str {
        match kind {
            SymbolKind::Class | SymbolKind::Struct => "kind-class",
            SymbolKind::Function | SymbolKind::Method | SymbolKind::AsyncFunction => "kind-function",
            SymbolKind::Interface | SymbolKind::Trait => "kind-interface",
            _ => "",
        }
    }
}

impl Default for HtmlExporter {
    fn default() -> Self {
        Self::new()
    }
}

impl Exporter for HtmlExporter {
    fn export(&self, analysis: &CodeAnalysis, output: &mut dyn Write) -> Result<()> {
        let title = self.title.clone().unwrap_or_else(||
            analysis.file_path.file_name()
                .and_then(|n| n.to_str())
                .unwrap_or("Code Analysis")
                .to_string());

        writeln!(output, "<!DOCTYPE html>")?;
        writeln!(output, "<html lang=\"en\">")?;
        writeln!(output, "<head>")?;
        writeln!(output, "  <meta charset=\"UTF-8\">")?;
        writeln!(output, "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">")?;
        writeln!(output, "  <title>{}</title>", Self::escape(&title))?;
        Self::write_styles(output)?;
        writeln!(output, "</head>")?;
        writeln!(output, "<body>")?;
        writeln!(output, "  <div class=\"container\">")?;

        // Header
        writeln!(output, "    <h1>{}</h1>", Self::escape(&title))?;
        writeln!(output, "    <p><strong>File:</strong> <code>{}</code></p>",
            Self::escape(&analysis.file_path.to_string_lossy()))?;
        writeln!(output, "    <p><strong>Language:</strong> {}</p>", analysis.language)?;

        // Statistics
        writeln!(output, "    <div class=\"stats\">")?;
        writeln!(output, "      <div class=\"stat\"><h3>Symbols</h3><div class=\"value\">{}</div></div>",
            analysis.symbols.len())?;
        writeln!(output, "      <div class=\"stat\"><h3>Relationships</h3><div class=\"value\">{}</div></div>",
            analysis.relationships.len())?;
        writeln!(output, "      <div class=\"stat\"><h3>Imports</h3><div class=\"value\">{}</div></div>",
            analysis.imports.len())?;
        writeln!(output, "    </div>")?;

        // Symbols table
        if !analysis.symbols.is_empty() {
            writeln!(output, "    <h2>Symbols</h2>")?;
            writeln!(output, "    <table>")?;
            writeln!(output, "      <thead><tr><th>Name</th><th>Kind</th><th>Visibility</th><th>Line</th></tr></thead>")?;
            writeln!(output, "      <tbody>")?;
            for symbol in &analysis.symbols {
                writeln!(output, "        <tr>")?;
                writeln!(output, "          <td class=\"symbol-name\">{}</td>", Self::escape(&symbol.name))?;
                writeln!(output, "          <td><span class=\"symbol-kind {}\">{}</span></td>",
                    Self::kind_class(symbol.kind), symbol.kind)?;
                writeln!(output, "          <td>{}</td>", symbol.visibility)?;
                writeln!(output, "          <td>{}</td>", symbol.location.start_line)?;
                writeln!(output, "        </tr>")?;
            }
            writeln!(output, "      </tbody>")?;
            writeln!(output, "    </table>")?;
        }

        // Relationships table
        if !analysis.relationships.is_empty() {
            writeln!(output, "    <h2>Relationships</h2>")?;
            writeln!(output, "    <table>")?;
            writeln!(output, "      <thead><tr><th>From</th><th>Type</th><th>To</th><th>Confidence</th></tr></thead>")?;
            writeln!(output, "      <tbody>")?;
            for rel in &analysis.relationships {
                writeln!(output, "        <tr>")?;
                writeln!(output, "          <td>{}</td>",
                    Self::escape(rel.from.name().unwrap_or(&rel.from.0)))?;
                writeln!(output, "          <td>{}</td>", rel.kind)?;
                writeln!(output, "          <td>{}</td>",
                    Self::escape(rel.to.name().unwrap_or(&rel.to.0)))?;
                writeln!(output, "          <td>{:.0}%</td>", rel.confidence * 100.0)?;
                writeln!(output, "        </tr>")?;
            }
            writeln!(output, "      </tbody>")?;
            writeln!(output, "    </table>")?;
        }

        writeln!(output, "  </div>")?;
        writeln!(output, "</body>")?;
        writeln!(output, "</html>")?;

        Ok(())
    }

    fn export_all(&self, analyses: &[CodeAnalysis], output: &mut dyn Write) -> Result<()> {
        let title = self.title.clone().unwrap_or_else(|| "Project Analysis".to_string());

        writeln!(output, "<!DOCTYPE html>")?;
        writeln!(output, "<html lang=\"en\">")?;
        writeln!(output, "<head>")?;
        writeln!(output, "  <meta charset=\"UTF-8\">")?;
        writeln!(output, "  <title>{}</title>", Self::escape(&title))?;
        Self::write_styles(output)?;
        writeln!(output, "</head>")?;
        writeln!(output, "<body>")?;
        writeln!(output, "  <div class=\"container\">")?;
        writeln!(output, "    <h1>{}</h1>", Self::escape(&title))?;

        // Aggregate stats
        let total_symbols: usize = analyses.iter().map(|a| a.symbols.len()).sum();
        let total_rels: usize = analyses.iter().map(|a| a.relationships.len()).sum();

        writeln!(output, "    <div class=\"stats\">")?;
        writeln!(output, "      <div class=\"stat\"><h3>Files</h3><div class=\"value\">{}</div></div>", analyses.len())?;
        writeln!(output, "      <div class=\"stat\"><h3>Total Symbols</h3><div class=\"value\">{}</div></div>", total_symbols)?;
        writeln!(output, "      <div class=\"stat\"><h3>Total Relationships</h3><div class=\"value\">{}</div></div>", total_rels)?;
        writeln!(output, "    </div>")?;

        // Per-file summaries
        for analysis in analyses {
            writeln!(output, "    <h2>{}</h2>",
                Self::escape(&analysis.file_path.to_string_lossy()))?;
            writeln!(output, "    <p>Language: {} | Symbols: {} | Relationships: {}</p>",
                analysis.language, analysis.symbols.len(), analysis.relationships.len())?;
        }

        writeln!(output, "  </div>")?;
        writeln!(output, "</body>")?;
        writeln!(output, "</html>")?;

        Ok(())
    }
}

/// Markdown documentation exporter.
pub struct MarkdownExporter {
    title: Option<String>,
}

impl MarkdownExporter {
    pub fn new() -> Self {
        Self { title: None }
    }

    pub fn with_title(mut self, title: impl Into<String>) -> Self {
        self.title = Some(title.into());
        self
    }

    fn escape(text: &str) -> String {
        text.replace('|', "\\|")
            .replace('\n', "<br>")
    }
}

impl Default for MarkdownExporter {
    fn default() -> Self {
        Self::new()
    }
}

impl Exporter for MarkdownExporter {
    fn export(&self, analysis: &CodeAnalysis, output: &mut dyn Write) -> Result<()> {
        let title = self.title.clone().unwrap_or_else(||
            analysis.file_path.file_name()
                .and_then(|n| n.to_str())
                .unwrap_or("Code Analysis")
                .to_string());

        writeln!(output, "# {}", title)?;
        writeln!(output)?;
        writeln!(output, "**File**: `{}`", analysis.file_path.display())?;
        writeln!(output, "**Language**: {}", analysis.language)?;
        writeln!(output)?;

        // Statistics
        writeln!(output, "## Summary")?;
        writeln!(output)?;
        writeln!(output, "| Metric | Count |")?;
        writeln!(output, "|--------|-------|")?;
        writeln!(output, "| Symbols | {} |", analysis.symbols.len())?;
        writeln!(output, "| Relationships | {} |", analysis.relationships.len())?;
        writeln!(output, "| Imports | {} |", analysis.imports.len())?;
        writeln!(output)?;

        // Symbols
        if !analysis.symbols.is_empty() {
            writeln!(output, "## Symbols")?;
            writeln!(output)?;
            writeln!(output, "| Name | Kind | Visibility | Line |")?;
            writeln!(output, "|------|------|------------|------|")?;
            for symbol in &analysis.symbols {
                writeln!(output, "| {} | {} | {} | {} |",
                    Self::escape(&symbol.name),
                    symbol.kind,
                    symbol.visibility,
                    symbol.location.start_line)?;
            }
            writeln!(output)?;
        }

        // Relationships grouped by type
        if !analysis.relationships.is_empty() {
            writeln!(output, "## Relationships")?;
            writeln!(output)?;

            let mut grouped: HashMap<RelationshipKind, Vec<_>> = HashMap::new();
            for rel in &analysis.relationships {
                grouped.entry(rel.kind).or_default().push(rel);
            }

            for (kind, rels) in grouped {
                writeln!(output, "### {} ({} total)", kind, rels.len())?;
                writeln!(output)?;
                for rel in rels {
                    writeln!(output, "- `{}` → `{}`",
                        rel.from.name().unwrap_or(&rel.from.0),
                        rel.to.name().unwrap_or(&rel.to.0))?;
                }
                writeln!(output)?;
            }
        }

        // Imports
        if !analysis.imports.is_empty() {
            writeln!(output, "## Imports")?;
            writeln!(output)?;
            for import in &analysis.imports {
                writeln!(output, "- `{}`", import.source)?;
            }
        }

        Ok(())
    }

    fn export_all(&self, analyses: &[CodeAnalysis], output: &mut dyn Write) -> Result<()> {
        let title = self.title.clone().unwrap_or_else(|| "Project Analysis".to_string());

        writeln!(output, "# {}", title)?;
        writeln!(output)?;

        // Aggregate stats
        let total_symbols: usize = analyses.iter().map(|a| a.symbols.len()).sum();
        let total_rels: usize = analyses.iter().map(|a| a.relationships.len()).sum();

        writeln!(output, "## Overview")?;
        writeln!(output)?;
        writeln!(output, "- **Files**: {}", analyses.len())?;
        writeln!(output, "- **Total Symbols**: {}", total_symbols)?;
        writeln!(output, "- **Total Relationships**: {}", total_rels)?;
        writeln!(output)?;

        // Table of contents
        writeln!(output, "## Files")?;
        writeln!(output)?;
        for (i, analysis) in analyses.iter().enumerate() {
            writeln!(output, "{}. [{}](#file-{})", i + 1,
                analysis.file_path.file_name().and_then(|n| n.to_str()).unwrap_or("unknown"),
                i)?;
        }
        writeln!(output)?;

        // Per-file details
        for (i, analysis) in analyses.iter().enumerate() {
            writeln!(output, "---")?;
            writeln!(output)?;
            writeln!(output, "## <a id=\"file-{}\"></a>{}", i, analysis.file_path.display())?;
            writeln!(output)?;
            writeln!(output, "- **Language**: {}", analysis.language)?;
            writeln!(output, "- **Symbols**: {}", analysis.symbols.len())?;
            writeln!(output, "- **Relationships**: {}", analysis.relationships.len())?;
            writeln!(output)?;

            if !analysis.symbols.is_empty() {
                writeln!(output, "### Symbols")?;
                writeln!(output)?;
                for symbol in &analysis.symbols {
                    writeln!(output, "- `{}` ({}) - line {}",
                        symbol.name, symbol.kind, symbol.location.start_line)?;
                }
                writeln!(output)?;
            }
        }

        Ok(())
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::parser::Language;
    use std::path::PathBuf;

    #[test]
    fn test_html_export() {
        let analysis = CodeAnalysis::new(PathBuf::from("test.rs"), Language::Rust);
        let mut output = Vec::new();

        HtmlExporter::new().export(&analysis, &mut output).unwrap();
        let html = String::from_utf8(output).unwrap();

        assert!(html.contains("<!DOCTYPE html>"));
        assert!(html.contains("test.rs"));
    }

    #[test]
    fn test_markdown_export() {
        let analysis = CodeAnalysis::new(PathBuf::from("test.rs"), Language::Rust);
        let mut output = Vec::new();

        MarkdownExporter::new().export(&analysis, &mut output).unwrap();
        let md = String::from_utf8(output).unwrap();

        assert!(md.contains("# test.rs"));
        assert!(md.contains("## Summary"));
    }
}
