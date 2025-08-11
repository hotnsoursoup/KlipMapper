use agentmap::query_pack::{
    EmbeddedProvider, FsProvider, QueryProvider, QueryPackRegistry, create_provider
};
use tempfile::tempdir;
use std::fs;
use std::path::Path;

#[test]
fn test_embedded_provider_defs() {
    let provider = EmbeddedProvider::new();
    
    // Test supported languages
    assert!(provider.defs("typescript").is_ok());
    assert!(provider.defs("ts").is_ok());
    assert!(provider.defs("javascript").is_ok());
    assert!(provider.defs("js").is_ok());
    assert!(provider.defs("python").is_ok());
    assert!(provider.defs("py").is_ok());
    assert!(provider.defs("rust").is_ok());
    assert!(provider.defs("rs").is_ok());
    assert!(provider.defs("dart").is_ok());
    assert!(provider.defs("go").is_ok());
    assert!(provider.defs("java").is_ok());
    
    // Test unsupported language
    assert!(provider.defs("unsupported").is_err());
    let err = provider.defs("unsupported").unwrap_err();
    assert!(err.to_string().contains("Unsupported language"));
}

#[test]
fn test_embedded_provider_refs() {
    let provider = EmbeddedProvider::new();
    
    // Test that refs queries are available
    assert!(provider.refs("typescript").is_ok());
    assert!(provider.refs("python").is_ok());
    assert!(provider.refs("rust").is_ok());
    
    // Test unsupported language
    assert!(provider.refs("unsupported").is_err());
}

#[test]
fn test_embedded_provider_exports() {
    let provider = EmbeddedProvider::new();
    
    // Test that exports queries are available
    assert!(provider.exports("typescript").is_ok());
    assert!(provider.exports("python").is_ok());
    assert!(provider.exports("rust").is_ok());
    
    // Test unsupported language
    assert!(provider.exports("unsupported").is_err());
}

#[test]
fn test_fs_provider() {
    let temp_dir = tempdir().unwrap();
    let queries_dir = temp_dir.path().join("queries");
    let ts_dir = queries_dir.join("typescript");
    fs::create_dir_all(&ts_dir).unwrap();
    
    // Create test query files
    let defs_content = "(function_declaration name: (identifier) @name)";
    let refs_content = "(call_expression function: (identifier) @ref)";
    let exports_content = "(export_statement declaration: (identifier) @export)";
    
    fs::write(ts_dir.join("defs.scm"), defs_content).unwrap();
    fs::write(ts_dir.join("uses.scm"), refs_content).unwrap();
    fs::write(ts_dir.join("imports.scm"), exports_content).unwrap();
    
    let provider = FsProvider::new(&queries_dir);
    
    // Test successful reads
    assert_eq!(provider.defs("typescript").unwrap(), defs_content);
    assert_eq!(provider.refs("typescript").unwrap(), refs_content);
    assert_eq!(provider.exports("typescript").unwrap(), exports_content);
    
    // Test missing language directory
    assert!(provider.defs("nonexistent").is_err());
    let err = provider.defs("nonexistent").unwrap_err();
    assert!(err.to_string().contains("Failed to read defs query"));
}

#[test]
fn test_fs_provider_missing_files() {
    let temp_dir = tempdir().unwrap();
    let queries_dir = temp_dir.path().join("queries");
    let ts_dir = queries_dir.join("typescript");
    fs::create_dir_all(&ts_dir).unwrap();
    
    // Create only defs.scm, missing uses.scm and imports.scm
    fs::write(ts_dir.join("defs.scm"), "test content").unwrap();
    
    let provider = FsProvider::new(&queries_dir);
    
    // defs should work
    assert!(provider.defs("typescript").is_ok());
    
    // refs and exports should fail with descriptive errors
    assert!(provider.refs("typescript").is_err());
    assert!(provider.exports("typescript").is_err());
    
    let refs_err = provider.refs("typescript").unwrap_err();
    assert!(refs_err.to_string().contains("Failed to read refs query"));
}

