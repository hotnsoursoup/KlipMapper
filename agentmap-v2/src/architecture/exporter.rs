//! Architecture exporter implementation.

use std::collections::{HashMap, HashSet};
use std::fs;
use std::path::{Path, PathBuf};

use anyhow::{Context, Result};

use crate::anchor::{AnchorHeader, Symbol as AnchorSymbol};

use super::types::*;

/// Architecture exporter configuration.
#[derive(Debug, Clone)]
pub struct ExporterConfig {
    /// Detail level for export.
    pub detail_level: DetailLevel,
    /// Include test files.
    pub include_tests: bool,
    /// Include generated files.
    pub include_generated: bool,
    /// Maximum folder depth.
    pub max_depth: Option<usize>,
    /// File path filters.
    pub file_filters: Vec<String>,
}

impl Default for ExporterConfig {
    fn default() -> Self {
        Self {
            detail_level: DetailLevel::Standard,
            include_tests: true,
            include_generated: false,
            max_depth: None,
            file_filters: Vec::new(),
        }
    }
}

impl ExporterConfig {
    /// Create a new config.
    pub fn new() -> Self {
        Self::default()
    }

    /// Set detail level.
    pub fn with_detail_level(mut self, level: DetailLevel) -> Self {
        self.detail_level = level;
        self
    }

    /// Exclude test files.
    pub fn exclude_tests(mut self) -> Self {
        self.include_tests = false;
        self
    }

    /// Include generated files.
    pub fn include_generated(mut self) -> Self {
        self.include_generated = true;
        self
    }

    /// Set max depth.
    pub fn with_max_depth(mut self, depth: usize) -> Self {
        self.max_depth = Some(depth);
        self
    }

    /// Add a file filter.
    pub fn add_filter(mut self, pattern: String) -> Self {
        self.file_filters.push(pattern);
        self
    }
}

/// Architecture exporter.
///
/// Exports project architecture from anchor headers.
pub struct ArchitectureExporter {
    root_path: PathBuf,
    config: ExporterConfig,
}

impl ArchitectureExporter {
    /// Create a new exporter.
    pub fn new(root_path: PathBuf) -> Self {
        Self {
            root_path,
            config: ExporterConfig::default(),
        }
    }

    /// Create with configuration.
    pub fn with_config(root_path: PathBuf, config: ExporterConfig) -> Self {
        Self { root_path, config }
    }

    /// Set detail level.
    pub fn with_detail_level(mut self, level: DetailLevel) -> Self {
        self.config.detail_level = level;
        self
    }

    /// Exclude tests.
    pub fn exclude_tests(mut self) -> Self {
        self.config.include_tests = false;
        self
    }

    /// Include generated files.
    pub fn include_generated(mut self) -> Self {
        self.config.include_generated = true;
        self
    }

    /// Set max depth.
    pub fn max_depth(mut self, depth: usize) -> Self {
        self.config.max_depth = Some(depth);
        self
    }

    /// Add file filter.
    pub fn add_file_filter(mut self, pattern: String) -> Self {
        self.config.file_filters.push(pattern);
        self
    }

    /// Export project architecture from anchor headers.
    pub fn export(&self, headers: &[AnchorHeader]) -> Result<ProjectArchitecture> {
        // Build folder structure
        let structure = self.build_folder_structure()?;

        // Extract symbols based on detail level
        let symbols = self.extract_symbols(headers)?;

        // Build relationships
        let relationships = self.build_relationships(headers, &symbols)?;

        // Calculate metrics
        let metrics = self.calculate_metrics(&symbols, &relationships)?;

        // Detect architectural layers
        let layers = self.detect_layers(&symbols, &relationships)?;

        // Identify patterns
        let patterns = self.identify_patterns(&symbols, &relationships)?;

        // Create metadata
        let metadata = ProjectMetadata::new(
            self.root_path
                .file_name()
                .unwrap_or_default()
                .to_string_lossy()
                .to_string(),
            self.root_path.to_string_lossy().to_string(),
        )
        .with_languages(self.get_languages(headers))
        .with_files(headers.len())
        .with_lines(self.count_total_lines(headers))
        .with_detail_level(self.config.detail_level);

        Ok(ProjectArchitecture::new(
            metadata,
            structure,
            symbols,
            relationships,
            metrics,
            layers,
            patterns,
        ))
    }

