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
            (class_definition 
                name: (identifier) @class.name
                superclass: (type_identifier)? @class.superclass
                body: (class_body) @class.body) @class.definition
            "#,
            functions: r#"
            (function_declaration
                name: (identifier) @function.name
                parameters: (formal_parameter_list) @function.params
                body: (_) @function.body) @function.definition
            "#,
            methods: r#"
            (method_declaration
                name: (identifier) @method.name
                parameters: (formal_parameter_list) @method.params
                body: (_) @method.body) @method.definition
            "#,
            imports: r#"
            (import_specification
                library: (dotted_identifier) @import.library
                (import_combinator)? @import.combinator) @import
                
            (library_import
                uri: (string_literal) @import.uri
                (as_clause (identifier) @import.alias)?
                (show_clause (identifier_list))? @import.show
                (hide_clause (identifier_list))? @import.hide) @import
            "#,
            exports: r#"
            (library_export
                uri: (string_literal) @export.uri
                (show_clause (identifier_list))? @export.show
                (hide_clause (identifier_list))? @export.hide) @export
            "#,
            variables: r#"
            (initialized_variable_definition
                (declared_identifier
                    name: (identifier) @variable.name
                    type: (type_identifier)? @variable.type) 
                value: (_) @variable.value) @variable.definition
            "#,
            types: r#"
            (type_alias
                name: (type_identifier) @type.name
                type: (_) @type.definition) @type.alias
            "#,
            annotations: r#"
            (annotation
                name: (identifier) @annotation.name
                arguments: (arguments)? @annotation.args) @annotation
            "#,
        }
    }

    pub fn typescript() -> Self {
        Self {
            classes: r#"
            (class_declaration
                name: (type_identifier) @class.name
                superclass: (class_heritage (identifier))? @class.superclass
                body: (class_body) @class.body) @class.definition
            "#,
            functions: r#"
            (function_declaration
                name: (identifier) @function.name
                parameters: (formal_parameters) @function.params
                body: (statement_block) @function.body) @function.definition
            "#,
            methods: r#"
            (method_definition
                name: (property_identifier) @method.name
                parameters: (formal_parameters) @method.params
                body: (statement_block) @method.body) @method.definition
            "#,
            imports: r#"
            (import_statement
                source: (string) @import.source
                (import_clause)? @import.clause) @import
            "#,
            exports: r#"
            (export_statement) @export
            "#,
            variables: r#"
            (variable_declaration
                (variable_declarator
                    name: (identifier) @variable.name
                    value: (_)? @variable.value)) @variable.definition
            "#,
            types: r#"
            (type_alias_declaration
                name: (type_identifier) @type.name
                value: (_) @type.definition) @type.alias
            "#,
            annotations: r#"
            (decorator
                (call_expression
                    function: (identifier) @annotation.name
                    arguments: (arguments)? @annotation.args)) @annotation
            "#,
        }
    }

    pub fn javascript() -> Self {
        // JavaScript patterns (similar to TypeScript but without types)
        Self {
            classes: r#"
            (class_declaration
                name: (identifier) @class.name
                superclass: (class_heritage (identifier))? @class.superclass
                body: (class_body) @class.body) @class.definition
            "#,
            functions: r#"
            (function_declaration
                name: (identifier) @function.name
                parameters: (formal_parameters) @function.params
                body: (statement_block) @function.body) @function.definition
            "#,
            methods: r#"
            (method_definition
                name: (property_identifier) @method.name
                parameters: (formal_parameters) @method.params
                body: (statement_block) @method.body) @method.definition
            "#,
            imports: r#"
            (import_statement
                source: (string) @import.source
                (import_clause)? @import.clause) @import
            "#,
            exports: r#"
            (export_statement) @export
            "#,
            variables: r#"
            (variable_declaration
                (variable_declarator
                    name: (identifier) @variable.name
                    value: (_)? @variable.value)) @variable.definition
            "#,
            types: "",
            annotations: "",
        }
    }

    pub fn python() -> Self {
        Self {
            classes: r#"
            (class_definition
                name: (identifier) @class.name
                superclasses: (argument_list)? @class.superclasses
                body: (block) @class.body) @class.definition
            "#,
            functions: r#"
            (function_definition
                name: (identifier) @function.name
                parameters: (parameters) @function.params
                body: (block) @function.body) @function.definition
            "#,
            methods: r#"
            (function_definition
                name: (identifier) @method.name
                parameters: (parameters) @method.params
                body: (block) @method.body) @method.definition
            "#,
            imports: r#"
            (import_statement
                name: (dotted_name) @import.name) @import
                
            (import_from_statement
                module_name: (dotted_name)? @import.module
                name: (dotted_name) @import.name) @import.from
            "#,
            exports: "",
            variables: r#"
            (assignment
                left: (identifier) @variable.name
                right: (_) @variable.value) @variable.definition
            "#,
            types: "",
            annotations: r#"
            (decorator
                (identifier) @annotation.name) @annotation
            "#,
        }
    }

    pub fn rust() -> Self {
        Self {
            classes: r#"
            (struct_item
                name: (type_identifier) @struct.name
                body: (_) @struct.body) @struct.definition
                
            (enum_item
                name: (type_identifier) @enum.name
                body: (_) @enum.body) @enum.definition
            "#,
            functions: r#"
            (function_item
                name: (identifier) @function.name
                parameters: (parameters) @function.params
                body: (block) @function.body) @function.definition
            "#,
            methods: r#"
            (function_item
                name: (identifier) @method.name
                parameters: (parameters) @method.params
                body: (block) @method.body) @method.definition
            "#,
            imports: r#"
            (use_declaration
                argument: (_) @import.path) @import
            "#,
            exports: r#"
            (visibility_modifier) @export
            "#,
            variables: r#"
            (let_declaration
                pattern: (identifier) @variable.name
                value: (_)? @variable.value) @variable.definition
            "#,
            types: r#"
            (type_item
                name: (type_identifier) @type.name
                type: (_) @type.definition) @type.alias
            "#,
            annotations: r#"
            (attribute_item
                (attribute
                    (identifier) @annotation.name
                    arguments: (_)? @annotation.args)) @annotation
            "#,
        }
    }

    pub fn go() -> Self {
        Self {
            classes: r#"
            (type_declaration
                (type_spec
                    name: (type_identifier) @struct.name
                    type: (struct_type) @struct.body)) @struct.definition
            "#,
            functions: r#"
            (function_declaration
                name: (identifier) @function.name
                parameters: (parameter_list) @function.params
                body: (block) @function.body) @function.definition
            "#,
            methods: r#"
            (method_declaration
                name: (field_identifier) @method.name
                parameters: (parameter_list) @method.params
                body: (block) @method.body) @method.definition
            "#,
            imports: r#"
            (import_spec
                path: (interpreted_string_literal) @import.path
                name: (package_identifier)? @import.alias) @import
            "#,
            exports: "",
            variables: r#"
            (var_declaration
                (var_spec
                    name: (identifier) @variable.name
                    type: (_)? @variable.type
                    value: (_)? @variable.value)) @variable.definition
            "#,
            types: r#"
            (type_declaration
                (type_spec
                    name: (type_identifier) @type.name
                    type: (_) @type.definition)) @type.alias
            "#,
            annotations: "",
        }
    }

    pub fn java() -> Self {
        Self {
            classes: r#"
            (class_declaration
                name: (identifier) @class.name
                superclass: (superclass (type_identifier))? @class.superclass
                body: (class_body) @class.body) @class.definition
            "#,
            functions: r#"
            (method_declaration
                name: (identifier) @method.name
                parameters: (formal_parameters) @method.params
                body: (block) @method.body) @method.definition
            "#,
            methods: r#"
            (method_declaration
                name: (identifier) @method.name
                parameters: (formal_parameters) @method.params
                body: (block) @method.body) @method.definition
            "#,
            imports: r#"
            (import_declaration
                (scoped_identifier) @import.path) @import
            "#,
            exports: "",
            variables: r#"
            (variable_declarator
                name: (identifier) @variable.name
                value: (_)? @variable.value) @variable.definition
            "#,
            types: "",
            annotations: r#"
            (annotation
                name: (identifier) @annotation.name
                arguments: (annotation_argument_list)? @annotation.args) @annotation
            "#,
        }
    }
}