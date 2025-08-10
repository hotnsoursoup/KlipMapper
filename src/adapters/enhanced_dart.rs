use anyhow::Result;
use serde::Serialize;
use std::collections::{BTreeMap, BTreeSet};
use tree_sitter::{Language, Parser, Query, QueryCursor};
use crate::adapters::{Adapter, Analysis, FileCtx};
use crate::index::{auto_symbols_for_dart, load_cfg};
use crate::sidecar::{Region, Symbol};

#[derive(Serialize)]
struct Scope { 
    kind: String, 
    name: String, 
    start: usize, 
    end: usize 
}

#[derive(Serialize)]
struct Occurrence { 
    file: String, 
    lines: Vec<usize>, 
    scopes: Vec<Scope> 
}

#[derive(Serialize)]
struct SymbolUsage { 
    name: String, 
    kind: String, 
    occurrences: Vec<Occurrence> 
}

pub struct EnhancedDartAdapter {
    lang: Language,
    query: Query,
    uses_query: Query,
}

impl EnhancedDartAdapter {
    pub fn new() -> Result<Self> {
        let lang = tree_sitter_dart::language();
        let query_src = include_str!("../../queries/dart.scm");
        let uses_query_src = include_str!("../../queries/dart_uses.scm");
        
        let query = Query::new(&lang, query_src)?;
        let uses_query = Query::new(&lang, uses_query_src)?;
        
        Ok(Self {
            lang,
            query,
            uses_query,
        })
    }
    
    pub fn analyze_with_tracking(&self, f: &FileCtx, root_path: &std::path::Path) -> Result<(Analysis, BTreeMap<String, serde_yaml::Value>)> {
        // Standard analysis first
        let analysis = self.analyze_standard(f)?;
        
        // Enhanced symbol tracking
        let tracking_data = self.analyze_symbol_usage(f, root_path)?;
        
        Ok((analysis, tracking_data))
    }
    
    fn analyze_standard(&self, f: &FileCtx) -> Result<Analysis> {
        let mut analysis = Analysis::default();
        let mut parser = Parser::new();
        parser.set_language(&self.lang)?;
        
        let tree = parser.parse(f.text, None).ok_or_else(|| anyhow::anyhow!("Parse failed"))?;
        let mut cursor = QueryCursor::new();
        let matches = cursor.matches(&self.query, tree.root_node(), f.text.as_bytes());
        
        for m in matches {
            for cap in m.captures {
                let cname = self.query.capture_names()[cap.index as usize];
                let node = cap.node;
                let range = node.range();
                let text = node.utf8_text(f.text.as_bytes())
                    .unwrap_or("<invalid>").to_string();
                
                if cname == "func_name" {
                    analysis.symbols.push(Symbol {
                        kind: "function".into(),
                        name: text,
                        range: (range.start_point.row as u32 + 1, range.end_point.row as u32 + 1),
                        doc_capsule: None,
                    });
                } else if cname == "class_name" {
                    analysis.symbols.push(Symbol {
                        kind: "class".into(),
                        name: text,
                        range: (range.start_point.row as u32 + 1, range.end_point.row as u32 + 1),
                        doc_capsule: None,
                    });
                }
            }
        }
        
        // Extract regions from <r:name> anchors
        let re_anchor = regex::Regex::new(r"<r:([A-Za-z0-9_\-]+)>").unwrap();
        let mut marks: Vec<(u32, String)> = Vec::new();
        
        for (i, line) in f.text.lines().enumerate() {
            if let Some(c) = re_anchor.captures(line) {
                marks.push((i as u32 + 1, c[1].to_string()));
            }
        }
        
        for (idx, (start, name)) in marks.iter().enumerate() {
            let end = if idx + 1 < marks.len() {
                marks[idx + 1].0 - 1
            } else {
                f.text.lines().count() as u32
            };
            analysis.regions.push(Region {
                name: name.clone(),
                anchor: format!("<r:{name}>"),
                start: *start,
                end,
            });
        }
        
        Ok(analysis)
    }
    
