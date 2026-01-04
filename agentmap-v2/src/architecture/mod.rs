//! Architecture analysis and export module.
//!
//! This module provides comprehensive project architecture analysis including:
//! - Folder structure mapping
//! - Symbol extraction with detail levels
//! - Relationship analysis
//! - Project metrics (complexity, dependencies, quality, maintainability)
//! - Architectural layer detection
//! - Design pattern identification
//!
//! # Example
//!
//! ```rust,ignore
//! use agentmap::architecture::{ArchitectureExporter, DetailLevel};
//! use std::path::PathBuf;
//!
//! let exporter = ArchitectureExporter::new(PathBuf::from("./my-project"))
//!     .with_detail_level(DetailLevel::Standard)
//!     .exclude_tests();
//!
//! let arch = exporter.export(&headers)?;
//!
//! println!("Project: {}", arch.metadata.name);
//! println!("Symbols: {}", arch.symbols.len());
//! println!("Patterns: {}", arch.patterns.len());
//! ```
//!
//! # Detail Levels
//!
//! The exporter supports multiple detail levels:
//!
//! - **Minimal**: Just folder structure and file counts
//! - **Basic**: Add language breakdown and basic metrics
//! - **Standard**: Add symbol summaries and relationships
//! - **Detailed**: Add detailed symbol information
//! - **Complete**: Include everything: source snippets, fingerprints, etc.

mod types;
mod exporter;

pub use types::{
    // Main architecture type
    ProjectArchitecture,
    ProjectMetadata,

    // Detail level
    DetailLevel,

    // Folder structure
    FolderStructure,
    FolderItemType,

    // Symbols
    ArchitectureSymbol,
    Visibility,

    // Relationships
    ArchitectureRelationship,

    // Metrics
    ProjectMetrics,
    ComplexityMetrics,
    DependencyMetrics,
    QualityMetrics,
    MaintainabilityMetrics,

    // Layers
    ArchitectureLayer,
    LayerViolation,
    ViolationSeverity,

    // Patterns
    ArchitecturePattern,
    PatternType,
};

pub use exporter::{ArchitectureExporter, ExporterConfig};

#[cfg(test)]
mod tests {
    use super::*;
    use std::path::PathBuf;
    use tempfile::TempDir;
    use std::fs;

    #[test]
    fn test_full_export_workflow() {
        let temp = TempDir::new().unwrap();

        // Create test files
        fs::write(temp.path().join("main.rs"), "fn main() {}").unwrap();
        fs::create_dir(temp.path().join("src")).unwrap();
        fs::write(temp.path().join("src/lib.rs"), "pub mod util;").unwrap();

        let exporter = ArchitectureExporter::new(temp.path().to_path_buf())
            .with_detail_level(DetailLevel::Standard);

        let result = exporter.export(&[]);
        assert!(result.is_ok());

        let arch = result.unwrap();
        assert!(!arch.metadata.name.is_empty());
        assert!(!arch.metadata.generated_at.is_empty());
    }

    #[test]
    fn test_detail_level_effects() {
        let temp = TempDir::new().unwrap();

        // Minimal should have no symbols
        let minimal = ArchitectureExporter::new(temp.path().to_path_buf())
            .with_detail_level(DetailLevel::Minimal)
            .export(&[])
            .unwrap();

        assert!(minimal.symbols.is_empty());
        assert!(minimal.relationships.is_empty());
    }

    #[test]
    fn test_project_metadata() {
        let metadata = ProjectMetadata::new("test-project".to_string(), "/test".to_string())
            .with_languages(vec!["rust".to_string(), "typescript".to_string()])
            .with_files(42)
            .with_lines(5000);

        assert_eq!(metadata.name, "test-project");
        assert_eq!(metadata.languages.len(), 2);
        assert_eq!(metadata.total_files, 42);
        assert_eq!(metadata.total_lines, 5000);
    }

