//! Diagram exporters: DOT, Mermaid, PlantUML, D2.

use std::io::Write;
use anyhow::Result;
use crate::core::{CodeAnalysis, SymbolKind, RelationshipKind};
use super::Exporter;

/// DOT (Graphviz) exporter.
pub struct DotExporter {
    rankdir: String,
}

impl DotExporter {
    pub fn new() -> Self {
        Self { rankdir: "TB".to_string() }
    }

    pub fn left_to_right(mut self) -> Self {
        self.rankdir = "LR".to_string();
        self
    }

    fn escape(text: &str) -> String {
        text.replace('\\', "\\\\")
            .replace('"', "\\\"")
            .replace('\n', "\\n")
    }

    fn kind_color(kind: SymbolKind) -> &'static str {
        match kind {
            SymbolKind::Class | SymbolKind::Struct => "#E1F5FE",
            SymbolKind::Interface | SymbolKind::Trait => "#F3E5F5",
            SymbolKind::Function | SymbolKind::AsyncFunction => "#E8F5E8",
            SymbolKind::Method => "#FFF3E0",
            SymbolKind::Enum => "#FBE9E7",
            _ => "#FAFAFA",
        }
    }

    fn rel_style(kind: RelationshipKind) -> &'static str {
        match kind {
            RelationshipKind::Calls => "[color=blue]",
            RelationshipKind::Inherits | RelationshipKind::Implements => "[color=red, style=bold]",
            RelationshipKind::Uses => "[color=green, style=dashed]",
            _ => "[color=gray]",
        }
    }
}

impl Default for DotExporter {
    fn default() -> Self {
        Self::new()
    }
}

impl Exporter for DotExporter {
    fn export(&self, analysis: &CodeAnalysis, output: &mut dyn Write) -> Result<()> {
        writeln!(output, "digraph code_analysis {{")?;
        writeln!(output, "  rankdir={};", self.rankdir)?;
        writeln!(output, "  node [shape=box, style=filled];")?;
        writeln!(output, "  edge [dir=forward];")?;
        writeln!(output)?;

        // Nodes
        for symbol in &analysis.symbols {
            let color = Self::kind_color(symbol.kind);
            let label = format!("{}\\n({})\\nLine: {}",
                symbol.name, symbol.kind, symbol.location.start_line);
            writeln!(output, "  \"{}\" [label=\"{}\", fillcolor=\"{}\"];",
                Self::escape(&symbol.id.0), Self::escape(&label), color)?;
        }

        writeln!(output)?;

        // Edges
        for rel in &analysis.relationships {
            let style = Self::rel_style(rel.kind);
            writeln!(output, "  \"{}\" -> \"{}\" {} [label=\"{}\"];",
                Self::escape(&rel.from.0),
                Self::escape(&rel.to.0),
                style,
                rel.kind)?;
        }

        writeln!(output, "}}")?;
        Ok(())
    }

    fn export_all(&self, analyses: &[CodeAnalysis], output: &mut dyn Write) -> Result<()> {
        writeln!(output, "digraph code_analysis {{")?;
        writeln!(output, "  rankdir={};", self.rankdir)?;
        writeln!(output, "  node [shape=box, style=filled];")?;
        writeln!(output, "  compound=true;")?;
        writeln!(output)?;

        for (i, analysis) in analyses.iter().enumerate() {
            writeln!(output, "  subgraph cluster_{} {{", i)?;
            writeln!(output, "    label=\"{}\";",
                Self::escape(&analysis.file_path.to_string_lossy()))?;

            for symbol in &analysis.symbols {
                let color = Self::kind_color(symbol.kind);
                writeln!(output, "    \"{}\" [label=\"{}\", fillcolor=\"{}\"];",
                    Self::escape(&symbol.id.0), Self::escape(&symbol.name), color)?;
            }
            writeln!(output, "  }}")?;
        }

        writeln!(output)?;

        for analysis in analyses {
            for rel in &analysis.relationships {
                writeln!(output, "  \"{}\" -> \"{}\";",
                    Self::escape(&rel.from.0), Self::escape(&rel.to.0))?;
            }
        }

        writeln!(output, "}}")?;
        Ok(())
    }
}

/// Mermaid diagram exporter.
pub struct MermaidExporter {
    direction: String,
}

impl MermaidExporter {
    pub fn new() -> Self {
        Self { direction: "TD".to_string() }
    }

    pub fn left_to_right(mut self) -> Self {
        self.direction = "LR".to_string();
        self
    }

    fn escape(text: &str) -> String {
        text.replace(' ', "_")
            .replace('-', "_")
            .replace('(', "_")
            .replace(')', "_")
            .replace(':', "_")
    }

