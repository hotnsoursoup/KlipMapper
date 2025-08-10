use agentmap::config::AgentMapConfig;
use std::path::{Path, PathBuf};
use tempfile::TempDir;
use std::fs;

#[test]
fn test_default_config() {
    let config = AgentMapConfig::default();
    
    assert!(config.languages.is_some());
    assert!(config.include.is_some());
    assert!(config.exclude.is_some());
    
    let languages = config.languages.unwrap();
    assert!(languages.contains(&"dart".to_string()));
    assert!(languages.contains(&"py".to_string()));
    assert!(languages.contains(&"rs".to_string()));
}

#[test]
fn test_config_loading_from_file() {
    let temp_dir = TempDir::new().unwrap();
    let agentmap_dir = temp_dir.path().join(".agentmap");
    fs::create_dir_all(&agentmap_dir).unwrap();
    
    let config_content = r#"
languages: [dart, py]
include: ["lib/**/*.dart"]
exclude: ["**/*.g.dart"]
track:
  - Employee
  - User
"#;
    
    let config_path = agentmap_dir.join("config.yaml");
    fs::write(&config_path, config_content).unwrap();
    
    let config = AgentMapConfig::load_from_dir(temp_dir.path()).unwrap();
    
    assert_eq!(config.languages.unwrap(), vec!["dart", "py"]);
    assert_eq!(config.include.unwrap(), vec!["lib/**/*.dart"]);
    assert_eq!(config.exclude.unwrap(), vec!["**/*.g.dart"]);
    assert_eq!(config.track.unwrap(), vec!["Employee", "User"]);
}

#[test]
fn test_config_merges_with_defaults() {
    let temp_dir = TempDir::new().unwrap();
    let agentmap_dir = temp_dir.path().join(".agentmap");
    fs::create_dir_all(&agentmap_dir).unwrap();
    
    // Only specify languages, other fields should use defaults
    let config_content = r#"
languages: [dart]
"#;
    
    let config_path = agentmap_dir.join("config.yaml");
    fs::write(&config_path, config_content).unwrap();
    
    let config = AgentMapConfig::load_from_dir(temp_dir.path()).unwrap();
    
    assert_eq!(config.languages.unwrap(), vec!["dart"]);
    // Should have default includes/excludes
    assert!(config.include.is_some());
    assert!(config.exclude.is_some());
    assert!(config.preamble.is_some());
}

#[test]
fn test_config_no_file_uses_defaults() {
    let temp_dir = TempDir::new().unwrap();
    
    let config = AgentMapConfig::load_from_dir(temp_dir.path()).unwrap();
    
    // Should be equivalent to default config
    let default_config = AgentMapConfig::default();
    assert_eq!(config.languages, default_config.languages);
}

#[test]
fn test_language_enablement() {
    let mut config = AgentMapConfig::default();
    config.languages = Some(vec!["dart".to_string(), "py".to_string()]);
    
    assert!(config.is_language_enabled("dart"));
    assert!(config.is_language_enabled("py"));
    assert!(!config.is_language_enabled("rs"));
    assert!(!config.is_language_enabled("js"));
}

#[test]
fn test_path_exclusion() {
    let mut config = AgentMapConfig::default();
    config.exclude = Some(vec![
        "**/*.g.dart".to_string(),
        "**/build/**".to_string(),
        "**/node_modules/**".to_string(),
    ]);
    
    assert!(config.should_exclude_path(Path::new("lib/models/user.g.dart")));
    assert!(config.should_exclude_path(Path::new("build/outputs/main.dart")));
    assert!(config.should_exclude_path(Path::new("node_modules/react/index.js")));
    
    assert!(!config.should_exclude_path(Path::new("lib/models/user.dart")));
    assert!(!config.should_exclude_path(Path::new("src/main.rs")));
}

#[test]
fn test_capture_tag_mapping() {
    let mut config = AgentMapConfig::default();
    let mut tags = std::collections::HashMap::new();
    tags.insert("use.id".to_string(), "ref".to_string());
    tags.insert("def.class".to_string(), "class_definition".to_string());
    config.tags = Some(tags);
    
    assert_eq!(config.map_capture_to_tag("use.id"), "ref");
    assert_eq!(config.map_capture_to_tag("def.class"), "class_definition");
    assert_eq!(config.map_capture_to_tag("unknown"), "unknown"); // Unmapped should return as-is
}

#[test]
fn test_query_overrides() {
    let mut config = AgentMapConfig::default();
    let mut overrides = std::collections::HashMap::new();
    overrides.insert("dart.uses".to_string(), "./custom/dart_uses.scm".to_string());
    config.query_overrides = Some(overrides);
    
    assert_eq!(
        config.get_query_override("dart.uses"),
        Some(PathBuf::from("./custom/dart_uses.scm"))
    );
    assert_eq!(config.get_query_override("python.defs"), None);
}

#[test]
fn test_invalid_config_handling() {
    let temp_dir = TempDir::new().unwrap();
    let agentmap_dir = temp_dir.path().join(".agentmap");
    fs::create_dir_all(&agentmap_dir).unwrap();
    
    // Invalid YAML
    let config_content = r#"
languages: [dart
invalid yaml structure
"#;
    
    let config_path = agentmap_dir.join("config.yaml");
    fs::write(&config_path, config_content).unwrap();
    
    let result = AgentMapConfig::load_from_dir(temp_dir.path());
    assert!(result.is_err()); // Should handle gracefully
}

#[test]
fn test_preamble_configuration() {
    let mut config = AgentMapConfig::default();
    
    let preamble = config.preamble.as_ref().unwrap();
    assert_eq!(preamble.line_budget, Some(12));
    assert!(preamble.sections.as_ref().unwrap().contains(&"purpose".to_string()));
    assert!(preamble.sections.as_ref().unwrap().contains(&"imports".to_string()));
}

#[test]
fn test_auto_discovery_settings() {
    let config = AgentMapConfig::default();
    
    let auto_config = config.auto.as_ref().unwrap();
    assert_eq!(auto_config.enable, Some(true));
    assert_eq!(auto_config.min_refs, Some(3));
    assert_eq!(auto_config.min_files, Some(2));
}