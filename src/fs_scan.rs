use std::{fs, path::PathBuf};
use ignore::WalkBuilder;
use rayon::prelude::*;
use sha2::{Digest, Sha256};
use anyhow::Result;
use crate::frontmatter::parse as parse_card;
use crate::adapters::{Adapter, FileCtx};
use crate::sidecar::Sidecar;

fn sha16(s: &str) -> String {
    let d = Sha256::digest(s.as_bytes());
    format!("{:x}", d)[..16].to_string()
}

fn sidecar_path(src: &PathBuf, card: &Option<String>) -> PathBuf {
    if let Some(rel) = card {
        return src.parent().unwrap().join(rel);
    }
    let mut out = PathBuf::from(".agentmap");
    out.push(src);
    out.set_extension("yaml");
    out
}

pub fn scan_paths(
    paths: Vec<PathBuf>,
    adapters: &[Box<dyn Adapter>],
    write: bool,
) -> Result<usize> {
    let files: Vec<PathBuf> = paths
        .into_iter()
        .flat_map(|p| {
            if p.is_dir() {
                WalkBuilder::new(p)
                    .standard_filters(true)
                    .build()
                    .filter_map(|e| e.ok())
                    .filter(|e| e
                        .file_type()
                        .map(|t| t.is_file())
                        .unwrap_or(false))
                    .map(|e| e.into_path())
                    .collect()
            } else {
                vec![p]
            }
        })
        .collect();

    let edited: usize = files
        .par_iter()
        .map(|path| {
            let text =
                fs::read_to_string(path).unwrap_or_else(|_| String::new());
            let head = text.lines().take(80)
                .collect::<Vec<_>>().join("\n");
            let fm = parse_card(&head);
            let agentmap_ref = fm.as_ref().and_then(|c| c.agentmap.clone());
            let ctx = FileCtx { path, text: &text };
            let mut used = None;
            for ad in adapters {
                if ad.supports(path) {
                    used = ad.analyze(&ctx).ok();
                    break;
                }
            }
            let a = used.unwrap_or_default();
            let sc = Sidecar {
                agentmap: "v1".into(),
                source: path.to_string_lossy().into(),
                source_hash: sha16(&text),
                regions: a.regions,
                symbols: a.symbols,
                imports: a.imports,
                usage_slices: a.usage,
                call_graph: a.calls,
            };
            let out = sidecar_path(path, &agentmap_ref);
            let new = serde_yaml::to_string(&sc).unwrap();
            let cur = fs::read_to_string(&out).unwrap_or_default();
            if new != cur {
                if write {
                    if let Some(p) = out.parent() {
                        let _ = fs::create_dir_all(p);
                    }
                    let _ = fs::write(&out, new);
                }
                1
            } else {
                0
            }
        })
        .sum();

    Ok(edited)
}
