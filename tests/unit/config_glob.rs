use agentmap::config::{AgentMapConfig, ConfigError};
use std::path::Path;
use tempfile::tempdir;
use std::fs;

#[test]
fn test_globset_build_success() {
    let mut config = AgentMapConfig::default();
    config.include = Some(vec![
        "**/*.dart".to_string(),
        "**/*.ts".to_string(),
        "src/**/*.py".to_string(),
    ]);
    config.exclude = Some(vec![
        "**/*.g.dart".to_string(),
        "**/build/**".to_string(),
        "**/node_modules/**".to_string(),
    ]);
    
    // Build globset should succeed with valid patterns
    assert!(config.build_globset().is_ok());
    assert!(config.glob_matcher.is_some());
}

#[test]
fn test_globset_build_invalid_pattern() {
    let mut config = AgentMapConfig::default();
    config.include = Some(vec![
        "[invalid_bracket".to_string(), // Invalid bracket pattern
    ]);
    
    // Build globset should fail with invalid patterns
    let result = config.build_globset();
    assert!(result.is_err());
    assert!(matches!(result.unwrap_err(), ConfigError::GlobSetBuildError { .. }));
}

#[test]
fn test_globset_pattern_validation() {
    let config = AgentMapConfig::default();
    
    // Valid patterns should pass
    assert!(config.validate_glob_pattern("**/*.dart").is_ok());
    assert!(config.validate_glob_pattern("src/**/*.ts").is_ok());
    assert!(config.validate_glob_pattern("*.{js,ts}").is_ok());
    assert!(config.validate_glob_pattern("[abc]*.rs").is_ok());
    
    // Invalid patterns should fail
    assert!(config.validate_glob_pattern("").is_err());
    assert!(config.validate_glob_pattern("[invalid_bracket").is_err());
}

#[test]
fn test_globset_path_matching_include_only() {
    let mut config = AgentMapConfig::default();
    config.include = Some(vec![
        "**/*.dart".to_string(),
        "**/*.ts".to_string(),
    ]);
    config.build_globset().unwrap();
    
    // Paths matching include patterns should not be excluded
    assert!(!config.should_exclude_path(Path::new("lib/main.dart")));
    assert!(!config.should_exclude_path(Path::new("src/components/header.ts")));
    
    // Paths not matching include patterns should be excluded
    assert!(config.should_exclude_path(Path::new("lib/main.py")));
    assert!(config.should_exclude_path(Path::new("src/config.rs")));
}

#[test]
fn test_globset_path_matching_exclude_only() {
    let mut config = AgentMapConfig::default();
    config.exclude = Some(vec![
        "**/*.g.dart".to_string(),
        "**/build/**".to_string(),
        "**/node_modules/**".to_string(),
    ]);
    config.build_globset().unwrap();
    
    // Paths matching exclude patterns should be excluded
    assert!(config.should_exclude_path(Path::new("lib/models/user.g.dart")));
    assert!(config.should_exclude_path(Path::new("build/outputs/main.dart")));
    assert!(config.should_exclude_path(Path::new("node_modules/react/index.js")));
    
    // Paths not matching exclude patterns should not be excluded
    assert!(!config.should_exclude_path(Path::new("lib/models/user.dart")));
    assert!(!config.should_exclude_path(Path::new("src/main.ts")));
    assert!(!config.should_exclude_path(Path::new("lib/widgets/button.dart")));
}

#[test]
fn test_globset_path_matching_include_and_exclude() {
    let mut config = AgentMapConfig::default();
    config.include = Some(vec![
        "**/*.dart".to_string(),
        "**/*.ts".to_string(),
    ]);
    config.exclude = Some(vec![
        "**/*.g.dart".to_string(),
        "**/test/**".to_string(),
    ]);
    config.build_globset().unwrap();
    
    // Regular Dart/TS files should not be excluded
    assert!(!config.should_exclude_path(Path::new("lib/main.dart")));
    assert!(!config.should_exclude_path(Path::new("src/app.ts")));
    
    // Generated files should be excluded (exclude overrides include)
    assert!(config.should_exclude_path(Path::new("lib/models/user.g.dart")));
    
    // Test files should be excluded
    assert!(config.should_exclude_path(Path::new("test/widget_test.dart")));
    
    // Non-matching file types should be excluded (not in include list)
    assert!(config.should_exclude_path(Path::new("src/config.py")));
    assert!(config.should_exclude_path(Path::new("lib/main.rs")));
}

#[test]
fn test_globset_complex_patterns() {
    let mut config = AgentMapConfig::default();
    config.include = Some(vec![
        "src/**/*.{ts,js}".to_string(),   // Brace expansion
        "lib/**/[!_]*.dart".to_string(),  // Character class negation
        "docs/*.md".to_string(),          // Simple wildcard
    ]);
    config.exclude = Some(vec![
        "**/.*".to_string(),              // Hidden files
        "**/*test*".to_string(),          // Test files
    ]);
    config.build_globset().unwrap();
    
    // TypeScript/JavaScript files in src
    assert!(!config.should_exclude_path(Path::new("src/components/header.ts")));
    assert!(!config.should_exclude_path(Path::new("src/utils/helper.js")));
    
    // Dart files not starting with underscore
    assert!(!config.should_exclude_path(Path::new("lib/widgets/button.dart")));
    assert!(config.should_exclude_path(Path::new("lib/widgets/_private.dart"))); // Starts with underscore
    
    // Markdown files in docs
    assert!(!config.should_exclude_path(Path::new("docs/README.md")));
    
    // Hidden files should be excluded
    assert!(config.should_exclude_path(Path::new("src/.env")));
    assert!(config.should_exclude_path(Path::new("lib/.gitkeep")));
    
    // Test files should be excluded
    assert!(config.should_exclude_path(Path::new("src/components/header.test.ts")));
    assert!(config.should_exclude_path(Path::new("lib/widgets/button_test.dart")));
}

