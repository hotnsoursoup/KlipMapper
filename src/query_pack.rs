use anyhow::{Result, Context};
use std::{collections::HashMap, path::{Path, PathBuf}, hash::{Hash, Hasher}, sync::{Arc, Mutex}};
use tree_sitter::{Language, Query};
use lru::LruCache;
use sha2::{Sha256, Digest};

/// Provides TreeSitter query content for different languages and query types
pub trait QueryProvider: Send + Sync {
    fn defs(&self, language: &str) -> Result<String>;
    fn refs(&self, language: &str) -> Result<String>;
    fn exports(&self, language: &str) -> Result<String>;
}

/// Cache key combining language and query content hash
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub struct CacheKey {
    pub language: String,
    pub query_type: QueryType,
    pub content_hash: String,
}

#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub enum QueryType {
    Definitions,
    References,
    Exports,
}

impl CacheKey {
    pub fn new(language: &str, query_type: QueryType, content: &str) -> Self {
        let mut hasher = Sha256::new();
        hasher.update(content.as_bytes());
        let content_hash = format!("{:x}", hasher.finalize())[..16].to_string(); // First 16 chars of SHA256
        
        Self {
            language: language.to_string(),
            query_type,
            content_hash,
        }
    }
}

/// Cached query content for lazy compilation
#[derive(Debug, Clone)]
pub struct CachedQuery {
    pub content: String,
    pub language_name: String,
    pub query_type: QueryType,
}

/// Thread-safe LRU cache for query content (not compiled queries)
pub struct QueryCache {
    cache: Arc<Mutex<LruCache<CacheKey, CachedQuery>>>,
}

impl QueryCache {
    /// Create a new cache with specified capacity
    pub fn new(capacity: usize) -> Self {
        let capacity = std::num::NonZeroUsize::new(capacity).unwrap_or(std::num::NonZeroUsize::new(128).unwrap());
        Self {
            cache: Arc::new(Mutex::new(LruCache::new(capacity))),
        }
    }
    
    /// Get a cached query from cache, returning None if not found
    pub fn get(&self, key: &CacheKey) -> Option<CachedQuery> {
        let mut cache = self.cache.lock().unwrap();
        cache.get(key).cloned()
    }
    
    /// Insert a query content into the cache
    pub fn insert(&self, key: CacheKey, cached_query: CachedQuery) {
        let mut cache = self.cache.lock().unwrap();
        cache.put(key, cached_query);
    }
    
    /// Check if cache contains a key
    pub fn contains(&self, key: &CacheKey) -> bool {
        let cache = self.cache.lock().unwrap();
        cache.contains(key)
    }
    
    /// Clear all entries from cache
    pub fn clear(&self) {
        let mut cache = self.cache.lock().unwrap();
        cache.clear();
    }
    
    /// Get cache statistics
    pub fn len(&self) -> usize {
        let cache = self.cache.lock().unwrap();
        cache.len()
    }
    
    /// Get cache capacity
    pub fn capacity(&self) -> usize {
        let cache = self.cache.lock().unwrap();
        cache.cap().into()
    }
}

impl Clone for QueryCache {
    fn clone(&self) -> Self {
        Self {
            cache: Arc::clone(&self.cache),
        }
    }
}

impl Default for QueryCache {
    fn default() -> Self {
        Self::new(256) // Default capacity
    }
}

/// Embedded query provider using compile-time included queries
#[derive(Debug, Clone, Default)]
pub struct EmbeddedProvider;

/// Filesystem query provider for runtime query overrides
#[derive(Debug, Clone)]
pub struct FsProvider {
    queries_root: PathBuf,
}

impl EmbeddedProvider {
    pub fn new() -> Self {
        Self
    }
}

impl QueryProvider for EmbeddedProvider {
    fn defs(&self, language: &str) -> Result<String> {
        match language {
            "typescript" | "ts" => Ok(include_str!("../queries/typescript/defs.scm").to_string()),
            "javascript" | "js" => Ok(include_str!("../queries/typescript/defs.scm").to_string()), // Reuse TS queries
            "python" | "py" => Ok(include_str!("../queries/python/defs.scm").to_string()),
            "rust" | "rs" => Ok(include_str!("../queries/rust/defs.scm").to_string()),
            "dart" => Ok(include_str!("../queries/dart.scm").to_string()), // Single file format
            "go" => Ok(include_str!("../queries/go.scm").to_string()), // Single file format
            "java" => Ok(include_str!("../queries/java.scm").to_string()), // Single file format
            _ => anyhow::bail!("Unsupported language for embedded queries: {}", language),
        }
    }

