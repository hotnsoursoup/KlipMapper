use serde::{Deserialize, Serialize};
use std::{collections::HashMap, path::{Path, PathBuf}};
use anyhow::{Result, Context};
use thiserror::Error;
use regex::Regex;
use globset::{Glob, GlobSet, GlobSetBuilder};
use std::sync::Arc;

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
    
    #[error("Failed to build glob set: {source}")]
    GlobSetBuildError { #[source] source: globset::Error },
}

/// Cached glob matcher for efficient path matching
#[derive(Debug, Clone)]
pub struct GlobMatcher {
    include_set: Option<Arc<GlobSet>>,
    exclude_set: Option<Arc<GlobSet>>,
}

impl GlobMatcher {
    /// Check if a path should be excluded based on include/exclude patterns
    pub fn should_exclude(&self, path: &str) -> bool {
        // First check exclude patterns - if any match, exclude the path
        if let Some(ref exclude_set) = self.exclude_set {
            if exclude_set.is_match(path) {
                return true;
            }
        }
        
        // If there are include patterns, path must match at least one to be included
        if let Some(ref include_set) = self.include_set {
            return !include_set.is_match(path);
        }
        
        // No include patterns specified, and path doesn't match exclude patterns
        false
    }
    
    /// Check if a path matches include patterns
    pub fn matches_include(&self, path: &str) -> bool {
        if let Some(ref include_set) = self.include_set {
            include_set.is_match(path)
        } else {
            true // No include patterns means everything is included by default
        }
    }
    
    /// Check if a path matches exclude patterns
    pub fn matches_exclude(&self, path: &str) -> bool {
        if let Some(ref exclude_set) = self.exclude_set {
            exclude_set.is_match(path)
        } else {
            false // No exclude patterns means nothing is excluded by default
        }
    }
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
    
    /// Cached glob matcher (not serialized)
    #[serde(skip)]
    pub glob_matcher: Option<GlobMatcher>,
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
            glob_matcher: None,
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
    