#[test]
fn test_query_pack_registry_embedded() {
    let registry = QueryPackRegistry::new().unwrap();
    
    // Test available languages
    let languages = registry.list_supported_languages();
    assert!(languages.contains(&"typescript"));
    assert!(languages.contains(&"python"));
    assert!(languages.contains(&"rust"));
    assert!(languages.contains(&"dart"));
    assert!(languages.contains(&"go"));
    assert!(languages.contains(&"java"));
    
    // Test available packs (includes aliases)
    let packs = registry.list_available_packs();
    assert!(packs.contains(&"typescript"));
    assert!(packs.contains(&"ts"));
    assert!(packs.contains(&"javascript"));
    assert!(packs.contains(&"js"));
    assert!(packs.contains(&"python"));
    assert!(packs.contains(&"py"));
    assert!(packs.contains(&"rust"));
    assert!(packs.contains(&"rs"));
}

#[test]
fn test_query_pack_registry_get_pack_for_extension() {
    let registry = QueryPackRegistry::new().unwrap();
    
    // Test extension mappings
    assert!(registry.get_pack_for_extension("ts").is_some());
    assert!(registry.get_pack_for_extension("tsx").is_some());
    assert!(registry.get_pack_for_extension("js").is_some());
    assert!(registry.get_pack_for_extension("jsx").is_some());
    assert!(registry.get_pack_for_extension("py").is_some());
    assert!(registry.get_pack_for_extension("rs").is_some());
    assert!(registry.get_pack_for_extension("dart").is_some());
    assert!(registry.get_pack_for_extension("go").is_some());
    assert!(registry.get_pack_for_extension("java").is_some());
    
    // Test unsupported extension
    assert!(registry.get_pack_for_extension("unsupported").is_none());
    
    // Test that TypeScript and JavaScript return different packs
    let ts_pack = registry.get_pack_for_extension("ts").unwrap();
    let js_pack = registry.get_pack_for_extension("js").unwrap();
    assert_eq!(ts_pack.name, "typescript");
    assert_eq!(js_pack.name, "javascript");
}

#[test]
fn test_query_pack_registry_get_pack() {
    let registry = QueryPackRegistry::new().unwrap();
    
    // Test getting packs by name
    assert!(registry.get_pack("typescript").is_some());
    assert!(registry.get_pack("ts").is_some());
    assert!(registry.get_pack("javascript").is_some());
    assert!(registry.get_pack("js").is_some());
    assert!(registry.get_pack("python").is_some());
    assert!(registry.get_pack("py").is_some());
    assert!(registry.get_pack("rust").is_some());
    assert!(registry.get_pack("rs").is_some());
    
    // Test nonexistent pack
    assert!(registry.get_pack("nonexistent").is_none());
}

#[test]
fn test_query_pack_registry_with_fs_provider() {
    let temp_dir = tempdir().unwrap();
    let queries_dir = temp_dir.path().join("queries");
    
    // Create test query structure
    let ts_dir = queries_dir.join("typescript");
    fs::create_dir_all(&ts_dir).unwrap();
    
    fs::write(ts_dir.join("defs.scm"), "(function_declaration name: (identifier) @name)").unwrap();
    fs::write(ts_dir.join("uses.scm"), "(call_expression function: (identifier) @ref)").unwrap();  
    fs::write(ts_dir.join("imports.scm"), "(export_statement declaration: (identifier) @export)").unwrap();
    
    let provider = Box::new(FsProvider::new(&queries_dir));
    let registry = QueryPackRegistry::with_provider(provider).unwrap();
    
    // Test that TypeScript pack was loaded successfully
    assert!(registry.get_pack("typescript").is_some());
    
    let ts_pack = registry.get_pack("typescript").unwrap();
    assert_eq!(ts_pack.name, "typescript");
    assert!(ts_pack.defs_query.is_some());
    assert!(ts_pack.uses_query.is_some());
    assert!(ts_pack.imports_query.is_some());
}

#[test]
fn test_query_pack_registry_switch_provider() {
    let mut registry = QueryPackRegistry::new().unwrap();
    
    // Initially using embedded provider
    assert!(matches!(registry.get_provider().defs("typescript"), Ok(_)));
    
    let temp_dir = tempdir().unwrap();
    let queries_dir = temp_dir.path().join("queries");
    let ts_dir = queries_dir.join("typescript");
    fs::create_dir_all(&ts_dir).unwrap();
    
    let custom_defs = "(custom_query) @test";
    fs::write(ts_dir.join("defs.scm"), custom_defs).unwrap();
    fs::write(ts_dir.join("uses.scm"), "(default_uses)").unwrap();
    fs::write(ts_dir.join("imports.scm"), "(default_imports)").unwrap();
    
    // Switch to filesystem provider
    let fs_provider = Box::new(FsProvider::new(&queries_dir));
    registry.switch_provider(fs_provider).unwrap();
    
    // Verify provider switched
    assert_eq!(registry.get_provider().defs("typescript").unwrap(), custom_defs);
    
    // Verify registry was rebuilt with new provider
    assert!(registry.get_pack("typescript").is_some());
}

