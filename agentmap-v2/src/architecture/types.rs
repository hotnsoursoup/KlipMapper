//! Types for architecture analysis and export.

use serde::{Deserialize, Serialize};
use std::collections::HashMap;

/// Complete project architecture representation.
///
/// Contains metadata, folder structure, symbols, relationships,
/// metrics, architectural layers, and detected patterns.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ProjectArchitecture {
    /// Project metadata.
    pub metadata: ProjectMetadata,
    /// Folder structure tree.
    pub structure: FolderStructure,
    /// Extracted symbols.
    pub symbols: Vec<ArchitectureSymbol>,
    /// Relationships between symbols.
    pub relationships: Vec<ArchitectureRelationship>,
    /// Project metrics.
    pub metrics: ProjectMetrics,
    /// Detected architectural layers.
    pub layers: Vec<ArchitectureLayer>,
    /// Detected design patterns.
    pub patterns: Vec<ArchitecturePattern>,
}

impl ProjectArchitecture {
    /// Create a new project architecture with the given components.
    pub fn new(
        metadata: ProjectMetadata,
        structure: FolderStructure,
        symbols: Vec<ArchitectureSymbol>,
        relationships: Vec<ArchitectureRelationship>,
        metrics: ProjectMetrics,
        layers: Vec<ArchitectureLayer>,
        patterns: Vec<ArchitecturePattern>,
    ) -> Self {
        Self {
            metadata,
            structure,
            symbols,
            relationships,
            metrics,
            layers,
            patterns,
        }
    }

    /// Get total symbol count.
    pub fn symbol_count(&self) -> usize {
        self.symbols.len()
    }

    /// Get total relationship count.
    pub fn relationship_count(&self) -> usize {
        self.relationships.len()
    }

    /// Get symbols by kind.
    pub fn symbols_by_kind(&self, kind: &str) -> Vec<&ArchitectureSymbol> {
        self.symbols.iter()
            .filter(|s| s.kind == kind)
            .collect()
    }

    /// Get symbols in a layer.
    pub fn symbols_in_layer(&self, layer_name: &str) -> Vec<&ArchitectureSymbol> {
        if let Some(layer) = self.layers.iter().find(|l| l.name == layer_name) {
            self.symbols.iter()
                .filter(|s| layer.symbols.contains(&s.id))
                .collect()
        } else {
            Vec::new()
        }
    }
}

/// Project metadata.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ProjectMetadata {
    /// Project name (from directory name).
    pub name: String,
    /// Root path of the project.
    pub root_path: String,
    /// Languages detected in the project.
    pub languages: Vec<String>,
    /// Total number of files analyzed.
    pub total_files: usize,
    /// Total lines of code.
    pub total_lines: usize,
    /// Timestamp when generated (ISO 8601).
    pub generated_at: String,
    /// AgentMap version.
    pub agentmap_version: String,
    /// Detail level used for export.
    pub detail_level: DetailLevel,
}

impl ProjectMetadata {
    /// Create new metadata.
    pub fn new(name: String, root_path: String) -> Self {
        Self {
            name,
            root_path,
            languages: Vec::new(),
            total_files: 0,
            total_lines: 0,
            generated_at: chrono::Utc::now().to_rfc3339(),
            agentmap_version: env!("CARGO_PKG_VERSION").to_string(),
            detail_level: DetailLevel::Standard,
        }
    }

    /// Set languages.
    pub fn with_languages(mut self, languages: Vec<String>) -> Self {
        self.languages = languages;
        self
    }

    /// Set file count.
    pub fn with_files(mut self, count: usize) -> Self {
        self.total_files = count;
        self
    }

    /// Set line count.
    pub fn with_lines(mut self, count: usize) -> Self {
        self.total_lines = count;
        self
    }

    /// Set detail level.
    pub fn with_detail_level(mut self, level: DetailLevel) -> Self {
        self.detail_level = level;
        self
    }
}

/// Detail level for architecture export.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum DetailLevel {
    /// Just folder structure and file counts.
    Minimal,
    /// Add language breakdown and basic metrics.
    Basic,
    /// Add symbol summaries and relationships.
    Standard,
    /// Add detailed symbol information.
    Detailed,
    /// Include everything: source snippets, fingerprints, etc.
    Complete,
}

impl Default for DetailLevel {
    fn default() -> Self {
        Self::Standard
    }
}