    /// Build folder structure recursively.
    fn build_folder_structure(&self) -> Result<FolderStructure> {
        self.build_folder_recursive(&self.root_path, 0)
    }

    fn build_folder_recursive(&self, path: &Path, depth: usize) -> Result<FolderStructure> {
        // Check max depth
        if let Some(max_depth) = self.config.max_depth {
            if depth > max_depth {
                return Ok(FolderStructure::directory(
                    "...".to_string(),
                    path.to_string_lossy().to_string(),
                ));
            }
        }

        let metadata = fs::metadata(path).context("Failed to read path metadata")?;
        let name = path
            .file_name()
            .unwrap_or_default()
            .to_string_lossy()
            .to_string();

        if metadata.is_file() {
            let item_type = self.classify_file(path);

            // Skip if filtered out
            if !self.should_include_file(path, &item_type) {
                return Ok(FolderStructure::file(
                    name,
                    path.to_string_lossy().to_string(),
                    metadata.len(),
                )
                .with_type(item_type));
            }

            let mut structure = FolderStructure::file(
                name,
                path.to_string_lossy().to_string(),
                metadata.len(),
            )
            .with_type(item_type);

            if let Some(language) = self.detect_language(path) {
                structure = structure.with_language(language);
            }

            // Add line count for non-minimal levels
            if !matches!(self.config.detail_level, DetailLevel::Minimal) {
                if let Ok(lines) = self.count_lines(path) {
                    structure = structure.with_lines(lines);
                }
            }

            Ok(structure)
        } else {
            let mut children = Vec::new();

            if let Ok(entries) = fs::read_dir(path) {
                for entry in entries.flatten() {
                    let child_path = entry.path();

                    // Skip hidden directories unless explicitly included
                    if let Some(name) = child_path.file_name() {
                        let name_str = name.to_string_lossy();
                        if name_str.starts_with('.') && !self.should_include_hidden(&name_str) {
                            continue;
                        }
                    }

                    if let Ok(child) = self.build_folder_recursive(&child_path, depth + 1) {
                        children.push(child);
                    }
                }
            }

            // Sort: directories first, then files alphabetically
            children.sort_by(|a, b| {
                match (&a.item_type, &b.item_type) {
                    (FolderItemType::Directory, FolderItemType::File) => std::cmp::Ordering::Less,
                    (FolderItemType::File, FolderItemType::Directory) => std::cmp::Ordering::Greater,
                    _ => a.name.cmp(&b.name),
                }
            });

            let total_symbols: usize = children
                .iter()
                .map(|c| c.symbols_count.unwrap_or(0))
                .sum();

            let mut structure = FolderStructure::directory(name, path.to_string_lossy().to_string())
                .with_symbols(total_symbols);
            structure.children = children;

            Ok(structure)
        }
    }

    /// Classify file type.
    fn classify_file(&self, path: &Path) -> FolderItemType {
        let name = path.file_name().unwrap_or_default().to_string_lossy();
        let extension = path.extension().unwrap_or_default().to_string_lossy();

        // Configuration files
        if matches!(
            name.as_ref(),
            "Cargo.toml"
                | "package.json"
                | "requirements.txt"
                | "pubspec.yaml"
                | "Dockerfile"
                | "docker-compose.yml"
                | ".env"
                | "config.yaml"
                | "tsconfig.json"
                | "webpack.config.js"
                | "vite.config.ts"
        ) {
            return FolderItemType::Config;
        }

        // Documentation
        if matches!(extension.as_ref(), "md" | "txt" | "rst" | "adoc")
            || name.to_lowercase().contains("readme")
        {
            return FolderItemType::Documentation;
        }

        // Test files
        if name.contains("test") || name.contains("spec") {
            return FolderItemType::Test;
        }

        // Check if in test directory
        if path.ancestors().any(|p| {
            p.file_name()
                .map_or(false, |n| n.to_string_lossy().contains("test"))
        }) {
            return FolderItemType::Test;
        }

        // Build/generated files
        if matches!(extension.as_ref(), "o" | "so" | "dll" | "exe")
            || name.contains("generated")
            || name.contains(".g.")
        {
            return FolderItemType::Generated;
        }

        // Assets
        if matches!(
            extension.as_ref(),
            "png" | "jpg" | "jpeg" | "svg" | "ico" | "ttf" | "woff" | "woff2"
        ) {
            return FolderItemType::Asset;
        }

        FolderItemType::File
    }

