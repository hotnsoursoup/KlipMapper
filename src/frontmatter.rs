use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug, Clone, Default)]
pub struct AgentCard {
    pub agent_card: Option<String>,
    pub purpose: Option<String>,
    pub entrypoints: Option<Vec<String>>,
    pub agentmap: Option<String>,
    pub hints: Option<Vec<String>>,
}

pub fn parse(head: &str) -> Option<AgentCard> {
    let mut lines = head.lines();
    if lines.next()?.trim() != "---" {
        return None;
    }
    let mut body = String::new();
    for l in lines {
        if l.trim() == "---" {
            break;
        }
        body.push_str(l);
        body.push('\n');
    }
    serde_yaml::from_str(&body).ok()
}