impl std::fmt::Display for DetailLevel {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Self::Minimal => write!(f, "minimal"),
            Self::Basic => write!(f, "basic"),
            Self::Standard => write!(f, "standard"),
            Self::Detailed => write!(f, "detailed"),
            Self::Complete => write!(f, "complete"),
        }
    }
}

impl std::str::FromStr for DetailLevel {
    type Err = anyhow::Error;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        match s.to_lowercase().as_str() {
            "minimal" | "min" => Ok(Self::Minimal),
            "basic" => Ok(Self::Basic),
            "standard" | "std" => Ok(Self::Standard),
            "detailed" | "detail" => Ok(Self::Detailed),
            "complete" | "full" => Ok(Self::Complete),
            _ => anyhow::bail!("Unknown detail level: {}. Expected: minimal, basic, standard, detailed, or complete", s),
        }
    }
}

/// Folder structure item.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct FolderStructure {
    /// Name of the item.
    pub name: String,
    /// Full path.
    pub path: String,
    /// Type of item.
    pub item_type: FolderItemType,
    /// File size in bytes (for files).
    pub size_bytes: Option<u64>,
    /// Line count (for code files).
    pub line_count: Option<usize>,
    /// Detected language (for code files).
    pub language: Option<String>,
    /// Number of symbols (for code files).
    pub symbols_count: Option<usize>,
    /// Child items (for directories).
    pub children: Vec<FolderStructure>,
    /// Additional metadata.
    pub metadata: HashMap<String, String>,
}

impl FolderStructure {
    /// Create a new directory structure item.
    pub fn directory(name: String, path: String) -> Self {
        Self {
            name,
            path,
            item_type: FolderItemType::Directory,
            size_bytes: None,
            line_count: None,
            language: None,
            symbols_count: None,
            children: Vec::new(),
            metadata: HashMap::new(),
        }
    }

    /// Create a new file structure item.
    pub fn file(name: String, path: String, size: u64) -> Self {
        Self {
            name,
            path,
            item_type: FolderItemType::File,
            size_bytes: Some(size),
            line_count: None,
            language: None,
            symbols_count: None,
            children: Vec::new(),
            metadata: HashMap::new(),
        }
    }

    /// Set the item type.
    pub fn with_type(mut self, item_type: FolderItemType) -> Self {
        self.item_type = item_type;
        self
    }

    /// Set language.
    pub fn with_language(mut self, language: String) -> Self {
        self.language = Some(language);
        self
    }

    /// Set line count.
    pub fn with_lines(mut self, lines: usize) -> Self {
        self.line_count = Some(lines);
        self
    }

    /// Set symbol count.
    pub fn with_symbols(mut self, count: usize) -> Self {
        self.symbols_count = Some(count);
        self
    }

    /// Add a child item.
    pub fn add_child(mut self, child: FolderStructure) -> Self {
        self.children.push(child);
        self
    }

    /// Check if this is a directory.
    pub fn is_directory(&self) -> bool {
        matches!(self.item_type, FolderItemType::Directory)
    }

    /// Check if this is a file.
    pub fn is_file(&self) -> bool {
        !self.is_directory()
    }

    /// Get total file count recursively.
    pub fn file_count(&self) -> usize {
        if self.is_file() {
            1
        } else {
            self.children.iter().map(|c| c.file_count()).sum()
        }
    }

    /// Get total symbol count recursively.
    pub fn total_symbols(&self) -> usize {
        if self.is_file() {
            self.symbols_count.unwrap_or(0)
        } else {
            self.children.iter().map(|c| c.total_symbols()).sum()
        }
    }
}

/// Type of folder item.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum FolderItemType {
    /// Directory/folder.
    Directory,
    /// Regular code file.
    File,
    /// Symbolic link.
    SymbolicLink,
    /// Configuration file.
    Config,
    /// Documentation file.
    Documentation,
    /// Test file.
    Test,
    /// Asset file (images, fonts, etc.).
    Asset,
    /// Build output file.
    Build,
    /// Generated/auto-created file.
    Generated,
}

impl Default for FolderItemType {
    fn default() -> Self {
        Self::File
    }
}