    /// Check if file should be included.
    fn should_include_file(&self, path: &Path, item_type: &FolderItemType) -> bool {
        match item_type {
            FolderItemType::Test if !self.config.include_tests => false,
            FolderItemType::Generated | FolderItemType::Build if !self.config.include_generated => {
                false
            }
            _ => {
                if !self.config.file_filters.is_empty() {
                    let path_str = path.to_string_lossy();
                    self.config.file_filters.iter().any(|filter| {
                        if filter.contains('*') {
                            let regex_pattern = filter.replace('*', ".*");
                            regex::Regex::new(&regex_pattern)
                                .map_or(false, |re| re.is_match(&path_str))
                        } else {
                            path_str.contains(filter)
                        }
                    })
                } else {
                    true
                }
            }
        }
    }

    /// Check if hidden item should be included.
    fn should_include_hidden(&self, name: &str) -> bool {
        matches!(name, ".github" | ".vscode" | ".agentmap" | ".gitignore")
    }

    /// Detect language from file extension.
    fn detect_language(&self, path: &Path) -> Option<String> {
        let extension = path.extension()?.to_string_lossy();

        match extension.as_ref() {
            "rs" => Some("rust".to_string()),
            "ts" | "tsx" => Some("typescript".to_string()),
            "js" | "jsx" => Some("javascript".to_string()),
            "py" => Some("python".to_string()),
            "dart" => Some("dart".to_string()),
            "java" => Some("java".to_string()),
            "go" => Some("go".to_string()),
            "cpp" | "cc" | "cxx" => Some("cpp".to_string()),
            "c" => Some("c".to_string()),
            "cs" => Some("csharp".to_string()),
            "rb" => Some("ruby".to_string()),
            "php" => Some("php".to_string()),
            "swift" => Some("swift".to_string()),
            "kt" => Some("kotlin".to_string()),
            _ => None,
        }
    }

    /// Count lines in a file.
    fn count_lines(&self, path: &Path) -> Result<usize> {
        let content = fs::read_to_string(path)?;
        Ok(content.lines().count())
    }

    /// Get all languages from headers.
    fn get_languages(&self, headers: &[AnchorHeader]) -> Vec<String> {
        let languages: HashSet<String> = headers.iter().map(|h| h.language.clone()).collect();
        let mut sorted: Vec<String> = languages.into_iter().collect();
        sorted.sort();
        sorted
    }

    /// Count total lines from headers.
    fn count_total_lines(&self, headers: &[AnchorHeader]) -> usize {
        // Estimate based on symbol line ranges
        headers
            .iter()
            .flat_map(|h| h.symbols.iter())
            .map(|s| (s.range.lines[1] - s.range.lines[0] + 1) as usize)
            .sum()
    }

    /// Extract symbols from headers.
    fn extract_symbols(&self, headers: &[AnchorHeader]) -> Result<Vec<ArchitectureSymbol>> {
        let mut symbols = Vec::new();

        if matches!(self.config.detail_level, DetailLevel::Minimal) {
            return Ok(symbols);
        }

        for header in headers {
            for symbol in &header.symbols {
                let arch_symbol = self.convert_symbol(symbol, &header.file_id);
                symbols.push(arch_symbol);
            }
        }

        Ok(symbols)
    }

