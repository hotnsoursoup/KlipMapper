use serde::{Deserialize, Serialize};
use std::{collections::HashMap, path::{Path, PathBuf}};
use anyhow::{Result, Context};
use thiserror::Error;
use regex::Regex;

/// Configuration validation errors
#[derive(Error, Debug)]
pub enum ConfigError {
    #[error("Unsupported language: {language}. Supported languages: {supported:?}")]
    UnsupportedLanguage { language: String, supported: Vec<String> },
    
    #[error("Invalid glob pattern '{pattern}': {source}")]
    InvalidGlobPattern { pattern: String, #[source] source: anyhow::Error },
    
    #[error("Invalid line budget: {value}. Must be between 1 and 100")]
    InvalidLineBudget { value: u32 },
    
    #[error("Invalid minimum references: {value}. Must be between 1 and 1000")]
    InvalidMinRefs { value: u32 },
    
    #[error("Invalid minimum files: {value}. Must be between 1 and 100")]
    InvalidMinFiles { value: u32 },
    
    #[error("Empty language list is not allowed")]
    EmptyLanguageList,
    
    #[error("Path does not exist: {path}")]
    PathDoesNotExist { path: String },
}

#[derive(Debug, Deserialize, Serialize, Clone)]
pub struct AgentMapConfig {
    pub languages: Option<Vec<String>>,
    pub include: Option<Vec<String>>,
    pub exclude: Option<Vec<String>>,
    pub tags: Option<HashMap<String, String>>,
    pub preamble: Option<PreambleConfig>,
    pub granularity: Option<GranularityConfig>,
    pub auto: Option<AutoConfig>,
    pub query_overrides: Option<HashMap<String, String>>,
    pub track: Option<Vec<String>>,
}

#[derive(Debug, Deserialize, Serialize, Clone)]
pub struct PreambleConfig {
    pub line_budget: Option<u32>,
    pub sections: Option<Vec<String>>,
}

#[derive(Debug, Deserialize, Serialize, Clone)]
pub struct GranularityConfig {
    pub track_calls: Option<bool>,
    pub track_member_access: Option<bool>,
    pub track_generics: Option<bool>,
}

#[derive(Debug, Deserialize, Serialize, Clone)]
pub struct AutoConfig {
    pub enable: Option<bool>,
    pub min_refs: Option<u32>,
    pub min_files: Option<u32>,
}

impl Default for AgentMapConfig {
    fn default() -> Self {
        Self {
            languages: Some(vec!["dart".into(), "ts".into(), "js".into(), "py".into(), "rs".into(), "go".into(), "java".into()]),
            include: Some(vec!["**/*.dart".into(), "**/*.ts".into(), "**/*.js".into(), "**/*.py".into(), "**/*.rs".into(), "**/*.go".into(), "**/*.java".into()]),
            exclude: Some(vec!["**/*.g.dart".into(), "**/build/**".into(), "**/target/**".into(), "**/node_modules/**".into()]),
            tags: None,
            preamble: Some(PreambleConfig {
                line_budget: Some(12),
                sections: Some(vec!["purpose".into(), "io".into(), "invariants".into(), "imports".into(), "hotspots".into()]),
            }),
            granularity: Some(GranularityConfig {
                track_calls: Some(true),
                track_member_access: Some(false),
                track_generics: Some(true),
            }),
            auto: Some(AutoConfig {
                enable: Some(true),
                min_refs: Some(3),
                min_files: Some(2),
            }),
            query_overrides: None,
            track: None,
        }
    }
}

impl AgentMapConfig {
    /// Supported languages for validation
    pub const SUPPORTED_LANGUAGES: &'static [&'static str] = &[
        "dart", "ts", "js", "py", "rust", "rs", "go", "java", "typescript", "javascript", "python"
    ];
    