    fn analyze_symbol_usage(&self, f: &FileCtx, root_path: &std::path::Path) -> Result<BTreeMap<String, serde_yaml::Value>> {
        // Build tracking set
        let cfg = load_cfg(root_path);
        let mut track: BTreeSet<String> = cfg.track.unwrap_or_default().into_iter().collect();
        
        // Add auto-detected symbols (with error handling)
        match auto_symbols_for_dart(root_path) {
            Ok(auto_symbols) => track.extend(auto_symbols),
            Err(_) => {} // Continue without auto symbols if detection fails
        }
        
        if track.is_empty() {
            return Ok(BTreeMap::new());
        }
        
        let mut parser = Parser::new();
        parser.set_language(&self.lang)?;
        let tree = parser.parse(f.text, None).ok_or_else(|| anyhow::anyhow!("Parse failed"))?;
        let mut cursor = QueryCursor::new();
        
        let mut usage_data = BTreeMap::new();
        let mut occurrences: BTreeMap<String, Vec<(usize, Vec<Scope>)>> = BTreeMap::new();
        
        for m in cursor.matches(&self.uses_query, tree.root_node(), f.text.as_bytes()) {
            for cap in m.captures {
                let cname = self.uses_query.capture_names()[cap.index as usize];
                if cname == "use.id" {
                    if let Ok(text) = cap.node.utf8_text(f.text.as_bytes()) {
                        if track.contains(text) {
                            let line = cap.node.start_position().row + 1;
                            let scopes = self.find_enclosing_scopes(f.text, cap.node);
                            occurrences.entry(text.to_string())
                                .or_default()
                                .push((line, scopes));
                        }
                    }
                }
            }
        }
        
        // Build file tags
        let _file_path = f.path.to_string_lossy().to_string();
        let mut file_tags = BTreeMap::new();
        
        for (sym, hits) in occurrences {
            let lines: Vec<usize> = hits.iter().map(|(line, _)| *line).collect();
            let method_regions: Vec<Vec<usize>> = hits.iter()
                .filter_map(|(_, scopes)| {
                    scopes.iter()
                        .find(|s| s.kind == "method")
                        .map(|s| vec![s.start, s.end])
                })
                .collect();
            
            file_tags.insert(
                format!("uses:{}", sym),
                serde_yaml::to_value(serde_json::json!({
                    "lines": lines,
                    "method_regions": method_regions
                }))?,
            );
        }
        
        usage_data.insert("tags".to_string(), serde_yaml::to_value(file_tags)?);
        Ok(usage_data)
    }
    
    fn find_enclosing_scopes(&self, src: &str, mut node: tree_sitter::Node) -> Vec<Scope> {
        let mut scopes = Vec::new();
        
        while let Some(parent) = node.parent() {
            let kind = parent.kind();
            if kind == "method_declaration" || kind == "function_signature" {
                scopes.push(Scope {
                    kind: "method".into(),
                    name: self.extract_node_name(src, parent),
                    start: parent.start_position().row + 1,
                    end: parent.end_position().row + 1,
                });
            } else if kind == "class_definition" {
                scopes.push(Scope {
                    kind: "class".into(),
                    name: self.extract_node_name(src, parent),
                    start: parent.start_position().row + 1,
                    end: parent.end_position().row + 1,
                });
            }
            node = parent;
        }
        
        scopes
    }
    
    fn extract_node_name(&self, src: &str, node: tree_sitter::Node) -> String {
        for i in 0..node.child_count() {
            if let Some(child) = node.child(i) {
                if child.kind() == "identifier" {
                    return child.utf8_text(src.as_bytes())
                        .unwrap_or("<unknown>").to_string();
                }
            }
        }
        "<unknown>".to_string()
    }
}

impl Adapter for EnhancedDartAdapter {
    fn name(&self) -> &'static str { 
        "enhanced_dart" 
    }

    fn supports(&self, path: &std::path::Path) -> bool {
        path.extension()
            .and_then(|e| e.to_str())
            .map(|e| e == "dart")
            .unwrap_or(false)
    }

    fn analyze(&self, f: &FileCtx) -> Result<Analysis> {
        self.analyze_standard(f)
    }
}