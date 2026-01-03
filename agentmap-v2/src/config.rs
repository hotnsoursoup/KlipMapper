//! Configuration module for AgentMap.
//!
//! Supports YAML configuration files for customizing analysis.

use std::path::{Path, PathBuf};
use serde::{Deserialize, Serialize};
use crate::core::{Result, Error};

/// AgentMap configuration.
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(default)]
pub struct Config {
    /// Languages to analyze (empty = all supported).
    pub languages: Vec<String>,

    /// Patterns to exclude (glob format).
    pub exclude: Vec<String>,

    /// Maximum file size to analyze (bytes).
    pub max_file_size: usize,

    /// Enable caching.
    pub cache: CacheConfig,

    /// Middleware configuration.
    pub middleware: MiddlewareConfig,

    /// Output configuration.
    pub output: OutputConfig,
}

/// Cache configuration.
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(default)]
pub struct CacheConfig {
    /// Enable caching.
    pub enabled: bool,
    /// Maximum cache entries.
    pub max_entries: usize,
}

/// Middleware configuration.
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(default)]
pub struct MiddlewareConfig {
    /// Enable logging middleware.
    pub logging: bool,
    /// Log level (debug, info, warn).
    pub log_level: String,
    /// Enable metrics collection.
    pub metrics: bool,
}

/// Output configuration.
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(default)]
pub struct OutputConfig {
    /// Default output format.
    pub format: String,
    /// Generate sidecar files.
    pub sidecar: bool,
    /// Sidecar file suffix.
    pub sidecar_suffix: String,
}

impl Default for Config {
    fn default() -> Self {
        Self {
            languages: vec![],
            exclude: vec![
                "**/node_modules/**".to_string(),
                "**/target/**".to_string(),
                "**/.git/**".to_string(),
                "**/vendor/**".to_string(),
                "**/__pycache__/**".to_string(),
            ],
            max_file_size: 1024 * 1024, // 1MB
            cache: CacheConfig::default(),
            middleware: MiddlewareConfig::default(),
            output: OutputConfig::default(),
        }
    }
}

impl Default for CacheConfig {
    fn default() -> Self {
        Self {
            enabled: true,
            max_entries: 1000,
        }
    }
}

impl Default for MiddlewareConfig {
    fn default() -> Self {
        Self {
            logging: false,
            log_level: "info".to_string(),
            metrics: true,
        }
    }
}

impl Default for OutputConfig {
    fn default() -> Self {
        Self {
            format: "json".to_string(),
            sidecar: false,
            sidecar_suffix: ".agentmap.yaml".to_string(),
        }
    }
}

impl Config {
    /// Load configuration from a file.
    pub fn load(path: &Path) -> Result<Self> {
        let content = std::fs::read_to_string(path)
            .map_err(|e| Error::io(path, e))?;

        Self::from_yaml(&content)
    }

    /// Parse configuration from YAML string.
    #[cfg(feature = "sidecar")]
    pub fn from_yaml(content: &str) -> Result<Self> {
        serde_yaml::from_str(content)
            .map_err(|e| Error::config(format!("Invalid config: {}", e)))
    }

    #[cfg(not(feature = "sidecar"))]
    pub fn from_yaml(_content: &str) -> Result<Self> {
        // Without YAML support, return default
        Ok(Self::default())
    }

    /// Save configuration to a file.
    #[cfg(feature = "sidecar")]
    pub fn save(&self, path: &Path) -> Result<()> {
        let content = serde_yaml::to_string(self)
            .map_err(|e| Error::config(format!("Failed to serialize: {}", e)))?;

        std::fs::write(path, content)
            .map_err(|e| Error::io(path, e))?;

        Ok(())
    }

    /// Find configuration file in standard locations.
    pub fn find() -> Option<PathBuf> {
        let candidates = [
            ".agentmap.yaml",
            ".agentmap.yml",
            "agentmap.yaml",
            "agentmap.yml",
        ];

        // Check current directory first
        for name in &candidates {
            let path = PathBuf::from(name);
            if path.exists() {
                return Some(path);
            }
        }

        // Check home directory
        if let Some(home) = dirs_home() {
            for name in &candidates {
                let path = home.join(name);
                if path.exists() {
                    return Some(path);
                }
            }
        }

        None
    }

    /// Check if a path should be excluded.
    pub fn should_exclude(&self, path: &Path) -> bool {
        let path_str = path.to_string_lossy();

        for pattern in &self.exclude {
            // Handle **/ glob patterns
            if pattern.contains("**") {
                // Remove ** and check if remaining parts are in path
                let clean = pattern.replace("**", "").replace("//", "/");
                let parts: Vec<&str> = clean.split('/').filter(|s| !s.is_empty()).collect();

                // Check if all non-empty parts are in the path
                if parts.iter().all(|p| path_str.contains(p)) {
                    return true;
                }
            } else if path_str.contains(pattern) {
                return true;
            }
        }

        false
    }
}

/// Get home directory.
fn dirs_home() -> Option<PathBuf> {
    std::env::var("HOME")
        .or_else(|_| std::env::var("USERPROFILE"))
        .ok()
        .map(PathBuf::from)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_default_config() {
        let config = Config::default();
        assert!(config.exclude.len() > 0);
        assert_eq!(config.max_file_size, 1024 * 1024);
    }

    #[test]
    fn test_should_exclude() {
        let config = Config::default();
        assert!(config.should_exclude(Path::new("project/node_modules/foo.js")));
        assert!(config.should_exclude(Path::new("project/target/debug/main")));
        assert!(!config.should_exclude(Path::new("project/src/main.rs")));
    }
}