impl std::fmt::Display for FolderItemType {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Self::Directory => write!(f, "directory"),
            Self::File => write!(f, "file"),
            Self::SymbolicLink => write!(f, "symlink"),
            Self::Config => write!(f, "config"),
            Self::Documentation => write!(f, "docs"),
            Self::Test => write!(f, "test"),
            Self::Asset => write!(f, "asset"),
            Self::Build => write!(f, "build"),
            Self::Generated => write!(f, "generated"),
        }
    }
}

/// Symbol extracted for architecture analysis.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ArchitectureSymbol {
    /// Unique symbol ID.
    pub id: String,
    /// Symbol name.
    pub name: String,
    /// Symbol kind (function, class, etc.).
    pub kind: String,
    /// File path where symbol is defined.
    pub file_path: String,
    /// Namespace/module hierarchy.
    pub namespace: Vec<String>,
    /// Visibility level.
    pub visibility: Visibility,
    /// Complexity score.
    pub complexity: Option<u32>,
    /// Number of usages/references.
    pub usage_count: usize,
    /// Roles/attributes.
    pub roles: Vec<String>,
    /// Line range [start, end].
    pub lines: [u32; 2],
    /// Source code snippet.
    pub source_snippet: Option<String>,
    /// Documentation/docstring.
    pub documentation: Option<String>,
    /// Annotations/attributes/decorators.
    pub annotations: Vec<String>,
}

impl ArchitectureSymbol {
    /// Create a new architecture symbol.
    pub fn new(id: String, name: String, kind: String, file_path: String) -> Self {
        Self {
            id,
            name,
            kind,
            file_path,
            namespace: Vec::new(),
            visibility: Visibility::Internal,
            complexity: None,
            usage_count: 0,
            roles: Vec::new(),
            lines: [0, 0],
            source_snippet: None,
            documentation: None,
            annotations: Vec::new(),
        }
    }

    /// Set namespace.
    pub fn with_namespace(mut self, namespace: Vec<String>) -> Self {
        self.namespace = namespace;
        self
    }

    /// Set visibility.
    pub fn with_visibility(mut self, visibility: Visibility) -> Self {
        self.visibility = visibility;
        self
    }

    /// Set complexity.
    pub fn with_complexity(mut self, complexity: u32) -> Self {
        self.complexity = Some(complexity);
        self
    }

    /// Set usage count.
    pub fn with_usage_count(mut self, count: usize) -> Self {
        self.usage_count = count;
        self
    }

    /// Set roles.
    pub fn with_roles(mut self, roles: Vec<String>) -> Self {
        self.roles = roles;
        self
    }

    /// Set line range.
    pub fn with_lines(mut self, start: u32, end: u32) -> Self {
        self.lines = [start, end];
        self
    }

    /// Set source snippet.
    pub fn with_source(mut self, source: String) -> Self {
        self.source_snippet = Some(source);
        self
    }

    /// Set documentation.
    pub fn with_documentation(mut self, docs: String) -> Self {
        self.documentation = Some(docs);
        self
    }

    /// Add an annotation.
    pub fn add_annotation(mut self, annotation: String) -> Self {
        self.annotations.push(annotation);
        self
    }

    /// Get fully qualified name.
    pub fn qualified_name(&self) -> String {
        if self.namespace.is_empty() {
            self.name.clone()
        } else {
            format!("{}::{}", self.namespace.join("::"), self.name)
        }
    }

    /// Get line count.
    pub fn line_count(&self) -> u32 {
        if self.lines[1] >= self.lines[0] {
            self.lines[1] - self.lines[0] + 1
        } else {
            0
        }
    }
}

/// Visibility level.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum Visibility {
    /// Public/exported.
    Public,
    /// Private (file-local).
    Private,
    /// Protected (inheritance-accessible).
    Protected,
    /// Internal (package/module).
    Internal,
    /// Package-level visibility (Java).
    Package,
}

impl Default for Visibility {
    fn default() -> Self {
        Self::Internal
    }
}

impl std::fmt::Display for Visibility {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Self::Public => write!(f, "public"),
            Self::Private => write!(f, "private"),
            Self::Protected => write!(f, "protected"),
            Self::Internal => write!(f, "internal"),
            Self::Package => write!(f, "package"),
        }
    }
}

