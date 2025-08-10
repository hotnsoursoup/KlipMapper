1) Add these query files
queries/dart_imports.scm

scm
Copy code
; import names and optional alias
(import_specification
  uri: (_) @import.uri
  (identifier) @import.name)?
(import_specification namespace: (identifier) @import.alias)
queries/dart_uses.scm

scm
Copy code
; Unqualified identifiers
(identifier) @use.id

; Type contexts (classes, annotations, constructors)
(type_identifier) @use.id
(constructor_identifier) @use.id

; Qualified identifiers: prefix.Name
(prefixed_identifier
  prefix: (identifier) @use.prefix
  (identifier) @use.id)
Place these under queries/.

2) Rust changes (concise patch)
2.1 Add optional config + zero-config index
Create .agentmap/config.yaml (optional):

yaml
Copy code
track:
  - Employee
  - EmployeesProvider
  - AppointmentModel
  - CustomerModel
  - TicketModel
  - TechnicianCard
2.1.1 New helper: load config and build auto index
src/index/mod.rs (new)

rust
Copy code
use serde::Deserialize;
use std::{collections::BTreeSet, fs, path::Path};

#[derive(Default, Deserialize)]
pub struct AppConfig { pub track: Option<Vec<String>> }

pub fn load_cfg(root: &Path) -> AppConfig {
    let p = root.join(".agentmap").join("config.yaml");
    fs::read_to_string(&p)
        .ok()
        .and_then(|s| serde_yaml::from_str(&s).ok())
        .unwrap_or_default()
}

pub fn auto_symbols_for_dart(root: &Path) -> BTreeSet<String> {
    // super lightweight: scrape PascalCase names defined at top-level class defs
    // using Tree-sitter if available or a regex fallback.
    // Here we do a simple TS pass when grammar is present.
    use tree_sitter::{Parser, Node};
    let mut out = BTreeSet::new();
    let mut parser = Parser::new();
    if let Some(lang) = tree_sitter_dart::language().into() {
        parser.set_language(&lang).ok();
    }
    for entry in walkdir::WalkDir::new(root)
        .into_iter()
        .filter_map(Result::ok)
        .filter(|e| e.path().extension().is_some_and(|x| x == "dart"))
    {
        if let Ok(src) = fs::read_to_string(entry.path()) {
            if let Some(mut p) = parser.parse(&src, None) {
                let root = p.root_node();
                let mut cursor = root.walk();
                for i in 0..root.child_count() {
                    if let Some(n) = root.child(i) {
                        collect_dart_toplevel(&src, n, &mut out, &mut cursor);
                    }
                }
            }
        }
    }
    out
}

fn collect_dart_toplevel(
    src: &str,
    node: tree_sitter::Node,
    out: &mut std::collections::BTreeSet<String>,
    cursor: &mut tree_sitter::TreeCursor,
) {
    let kind = node.kind();
    if kind == "class_definition" {
        // child: "name" → identifier
        for i in 0..node.child_count() {
            if let Some(c) = node.child(i) {
                if c.kind() == "name" {
                    if let Some(id) = c.child(0) {
                        out.insert(id.utf8_text(src.as_bytes()).unwrap().to_string());
                    }
                }
            }
        }
    }
    // scan siblings
    if cursor.goto_first_child_for_index(node.start_byte()).is_some() {
        loop {
            let n = cursor.node();
            collect_dart_toplevel(src, n, out, cursor);
            if !cursor.goto_next_sibling() { break; }
        }
        cursor.goto_parent();
    }
}
Add to Cargo.toml (if not present):

toml
Copy code
walkdir = "2"
serde = { version = "1", features = ["derive"] }
serde_yaml = "0.9"
2.1.2 Update the TS adapter to tag uses and scopes
Patch your existing src/adapters/ts_adapter.rs where you already
build queries and iterate captures.

Key deltas:

Merge config track set + auto-index (unless disabled).

For each capture @use.id, match text against the track set.

Compute enclosing method/class ranges.

Emit file-level YAML map (files[<path>].tags.*) and a global symbols list.

Minimal drop-in snippet (replace your current capture loop & output):

rust
Copy code
use crate::index::{auto_symbols_for_dart, load_cfg};
use serde::Serialize;
use std::{collections::{BTreeMap, BTreeSet}, path::Path};

