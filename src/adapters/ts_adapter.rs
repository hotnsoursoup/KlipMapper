use anyhow::Result;
use regex::Regex;
use tree_sitter::{Language, Parser, Query, QueryCursor};
use crate::adapters::{Adapter, Analysis, FileCtx};
use crate::sidecar::{Region, Symbol, Import};

pub struct TsAdapter {
    lang: Language,
    exts: Vec<String>,
    query: Query,
    re_anchor: Regex,
}

impl TsAdapter {
    pub fn new(lang: Language, exts: &[&str], qsrc: &str) -> Self {
        let q = Query::new(&lang, qsrc).expect("valid query");
        let re_anchor = Regex::new(r"<r:([A-Za-z0-9_\-]+)>").unwrap();
        Self {
            lang,
            exts: exts.iter().map(|s| s.to_string()).collect(),
            query: q,
            re_anchor,
        }
    }
}

impl Adapter for TsAdapter {
    fn name(&self) -> &'static str { "treesitter" }

    fn supports(&self, p: &std::path::Path) -> bool {
        p.extension()
            .and_then(|e| e.to_str())
            .map(|e| {
                self.exts
                    .iter()
                    .any(|x| x.trim_start_matches('.') == e)
            })
            .unwrap_or(false)
    }

    fn analyze(&self, f: &FileCtx) -> Result<Analysis> {
        let mut a = Analysis::default();
        let mut p = Parser::new();
        p.set_language(&self.lang)?;
        let tree = p.parse(f.text, None).ok_or_else(|| anyhow::anyhow!(
            "parse failed"))?;

        let mut qc = QueryCursor::new();
        let matches = qc.matches(&self.query, tree.root_node(),
                                 f.text.as_bytes());

        for m in matches {
    for cap in m.captures {
        let cname = self.query.capture_names()[cap.index as usize];
        let node = cap.node;
        let range = node.range();
        let bytes = &f.text.as_bytes()[node.byte_range()];
        let text = String::from_utf8_lossy(bytes).into_owned();

        if cname == "func_name" {
            a.symbols.push(Symbol {
                kind: "function".into(),
                name: text,
                range: (range.start_point.row as u32 + 1,
                        range.end_point.row as u32 + 1),
                doc_capsule: None,
            });
        } else if cname == "method_name" {
            a.symbols.push(Symbol {
                kind: "method".into(),
                name: text,
                range: (range.start_point.row as u32 + 1,
                        range.end_point.row as u32 + 1),
                doc_capsule: None,
            });
        } else if cname == "class_name" || cname == "flutter_class_name" {
            a.symbols.push(Symbol {
                kind: "class".into(),
                name: text,
                range: (range.start_point.row as u32 + 1,
                        range.end_point.row as u32 + 1),
                doc_capsule: None,
            });
        } else if cname == "import_name" {
            a.imports.push(Import { name: text, from: None, path: None });
        }
    }
}


        // Region anchors via regex on source lines
        let mut marks: Vec<(u32, String)> = Vec::new();
        for (i, line) in f.text.lines().enumerate() {
            if let Some(c) = self.re_anchor.captures(line) {
                marks.push((i as u32 + 1, c[1].to_string()));
            }
        }
        for (idx, (start, name)) in marks.iter().enumerate() {
            let end = if idx + 1 < marks.len() {
                marks[idx + 1].0 - 1
            } else {
                f.text.lines().count() as u32
            };
            a.regions.push(Region {
                name: name.clone(),
                anchor: format!("<r:{name}>"),
                start: *start,
                end,
            });
        }

        Ok(a)
    }
}