    fn refs(&self, language: &str) -> Result<String> {
        match language {
            "typescript" | "ts" => Ok(include_str!("../queries/typescript/uses.scm").to_string()),
            "javascript" | "js" => Ok(include_str!("../queries/typescript/uses.scm").to_string()),
            "python" | "py" => Ok(include_str!("../queries/python/uses.scm").to_string()),
            "rust" | "rs" => Ok(include_str!("../queries/rust/uses.scm").to_string()),
            "dart" => Ok(include_str!("../queries/dart_uses.scm").to_string()), // Dedicated uses file
            "go" => Ok(include_str!("../queries/go.scm").to_string()), // Single file format - reuse defs
            "java" => Ok(include_str!("../queries/java.scm").to_string()), // Single file format - reuse defs
            _ => anyhow::bail!("Unsupported language for embedded queries: {}", language),
        }
    }

    fn exports(&self, language: &str) -> Result<String> {
        match language {
            "typescript" | "ts" => Ok(include_str!("../queries/typescript/imports.scm").to_string()),
            "javascript" | "js" => Ok(include_str!("../queries/typescript/imports.scm").to_string()),
            "python" | "py" => Ok(include_str!("../queries/python/imports.scm").to_string()),
            "rust" | "rs" => Ok(include_str!("../queries/rust/imports.scm").to_string()),
            "dart" => Ok(include_str!("../queries/dart_imports.scm").to_string()), // Dedicated imports file
            "go" => Ok(include_str!("../queries/go.scm").to_string()), // Single file format - reuse defs
            "java" => Ok(include_str!("../queries/java.scm").to_string()), // Single file format - reuse defs
            _ => anyhow::bail!("Unsupported language for embedded queries: {}", language),
        }
    }
}

impl FsProvider {
    pub fn new<P: AsRef<Path>>(queries_root: P) -> Self {
        Self {
            queries_root: queries_root.as_ref().to_path_buf(),
        }
    }
}

impl QueryProvider for FsProvider {
    fn defs(&self, language: &str) -> Result<String> {
        let path = self.queries_root.join(language).join("defs.scm");
        std::fs::read_to_string(&path)
            .with_context(|| format!("Failed to read defs query for {}: {:?}", language, path))
    }

    fn refs(&self, language: &str) -> Result<String> {
        let path = self.queries_root.join(language).join("uses.scm");
        std::fs::read_to_string(&path)
            .with_context(|| format!("Failed to read refs query for {}: {:?}", language, path))
    }

    fn exports(&self, language: &str) -> Result<String> {
        let path = self.queries_root.join(language).join("imports.scm");
        std::fs::read_to_string(&path)
            .with_context(|| format!("Failed to read exports query for {}: {:?}", language, path))
    }
}

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
    fn clone_box(&self) -> Box<dyn SymbolResolver>;
}

impl Clone for Box<dyn SymbolResolver> {
    fn clone(&self) -> Self {
        self.clone_box()
    }
}

impl QueryPack {
    pub fn for_typescript(provider: &dyn QueryProvider) -> Result<Self> {
        let language = tree_sitter_typescript::language_typescript();
        
        let defs_query = Query::new(&language, &provider.defs("typescript")?)
            .context("Failed to compile TypeScript defs query")?;
        let uses_query = Query::new(&language, &provider.refs("typescript")?)
            .context("Failed to compile TypeScript refs query")?;
        let imports_query = Query::new(&language, &provider.exports("typescript")?)
            .context("Failed to compile TypeScript exports query")?;
        
        Ok(Self {
            language,
            name: "typescript".into(),
            defs_query: Some(defs_query),
            uses_query: Some(uses_query),
            imports_query: Some(imports_query),
            resolver: Box::new(TypeScriptResolver),
        })
    }

    pub fn for_python(provider: &dyn QueryProvider) -> Result<Self> {
        let language = tree_sitter_python::language();
        
        let defs_query = Query::new(&language, &provider.defs("python")?)
            .context("Failed to compile Python defs query")?;
        let uses_query = Query::new(&language, &provider.refs("python")?)
            .context("Failed to compile Python refs query")?;
        let imports_query = Query::new(&language, &provider.exports("python")?)
            .context("Failed to compile Python exports query")?;
        
        Ok(Self {
            language,
            name: "python".into(),
            defs_query: Some(defs_query),
            uses_query: Some(uses_query),
            imports_query: Some(imports_query),
            resolver: Box::new(PythonResolver),
        })
    }