/// Relationship between symbols.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ArchitectureRelationship {
    /// Source symbol ID.
    pub from_symbol: String,
    /// Target symbol ID.
    pub to_symbol: String,
    /// Type of relationship.
    pub relationship_type: String,
    /// Relationship strength (0.0 to 1.0).
    pub strength: f32,
    /// File where relationship is defined.
    pub file_path: Option<String>,
    /// Line number of relationship.
    pub line_number: Option<u32>,
    /// Additional context.
    pub context: Option<String>,
}

impl ArchitectureRelationship {
    /// Create a new relationship.
    pub fn new(from: String, to: String, rel_type: String) -> Self {
        Self {
            from_symbol: from,
            to_symbol: to,
            relationship_type: rel_type,
            strength: 1.0,
            file_path: None,
            line_number: None,
            context: None,
        }
    }

    /// Set strength.
    pub fn with_strength(mut self, strength: f32) -> Self {
        self.strength = strength.clamp(0.0, 1.0);
        self
    }

    /// Set file path.
    pub fn with_file(mut self, path: String) -> Self {
        self.file_path = Some(path);
        self
    }

    /// Set line number.
    pub fn with_line(mut self, line: u32) -> Self {
        self.line_number = Some(line);
        self
    }

    /// Set context.
    pub fn with_context(mut self, context: String) -> Self {
        self.context = Some(context);
        self
    }
}

/// Project metrics aggregate.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ProjectMetrics {
    /// Complexity metrics.
    pub complexity: ComplexityMetrics,
    /// Dependency metrics.
    pub dependencies: DependencyMetrics,
    /// Quality metrics.
    pub quality: QualityMetrics,
    /// Maintainability metrics.
    pub maintainability: MaintainabilityMetrics,
}

impl Default for ProjectMetrics {
    fn default() -> Self {
        Self {
            complexity: ComplexityMetrics::default(),
            dependencies: DependencyMetrics::default(),
            quality: QualityMetrics::default(),
            maintainability: MaintainabilityMetrics::default(),
        }
    }
}

/// Complexity metrics.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ComplexityMetrics {
    /// Average cyclomatic complexity.
    pub cyclomatic_complexity: f32,
    /// Average cognitive complexity.
    pub cognitive_complexity: f32,
    /// Average nesting depth.
    pub nesting_depth_avg: f32,
    /// Average function length in lines.
    pub function_length_avg: f32,
    /// Average class size in lines.
    pub class_size_avg: f32,
}

impl Default for ComplexityMetrics {
    fn default() -> Self {
        Self {
            cyclomatic_complexity: 0.0,
            cognitive_complexity: 0.0,
            nesting_depth_avg: 0.0,
            function_length_avg: 0.0,
            class_size_avg: 0.0,
        }
    }
}

/// Dependency metrics.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct DependencyMetrics {
    /// Total number of dependencies.
    pub total_dependencies: usize,
    /// Number of circular dependencies.
    pub circular_dependencies: usize,
    /// Maximum dependency chain depth.
    pub dependency_depth: usize,
    /// Coupling factor (dependencies per symbol).
    pub coupling_factor: f32,
    /// Cohesion factor (internal relationships).
    pub cohesion_factor: f32,
}

impl Default for DependencyMetrics {
    fn default() -> Self {
        Self {
            total_dependencies: 0,
            circular_dependencies: 0,
            dependency_depth: 0,
            coupling_factor: 0.0,
            cohesion_factor: 0.0,
        }
    }
}

/// Quality metrics.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct QualityMetrics {
    /// Test coverage percentage (if available).
    pub test_coverage: Option<f32>,
    /// Documentation coverage percentage.
    pub documentation_coverage: f32,
    /// Duplicate code percentage.
    pub duplicate_code_percentage: f32,
    /// Estimated technical debt in minutes.
    pub technical_debt_minutes: Option<u32>,
}

impl Default for QualityMetrics {
    fn default() -> Self {
        Self {
            test_coverage: None,
            documentation_coverage: 0.0,
            duplicate_code_percentage: 0.0,
            technical_debt_minutes: None,
        }
    }
}

/// Maintainability metrics.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct MaintainabilityMetrics {
    /// Maintainability index (0-100).
    pub maintainability_index: f32,
    /// Code churn rate.
    pub code_churn: f32,
    /// Bug proneness score.
    pub bug_proneness: f32,
    /// Suggested refactorings.
    pub refactoring_suggestions: Vec<String>,
}