    /// Convert anchor symbol to architecture symbol.
    fn convert_symbol(&self, symbol: &AnchorSymbol, file_path: &str) -> ArchitectureSymbol {
        let namespace: Vec<String> = symbol
            .frames
            .iter()
            .filter_map(|frame| frame.name.clone())
            .collect();

        let visibility = self.determine_visibility(symbol);
        let complexity = self.calculate_symbol_complexity(symbol);
        let usage_count = symbol.references.len() + symbol.edges.len();

        let mut arch_symbol = ArchitectureSymbol::new(
            symbol.id.clone(),
            symbol.name.clone(),
            symbol.kind.clone(),
            file_path.to_string(),
        )
        .with_namespace(namespace)
        .with_visibility(visibility)
        .with_usage_count(usage_count)
        .with_roles(symbol.roles.clone())
        .with_lines(symbol.range.lines[0], symbol.range.lines[1]);

        if let Some(c) = complexity {
            arch_symbol = arch_symbol.with_complexity(c);
        }

        // Add more detail for higher detail levels
        if matches!(
            self.config.detail_level,
            DetailLevel::Standard | DetailLevel::Detailed | DetailLevel::Complete
        ) {
            for role in &symbol.roles {
                arch_symbol = arch_symbol.add_annotation(role.clone());
            }
        }

        arch_symbol
    }

    /// Determine visibility from symbol.
    fn determine_visibility(&self, symbol: &AnchorSymbol) -> Visibility {
        if symbol.roles.iter().any(|r| r.contains("public") || r == "pub") {
            Visibility::Public
        } else if symbol.roles.iter().any(|r| r.contains("private")) {
            Visibility::Private
        } else if symbol.roles.iter().any(|r| r.contains("protected")) {
            Visibility::Protected
        } else {
            Visibility::Internal
        }
    }

    /// Calculate symbol complexity.
    fn calculate_symbol_complexity(&self, symbol: &AnchorSymbol) -> Option<u32> {
        let base_complexity = match symbol.kind.as_str() {
            "function" | "method" => 1,
            "class" | "struct" => 2,
            _ => 1,
        };

        let relationship_complexity = (symbol.edges.len() + symbol.references.len()) as u32;
        let nesting_complexity = symbol.frames.len() as u32;

        Some(base_complexity + relationship_complexity + nesting_complexity)
    }

    /// Build relationships from headers.
    fn build_relationships(
        &self,
        headers: &[AnchorHeader],
        symbols: &[ArchitectureSymbol],
    ) -> Result<Vec<ArchitectureRelationship>> {
        let mut relationships = Vec::new();

        if matches!(
            self.config.detail_level,
            DetailLevel::Minimal | DetailLevel::Basic
        ) {
            return Ok(relationships);
        }

        // Build symbol lookup
        let symbol_lookup: HashMap<String, usize> = symbols
            .iter()
            .enumerate()
            .map(|(i, s)| (s.id.clone(), i))
            .collect();

        for header in headers {
            for symbol in &header.symbols {
                // Process edges (direct relationships)
                for edge in &symbol.edges {
                    if symbol_lookup.contains_key(&edge.target) {
                        relationships.push(
                            ArchitectureRelationship::new(
                                symbol.id.clone(),
                                edge.target.clone(),
                                edge.edge_type.clone(),
                            )
                            .with_strength(1.0)
                            .with_file(header.file_id.clone())
                            .with_line(edge.at_line),
                        );
                    }
                }

                // Process references (indirect relationships)
                for reference in &symbol.references {
                    for target in symbols {
                        if target.name == reference.target
                            || reference.target.ends_with(&format!(".{}", target.name))
                        {
                            relationships.push(
                                ArchitectureRelationship::new(
                                    symbol.id.clone(),
                                    target.id.clone(),
                                    format!("ref-{}", reference.ref_type),
                                )
                                .with_strength(0.7)
                                .with_file(header.file_id.clone())
                                .with_line(reference.at_line)
                                .with_context(reference.target.clone()),
                            );
                        }
                    }
                }
            }
        }

        Ok(relationships)
    }

