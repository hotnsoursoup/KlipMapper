use agentmap::config::{AgentMapConfig, ConfigError, PreambleConfig, AutoConfig};
use std::collections::HashMap;

fn main() {
    println!("Testing configuration validation system...");
    
    // Test 1: Valid configuration
    let mut config = AgentMapConfig::default();
    config.languages = Some(vec!["dart".to_string(), "ts".to_string()]);
    
    match config.validate() {
        Ok(_) => println!("✅ Valid configuration passed validation"),
        Err(e) => println!("❌ Valid configuration failed: {}", e),
    }
    
    // Test 2: Invalid language
    let mut invalid_config = AgentMapConfig::default();
    invalid_config.languages = Some(vec!["invalid_lang".to_string()]);
    
    match invalid_config.validate() {
        Ok(_) => println!("❌ Invalid language should have failed validation"),
        Err(e) => {
            println!("✅ Invalid language correctly rejected: {}", e);
            if let ConfigError::UnsupportedLanguage { language, supported } = e {
                println!("   Language: {}, Supported: {:?}", language, supported);
            }
        }
    }
    
    // Test 3: Empty language list
    let mut empty_lang_config = AgentMapConfig::default();
    empty_lang_config.languages = Some(vec![]);
    
    match empty_lang_config.validate() {
        Ok(_) => println!("❌ Empty language list should have failed validation"),
        Err(e) => println!("✅ Empty language list correctly rejected: {}", e),
    }
    
    // Test 4: Invalid line budget
    let mut budget_config = AgentMapConfig::default();
    budget_config.preamble = Some(PreambleConfig {
        line_budget: Some(150), // Too high
        sections: None,
    });
    
    match budget_config.validate() {
        Ok(_) => println!("❌ Invalid line budget should have failed validation"),
        Err(e) => println!("✅ Invalid line budget correctly rejected: {}", e),
    }
    
    // Test 5: Invalid glob pattern
    let mut glob_config = AgentMapConfig::default();
    glob_config.include = Some(vec!["***/*.rs".to_string()]); // Invalid triple asterisk
    
    match glob_config.validate() {
        Ok(_) => println!("❌ Invalid glob pattern should have failed validation"),
        Err(e) => println!("✅ Invalid glob pattern correctly rejected: {}", e),
    }
    
    // Test 6: Language normalization
    let config = AgentMapConfig::default();
    assert_eq!(config.normalize_language("typescript"), "ts");
    assert_eq!(config.normalize_language("javascript"), "js");
    assert_eq!(config.normalize_language("python"), "py");
    assert_eq!(config.normalize_language("rust"), "rs");
    println!("✅ Language normalization works correctly");
    
    // Test 7: is_valid helper
    let valid_config = AgentMapConfig::default();
    assert!(valid_config.is_valid());
    
    let mut invalid_config = AgentMapConfig::default();
    invalid_config.languages = Some(vec!["invalid_language".to_string()]);
    assert!(!invalid_config.is_valid());
    println!("✅ is_valid helper works correctly");
    
    println!("\n🎉 All validation tests completed!");
}