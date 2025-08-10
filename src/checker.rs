use anyhow::Result;
use std::{fs, path::PathBuf};
use crate::adapters::{Adapter, FileCtx};
use crate::sidecar::Sidecar;
use crate::frontmatter::parse as parse_card;
use sha2::{Digest, Sha256};
use ignore::WalkBuilder;
use rayon::prelude::*;

#[derive(Debug, PartialEq)]
pub enum CheckResult {
    Valid,
    Missing,
    Outdated,
    Invalid,
}

pub struct CheckSummary {
    pub valid: usize,
    pub missing: usize,
    pub outdated: usize,
    pub invalid: usize,
    pub details: Vec<(PathBuf, CheckResult, Option<String>)>,
}

impl CheckSummary {
    pub fn new() -> Self {
        Self {
            valid: 0,
            missing: 0,
            outdated: 0,
            invalid: 0,
            details: Vec::new(),
        }
    }
    
    pub fn add_result(&mut self, path: PathBuf, result: CheckResult, message: Option<String>) {
        match result {
            CheckResult::Valid => self.valid += 1,
            CheckResult::Missing => self.missing += 1,
            CheckResult::Outdated => self.outdated += 1,
            CheckResult::Invalid => self.invalid += 1,
        }
        self.details.push((path, result, message));
    }
    
    pub fn has_issues(&self) -> bool {
        self.missing > 0 || self.outdated > 0 || self.invalid > 0
    }
    
    pub fn exit_code(&self) -> i32 {
        if self.has_issues() { 1 } else { 0 }
    }
}

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

pub fn check_paths(
    paths: Vec<PathBuf>,
    adapters: &[Box<dyn Adapter>],
) -> Result<CheckSummary> {
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

    let results: Vec<(PathBuf, CheckResult, Option<String>)> = files
        .par_iter()
        .map(|path| check_single_file(path, adapters))
        .collect();

    let mut summary = CheckSummary::new();
    for (path, result, message) in results {
        summary.add_result(path, result, message);
    }

    Ok(summary)
}

fn check_single_file(
    path: &PathBuf,
    adapters: &[Box<dyn Adapter>],
) -> (PathBuf, CheckResult, Option<String>) {
    // Check if any adapter supports this file
    let mut supported_adapter = None;
    for adapter in adapters {
        if adapter.supports(path) {
            supported_adapter = Some(adapter);
            break;
        }
    }
    
    let Some(adapter) = supported_adapter else {
        // File not supported, skip silently
        return (path.clone(), CheckResult::Valid, None);
    };

    // Read source file
    let text = match fs::read_to_string(path) {
        Ok(content) => content,
        Err(e) => return (path.clone(), CheckResult::Invalid, Some(format!("Can't read source: {}", e))),
    };

    // Parse frontmatter to get sidecar location
    let head = text.lines().take(80).collect::<Vec<_>>().join("\n");
    let fm = parse_card(&head);
    let agentmap_ref = fm.as_ref().and_then(|c| c.agentmap.clone());
    let sidecar_file = sidecar_path(path, &agentmap_ref);

    // Check if sidecar file exists
    let sidecar_content = match fs::read_to_string(&sidecar_file) {
        Ok(content) => content,
        Err(_) => return (path.clone(), CheckResult::Missing, Some(format!("Sidecar not found: {}", sidecar_file.display()))),
    };

    // Parse sidecar file
    let existing_sidecar: Sidecar = match serde_yaml::from_str(&sidecar_content) {
        Ok(sc) => sc,
        Err(e) => return (path.clone(), CheckResult::Invalid, Some(format!("Invalid sidecar YAML: {}", e))),
    };

    // Check source hash
    let current_hash = sha16(&text);
    if existing_sidecar.source_hash != current_hash {
        return (path.clone(), CheckResult::Outdated, Some("Source file has changed since sidecar was generated".to_string()));
    }

    // Generate current analysis to compare
    let ctx = FileCtx { path, text: &text };
    let current_analysis = match adapter.analyze(&ctx) {
        Ok(analysis) => analysis,
        Err(e) => return (path.clone(), CheckResult::Invalid, Some(format!("Analysis failed: {}", e))),
    };

    // Compare key analysis results
    if existing_sidecar.symbols.len() != current_analysis.symbols.len() ||
       existing_sidecar.regions.len() != current_analysis.regions.len() {
        return (path.clone(), CheckResult::Outdated, Some("Symbol/region count mismatch - analysis has changed".to_string()));
    }

    // If we get here, everything looks good
    (path.clone(), CheckResult::Valid, None)
}