    /// Calculate project metrics.
    fn calculate_metrics(
        &self,
        symbols: &[ArchitectureSymbol],
        relationships: &[ArchitectureRelationship],
    ) -> Result<ProjectMetrics> {
        let complexity = ComplexityMetrics {
            cyclomatic_complexity: self.avg_cyclomatic_complexity(symbols),
            cognitive_complexity: self.avg_cognitive_complexity(symbols),
            nesting_depth_avg: 2.5, // Would need deeper analysis
            function_length_avg: self.avg_function_length(symbols),
            class_size_avg: self.avg_class_size(symbols),
        };

        let dependencies = DependencyMetrics {
            total_dependencies: relationships.len(),
            circular_dependencies: 0, // Would need cycle detection
            dependency_depth: 3,      // Would need graph traversal
            coupling_factor: self.calculate_coupling(symbols, relationships),
            cohesion_factor: 0.7, // Would need deeper analysis
        };

        let quality = QualityMetrics {
            test_coverage: None,
            documentation_coverage: self.documentation_coverage(symbols),
            duplicate_code_percentage: 0.0,
            technical_debt_minutes: None,
        };

        let maintainability = MaintainabilityMetrics {
            maintainability_index: self.maintainability_index(&complexity, &dependencies, &quality),
            code_churn: 0.0,
            bug_proneness: self.bug_proneness(&complexity),
            refactoring_suggestions: self.refactoring_suggestions(symbols),
        };

        Ok(ProjectMetrics {
            complexity,
            dependencies,
            quality,
            maintainability,
        })
    }

    fn avg_cyclomatic_complexity(&self, symbols: &[ArchitectureSymbol]) -> f32 {
        if symbols.is_empty() {
            return 0.0;
        }
        let total: u32 = symbols.iter().filter_map(|s| s.complexity).sum();
        total as f32 / symbols.len() as f32
    }

    fn avg_cognitive_complexity(&self, symbols: &[ArchitectureSymbol]) -> f32 {
        self.avg_cyclomatic_complexity(symbols) * 0.8
    }

    fn avg_function_length(&self, symbols: &[ArchitectureSymbol]) -> f32 {
        let functions: Vec<_> = symbols
            .iter()
            .filter(|s| matches!(s.kind.as_str(), "function" | "method"))
            .collect();

        if functions.is_empty() {
            return 0.0;
        }

        let total: u32 = functions.iter().map(|s| s.line_count()).sum();
        total as f32 / functions.len() as f32
    }

    fn avg_class_size(&self, symbols: &[ArchitectureSymbol]) -> f32 {
        let classes: Vec<_> = symbols
            .iter()
            .filter(|s| matches!(s.kind.as_str(), "class" | "struct" | "interface"))
            .collect();

        if classes.is_empty() {
            return 0.0;
        }

        let total: u32 = classes.iter().map(|s| s.line_count()).sum();
        total as f32 / classes.len() as f32
    }

    fn calculate_coupling(
        &self,
        symbols: &[ArchitectureSymbol],
        relationships: &[ArchitectureRelationship],
    ) -> f32 {
        if symbols.is_empty() {
            return 0.0;
        }
        relationships.len() as f32 / symbols.len() as f32
    }

    fn documentation_coverage(&self, symbols: &[ArchitectureSymbol]) -> f32 {
        if symbols.is_empty() {
            return 0.0;
        }
        let documented = symbols.iter().filter(|s| s.documentation.is_some()).count();
        documented as f32 / symbols.len() as f32
    }

    fn maintainability_index(
        &self,
        complexity: &ComplexityMetrics,
        dependencies: &DependencyMetrics,
        quality: &QualityMetrics,
    ) -> f32 {
        let base = 100.0;
        let complexity_penalty = complexity.cyclomatic_complexity * 2.0;
        let coupling_penalty = dependencies.coupling_factor * 10.0;
        let doc_bonus = quality.documentation_coverage * 20.0;

        (base - complexity_penalty - coupling_penalty + doc_bonus).clamp(0.0, 100.0)
    }

    fn bug_proneness(&self, complexity: &ComplexityMetrics) -> f32 {
        (complexity.cyclomatic_complexity / 10.0).min(1.0)
    }

