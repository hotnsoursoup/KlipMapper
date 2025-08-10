use serde::{Deserialize, Serialize};
use std::{collections::HashMap, path::{Path, PathBuf}};
use anyhow::Result;

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
    pub fn load_from_dir(root: &Path) -> Result<Self> {
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