#[test]
fn test_globset_fallback_to_simple_matching() {
    let mut config = AgentMapConfig::default();
    config.exclude = Some(vec![
        "**/*.g.dart".to_string(),
        "**/build/**".to_string(),
    ]);
    
    // Don't build globset - should fallback to simple matching
    assert!(config.glob_matcher.is_none());
    
    // Simple patterns should still work via fallback
    assert!(config.should_exclude_path(Path::new("lib/models/user.g.dart")));
    assert!(config.should_exclude_path(Path::new("build/outputs/main.dart")));
    assert!(!config.should_exclude_path(Path::new("lib/models/user.dart")));
}

#[test]
fn test_globset_performance_comparison() {
    let mut config = AgentMapConfig::default();
    config.include = Some(vec![
        "**/*.dart".to_string(),
        "**/*.ts".to_string(),
        "**/*.js".to_string(),
        "**/*.py".to_string(),
        "**/*.rs".to_string(),
    ]);
    config.exclude = Some(vec![
        "**/*.g.dart".to_string(),
        "**/build/**".to_string(),
        "**/node_modules/**".to_string(),
        "**/target/**".to_string(),
        "**/.git/**".to_string(),
        "**/test/**".to_string(),
    ]);
    
    // Build globset
    config.build_globset().unwrap();
    
    let test_paths = vec![
        "lib/main.dart",
        "src/components/header.ts", 
        "lib/models/user.g.dart",
        "build/outputs/app.js",
        "node_modules/react/index.js",
        "src/utils/helper.py",
        "target/debug/main.rs",
        "test/widget_test.dart",
        ".git/config",
        "docs/README.md",
    ];
    
    // Both methods should produce the same results
    for path_str in &test_paths {
        let path = Path::new(path_str);
        let globset_result = {
            let path_str = path.to_string_lossy();
            config.glob_matcher.as_ref().unwrap().should_exclude(&path_str)
        };
        let simple_result = config.should_exclude_path_simple(path);
        
        // Results should be consistent (though may differ for complex patterns)
        // For basic patterns, they should match
        if !path_str.contains('[') && !path_str.contains('{') {
            assert_eq!(globset_result, simple_result, 
                "Path: {} - globset: {}, simple: {}", path_str, globset_result, simple_result);
        }
    }
}

#[test]
fn test_globset_with_configuration_loading() {
    let temp_dir = tempdir().unwrap();
    let agentmap_dir = temp_dir.path().join(".agentmap");
    fs::create_dir_all(&agentmap_dir).unwrap();
    
    let config_content = r#"
languages: [dart, ts, py]
include:
  - "**/*.dart"
  - "**/*.ts"
  - "**/*.py"
exclude:
  - "**/*.g.dart"
  - "**/build/**"
  - "**/test/**"
"#;
    
    let config_file = agentmap_dir.join("config.yaml");
    fs::write(&config_file, config_content).unwrap();
    
    // Load configuration - should automatically build globset
    let config = AgentMapConfig::load_from_dir(temp_dir.path()).unwrap();
    
    // Globset should be built
    assert!(config.glob_matcher.is_some());
    
    // Pattern matching should work
    assert!(!config.should_exclude_path(Path::new("lib/main.dart")));
    assert!(config.should_exclude_path(Path::new("lib/models/user.g.dart")));
    assert!(config.should_exclude_path(Path::new("build/outputs/main.dart")));
    assert!(!config.should_exclude_path(Path::new("src/utils/helper.py")));
}

#[test]
fn test_glob_matcher_methods() {
    let mut config = AgentMapConfig::default();
    config.include = Some(vec![
        "**/*.dart".to_string(),
        "**/*.ts".to_string(),
    ]);
    config.exclude = Some(vec![
        "**/*.g.dart".to_string(),
        "**/test/**".to_string(),
    ]);
    config.build_globset().unwrap();
    
    let matcher = config.glob_matcher.as_ref().unwrap();
    
    // Test matches_include
    assert!(matcher.matches_include("lib/main.dart"));
    assert!(matcher.matches_include("src/app.ts"));
    assert!(!matcher.matches_include("src/config.py"));
    
    // Test matches_exclude
    assert!(matcher.matches_exclude("lib/models/user.g.dart"));
    assert!(matcher.matches_exclude("test/widget_test.dart"));
    assert!(!matcher.matches_exclude("lib/main.dart"));
    
    // Test should_exclude logic
    assert!(!matcher.should_exclude("lib/main.dart"));        // Included, not excluded
    assert!(matcher.should_exclude("lib/models/user.g.dart")); // Included but excluded
    assert!(matcher.should_exclude("test/widget_test.dart"));  // Included but excluded
    assert!(matcher.should_exclude("src/config.py"));         // Not included
}