#[derive(Serialize)]
struct Scope { kind: String, name: String, start: usize, end: usize }

#[derive(Serialize)]
struct Occ { file: String, lines: Vec<usize>, scopes: Vec<Scope> }

#[derive(Serialize)]
struct SymbolOut { name: String, kind: String, occurrences: Vec<Occ> }

#[derive(Serialize, Default)]
struct FileTags {
    #[serde(rename = "uses:*", skip_serializing_if = "BTreeMap::is_empty")]
    _phantom: BTreeMap<String, ()>,
}

pub fn annotate_dart_file(
    root: &Path,
    path: &Path,
    src: &str,
    parser: &mut tree_sitter::Parser,
    q_uses: &tree_sitter::Query,
    lang: &tree_sitter::Language,
) -> serde_yaml::Value {
    // Build track set
    let cfg = load_cfg(root);
    let mut track: BTreeSet<String> =
        cfg.track.unwrap_or_default().into_iter().collect();
    // zero-config supplement
    for s in auto_symbols_for_dart(root) { track.insert(s); }

    // Parse & query
    parser.set_language(lang).unwrap();
    let tree = parser.parse(src, None).unwrap();
    let mut qc = tree_sitter::QueryCursor::new();
    let mut occurrences: BTreeMap<String, Vec<(usize, Vec<Scope>)>> = BTreeMap::new();

    for m in qc.captures(q_uses, tree.root_node(), src.as_bytes()) {
        let cap = m.0.captures[0]; // @use.id is first in our query lines
        let text = cap.node.utf8_text(src.as_bytes()).unwrap();
        if !track.contains(text) { continue; }

        let line = cap.node.start_position().row + 1;
        let scopes = enclosing_scopes(src, cap.node);

        occurrences.entry(text.to_string())
            .or_default()
            .push((line, scopes));
    }

    // Shape file-level YAML
    #[derive(Serialize)]
    struct FileOut {
        tags: BTreeMap<String, serde_yaml::Value>,
    }
    let mut file_tags: BTreeMap<String, serde_yaml::Value> = BTreeMap::new();
    let fstr = path.to_string_lossy().to_string();
    let mut symbols_yaml = Vec::<SymbolOut>::new();

    for (sym, hits) in occurrences {
        let mut lines = Vec::new();
        let mut occs = Vec::new();
        for (line, scopes) in hits {
            lines.push(line);
            occs.push(Occ {
                file: fstr.clone(),
                lines: vec![line],
                scopes,
            });
        }
        // file quick tags
        file_tags.insert(
            format!("uses:{sym}"),
            serde_yaml::to_value(serde_json::json!({
                "lines": lines,
                "method_regions": occs.iter()
                    .filter_map(|o| o.scopes.iter()
                        .find(|s| s.kind=="method")
                        .map(|s| vec![s.start, s.end]))
                    .collect::<Vec<_>>()
            })).unwrap(),
        );
        symbols_yaml.push(SymbolOut {
            name: sym,
            kind: "symbol".into(),
            occurrences: occs,
        });
    }

    serde_yaml::to_value(serde_json::json!({
        "files": { fstr: { "tags": file_tags } },
        "symbols": symbols_yaml
    })).unwrap()
}

fn enclosing_scopes(src: &str, mut node: tree_sitter::Node) -> Vec<Scope> {
    let mut out = Vec::new();
    while let Some(p) = node.parent() {
        let k = p.kind();
        if k == "method_declaration" || k == "function_declaration" {
            out.push(Scope {
                kind: "method".into(),
                name: node_name(src, p),
                start: p.start_position().row + 1,
                end: p.end_position().row + 1,
            });
        } else if k == "class_definition" {
            out.push(Scope {
                kind: "class".into(),
                name: node_name(src, p),
                start: p.start_position().row + 1,
                end: p.end_position().row + 1,
            });
        }
        node = p;
    }
    out
}

fn node_name(src: &str, n: tree_sitter::Node) -> String {
    for i in 0..n.child_count() {
        if let Some(c) = n.child(i) {
            if c.kind() == "name" {
                if let Some(id) = c.child(0) {
                    return id.utf8_text(src.as_bytes()).unwrap().to_string();
                }
            }
        }
    }
    "".into()
}
Call annotate_dart_file from your existing driver where you iterate files.
The function returns a YAML Value; merge it into your run’s sidecar.