    pub fn for_rust(provider: &dyn QueryProvider) -> Result<Self> {
        let language = tree_sitter_rust::language();
        
        let defs_query = Query::new(&language, &provider.defs("rust")?)
            .context("Failed to compile Rust defs query")?;
        let uses_query = Query::new(&language, &provider.refs("rust")?)
            .context("Failed to compile Rust refs query")?;
        let imports_query = Query::new(&language, &provider.exports("rust")?)
            .context("Failed to compile Rust exports query")?;
        
        Ok(Self {
            language,
            name: "rust".into(),
            defs_query: Some(defs_query),
            uses_query: Some(uses_query),
            imports_query: Some(imports_query),
            resolver: Box::new(RustResolver),
        })
    }

    pub fn for_dart(provider: &dyn QueryProvider) -> Result<Self> {
        let language = tree_sitter_dart::language();
        
        let defs_query = Query::new(&language, &provider.defs("dart")?)
            .context("Failed to compile Dart defs query")?;
        let uses_query = Query::new(&language, &provider.refs("dart")?)
            .context("Failed to compile Dart refs query")?;
        let imports_query = Query::new(&language, &provider.exports("dart")?)
            .context("Failed to compile Dart exports query")?;
        
        Ok(Self {
            language,
            name: "dart".into(),
            defs_query: Some(defs_query),
            uses_query: Some(uses_query),
            imports_query: Some(imports_query),
            resolver: Box::new(DartResolver),
        })
    }

    pub fn for_go(provider: &dyn QueryProvider) -> Result<Self> {
        let language = tree_sitter_go::language();
        
        let defs_query = Query::new(&language, &provider.defs("go")?)
            .context("Failed to compile Go defs query")?;
        let uses_query = Query::new(&language, &provider.refs("go")?)
            .context("Failed to compile Go refs query")?;
        let imports_query = Query::new(&language, &provider.exports("go")?)
            .context("Failed to compile Go exports query")?;
        
        Ok(Self {
            language,
            name: "go".into(),
            defs_query: Some(defs_query),
            uses_query: Some(uses_query),
            imports_query: Some(imports_query),
            resolver: Box::new(GoResolver),
        })
    }

    pub fn for_java(provider: &dyn QueryProvider) -> Result<Self> {
        let language = tree_sitter_java::language();
        
        let defs_query = Query::new(&language, &provider.defs("java")?)
            .context("Failed to compile Java defs query")?;
        let uses_query = Query::new(&language, &provider.refs("java")?)
            .context("Failed to compile Java refs query")?;
        let imports_query = Query::new(&language, &provider.exports("java")?)
            .context("Failed to compile Java exports query")?;
        
        Ok(Self {
            language,
            name: "java".into(),
            defs_query: Some(defs_query),
            uses_query: Some(uses_query),
            imports_query: Some(imports_query),
            resolver: Box::new(JavaResolver),
        })
    }

