use serde::{Deserialize, Serialize};
use std::{collections::HashMap, path::PathBuf};
use anyhow::Result;

#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct SymbolDefinition {
    pub name: String,
    pub kind: String,
    pub file: PathBuf,
    pub line: u32,
    pub end_line: u32,
    pub scope: Option<String>,
}

#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct SymbolUsage {
    pub symbol: String,
    pub file: PathBuf,
    pub line: u32,
    pub context: UsageContext,
}

#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct UsageContext {
    pub usage_type: String, // "call", "access", "reference", etc.
    pub enclosing: Option<EnclosingScope>,
}

#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct EnclosingScope {
    pub scope_type: String, // "method", "class", "function", etc.
    pub name: String,
    pub range: (u32, u32),
}

#[derive(Debug, Serialize, Deserialize, Default)]
pub struct ProjectSymbolTable {
    pub definitions: HashMap<String, Vec<SymbolDefinition>>,
    pub usages: HashMap<String, Vec<SymbolUsage>>,
    pub imports: HashMap<PathBuf, Vec<ImportInfo>>,
    pub aliases: HashMap<String, String>, // alias -> original mapping
}

#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct ImportInfo {
    pub module: String,
    pub imported_name: Option<String>,
    pub alias: Option<String>,
    pub line: u32,
}

impl ProjectSymbolTable {
    pub fn new() -> Self {
        Self::default()
    }
    
    pub fn add_definition(&mut self, def: SymbolDefinition) {
        self.definitions
            .entry(def.name.clone())
            .or_default()
            .push(def);
    }
    
    pub fn add_usage(&mut self, usage: SymbolUsage) {
        self.usages
            .entry(usage.symbol.clone())
            .or_default()
            .push(usage);
    }
    
    pub fn add_import(&mut self, file: PathBuf, import: ImportInfo) {
        self.imports
            .entry(file)
            .or_default()
            .push(import);
    }
    
    pub fn add_alias(&mut self, alias: String, original: String) {
        self.aliases.insert(alias, original);
    }
    
    pub fn resolve_symbol(&self, name: &str) -> Option<&Vec<SymbolDefinition>> {
        // First try direct lookup
        if let Some(defs) = self.definitions.get(name) {
            return Some(defs);
        }
        
        // Try resolving through aliases
        if let Some(original) = self.aliases.get(name) {
            return self.definitions.get(original);
        }
        
        None
    }
    
    pub fn find_symbol_usages(&self, symbol: &str) -> Option<&Vec<SymbolUsage>> {
        self.usages.get(symbol)
    }
    
    pub fn get_cross_references(&self, symbol: &str) -> CrossReferences {
        let definitions = self.resolve_symbol(symbol).cloned().unwrap_or_default();
        let usages = self.find_symbol_usages(symbol).cloned().unwrap_or_default();
        
        let total_refs = usages.len();
        let files_count = count_unique_files(&usages);
        
        CrossReferences {
            symbol: symbol.to_string(),
            definitions,
            usages,
            total_refs,
            files_count,
        }
    }
    
    pub fn query_symbols_by_pattern(&self, pattern: &str) -> Vec<String> {
        self.definitions
            .keys()
            .filter(|name| name.contains(pattern))
            .cloned()
            .collect()
    }
    
    pub fn get_symbols_in_file(&self, file: &PathBuf) -> Vec<&SymbolDefinition> {
        self.definitions
            .values()
            .flatten()
            .filter(|def| &def.file == file)
            .collect()
    }
    
    pub fn get_usage_stats(&self) -> SymbolStats {
        let total_symbols = self.definitions.len();
        let total_definitions = self.definitions.values().map(|v| v.len()).sum();
        let total_usages = self.usages.values().map(|v| v.len()).sum();
        
        let most_used = self.usages
            .iter()
            .max_by_key(|(_, usages)| usages.len())
            .map(|(name, usages)| (name.clone(), usages.len()));
        
        SymbolStats {
            total_symbols,
            total_definitions,
            total_usages,
            most_used_symbol: most_used,
        }
    }
}

#[derive(Debug, Serialize)]
pub struct CrossReferences {
    pub symbol: String,
    pub definitions: Vec<SymbolDefinition>,
    pub usages: Vec<SymbolUsage>,
    pub total_refs: usize,
    pub files_count: usize,
}

#[derive(Debug, Serialize)]
pub struct SymbolStats {
    pub total_symbols: usize,
    pub total_definitions: usize,
    pub total_usages: usize,
    pub most_used_symbol: Option<(String, usize)>,
}

fn count_unique_files(usages: &[SymbolUsage]) -> usize {
    let mut files: Vec<_> = usages.iter().map(|u| &u.file).collect();
    files.sort_unstable();
    files.dedup();
    files.len()
}