    /// Valid preamble sections
    pub const VALID_SECTIONS: &'static [&'static str] = &[
        "purpose", "io", "invariants", "imports", "hotspots", "dependencies", "exports", "tests"
    ];
    
    pub fn load_from_dir(root: &Path) -> Result<Self> {
        let config_path = root.join(".agentmap").join("config.yaml");
        
        if config_path.exists() {
            let content = std::fs::read_to_string(&config_path)?;
            let mut config: AgentMapConfig = serde_yaml::from_str(&content)?;
            
            // Merge with defaults
            let default_config = Self::default();
            config.merge_defaults(default_config);
            
            // Validate the merged configuration
            config.validate().context("Configuration validation failed")?;
            
            Ok(config)
        } else {
            Ok(Self::default())
        }
    }
    
    fn merge_defaults(&mut self, defaults: AgentMapConfig) {
        if self.languages.is_none() { self.languages = defaults.languages; }
        if self.include.is_none() { self.include = defaults.include; }
        if self.exclude.is_none() { self.exclude = defaults.exclude; }
        if self.preamble.is_none() { self.preamble = defaults.preamble; }
        if self.granularity.is_none() { self.granularity = defaults.granularity; }
        if self.auto.is_none() { self.auto = defaults.auto; }
    }
    
    /// Validate the configuration for correctness
    pub fn validate(&self) -> Result<(), ConfigError> {
        self.validate_schema()?;
        self.validate_semantics()?;
        Ok(())
    }
    
    /// Validate configuration schema and structure
    fn validate_schema(&self) -> Result<(), ConfigError> {
        // Validate languages
        if let Some(languages) = &self.languages {
            if languages.is_empty() {
                return Err(ConfigError::EmptyLanguageList);
            }
            
            for lang in languages {
                self.ensure_supported_language(lang)?;
            }
        }
        
        // Validate glob patterns
        if let Some(includes) = &self.include {
            for pattern in includes {
                self.validate_glob_pattern(pattern)
                    .map_err(|e| ConfigError::InvalidGlobPattern {
                        pattern: pattern.clone(),
                        source: e,
                    })?;
            }
        }
        
        if let Some(excludes) = &self.exclude {
            for pattern in excludes {
                self.validate_glob_pattern(pattern)
                    .map_err(|e| ConfigError::InvalidGlobPattern {
                        pattern: pattern.clone(),
                        source: e,
                    })?;
            }
        }
        
        Ok(())
    }
    
    /// Validate configuration semantics and constraints
    fn validate_semantics(&self) -> Result<(), ConfigError> {
        // Validate preamble config
        if let Some(preamble) = &self.preamble {
            if let Some(line_budget) = preamble.line_budget {
                if line_budget == 0 || line_budget > 100 {
                    return Err(ConfigError::InvalidLineBudget { value: line_budget });
                }
            }
            
            if let Some(sections) = &preamble.sections {
                for section in sections {
                    if !Self::VALID_SECTIONS.contains(&section.as_str()) {
                        // Warning: unknown section, but don't fail validation
                        eprintln!("Warning: Unknown preamble section '{}'. Valid sections: {:?}", 
                                 section, Self::VALID_SECTIONS);
                    }
                }
            }
        }
        
        // Validate auto config
        if let Some(auto) = &self.auto {
            if let Some(min_refs) = auto.min_refs {
                if min_refs == 0 || min_refs > 1000 {
                    return Err(ConfigError::InvalidMinRefs { value: min_refs });
                }
            }
            
            if let Some(min_files) = auto.min_files {
                if min_files == 0 || min_files > 100 {
                    return Err(ConfigError::InvalidMinFiles { value: min_files });
                }
            }
        }
        
        Ok(())
    }
    
    /// Ensure a language is supported
    fn ensure_supported_language(&self, lang: &str) -> Result<(), ConfigError> {
        // Normalize common language aliases
        let normalized = match lang {
            "typescript" => "ts",
            "javascript" => "js", 
            "python" => "py",
            "rust" => "rs",
            other => other,
        };
        
        if !Self::SUPPORTED_LANGUAGES.contains(&normalized) {
            return Err(ConfigError::UnsupportedLanguage {
                language: lang.to_string(),
                supported: Self::SUPPORTED_LANGUAGES.iter().map(|s| s.to_string()).collect(),
            });
        }
        
        Ok(())
    }
    
    /// Validate a glob pattern
    fn validate_glob_pattern(&self, pattern: &str) -> Result<()> {
        // Basic validation - ensure pattern is not empty and has valid structure
        if pattern.is_empty() {
            anyhow::bail!("Glob pattern cannot be empty");
        }
        
        // Check for invalid patterns that would cause issues
        if pattern.contains("***") {
            anyhow::bail!("Invalid glob pattern: triple asterisk not allowed");
        }
        
        // Validate bracket expressions if present
        if pattern.contains('[') {
            let mut bracket_count = 0;
            for c in pattern.chars() {
                match c {
                    '[' => bracket_count += 1,
                    ']' => {
                        bracket_count -= 1;
                        if bracket_count < 0 {
                            anyhow::bail!("Invalid glob pattern: unmatched closing bracket");
                        }
                    },
                    _ => {},
                }
            }
            if bracket_count != 0 {
                anyhow::bail!("Invalid glob pattern: unmatched opening bracket");
            }
        }
        
        Ok(())
    }
    
    pub fn is_language_enabled(&self, lang: &str) -> bool {
        self.languages.as_ref()
            .map(|langs| langs.contains(&lang.to_string()))
            .unwrap_or(true)
    }
    
    pub fn should_exclude_path(&self, path: &Path) -> bool {
        let path_str = path.to_string_lossy();
        
        if let Some(excludes) = &self.exclude {
            for pattern in excludes {
                if glob_match(pattern, &path_str) {
                    return true;
                }
            }
        }
        
        // Check if included
        if let Some(includes) = &self.include {
            for pattern in includes {
                if glob_match(pattern, &path_str) {
                    return false;
                }
            }
            return true; // Not in include list
        }
        
        false
    }
    
    pub fn map_capture_to_tag(&self, capture: &str) -> String {
        if let Some(tags) = &self.tags {
            tags.get(capture).cloned().unwrap_or_else(|| capture.to_string())
        } else {
            capture.to_string()
        }
    }
    
    pub fn get_query_override(&self, lang_query: &str) -> Option<PathBuf> {
        self.query_overrides.as_ref()
            .and_then(|overrides| overrides.get(lang_query))
            .map(PathBuf::from)
    }
    
    /// Get normalized language name
    pub fn normalize_language(&self, lang: &str) -> String {
        match lang {
            "typescript" => "ts".to_string(),
            "javascript" => "js".to_string(),
            "python" => "py".to_string(),
            "rust" => "rs".to_string(),
            other => other.to_string(),
        }
    }
    
    /// Check if configuration is valid (non-panicking version of validate)
    pub fn is_valid(&self) -> bool {
        self.validate().is_ok()
    }
}

fn glob_match(pattern: &str, path: &str) -> bool {
    // Simple glob matching - could use glob crate for more sophisticated matching
    if pattern.contains("**") {
        let clean_pattern = pattern.replace("**", "*");
        path.contains(&clean_pattern.replace("*", ""))
    } else if pattern.contains("*") {
        let parts: Vec<&str> = pattern.split('*').collect();
        if parts.len() == 2 {
            path.starts_with(parts[0]) && path.ends_with(parts[1])
        } else {
            false
        }
    } else {
        path == pattern
    }
}