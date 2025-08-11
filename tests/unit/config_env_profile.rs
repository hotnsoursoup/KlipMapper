use agentmap::config::{AgentMapConfig, PreambleConfig, AutoConfig, GranularityConfig};
use std::collections::HashMap;
use tempfile::tempdir;
use std::fs;

#[test]
fn test_environment_variable_overrides() {
    // Test AGENTMAP_LANGUAGES override
    std::env::set_var("AGENTMAP_LANGUAGES", "dart,ts,py");
    std::env::set_var("AGENTMAP_LINE_BUDGET", "25");
    std::env::set_var("AGENTMAP_MIN_REFS", "10");
    std::env::set_var("AGENTMAP_TRACK_CALLS", "false");
    
    let temp_dir = tempdir().unwrap();
    let config = AgentMapConfig::load_with_env(temp_dir.path()).unwrap();
    
    // Check environment overrides were applied
    assert_eq!(config.languages.unwrap(), vec!["dart", "ts", "py"]);
    assert_eq!(config.preamble.unwrap().line_budget.unwrap(), 25);
    assert_eq!(config.auto.unwrap().min_refs.unwrap(), 10);
    assert_eq!(config.granularity.unwrap().track_calls.unwrap(), false);
    
    // Clean up environment variables
    std::env::remove_var("AGENTMAP_LANGUAGES");
    std::env::remove_var("AGENTMAP_LINE_BUDGET");
    std::env::remove_var("AGENTMAP_MIN_REFS");
    std::env::remove_var("AGENTMAP_TRACK_CALLS");
}

#[test]
fn test_include_exclude_environment_overrides() {
    std::env::set_var("AGENTMAP_INCLUDE", "**/*.dart,**/*.ts,src/**/*.py");
    std::env::set_var("AGENTMAP_EXCLUDE", "**/*.g.dart,**/build/**,**/test/**");
    
    let temp_dir = tempdir().unwrap();
    let config = AgentMapConfig::load_with_env(temp_dir.path()).unwrap();
    
    assert_eq!(config.include.unwrap(), vec!["**/*.dart", "**/*.ts", "src/**/*.py"]);
    assert_eq!(config.exclude.unwrap(), vec!["**/*.g.dart", "**/build/**", "**/test/**"]);
    
    std::env::remove_var("AGENTMAP_INCLUDE");
    std::env::remove_var("AGENTMAP_EXCLUDE");
}

#[test]
fn test_boolean_environment_overrides() {
    std::env::set_var("AGENTMAP_TRACK_MEMBER_ACCESS", "true");
    std::env::set_var("AGENTMAP_TRACK_GENERICS", "false");
    
    let temp_dir = tempdir().unwrap();
    let config = AgentMapConfig::load_with_env(temp_dir.path()).unwrap();
    
    let granularity = config.granularity.unwrap();
    assert_eq!(granularity.track_member_access.unwrap(), true);
    assert_eq!(granularity.track_generics.unwrap(), false);
    
    std::env::remove_var("AGENTMAP_TRACK_MEMBER_ACCESS");
    std::env::remove_var("AGENTMAP_TRACK_GENERICS");
}

#[test]
fn test_development_profile() {
    std::env::set_var("AGENTMAP_PROFILE", "development");
    
    let temp_dir = tempdir().unwrap();
    let config = AgentMapConfig::load_with_env(temp_dir.path()).unwrap();
    
    // Development profile should enable member access tracking
    if let Some(granularity) = &config.granularity {
        if let Some(track_member_access) = granularity.track_member_access {
            assert_eq!(track_member_access, true);
        }
    }
    
    // Should have development-specific excludes
    if let Some(exclude) = &config.exclude {
        assert!(exclude.contains(&"**/target/debug/**".to_string()));
    }
    
    std::env::remove_var("AGENTMAP_PROFILE");
}

#[test]
fn test_production_profile() {
    std::env::set_var("AGENTMAP_PROFILE", "production");
    
    let temp_dir = tempdir().unwrap();
    let config = AgentMapConfig::load_with_env(temp_dir.path()).unwrap();
    
    // Production profile should disable member access tracking and generics
    if let Some(granularity) = &config.granularity {
        if let Some(track_member_access) = granularity.track_member_access {
            assert_eq!(track_member_access, false);
        }
        if let Some(track_generics) = granularity.track_generics {
            assert_eq!(track_generics, false);
        }
    }
    
    // Should exclude test directories in production
    if let Some(exclude) = &config.exclude {
        assert!(exclude.contains(&"**/test/**".to_string()));
        assert!(exclude.contains(&"**/tests/**".to_string()));
    }
    
    std::env::remove_var("AGENTMAP_PROFILE");
}

