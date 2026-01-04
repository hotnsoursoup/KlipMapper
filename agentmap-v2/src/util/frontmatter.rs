//! YAML frontmatter parsing for source files.
//!
//! Parses frontmatter blocks like:
//! ```text
//! ---
//! agent_card: MyAgent
//! purpose: Process user data
//! ---
//! // ... rest of file
//! ```

use serde::{Deserialize, Serialize, de::DeserializeOwned};
use std::collections::HashMap;

/// Agent card metadata from frontmatter.
#[derive(Debug, Clone, Default, Serialize, Deserialize)]
pub struct AgentCard {
    /// Agent card name/identifier
    pub agent_card: Option<String>,
    /// Purpose description
    pub purpose: Option<String>,
    /// Entry point functions/methods
    pub entrypoints: Option<Vec<String>>,
    /// Path to agentmap sidecar file
    pub agentmap: Option<String>,
    /// Analysis hints for the parser
    pub hints: Option<Vec<String>>,
    /// Additional custom fields
    #[serde(flatten)]
    pub extra: HashMap<String, serde_yaml::Value>,
}

/// Generic frontmatter container.
#[derive(Debug, Clone, Default)]
pub struct Frontmatter {
    /// Raw YAML content
    pub raw: String,
    /// Parsed fields
    pub fields: HashMap<String, serde_yaml::Value>,
}

impl Frontmatter {
    /// Get a field value as a string.
    pub fn get_string(&self, key: &str) -> Option<String> {
        self.fields.get(key).and_then(|v| v.as_str().map(String::from))
    }

    /// Get a field value as a vector of strings.
    pub fn get_string_vec(&self, key: &str) -> Option<Vec<String>> {
        self.fields.get(key).and_then(|v| {
            v.as_sequence().map(|seq| {
                seq.iter()
                    .filter_map(|item| item.as_str().map(String::from))
                    .collect()
            })
        })
    }

    /// Get a field value as a boolean.
    pub fn get_bool(&self, key: &str) -> Option<bool> {
        self.fields.get(key).and_then(|v| v.as_bool())
    }

    /// Get a field value as an integer.
    pub fn get_i64(&self, key: &str) -> Option<i64> {
        self.fields.get(key).and_then(|v| v.as_i64())
    }

    /// Check if a field exists.
    pub fn has(&self, key: &str) -> bool {
        self.fields.contains_key(key)
    }

    /// Parse into a specific type.
    pub fn parse_as<T: DeserializeOwned>(&self) -> Option<T> {
        serde_yaml::from_str(&self.raw).ok()
    }
}

/// Parse YAML frontmatter from the beginning of a file.
///
/// Looks for content between `---` markers at the start of the file.
///
/// # Arguments
/// * `content` - The file content or first N lines
///
/// # Returns
/// * `Some(Frontmatter)` if valid frontmatter found
/// * `None` if no frontmatter or invalid YAML
pub fn parse_frontmatter(content: &str) -> Option<Frontmatter> {
    let mut lines = content.lines();

    // First line must be `---`
    if lines.next()?.trim() != "---" {
        return None;
    }

    // Collect lines until closing `---`
    let mut body = String::new();
    let mut found_end = false;

    for line in lines {
        if line.trim() == "---" {
            found_end = true;
            break;
        }
        body.push_str(line);
        body.push('\n');
    }

    // Must have closing marker
    if !found_end {
        return None;
    }

    // Try to parse as YAML
    let fields: HashMap<String, serde_yaml::Value> = serde_yaml::from_str(&body).ok()?;

    Some(Frontmatter {
        raw: body,
        fields,
    })
}

/// Parse frontmatter as AgentCard.
pub fn parse_agent_card(content: &str) -> Option<AgentCard> {
    parse_frontmatter(content)?.parse_as()
}

/// Extract frontmatter and remaining content.
///
/// Returns (frontmatter, remaining_content).
pub fn split_frontmatter(content: &str) -> (Option<Frontmatter>, &str) {
    let mut lines = content.lines();

    // Check for opening marker
    let first_line = match lines.next() {
        Some(line) if line.trim() == "---" => line,
        _ => return (None, content),
    };

    // Find closing marker
    let mut body_end = first_line.len() + 1; // +1 for newline
    let mut found_end = false;

    for line in lines {
        body_end += line.len() + 1;
        if line.trim() == "---" {
            found_end = true;
            break;
        }
    }

    if !found_end {
        return (None, content);
    }

    let frontmatter = parse_frontmatter(&content[..body_end]);
    let remaining = content.get(body_end..).unwrap_or("");

    (frontmatter, remaining.trim_start())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_parse_frontmatter() {
        let content = r#"---
agent_card: TestAgent
purpose: Testing
---
fn main() {}
"#;
        let fm = parse_frontmatter(content);
        assert!(fm.is_some());
        let fm = fm.unwrap();
        assert_eq!(fm.get_string("agent_card"), Some("TestAgent".to_string()));
        assert_eq!(fm.get_string("purpose"), Some("Testing".to_string()));
    }

    #[test]
    fn test_parse_agent_card() {
        let content = r#"---
agent_card: MyAgent
purpose: Process data
entrypoints:
  - main
  - init
hints:
  - async
---
"#;
        let card = parse_agent_card(content);
        assert!(card.is_some());
        let card = card.unwrap();
        assert_eq!(card.agent_card, Some("MyAgent".to_string()));
        assert_eq!(card.entrypoints, Some(vec!["main".to_string(), "init".to_string()]));
    }

    #[test]
    fn test_no_frontmatter() {
        let content = "fn main() {}";
        assert!(parse_frontmatter(content).is_none());
    }

    #[test]
    fn test_unclosed_frontmatter() {
        let content = "---\nagent: test\nfn main() {}";
        assert!(parse_frontmatter(content).is_none());
    }

    #[test]
    fn test_split_frontmatter() {
        let content = r#"---
title: Test
---
fn main() {}
"#;
        let (fm, remaining) = split_frontmatter(content);
        assert!(fm.is_some());
        assert!(remaining.contains("fn main()"));
    }

    #[test]
    fn test_frontmatter_with_list() {
        let content = r#"---
hints:
  - async
  - parallel
---
"#;
        let fm = parse_frontmatter(content).unwrap();
        let hints = fm.get_string_vec("hints");
        assert_eq!(hints, Some(vec!["async".to_string(), "parallel".to_string()]));
    }
}
