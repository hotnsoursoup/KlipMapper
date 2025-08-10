use crate::architecture_exporter::{ProjectArchitecture, FolderStructure, ArchitectureSymbol, ArchitectureRelationship};
use anyhow::{Result, Context};
use serde_json;
use std::io::Write;
use std::collections::HashMap;

/// Supported export formats for project architecture
#[derive(Debug, Clone, Copy)]
pub enum ExportFormat {
    /// Human-readable JSON with indentation
    Json,
    /// Compact JSON (minified)
    JsonCompact,
    /// YAML format
    Yaml,
    /// GraphML for graph visualization tools (Gephi, yEd, etc.)
    GraphML,
    /// DOT format for Graphviz
    Dot,
    /// Mermaid diagram format
    Mermaid,
    /// CSV format (symbols and relationships as separate files)
    Csv,
    /// HTML report with interactive features
    Html,
    /// Markdown documentation
    Markdown,
    /// PlantUML format for diagrams
    PlantUml,
    /// D2 diagram language
    D2,
    /// Cypher queries for Neo4j
    Cypher,
}

pub struct ArchitectureFormatter;

impl ArchitectureFormatter {
    /// Export project architecture in specified format
    pub fn export(
        architecture: &ProjectArchitecture,
        format: ExportFormat,
        output: &mut dyn Write,
    ) -> Result<()> {
        match format {
            ExportFormat::Json => Self::export_json(architecture, output, true),
            ExportFormat::JsonCompact => Self::export_json(architecture, output, false),
            ExportFormat::Yaml => Self::export_yaml(architecture, output),
            ExportFormat::GraphML => Self::export_graphml(architecture, output),
            ExportFormat::Dot => Self::export_dot(architecture, output),
            ExportFormat::Mermaid => Self::export_mermaid(architecture, output),
            ExportFormat::Csv => Self::export_csv(architecture, output),
            ExportFormat::Html => Self::export_html(architecture, output),
            ExportFormat::Markdown => Self::export_markdown(architecture, output),
            ExportFormat::PlantUml => Self::export_plantuml(architecture, output),
            ExportFormat::D2 => Self::export_d2(architecture, output),
            ExportFormat::Cypher => Self::export_cypher(architecture, output),
        }
    }

    fn export_json(
        architecture: &ProjectArchitecture,
        output: &mut dyn Write,
        pretty: bool,
    ) -> Result<()> {
        let json = if pretty {
            serde_json::to_string_pretty(architecture)
        } else {
            serde_json::to_string(architecture)
        }.context("Failed to serialize architecture to JSON")?;
        
        output.write_all(json.as_bytes())?;
        Ok(())
    }

    fn export_yaml(
        architecture: &ProjectArchitecture,
        output: &mut dyn Write,
    ) -> Result<()> {
        let yaml = serde_yaml::to_string(architecture)
            .context("Failed to serialize architecture to YAML")?;
        
        output.write_all(yaml.as_bytes())?;
        Ok(())
    }