    #[test]
    fn test_folder_structure_building() {
        let dir = FolderStructure::directory("src".to_string(), "/project/src".to_string());
        assert!(dir.is_directory());
        assert!(!dir.is_file());

        let file = FolderStructure::file("main.rs".to_string(), "/project/main.rs".to_string(), 1024);
        assert!(file.is_file());
        assert!(!file.is_directory());
    }

    #[test]
    fn test_architecture_symbol_builder() {
        let symbol = ArchitectureSymbol::new(
            "F1".to_string(),
            "process".to_string(),
            "function".to_string(),
            "src/lib.rs".to_string(),
        )
        .with_namespace(vec!["mylib".to_string(), "util".to_string()])
        .with_visibility(Visibility::Public)
        .with_complexity(5)
        .with_lines(10, 50);

        assert_eq!(symbol.qualified_name(), "mylib::util::process");
        assert_eq!(symbol.line_count(), 41);
        assert_eq!(symbol.visibility, Visibility::Public);
    }

    #[test]
    fn test_relationship_builder() {
        let rel = ArchitectureRelationship::new(
            "F1".to_string(),
            "F2".to_string(),
            "calls".to_string(),
        )
        .with_strength(0.9)
        .with_file("test.rs".to_string())
        .with_line(42)
        .with_context("function call".to_string());

        assert_eq!(rel.from_symbol, "F1");
        assert_eq!(rel.to_symbol, "F2");
        assert_eq!(rel.strength, 0.9);
        assert_eq!(rel.line_number, Some(42));
    }

    #[test]
    fn test_layer_detection_patterns() {
        let layer = ArchitectureLayer::new("Domain".to_string(), 2)
            .with_symbols(vec!["E1".to_string(), "E2".to_string()])
            .with_responsibilities(vec![
                "Core business logic".to_string(),
                "Entity management".to_string(),
            ])
            .depends_on("Infrastructure".to_string());

        assert_eq!(layer.name, "Domain");
        assert_eq!(layer.level, 2);
        assert_eq!(layer.symbols.len(), 2);
        assert_eq!(layer.dependencies.len(), 1);
    }

    #[test]
    fn test_pattern_detection() {
        let pattern = ArchitecturePattern::new("Factory".to_string(), PatternType::Creational)
            .with_confidence(0.85)
            .with_participants(vec!["F1".to_string(), "F2".to_string()])
            .with_description("Creates objects without specifying concrete classes".to_string())
            .add_benefit("Flexible instantiation".to_string())
            .add_concern("Added complexity".to_string());

        assert_eq!(pattern.pattern_name, "Factory");
        assert_eq!(pattern.confidence, 0.85);
        assert_eq!(pattern.participants.len(), 2);
        assert_eq!(pattern.benefits.len(), 1);
        assert_eq!(pattern.concerns.len(), 1);
    }

    #[test]
    fn test_metrics_defaults() {
        let metrics = ProjectMetrics::default();

        assert_eq!(metrics.complexity.cyclomatic_complexity, 0.0);
        assert_eq!(metrics.dependencies.total_dependencies, 0);
        assert_eq!(metrics.quality.documentation_coverage, 0.0);
        assert_eq!(metrics.maintainability.maintainability_index, 100.0);
    }

    #[test]
    fn test_violation_severity() {
        let violation = LayerViolation::new(
            "dependency_inversion".to_string(),
            "Domain depends on Infrastructure".to_string(),
            "E1".to_string(),
            "R1".to_string(),
        )
        .with_severity(ViolationSeverity::Error);

        assert_eq!(violation.severity, ViolationSeverity::Error);
    }

    #[test]
    fn test_exporter_config_builder() {
        let config = ExporterConfig::new()
            .with_detail_level(DetailLevel::Detailed)
            .exclude_tests()
            .include_generated()
            .with_max_depth(10)
            .add_filter("*.rs".to_string());

        assert_eq!(config.detail_level, DetailLevel::Detailed);
        assert!(!config.include_tests);
        assert!(config.include_generated);
        assert_eq!(config.max_depth, Some(10));
        assert_eq!(config.file_filters.len(), 1);
    }
}
