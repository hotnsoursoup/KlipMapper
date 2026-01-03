//! Language detection and configuration.

use std::path::Path;
use serde::{Deserialize, Serialize};
use crate::core::{Error, Result};

/// Supported programming languages.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
#[serde(rename_all = "lowercase")]
pub enum Language {
    Rust,
    Python,
    TypeScript,
    JavaScript,
    Go,
    Java,
    Dart,
}

impl Language {
    /// Detect language from file path extension.
    pub fn detect_from_path(path: &Path) -> Result<Self> {
        let ext = path
            .extension()
            .and_then(|e| e.to_str())
            .ok_or_else(|| Error::unsupported_language(path))?;

        Self::from_extension(ext)
            .ok_or_else(|| Error::unsupported_language(path))
    }

    /// Get language from file extension.
    pub fn from_extension(ext: &str) -> Option<Self> {
        match ext.to_lowercase().as_str() {
            "rs" => Some(Self::Rust),
            "py" | "pyi" => Some(Self::Python),
            "ts" | "tsx" => Some(Self::TypeScript),
            "js" | "jsx" | "mjs" | "cjs" => Some(Self::JavaScript),
            "go" => Some(Self::Go),
            "java" => Some(Self::Java),
            "dart" => Some(Self::Dart),
            _ => None,
        }
    }

    /// Get the TreeSitter language for this language.
    pub fn tree_sitter_language(&self) -> tree_sitter::Language {
        match self {
            Self::Rust => tree_sitter_rust::language(),
            Self::Python => tree_sitter_python::language(),
            Self::TypeScript => tree_sitter_typescript::language_typescript(),
            Self::JavaScript => tree_sitter_javascript::language(),
            Self::Go => tree_sitter_go::language(),
            Self::Java => tree_sitter_java::language(),
            Self::Dart => tree_sitter_dart::language(),
        }
    }

    /// Get common file extensions for this language.
    pub fn extensions(&self) -> &[&str] {
        match self {
            Self::Rust => &["rs"],
            Self::Python => &["py", "pyi"],
            Self::TypeScript => &["ts", "tsx"],
            Self::JavaScript => &["js", "jsx", "mjs", "cjs"],
            Self::Go => &["go"],
            Self::Java => &["java"],
            Self::Dart => &["dart"],
        }
    }

    /// Get all supported languages.
    pub fn all() -> &'static [Language] {
        &[
            Self::Rust,
            Self::Python,
            Self::TypeScript,
            Self::JavaScript,
            Self::Go,
            Self::Java,
            Self::Dart,
        ]
    }

    /// Get language name for query file lookups.
    pub fn name(&self) -> &'static str {
        match self {
            Self::Rust => "rust",
            Self::Python => "python",
            Self::TypeScript => "typescript",
            Self::JavaScript => "javascript",
            Self::Go => "go",
            Self::Java => "java",
            Self::Dart => "dart",
        }
    }
}

impl std::fmt::Display for Language {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let s = match self {
            Self::Rust => "rust",
            Self::Python => "python",
            Self::TypeScript => "typescript",
            Self::JavaScript => "javascript",
            Self::Go => "go",
            Self::Java => "java",
            Self::Dart => "dart",
        };
        write!(f, "{s}")
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::path::PathBuf;

    #[test]
    fn test_language_detection() {
        assert_eq!(
            Language::detect_from_path(&PathBuf::from("main.rs")).unwrap(),
            Language::Rust
        );
        assert_eq!(
            Language::detect_from_path(&PathBuf::from("app.py")).unwrap(),
            Language::Python
        );
        assert_eq!(
            Language::detect_from_path(&PathBuf::from("index.ts")).unwrap(),
            Language::TypeScript
        );
    }

    #[test]
    fn test_unsupported_extension() {
        assert!(Language::detect_from_path(&PathBuf::from("readme.md")).is_err());
    }
}
