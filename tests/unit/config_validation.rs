use agentmap::config::{AgentMapConfig, ConfigError, PreambleConfig, AutoConfig};
use std::collections::HashMap;
use tempfile::tempdir;
use std::fs;

#[test]
    fn test_supported_languages_validation() {
        let mut config = AgentMapConfig::default();
        
        // Test valid languages
        config.languages = Some(vec!["dart".to_string(), "ts".to_string(), "py".to_string()]);
        assert!(config.validate().is_ok());
        
        // Test normalized languages
        config.languages = Some(vec!["typescript".to_string(), "javascript".to_string(), "python".to_string()]);
        assert!(config.validate().is_ok());
        
        // Test invalid language
        config.languages = Some(vec!["invalid_lang".to_string()]);
        let result = config.validate();
        assert!(result.is_err());
        assert!(matches!(result.unwrap_err(), ConfigError::UnsupportedLanguage { .. }));
    }

    #[test]
    fn test_empty_language_list_validation() {
        let mut config = AgentMapConfig::default();
        config.languages = Some(vec![]);
        
        let result = config.validate();
        assert!(result.is_err());
        assert!(matches!(result.unwrap_err(), ConfigError::EmptyLanguageList));
    }

    #[test]
    fn test_glob_pattern_validation() {
        let mut config = AgentMapConfig::default();
        
        // Test valid patterns
        config.include = Some(vec!["**/*.rs".to_string(), "src/**/*.ts".to_string()]);
        assert!(config.validate().is_ok());
        
        // Test invalid pattern with triple asterisk
        config.include = Some(vec!["***/*.rs".to_string()]);
        let result = config.validate();
        assert!(result.is_err());
        assert!(matches!(result.unwrap_err(), ConfigError::InvalidGlobPattern { .. }));
        
        // Test empty pattern
        config.include = Some(vec!["".to_string()]);
        let result = config.validate();
        assert!(result.is_err());
        assert!(matches!(result.unwrap_err(), ConfigError::InvalidGlobPattern { .. }));
        
        // Test unmatched brackets
        config.include = Some(vec!["src/[abc/*.rs".to_string()]);
        let result = config.validate();
        assert!(result.is_err());
        assert!(matches!(result.unwrap_err(), ConfigError::InvalidGlobPattern { .. }));
    }

    #[test]
    fn test_line_budget_validation() {
        let mut config = AgentMapConfig::default();
        
        // Test valid line budget
        config.preamble = Some(PreambleConfig {
            line_budget: Some(50),
            sections: None,
        });
        assert!(config.validate().is_ok());
        
        // Test invalid line budget (too high)
        config.preamble = Some(PreambleConfig {
            line_budget: Some(150),
            sections: None,
        });
        let result = config.validate();
        assert!(result.is_err());
        assert!(matches!(result.unwrap_err(), ConfigError::InvalidLineBudget { value: 150 }));
        
        // Test invalid line budget (zero)
        config.preamble = Some(PreambleConfig {
            line_budget: Some(0),
            sections: None,
        });
        let result = config.validate();
        assert!(result.is_err());
        assert!(matches!(result.unwrap_err(), ConfigError::InvalidLineBudget { value: 0 }));
    }

    #[test]
    fn test_auto_config_validation() {
        let mut config = AgentMapConfig::default();
        
        // Test valid auto config
        config.auto = Some(AutoConfig {
            enable: Some(true),
            min_refs: Some(5),
            min_files: Some(3),
        });
        assert!(config.validate().is_ok());
        
        // Test invalid min_refs
        config.auto = Some(AutoConfig {
            enable: Some(true),
            min_refs: Some(1500),
            min_files: Some(3),
        });
        let result = config.validate();
        assert!(result.is_err());
        assert!(matches!(result.unwrap_err(), ConfigError::InvalidMinRefs { value: 1500 }));
        
        // Test invalid min_files
        config.auto = Some(AutoConfig {
            enable: Some(true),
            min_refs: Some(5),
            min_files: Some(150),
        });
        let result = config.validate();
        assert!(result.is_err());
        assert!(matches!(result.unwrap_err(), ConfigError::InvalidMinFiles { value: 150 }));
    }

    #[test]
    fn test_language_normalization() {
        let config = AgentMapConfig::default();
        
        assert_eq!(config.normalize_language("typescript"), "ts");
        assert_eq!(config.normalize_language("javascript"), "js");
        assert_eq!(config.normalize_language("python"), "py");
        assert_eq!(config.normalize_language("rust"), "rs");
        assert_eq!(config.normalize_language("dart"), "dart");
        assert_eq!(config.normalize_language("unknown"), "unknown");
    }

    #[test]
    fn test_is_valid_helper() {
        let valid_config = AgentMapConfig::default();
        assert!(valid_config.is_valid());
        
        let mut invalid_config = AgentMapConfig::default();
        invalid_config.languages = Some(vec!["invalid_language".to_string()]);
        assert!(!invalid_config.is_valid());
    }

    #[test]
    fn test_validation_with_config_loading() {
        let temp_dir = tempdir().unwrap();
        let config_dir = temp_dir.path().join(".agentmap");
        fs::create_dir_all(&config_dir).unwrap();
        
        // Test valid config file
        let config_content = r#"
languages:
  - dart
  - ts
  - py
include:
  - "**/*.dart"
  - "**/*.ts"
exclude:
  - "**/build/**"
preamble:
  line_budget: 15
  sections:
    - purpose
    - imports
auto:
  enable: true
  min_refs: 5
  min_files: 2
"#;
        
        let config_file = config_dir.join("config.yaml");
        fs::write(&config_file, config_content).unwrap();
        
        let result = AgentMapConfig::load_from_dir(temp_dir.path());
        assert!(result.is_ok());
        
        // Test invalid config file
        let invalid_config_content = r#"
languages:
  - invalid_language
preamble:
  line_budget: 150
"#;
        
        fs::write(&config_file, invalid_config_content).unwrap();
        
        let result = AgentMapConfig::load_from_dir(temp_dir.path());
        assert!(result.is_err());
    }

    #[test]  
    fn test_error_messages() {
        let mut config = AgentMapConfig::default();
        config.languages = Some(vec!["invalid_lang".to_string()]);
        
        let error = config.validate().unwrap_err();
        let error_msg = error.to_string();
        assert!(error_msg.contains("Unsupported language: invalid_lang"));
        assert!(error_msg.contains("Supported languages:"));
        
        // Test line budget error message
        config = AgentMapConfig::default();
        config.preamble = Some(PreambleConfig {
            line_budget: Some(150),
            sections: None,
        });
        
        let error = config.validate().unwrap_err();
        let error_msg = error.to_string();
        assert!(error_msg.contains("Invalid line budget: 150"));
        assert!(error_msg.contains("Must be between 1 and 100"));
    }