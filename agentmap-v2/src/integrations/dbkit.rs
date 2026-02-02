//! db-kit integration for AgentMap.
//!
//! Provides a bridge between AgentMap's analysis output and db-kit's storage layer.
//!
//! # Example
//!
//! ```rust,ignore
//! use agentmap::integrations::DbKitBridge;
//! use db_kit::{DatabasePool, Sqlite, PoolConfig};
//!
//! // Open database
//! let pool = DatabasePool::<Sqlite>::open("agentmap.db", PoolConfig::default()).await?;
//!
//! // Create bridge
//! let bridge = DbKitBridge::new(pool);
//! bridge.init().await?;
//!
//! // Index analysis results
//! let analysis = agent.analyze_file("src/main.rs")?;
//! bridge.index_analysis(&analysis, project_id).await?;
//! ```

use std::collections::HashMap;
use std::sync::Arc;
use anyhow::{Context, Result};

// Re-export db-kit types for convenience
pub use db_kit_lib::{DatabasePool, Sqlite, PoolConfig};
pub use db_kit_lib::extensions::agentmap::{
    AgentMapExt, AgentMapIndexer, AgentMapQueries,
    SymbolBuilder, RelationshipBuilder, ImportBuilder, FileUpdateBuilder,
    Symbol as DbSymbol, Relationship as DbRelationship, File as DbFile,
};

use crate::{CodeAnalysis, Symbol, Relationship, SymbolKind, Visibility, RelationshipKind};

/// Configuration for the db-kit bridge.
#[derive(Debug, Clone)]
pub struct BridgeConfig {
    /// Whether to store code content in the database.
    pub store_code_content: bool,

    /// Whether to store documentation.
    pub store_documentation: bool,

    /// Whether to delete existing symbols before re-indexing a file.
    pub replace_on_reindex: bool,

    /// Maximum batch size for bulk inserts.
    pub batch_size: usize,
}

impl Default for BridgeConfig {
    fn default() -> Self {
        Self {
            store_code_content: true,
            store_documentation: true,
            replace_on_reindex: true,
            batch_size: 100,
        }
    }
}

/// Symbol data prepared for db-kit insertion.
#[derive(Debug, Clone)]
pub struct SymbolRecord {
    pub file_id: i64,
    pub name: String,
    pub qualified_name: String,
    pub kind: String,
    pub language: String,
    pub start_line: i64,
    pub start_column: i64,
    pub end_line: i64,
    pub end_column: i64,
    pub visibility: String,
    pub is_exported: bool,
    pub docstring: Option<String>,
    pub code_content: Option<String>,
}

/// Relationship data prepared for db-kit insertion.
#[derive(Debug, Clone)]
pub struct RelationshipRecord {
    pub source_id: i64,
    pub target_id: i64,
    pub relation_type: String,
    pub file_id: i64,
    pub line: i64,
    pub confidence: f64,
}

/// Import data prepared for db-kit insertion.
#[derive(Debug, Clone)]
pub struct ImportRecord {
    pub file_id: i64,
    pub module_path: String,
    pub imported_name: Option<String>,
    pub local_name: Option<String>,
    pub import_kind: String,
    pub line: i64,
    pub is_wildcard: bool,
}

/// Result of indexing a single file.
#[derive(Debug, Clone)]
pub struct IndexResult {
    /// File ID in the database.
    pub file_id: i64,

    /// Number of symbols indexed.
    pub symbol_count: usize,

    /// Number of relationships indexed.
    pub relationship_count: usize,

    /// Number of imports indexed.
    pub import_count: usize,

    /// Mapping from AgentMap SymbolId string to db-kit i64 ID.
    pub symbol_id_map: HashMap<String, i64>,
}

/// Convert AgentMap's SymbolKind to db-kit string representation.
pub fn symbol_kind_to_string(kind: SymbolKind) -> String {
    match kind {
        SymbolKind::Function => "function",
        SymbolKind::Method => "method",
        SymbolKind::Constructor => "constructor",
        SymbolKind::AsyncFunction => "async_function",
        SymbolKind::Generator => "generator",
        SymbolKind::Lambda => "lambda",
        SymbolKind::Class => "class",
        SymbolKind::Struct => "struct",
        SymbolKind::Interface => "interface",
        SymbolKind::Trait => "trait",
        SymbolKind::Enum => "enum",
        SymbolKind::TypeAlias => "type_alias",
        SymbolKind::Variable => "variable",
        SymbolKind::Constant => "constant",
        SymbolKind::Parameter => "parameter",
        SymbolKind::Field => "field",
        SymbolKind::Property => "property",
        SymbolKind::Module => "module",
        SymbolKind::Namespace => "namespace",
        SymbolKind::Package => "package",
        SymbolKind::Import => "import",
        SymbolKind::Export => "export",
        SymbolKind::Macro => "macro",
        SymbolKind::Decorator => "decorator",
        SymbolKind::Annotation => "annotation",
        SymbolKind::Unknown => "unknown",
    }.to_string()
}

