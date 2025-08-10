use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use std::path::PathBuf;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum SymbolKind {
    // Classes and Types
    Class { 
        is_abstract: bool, 
        superclass: Option<String>,
        interfaces: Vec<String>,
        is_generic: bool,
    },
    Interface,
    Enum { variants: Vec<String> },
    Struct { fields: Vec<Field> },
    Type { definition: String },
    
    // Functions and Methods
    Function { 
        is_async: bool,
        parameters: Vec<Parameter>,
        return_type: Option<String>,
        is_generator: bool,
    },
    Method { 
        visibility: Visibility,
        is_static: bool,
        is_async: bool,
        is_abstract: bool,
        parameters: Vec<Parameter>,
        return_type: Option<String>,
    },
    Constructor { 
        parameters: Vec<Parameter>,
        is_named: bool,
    },
    
    // Variables and Properties
    Variable { 
        var_type: Option<String>, 
        is_mutable: bool,
        is_nullable: bool,
    },
    Property { 
        visibility: Visibility,
        is_static: bool,
        is_final: bool,
        property_type: Option<String>,
    },
    Constant { value: Option<String> },
    
    // Modules and Organization
    Module { exports: Vec<String> },
    Import { 
        source: String, 
        items: Vec<ImportItem>,
        is_wildcard: bool,
        alias: Option<String>,
    },
    Export { items: Vec<String> },
    
    // Flutter/Dart Specific
    Widget { 
        is_stateful: bool,
        properties: Vec<Property>,
        build_method: Option<String>,
        lifecycle_methods: Vec<String>,
    },
    Provider { provided_type: String },
    
    // Language-specific extensions
    Trait { methods: Vec<String> },
    Mixin { methods: Vec<String> },
    Extension { target_type: String },
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Symbol {
    pub id: String,
    pub name: String,
    pub kind: SymbolKind,
    pub location: SourceLocation,
    pub documentation: Option<String>,
    pub annotations: Vec<Annotation>,
    pub visibility: Visibility,
    pub relationships: Vec<Relationship>,
    pub metrics: SymbolMetrics,
    pub context: SymbolContext,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SourceLocation {
    pub file_path: PathBuf,
    pub start_line: u32,
    pub start_column: u32,
    pub end_line: u32,
    pub end_column: u32,
    pub byte_offset: u32,
    pub byte_length: u32,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Field {
    pub name: String,
    pub field_type: String,
    pub is_optional: bool,
    pub default_value: Option<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Parameter {
    pub name: String,
    pub param_type: Option<String>,
    pub is_optional: bool,
    pub default_value: Option<String>,
    pub is_named: bool,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Property {
    pub name: String,
    pub property_type: String,
    pub is_getter: bool,
    pub is_setter: bool,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ImportItem {
    pub name: String,
    pub alias: Option<String>,
    pub is_type_only: bool,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Annotation {
    pub name: String,
    pub arguments: HashMap<String, String>,
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
pub enum Relationship {
    Inherits { target: String },
    Implements { target: String },
    Imports { 
        source: String, 
        alias: Option<String>,
        import_type: ImportType,
    },
    Calls { 
        target: String, 
        call_type: CallType,
        call_context: CallContext,
    },
    References { 
        target: String,
        reference_type: ReferenceType,
    },
    Contains { children: Vec<String> },
    DependsOn { 
        target: String, 
        dependency_type: DependencyType,
        strength: DependencyStrength,
    },
    Overrides { target: String },
    Extends { target: String },
    Mixes { target: String },
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum ImportType {
    Module,
    Named,
    Wildcard,
    Dynamic,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum CallType {
    Direct,
    Indirect,
    Constructor,
    Method,
    Function,
    Static,
    Super,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum CallContext {
    Declaration,
    Assignment,
    Expression,
    Parameter,
    Return,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum ReferenceType {
    TypeAnnotation,
    Variable,
    Parameter,
    ReturnType,
    GenericArgument,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum DependencyType {
    Import,
    Inheritance,
    Composition,
    Aggregation,
    Usage,
    Configuration,
    Testing,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum DependencyStrength {
    Strong,    // Direct dependency
    Medium,    // Indirect but important
    Weak,      // Loose coupling
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SymbolMetrics {
    pub complexity: u32,
    pub lines_of_code: u32,
    pub cyclomatic_complexity: u32,
    pub fan_in: u32,
    pub fan_out: u32,
    pub depth: u32,
    pub coupling: f32,
    pub cohesion: f32,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SymbolContext {
    pub namespace: Option<String>,
    pub module_path: Vec<String>,
    pub enclosing_class: Option<String>,
    pub enclosing_function: Option<String>,
    pub scope_level: u32,
    pub is_test: bool,
    pub is_generated: bool,
    pub language_specific: HashMap<String, serde_json::Value>,
}

impl Default for SymbolMetrics {
    fn default() -> Self {
        Self {
            complexity: 0,
            lines_of_code: 0,
            cyclomatic_complexity: 0,
            fan_in: 0,
            fan_out: 0,
            depth: 0,
            coupling: 0.0,
            cohesion: 0.0,
        }
    }
}

impl Default for SymbolContext {
    fn default() -> Self {
        Self {
            namespace: None,
            module_path: Vec::new(),
            enclosing_class: None,
            enclosing_function: None,
            scope_level: 0,
            is_test: false,
            is_generated: false,
            language_specific: HashMap::new(),
        }
    }
}

impl Symbol {
    pub fn new(id: String, name: String, kind: SymbolKind, location: SourceLocation) -> Self {
        Self {
            id,
            name,
            kind,
            location,
            documentation: None,
            annotations: Vec::new(),
            visibility: Visibility::Public,
            relationships: Vec::new(),
            metrics: SymbolMetrics::default(),
            context: SymbolContext::default(),
        }
    }

    pub fn with_visibility(mut self, visibility: Visibility) -> Self {
        self.visibility = visibility;
        self
    }

    pub fn with_documentation(mut self, documentation: String) -> Self {
        self.documentation = Some(documentation);
        self
    }

    pub fn add_relationship(&mut self, relationship: Relationship) {
        self.relationships.push(relationship);
    }

    pub fn add_annotation(&mut self, annotation: Annotation) {
        self.annotations.push(annotation);
    }

    pub fn is_public(&self) -> bool {
        matches!(self.visibility, Visibility::Public)
    }

    pub fn is_test(&self) -> bool {
        self.context.is_test
    }

    pub fn is_generated(&self) -> bool {
        self.context.is_generated
    }
}