    fn shape(kind: SymbolKind) -> (&'static str, &'static str) {
        match kind {
            SymbolKind::Class | SymbolKind::Struct => ("(", ")"),
            SymbolKind::Interface | SymbolKind::Trait => ("{", "}"),
            SymbolKind::Function | SymbolKind::Method | SymbolKind::AsyncFunction => ("[", "]"),
            SymbolKind::Enum => ("[/", "\\]"),
            _ => ("((", "))"),
        }
    }

    fn arrow(kind: RelationshipKind) -> &'static str {
        match kind {
            RelationshipKind::Inherits => "==>",
            RelationshipKind::Implements => "-.->",
            RelationshipKind::Calls => "-->",
            RelationshipKind::Uses => "..>",
            _ => "---",
        }
    }
}

impl Default for MermaidExporter {
    fn default() -> Self {
        Self::new()
    }
}

impl Exporter for MermaidExporter {
    fn export(&self, analysis: &CodeAnalysis, output: &mut dyn Write) -> Result<()> {
        writeln!(output, "graph {}", self.direction)?;
        writeln!(output)?;

        // Nodes
        for symbol in &analysis.symbols {
            let (open, close) = Self::shape(symbol.kind);
            let id = Self::escape(&symbol.id.0);
            let name = Self::escape(&symbol.name);
            writeln!(output, "  {}{}{}{}", id, open, name, close)?;
        }

        writeln!(output)?;

        // Relationships
        for rel in &analysis.relationships {
            let from_id = Self::escape(&rel.from.0);
            let to_id = Self::escape(&rel.to.0);
            let arrow = Self::arrow(rel.kind);
            writeln!(output, "  {} {} {} |{}|", from_id, arrow, to_id, rel.kind)?;
        }

        writeln!(output)?;

        // Styling
        writeln!(output, "classDef class fill:#e1f5fe")?;
        writeln!(output, "classDef interface fill:#f3e5f5")?;
        writeln!(output, "classDef function fill:#e8f5e8")?;

        Ok(())
    }

    fn export_all(&self, analyses: &[CodeAnalysis], output: &mut dyn Write) -> Result<()> {
        writeln!(output, "graph {}", self.direction)?;
        writeln!(output)?;

        for (i, analysis) in analyses.iter().enumerate() {
            writeln!(output, "  subgraph file{} [{}]", i,
                analysis.file_path.file_name().and_then(|n| n.to_str()).unwrap_or("unknown"))?;

            for symbol in &analysis.symbols {
                let (open, close) = Self::shape(symbol.kind);
                let id = Self::escape(&symbol.id.0);
                let name = Self::escape(&symbol.name);
                writeln!(output, "    {}{}{}{}", id, open, name, close)?;
            }
            writeln!(output, "  end")?;
        }

        writeln!(output)?;

        for analysis in analyses {
            for rel in &analysis.relationships {
                let from_id = Self::escape(&rel.from.0);
                let to_id = Self::escape(&rel.to.0);
                let arrow = Self::arrow(rel.kind);
                writeln!(output, "  {} {} {}", from_id, arrow, to_id)?;
            }
        }

        Ok(())
    }
}

/// PlantUML exporter.
pub struct PlantUmlExporter;

impl PlantUmlExporter {
    pub fn new() -> Self {
        Self
    }

    fn arrow(kind: RelationshipKind) -> &'static str {
        match kind {
            RelationshipKind::Inherits => "--|>",
            RelationshipKind::Implements => "..|>",
            RelationshipKind::Calls => "-->",
            RelationshipKind::Uses => "..>",
            _ => "--",
        }
    }
}

impl Default for PlantUmlExporter {
    fn default() -> Self {
        Self::new()
    }
}

impl Exporter for PlantUmlExporter {
    fn export(&self, analysis: &CodeAnalysis, output: &mut dyn Write) -> Result<()> {
        writeln!(output, "@startuml")?;
        writeln!(output, "!theme plain")?;
        writeln!(output, "title {}", analysis.file_path.display())?;
        writeln!(output)?;

        // Group by kind
        let mut classes = Vec::new();
        let mut interfaces = Vec::new();
        let mut functions = Vec::new();

        for symbol in &analysis.symbols {
            match symbol.kind {
                SymbolKind::Class | SymbolKind::Struct => classes.push(symbol),
                SymbolKind::Interface | SymbolKind::Trait => interfaces.push(symbol),
                SymbolKind::Function | SymbolKind::Method | SymbolKind::AsyncFunction => functions.push(symbol),
                _ => functions.push(symbol),
            }
        }

        for symbol in classes {
            writeln!(output, "class {} {{", symbol.name)?;
            writeln!(output, "}}")?;
        }

        for symbol in interfaces {
            writeln!(output, "interface {}", symbol.name)?;
        }

        for symbol in functions {
            writeln!(output, "object \"{}\" as {}", symbol.name,
                symbol.id.0.replace(":", "_").replace("/", "_").replace("\\", "_"))?;
        }

        writeln!(output)?;

        for rel in &analysis.relationships {
            let from_id = rel.from.0.replace(":", "_").replace("/", "_").replace("\\", "_");
            let to_id = rel.to.0.replace(":", "_").replace("/", "_").replace("\\", "_");
            writeln!(output, "{} {} {} : {}", from_id, Self::arrow(rel.kind), to_id, rel.kind)?;
        }

        writeln!(output, "@enduml")?;
        Ok(())
    }