/// Convert AgentMap's Visibility to db-kit string representation.
pub fn visibility_to_string(visibility: Visibility) -> String {
    match visibility {
        Visibility::Public => "public",
        Visibility::Private => "private",
        Visibility::Protected => "protected",
        Visibility::Internal => "internal",
        Visibility::Unspecified => "unspecified",
    }.to_string()
}

/// Convert AgentMap's RelationshipKind to db-kit string representation.
pub fn relationship_kind_to_string(kind: RelationshipKind) -> String {
    match kind {
        RelationshipKind::Inherits => "extends",
        RelationshipKind::Implements => "implements",
        RelationshipKind::TypeOf => "type_of",
        RelationshipKind::HasField => "has_field",
        RelationshipKind::HasMethod => "has_method",
        RelationshipKind::Contains => "contains",
        RelationshipKind::Imports => "imports",
        RelationshipKind::Uses => "uses",
        RelationshipKind::Calls => "calls",
        RelationshipKind::Instantiates => "instantiates",
        RelationshipKind::References => "references",
        RelationshipKind::Returns => "returns",
        RelationshipKind::TakesParam => "takes_param",
        RelationshipKind::Exports => "exports",
        RelationshipKind::ReExports => "re_exports",
        RelationshipKind::DecoratedBy => "decorates",
        RelationshipKind::Unknown => "unknown",
    }.to_string()
}

/// Convert a Symbol to a SymbolRecord for db-kit insertion.
pub fn symbol_to_record(symbol: &Symbol, file_id: i64, language: &str, config: &BridgeConfig) -> SymbolRecord {
    SymbolRecord {
        file_id,
        name: symbol.name.clone(),
        qualified_name: symbol.fully_qualified_name(),
        kind: symbol_kind_to_string(symbol.kind),
        language: language.to_string(),
        start_line: symbol.location.start_line as i64,
        start_column: symbol.location.start_column as i64,
        end_line: symbol.location.end_line as i64,
        end_column: symbol.location.end_column as i64,
        visibility: visibility_to_string(symbol.visibility),
        is_exported: matches!(symbol.visibility, Visibility::Public),
        docstring: if config.store_documentation {
            symbol.documentation.clone()
        } else {
            None
        },
        code_content: if config.store_code_content {
            Some(symbol.code_content.clone())
        } else {
            None
        },
    }
}

/// Convert a Relationship to a RelationshipRecord for db-kit insertion.
///
/// Returns None if the source or target symbol IDs are not in the id_map.
pub fn relationship_to_record(
    rel: &Relationship,
    file_id: i64,
    id_map: &HashMap<String, i64>,
) -> Option<RelationshipRecord> {
    let source_id = id_map.get(&rel.from.0)?;
    let target_id = id_map.get(&rel.to.0)?;

    Some(RelationshipRecord {
        source_id: *source_id,
        target_id: *target_id,
        relation_type: relationship_kind_to_string(rel.kind),
        file_id,
        line: rel.location.start_line as i64,
        confidence: rel.confidence as f64,
    })
}

/// Prepare a CodeAnalysis for db-kit storage.
///
/// This function converts all symbols, relationships, and imports to db-kit records.
/// It does NOT perform the actual database operations - that's the responsibility
/// of the caller using the db-kit extension traits.
pub fn prepare_analysis(
    analysis: &CodeAnalysis,
    file_id: i64,
    config: &BridgeConfig,
) -> (Vec<SymbolRecord>, Vec<ImportRecord>) {
    let language = analysis.language.to_string();

    // Convert symbols
    let symbols: Vec<SymbolRecord> = analysis.symbols.iter()
        .map(|s| symbol_to_record(s, file_id, &language, config))
        .collect();

    // Convert imports
    let imports: Vec<ImportRecord> = analysis.imports.iter()
        .flat_map(|imp| {
            if imp.imported_names.is_empty() {
                // Wildcard or module import
                vec![ImportRecord {
                    file_id,
                    module_path: imp.source.clone(),
                    imported_name: None,
                    local_name: imp.module_alias.clone(),
                    import_kind: if imp.is_wildcard { "wildcard" } else { "module" }.to_string(),
                    line: imp.location.start_line as i64,
                    is_wildcard: imp.is_wildcard,
                }]
            } else {
                // Named imports
                imp.imported_names.iter().map(|name| ImportRecord {
                    file_id,
                    module_path: imp.source.clone(),
                    imported_name: Some(name.name.clone()),
                    local_name: name.alias.clone(),
                    import_kind: "named".to_string(),
                    line: imp.location.start_line as i64,
                    is_wildcard: false,
                }).collect()
            }
        })
        .collect();

    (symbols, imports)
}