    fn refactoring_suggestions(&self, symbols: &[ArchitectureSymbol]) -> Vec<String> {
        let mut suggestions = Vec::new();

        for symbol in symbols {
            if let Some(complexity) = symbol.complexity {
                if complexity > 10 {
                    suggestions.push(format!(
                        "Consider refactoring {} - complexity: {}",
                        symbol.name, complexity
                    ));
                }
            }

            if symbol.line_count() > 100 {
                suggestions.push(format!(
                    "Consider breaking down {} - {} lines",
                    symbol.name,
                    symbol.line_count()
                ));
            }
        }

        suggestions
    }

    /// Detect architectural layers.
    fn detect_layers(
        &self,
        symbols: &[ArchitectureSymbol],
        _relationships: &[ArchitectureRelationship],
    ) -> Result<Vec<ArchitectureLayer>> {
        let mut layers = Vec::new();

        let layer_patterns = [
            (
                "Presentation",
                vec!["controller", "view", "component", "widget"],
            ),
            (
                "Application",
                vec!["service", "handler", "use_case", "command"],
            ),
            (
                "Domain",
                vec!["entity", "model", "aggregate", "value_object"],
            ),
            (
                "Infrastructure",
                vec!["repository", "dao", "client", "adapter"],
            ),
            ("Data", vec!["database", "storage", "cache", "file"]),
        ];

        for (layer_name, patterns) in layer_patterns.iter() {
            let layer_symbols: Vec<String> = symbols
                .iter()
                .filter(|s| {
                    patterns.iter().any(|pattern| {
                        s.name.to_lowercase().contains(pattern)
                            || s.kind.to_lowercase().contains(pattern)
                            || s.roles
                                .iter()
                                .any(|role| role.to_lowercase().contains(pattern))
                    })
                })
                .map(|s| s.id.clone())
                .collect();

            if !layer_symbols.is_empty() {
                layers.push(
                    ArchitectureLayer::new(layer_name.to_string(), layers.len())
                        .with_symbols(layer_symbols)
                        .with_responsibilities(self.infer_responsibilities(layer_name)),
                );
            }
        }

        Ok(layers)
    }

    fn infer_responsibilities(&self, layer_name: &str) -> Vec<String> {
        match layer_name {
            "Presentation" => vec![
                "User interface".to_string(),
                "Input validation".to_string(),
                "Response formatting".to_string(),
            ],
            "Application" => vec![
                "Business logic orchestration".to_string(),
                "Use case implementation".to_string(),
                "Transaction management".to_string(),
            ],
            "Domain" => vec![
                "Core business logic".to_string(),
                "Business rules".to_string(),
                "Entity management".to_string(),
            ],
            "Infrastructure" => vec![
                "External integrations".to_string(),
                "Data persistence".to_string(),
                "Technical services".to_string(),
            ],
            "Data" => vec![
                "Data storage".to_string(),
                "Data retrieval".to_string(),
                "Data consistency".to_string(),
            ],
            _ => Vec::new(),
        }
    }

