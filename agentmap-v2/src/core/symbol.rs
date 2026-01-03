//! Symbol types for code elements.
//!
//! The [`Symbol`] type represents any named code element: functions, classes,
//! variables, constants, etc. It's designed to map directly to db-kit entities.

use std::collections::HashMap;
use serde::{Deserialize, Serialize};
use super::SourceLocation;

/// Unique identifier for a symbol.
///
/// Format: `{file_path}:{start_line}:{name}`
///
/// This format ensures:
/// - Uniqueness across the codebase
/// - Human readability
/// - Stable across renames (line-based)
#[derive(Debug, Clone, PartialEq, Eq, Hash, Serialize, Deserialize)]
pub struct SymbolId(pub String);

impl SymbolId {
    /// Create a new symbol ID.
    pub fn new(file_path: &str, line: u32, name: &str) -> Self {
        Self(format!("{file_path}:{line}:{name}"))
    }

    /// Get the file path component.
    pub fn file_path(&self) -> Option<&str> {
        self.0.split(':').next()
    }

    /// Get the line number component.
    pub fn line(&self) -> Option<u32> {
        self.0.split(':').nth(1)?.parse().ok()
    }

    /// Get the name component.
    ///
    /// Returns the name portion for resolved IDs (format: `file:line:name`)
    /// or the entire string for bare/unresolved names.
    pub fn name(&self) -> Option<&str> {
        // Try to get 3rd segment for resolved format
        if let Some(name) = self.0.split(':').nth(2) {
            Some(name)
        } else if !self.0.is_empty() {
            // For bare names without colons, return entire string
            Some(&self.0)
        } else {
            None
        }
    }

    /// Check if this SymbolId is fully resolved (has file:line:name format).
    ///
    /// Resolved IDs have the format `file_path:line:name` with at least 2 colons.
    /// Unresolved IDs are bare names like `ClassName` or module paths.
    ///
    /// Note: Handles Windows paths like `C:\path\file.rs:10:name` by finding
    /// the last two colons which should be `line:name`.
    pub fn is_resolved(&self) -> bool {
        // Find the last two colons (line:name) to handle Windows drive letters
        if let Some(last_colon) = self.0.rfind(':') {
            if let Some(second_last) = self.0[..last_colon].rfind(':') {
                let line_str = &self.0[second_last + 1..last_colon];
                // Line number should be a valid u32
                return line_str.parse::<u32>().is_ok();
            }
        }
        false
    }
}

impl std::fmt::Display for SymbolId {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.0)
    }
}

impl From<String> for SymbolId {
    fn from(s: String) -> Self {
        Self(s)
    }
}

/// A code symbol (function, class, variable, etc.).
///
/// This is the canonical symbol type in AgentMap. It contains all information
/// needed for RAG indexing:
/// - `code_content` for embeddings
/// - `documentation` for FTS
/// - `properties` for metadata filtering
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub struct Symbol {
    /// Unique identifier.
    pub id: SymbolId,

    /// Symbol name.
    pub name: String,

    /// Symbol kind (function, class, etc.).
    pub kind: SymbolKind,

    /// Source location.
    pub location: SourceLocation,

    /// Visibility modifier.
    pub visibility: Visibility,

    /// The actual source code of this symbol.
    ///
    /// This is essential for generating embeddings.
    pub code_content: String,

    /// Documentation comments (if any).
    pub documentation: Option<String>,

    /// Additional properties for filtering.
    pub properties: HashMap<String, String>,
}

impl Symbol {
    /// Create a new symbol.
    pub fn new(
        name: impl Into<String>,
        kind: SymbolKind,
        location: SourceLocation,
    ) -> Self {
        let name = name.into();
        let id = SymbolId::new(
            location.file_path.to_string_lossy().as_ref(),
            location.start_line,
            &name,
        );

        Self {
            id,
            name,
            kind,
            location,
            visibility: Visibility::default(),
            code_content: String::new(),
            documentation: None,
            properties: HashMap::new(),
        }
    }

    /// Set the code content.
    pub fn with_code(mut self, code: impl Into<String>) -> Self {
        self.code_content = code.into();
        self
    }

    /// Set documentation.
    pub fn with_docs(mut self, docs: impl Into<String>) -> Self {
        self.documentation = Some(docs.into());
        self
    }

    /// Set visibility.
    pub fn with_visibility(mut self, visibility: Visibility) -> Self {
        self.visibility = visibility;
        self
    }

    /// Add a property.
    pub fn with_property(mut self, key: impl Into<String>, value: impl Into<String>) -> Self {
        self.properties.insert(key.into(), value.into());
        self
    }