    /// Supported configuration profiles
    pub const SUPPORTED_PROFILES: &'static [&'static str] = &[
        "default", "development", "dev", "production", "prod", "testing", "test"
    ];
    
    pub fn load_from_dir(root: &Path) -> Result<Self> {
        // Use the new environment-aware loader
        Self::load_with_env(root)
    }
    
    /// Load configuration with environment variable overrides and profile support
    pub fn load_with_env(root: &Path) -> Result<Self> {
        let mut config = Self::load_yaml(root)?;
        
        // Apply profile-specific configuration
        let profile = std::env::var("AGENTMAP_PROFILE")
            .unwrap_or_else(|_| "default".to_string());
        config.apply_profile(&profile)?;
        
        // Apply environment variable overrides
        config.apply_env_overrides("AGENTMAP_")?;
        
        // Validate the final configuration
        config.validate().context("Configuration validation failed")?;
        
        // Build glob matcher for efficient path matching
        config.build_globset().context("Failed to build glob matcher")?;
        
        Ok(config)
    }
    
    /// Load base configuration from YAML file
    fn load_yaml(root: &Path) -> Result<Self> {
        let config_path = root.join(".agentmap").join("config.yaml");
        
        if config_path.exists() {
            let content = std::fs::read_to_string(&config_path)?;
            let mut config: AgentMapConfig = serde_yaml::from_str(&content)?;
            
            // Merge with defaults
            let default_config = Self::default();
            config.merge_defaults(default_config);
            
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
    
    /// Build GlobSet for efficient path matching
    pub fn build_globset(&mut self) -> Result<(), ConfigError> {
        let mut include_builder = GlobSetBuilder::new();
        let mut exclude_builder = GlobSetBuilder::new();
        
        // Add include patterns
        if let Some(patterns) = &self.include {
            for pattern in patterns {
                let glob = Glob::new(pattern)
                    .map_err(|e| ConfigError::GlobSetBuildError { source: e })?;
                include_builder.add(glob);
            }
        }
        
        // Add exclude patterns  
        if let Some(patterns) = &self.exclude {
            for pattern in patterns {
                let glob = Glob::new(pattern)
                    .map_err(|e| ConfigError::GlobSetBuildError { source: e })?;
                exclude_builder.add(glob);
            }
        }
        
        // Build the glob sets
        let include_set = if self.include.is_some() {
            Some(Arc::new(include_builder.build()
                .map_err(|e| ConfigError::GlobSetBuildError { source: e })?))
        } else {
            None
        };
        
        let exclude_set = if self.exclude.is_some() {
            Some(Arc::new(exclude_builder.build()
                .map_err(|e| ConfigError::GlobSetBuildError { source: e })?))
        } else {
            None
        };
        
        self.glob_matcher = Some(GlobMatcher {
            include_set,
            exclude_set,
        });
        
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
        
        if let Some(ref matcher) = self.glob_matcher {
            return matcher.should_exclude(&path_str);
        }
        
        // Fallback to simple pattern matching if glob matcher is not built
        self.should_exclude_path_simple(path)
    }
    
    /// Fallback method using simple pattern matching
    fn should_exclude_path_simple(&self, path: &Path) -> bool {
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
    
    /// Apply profile-specific configuration overrides
    fn apply_profile(&mut self, profile: &str) -> Result<()> {
        let profile_lower = profile.to_lowercase();
        let normalized_profile = match profile_lower.as_str() {
            "dev" => "development",
            "prod" => "production",  
            "test" => "testing",
            other => other,
        };
        
        if !Self::SUPPORTED_PROFILES.contains(&normalized_profile) {
            eprintln!(
                "Warning: Unknown profile '{}'. Supported profiles: {:?}", 
                profile, Self::SUPPORTED_PROFILES
            );
            return Ok(()); // Don't fail on unknown profiles, just warn
        }
        
        match normalized_profile {
            "development" => {
                // Development profile: more verbose, include more files
                if self.exclude.is_none() {
                    self.exclude = Some(vec![
                        "**/*.g.dart".to_string(),
                        "**/target/debug/**".to_string(),
                        "**/node_modules/**".to_string(),
                    ]);
                }
                // Enable more granular tracking in development
                if let Some(ref mut granularity) = self.granularity {
                    if granularity.track_member_access.is_none() {
                        granularity.track_member_access = Some(true);
                    }
                }
            },
            "production" => {
                // Production profile: optimized for performance
                if self.exclude.is_none() {
                    self.exclude = Some(vec![
                        "**/*.g.dart".to_string(),
                        "**/build/**".to_string(),
                        "**/target/**".to_string(),
                        "**/node_modules/**".to_string(),
                        "**/test/**".to_string(),
                        "**/tests/**".to_string(),
                    ]);
                }
                // Reduce tracking overhead in production
                if let Some(ref mut granularity) = self.granularity {
                    if granularity.track_member_access.is_none() {
                        granularity.track_member_access = Some(false);
                    }
                    if granularity.track_generics.is_none() {
                        granularity.track_generics = Some(false);
                    }
                }
            },
            "testing" => {
                // Testing profile: include test files, minimal exclusions
                if self.exclude.is_none() {
                    self.exclude = Some(vec![
                        "**/*.g.dart".to_string(),
                        "**/node_modules/**".to_string(),
                    ]);
                }
                if self.include.is_none() {
                    self.include = Some(vec![
                        "**/*.dart".to_string(),
                        "**/*.ts".to_string(),
                        "**/*.js".to_string(),
                        "**/*.py".to_string(),
                        "**/*.rs".to_string(),
                        "**/test/**/*.dart".to_string(),
                        "**/tests/**/*.rs".to_string(),
                    ]);
                }
            },
            _ => {} // default profile or others - no special handling
        }
        
        Ok(())
    }
    
    /// Apply environment variable overrides
    fn apply_env_overrides(&mut self, prefix: &str) -> Result<()> {
        // Map environment variables to configuration fields
        
        // AGENTMAP_LANGUAGES=dart,ts,py
        if let Ok(val) = std::env::var(format!("{prefix}LANGUAGES")) {
            let languages: Vec<String> = val.split(',')
                .map(|s| s.trim().to_string())
                .filter(|s| !s.is_empty())
                .collect();
            if !languages.is_empty() {
                self.languages = Some(languages);
            }
        }
        
        // AGENTMAP_INCLUDE=**/*.dart,**/*.ts
        if let Ok(val) = std::env::var(format!("{prefix}INCLUDE")) {
            let patterns: Vec<String> = val.split(',')
                .map(|s| s.trim().to_string())
                .filter(|s| !s.is_empty())
                .collect();
            if !patterns.is_empty() {
                self.include = Some(patterns);
            }
        }
        
        // AGENTMAP_EXCLUDE=**/*.g.dart,**/build/**
        if let Ok(val) = std::env::var(format!("{prefix}EXCLUDE")) {
            let patterns: Vec<String> = val.split(',')
                .map(|s| s.trim().to_string())
                .filter(|s| !s.is_empty())
                .collect();
            if !patterns.is_empty() {
                self.exclude = Some(patterns);
            }
        }
        
        // AGENTMAP_LINE_BUDGET=15
        if let Ok(val) = std::env::var(format!("{prefix}LINE_BUDGET")) {
            if let Ok(budget) = val.parse::<u32>() {
                if self.preamble.is_none() {
                    self.preamble = Some(PreambleConfig {
                        line_budget: Some(budget),
                        sections: None,
                    });
                } else if let Some(ref mut preamble) = self.preamble {
                    preamble.line_budget = Some(budget);
                }
            }
        }
        
        // AGENTMAP_MIN_REFS=5
        if let Ok(val) = std::env::var(format!("{prefix}MIN_REFS")) {
            if let Ok(min_refs) = val.parse::<u32>() {
                if self.auto.is_none() {
                    self.auto = Some(AutoConfig {
                        enable: Some(true),
                        min_refs: Some(min_refs),
                        min_files: None,
                    });
                } else if let Some(ref mut auto_config) = self.auto {
                    auto_config.min_refs = Some(min_refs);
                }
            }
        }
        
        // AGENTMAP_MIN_FILES=3
        if let Ok(val) = std::env::var(format!("{prefix}MIN_FILES")) {
            if let Ok(min_files) = val.parse::<u32>() {
                if self.auto.is_none() {
                    self.auto = Some(AutoConfig {
                        enable: Some(true),
                        min_refs: None,
                        min_files: Some(min_files),
                    });
                } else if let Some(ref mut auto_config) = self.auto {
                    auto_config.min_files = Some(min_files);
                }
            }
        }
        
        // AGENTMAP_TRACK_CALLS=true|false
        if let Ok(val) = std::env::var(format!("{prefix}TRACK_CALLS")) {
            if let Ok(track_calls) = val.to_lowercase().parse::<bool>() {
                if self.granularity.is_none() {
                    self.granularity = Some(GranularityConfig {
                        track_calls: Some(track_calls),
                        track_member_access: None,
                        track_generics: None,
                    });
                } else if let Some(ref mut granularity) = self.granularity {
                    granularity.track_calls = Some(track_calls);
                }
            }
        }
        
        // AGENTMAP_TRACK_MEMBER_ACCESS=true|false
        if let Ok(val) = std::env::var(format!("{prefix}TRACK_MEMBER_ACCESS")) {
            if let Ok(track_member) = val.to_lowercase().parse::<bool>() {
                if self.granularity.is_none() {
                    self.granularity = Some(GranularityConfig {
                        track_calls: None,
                        track_member_access: Some(track_member),
                        track_generics: None,
                    });
                } else if let Some(ref mut granularity) = self.granularity {
                    granularity.track_member_access = Some(track_member);
                }
            }
        }
        
        // AGENTMAP_TRACK_GENERICS=true|false
        if let Ok(val) = std::env::var(format!("{prefix}TRACK_GENERICS")) {
            if let Ok(track_generics) = val.to_lowercase().parse::<bool>() {
                if self.granularity.is_none() {
                    self.granularity = Some(GranularityConfig {
                        track_calls: None,
                        track_member_access: None,
                        track_generics: Some(track_generics),
                    });
                } else if let Some(ref mut granularity) = self.granularity {
                    granularity.track_generics = Some(track_generics);
                }
            }
        }
        
        Ok(())
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