    /// Identify design patterns.
    fn identify_patterns(
        &self,
        symbols: &[ArchitectureSymbol],
        _relationships: &[ArchitectureRelationship],
    ) -> Result<Vec<ArchitecturePattern>> {
        let mut patterns = Vec::new();

        // Detect Singleton
        let singletons: Vec<_> = symbols
            .iter()
            .filter(|s| {
                s.name.to_lowercase().contains("singleton")
                    || s.roles.iter().any(|r| r.contains("singleton"))
            })
            .collect();

        if !singletons.is_empty() {
            patterns.push(
                ArchitecturePattern::new("Singleton".to_string(), PatternType::Creational)
                    .with_confidence(0.9)
                    .with_participants(singletons.iter().map(|s| s.id.clone()).collect())
                    .with_description("Ensures a class has only one instance".to_string())
                    .add_benefit("Controlled access to sole instance".to_string())
                    .add_concern("Global state".to_string())
                    .add_concern("Testing difficulties".to_string()),
            );
        }

        // Detect Factory
        let factories: Vec<_> = symbols
            .iter()
            .filter(|s| {
                s.name.to_lowercase().contains("factory")
                    || s.name.to_lowercase().contains("builder")
            })
            .collect();

        if !factories.is_empty() {
            patterns.push(
                ArchitecturePattern::new("Factory".to_string(), PatternType::Creational)
                    .with_confidence(0.8)
                    .with_participants(factories.iter().map(|s| s.id.clone()).collect())
                    .with_description("Creates objects without specifying exact classes".to_string())
                    .add_benefit("Flexible object creation".to_string())
                    .add_concern("Increased complexity".to_string()),
            );
        }

        // Detect Repository
        let repositories: Vec<_> = symbols
            .iter()
            .filter(|s| {
                s.name.to_lowercase().contains("repository")
                    || s.name.to_lowercase().contains("repo")
            })
            .collect();

        if !repositories.is_empty() {
            patterns.push(
                ArchitecturePattern::new("Repository".to_string(), PatternType::Architectural)
                    .with_confidence(0.9)
                    .with_participants(repositories.iter().map(|s| s.id.clone()).collect())
                    .with_description("Encapsulates data access logic".to_string())
                    .add_benefit("Separation of concerns".to_string())
                    .add_benefit("Testability".to_string())
                    .add_concern("Additional abstraction layer".to_string()),
            );
        }

        Ok(patterns)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use tempfile::TempDir;

    #[test]
    fn test_exporter_config() {
        let config = ExporterConfig::new()
            .with_detail_level(DetailLevel::Detailed)
            .exclude_tests()
            .with_max_depth(5);

        assert_eq!(config.detail_level, DetailLevel::Detailed);
        assert!(!config.include_tests);
        assert_eq!(config.max_depth, Some(5));
    }

    #[test]
    fn test_exporter_new() {
        let exporter = ArchitectureExporter::new(PathBuf::from("/test"))
            .with_detail_level(DetailLevel::Complete)
            .exclude_tests();

        assert_eq!(exporter.config.detail_level, DetailLevel::Complete);
        assert!(!exporter.config.include_tests);
    }

    #[test]
    fn test_classify_file() {
        let exporter = ArchitectureExporter::new(PathBuf::from("/test"));

        assert!(matches!(
            exporter.classify_file(Path::new("Cargo.toml")),
            FolderItemType::Config
        ));
        assert!(matches!(
            exporter.classify_file(Path::new("README.md")),
            FolderItemType::Documentation
        ));
        assert!(matches!(
            exporter.classify_file(Path::new("test_main.rs")),
            FolderItemType::Test
        ));
        assert!(matches!(
            exporter.classify_file(Path::new("main.rs")),
            FolderItemType::File
        ));
    }

    #[test]
    fn test_detect_language() {
        let exporter = ArchitectureExporter::new(PathBuf::from("/test"));

        assert_eq!(
            exporter.detect_language(Path::new("main.rs")),
            Some("rust".to_string())
        );
        assert_eq!(
            exporter.detect_language(Path::new("app.ts")),
            Some("typescript".to_string())
        );
        assert_eq!(
            exporter.detect_language(Path::new("script.py")),
            Some("python".to_string())
        );
        assert_eq!(
            exporter.detect_language(Path::new("Widget.dart")),
            Some("dart".to_string())
        );
    }

    #[test]
    fn test_export_empty_headers() {
        let temp = TempDir::new().unwrap();
        let exporter = ArchitectureExporter::new(temp.path().to_path_buf())
            .with_detail_level(DetailLevel::Minimal);

        let result = exporter.export(&[]);
        assert!(result.is_ok());

        let arch = result.unwrap();
        assert!(arch.symbols.is_empty());
        assert!(arch.relationships.is_empty());
    }

    #[test]
    fn test_refactoring_suggestions() {
        let exporter = ArchitectureExporter::new(PathBuf::from("/test"));

        let symbols = vec![
            ArchitectureSymbol::new(
                "F1".to_string(),
                "complex_function".to_string(),
                "function".to_string(),
                "test.rs".to_string(),
            )
            .with_complexity(15)
            .with_lines(1, 150),
        ];

        let suggestions = exporter.refactoring_suggestions(&symbols);
        assert!(!suggestions.is_empty());
        assert!(suggestions.iter().any(|s| s.contains("complex_function")));
    }
}