    fn export_graphml(
        architecture: &ProjectArchitecture,
        output: &mut dyn Write,
    ) -> Result<()> {
        writeln!(output, "<?xml version=\"1.0\" encoding=\"UTF-8\"?>")?;
        writeln!(output, "<graphml xmlns=\"http://graphml.graphdrawing.org/xmlns\"")?;
        writeln!(output, "         xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"")?;
        writeln!(output, "         xsi:schemaLocation=\"http://graphml.graphdrawing.org/xmlns")?;
        writeln!(output, "         http://graphml.graphdrawing.org/xmlns/1.0/graphml.xsd\">")?;
        
        // Define keys for node and edge attributes
        writeln!(output, "  <key id=\"name\" for=\"node\" attr.name=\"name\" attr.type=\"string\"/>")?;
        writeln!(output, "  <key id=\"kind\" for=\"node\" attr.name=\"kind\" attr.type=\"string\"/>")?;
        writeln!(output, "  <key id=\"file\" for=\"node\" attr.name=\"file\" attr.type=\"string\"/>")?;
        writeln!(output, "  <key id=\"visibility\" for=\"node\" attr.name=\"visibility\" attr.type=\"string\"/>")?;
        writeln!(output, "  <key id=\"complexity\" for=\"node\" attr.name=\"complexity\" attr.type=\"int\"/>")?;
        writeln!(output, "  <key id=\"lines\" for=\"node\" attr.name=\"lines\" attr.type=\"string\"/>")?;
        writeln!(output, "  <key id=\"relation\" for=\"edge\" attr.name=\"relation\" attr.type=\"string\"/>")?;
        writeln!(output, "  <key id=\"strength\" for=\"edge\" attr.name=\"strength\" attr.type=\"double\"/>")?;
        
        writeln!(output, "  <graph id=\"G\" edgedefault=\"directed\">")?;
        
        // Export nodes (symbols)
        for symbol in &architecture.symbols {
            writeln!(output, "    <node id=\"{}\">", symbol.id)?;
            writeln!(output, "      <data key=\"name\">{}</data>", Self::xml_escape(&symbol.name))?;
            writeln!(output, "      <data key=\"kind\">{}</data>", Self::xml_escape(&symbol.kind))?;
            writeln!(output, "      <data key=\"file\">{}</data>", Self::xml_escape(&symbol.file_path))?;
            writeln!(output, "      <data key=\"visibility\">{:?}</data>", symbol.visibility)?;
            if let Some(complexity) = symbol.complexity {
                writeln!(output, "      <data key=\"complexity\">{}</data>", complexity)?;
            }
            writeln!(output, "      <data key=\"lines\">{}-{}</data>", symbol.lines[0], symbol.lines[1])?;
            writeln!(output, "    </node>")?;
        }
        
        // Export edges (relationships)
        for (i, relationship) in architecture.relationships.iter().enumerate() {
            writeln!(output, "    <edge id=\"e{}\" source=\"{}\" target=\"{}\">", 
                i, relationship.from_symbol, relationship.to_symbol)?;
            writeln!(output, "      <data key=\"relation\">{}</data>", 
                Self::xml_escape(&relationship.relationship_type))?;
            writeln!(output, "      <data key=\"strength\">{}</data>", relationship.strength)?;
            writeln!(output, "    </edge>")?;
        }
        
        writeln!(output, "  </graph>")?;
        writeln!(output, "</graphml>")?;
        Ok(())
    }

    fn export_dot(
        architecture: &ProjectArchitecture,
        output: &mut dyn Write,
    ) -> Result<()> {
        writeln!(output, "digraph project_architecture {{")?;
        writeln!(output, "  rankdir=TB;")?;
        writeln!(output, "  node [shape=box, style=filled];")?;
        writeln!(output, "  edge [dir=forward];")?;
        writeln!(output)?;
        
        // Color mapping for different symbol kinds
        let kind_colors = HashMap::from([
            ("class", "#E1F5FE"),
            ("interface", "#F3E5F5"), 
            ("function", "#E8F5E8"),
            ("method", "#FFF3E0"),
            ("variable", "#FAFAFA"),
        ]);
        
        // Export nodes with styling
        for symbol in &architecture.symbols {
            let color = kind_colors.get(symbol.kind.as_str()).unwrap_or(&"#FFFFFF");
            let label = format!("{}\\n({})\\nLines: {}-{}", 
                symbol.name, symbol.kind, symbol.lines[0], symbol.lines[1]);
            
            writeln!(output, "  \"{}\" [label=\"{}\", fillcolor=\"{}\"];", 
                symbol.id, Self::dot_escape(&label), color)?;
        }
        
        writeln!(output)?;
        
        // Export edges with labels
        for relationship in &architecture.relationships {
            let style = match relationship.relationship_type.as_str() {
                "call" => "[color=blue]",
                "inherit" => "[color=red, style=bold]",
                "uses-type" => "[color=green, style=dashed]",
                _ => "[color=gray]",
            };
            
            writeln!(output, "  \"{}\" -> \"{}\" {} [label=\"{}\"];", 
                relationship.from_symbol,
                relationship.to_symbol,
                style,
                Self::dot_escape(&relationship.relationship_type)
            )?;
        }
        
        writeln!(output, "}}")?;
        Ok(())
    }

    fn export_mermaid(
        architecture: &ProjectArchitecture,
        output: &mut dyn Write,
    ) -> Result<()> {
        writeln!(output, "graph TD")?;
        writeln!(output)?;
        
        // Define nodes with styling
        for symbol in &architecture.symbols {
            let shape = match symbol.kind.as_str() {
                "class" => ("(", ")"),
                "interface" => ("{", "}"),
                "function" | "method" => ("[", "]"),
                _ => ("((", "))"),
            };
            
            writeln!(output, "  {}{}{}{} --> |{}| Info_{}", 
                symbol.id,
                shape.0,
                Self::mermaid_escape(&symbol.name),
                shape.1,
                symbol.kind,
                symbol.id
            )?;
        }
        
        writeln!(output)?;
        
        // Define relationships
        for relationship in &architecture.relationships {
            let arrow = match relationship.relationship_type.as_str() {
                "inherit" => "==>",
                "implement" => "-.->",
                "call" => "-->", 
                "uses-type" => "..>",
                _ => "---",
            };
            
            writeln!(output, "  {} {} {} |{}|", 
                relationship.from_symbol,
                arrow,
                relationship.to_symbol,
                Self::mermaid_escape(&relationship.relationship_type)
            )?;
        }
        
        // Add styling
        writeln!(output)?;
        writeln!(output, "classDef class fill:#e1f5fe")?;
        writeln!(output, "classDef interface fill:#f3e5f5")?;
        writeln!(output, "classDef function fill:#e8f5e8")?;
        writeln!(output, "classDef method fill:#fff3e0")?;
        
        Ok(())
    }

    fn export_csv(
        architecture: &ProjectArchitecture,
        output: &mut dyn Write,
    ) -> Result<()> {
        // Export symbols CSV
        writeln!(output, "=== SYMBOLS ===")?;
        writeln!(output, "id,name,kind,file_path,visibility,complexity,usage_count,lines_start,lines_end,roles")?;
        
        for symbol in &architecture.symbols {
            writeln!(output, "{},{},{},{},{:?},{},{},{},{},\"{}\"",
                symbol.id,
                Self::csv_escape(&symbol.name),
                Self::csv_escape(&symbol.kind),
                Self::csv_escape(&symbol.file_path),
                symbol.visibility,
                symbol.complexity.unwrap_or(0),
                symbol.usage_count,
                symbol.lines[0],
                symbol.lines[1],
                symbol.roles.join(";")
            )?;
        }
        
        // Export relationships CSV
        writeln!(output)?;
        writeln!(output, "=== RELATIONSHIPS ===")?;
        writeln!(output, "from_symbol,to_symbol,relationship_type,strength,file_path,line_number")?;
        
        for relationship in &architecture.relationships {
            writeln!(output, "{},{},{},{},{},{}",
                relationship.from_symbol,
                relationship.to_symbol,
                Self::csv_escape(&relationship.relationship_type),
                relationship.strength,
                relationship.file_path.as_deref().unwrap_or(""),
                relationship.line_number.unwrap_or(0)
            )?;
        }
        
        Ok(())
    }

    fn export_html(
        architecture: &ProjectArchitecture,
        output: &mut dyn Write,
    ) -> Result<()> {
        writeln!(output, "<!DOCTYPE html>")?;
        writeln!(output, "<html lang=\"en\">")?;
        writeln!(output, "<head>")?;
        writeln!(output, "  <meta charset=\"UTF-8\">")?;
        writeln!(output, "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">")?;
        writeln!(output, "  <title>Project Architecture - {}</title>", 
            Self::html_escape(&architecture.metadata.name))?;
        writeln!(output, "  <style>")?;
        writeln!(output, "{}", Self::get_html_styles())?;
        writeln!(output, "  </style>")?;
        writeln!(output, "</head>")?;
        writeln!(output, "<body>")?;
        
        // Header
        writeln!(output, "  <div class=\"container\">")?;
        writeln!(output, "    <h1>Project Architecture: {}</h1>", 
            Self::html_escape(&architecture.metadata.name))?;
        
        // Metadata section
        writeln!(output, "    <div class=\"metadata\">")?;
        writeln!(output, "      <h2>Project Information</h2>")?;
        writeln!(output, "      <p><strong>Languages:</strong> {}</p>", 
            architecture.metadata.languages.join(", "))?;
        writeln!(output, "      <p><strong>Total Files:</strong> {}</p>", 
            architecture.metadata.total_files)?;
        writeln!(output, "      <p><strong>Detail Level:</strong> {:?}</p>", 
            architecture.metadata.detail_level)?;
        writeln!(output, "      <p><strong>Generated:</strong> {}</p>", 
            architecture.metadata.generated_at)?;
        writeln!(output, "    </div>")?;
        
        // Metrics section  
        writeln!(output, "    <div class=\"metrics\">")?;
        writeln!(output, "      <h2>Project Metrics</h2>")?;
        writeln!(output, "      <div class=\"metric-grid\">")?;
        writeln!(output, "        <div class=\"metric\">")?;
        writeln!(output, "          <h3>Complexity</h3>")?;
        writeln!(output, "          <p>Cyclomatic: {:.2}</p>", 
            architecture.metrics.complexity.cyclomatic_complexity)?;
        writeln!(output, "          <p>Cognitive: {:.2}</p>", 
            architecture.metrics.complexity.cognitive_complexity)?;
        writeln!(output, "        </div>")?;
        writeln!(output, "        <div class=\"metric\">")?;
        writeln!(output, "          <h3>Dependencies</h3>")?;
        writeln!(output, "          <p>Total: {}</p>", 
            architecture.metrics.dependencies.total_dependencies)?;
        writeln!(output, "          <p>Circular: {}</p>", 
            architecture.metrics.dependencies.circular_dependencies)?;
        writeln!(output, "        </div>")?;
        writeln!(output, "        <div class=\"metric\">")?;
        writeln!(output, "          <h3>Quality</h3>")?;
        writeln!(output, "          <p>Documentation: {:.1}%</p>", 
            architecture.metrics.quality.documentation_coverage * 100.0)?;
        writeln!(output, "          <p>Maintainability: {:.1}</p>", 
            architecture.metrics.maintainability.maintainability_index)?;
        writeln!(output, "        </div>")?;
        writeln!(output, "      </div>")?;
        writeln!(output, "    </div>")?;
        
        // Symbols table
        writeln!(output, "    <div class=\"symbols\">")?;
        writeln!(output, "      <h2>Symbols ({} total)</h2>", architecture.symbols.len())?;
        writeln!(output, "      <table>")?;
        writeln!(output, "        <thead>")?;
        writeln!(output, "          <tr><th>Name</th><th>Kind</th><th>File</th><th>Lines</th><th>Complexity</th></tr>")?;
        writeln!(output, "        </thead>")?;
        writeln!(output, "        <tbody>")?;
        
        for symbol in &architecture.symbols {
            writeln!(output, "          <tr>")?;
            writeln!(output, "            <td class=\"symbol-name\">{}</td>", 
                Self::html_escape(&symbol.name))?;
            writeln!(output, "            <td class=\"symbol-kind {}\">{}</td>", 
                symbol.kind, Self::html_escape(&symbol.kind))?;
            writeln!(output, "            <td class=\"file-path\">{}</td>", 
                Self::html_escape(&symbol.file_path))?;
            writeln!(output, "            <td>{}-{}</td>", symbol.lines[0], symbol.lines[1])?;
            writeln!(output, "            <td>{}</td>", 
                symbol.complexity.unwrap_or(0))?;
            writeln!(output, "          </tr>")?;
        }
        
        writeln!(output, "        </tbody>")?;
        writeln!(output, "      </table>")?;
        writeln!(output, "    </div>")?;
        
        // Relationships section
        writeln!(output, "    <div class=\"relationships\">")?;
        writeln!(output, "      <h2>Relationships ({} total)</h2>", architecture.relationships.len())?;
        writeln!(output, "      <div class=\"relationship-list\">")?;
        
        for relationship in &architecture.relationships {
            writeln!(output, "        <div class=\"relationship {}\"?>", 
                relationship.relationship_type.replace("-", "_"))?;
            writeln!(output, "          <strong>{}</strong> → <strong>{}</strong>", 
                Self::html_escape(&relationship.from_symbol),
                Self::html_escape(&relationship.to_symbol))?;
            writeln!(output, "          <span class=\"rel-type\">{}</span>", 
                Self::html_escape(&relationship.relationship_type))?;
            writeln!(output, "        </div>")?;
        }
        
        writeln!(output, "      </div>")?;
        writeln!(output, "    </div>")?;
        
        writeln!(output, "  </div>")?;
        writeln!(output, "</body>")?;
        writeln!(output, "</html>")?;
        Ok(())
    }

    fn export_markdown(
        architecture: &ProjectArchitecture,
        output: &mut dyn Write,
    ) -> Result<()> {
        writeln!(output, "# Project Architecture: {}", architecture.metadata.name)?;
        writeln!(output)?;
        writeln!(output, "Generated on: {}", architecture.metadata.generated_at)?;
        writeln!(output, "Detail Level: {:?}", architecture.metadata.detail_level)?;
        writeln!(output)?;
        
        // Project metadata
        writeln!(output, "## Project Information")?;
        writeln!(output)?;
        writeln!(output, "- **Languages**: {}", architecture.metadata.languages.join(", "))?;
        writeln!(output, "- **Total Files**: {}", architecture.metadata.total_files)?;
        writeln!(output, "- **Total Lines**: {}", architecture.metadata.total_lines)?;
        writeln!(output, "- **Root Path**: `{}`", architecture.metadata.root_path)?;
        writeln!(output)?;
        
        // Metrics
        writeln!(output, "## Metrics")?;
        writeln!(output)?;
        writeln!(output, "### Complexity")?;
        writeln!(output, "- Cyclomatic Complexity: {:.2}", architecture.metrics.complexity.cyclomatic_complexity)?;
        writeln!(output, "- Cognitive Complexity: {:.2}", architecture.metrics.complexity.cognitive_complexity)?;
        writeln!(output, "- Average Function Length: {:.1} lines", architecture.metrics.complexity.function_length_avg)?;
        writeln!(output, "- Average Class Size: {:.1} lines", architecture.metrics.complexity.class_size_avg)?;
        writeln!(output)?;
        
        writeln!(output, "### Dependencies")?;
        writeln!(output, "- Total Dependencies: {}", architecture.metrics.dependencies.total_dependencies)?;
        writeln!(output, "- Circular Dependencies: {}", architecture.metrics.dependencies.circular_dependencies)?;
        writeln!(output, "- Coupling Factor: {:.2}", architecture.metrics.dependencies.coupling_factor)?;
        writeln!(output, "- Cohesion Factor: {:.2}", architecture.metrics.dependencies.cohesion_factor)?;
        writeln!(output)?;
        
        writeln!(output, "### Quality")?;
        writeln!(output, "- Documentation Coverage: {:.1}%", architecture.metrics.quality.documentation_coverage * 100.0)?;
        writeln!(output, "- Maintainability Index: {:.1}/100", architecture.metrics.maintainability.maintainability_index)?;
        writeln!(output)?;
        
        // Symbols
        writeln!(output, "## Symbols ({} total)", architecture.symbols.len())?;
        writeln!(output)?;
        writeln!(output, "| Name | Kind | File | Lines | Complexity |")?;
        writeln!(output, "|------|------|------|-------|------------|")?;
        
        for symbol in &architecture.symbols {
            writeln!(output, "| {} | {} | {} | {}-{} | {} |",
                Self::md_escape(&symbol.name),
                Self::md_escape(&symbol.kind),
                Self::md_escape(&symbol.file_path),
                symbol.lines[0],
                symbol.lines[1],
                symbol.complexity.unwrap_or(0)
            )?;
        }
        
        writeln!(output)?;
        
        // Relationships
        if !architecture.relationships.is_empty() {
            writeln!(output, "## Relationships ({} total)", architecture.relationships.len())?;
            writeln!(output)?;
            
            let mut relationship_groups: HashMap<String, Vec<&ArchitectureRelationship>> = HashMap::new();
            for rel in &architecture.relationships {
                relationship_groups.entry(rel.relationship_type.clone())
                    .or_default()
                    .push(rel);
            }
            
            for (rel_type, relationships) in relationship_groups {
                writeln!(output, "### {} ({} relationships)", rel_type, relationships.len())?;
                writeln!(output)?;
                
                for rel in relationships {
                    writeln!(output, "- `{}` → `{}`", rel.from_symbol, rel.to_symbol)?;
                }
                
                writeln!(output)?;
            }
        }
        
        // Architecture layers
        if !architecture.layers.is_empty() {
            writeln!(output, "## Architecture Layers")?;
            writeln!(output)?;
            
            for layer in &architecture.layers {
                writeln!(output, "### {} (Level {})", layer.name, layer.level)?;
                writeln!(output)?;
                writeln!(output, "**Symbols**: {} symbols", layer.symbols.len())?;
                writeln!(output)?;
                writeln!(output, "**Responsibilities**:")?;
                for responsibility in &layer.responsibilities {
                    writeln!(output, "- {}", responsibility)?;
                }
                writeln!(output)?;
            }
        }
        
        // Detected patterns
        if !architecture.patterns.is_empty() {
            writeln!(output, "## Detected Patterns")?;
            writeln!(output)?;
            
            for pattern in &architecture.patterns {
                writeln!(output, "### {} ({:?})", pattern.pattern_name, pattern.pattern_type)?;
                writeln!(output)?;
                writeln!(output, "**Confidence**: {:.1}%", pattern.confidence * 100.0)?;
                writeln!(output, "**Description**: {}", pattern.description)?;
                writeln!(output, "**Participants**: {}", pattern.participants.join(", "))?;
                writeln!(output)?;
            }
        }
        
        Ok(())
    }

    fn export_plantuml(
        architecture: &ProjectArchitecture,
        output: &mut dyn Write,
    ) -> Result<()> {
        writeln!(output, "@startuml")?;
        writeln!(output, "!theme plain")?;
        writeln!(output, "title Project Architecture - {}", architecture.metadata.name)?;
        writeln!(output)?;
        
        // Group symbols by file/package
        let mut file_groups: HashMap<String, Vec<&ArchitectureSymbol>> = HashMap::new();
        for symbol in &architecture.symbols {
            file_groups.entry(symbol.file_path.clone()).or_default().push(symbol);
        }
        
        // Export packages/files
        for (file_path, symbols) in file_groups {
            let package_name = file_path.split('/').last().unwrap_or(&file_path);
            writeln!(output, "package \"{}\" {{", package_name)?;
            
            for symbol in symbols {
                match symbol.kind.as_str() {
                    "class" | "struct" => {
                        writeln!(output, "  class {} {{", symbol.name)?;
                        writeln!(output, "  }}")?;
                    },
                    "interface" | "trait" => {
                        writeln!(output, "  interface {}", symbol.name)?;
                    },
                    "function" | "method" => {
                        writeln!(output, "  note as {}_note", symbol.id)?;
                        writeln!(output, "    Function: {}", symbol.name)?;
                        writeln!(output, "    Lines: {}-{}", symbol.lines[0], symbol.lines[1])?;
                        writeln!(output, "  end note")?;
                    },
                    _ => {
                        writeln!(output, "  object {}", symbol.name)?;
                    }
                }
            }
            
            writeln!(output, "}}")?;
            writeln!(output)?;
        }
        
        // Export relationships
        for relationship in &architecture.relationships {
            let arrow = match relationship.relationship_type.as_str() {
                "inherit" => "--|>",
                "implement" => "..|>",
                "call" => "-->",
                "uses-type" => "..>",
                _ => "--",
            };
            
            writeln!(output, "{} {} {} : {}", 
                relationship.from_symbol,
                arrow,
                relationship.to_symbol,
                relationship.relationship_type
            )?;
        }
        
        writeln!(output, "@enduml")?;
        Ok(())
    }

    fn export_d2(
        architecture: &ProjectArchitecture,
        output: &mut dyn Write,
    ) -> Result<()> {
        writeln!(output, "# Project Architecture: {}", architecture.metadata.name)?;
        writeln!(output)?;
        
        // Export symbols as shapes
        for symbol in &architecture.symbols {
            let shape = match symbol.kind.as_str() {
                "class" => "class",
                "interface" => "class",
                "function" | "method" => "process",
                _ => "rectangle",
            };
            
            writeln!(output, "{}: {{", symbol.id)?;
            writeln!(output, "  label: \"{}\"", Self::d2_escape(&symbol.name))?;
            writeln!(output, "  shape: {}", shape)?;
            if symbol.kind == "class" {
                writeln!(output, "  style.fill: \"#e1f5fe\"")?;
            }
            writeln!(output, "}}")?;
        }
        
        writeln!(output)?;
        
        // Export relationships
        for relationship in &architecture.relationships {
            let style = match relationship.relationship_type.as_str() {
                "inherit" => "style.stroke-dash: 0",
                "call" => "style.stroke: \"#2196F3\"",
                _ => "",
            };
            
            writeln!(output, "{} -> {}: \"{}\" {{", 
                relationship.from_symbol,
                relationship.to_symbol,
                Self::d2_escape(&relationship.relationship_type)
            )?;
            if !style.is_empty() {
                writeln!(output, "  {}", style)?;
            }
            writeln!(output, "}}")?;
        }
        
        Ok(())
    }

    fn export_cypher(
        architecture: &ProjectArchitecture,
        output: &mut dyn Write,
    ) -> Result<()> {
        writeln!(output, "// Neo4j Cypher queries to import project architecture")?;
        writeln!(output, "// Project: {}", architecture.metadata.name)?;
        writeln!(output)?;
        
        // Clear existing data
        writeln!(output, "// Clear existing project data")?;
        writeln!(output, "MATCH (n:Symbol {{project: '{}'}}) DETACH DELETE n;", 
            Self::cypher_escape(&architecture.metadata.name))?;
        writeln!(output)?;
        
        // Create symbols
        writeln!(output, "// Create symbols")?;
        for symbol in &architecture.symbols {
            writeln!(output, "CREATE ({}:Symbol {{", symbol.id)?;
            writeln!(output, "  project: '{}',", Self::cypher_escape(&architecture.metadata.name))?;
            writeln!(output, "  id: '{}',", Self::cypher_escape(&symbol.id))?;
            writeln!(output, "  name: '{}',", Self::cypher_escape(&symbol.name))?;
            writeln!(output, "  kind: '{}',", Self::cypher_escape(&symbol.kind))?;
            writeln!(output, "  file_path: '{}',", Self::cypher_escape(&symbol.file_path))?;
            writeln!(output, "  visibility: '{:?}',", symbol.visibility)?;
            writeln!(output, "  complexity: {},", symbol.complexity.unwrap_or(0))?;
            writeln!(output, "  lines_start: {},", symbol.lines[0])?;
            writeln!(output, "  lines_end: {},", symbol.lines[1])?;
            writeln!(output, "  usage_count: {}", symbol.usage_count)?;
            writeln!(output, "}});")?;
        }
        
        writeln!(output)?;
        
        // Create relationships
        writeln!(output, "// Create relationships")?;
        for relationship in &architecture.relationships {
            writeln!(output, "MATCH (from:Symbol {{id: '{}'}}), (to:Symbol {{id: '{}'}})", 
                Self::cypher_escape(&relationship.from_symbol),
                Self::cypher_escape(&relationship.to_symbol)
            )?;
            writeln!(output, "CREATE (from)-[:{}]->(to);", 
                Self::cypher_escape(&relationship.relationship_type.to_uppercase())
            )?;
        }
        
        writeln!(output)?;
        writeln!(output, "// Sample queries:")?;
        writeln!(output, "// Find all classes: MATCH (n:Symbol {{kind: 'class'}}) RETURN n;")?;
        writeln!(output, "// Find symbol dependencies: MATCH (n:Symbol)-[r]->(m:Symbol) RETURN n.name, type(r), m.name;")?;
        writeln!(output, "// Find most connected symbols: MATCH (n:Symbol) RETURN n.name, n.usage_count ORDER BY n.usage_count DESC LIMIT 10;")?;
        
        Ok(())
    }

    // Helper methods for escaping special characters in different formats
    
    fn xml_escape(text: &str) -> String {
        text.replace('&', "&amp;")
            .replace('<', "&lt;")
            .replace('>', "&gt;")
            .replace('"', "&quot;")
            .replace('\'', "&#39;")
    }

    fn html_escape(text: &str) -> String {
        Self::xml_escape(text)
    }

    fn csv_escape(text: &str) -> String {
        if text.contains(',') || text.contains('"') || text.contains('\n') {
            format!("\"{}\"", text.replace('"', "\"\""))
        } else {
            text.to_string()
        }
    }

    fn dot_escape(text: &str) -> String {
        text.replace('\\', "\\\\")
            .replace('"', "\\\"")
            .replace('\n', "\\n")
    }

    fn mermaid_escape(text: &str) -> String {
        text.replace(' ', "_")
            .replace('-', "_")
            .replace('(', "_")
            .replace(')', "_")
    }

    fn md_escape(text: &str) -> String {
        text.replace('|', "\\|")
            .replace('\n', "<br>")
    }

    fn d2_escape(text: &str) -> String {
        text.replace('"', "\\\"")
            .replace('\n', "\\n")
    }

    fn cypher_escape(text: &str) -> String {
        text.replace('\'', "\\'")
            .replace('\\', "\\\\")
    }

    fn get_html_styles() -> &'static str {
        r#"
body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; margin: 0; padding: 20px; background: #f5f5f5; }
.container { max-width: 1200px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
h1 { color: #333; border-bottom: 3px solid #007acc; padding-bottom: 10px; }
h2 { color: #555; margin-top: 30px; }
.metadata, .metrics { background: #f8f9fa; padding: 20px; border-radius: 6px; margin: 20px 0; }
.metric-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; }
.metric { background: white; padding: 15px; border-radius: 4px; border-left: 4px solid #007acc; }
.metric h3 { margin: 0 0 10px 0; color: #333; }
.metric p { margin: 5px 0; color: #666; }
table { width: 100%; border-collapse: collapse; margin: 20px 0; }
th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
th { background: #f1f3f4; font-weight: 600; }
.symbol-name { font-family: 'SF Mono', Monaco, monospace; font-weight: bold; }
.symbol-kind { padding: 4px 8px; border-radius: 4px; font-size: 12px; text-transform: uppercase; }
.symbol-kind.class { background: #e3f2fd; color: #1976d2; }
.symbol-kind.function { background: #e8f5e8; color: #2e7d32; }
.symbol-kind.method { background: #fff3e0; color: #f57c00; }
.file-path { font-family: 'SF Mono', Monaco, monospace; font-size: 12px; color: #666; }
.relationship-list { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 10px; }
.relationship { padding: 10px; background: #f8f9fa; border-radius: 4px; border-left: 3px solid #007acc; }
.rel-type { float: right; font-size: 12px; color: #666; background: #e9ecef; padding: 2px 6px; border-radius: 3px; }
"#
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::architecture_exporter::*;

    fn create_test_architecture() -> ProjectArchitecture {
        ProjectArchitecture {
            metadata: ProjectMetadata {
                name: "Test Project".to_string(),
                root_path: "/test".to_string(),
                languages: vec!["rust".to_string()],
                total_files: 1,
                total_lines: 100,
                generated_at: "2024-01-01T00:00:00Z".to_string(),
                agentmap_version: "1.0.0".to_string(),
                detail_level: DetailLevel::Standard,
            },
            structure: FolderStructure {
                name: "test".to_string(),
                path: "/test".to_string(),
                item_type: FolderItemType::Directory,
                size_bytes: None,
                line_count: None,
                language: None,
                symbols_count: Some(1),
                children: Vec::new(),
                metadata: HashMap::new(),
            },
            symbols: vec![
                ArchitectureSymbol {
                    id: "C1".to_string(),
                    name: "TestClass".to_string(),
                    kind: "class".to_string(),
                    file_path: "test.rs".to_string(),
                    namespace: vec!["test".to_string()],
                    visibility: Visibility::Public,
                    complexity: Some(5),
                    usage_count: 2,
                    roles: vec!["entity".to_string()],
                    lines: [10, 20],
                    source_snippet: None,
                    documentation: None,
                    annotations: Vec::new(),
                }
            ],
            relationships: vec![],
            metrics: ProjectMetrics {
                complexity: ComplexityMetrics {
                    cyclomatic_complexity: 2.0,
                    cognitive_complexity: 1.5,
                    nesting_depth_avg: 2.0,
                    function_length_avg: 15.0,
                    class_size_avg: 50.0,
                },
                dependencies: DependencyMetrics {
                    total_dependencies: 0,
                    circular_dependencies: 0,
                    dependency_depth: 1,
                    coupling_factor: 0.1,
                    cohesion_factor: 0.8,
                },
                quality: QualityMetrics {
                    test_coverage: None,
                    documentation_coverage: 0.5,
                    duplicate_code_percentage: 0.0,
                    technical_debt_minutes: None,
                },
                maintainability: MaintainabilityMetrics {
                    maintainability_index: 75.0,
                    code_churn: 0.1,
                    bug_proneness: 0.2,
                    refactoring_suggestions: Vec::new(),
                },
            },
            layers: Vec::new(),
            patterns: Vec::new(),
        }
    }

    #[test]
    fn test_json_export() {
        let architecture = create_test_architecture();
        let mut output = Vec::new();
        
        ArchitectureFormatter::export(&architecture, ExportFormat::Json, &mut output).unwrap();
        
        let json_str = String::from_utf8(output).unwrap();
        assert!(json_str.contains("Test Project"));
        assert!(json_str.contains("TestClass"));
    }

    #[test]
    fn test_csv_export() {
        let architecture = create_test_architecture();
        let mut output = Vec::new();
        
        ArchitectureFormatter::export(&architecture, ExportFormat::Csv, &mut output).unwrap();
        
        let csv_str = String::from_utf8(output).unwrap();
        assert!(csv_str.contains("=== SYMBOLS ==="));
        assert!(csv_str.contains("TestClass"));
    }

    #[test]
    fn test_markdown_export() {
        let architecture = create_test_architecture();
        let mut output = Vec::new();
        
        ArchitectureFormatter::export(&architecture, ExportFormat::Markdown, &mut output).unwrap();
        
        let md_str = String::from_utf8(output).unwrap();
        assert!(md_str.contains("# Project Architecture: Test Project"));
        assert!(md_str.contains("| TestClass |"));
    }

    #[test]
    fn test_escaping_functions() {
        assert_eq!(ArchitectureFormatter::xml_escape("A&B<C>"), "A&amp;B&lt;C&gt;");
        assert_eq!(ArchitectureFormatter::csv_escape("A,B"), "\"A,B\"");
        assert_eq!(ArchitectureFormatter::dot_escape("A\"B"), "A\\\"B");
    }
}