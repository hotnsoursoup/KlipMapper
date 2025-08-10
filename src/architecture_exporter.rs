use crate::anchor::{AnchorHeader, Symbol, SymbolReference, SymbolEdge};
use crate::wildcard_matcher::{WildcardQueryBuilder, SearchScope};
use serde::{Deserialize, Serialize};
use std::collections::{HashMap, HashSet};
use std::path::{Path, PathBuf};
use anyhow::{Result, Context};
use std::fs;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ProjectArchitecture {
    pub metadata: ProjectMetadata,
    pub structure: FolderStructure,
    pub symbols: Vec<ArchitectureSymbol>,
    pub relationships: Vec<ArchitectureRelationship>,
    pub metrics: ProjectMetrics,
    pub layers: Vec<ArchitectureLayer>,
    pub patterns: Vec<ArchitecturePattern>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ProjectMetadata {
    pub name: String,
    pub root_path: String,
    pub languages: Vec<String>,
    pub total_files: usize,
    pub total_lines: usize,
    pub generated_at: String,
    pub agentmap_version: String,
    pub detail_level: DetailLevel,
}

#[derive(Debug, Clone, Copy, Serialize, Deserialize)]
pub enum DetailLevel {
    /// Just folder structure and file counts
    Minimal,
    /// Add language breakdown and basic metrics
    Basic,
    /// Add symbol summaries and relationships
    Standard,
    /// Add detailed symbol information
    Detailed,
    /// Include everything: source snippets, fingerprints, etc.
    Complete,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct FolderStructure {
    pub name: String,
    pub path: String,
    pub item_type: FolderItemType,
    pub size_bytes: Option<u64>,
    pub line_count: Option<usize>,
    pub language: Option<String>,
    pub symbols_count: Option<usize>,
    pub children: Vec<FolderStructure>,
    pub metadata: HashMap<String, String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum FolderItemType {
    Directory,
    File,
    SymbolicLink,
    Config,
    Documentation,
    Test,
    Asset,
    Build,
    Generated,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ArchitectureSymbol {
    pub id: String,
    pub name: String,
    pub kind: String,
    pub file_path: String,
    pub namespace: Vec<String>,
    pub visibility: Visibility,
    pub complexity: Option<u32>,
    pub usage_count: usize,
    pub roles: Vec<String>,
    pub lines: [u32; 2],
    pub source_snippet: Option<String>,
    pub documentation: Option<String>,
    pub annotations: Vec<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum Visibility {
    Public,
    Private,
    Protected,
    Internal,
    Package,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ArchitectureRelationship {
    pub from_symbol: String,
    pub to_symbol: String,
    pub relationship_type: String,
    pub strength: f32, // 0.0 to 1.0
    pub file_path: Option<String>,
    pub line_number: Option<u32>,
    pub context: Option<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ProjectMetrics {
    pub complexity: ComplexityMetrics,
    pub dependencies: DependencyMetrics,
    pub quality: QualityMetrics,
    pub maintainability: MaintainabilityMetrics,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ComplexityMetrics {
    pub cyclomatic_complexity: f32,
    pub cognitive_complexity: f32,
    pub nesting_depth_avg: f32,
    pub function_length_avg: f32,
    pub class_size_avg: f32,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct DependencyMetrics {
    pub total_dependencies: usize,
    pub circular_dependencies: usize,
    pub dependency_depth: usize,
    pub coupling_factor: f32,
    pub cohesion_factor: f32,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct QualityMetrics {
    pub test_coverage: Option<f32>,
    pub documentation_coverage: f32,
    pub duplicate_code_percentage: f32,
    pub technical_debt_minutes: Option<u32>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct MaintainabilityMetrics {
    pub maintainability_index: f32,
    pub code_churn: f32,
    pub bug_proneness: f32,
    pub refactoring_suggestions: Vec<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ArchitectureLayer {
    pub name: String,
    pub level: usize,
    pub symbols: Vec<String>,
    pub responsibilities: Vec<String>,
    pub dependencies: Vec<String>, // Other layer names
    pub violations: Vec<LayerViolation>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct LayerViolation {
    pub violation_type: String,
    pub description: String,
    pub severity: ViolationSeverity,
    pub from_symbol: String,
    pub to_symbol: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum ViolationSeverity {
    Info,
    Warning,
    Error,
    Critical,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ArchitecturePattern {
    pub pattern_name: String,
    pub pattern_type: PatternType,
    pub confidence: f32,
    pub participants: Vec<String>, // Symbol IDs
    pub description: String,
    pub benefits: Vec<String>,
    pub concerns: Vec<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum PatternType {
    Creational,
    Structural,
    Behavioral,
    Architectural,
    Concurrency,
    AntiPattern,
}

pub struct ArchitectureExporter {
    root_path: PathBuf,
    detail_level: DetailLevel,
    include_tests: bool,
    include_generated: bool,
    max_depth: Option<usize>,
    file_filters: Vec<String>,
}

impl ArchitectureExporter {
    pub fn new(root_path: PathBuf) -> Self {
        Self {
            root_path,
            detail_level: DetailLevel::Standard,
            include_tests: true,
            include_generated: false,
            max_depth: None,
            file_filters: Vec::new(),
        }
    }

    pub fn with_detail_level(mut self, level: DetailLevel) -> Self {
        self.detail_level = level;
        self
    }

    pub fn exclude_tests(mut self) -> Self {
        self.include_tests = false;
        self
    }

    pub fn include_generated(mut self) -> Self {
        self.include_generated = true;
        self
    }

    pub fn max_depth(mut self, depth: usize) -> Self {
        self.max_depth = Some(depth);
        self
    }

    pub fn add_file_filter(mut self, pattern: String) -> Self {
        self.file_filters.push(pattern);
        self
    }

    /// Export project architecture to various formats
    pub fn export(&self, headers: &[AnchorHeader]) -> Result<ProjectArchitecture> {
        // Build folder structure
        let structure = self.build_folder_structure()?;
        
        // Extract symbols based on detail level
        let symbols = self.extract_symbols(headers)?;
        
        // Build relationships
        let relationships = self.build_relationships(headers, &symbols)?;
        
        // Calculate metrics
        let metrics = self.calculate_metrics(headers, &symbols, &relationships)?;
        
        // Detect architectural layers
        let layers = self.detect_layers(&symbols, &relationships)?;
        
        // Identify patterns
        let patterns = self.identify_patterns(&symbols, &relationships)?;
        
        // Create metadata
        let metadata = ProjectMetadata {
            name: self.root_path.file_name()
                .unwrap_or_default()
                .to_string_lossy()
                .to_string(),
            root_path: self.root_path.to_string_lossy().to_string(),
            languages: self.get_languages(headers),
            total_files: headers.len(),
            total_lines: self.count_total_lines(headers)?,
            generated_at: chrono::Utc::now().to_rfc3339(),
            agentmap_version: env!("CARGO_PKG_VERSION").to_string(),
            detail_level: self.detail_level,
        };

        Ok(ProjectArchitecture {
            metadata,
            structure,
            symbols,
            relationships,
            metrics,
            layers,
            patterns,
        })
    }

    fn build_folder_structure(&self) -> Result<FolderStructure> {
        self.build_folder_structure_recursive(&self.root_path, 0)
    }

    fn build_folder_structure_recursive(&self, path: &Path, depth: usize) -> Result<FolderStructure> {
        if let Some(max_depth) = self.max_depth {
            if depth > max_depth {
                return Ok(FolderStructure {
                    name: "...".to_string(),
                    path: path.to_string_lossy().to_string(),
                    item_type: FolderItemType::Directory,
                    size_bytes: None,
                    line_count: None,
                    language: None,
                    symbols_count: None,
                    children: Vec::new(),
                    metadata: HashMap::new(),
                });
            }
        }

        let metadata = fs::metadata(path).context("Failed to read path metadata")?;
        let name = path.file_name()
            .unwrap_or_default()
            .to_string_lossy()
            .to_string();

        if metadata.is_file() {
            let item_type = self.classify_file(path);
            
            // Skip if filtered out
            if !self.should_include_file(path, &item_type) {
                return Ok(FolderStructure {
                    name,
                    path: path.to_string_lossy().to_string(),
                    item_type,
                    size_bytes: Some(metadata.len()),
                    line_count: None,
                    language: None,
                    symbols_count: None,
                    children: Vec::new(),
                    metadata: HashMap::new(),
                });
            }

            let language = self.detect_language(path);
            let (line_count, symbols_count) = if matches!(self.detail_level, DetailLevel::Basic | DetailLevel::Standard | DetailLevel::Detailed | DetailLevel::Complete) {
                let lines = self.count_lines(path).unwrap_or(0);
                let symbols = self.count_symbols(path).unwrap_or(0);
                (Some(lines), Some(symbols))
            } else {
                (None, None)
            };

            let mut file_metadata = HashMap::new();
            if let Some(lang) = &language {
                file_metadata.insert("language".to_string(), lang.clone());
            }

            Ok(FolderStructure {
                name,
                path: path.to_string_lossy().to_string(),
                item_type,
                size_bytes: Some(metadata.len()),
                line_count,
                language,
                symbols_count,
                children: Vec::new(),
                metadata: file_metadata,
            })
        } else {
            let mut children = Vec::new();
            
            if let Ok(entries) = fs::read_dir(path) {
                for entry in entries {
                    if let Ok(entry) = entry {
                        let child_path = entry.path();
                        
                        // Skip hidden directories unless explicitly included
                        if let Some(name) = child_path.file_name() {
                            let name_str = name.to_string_lossy();
                            if name_str.starts_with('.') && !self.should_include_hidden(&name_str) {
                                continue;
                            }
                        }

                        if let Ok(child_structure) = self.build_folder_structure_recursive(&child_path, depth + 1) {
                            children.push(child_structure);
                        }
                    }
                }
            }

            // Sort children: directories first, then files
            children.sort_by(|a, b| {
                match (&a.item_type, &b.item_type) {
                    (FolderItemType::Directory, FolderItemType::File) => std::cmp::Ordering::Less,
                    (FolderItemType::File, FolderItemType::Directory) => std::cmp::Ordering::Greater,
                    _ => a.name.cmp(&b.name),
                }
            });

            Ok(FolderStructure {
                name,
                path: path.to_string_lossy().to_string(),
                item_type: FolderItemType::Directory,
                size_bytes: None,
                line_count: None,
                language: None,
                symbols_count: Some(children.iter().map(|c| c.symbols_count.unwrap_or(0)).sum()),
                children,
                metadata: HashMap::new(),
            })
        }
    }

    fn classify_file(&self, path: &Path) -> FolderItemType {
        let name = path.file_name().unwrap_or_default().to_string_lossy();
        let extension = path.extension().unwrap_or_default().to_string_lossy();

        // Configuration files
        if matches!(name.as_ref(), 
            "Cargo.toml" | "package.json" | "requirements.txt" | "pubspec.yaml" | 
            "Dockerfile" | "docker-compose.yml" | ".env" | "config.yaml" | 
            "tsconfig.json" | "webpack.config.js" | "vite.config.ts"
        ) {
            return FolderItemType::Config;
        }

        // Documentation
        if matches!(extension.as_ref(), "md" | "txt" | "rst" | "adoc") || 
           name.to_lowercase().contains("readme") {
            return FolderItemType::Documentation;
        }

        // Test files
        if name.contains("test") || name.contains("spec") || 
           path.ancestors().any(|p| p.file_name().map_or(false, |n| n.to_string_lossy().contains("test"))) {
            return FolderItemType::Test;
        }

        // Build/generated files
        if matches!(extension.as_ref(), "o" | "so" | "dll" | "exe") ||
           name.contains("generated") || name.contains(".g.") {
            return FolderItemType::Generated;
        }

        // Assets
        if matches!(extension.as_ref(), "png" | "jpg" | "jpeg" | "svg" | "ico" | "ttf" | "woff" | "woff2") {
            return FolderItemType::Asset;
        }

        FolderItemType::File
    }

    fn should_include_file(&self, path: &Path, item_type: &FolderItemType) -> bool {
        match item_type {
            FolderItemType::Test if !self.include_tests => false,
            FolderItemType::Generated | FolderItemType::Build if !self.include_generated => false,
            _ => {
                // Apply file filters
                if !self.file_filters.is_empty() {
                    let path_str = path.to_string_lossy();
                    self.file_filters.iter().any(|filter| {
                        // Simple glob matching
                        if filter.contains('*') {
                            // Convert glob to regex and match
                            let regex_pattern = filter.replace("*", ".*");
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

    fn should_include_hidden(&self, name: &str) -> bool {
        // Include some important hidden directories/files
        matches!(name, ".github" | ".vscode" | ".agentmap" | ".gitignore")
    }

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

    fn count_lines(&self, path: &Path) -> Result<usize> {
        let content = fs::read_to_string(path)?;
        Ok(content.lines().count())
    }

    fn count_symbols(&self, _path: &Path) -> Result<usize> {
        // Would need to load anchor for this file
        // Simplified for now
        Ok(0)
    }

    fn extract_symbols(&self, headers: &[AnchorHeader]) -> Result<Vec<ArchitectureSymbol>> {
        let mut symbols = Vec::new();

        for header in headers {
            for symbol in &header.symbols {
                let arch_symbol = match self.detail_level {
                    DetailLevel::Minimal => continue, // Skip symbols in minimal mode
                    DetailLevel::Basic => ArchitectureSymbol {
                        id: symbol.id.clone(),
                        name: symbol.name.clone(),
                        kind: symbol.kind.clone(),
                        file_path: header.file_id.clone(),
                        namespace: self.extract_namespace(symbol),
                        visibility: self.determine_visibility(symbol),
                        complexity: None,
                        usage_count: symbol.references.len() + symbol.edges.len(),
                        roles: symbol.roles.clone(),
                        lines: symbol.range.lines,
                        source_snippet: None,
                        documentation: None,
                        annotations: Vec::new(),
                    },
                    DetailLevel::Standard => ArchitectureSymbol {
                        id: symbol.id.clone(),
                        name: symbol.name.clone(),
                        kind: symbol.kind.clone(),
                        file_path: header.file_id.clone(),
                        namespace: self.extract_namespace(symbol),
                        visibility: self.determine_visibility(symbol),
                        complexity: self.calculate_symbol_complexity(symbol),
                        usage_count: symbol.references.len() + symbol.edges.len(),
                        roles: symbol.roles.clone(),
                        lines: symbol.range.lines,
                        source_snippet: None,
                        documentation: self.extract_documentation(symbol),
                        annotations: self.extract_annotations(symbol),
                    },
                    DetailLevel::Detailed | DetailLevel::Complete => ArchitectureSymbol {
                        id: symbol.id.clone(),
                        name: symbol.name.clone(),
                        kind: symbol.kind.clone(),
                        file_path: header.file_id.clone(),
                        namespace: self.extract_namespace(symbol),
                        visibility: self.determine_visibility(symbol),
                        complexity: self.calculate_symbol_complexity(symbol),
                        usage_count: symbol.references.len() + symbol.edges.len(),
                        roles: symbol.roles.clone(),
                        lines: symbol.range.lines,
                        source_snippet: if matches!(self.detail_level, DetailLevel::Complete) {
                            self.extract_source_snippet(symbol, &header.file_id)
                        } else {
                            None
                        },
                        documentation: self.extract_documentation(symbol),
                        annotations: self.extract_annotations(symbol),
                    },
                };

                symbols.push(arch_symbol);
            }
        }

        Ok(symbols)
    }

    fn build_relationships(&self, headers: &[AnchorHeader], symbols: &[ArchitectureSymbol]) -> Result<Vec<ArchitectureRelationship>> {
        let mut relationships = Vec::new();

        if matches!(self.detail_level, DetailLevel::Minimal | DetailLevel::Basic) {
            return Ok(relationships);
        }

        // Build symbol ID to index mapping
        let symbol_lookup: HashMap<String, usize> = symbols.iter()
            .enumerate()
            .map(|(i, s)| (s.id.clone(), i))
            .collect();

        for header in headers {
            for symbol in &header.symbols {
                // Process edges (direct relationships)
                for edge in &symbol.edges {
                    if let Some(_target_idx) = symbol_lookup.get(&edge.target) {
                        relationships.push(ArchitectureRelationship {
                            from_symbol: symbol.id.clone(),
                            to_symbol: edge.target.clone(),
                            relationship_type: edge.edge_type.clone(),
                            strength: 1.0, // Direct relationship
                            file_path: Some(header.file_id.clone()),
                            line_number: Some(edge.at_line),
                            context: None,
                        });
                    }
                }

                // Process references (indirect relationships)
                for reference in &symbol.references {
                    // Look for matching symbols by name
                    for target_symbol in symbols {
                        if target_symbol.name == reference.target || 
                           reference.target.ends_with(&format!(".{}", target_symbol.name)) {
                            relationships.push(ArchitectureRelationship {
                                from_symbol: symbol.id.clone(),
                                to_symbol: target_symbol.id.clone(),
                                relationship_type: format!("ref-{}", reference.ref_type),
                                strength: 0.7, // Reference relationship
                                file_path: Some(header.file_id.clone()),
                                line_number: Some(reference.at_line),
                                context: Some(reference.target.clone()),
                            });
                        }
                    }
                }
            }
        }

        Ok(relationships)
    }

    fn calculate_metrics(&self, headers: &[AnchorHeader], symbols: &[ArchitectureSymbol], relationships: &[ArchitectureRelationship]) -> Result<ProjectMetrics> {
        // Simplified metrics calculation
        let complexity = ComplexityMetrics {
            cyclomatic_complexity: self.calculate_avg_cyclomatic_complexity(symbols),
            cognitive_complexity: self.calculate_avg_cognitive_complexity(symbols),
            nesting_depth_avg: 2.5, // Placeholder
            function_length_avg: self.calculate_avg_function_length(symbols),
            class_size_avg: self.calculate_avg_class_size(symbols),
        };

        let dependencies = DependencyMetrics {
            total_dependencies: relationships.len(),
            circular_dependencies: self.detect_circular_dependencies(relationships),
            dependency_depth: self.calculate_dependency_depth(relationships),
            coupling_factor: self.calculate_coupling(symbols, relationships),
            cohesion_factor: self.calculate_cohesion(symbols, relationships),
        };

        let quality = QualityMetrics {
            test_coverage: None, // Would need external tool integration
            documentation_coverage: self.calculate_documentation_coverage(symbols),
            duplicate_code_percentage: 0.0, // Placeholder
            technical_debt_minutes: None,
        };

        let maintainability = MaintainabilityMetrics {
            maintainability_index: self.calculate_maintainability_index(&complexity, &dependencies, &quality),
            code_churn: 0.0, // Would need git integration
            bug_proneness: self.calculate_bug_proneness(&complexity),
            refactoring_suggestions: self.generate_refactoring_suggestions(symbols, relationships),
        };

        Ok(ProjectMetrics {
            complexity,
            dependencies,
            quality,
            maintainability,
        })
    }

    fn detect_layers(&self, symbols: &[ArchitectureSymbol], relationships: &[ArchitectureRelationship]) -> Result<Vec<ArchitectureLayer>> {
        // Simplified layer detection based on naming patterns and relationships
        let mut layers = Vec::new();

        // Common architectural layers
        let layer_patterns = [
            ("Presentation", vec!["controller", "view", "component", "widget"]),
            ("Application", vec!["service", "handler", "use_case", "command"]),
            ("Domain", vec!["entity", "model", "aggregate", "value_object"]),
            ("Infrastructure", vec!["repository", "dao", "client", "adapter"]),
            ("Data", vec!["database", "storage", "cache", "file"]),
        ];

        for (layer_name, patterns) in layer_patterns.iter() {
            let layer_symbols: Vec<String> = symbols.iter()
                .filter(|s| {
                    patterns.iter().any(|pattern| 
                        s.name.to_lowercase().contains(pattern) ||
                        s.kind.to_lowercase().contains(pattern) ||
                        s.roles.iter().any(|role| role.to_lowercase().contains(pattern))
                    )
                })
                .map(|s| s.id.clone())
                .collect();

            if !layer_symbols.is_empty() {
                layers.push(ArchitectureLayer {
                    name: layer_name.to_string(),
                    level: layers.len(),
                    symbols: layer_symbols,
                    responsibilities: self.infer_layer_responsibilities(layer_name),
                    dependencies: Vec::new(), // Would analyze cross-layer dependencies
                    violations: Vec::new(),   // Would detect architectural violations
                });
            }
        }

        Ok(layers)
    }

    fn identify_patterns(&self, symbols: &[ArchitectureSymbol], relationships: &[ArchitectureRelationship]) -> Result<Vec<ArchitecturePattern>> {
        let mut patterns = Vec::new();

        // Detect common design patterns
        patterns.extend(self.detect_singleton_pattern(symbols, relationships)?);
        patterns.extend(self.detect_factory_pattern(symbols, relationships)?);
        patterns.extend(self.detect_observer_pattern(symbols, relationships)?);
        patterns.extend(self.detect_repository_pattern(symbols, relationships)?);

        Ok(patterns)
    }

    // Helper methods for metrics and pattern detection (simplified implementations)

    fn get_languages(&self, headers: &[AnchorHeader]) -> Vec<String> {
        let mut languages: HashSet<String> = headers.iter()
            .map(|h| h.language.clone())
            .collect();
        
        let mut sorted: Vec<String> = languages.into_iter().collect();
        sorted.sort();
        sorted
    }

    fn count_total_lines(&self, headers: &[AnchorHeader]) -> Result<usize> {
        // Would need to read actual files or store line count in headers
        Ok(headers.len() * 100) // Placeholder
    }

    fn extract_namespace(&self, symbol: &Symbol) -> Vec<String> {
        symbol.frames.iter()
            .filter_map(|frame| frame.name.clone())
            .collect()
    }

    fn determine_visibility(&self, symbol: &Symbol) -> Visibility {
        if symbol.roles.contains(&"public".to_string()) {
            Visibility::Public
        } else if symbol.roles.contains(&"private".to_string()) {
            Visibility::Private
        } else if symbol.roles.contains(&"protected".to_string()) {
            Visibility::Protected
        } else {
            Visibility::Internal
        }
    }

    fn calculate_symbol_complexity(&self, symbol: &Symbol) -> Option<u32> {
        // Simple complexity based on number of relationships and nesting
        let base_complexity = match symbol.kind.as_str() {
            "function" | "method" => 1,
            "class" | "struct" => 2,
            _ => 1,
        };
        
        let relationship_complexity = (symbol.edges.len() + symbol.references.len()) as u32;
        let nesting_complexity = symbol.frames.len() as u32;
        
        Some(base_complexity + relationship_complexity + nesting_complexity)
    }

    fn extract_documentation(&self, _symbol: &Symbol) -> Option<String> {
        // Would extract from source comments
        None
    }

    fn extract_annotations(&self, symbol: &Symbol) -> Vec<String> {
        // Extract from roles and other metadata
        symbol.roles.clone()
    }

    fn extract_source_snippet(&self, _symbol: &Symbol, _file_id: &str) -> Option<String> {
        // Would read from actual source file
        None
    }

    // Simplified metric calculations
    fn calculate_avg_cyclomatic_complexity(&self, symbols: &[ArchitectureSymbol]) -> f32 {
        let total: u32 = symbols.iter().filter_map(|s| s.complexity).sum();
        total as f32 / symbols.len().max(1) as f32
    }

    fn calculate_avg_cognitive_complexity(&self, symbols: &[ArchitectureSymbol]) -> f32 {
        // Placeholder - would need deeper analysis
        self.calculate_avg_cyclomatic_complexity(symbols) * 0.8
    }

    fn calculate_avg_function_length(&self, symbols: &[ArchitectureSymbol]) -> f32 {
        let function_symbols: Vec<_> = symbols.iter()
            .filter(|s| matches!(s.kind.as_str(), "function" | "method"))
            .collect();
        
        if function_symbols.is_empty() { return 0.0; }
        
        let total_lines: u32 = function_symbols.iter()
            .map(|s| s.lines[1] - s.lines[0] + 1)
            .sum();
            
        total_lines as f32 / function_symbols.len() as f32
    }

    fn calculate_avg_class_size(&self, symbols: &[ArchitectureSymbol]) -> f32 {
        let class_symbols: Vec<_> = symbols.iter()
            .filter(|s| matches!(s.kind.as_str(), "class" | "struct" | "interface"))
            .collect();
        
        if class_symbols.is_empty() { return 0.0; }
        
        let total_lines: u32 = class_symbols.iter()
            .map(|s| s.lines[1] - s.lines[0] + 1)
            .sum();
            
        total_lines as f32 / class_symbols.len() as f32
    }

    fn detect_circular_dependencies(&self, _relationships: &[ArchitectureRelationship]) -> usize {
        // Would implement cycle detection algorithm
        0
    }

    fn calculate_dependency_depth(&self, _relationships: &[ArchitectureRelationship]) -> usize {
        // Would calculate maximum dependency chain length
        3
    }

    fn calculate_coupling(&self, symbols: &[ArchitectureSymbol], relationships: &[ArchitectureRelationship]) -> f32 {
        if symbols.is_empty() { return 0.0; }
        relationships.len() as f32 / symbols.len() as f32
    }

    fn calculate_cohesion(&self, _symbols: &[ArchitectureSymbol], _relationships: &[ArchitectureRelationship]) -> f32 {
        // Simplified cohesion calculation
        0.7
    }

    fn calculate_documentation_coverage(&self, symbols: &[ArchitectureSymbol]) -> f32 {
        let documented = symbols.iter()
            .filter(|s| s.documentation.is_some())
            .count();
        documented as f32 / symbols.len().max(1) as f32
    }

    fn calculate_maintainability_index(&self, complexity: &ComplexityMetrics, dependencies: &DependencyMetrics, quality: &QualityMetrics) -> f32 {
        // Simplified maintainability index calculation
        let base_score = 100.0;
        let complexity_penalty = complexity.cyclomatic_complexity * 2.0;
        let coupling_penalty = dependencies.coupling_factor * 10.0;
        let documentation_bonus = quality.documentation_coverage * 20.0;
        
        (base_score - complexity_penalty - coupling_penalty + documentation_bonus)
            .max(0.0)
            .min(100.0)
    }

    fn calculate_bug_proneness(&self, complexity: &ComplexityMetrics) -> f32 {
        // Higher complexity = higher bug proneness
        (complexity.cyclomatic_complexity / 10.0).min(1.0)
    }

    fn generate_refactoring_suggestions(&self, symbols: &[ArchitectureSymbol], _relationships: &[ArchitectureRelationship]) -> Vec<String> {
        let mut suggestions = Vec::new();
        
        // Check for overly complex symbols
        for symbol in symbols {
            if let Some(complexity) = symbol.complexity {
                if complexity > 10 {
                    suggestions.push(format!("Consider refactoring {} - complexity: {}", symbol.name, complexity));
                }
            }
            
            if symbol.lines[1] - symbol.lines[0] > 100 {
                suggestions.push(format!("Consider breaking down {} - {} lines", symbol.name, symbol.lines[1] - symbol.lines[0]));
            }
        }
        
        suggestions
    }

    fn infer_layer_responsibilities(&self, layer_name: &str) -> Vec<String> {
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

    // Pattern detection methods (simplified)
    
    fn detect_singleton_pattern(&self, symbols: &[ArchitectureSymbol], _relationships: &[ArchitectureRelationship]) -> Result<Vec<ArchitecturePattern>> {
        let singletons: Vec<_> = symbols.iter()
            .filter(|s| s.name.to_lowercase().contains("singleton") || 
                       s.roles.iter().any(|r| r.contains("singleton")))
            .collect();

        if !singletons.is_empty() {
            Ok(vec![ArchitecturePattern {
                pattern_name: "Singleton".to_string(),
                pattern_type: PatternType::Creational,
                confidence: 0.9,
                participants: singletons.iter().map(|s| s.id.clone()).collect(),
                description: "Ensures a class has only one instance".to_string(),
                benefits: vec!["Controlled access to sole instance".to_string()],
                concerns: vec!["Global state".to_string(), "Testing difficulties".to_string()],
            }])
        } else {
            Ok(Vec::new())
        }
    }

    fn detect_factory_pattern(&self, symbols: &[ArchitectureSymbol], _relationships: &[ArchitectureRelationship]) -> Result<Vec<ArchitecturePattern>> {
        let factories: Vec<_> = symbols.iter()
            .filter(|s| s.name.to_lowercase().contains("factory") || 
                       s.name.to_lowercase().contains("builder"))
            .collect();

        if !factories.is_empty() {
            Ok(vec![ArchitecturePattern {
                pattern_name: "Factory".to_string(),
                pattern_type: PatternType::Creational,
                confidence: 0.8,
                participants: factories.iter().map(|s| s.id.clone()).collect(),
                description: "Creates objects without specifying exact classes".to_string(),
                benefits: vec!["Flexible object creation".to_string()],
                concerns: vec!["Increased complexity".to_string()],
            }])
        } else {
            Ok(Vec::new())
        }
    }

    fn detect_observer_pattern(&self, symbols: &[ArchitectureSymbol], _relationships: &[ArchitectureRelationship]) -> Result<Vec<ArchitecturePattern>> {
        // Look for event/observer related symbols
        Ok(Vec::new()) // Simplified
    }

    fn detect_repository_pattern(&self, symbols: &[ArchitectureSymbol], _relationships: &[ArchitectureRelationship]) -> Result<Vec<ArchitecturePattern>> {
        let repositories: Vec<_> = symbols.iter()
            .filter(|s| s.name.to_lowercase().contains("repository") || 
                       s.name.to_lowercase().contains("repo"))
            .collect();

        if !repositories.is_empty() {
            Ok(vec![ArchitecturePattern {
                pattern_name: "Repository".to_string(),
                pattern_type: PatternType::Architectural,
                confidence: 0.9,
                participants: repositories.iter().map(|s| s.id.clone()).collect(),
                description: "Encapsulates data access logic".to_string(),
                benefits: vec!["Separation of concerns".to_string(), "Testability".to_string()],
                concerns: vec!["Additional abstraction layer".to_string()],
            }])
        } else {
            Ok(Vec::new())
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_detail_levels() {
        let levels = [
            DetailLevel::Minimal,
            DetailLevel::Basic, 
            DetailLevel::Standard,
            DetailLevel::Detailed,
            DetailLevel::Complete,
        ];

        for level in levels {
            let exporter = ArchitectureExporter::new(PathBuf::from("/test"))
                .with_detail_level(level);
            assert_eq!(exporter.detail_level as u8, level as u8);
        }
    }

    #[test]
    fn test_file_classification() {
        let exporter = ArchitectureExporter::new(PathBuf::from("/test"));
        
        assert!(matches!(exporter.classify_file(Path::new("Cargo.toml")), FolderItemType::Config));
        assert!(matches!(exporter.classify_file(Path::new("README.md")), FolderItemType::Documentation));
        assert!(matches!(exporter.classify_file(Path::new("test.rs")), FolderItemType::Test));
        assert!(matches!(exporter.classify_file(Path::new("main.rs")), FolderItemType::File));
    }

    #[test]
    fn test_language_detection() {
        let exporter = ArchitectureExporter::new(PathBuf::from("/test"));
        
        assert_eq!(exporter.detect_language(Path::new("main.rs")), Some("rust".to_string()));
        assert_eq!(exporter.detect_language(Path::new("app.ts")), Some("typescript".to_string()));
        assert_eq!(exporter.detect_language(Path::new("script.py")), Some("python".to_string()));
        assert_eq!(exporter.detect_language(Path::new("Widget.dart")), Some("dart".to_string()));
    }
}