impl Default for MaintainabilityMetrics {
    fn default() -> Self {
        Self {
            maintainability_index: 100.0,
            code_churn: 0.0,
            bug_proneness: 0.0,
            refactoring_suggestions: Vec::new(),
        }
    }
}

/// Architectural layer.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ArchitectureLayer {
    /// Layer name.
    pub name: String,
    /// Layer level (0 = top, higher = lower).
    pub level: usize,
    /// Symbol IDs in this layer.
    pub symbols: Vec<String>,
    /// Layer responsibilities.
    pub responsibilities: Vec<String>,
    /// Dependencies on other layers.
    pub dependencies: Vec<String>,
    /// Architectural violations.
    pub violations: Vec<LayerViolation>,
}

impl ArchitectureLayer {
    /// Create a new layer.
    pub fn new(name: String, level: usize) -> Self {
        Self {
            name,
            level,
            symbols: Vec::new(),
            responsibilities: Vec::new(),
            dependencies: Vec::new(),
            violations: Vec::new(),
        }
    }

    /// Add a symbol to this layer.
    pub fn add_symbol(mut self, symbol_id: String) -> Self {
        self.symbols.push(symbol_id);
        self
    }

    /// Add symbols to this layer.
    pub fn with_symbols(mut self, symbols: Vec<String>) -> Self {
        self.symbols = symbols;
        self
    }

    /// Set responsibilities.
    pub fn with_responsibilities(mut self, responsibilities: Vec<String>) -> Self {
        self.responsibilities = responsibilities;
        self
    }

    /// Add a dependency on another layer.
    pub fn depends_on(mut self, layer: String) -> Self {
        self.dependencies.push(layer);
        self
    }

    /// Add a violation.
    pub fn add_violation(mut self, violation: LayerViolation) -> Self {
        self.violations.push(violation);
        self
    }

    /// Check if layer has violations.
    pub fn has_violations(&self) -> bool {
        !self.violations.is_empty()
    }
}

/// Architectural layer violation.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct LayerViolation {
    /// Type of violation.
    pub violation_type: String,
    /// Description of the violation.
    pub description: String,
    /// Severity level.
    pub severity: ViolationSeverity,
    /// Source symbol ID.
    pub from_symbol: String,
    /// Target symbol ID.
    pub to_symbol: String,
}

impl LayerViolation {
    /// Create a new violation.
    pub fn new(
        violation_type: String,
        description: String,
        from_symbol: String,
        to_symbol: String,
    ) -> Self {
        Self {
            violation_type,
            description,
            severity: ViolationSeverity::Warning,
            from_symbol,
            to_symbol,
        }
    }

    /// Set severity.
    pub fn with_severity(mut self, severity: ViolationSeverity) -> Self {
        self.severity = severity;
        self
    }
}

/// Severity of architectural violation.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum ViolationSeverity {
    /// Informational.
    Info,
    /// Warning - should be addressed.
    Warning,
    /// Error - must be fixed.
    Error,
    /// Critical - security or stability issue.
    Critical,
}

impl Default for ViolationSeverity {
    fn default() -> Self {
        Self::Warning
    }
}

impl std::fmt::Display for ViolationSeverity {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Self::Info => write!(f, "info"),
            Self::Warning => write!(f, "warning"),
            Self::Error => write!(f, "error"),
            Self::Critical => write!(f, "critical"),
        }
    }
}

/// Detected design pattern.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ArchitecturePattern {
    /// Pattern name.
    pub pattern_name: String,
    /// Pattern category.
    pub pattern_type: PatternType,
    /// Detection confidence (0.0 to 1.0).
    pub confidence: f32,
    /// Symbol IDs participating in the pattern.
    pub participants: Vec<String>,
    /// Description of how the pattern is implemented.
    pub description: String,
    /// Benefits of this pattern usage.
    pub benefits: Vec<String>,
    /// Concerns or potential issues.
    pub concerns: Vec<String>,
}

impl ArchitecturePattern {
    /// Create a new pattern.
    pub fn new(name: String, pattern_type: PatternType) -> Self {
        Self {
            pattern_name: name,
            pattern_type,
            confidence: 0.0,
            participants: Vec::new(),
            description: String::new(),
            benefits: Vec::new(),
            concerns: Vec::new(),
        }
    }

    /// Set confidence.
    pub fn with_confidence(mut self, confidence: f32) -> Self {
        self.confidence = confidence.clamp(0.0, 1.0);
        self
    }