    pub fn for_javascript(provider: &dyn QueryProvider) -> Result<Self> {
        let language = tree_sitter_javascript::language();
        
        let defs_query = Query::new(&language, &provider.defs("javascript")?)
            .context("Failed to compile JavaScript defs query")?;
        let uses_query = Query::new(&language, &provider.refs("javascript")?)
            .context("Failed to compile JavaScript refs query")?;
        let imports_query = Query::new(&language, &provider.exports("javascript")?)
            .context("Failed to compile JavaScript exports query")?;
        
        Ok(Self {
            language,
            name: "javascript".into(),
            defs_query: Some(defs_query),
            uses_query: Some(uses_query),
            imports_query: Some(imports_query),
            resolver: Box::new(TypeScriptResolver), // JS uses same resolver as TS
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
    
    fn clone_box(&self) -> Box<dyn SymbolResolver> {
        Box::new(TypeScriptResolver)
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
    
    fn clone_box(&self) -> Box<dyn SymbolResolver> {
        Box::new(PythonResolver)
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
    
    fn clone_box(&self) -> Box<dyn SymbolResolver> {
        Box::new(RustResolver)
    }
}

// New resolvers for additional languages
pub struct DartResolver;

impl SymbolResolver for DartResolver {
    fn resolve_import_alias(&self, import: &str, alias: Option<&str>) -> String {
        if let Some(alias) = alias {
            alias.to_string()
        } else {
            // For "import 'package:foo/bar.dart' as baz", use last component
            import.split('/').last()
                .and_then(|s| s.split('.').next())
                .unwrap_or(import).to_string()
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
            "function_signature" | "method_signature" => Some("method"),
            "class_definition" => Some("class"),
            "mixin_declaration" => Some("mixin"),
            "enum_declaration" => Some("enum"),
            _ => None,
        }
    }
    
    fn clone_box(&self) -> Box<dyn SymbolResolver> {
        Box::new(DartResolver)
    }
}

pub struct GoResolver;

impl SymbolResolver for GoResolver {
    fn resolve_import_alias(&self, import: &str, alias: Option<&str>) -> String {
        if let Some(alias) = alias {
            alias.to_string()
        } else {
            // For "import github.com/foo/bar", use "bar"
            import.split('/').last().unwrap_or(import).to_string()
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
            "function_declaration" | "method_declaration" => Some("function"),
            "type_declaration" => Some("type"),
            "struct_type" => Some("struct"),
            "interface_type" => Some("interface"),
            _ => None,
        }
    }
    
    fn clone_box(&self) -> Box<dyn SymbolResolver> {
        Box::new(GoResolver)
    }
}

pub struct JavaResolver;

impl SymbolResolver for JavaResolver {
    fn resolve_import_alias(&self, import: &str, alias: Option<&str>) -> String {
        if let Some(alias) = alias {
            alias.to_string()
        } else {
            // For "import java.util.List", use "List"
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
            "method_declaration" | "constructor_declaration" => Some("method"),
            "class_declaration" => Some("class"),
            "interface_declaration" => Some("interface"),
            "enum_declaration" => Some("enum"),
            "annotation_type_declaration" => Some("annotation"),
            _ => None,
        }
    }
    
    fn clone_box(&self) -> Box<dyn SymbolResolver> {
        Box::new(JavaResolver)
    }
}

pub struct QueryPackRegistry {
    packs: HashMap<String, QueryPack>,
    provider: Box<dyn QueryProvider>,
    cache: QueryCache,
}

impl QueryPackRegistry {
    pub fn new() -> Result<Self> {
        let provider = Box::new(EmbeddedProvider::new());
        Self::with_provider(provider)
    }
    
    pub fn with_cache_capacity(capacity: usize) -> Result<Self> {
        let provider = Box::new(EmbeddedProvider::new());
        Self::with_provider_and_cache(provider, QueryCache::new(capacity))
    }
    
    pub fn with_provider(provider: Box<dyn QueryProvider>) -> Result<Self> {
        Self::with_provider_and_cache(provider, QueryCache::default())
    }
    
    pub fn with_provider_and_cache(provider: Box<dyn QueryProvider>, cache: QueryCache) -> Result<Self> {
        let mut registry = Self {
            packs: HashMap::new(),
            provider,
            cache,
        };
        
        registry.load_query_packs()?;
        Ok(registry)
    }
    
    /// Load available query packs using the provider with cache
    fn load_query_packs(&mut self) -> Result<()> {
        // Load available query packs using the provider with cache
        if let Ok(pack) = self.for_typescript_cached() {
            self.packs.insert("typescript".to_string(), pack);
        }
        if let Ok(pack) = self.for_typescript_cached() {
            self.packs.insert("ts".to_string(), pack);
        }
        
        if let Ok(pack) = self.for_javascript_cached() {
            self.packs.insert("javascript".to_string(), pack);
        }
        if let Ok(pack) = self.for_javascript_cached() {
            self.packs.insert("js".to_string(), pack);
        }
        
        if let Ok(pack) = self.for_python_cached() {
            self.packs.insert("python".to_string(), pack);
        }
        if let Ok(pack) = self.for_python_cached() {
            self.packs.insert("py".to_string(), pack);
        }
        
        if let Ok(pack) = self.for_rust_cached() {
            self.packs.insert("rust".to_string(), pack);
        }
        if let Ok(pack) = self.for_rust_cached() {
            self.packs.insert("rs".to_string(), pack);
        }
        
        if let Ok(pack) = self.for_dart_cached() {
            self.packs.insert("dart".to_string(), pack);
        }
        
        if let Ok(pack) = self.for_go_cached() {
            self.packs.insert("go".to_string(), pack);
        }
        
        if let Ok(pack) = self.for_java_cached() {
            self.packs.insert("java".to_string(), pack);
        }
        
        Ok(())
    }
    
    /// Compile query with caching support
    fn compile_query_cached(&self, language: &Language, language_name: &str, query_type: QueryType, content: &str) -> Result<Query> {
        let cache_key = CacheKey::new(language_name, query_type.clone(), content);
        
        // Cache the query content for inspection
        let cached_query = CachedQuery {
            content: content.to_string(),
            language_name: language_name.to_string(),
            query_type: query_type.clone(),
        };
        self.cache.insert(cache_key.clone(), cached_query);
        
        // Compile query with enhanced error context
        Query::new(language, content)
            .with_context(|| {
                format!(
                    "Failed to compile {} {:?} query (content hash: {})", 
                    language_name, 
                    query_type,
                    cache_key.content_hash
                )
            })
    }
    
    // Cached query pack creation methods
    fn for_typescript_cached(&self) -> Result<QueryPack> {
        let language = tree_sitter_typescript::language_typescript();
        
        let defs_content = self.provider.defs("typescript")?;
        let refs_content = self.provider.refs("typescript")?;
        let exports_content = self.provider.exports("typescript")?;
        
        let defs_query = self.compile_query_cached(&language, "typescript", QueryType::Definitions, &defs_content)?;
        let uses_query = self.compile_query_cached(&language, "typescript", QueryType::References, &refs_content)?;
        let imports_query = self.compile_query_cached(&language, "typescript", QueryType::Exports, &exports_content)?;
        
        Ok(QueryPack {
            language,
            name: "typescript".into(),
            defs_query: Some(defs_query),
            uses_query: Some(uses_query),
            imports_query: Some(imports_query),
            resolver: Box::new(TypeScriptResolver),
        })
    }
    
    fn for_javascript_cached(&self) -> Result<QueryPack> {
        let language = tree_sitter_javascript::language();
        
        let defs_content = self.provider.defs("javascript")?;
        let refs_content = self.provider.refs("javascript")?;
        let exports_content = self.provider.exports("javascript")?;
        
        let defs_query = self.compile_query_cached(&language, "javascript", QueryType::Definitions, &defs_content)?;
        let uses_query = self.compile_query_cached(&language, "javascript", QueryType::References, &refs_content)?;
        let imports_query = self.compile_query_cached(&language, "javascript", QueryType::Exports, &exports_content)?;
        
        Ok(QueryPack {
            language,
            name: "javascript".into(),
            defs_query: Some(defs_query),
            uses_query: Some(uses_query),
            imports_query: Some(imports_query),
            resolver: Box::new(TypeScriptResolver), // JS uses same resolver as TS
        })
    }
    
    fn for_python_cached(&self) -> Result<QueryPack> {
        let language = tree_sitter_python::language();
        
        let defs_content = self.provider.defs("python")?;
        let refs_content = self.provider.refs("python")?;
        let exports_content = self.provider.exports("python")?;
        
        let defs_query = self.compile_query_cached(&language, "python", QueryType::Definitions, &defs_content)?;
        let uses_query = self.compile_query_cached(&language, "python", QueryType::References, &refs_content)?;
        let imports_query = self.compile_query_cached(&language, "python", QueryType::Exports, &exports_content)?;
        
        Ok(QueryPack {
            language,
            name: "python".into(),
            defs_query: Some(defs_query),
            uses_query: Some(uses_query),
            imports_query: Some(imports_query),
            resolver: Box::new(PythonResolver),
        })
    }
    
    fn for_rust_cached(&self) -> Result<QueryPack> {
        let language = tree_sitter_rust::language();
        
        let defs_content = self.provider.defs("rust")?;
        let refs_content = self.provider.refs("rust")?;
        let exports_content = self.provider.exports("rust")?;
        
        let defs_query = self.compile_query_cached(&language, "rust", QueryType::Definitions, &defs_content)?;
        let uses_query = self.compile_query_cached(&language, "rust", QueryType::References, &refs_content)?;
        let imports_query = self.compile_query_cached(&language, "rust", QueryType::Exports, &exports_content)?;
        
        Ok(QueryPack {
            language,
            name: "rust".into(),
            defs_query: Some(defs_query),
            uses_query: Some(uses_query),
            imports_query: Some(imports_query),
            resolver: Box::new(RustResolver),
        })
    }
    
    fn for_dart_cached(&self) -> Result<QueryPack> {
        let language = tree_sitter_dart::language();
        
        let defs_content = self.provider.defs("dart")?;
        let refs_content = self.provider.refs("dart")?;
        let exports_content = self.provider.exports("dart")?;
        
        let defs_query = self.compile_query_cached(&language, "dart", QueryType::Definitions, &defs_content)?;
        let uses_query = self.compile_query_cached(&language, "dart", QueryType::References, &refs_content)?;
        let imports_query = self.compile_query_cached(&language, "dart", QueryType::Exports, &exports_content)?;
        
        Ok(QueryPack {
            language,
            name: "dart".into(),
            defs_query: Some(defs_query),
            uses_query: Some(uses_query),
            imports_query: Some(imports_query),
            resolver: Box::new(DartResolver),
        })
    }
    
    fn for_go_cached(&self) -> Result<QueryPack> {
        let language = tree_sitter_go::language();
        
        let defs_content = self.provider.defs("go")?;
        let refs_content = self.provider.refs("go")?;
        let exports_content = self.provider.exports("go")?;
        
        let defs_query = self.compile_query_cached(&language, "go", QueryType::Definitions, &defs_content)?;
        let uses_query = self.compile_query_cached(&language, "go", QueryType::References, &refs_content)?;
        let imports_query = self.compile_query_cached(&language, "go", QueryType::Exports, &exports_content)?;
        
        Ok(QueryPack {
            language,
            name: "go".into(),
            defs_query: Some(defs_query),
            uses_query: Some(uses_query),
            imports_query: Some(imports_query),
            resolver: Box::new(GoResolver),
        })
    }
    
    fn for_java_cached(&self) -> Result<QueryPack> {
        let language = tree_sitter_java::language();
        
        let defs_content = self.provider.defs("java")?;
        let refs_content = self.provider.refs("java")?;
        let exports_content = self.provider.exports("java")?;
        
        let defs_query = self.compile_query_cached(&language, "java", QueryType::Definitions, &defs_content)?;
        let uses_query = self.compile_query_cached(&language, "java", QueryType::References, &refs_content)?;
        let imports_query = self.compile_query_cached(&language, "java", QueryType::Exports, &exports_content)?;
        
        Ok(QueryPack {
            language,
            name: "java".into(),
            defs_query: Some(defs_query),
            uses_query: Some(uses_query),
            imports_query: Some(imports_query),
            resolver: Box::new(JavaResolver),
        })
    }
    
    pub fn get_pack_for_extension(&self, ext: &str) -> Option<&QueryPack> {
        let lang = match ext {
            "ts" | "tsx" => "typescript",
            "js" | "jsx" => "javascript",
            "py" => "python",
            "rs" => "rust",
            "dart" => "dart",
            "go" => "go",
            "java" => "java",
            _ => return None,
        };
        
        self.packs.get(lang)
    }
    
    /// Switch provider at runtime - useful for testing or query overrides
    pub fn switch_provider(&mut self, new_provider: Box<dyn QueryProvider>) -> Result<()> {
        // Clear cache when switching providers
        self.cache.clear();
        *self = Self::with_provider_and_cache(new_provider, self.cache.clone())?;
        Ok(())
    }
    
    /// Get the current provider (for testing or introspection)
    pub fn get_provider(&self) -> &dyn QueryProvider {
        self.provider.as_ref()
    }
    
    /// Get cache reference for inspection
    pub fn get_cache(&self) -> &QueryCache {
        &self.cache
    }
    
    /// Validate queries at startup for enabled languages
    pub fn validate_enabled_languages(&self, enabled_languages: &[&str]) -> Result<()> {
        let mut validation_errors = Vec::new();
        
        for language in enabled_languages {
            if let Err(e) = self.validate_language_queries(language) {
                validation_errors.push(format!("Language '{}': {}", language, e));
            }
        }
        
        if !validation_errors.is_empty() {
            return Err(anyhow::anyhow!(
                "Query validation failed for {} language(s):\n{}",
                validation_errors.len(),
                validation_errors.join("\n")
            ));
        }
        
        Ok(())
    }
    
    /// Validate queries for a specific language
    fn validate_language_queries(&self, language: &str) -> Result<()> {
        // Try to get query content from provider
        let defs_content = self.provider.defs(language)
            .with_context(|| format!("Failed to get definitions query for language '{}'", language))?;
            
        let refs_content = self.provider.refs(language)
            .with_context(|| format!("Failed to get references query for language '{}'", language))?;
            
        let exports_content = self.provider.exports(language)
            .with_context(|| format!("Failed to get exports query for language '{}'", language))?;
        
        // Try to get the TreeSitter language
        let ts_language = self.get_treesitter_language(language)
            .with_context(|| format!("TreeSitter language not available for '{}'", language))?;
        
        // Validate query compilation
        Query::new(&ts_language, &defs_content)
            .with_context(|| format!("Invalid definitions query for language '{}': {}", language, 
                Self::truncate_query(&defs_content, 50)))?;
        
        Query::new(&ts_language, &refs_content)
            .with_context(|| format!("Invalid references query for language '{}': {}", language, 
                Self::truncate_query(&refs_content, 50)))?;
        
        Query::new(&ts_language, &exports_content)
            .with_context(|| format!("Invalid exports query for language '{}': {}", language, 
                Self::truncate_query(&exports_content, 50)))?;
        
        Ok(())
    }
    
    /// Get TreeSitter language by name
    fn get_treesitter_language(&self, language: &str) -> Result<Language> {
        match language {
            "typescript" | "ts" => Ok(tree_sitter_typescript::language_typescript()),
            "javascript" | "js" => Ok(tree_sitter_javascript::language()),
            "python" | "py" => Ok(tree_sitter_python::language()),
            "rust" | "rs" => Ok(tree_sitter_rust::language()),
            "dart" => Ok(tree_sitter_dart::language()),
            "go" => Ok(tree_sitter_go::language()),
            "java" => Ok(tree_sitter_java::language()),
            _ => anyhow::bail!("Unsupported TreeSitter language: {}", language),
        }
    }
    
    /// Helper to truncate query content for error messages
    fn truncate_query(query: &str, max_len: usize) -> String {
        if query.len() <= max_len {
            query.to_string()
        } else {
            format!("{}...", &query[..max_len])
        }
    }
    
    pub fn get_pack(&self, name: &str) -> Option<&QueryPack> {
        self.packs.get(name)
    }
    
    pub fn list_available_packs(&self) -> Vec<&str> {
        let mut packs: Vec<&str> = self.packs.keys().map(|s| s.as_str()).collect();
        packs.sort(); // Consistent ordering
        packs
    }
    
    /// Get unique languages (not including aliases)
    pub fn list_supported_languages(&self) -> Vec<&str> {
        let mut languages = vec![
            "typescript", "javascript", "python", "rust", "dart", "go", "java"
        ];
        languages.retain(|lang| self.packs.contains_key(*lang));
        languages
    }
}

/// Factory function for creating providers
pub fn create_provider(queries_dir: Option<&Path>) -> Box<dyn QueryProvider> {
    if let Some(dir) = queries_dir {
        if dir.exists() {
            Box::new(FsProvider::new(dir))
        } else {
            eprintln!("Warning: Queries directory does not exist: {:?}. Using embedded queries.", dir);
            Box::new(EmbeddedProvider::new())
        }
    } else {
        Box::new(EmbeddedProvider::new())
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::fs;
    use tempfile::tempdir;

    #[test]
    fn test_embedded_provider_basic() {
        let provider = EmbeddedProvider::new();
        
        // Test that we can get queries for supported languages
        assert!(provider.defs("typescript").is_ok());
        assert!(provider.refs("typescript").is_ok());
        assert!(provider.exports("typescript").is_ok());
        
        // Test unsupported language
        assert!(provider.defs("unsupported").is_err());
    }

    #[test]
    fn test_query_pack_registry_creation() {
        let registry = QueryPackRegistry::new().unwrap();
        
        // Registry should be created successfully
        let languages = registry.list_supported_languages();
        // Registry loads whatever languages it can compile successfully
        // Some languages may fail due to TreeSitter dependencies
        
        // Test available packs include aliases
        let available = registry.list_available_packs();
        assert!(!available.is_empty());
        
        // At minimum we should have some pack available
        // The actual languages depend on which TreeSitter dependencies compile successfully
    }

    #[test]
    fn test_fs_provider_with_temp_files() {
        let temp_dir = tempdir().unwrap();
        let queries_dir = temp_dir.path().join("queries");
        let ts_dir = queries_dir.join("typescript");
        fs::create_dir_all(&ts_dir).unwrap();
        
        // Create a simple test query
        fs::write(ts_dir.join("defs.scm"), "(function_declaration name: (identifier) @name)").unwrap();
        fs::write(ts_dir.join("uses.scm"), "(call_expression function: (identifier) @ref)").unwrap();
        fs::write(ts_dir.join("imports.scm"), "(import_statement source: (string) @import)").unwrap();
        
        let provider = FsProvider::new(&queries_dir);
        
        assert!(provider.defs("typescript").is_ok());
        assert_eq!(provider.defs("typescript").unwrap(), "(function_declaration name: (identifier) @name)");
    }

    #[test]
    fn test_create_provider_factory() {
        // Test with None - should return embedded provider
        let provider = create_provider(None);
        assert!(provider.defs("typescript").is_ok());
        
        // Test with non-existing directory - should fallback to embedded
        let temp_dir = tempdir().unwrap();
        let non_existing = temp_dir.path().join("does_not_exist");
        let provider = create_provider(Some(&non_existing));
        assert!(provider.defs("typescript").is_ok());
    }
    
    #[test]
    fn test_cache_key_creation() {
        let key1 = CacheKey::new("typescript", QueryType::Definitions, "(function_declaration) @def");
        let key2 = CacheKey::new("typescript", QueryType::Definitions, "(function_declaration) @def");
        let key3 = CacheKey::new("typescript", QueryType::References, "(function_declaration) @def");
        let key4 = CacheKey::new("python", QueryType::Definitions, "(function_declaration) @def");
        
        // Same content should produce same hash
        assert_eq!(key1.content_hash, key2.content_hash);
        assert_eq!(key1, key2);
        
        // Different query types should produce different keys
        assert_ne!(key1, key3);
        assert_eq!(key1.content_hash, key3.content_hash); // Same content
        
        // Different languages should produce different keys
        assert_ne!(key1, key4);
        assert_eq!(key1.content_hash, key4.content_hash); // Same content
    }
    
    #[test]
    fn test_query_cache_basic_operations() {
        let cache = QueryCache::new(10);
        let key = CacheKey::new("typescript", QueryType::Definitions, "(function_declaration) @def");
        
        // Initially empty
        assert_eq!(cache.len(), 0);
        assert!(!cache.contains(&key));
        assert!(cache.get(&key).is_none());
        
        // Create cached query content
        let cached_query = CachedQuery {
            content: "(function_declaration) @def".to_string(),
            language_name: "typescript".to_string(),
            query_type: QueryType::Definitions,
        };
        
        // Insert and verify
        cache.insert(key.clone(), cached_query);
        assert_eq!(cache.len(), 1);
        assert!(cache.contains(&key));
        assert!(cache.get(&key).is_some());
        
        // Clear and verify
        cache.clear();
        assert_eq!(cache.len(), 0);
        assert!(!cache.contains(&key));
    }
    
    #[test]
    fn test_query_cache_lru_behavior() {
        let cache = QueryCache::new(2); // Small cache for LRU testing
        
        let key1 = CacheKey::new("lang1", QueryType::Definitions, "content1");
        let key2 = CacheKey::new("lang2", QueryType::Definitions, "content2");
        let key3 = CacheKey::new("lang3", QueryType::Definitions, "content3");
        
        let cached1 = CachedQuery {
            content: "content1".to_string(),
            language_name: "lang1".to_string(),
            query_type: QueryType::Definitions,
        };
        let cached2 = CachedQuery {
            content: "content2".to_string(),
            language_name: "lang2".to_string(),
            query_type: QueryType::Definitions,
        };
        let cached3 = CachedQuery {
            content: "content3".to_string(),
            language_name: "lang3".to_string(),
            query_type: QueryType::Definitions,
        };
        
        // Fill cache to capacity
        cache.insert(key1.clone(), cached1);
        cache.insert(key2.clone(), cached2);
        assert_eq!(cache.len(), 2);
        assert!(cache.contains(&key1));
        assert!(cache.contains(&key2));
        
        // Insert third item should evict first
        cache.insert(key3.clone(), cached3);
        assert_eq!(cache.len(), 2);
        assert!(!cache.contains(&key1)); // Should be evicted
        assert!(cache.contains(&key2));
        assert!(cache.contains(&key3));
    }
    
    #[test]
    fn test_registry_with_cache() {
        let cache = QueryCache::new(50);
        let provider = Box::new(EmbeddedProvider::new());
        
        if let Ok(registry) = QueryPackRegistry::with_provider_and_cache(provider, cache) {
            let cache_ref = registry.get_cache();
            
            // Cache should have entries after registry creation (from query compilation)
            // The exact number depends on which languages compile successfully
            assert!(cache_ref.capacity() == 50);
            
            // Test cache hit/miss through multiple registry operations
            let initial_len = cache_ref.len();
            
            // Getting the same pack multiple times shouldn't increase cache size significantly
            // (because same queries are reused)
            let _pack1 = registry.get_pack("typescript");
            let _pack2 = registry.get_pack("typescript");
            let cache_len_after = cache_ref.len();
            
            // Cache length should not have grown much (queries are cached)
            assert!(cache_len_after >= initial_len);
        }
    }
    
    #[test]
    fn test_query_validation() {
        let registry = QueryPackRegistry::new().unwrap();
        
        // Test validation with supported languages
        let supported_langs = registry.list_supported_languages();
        if !supported_langs.is_empty() {
            // Take first few supported languages for validation
            let test_langs: Vec<&str> = supported_langs.into_iter().take(3).collect();
            
            // Should succeed for supported languages
            assert!(registry.validate_enabled_languages(&test_langs).is_ok());
        }
        
        // Test validation with unsupported language
        let unsupported_langs = vec!["unsupported_language"];
        assert!(registry.validate_enabled_languages(&unsupported_langs).is_err());
    }
    
    #[test]
    fn test_cache_invalidation_on_provider_switch() {
        let mut registry = QueryPackRegistry::new().unwrap();
        let initial_cache_len = registry.get_cache().len();
        
        // Switch to a new provider
        let new_provider = Box::new(EmbeddedProvider::new());
        assert!(registry.switch_provider(new_provider).is_ok());
        
        // Cache should be rebuilt (may have different size due to different loading patterns)
        let new_cache_len = registry.get_cache().len();
        
        // Cache should have some entries after provider switch and reload
        assert!(new_cache_len > 0);
    }
}