/// Build the symbol ID map after symbols have been inserted.
///
/// This maps AgentMap's string-based SymbolIds to db-kit's i64 IDs.
pub fn build_symbol_id_map(
    analysis: &CodeAnalysis,
    db_symbol_ids: &[i64],
) -> HashMap<String, i64> {
    analysis.symbols.iter()
        .zip(db_symbol_ids.iter())
        .map(|(symbol, &db_id)| (symbol.id.0.clone(), db_id))
        .collect()
}

/// Compute a content hash for a file using SHA256.
pub fn compute_file_hash(content: &str) -> String {
    use sha2::{Sha256, Digest};

    let mut hasher = Sha256::new();
    hasher.update(content.as_bytes());
    let result = hasher.finalize();
    format!("{:064x}", result)
}

// ============================================================================
// High-Level Bridge API
// ============================================================================

/// High-level bridge for indexing AgentMap analysis results to db-kit.
///
/// This struct wraps a db-kit DatabasePool and provides a convenient API
/// for indexing code analysis results.
pub struct DbKitBridge {
    pool: Arc<DatabasePool<Sqlite>>,
    config: BridgeConfig,
}

impl DbKitBridge {
    /// Create a new bridge with a database pool.
    pub fn new(pool: DatabasePool<Sqlite>) -> Self {
        Self {
            pool: Arc::new(pool),
            config: BridgeConfig::default(),
        }
    }

    /// Create a new bridge with custom configuration.
    pub fn with_config(pool: DatabasePool<Sqlite>, config: BridgeConfig) -> Self {
        Self {
            pool: Arc::new(pool),
            config,
        }
    }

    /// Initialize the AgentMap schema in the database.
    pub async fn init(&self) -> Result<()> {
        self.pool.agentmap_init().await
            .context("Failed to initialize AgentMap schema")
    }

    /// Check if the schema is initialized.
    pub async fn is_initialized(&self) -> Result<bool> {
        self.pool.agentmap_is_initialized().await
            .context("Failed to check schema initialization")
    }

    /// Get or create a project.
    pub async fn ensure_project(&self, name: &str, root_path: &str) -> Result<i64> {
        self.pool.agentmap_upsert_project(name, root_path).await
            .context("Failed to upsert project")
    }

