//! Tabular exporters: CSV, Cypher.

use std::io::Write;
use anyhow::Result;
use crate::core::CodeAnalysis;
use super::Exporter;

/// CSV exporter.
pub struct CsvExporter;

impl CsvExporter {
    fn escape(text: &str) -> String {
        if text.contains(',') || text.contains('"') || text.contains('\n') {
            format!("\"{}\"", text.replace('"', "\"\""))
        } else {
            text.to_string()
        }
    }
}

impl Exporter for CsvExporter {
    fn export(&self, analysis: &CodeAnalysis, output: &mut dyn Write) -> Result<()> {
        // Symbols CSV
        writeln!(output, "=== SYMBOLS ===")?;
        writeln!(output, "id,name,kind,file_path,visibility,line_start,line_end")?;

        for symbol in &analysis.symbols {
            writeln!(output, "{},{},{},{},{},{},{}",
                Self::escape(&symbol.id.0),
                Self::escape(&symbol.name),
                symbol.kind,
                Self::escape(&analysis.file_path.to_string_lossy()),
                symbol.visibility,
                symbol.location.start_line,
                symbol.location.end_line)?;
        }

        // Relationships CSV
        writeln!(output)?;
        writeln!(output, "=== RELATIONSHIPS ===")?;
        writeln!(output, "from_symbol,to_symbol,relationship_type,confidence")?;

        for rel in &analysis.relationships {
            writeln!(output, "{},{},{},{}",
                Self::escape(&rel.from.0),
                Self::escape(&rel.to.0),
                rel.kind,
                rel.confidence)?;
        }

        // Imports CSV
        writeln!(output)?;
        writeln!(output, "=== IMPORTS ===")?;
        writeln!(output, "source,line")?;

        for import in &analysis.imports {
            writeln!(output, "{},{}",
                Self::escape(&import.source),
                import.location.start_line)?;
        }

        Ok(())
    }

    fn export_all(&self, analyses: &[CodeAnalysis], output: &mut dyn Write) -> Result<()> {
        // Combined symbols CSV
        writeln!(output, "=== SYMBOLS ===")?;
        writeln!(output, "id,name,kind,file_path,visibility,line_start,line_end")?;

        for analysis in analyses {
            for symbol in &analysis.symbols {
                writeln!(output, "{},{},{},{},{},{},{}",
                    Self::escape(&symbol.id.0),
                    Self::escape(&symbol.name),
                    symbol.kind,
                    Self::escape(&analysis.file_path.to_string_lossy()),
                    symbol.visibility,
                    symbol.location.start_line,
                    symbol.location.end_line)?;
            }
        }

        // Combined relationships CSV
        writeln!(output)?;
        writeln!(output, "=== RELATIONSHIPS ===")?;
        writeln!(output, "from_symbol,to_symbol,relationship_type,confidence")?;

        for analysis in analyses {
            for rel in &analysis.relationships {
                writeln!(output, "{},{},{},{}",
                    Self::escape(&rel.from.0),
                    Self::escape(&rel.to.0),
                    rel.kind,
                    rel.confidence)?;
            }
        }

        Ok(())
    }
}

/// Cypher exporter for Neo4j.
pub struct CypherExporter {
    project_name: String,
}

impl CypherExporter {
    pub fn new() -> Self {
        Self { project_name: "analysis".to_string() }
    }

    pub fn with_project(mut self, name: impl Into<String>) -> Self {
        self.project_name = name.into();
        self
    }

    fn escape(text: &str) -> String {
        text.replace('\'', "\\'")
            .replace('\\', "\\\\")
    }
}

impl Default for CypherExporter {
    fn default() -> Self {
        Self::new()
    }
}

impl Exporter for CypherExporter {
    fn export(&self, analysis: &CodeAnalysis, output: &mut dyn Write) -> Result<()> {
        writeln!(output, "// Neo4j Cypher queries for {}", analysis.file_path.display())?;
        writeln!(output)?;

        // Create symbols
        writeln!(output, "// Create symbols")?;
        for symbol in &analysis.symbols {
            let id = Self::escape(&symbol.id.0);
            writeln!(output, "CREATE (n:Symbol {{")?;
            writeln!(output, "  id: '{}',", id)?;
            writeln!(output, "  name: '{}',", Self::escape(&symbol.name))?;
            writeln!(output, "  kind: '{}',", symbol.kind)?;
            writeln!(output, "  file: '{}',", Self::escape(&analysis.file_path.to_string_lossy()))?;
            writeln!(output, "  visibility: '{}',", symbol.visibility)?;
            writeln!(output, "  line: {}", symbol.location.start_line)?;
            writeln!(output, "}});")?;
        }

        writeln!(output)?;

        // Create relationships
        writeln!(output, "// Create relationships")?;
        for rel in &analysis.relationships {
            let from_id = Self::escape(&rel.from.0);
            let to_id = Self::escape(&rel.to.0);
            let rel_type = rel.kind.to_string().to_uppercase().replace(' ', "_");
            writeln!(output, "MATCH (from:Symbol {{id: '{}'}}), (to:Symbol {{id: '{}'}})",
                from_id, to_id)?;
            writeln!(output, "CREATE (from)-[:{}]->(to);", rel_type)?;
        }

        writeln!(output)?;
        writeln!(output, "// Sample queries:")?;
        writeln!(output, "// Find all symbols: MATCH (n:Symbol) RETURN n;")?;
        writeln!(output, "// Find relationships: MATCH (n:Symbol)-[r]->(m:Symbol) RETURN n.name, type(r), m.name;")?;

        Ok(())
    }

    fn export_all(&self, analyses: &[CodeAnalysis], output: &mut dyn Write) -> Result<()> {
        writeln!(output, "// Neo4j Cypher queries for project: {}", self.project_name)?;
        writeln!(output)?;

        // Clear existing
        writeln!(output, "// Clear existing data (uncomment to use)")?;
        writeln!(output, "// MATCH (n:Symbol) DETACH DELETE n;")?;
        writeln!(output)?;

        for analysis in analyses {
            self.export(analysis, output)?;
            writeln!(output)?;
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
    fn test_csv_export() {
        let analysis = CodeAnalysis::new(PathBuf::from("test.rs"), Language::Rust);
        let mut output = Vec::new();

        CsvExporter.export(&analysis, &mut output).unwrap();
        let csv = String::from_utf8(output).unwrap();

        assert!(csv.contains("=== SYMBOLS ==="));
        assert!(csv.contains("=== RELATIONSHIPS ==="));
    }

    #[test]
    fn test_cypher_export() {
        let analysis = CodeAnalysis::new(PathBuf::from("test.rs"), Language::Rust);
        let mut output = Vec::new();

        CypherExporter::new().export(&analysis, &mut output).unwrap();
        let cypher = String::from_utf8(output).unwrap();

        assert!(cypher.contains("Neo4j Cypher"));
    }
}
