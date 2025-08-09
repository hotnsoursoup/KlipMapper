use anyhow::Result;
use crate::sidecar::{Region, Symbol, Import, UsageSlice, CallEdge};

pub struct FileCtx<'a> {
    pub path: &'a std::path::Path,
    pub text: &'a str,
}

#[derive(Default)]
pub struct Analysis {
    pub regions: Vec<Region>,
    pub symbols: Vec<Symbol>,
    pub imports: Vec<Import>,
    pub usage: Vec<UsageSlice>,
    pub calls: Vec<CallEdge>,
}

pub trait Adapter: Send + Sync {
    fn name(&self) -> &'static str;
    fn supports(&self, p: &std::path::Path) -> bool;
    fn analyze(&self, f: &FileCtx) -> Result<Analysis>;
}

pub mod ts_adapter;

pub mod registry {
    use super::*;
    use anyhow::Result;
    use tree_sitter::Language;
    use crate::adapters::ts_adapter::TsAdapter;

    fn make(lang: Language, exts: &[&str], q: &str) -> Box<dyn Adapter> {
        Box::new(TsAdapter::new(lang, exts, q))
    }

    pub fn all() -> Result<Vec<Box<dyn Adapter>>> {
        let dart_q = include_str!("../../queries/dart.scm");
        let py_q = include_str!("../../queries/python.scm");
        let ts_q = include_str!("../../queries/typescript.scm");

        let mut v: Vec<Box<dyn Adapter>> = Vec::new();
        v.push(make(tree_sitter_dart::language(), &[".dart"], dart_q));
        v.push(make(tree_sitter_python::language(), &[".py"], py_q));
        v.push(make(
            tree_sitter_typescript::language_typescript(),
            &[".ts", ".tsx"],
            ts_q,
        ));
        v.push(make(
            tree_sitter_javascript::language(),
            &[".js", ".jsx"],
            ts_q,
        ));
        Ok(v)
    }
}
