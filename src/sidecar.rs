use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug, Clone, Default)]
pub struct Region {
    pub name: String,
    pub anchor: String,
    pub start: u32,
    pub end: u32,
}

#[derive(Serialize, Deserialize, Debug, Clone, Default)]
pub struct DocCapsule {
    pub purpose: Option<String>,
    pub inputs: Option<Vec<String>>,
    pub outputs: Option<Vec<String>>,
    pub side_effects: Option<String>,
    pub invariants: Option<Vec<String>>,
    pub pitfalls: Option<Vec<String>>,
}

#[derive(Serialize, Deserialize, Debug, Clone, Default)]
pub struct Symbol {
    pub kind: String,
    pub name: String,
    pub range: (u32, u32),
    pub doc_capsule: Option<DocCapsule>,
}

#[derive(Serialize, Deserialize, Debug, Clone, Default)]
pub struct Import {
    pub name: String,
    pub from: Option<String>,
    pub path: Option<String>,
}

#[derive(Serialize, Deserialize, Debug, Clone, Default)]
pub struct UsageSlice {
    pub import_name: String,
    pub container: String,
    pub start: u32,
    pub end: u32,
}

#[derive(Serialize, Deserialize, Debug, Clone, Default)]
pub struct CallEdge {
    pub caller: String,
    pub target: String,
    pub line: u32,
}

#[derive(Serialize, Deserialize, Debug, Clone, Default)]
pub struct Sidecar {
    pub agentmap: String,
    pub source: String,
    pub source_hash: String,
    pub regions: Vec<Region>,
    pub symbols: Vec<Symbol>,
    pub imports: Vec<Import>,
    pub usage_slices: Vec<UsageSlice>,
    pub call_graph: Vec<CallEdge>,
}
