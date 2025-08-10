use anyhow::Result;
use std::{collections::HashMap, path::Path};
use tree_sitter::{Language, Query};

pub struct QueryPack {
    pub language: Language,
    pub name: String,
    pub defs_query: Option<Query>,
    pub uses_query: Option<Query>,
    pub imports_query: Option<Query>,
    pub resolver: Box<dyn SymbolResolver>,
}

pub trait SymbolResolver: Send + Sync {
    fn resolve_import_alias(&self, import: &str, alias: Option<&str>) -> String;
    fn resolve_member_access(&self, object: &str, member: &str) -> String;
    fn normalize_symbol_name(&self, name: &str) -> String;
    fn get_enclosing_scope_type(&self, node_kind: &str) -> Option<&'static str>;
}

impl QueryPack {
    pub fn for_typescript() -> Result<Self> {
        let language = tree_sitter_typescript::language_typescript();
        
        let defs_query = Query::new(&language, include_str!("../queries/typescript/defs.scm"))?;
        let uses_query = Query::new(&language, include_str!("../queries/typescript/uses.scm"))?;
        let imports_query = Query::new(&language, include_str!("../queries/typescript/imports.scm"))?;
        
        Ok(Self {
            language,
            name: "typescript".into(),
            defs_query: Some(defs_query),
            uses_query: Some(uses_query),
            imports_query: Some(imports_query),
            resolver: Box::new(TypeScriptResolver),
        })
    }
    
    pub fn for_python() -> Result<Self> {
        let language = tree_sitter_python::language();
        
        let defs_query = Query::new(&language, include_str!("../queries/python/defs.scm"))?;
        let uses_query = Query::new(&language, include_str!("../queries/python/uses.scm"))?;
        let imports_query = Query::new(&language, include_str!("../queries/python/imports.scm"))?;
        
        Ok(Self {
            language,
            name: "python".into(),
            defs_query: Some(defs_query),
            uses_query: Some(uses_query),
            imports_query: Some(imports_query),
            resolver: Box::new(PythonResolver),
        })
    }
    
    pub fn for_rust() -> Result<Self> {
        let language = tree_sitter_rust::language();
        
        let defs_query = Query::new(&language, include_str!("../queries/rust/defs.scm"))?;
        let uses_query = Query::new(&language, include_str!("../queries/rust/uses.scm"))?;
        let imports_query = Query::new(&language, include_str!("../queries/rust/imports.scm"))?;
        
        Ok(Self {
            language,
            name: "rust".into(),
            defs_query: Some(defs_query),
            uses_query: Some(uses_query),
            imports_query: Some(imports_query),
            resolver: Box::new(RustResolver),
        })
    }
}

// Language-specific resolvers
pub struct TypeScriptResolver;

impl SymbolResolver for TypeScriptResolver {
    fn resolve_import_alias(&self, import: &str, alias: Option<&str>) -> String {
        alias.unwrap_or(import).to_string()
    }
    
    fn resolve_member_access(&self, object: &str, member: &str) -> String {
        format!("{}.{}", object, member)
    }
    
    fn normalize_symbol_name(&self, name: &str) -> String {
        name.to_string()
    }
    
    fn get_enclosing_scope_type(&self, node_kind: &str) -> Option<&'static str> {
        match node_kind {
            "function_declaration" | "method_definition" => Some("method"),
            "class_declaration" => Some("class"),
            "interface_declaration" => Some("interface"),
            _ => None,
        }
    }
}

pub struct PythonResolver;

impl SymbolResolver for PythonResolver {
    fn resolve_import_alias(&self, import: &str, alias: Option<&str>) -> String {
        if let Some(alias) = alias {
            alias.to_string()
        } else {
            // For "from foo import bar", use "bar"
            import.split('.').last().unwrap_or(import).to_string()
        }
    }
    
    fn resolve_member_access(&self, object: &str, member: &str) -> String {
        format!("{}.{}", object, member)
    }
    
    fn normalize_symbol_name(&self, name: &str) -> String {
        name.to_string()
    }
    
    fn get_enclosing_scope_type(&self, node_kind: &str) -> Option<&'static str> {
        match node_kind {
            "function_definition" => Some("function"),
            "class_definition" => Some("class"),
            _ => None,
        }
    }
}

pub struct RustResolver;

impl SymbolResolver for RustResolver {
    fn resolve_import_alias(&self, import: &str, alias: Option<&str>) -> String {
        if let Some(alias) = alias {
            alias.to_string()
        } else {
            // For "use foo::bar::Baz", use "Baz"
            import.split("::").last().unwrap_or(import).to_string()
        }
    }
    
    fn resolve_member_access(&self, object: &str, member: &str) -> String {
        format!("{}::{}", object, member)
    }
    
    fn normalize_symbol_name(&self, name: &str) -> String {
        name.to_string()
    }
    
    fn get_enclosing_scope_type(&self, node_kind: &str) -> Option<&'static str> {
        match node_kind {
            "function_item" => Some("function"),
            "impl_item" => Some("impl"),
            "struct_item" => Some("struct"),
            "enum_item" => Some("enum"),
            "trait_item" => Some("trait"),
            _ => None,
        }
    }
}

pub struct QueryPackRegistry {
    packs: HashMap<String, QueryPack>,
}

impl QueryPackRegistry {
    pub fn new() -> Result<Self> {
        let mut packs = HashMap::new();
        
        // Load available query packs
        if let Ok(pack) = QueryPack::for_typescript() {
            packs.insert("typescript".to_string(), pack);
            packs.insert("ts".to_string(), QueryPack::for_typescript()?);
        }
        
        if let Ok(pack) = QueryPack::for_python() {
            packs.insert("python".to_string(), pack);
            packs.insert("py".to_string(), QueryPack::for_python()?);
        }
        
        if let Ok(pack) = QueryPack::for_rust() {
            packs.insert("rust".to_string(), pack);
            packs.insert("rs".to_string(), QueryPack::for_rust()?);
        }
        
        Ok(Self { packs })
    }
    
    pub fn get_pack_for_extension(&self, ext: &str) -> Option<&QueryPack> {
        let lang = match ext {
            "ts" | "tsx" => "typescript",
            "js" | "jsx" => "typescript", // Can reuse TS queries
            "py" => "python",
            "rs" => "rust",
            _ => return None,
        };
        
        self.packs.get(lang)
    }
    
    pub fn get_pack(&self, name: &str) -> Option<&QueryPack> {
        self.packs.get(name)
    }
    
    pub fn list_available_packs(&self) -> Vec<&str> {
        self.packs.keys().map(|s| s.as_str()).collect()
    }
}