    /// Index a single file's analysis results.
    ///
    /// This is the main entry point for indexing. It:
    /// 1. Creates/updates the file record
    /// 2. Deletes existing symbols for the file (if replace_on_reindex)
    /// 3. Batch inserts all symbols (single transaction)
    /// 4. Batch inserts all relationships (single transaction)
    ///
    /// Returns an IndexResult with the file ID and symbol ID mapping.
    pub async fn index_analysis(
        &self,
        analysis: &CodeAnalysis,
        project_id: i64,
        content_hash: &str,
    ) -> Result<IndexResult> {
        let path = analysis.file_path.to_string_lossy().to_string();
        let language = analysis.language.to_string();

        // Upsert file
        let file_id = self.pool.agentmap_upsert_file(project_id, &path, content_hash, &language)
            .await
            .context("Failed to upsert file")?;

        // Delete existing data if configured
        if self.config.replace_on_reindex {
            self.pool.agentmap_delete_file_symbols(file_id)
                .await
                .context("Failed to delete existing symbols")?;
            self.pool.agentmap_delete_file_imports(file_id)
                .await
                .context("Failed to delete existing imports")?;
        }

        // Prepare symbols and imports
        let (symbol_records, import_records) = prepare_analysis(analysis, file_id, &self.config);

        // Convert to SymbolBuilder for batch insert
        let symbol_builders: Vec<SymbolBuilder> = symbol_records.iter().map(|record| {
            SymbolBuilder {
                file_id: record.file_id,
                name: record.name.clone(),
                qualified_name: record.qualified_name.clone(),
                kind: record.kind.clone(),
                language: record.language.clone(),
                start_line: record.start_line,
                start_column: record.start_column,
                end_line: record.end_line,
                end_column: record.end_column,
                visibility: record.visibility.clone(),
                is_exported: record.is_exported,
            }
        }).collect();

        // Batch insert symbols (uses transaction internally)
        let db_symbol_ids = self.pool.agentmap_insert_symbols_batch(&symbol_builders)
            .await
            .context("Failed to batch insert symbols")?;

        // Build ID map
        let symbol_id_map = build_symbol_id_map(analysis, &db_symbol_ids);

        // Prepare relationships
        let relationship_builders: Vec<RelationshipBuilder> = analysis.relationships.iter()
            .filter_map(|rel| {
                relationship_to_record(rel, file_id, &symbol_id_map).map(|record| {
                    RelationshipBuilder {
                        source_id: record.source_id,
                        target_id: record.target_id,
                        relation_type: record.relation_type,
                    }
                })
            })
            .collect();

        // Batch insert relationships (uses transaction internally)
        let rel_ids = self.pool.agentmap_insert_relationships_batch(&relationship_builders)
            .await
            .context("Failed to batch insert relationships")?;

        // Convert ImportRecords to ImportBuilders and batch insert
        let import_builders: Vec<ImportBuilder> = import_records.iter().map(|record| {
            ImportBuilder {
                file_id: record.file_id,
                line: record.line,
                column: None,
                module_path: record.module_path.clone(),
                is_relative: false, // Could be detected from module_path
                is_external: !record.module_path.starts_with('.'),
                package_name: None,
                import_kind: record.import_kind.clone(),
                imported_name: record.imported_name.clone(),
                local_name: record.local_name.clone(),
                is_type_only: false,
            }
        }).collect();

        let import_ids = self.pool.agentmap_insert_imports_batch(&import_builders)
            .await
            .context("Failed to batch insert imports")?;

        Ok(IndexResult {
            file_id,
            symbol_count: db_symbol_ids.len(),
            relationship_count: rel_ids.len(),
            import_count: import_ids.len(),
            symbol_id_map,
        })
    }

    /// Index a file's analysis results with content for metadata computation.
    ///
    /// This enhanced version also computes and stores file metadata like line count and size.
    pub async fn index_analysis_with_content(
        &self,
        analysis: &CodeAnalysis,
        project_id: i64,
        content: &str,
    ) -> Result<IndexResult> {
        let content_hash = compute_file_hash(content);
        let result = self.index_analysis(analysis, project_id, &content_hash).await?;

        // Compute and update file metadata
        let line_count = content.lines().count() as i64;
        let size_bytes = content.len() as i64;

        // Detect if this is a test file
        let path_str = analysis.file_path.to_string_lossy().to_lowercase();
        let is_test_file = path_str.contains("test")
            || path_str.contains("spec")
            || path_str.contains("_test.")
            || path_str.contains(".test.");

        let update = FileUpdateBuilder {
            file_id: result.file_id,
            size_bytes: Some(size_bytes),
            line_count: Some(line_count),
            file_type: None,
            is_test_file: Some(is_test_file),
            is_generated: None,
            is_entry_point: None,
            architecture_layer: None,
        };

        self.update_file_metadata(&update).await?;

        Ok(result)
    }

    /// Index multiple analysis results in batch.
    pub async fn index_batch(
        &self,
        analyses: &[CodeAnalysis],
        project_id: i64,
        content_hashes: &[String],
    ) -> Result<Vec<IndexResult>> {
        let mut results = Vec::with_capacity(analyses.len());

        for (analysis, hash) in analyses.iter().zip(content_hashes.iter()) {
            let result = self.index_analysis(analysis, project_id, hash).await?;
            results.push(result);
        }

        Ok(results)
    }

    /// Query symbols by name.
    pub async fn find_symbols_by_name(&self, name: &str) -> Result<Vec<DbSymbol>> {
        self.pool.agentmap_find_symbols_by_name(name).await
            .context("Failed to find symbols by name")
    }

    /// Get all symbols in a file.
    pub async fn get_file_symbols(&self, file_id: i64) -> Result<Vec<DbSymbol>> {
        self.pool.agentmap_get_file_symbols(file_id).await
            .context("Failed to get file symbols")
    }

