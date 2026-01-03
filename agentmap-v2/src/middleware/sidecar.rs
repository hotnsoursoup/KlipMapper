//! Sidecar output middleware.
//!
//! Writes analysis results as YAML sidecar files alongside source files.

use std::path::PathBuf;
use crate::core::{Result, CodeAnalysis};
use super::{Middleware, Context};

/// Middleware that writes sidecar files for analysis results.
///
/// Creates `.agentmap.yaml` files alongside analyzed source files.
pub struct SidecarMiddleware {
    /// Suffix for sidecar files.
    suffix: String,
    /// Output directory (if different from source).
    output_dir: Option<PathBuf>,
}

impl SidecarMiddleware {
    /// Create a new sidecar middleware with default settings.
    pub fn new() -> Self {
        Self {
            suffix: ".agentmap.yaml".to_string(),
            output_dir: None,
        }
    }

    /// Set custom suffix for sidecar files.
    pub fn with_suffix(mut self, suffix: impl Into<String>) -> Self {
        self.suffix = suffix.into();
        self
    }

    /// Set output directory for sidecar files.
    pub fn with_output_dir(mut self, dir: impl Into<PathBuf>) -> Self {
        self.output_dir = Some(dir.into());
        self
    }

    /// Get the sidecar path for a source file.
    fn sidecar_path(&self, source_path: &std::path::Path) -> PathBuf {
        let base_dir = self.output_dir.as_ref()
            .map(|d| d.clone())
            .unwrap_or_else(|| source_path.parent().unwrap_or(source_path).to_path_buf());

        let file_name = source_path.file_name()
            .and_then(|n| n.to_str())
            .unwrap_or("unknown");

        base_dir.join(format!("{}{}", file_name, self.suffix))
    }

    /// Write sidecar file for an analysis result.
    #[cfg(feature = "sidecar")]
    fn write_sidecar(&self, path: &std::path::Path, analysis: &CodeAnalysis) -> Result<()> {
        let sidecar_path = self.sidecar_path(path);

        // Create compact sidecar format
        let sidecar = SidecarOutput {
            file: path.to_string_lossy().to_string(),
            language: analysis.language.to_string(),
            symbols: analysis.symbols.iter().map(|s| SidecarSymbol {
                name: s.name.clone(),
                kind: s.kind.to_string(),
                line: s.location.start_line,
                visibility: s.visibility.to_string(),
            }).collect(),
            relationships: analysis.relationships.iter().map(|r| SidecarRelationship {
                from: r.from.name().unwrap_or("").to_string(),
                kind: r.kind.to_string(),
                to: r.to.name().unwrap_or("").to_string(),
            }).collect(),
            imports: analysis.imports.iter().map(|i| i.source.clone()).collect(),
        };

        let yaml = serde_yaml::to_string(&sidecar)
            .map_err(|e| Error::other("sidecar", format!("YAML serialization failed: {}", e)))?;

        std::fs::write(&sidecar_path, yaml)
            .map_err(|e| Error::io(&sidecar_path, e))?;

        Ok(())
    }

    #[cfg(not(feature = "sidecar"))]
    fn write_sidecar(&self, _path: &std::path::Path, _analysis: &CodeAnalysis) -> Result<()> {
        // No-op without sidecar feature
        Ok(())
    }
}

#[cfg(feature = "sidecar")]
#[derive(serde::Serialize)]
struct SidecarOutput {
    file: String,
    language: String,
    symbols: Vec<SidecarSymbol>,
    relationships: Vec<SidecarRelationship>,
    imports: Vec<String>,
}

#[cfg(feature = "sidecar")]
#[derive(serde::Serialize)]
struct SidecarSymbol {
    name: String,
    kind: String,
    line: u32,
    visibility: String,
}

#[cfg(feature = "sidecar")]
#[derive(serde::Serialize)]
struct SidecarRelationship {
    from: String,
    kind: String,
    to: String,
}

impl Default for SidecarMiddleware {
    fn default() -> Self {
        Self::new()
    }
}

impl Middleware for SidecarMiddleware {
    fn after_analyze(&self, ctx: &Context, analysis: &CodeAnalysis) -> Result<()> {
        self.write_sidecar(&ctx.path, analysis)
    }

    fn name(&self) -> &str {
        "SidecarMiddleware"
    }
}