    fn export_all(&self, analyses: &[CodeAnalysis], output: &mut dyn Write) -> Result<()> {
        writeln!(output, "@startuml")?;
        writeln!(output, "!theme plain")?;
        writeln!(output, "title Code Analysis")?;
        writeln!(output)?;

        for analysis in analyses {
            let package_name = analysis.file_path.file_name()
                .and_then(|n| n.to_str())
                .unwrap_or("unknown");

            writeln!(output, "package \"{}\" {{", package_name)?;
            for symbol in &analysis.symbols {
                match symbol.kind {
                    SymbolKind::Class | SymbolKind::Struct => {
                        writeln!(output, "  class {}", symbol.name)?;
                    }
                    _ => {
                        writeln!(output, "  object \"{}\"", symbol.name)?;
                    }
                }
            }
            writeln!(output, "}}")?;
        }

        writeln!(output)?;

        for analysis in analyses {
            for rel in &analysis.relationships {
                let from_name = rel.from.name().unwrap_or(&rel.from.0);
                let to_name = rel.to.name().unwrap_or(&rel.to.0);
                writeln!(output, "{} {} {} : {}", from_name, Self::arrow(rel.kind), to_name, rel.kind)?;
            }
        }

        writeln!(output, "@enduml")?;
        Ok(())
    }
}

/// D2 diagram language exporter.
pub struct D2Exporter;

impl D2Exporter {
    pub fn new() -> Self {
        Self
    }

    fn escape(text: &str) -> String {
        text.replace('"', "\\\"")
            .replace('\n', "\\n")
    }

    fn shape(kind: SymbolKind) -> &'static str {
        match kind {
            SymbolKind::Class | SymbolKind::Struct => "class",
            SymbolKind::Interface | SymbolKind::Trait => "class",
            SymbolKind::Function | SymbolKind::Method => "process",
            SymbolKind::Enum => "hexagon",
            _ => "rectangle",
        }
    }
}

impl Default for D2Exporter {
    fn default() -> Self {
        Self::new()
    }
}

impl Exporter for D2Exporter {
    fn export(&self, analysis: &CodeAnalysis, output: &mut dyn Write) -> Result<()> {
        writeln!(output, "# {}", analysis.file_path.display())?;
        writeln!(output)?;

        // Nodes
        for symbol in &analysis.symbols {
            let id = symbol.id.0.replace(":", "_").replace("/", "_").replace("\\", "_");
            writeln!(output, "{}: {{", id)?;
            writeln!(output, "  label: \"{}\"", Self::escape(&symbol.name))?;
            writeln!(output, "  shape: {}", Self::shape(symbol.kind))?;
            if matches!(symbol.kind, SymbolKind::Class | SymbolKind::Struct) {
                writeln!(output, "  style.fill: \"#e1f5fe\"")?;
            }
            writeln!(output, "}}")?;
        }

        writeln!(output)?;

        // Relationships
        for rel in &analysis.relationships {
            let from_id = rel.from.0.replace(":", "_").replace("/", "_").replace("\\", "_");
            let to_id = rel.to.0.replace(":", "_").replace("/", "_").replace("\\", "_");
            writeln!(output, "{} -> {}: \"{}\"", from_id, to_id, Self::escape(&rel.kind.to_string()))?;
        }

        Ok(())
    }

    fn export_all(&self, analyses: &[CodeAnalysis], output: &mut dyn Write) -> Result<()> {
        writeln!(output, "# Code Analysis")?;
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
    fn test_dot_export() {
        let analysis = CodeAnalysis::new(PathBuf::from("test.rs"), Language::Rust);
        let mut output = Vec::new();

        DotExporter::new().export(&analysis, &mut output).unwrap();
        let dot = String::from_utf8(output).unwrap();

        assert!(dot.contains("digraph"));
    }

    #[test]
    fn test_mermaid_export() {
        let analysis = CodeAnalysis::new(PathBuf::from("test.rs"), Language::Rust);
        let mut output = Vec::new();

        MermaidExporter::new().export(&analysis, &mut output).unwrap();
        let mmd = String::from_utf8(output).unwrap();

        assert!(mmd.contains("graph TD"));
    }

    #[test]
    fn test_plantuml_export() {
        let analysis = CodeAnalysis::new(PathBuf::from("test.rs"), Language::Rust);
        let mut output = Vec::new();

        PlantUmlExporter::new().export(&analysis, &mut output).unwrap();
        let puml = String::from_utf8(output).unwrap();

        assert!(puml.contains("@startuml"));
        assert!(puml.contains("@enduml"));
    }
}
