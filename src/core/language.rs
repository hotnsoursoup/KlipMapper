use std::path::Path;
use anyhow::Result;
use tree_sitter::Language;

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum SupportedLanguage {
    Dart,
    TypeScript,
    JavaScript,
    Python,
    Rust,
    Go,
    Java,
}

impl SupportedLanguage {
    pub fn from_extension(extension: &str) -> Option<Self> {
        match extension.to_lowercase().as_str() {
            "dart" => Some(Self::Dart),
            "ts" => Some(Self::TypeScript),
            "tsx" => Some(Self::TypeScript),
            "js" => Some(Self::JavaScript),
            "jsx" => Some(Self::JavaScript),
            "py" => Some(Self::Python),
            "rs" => Some(Self::Rust),
            "go" => Some(Self::Go),
            "java" => Some(Self::Java),
            _ => None,
        }
    }

    pub fn from_path(path: &Path) -> Option<Self> {
        path.extension()
            .and_then(|ext| ext.to_str())
            .and_then(Self::from_extension)
    }

    pub fn as_str(&self) -> &'static str {
        match self {
            Self::Dart => "dart",
            Self::TypeScript => "typescript",
            Self::JavaScript => "javascript",
            Self::Python => "python",
            Self::Rust => "rust",
            Self::Go => "go",
            Self::Java => "java",
        }
    }

    pub fn get_tree_sitter_language(&self) -> Result<Language> {
        match self {
            Self::Dart => Ok(tree_sitter_dart::language()),
            Self::TypeScript => Ok(tree_sitter_typescript::language_typescript()),
            Self::JavaScript => Ok(tree_sitter_javascript::language()),
            Self::Python => Ok(tree_sitter_python::language()),
            Self::Rust => Ok(tree_sitter_rust::language()),
            Self::Go => Ok(tree_sitter_go::language()),
            Self::Java => Ok(tree_sitter_java::language()),
        }
    }

    pub fn get_comment_patterns(&self) -> CommentPatterns {
        match self {
            Self::Dart | Self::TypeScript | Self::JavaScript | Self::Rust | Self::Go | Self::Java => {
                CommentPatterns {
                    single_line: vec!["//"],
                    multi_line_start: vec!["/*"],
                    multi_line_end: vec!["*/"],
                    doc_comment: vec!["///", "/**"],
                }
            }
            Self::Python => CommentPatterns {
                single_line: vec!["#"],
                multi_line_start: vec!["\"\"\"", "'''"],
                multi_line_end: vec!["\"\"\"", "'''"],
                doc_comment: vec!["\"\"\""],
            },
        }
    }

    pub fn get_query_patterns(&self) -> LanguageQueryPatterns {
        match self {
            Self::Dart => LanguageQueryPatterns::dart(),
            Self::TypeScript => LanguageQueryPatterns::typescript(),
            Self::JavaScript => LanguageQueryPatterns::javascript(),
            Self::Python => LanguageQueryPatterns::python(),
            Self::Rust => LanguageQueryPatterns::rust(),
            Self::Go => LanguageQueryPatterns::go(),
            Self::Java => LanguageQueryPatterns::java(),
        }
    }
}

#[derive(Debug, Clone)]
pub struct CommentPatterns {
    pub single_line: Vec<&'static str>,
    pub multi_line_start: Vec<&'static str>,
    pub multi_line_end: Vec<&'static str>,
    pub doc_comment: Vec<&'static str>,
}

#[derive(Debug, Clone)]
pub struct LanguageQueryPatterns {
    pub classes: &'static str,
    pub functions: &'static str,
    pub methods: &'static str,
    pub imports: &'static str,
    pub exports: &'static str,
    pub variables: &'static str,
    pub types: &'static str,
    pub annotations: &'static str,
}

impl LanguageQueryPatterns {
    pub fn dart() -> Self {
        Self {
            classes: r#"
            (class_definition) @class.definition
            "#,
            functions: r#"
            (function_signature) @function.definition
            "#,
            methods: r#"
            (method_signature) @method.definition
            "#,
            imports: r#"
            (import_specification) @import
            "#,
            exports: r#"
            (library_export) @export
            "#,
            variables: r#"
            (initialized_variable_definition) @variable.definition
            "#,
            types: r#"
            (type_alias) @type.alias
            "#,
            annotations: r#"
            (annotation) @annotation
            "#,
        }
    }

    pub fn typescript() -> Self {
        Self {
            classes: r#"
            (class_declaration) @class.definition
            "#,
            functions: r#"
            (function_declaration) @function.definition
            "#,
            methods: r#"
            (method_definition) @method.definition
            "#,
            imports: r#"
            (import_statement) @import
            "#,
            exports: r#"
            (export_statement) @export
            "#,
            variables: r#"
            (variable_declaration) @variable.definition
            "#,
            types: r#"
            (type_alias_declaration) @type.alias
            "#,
            annotations: r#"
            (decorator) @annotation
            "#,
        }
    }

    pub fn javascript() -> Self {
        Self {
            classes: r#"
            (class_declaration) @class.definition
            "#,
            functions: r#"
            (function_declaration) @function.definition
            "#,
            methods: r#"
            (method_definition) @method.definition
            "#,
            imports: r#"
            (import_statement) @import
            "#,
            exports: r#"
            (export_statement) @export
            "#,
            variables: r#"
            (variable_declaration) @variable.definition
            "#,
            types: "",
            annotations: "",
        }
    }

    pub fn python() -> Self {
        Self {
            classes: r#"
            (class_definition) @class.definition
            "#,
            functions: r#"
            (function_definition) @function.definition
            "#,
            methods: r#"
            (function_definition) @method.definition
            "#,
            imports: r#"
            (import_statement) @import
            "#,
            exports: "",
            variables: r#"
            (assignment) @variable.definition
            "#,
            types: "",
            annotations: r#"
            (decorator) @annotation
            "#,
        }
    }

    pub fn rust() -> Self {
        Self {
            classes: r#"
            (struct_item) @struct.definition
            "#,
            functions: r#"
            (function_item) @function.definition
            "#,
            methods: r#"
            (function_item) @method.definition
            "#,
            imports: r#"
            (use_declaration) @import
            "#,
            exports: r#"
            (visibility_modifier) @export
            "#,
            variables: r#"
            (let_declaration) @variable.definition
            "#,
            types: r#"
            (type_item) @type.alias
            "#,
            annotations: r#"
            (attribute_item) @annotation
            "#,
        }
    }

    pub fn go() -> Self {
        Self {
            classes: r#"
            (type_declaration) @struct.definition
            "#,
            functions: r#"
            (function_declaration) @function.definition
            "#,
            methods: r#"
            (method_declaration) @method.definition
            "#,
            imports: r#"
            (import_spec) @import
            "#,
            exports: "",
            variables: r#"
            (var_declaration) @variable.definition
            "#,
            types: r#"
            (type_declaration) @type.alias
            "#,
            annotations: "",
        }
    }

    pub fn java() -> Self {
        Self {
            classes: r#"
            (class_declaration) @class.definition
            "#,
            functions: r#"
            (method_declaration) @method.definition
            "#,
            methods: r#"
            (method_declaration) @method.definition
            "#,
            imports: r#"
            (import_declaration) @import
            "#,
            exports: "",
            variables: r#"
            (variable_declarator) @variable.definition
            "#,
            types: "",
            annotations: r#"
            (annotation) @annotation
            "#,
        }
    }
}