#[test]
fn test_create_provider_factory() {
    // Test with None - should return embedded provider
    let provider = create_provider(None);
    assert!(provider.defs("typescript").is_ok());
    
    // Test with existing directory - should return fs provider
    let temp_dir = tempdir().unwrap();
    let queries_dir = temp_dir.path().join("queries");
    let ts_dir = queries_dir.join("typescript");
    fs::create_dir_all(&ts_dir).unwrap();
    
    fs::write(ts_dir.join("defs.scm"), "test content").unwrap();
    fs::write(ts_dir.join("uses.scm"), "test content").unwrap();
    fs::write(ts_dir.join("imports.scm"), "test content").unwrap();
    
    let provider = create_provider(Some(&queries_dir));
    assert_eq!(provider.defs("typescript").unwrap(), "test content");
    
    // Test with non-existing directory - should fallback to embedded provider
    let non_existing_dir = temp_dir.path().join("does_not_exist");
    let provider = create_provider(Some(&non_existing_dir));
    assert!(provider.defs("typescript").is_ok());
    // This should be embedded content, not "test content"
    assert_ne!(provider.defs("typescript").unwrap(), "test content");
}

#[test]
fn test_provider_trait_object_compatibility() {
    // Test that providers can be used through trait objects
    let embedded: Box<dyn QueryProvider> = Box::new(EmbeddedProvider::new());
    assert!(embedded.defs("typescript").is_ok());
    
    let temp_dir = tempdir().unwrap();
    let queries_dir = temp_dir.path().join("queries");
    let ts_dir = queries_dir.join("typescript");
    fs::create_dir_all(&ts_dir).unwrap();
    
    fs::write(ts_dir.join("defs.scm"), "fs content").unwrap();
    fs::write(ts_dir.join("uses.scm"), "fs content").unwrap();
    fs::write(ts_dir.join("imports.scm"), "fs content").unwrap();
    
    let filesystem: Box<dyn QueryProvider> = Box::new(FsProvider::new(&queries_dir));
    assert_eq!(filesystem.defs("typescript").unwrap(), "fs content");
}

#[test]
fn test_error_messages() {
    let provider = EmbeddedProvider::new();
    
    let err = provider.defs("invalid_language").unwrap_err();
    assert!(err.to_string().contains("Unsupported language for embedded queries: invalid_language"));
    
    let temp_dir = tempdir().unwrap();
    let queries_dir = temp_dir.path().join("queries");
    // Don't create the directory structure
    
    let fs_provider = FsProvider::new(&queries_dir);
    let err = fs_provider.defs("typescript").unwrap_err();
    assert!(err.to_string().contains("Failed to read defs query for typescript"));
}

#[test] 
fn test_language_expansion() {
    let registry = QueryPackRegistry::new().unwrap();
    let supported = registry.list_supported_languages();
    
    // Verify all 7 languages from task requirements are supported
    assert!(supported.contains(&"typescript"));
    assert!(supported.contains(&"javascript"));
    assert!(supported.contains(&"python"));
    assert!(supported.contains(&"rust"));
    assert!(supported.contains(&"dart"));
    assert!(supported.contains(&"go"));
    assert!(supported.contains(&"java"));
    
    // Should have exactly 7 unique languages (no duplicates from aliases)
    let unique_languages: std::collections::HashSet<_> = supported.into_iter().collect();
    assert_eq!(unique_languages.len(), 7);
}

#[test]
fn test_query_provider_abstraction_completeness() {
    // Verify all three query types are supported by the provider abstraction
    let provider = EmbeddedProvider::new();
    
    for language in &["typescript", "javascript", "python", "rust", "dart", "go", "java"] {
        assert!(provider.defs(language).is_ok(), "defs query missing for {}", language);
        assert!(provider.refs(language).is_ok(), "refs query missing for {}", language);
        assert!(provider.exports(language).is_ok(), "exports query missing for {}", language);
    }
}