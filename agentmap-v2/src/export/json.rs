//! JSON and YAML exporters.

use std::io::Write;
use anyhow::{Context, Result};
use crate::core::CodeAnalysis;
use super::Exporter;

/// JSON/YAML exporter.
pub struct JsonExporter {
    pretty: bool,
    yaml: bool,
}

impl JsonExporter {
    /// Create a new JSON exporter.
    pub fn new(pretty: bool) -> Self {
        Self { pretty, yaml: false }
    }

    /// Create a YAML exporter.
    pub fn yaml() -> Self {
        Self { pretty: true, yaml: true }
    }
}

impl Exporter for JsonExporter {
    fn export(&self, analysis: &CodeAnalysis, output: &mut dyn Write) -> Result<()> {
        if self.yaml {
            let yaml = serde_yaml::to_string(analysis)
                .context("Failed to serialize to YAML")?;
            output.write_all(yaml.as_bytes())?;
        } else if self.pretty {
            let json = serde_json::to_string_pretty(analysis)
                .context("Failed to serialize to JSON")?;
            output.write_all(json.as_bytes())?;
        } else {
            let json = serde_json::to_string(analysis)
                .context("Failed to serialize to JSON")?;
            output.write_all(json.as_bytes())?;
        }
        Ok(())
    }

    fn export_all(&self, analyses: &[CodeAnalysis], output: &mut dyn Write) -> Result<()> {
        if self.yaml {
            let yaml = serde_yaml::to_string(analyses)
                .context("Failed to serialize to YAML")?;
            output.write_all(yaml.as_bytes())?;
        } else if self.pretty {
            let json = serde_json::to_string_pretty(analyses)
                .context("Failed to serialize to JSON")?;
            output.write_all(json.as_bytes())?;
        } else {
            let json = serde_json::to_string(analyses)
                .context("Failed to serialize to JSON")?;
            output.write_all(json.as_bytes())?;
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
    fn test_json_export() {
        let analysis = CodeAnalysis::new(PathBuf::from("test.rs"), Language::Rust);
        let mut output = Vec::new();

        JsonExporter::new(true).export(&analysis, &mut output).unwrap();
        let json = String::from_utf8(output).unwrap();

        assert!(json.contains("test.rs"));
    }

    #[test]
    fn test_yaml_export() {
        let analysis = CodeAnalysis::new(PathBuf::from("test.rs"), Language::Rust);
        let mut output = Vec::new();

        JsonExporter::yaml().export(&analysis, &mut output).unwrap();
        let yaml = String::from_utf8(output).unwrap();

        assert!(yaml.contains("test.rs"));
    }
}
