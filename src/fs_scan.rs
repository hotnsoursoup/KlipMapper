use std::{fs, path::PathBuf};
use ignore::WalkBuilder;
use rayon::prelude::*;
use sha2::{Digest, Sha256};
use anyhow::{Result, Context, bail};
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
    println!("DEBUG: scan_paths called with {} paths", paths.len());
    for (i, path) in paths.iter().enumerate() {
        println!("DEBUG: Path {}: {}", i, path.display());
        
        // Check if path exists
        if !path.exists() {
            bail!("Path does not exist: {}", path.display());
        }
        
        // Check if we can read it
        let meta = std::fs::metadata(path)
            .with_context(|| format!("Failed to stat path: {}", path.display()))?;
        
        if meta.is_dir() {
            println!("DEBUG: {} is a directory", path.display());
        } else {
            println!("DEBUG: {} is a file", path.display());
        }
    }

    let files: Vec<PathBuf> = paths
        .into_iter()
        .flat_map(|p| {
            if p.is_dir() {
                let walker_files: Vec<PathBuf> = WalkBuilder::new(&p)
                    .standard_filters(true)
                    .build()
                    .filter_map(|e| e.ok())
                    .filter(|e| e
                        .file_type()
                        .map(|t| t.is_file())
                        .unwrap_or(false))
                    .map(|e| e.into_path())
                    .collect();
                println!("DEBUG: Found {} files in directory {}", walker_files.len(), p.display());
                walker_files
            } else {
                vec![p]
            }
        })
        .collect();

    println!("DEBUG: Total files to process: {}", files.len());
    
    if files.is_empty() {
        bail!("No files found to scan in the provided paths");
    }

    // Show first few files for debugging
    for (i, file) in files.iter().take(5).enumerate() {
        println!("DEBUG: File {}: {}", i, file.display());
    }

    let edited: usize = files
        .par_iter()
        .map(|path| {
            // Try to read file, but handle errors gracefully
            let text = match fs::read_to_string(path) {
                Ok(content) => content,
                Err(e) => {
                    eprintln!("WARN: Failed to read file {}: {}", path.display(), e);
                    return 0;
                }
            };
            
            let head = text.lines().take(80)
                .collect::<Vec<_>>().join("\n");
            let fm = parse_card(&head);
            let agentmap_ref = fm.as_ref().and_then(|c| c.agentmap.clone());
            let ctx = FileCtx { path, text: &text };
            
            // Find matching adapter
            let mut used = None;
            for ad in adapters {
                if ad.supports(path) {
                    println!("DEBUG: Processing {} with adapter {}", path.display(), ad.name());
                    match ad.analyze(&ctx) {
                        Ok(analysis) => {
                            used = Some(analysis);
                            break;
                        },
                        Err(e) => {
                            eprintln!("WARN: Analysis failed for {} with {}: {}", 
                                path.display(), ad.name(), e);
                        }
                    }
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
            let new = match serde_yaml::to_string(&sc) {
                Ok(yaml) => yaml,
                Err(e) => {
                    eprintln!("WARN: Failed to serialize sidecar for {}: {}", path.display(), e);
                    return 0;
                }
            };
            
            let cur = fs::read_to_string(&out).unwrap_or_default();
            if new != cur {
                if write {
                    if let Some(p) = out.parent() {
                        let _ = fs::create_dir_all(p);
                    }
                    match fs::write(&out, &new) {
                        Ok(_) => println!("DEBUG: Wrote sidecar to {}", out.display()),
                        Err(e) => eprintln!("WARN: Failed to write sidecar to {}: {}", out.display(), e),
                    }
                } else {
                    println!("DEBUG: Would write sidecar to {}", out.display());
                }
                1
            } else {
                0
            }
        })
        .sum();

    Ok(edited)
}