    /// Get outgoing relationships from a symbol.
    pub async fn get_outgoing_relationships(&self, symbol_id: i64) -> Result<Vec<DbRelationship>> {
        self.pool.agentmap_get_outgoing(symbol_id).await
            .context("Failed to get outgoing relationships")
    }

    /// Get incoming relationships to a symbol.
    pub async fn get_incoming_relationships(&self, symbol_id: i64) -> Result<Vec<DbRelationship>> {
        self.pool.agentmap_get_incoming(symbol_id).await
            .context("Failed to get incoming relationships")
    }

    /// Get a file by path.
    pub async fn get_file_by_path(&self, path: &str) -> Result<Option<DbFile>> {
        self.pool.agentmap_get_file_by_path(path).await
            .context("Failed to get file by path")
    }

    /// Delete a file and all its associated data (symbols, relationships, imports).
    pub async fn delete_file(&self, file_id: i64) -> Result<()> {
        self.pool.agentmap_delete_file(file_id).await
            .context("Failed to delete file")
    }

    /// Delete a file by path.
    pub async fn delete_file_by_path(&self, path: &str) -> Result<bool> {
        if let Some(file) = self.get_file_by_path(path).await? {
            self.delete_file(file.id).await?;
            Ok(true)
        } else {
            Ok(false)
        }
    }

    /// Update file metadata (line count, size, type classification).
    pub async fn update_file_metadata(&self, update: &FileUpdateBuilder) -> Result<()> {
        self.pool.agentmap_update_file_metadata(update).await
            .context("Failed to update file metadata")
    }

    /// Get the underlying pool for advanced operations.
    pub fn pool(&self) -> &DatabasePool<Sqlite> {
        &self.pool
    }
}

/// Open a new db-kit bridge with default configuration.
///
/// This is a convenience function for quickly setting up a bridge.
pub async fn open_bridge(db_path: &str) -> Result<DbKitBridge> {
    let pool = DatabasePool::<Sqlite>::open(db_path, PoolConfig::default())
        .await
        .context("Failed to open database")?;

    let bridge = DbKitBridge::new(pool);
    bridge.init().await?;

    Ok(bridge)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::core::SourceLocation;
    use std::path::PathBuf;

    fn make_test_symbol() -> Symbol {
        let loc = SourceLocation {
            file_path: PathBuf::from("test.rs"),
            start_line: 10,
            start_column: 0,
            end_line: 20,
            end_column: 1,
            byte_offset: 100,
            byte_length: 500,
        };

        Symbol::new("test_function", SymbolKind::Function, loc)
            .with_visibility(Visibility::Public)
            .with_code("fn test_function() {}")
            .with_docs("A test function.")
    }

    #[test]
    fn test_symbol_to_record() {
        let symbol = make_test_symbol();
        let config = BridgeConfig::default();
        let record = symbol_to_record(&symbol, 1, "rust", &config);

        assert_eq!(record.name, "test_function");
        assert_eq!(record.kind, "function");
        assert_eq!(record.visibility, "public");
        assert!(record.is_exported);
        assert!(record.docstring.is_some());
        assert!(record.code_content.is_some());
    }

    #[test]
    fn test_symbol_to_record_without_content() {
        let symbol = make_test_symbol();
        let config = BridgeConfig {
            store_code_content: false,
            store_documentation: false,
            ..Default::default()
        };
        let record = symbol_to_record(&symbol, 1, "rust", &config);

        assert!(record.docstring.is_none());
        assert!(record.code_content.is_none());
    }

    #[test]
    fn test_kind_conversions() {
        assert_eq!(symbol_kind_to_string(SymbolKind::Function), "function");
        assert_eq!(symbol_kind_to_string(SymbolKind::Class), "class");
        assert_eq!(symbol_kind_to_string(SymbolKind::AsyncFunction), "async_function");
    }

    #[test]
    fn test_relationship_kind_conversions() {
        assert_eq!(relationship_kind_to_string(RelationshipKind::Calls), "calls");
        assert_eq!(relationship_kind_to_string(RelationshipKind::Inherits), "extends");
        assert_eq!(relationship_kind_to_string(RelationshipKind::Implements), "implements");
    }

    #[test]
    fn test_compute_file_hash() {
        let hash1 = compute_file_hash("fn main() {}");
        let hash2 = compute_file_hash("fn main() {}");
        let hash3 = compute_file_hash("fn main() { println!(); }");

        assert_eq!(hash1, hash2);
        assert_ne!(hash1, hash3);
        // SHA256 produces 64 hex characters
        assert_eq!(hash1.len(), 64);
    }
}