    /// Check if symbol is public.
    pub fn is_public(&self) -> bool {
        matches!(self.visibility, Visibility::Public)
    }

    /// Get fully qualified name (file::name).
    pub fn fully_qualified_name(&self) -> String {
        format!(
            "{}::{}",
            self.location.file_path.to_string_lossy(),
            self.name
        )
    }
}

/// Kind of symbol.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum SymbolKind {
    // Functions
    Function,
    Method,
    Constructor,
    AsyncFunction,
    Generator,
    Lambda,

    // Types
    Class,
    Struct,
    Interface,
    Trait,
    Enum,
    TypeAlias,

    // Values
    Variable,
    Constant,
    Parameter,
    Field,
    Property,

    // Modules
    Module,
    Namespace,
    Package,

    // Other
    Import,
    Export,
    Macro,
    Decorator,
    Annotation,

    // Generic fallback
    Unknown,
}

impl SymbolKind {
    /// Check if this is a function-like symbol.
    pub fn is_function(&self) -> bool {
        matches!(
            self,
            Self::Function | Self::Method | Self::Constructor |
            Self::AsyncFunction | Self::Generator | Self::Lambda
        )
    }

    /// Check if this is a type definition.
    pub fn is_type(&self) -> bool {
        matches!(
            self,
            Self::Class | Self::Struct | Self::Interface |
            Self::Trait | Self::Enum | Self::TypeAlias
        )
    }

    /// Check if this is a value/variable.
    pub fn is_value(&self) -> bool {
        matches!(
            self,
            Self::Variable | Self::Constant | Self::Parameter |
            Self::Field | Self::Property
        )
    }
}

impl std::fmt::Display for SymbolKind {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let s = match self {
            Self::Function => "function",
            Self::Method => "method",
            Self::Constructor => "constructor",
            Self::AsyncFunction => "async_function",
            Self::Generator => "generator",
            Self::Lambda => "lambda",
            Self::Class => "class",
            Self::Struct => "struct",
            Self::Interface => "interface",
            Self::Trait => "trait",
            Self::Enum => "enum",
            Self::TypeAlias => "type_alias",
            Self::Variable => "variable",
            Self::Constant => "constant",
            Self::Parameter => "parameter",
            Self::Field => "field",
            Self::Property => "property",
            Self::Module => "module",
            Self::Namespace => "namespace",
            Self::Package => "package",
            Self::Import => "import",
            Self::Export => "export",
            Self::Macro => "macro",
            Self::Decorator => "decorator",
            Self::Annotation => "annotation",
            Self::Unknown => "unknown",
        };
        write!(f, "{s}")
    }
}

/// Visibility of a symbol.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Default, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum Visibility {
    Public,
    Private,
    Protected,
    Internal,
    #[default]
    Unspecified,
}

impl std::fmt::Display for Visibility {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let s = match self {
            Self::Public => "public",
            Self::Private => "private",
            Self::Protected => "protected",
            Self::Internal => "internal",
            Self::Unspecified => "unspecified",
        };
        write!(f, "{s}")
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::path::PathBuf;

    #[test]
    fn test_symbol_id_components() {
        let id = SymbolId::new("src/main.rs", 42, "main");
        assert_eq!(id.file_path(), Some("src/main.rs"));
        assert_eq!(id.line(), Some(42));
        assert_eq!(id.name(), Some("main"));
    }

    #[test]
    fn test_symbol_creation() {
        let loc = SourceLocation {
            file_path: PathBuf::from("src/lib.rs"),
            start_line: 10,
            start_column: 0,
            end_line: 20,
            end_column: 1,
            byte_offset: 100,
            byte_length: 500,
        };

        let symbol = Symbol::new("process_data", SymbolKind::Function, loc)
            .with_visibility(Visibility::Public)
            .with_code("fn process_data() { }")
            .with_docs("Processes data.");

        assert_eq!(symbol.name, "process_data");
        assert_eq!(symbol.kind, SymbolKind::Function);
        assert!(symbol.is_public());
        assert!(!symbol.code_content.is_empty());
    }

    #[test]
    fn test_symbol_kind_categories() {
        assert!(SymbolKind::Function.is_function());
        assert!(SymbolKind::AsyncFunction.is_function());
        assert!(!SymbolKind::Class.is_function());

        assert!(SymbolKind::Class.is_type());
        assert!(SymbolKind::Interface.is_type());
        assert!(!SymbolKind::Function.is_type());
    }
}