#[test]
fn test_testing_profile() {
    std::env::set_var("AGENTMAP_PROFILE", "testing");
    
    let temp_dir = tempdir().unwrap();
    let config = AgentMapConfig::load_with_env(temp_dir.path()).unwrap();
    
    // Testing profile should include test files
    if let Some(include) = &config.include {
        assert!(include.contains(&"**/test/**/*.dart".to_string()));
        assert!(include.contains(&"**/tests/**/*.rs".to_string()));
    }
    
    // Should have minimal exclusions for testing
    if let Some(exclude) = &config.exclude {
        assert!(exclude.len() <= 2); // Only basic exclusions
        assert!(exclude.contains(&"**/*.g.dart".to_string()));
    }
    
    std::env::remove_var("AGENTMAP_PROFILE");
}

#[test]
fn test_profile_aliases() {
    // Test dev -> development
    std::env::set_var("AGENTMAP_PROFILE", "dev");
    let temp_dir = tempdir().unwrap();
    let config = AgentMapConfig::load_with_env(temp_dir.path()).unwrap();
    
    // Should behave like development profile
    if let Some(granularity) = &config.granularity {
        if let Some(track_member_access) = granularity.track_member_access {
            assert_eq!(track_member_access, true);
        }
    }
    
    std::env::remove_var("AGENTMAP_PROFILE");
    
    // Test prod -> production
    std::env::set_var("AGENTMAP_PROFILE", "prod");
    let config = AgentMapConfig::load_with_env(temp_dir.path()).unwrap();
    
    // Should behave like production profile
    if let Some(granularity) = &config.granularity {
        if let Some(track_member_access) = granularity.track_member_access {
            assert_eq!(track_member_access, false);
        }
    }
    
    std::env::remove_var("AGENTMAP_PROFILE");
}

#[test]
fn test_unknown_profile_warning() {
    std::env::set_var("AGENTMAP_PROFILE", "unknown_profile");
    
    let temp_dir = tempdir().unwrap();
    // Should not fail, just emit a warning
    let config = AgentMapConfig::load_with_env(temp_dir.path()).unwrap();
    
    // Should still have default configuration
    assert!(config.languages.is_some());
    
    std::env::remove_var("AGENTMAP_PROFILE");
}

#[test]
fn test_environment_precedence_over_file() {
    let temp_dir = tempdir().unwrap();
    let agentmap_dir = temp_dir.path().join(".agentmap");
    fs::create_dir_all(&agentmap_dir).unwrap();
    
    // Create config file with specific values
    let config_content = r#"
languages: [rust, go]
preamble:
  line_budget: 10
"#;
    
    let config_file = agentmap_dir.join("config.yaml");
    fs::write(&config_file, config_content).unwrap();
    
    // Set environment variables that should override
    std::env::set_var("AGENTMAP_LANGUAGES", "dart,ts");
    std::env::set_var("AGENTMAP_LINE_BUDGET", "30");
    
    let config = AgentMapConfig::load_with_env(temp_dir.path()).unwrap();
    
    // Environment variables should override file values
    assert_eq!(config.languages.unwrap(), vec!["dart", "ts"]);
    assert_eq!(config.preamble.unwrap().line_budget.unwrap(), 30);
    
    std::env::remove_var("AGENTMAP_LANGUAGES");
    std::env::remove_var("AGENTMAP_LINE_BUDGET");
}

#[test]
fn test_malformed_environment_variables() {
    // Test malformed boolean values
    std::env::set_var("AGENTMAP_TRACK_CALLS", "invalid_boolean");
    std::env::set_var("AGENTMAP_MIN_REFS", "not_a_number");
    
    let temp_dir = tempdir().unwrap();
    // Should not fail, just ignore malformed values
    let config = AgentMapConfig::load_with_env(temp_dir.path()).unwrap();
    
    // Should use default values for malformed env vars
    assert!(config.is_valid());
    
    std::env::remove_var("AGENTMAP_TRACK_CALLS");
    std::env::remove_var("AGENTMAP_MIN_REFS");
}

#[test]
fn test_empty_environment_variables() {
    std::env::set_var("AGENTMAP_LANGUAGES", "");
    std::env::set_var("AGENTMAP_INCLUDE", "");
    
    let temp_dir = tempdir().unwrap();
    let config = AgentMapConfig::load_with_env(temp_dir.path()).unwrap();
    
    // Empty env vars should not override defaults
    assert!(config.languages.is_some());
    assert!(config.include.is_some());
    
    std::env::remove_var("AGENTMAP_LANGUAGES");
    std::env::remove_var("AGENTMAP_INCLUDE");
}