    /// Set participants.
    pub fn with_participants(mut self, participants: Vec<String>) -> Self {
        self.participants = participants;
        self
    }

    /// Set description.
    pub fn with_description(mut self, description: String) -> Self {
        self.description = description;
        self
    }

    /// Add a benefit.
    pub fn add_benefit(mut self, benefit: String) -> Self {
        self.benefits.push(benefit);
        self
    }

    /// Add a concern.
    pub fn add_concern(mut self, concern: String) -> Self {
        self.concerns.push(concern);
        self
    }
}

/// Design pattern category.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum PatternType {
    /// Creational pattern (Factory, Singleton, Builder, etc.).
    Creational,
    /// Structural pattern (Adapter, Decorator, Facade, etc.).
    Structural,
    /// Behavioral pattern (Observer, Strategy, Command, etc.).
    Behavioral,
    /// Architectural pattern (MVC, MVVM, Layered, etc.).
    Architectural,
    /// Concurrency pattern (Thread Pool, Producer-Consumer, etc.).
    Concurrency,
    /// Anti-pattern (God Object, Spaghetti Code, etc.).
    AntiPattern,
}

impl Default for PatternType {
    fn default() -> Self {
        Self::Behavioral
    }
}

impl std::fmt::Display for PatternType {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Self::Creational => write!(f, "creational"),
            Self::Structural => write!(f, "structural"),
            Self::Behavioral => write!(f, "behavioral"),
            Self::Architectural => write!(f, "architectural"),
            Self::Concurrency => write!(f, "concurrency"),
            Self::AntiPattern => write!(f, "anti-pattern"),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_detail_level_parse() {
        assert_eq!("minimal".parse::<DetailLevel>().unwrap(), DetailLevel::Minimal);
        assert_eq!("standard".parse::<DetailLevel>().unwrap(), DetailLevel::Standard);
        assert_eq!("complete".parse::<DetailLevel>().unwrap(), DetailLevel::Complete);
    }

    #[test]
    fn test_folder_structure() {
        let dir = FolderStructure::directory("src".to_string(), "/project/src".to_string())
            .add_child(FolderStructure::file("main.rs".to_string(), "/project/src/main.rs".to_string(), 1024));

        assert!(dir.is_directory());
        assert_eq!(dir.file_count(), 1);
    }

    #[test]
    fn test_architecture_symbol() {
        let symbol = ArchitectureSymbol::new(
            "F1".to_string(),
            "main".to_string(),
            "function".to_string(),
            "src/main.rs".to_string(),
        )
        .with_namespace(vec!["project".to_string()])
        .with_visibility(Visibility::Public)
        .with_lines(1, 50);

        assert_eq!(symbol.qualified_name(), "project::main");
        assert_eq!(symbol.line_count(), 50);
    }

    #[test]
    fn test_architecture_relationship() {
        let rel = ArchitectureRelationship::new(
            "F1".to_string(),
            "F2".to_string(),
            "calls".to_string(),
        )
        .with_strength(0.8)
        .with_line(42);

        assert_eq!(rel.strength, 0.8);
        assert_eq!(rel.line_number, Some(42));
    }

    #[test]
    fn test_architecture_layer() {
        let layer = ArchitectureLayer::new("Domain".to_string(), 2)
            .with_symbols(vec!["E1".to_string(), "E2".to_string()])
            .with_responsibilities(vec!["Business logic".to_string()]);

        assert_eq!(layer.symbols.len(), 2);
        assert!(!layer.has_violations());
    }

    #[test]
    fn test_architecture_pattern() {
        let pattern = ArchitecturePattern::new("Factory".to_string(), PatternType::Creational)
            .with_confidence(0.85)
            .with_participants(vec!["F1".to_string()])
            .add_benefit("Flexible creation".to_string());

        assert_eq!(pattern.confidence, 0.85);
        assert_eq!(pattern.benefits.len(), 1);
    }

    #[test]
    fn test_visibility_display() {
        assert_eq!(Visibility::Public.to_string(), "public");
        assert_eq!(Visibility::Private.to_string(), "private");
    }

    #[test]
    fn test_pattern_type_display() {
        assert_eq!(PatternType::Creational.to_string(), "creational");
        assert_eq!(PatternType::AntiPattern.to_string(), "anti-pattern");
    }
}
