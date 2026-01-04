//! GraphML exporter for graph visualization tools.

use std::io::Write;
use anyhow::Result;
use crate::core::CodeAnalysis;
use super::Exporter;

/// GraphML exporter for Gephi, yEd, etc.
pub struct GraphMlExporter;

impl GraphMlExporter {
    fn xml_escape(text: &str) -> String {
        text.replace('&', "&amp;")
            .replace('<', "&lt;")
            .replace('>', "&gt;")
            .replace('"', "&quot;")
            .replace('\'', "&#39;")
    }

    fn write_header(&self, output: &mut dyn Write) -> Result<()> {
        writeln!(output, "<?xml version=\"1.0\" encoding=\"UTF-8\"?>")?;
        writeln!(output, "<graphml xmlns=\"http://graphml.graphdrawing.org/xmlns\"")?;
        writeln!(output, "         xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"")?;
        writeln!(output, "         xsi:schemaLocation=\"http://graphml.graphdrawing.org/xmlns")?;
        writeln!(output, "         http://graphml.graphdrawing.org/xmlns/1.0/graphml.xsd\">")?;

        // Define keys for node attributes
        writeln!(output, "  <key id=\"name\" for=\"node\" attr.name=\"name\" attr.type=\"string\"/>")?;
        writeln!(output, "  <key id=\"kind\" for=\"node\" attr.name=\"kind\" attr.type=\"string\"/>")?;
        writeln!(output, "  <key id=\"file\" for=\"node\" attr.name=\"file\" attr.type=\"string\"/>")?;
        writeln!(output, "  <key id=\"line\" for=\"node\" attr.name=\"line\" attr.type=\"int\"/>")?;
        writeln!(output, "  <key id=\"visibility\" for=\"node\" attr.name=\"visibility\" attr.type=\"string\"/>")?;

        // Define keys for edge attributes
        writeln!(output, "  <key id=\"relation\" for=\"edge\" attr.name=\"relation\" attr.type=\"string\"/>")?;
        writeln!(output, "  <key id=\"confidence\" for=\"edge\" attr.name=\"confidence\" attr.type=\"double\"/>")?;

        Ok(())
    }

    fn write_analysis(&self, analysis: &CodeAnalysis, output: &mut dyn Write, graph_id: &str) -> Result<()> {
        writeln!(output, "  <graph id=\"{}\" edgedefault=\"directed\">", graph_id)?;

        // Export nodes (symbols)
        for symbol in &analysis.symbols {
            writeln!(output, "    <node id=\"{}\">", Self::xml_escape(&symbol.id.0))?;
            writeln!(output, "      <data key=\"name\">{}</data>", Self::xml_escape(&symbol.name))?;
            writeln!(output, "      <data key=\"kind\">{}</data>", symbol.kind)?;
            writeln!(output, "      <data key=\"file\">{}</data>",
                Self::xml_escape(&analysis.file_path.to_string_lossy()))?;
            writeln!(output, "      <data key=\"line\">{}</data>", symbol.location.start_line)?;
            writeln!(output, "      <data key=\"visibility\">{}</data>", symbol.visibility)?;
            writeln!(output, "    </node>")?;
        }

        // Export edges (relationships)
        for (i, rel) in analysis.relationships.iter().enumerate() {
            writeln!(output, "    <edge id=\"e{}\" source=\"{}\" target=\"{}\">",
                i, Self::xml_escape(&rel.from.0), Self::xml_escape(&rel.to.0))?;
            writeln!(output, "      <data key=\"relation\">{}</data>", rel.kind)?;
            writeln!(output, "      <data key=\"confidence\">{}</data>", rel.confidence)?;
            writeln!(output, "    </edge>")?;
        }

        writeln!(output, "  </graph>")?;
        Ok(())
    }

    fn write_footer(&self, output: &mut dyn Write) -> Result<()> {
        writeln!(output, "</graphml>")?;
        Ok(())
    }
}

impl Exporter for GraphMlExporter {
    fn export(&self, analysis: &CodeAnalysis, output: &mut dyn Write) -> Result<()> {
        self.write_header(output)?;
        self.write_analysis(analysis, output, "G")?;
        self.write_footer(output)?;
        Ok(())
    }

    fn export_all(&self, analyses: &[CodeAnalysis], output: &mut dyn Write) -> Result<()> {
        self.write_header(output)?;
        for (i, analysis) in analyses.iter().enumerate() {
            self.write_analysis(analysis, output, &format!("G{}", i))?;
        }
        self.write_footer(output)?;
        Ok(())
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::parser::Language;
    use std::path::PathBuf;

    #[test]
    fn test_graphml_export() {
        let analysis = CodeAnalysis::new(PathBuf::from("test.rs"), Language::Rust);
        let mut output = Vec::new();

        GraphMlExporter.export(&analysis, &mut output).unwrap();
        let xml = String::from_utf8(output).unwrap();

        assert!(xml.contains("<?xml version"));
        assert!(xml.contains("<graphml"));
        assert!(xml.contains("</graphml>"));
    }
}
