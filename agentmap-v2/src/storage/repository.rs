//! Embedding repository for SQLite persistence.
//!
//! Provides CRUD operations for symbol embeddings and code relationships.

use std::path::Path;
use std::sync::Arc;
use parking_lot::RwLock;
use std::collections::HashMap;

use crate::core::{Result, Error};
use super::vector::{embedding_to_blob, try_blob_to_embedding, cosine_similarity};
use super::schema::SCHEMA;


/// Metadata for a stored embedding.
#[derive(Debug, Clone)]
pub struct EmbeddingMetadata {
    pub symbol_id: String,
    pub symbol_name: String,
    pub symbol_kind: String,
    pub file_path: String,
    pub content_hash: String,
    pub embedding_model: String,
}

/// Search result from similarity search.
#[derive(Debug, Clone)]
pub struct SearchResult {
    pub symbol_id: String,
    pub symbol_name: String,
    pub symbol_kind: String,
    pub file_path: String,
    pub similarity: f32,
}

/// Repository for embedding storage and retrieval.
///
/// Uses SQLite for persistence with in-memory caching for search.
pub struct EmbeddingRepository {
    /// In-memory cache of embeddings for fast search
    embeddings: Arc<RwLock<HashMap<String, (Vec<f32>, EmbeddingMetadata)>>>,
    /// Database path for persistence
    db_path: std::path::PathBuf,
    /// Whether database is initialized
    initialized: Arc<RwLock<bool>>,
}

impl EmbeddingRepository {
    /// Open or create an embedding repository at the given path.
    ///
    /// Creates parent directories and initializes schema if needed.
    pub async fn open(path: impl AsRef<Path>) -> Result<Self> {
        let db_path = path.as_ref().to_path_buf();

        // Create parent directories
        if let Some(parent) = db_path.parent() {
            std::fs::create_dir_all(parent).map_err(|e| {
                Error::io_error("create directory", e)
            })?;
        }

        let repo = Self {
            embeddings: Arc::new(RwLock::new(HashMap::new())),
            db_path,
            initialized: Arc::new(RwLock::new(false)),
        };

        // Initialize database
        repo.initialize().await?;

        Ok(repo)
    }

    /// Initialize the database schema.
    async fn initialize(&self) -> Result<()> {
        use rusqlite::Connection;

        let path = self.db_path.clone();

        // Run in blocking context since rusqlite is sync
        tokio::task::spawn_blocking(move || {
            let conn = Connection::open(&path).map_err(|e| {
                Error::database(format!("Failed to open database: {}", e))
            })?;

            conn.execute_batch(SCHEMA).map_err(|e| {
                Error::database(format!("Failed to initialize schema: {}", e))
            })?;

            Ok::<(), Error>(())
        }).await.map_err(|e| Error::internal(format!("Task join error: {}", e)))??;

        *self.initialized.write() = true;

        // Load existing embeddings into cache
        self.load_cache().await?;

        Ok(())
    }

    /// Load embeddings from database into memory cache.
    async fn load_cache(&self) -> Result<()> {
        use rusqlite::Connection;

        let path = self.db_path.clone();

        let rows = tokio::task::spawn_blocking(move || {
            let conn = Connection::open(&path)?;

            let mut stmt = conn.prepare(
                "SELECT symbol_id, symbol_name, symbol_kind, file_path, content_hash, \
                        embedding_model, embedding, embedding_dims \
                 FROM symbol_embeddings"
            )?;

            let results: Vec<_> = stmt.query_map([], |row| {
                Ok((
                    row.get::<_, String>(0)?,  // symbol_id
                    row.get::<_, String>(1)?,  // symbol_name
                    row.get::<_, String>(2)?,  // symbol_kind
                    row.get::<_, String>(3)?,  // file_path
                    row.get::<_, String>(4)?,  // content_hash
                    row.get::<_, String>(5)?,  // embedding_model
                    row.get::<_, Vec<u8>>(6)?, // embedding
                    row.get::<_, i32>(7)?,     // embedding_dims
                ))
            })?.collect::<std::result::Result<Vec<_>, _>>()?;

            Ok::<_, rusqlite::Error>(results)
        }).await.map_err(|e| Error::internal(format!("Task join error: {}", e)))?
          .map_err(|e: rusqlite::Error| Error::database(format!("Load cache failed: {}", e)))?;

        let mut cache = self.embeddings.write();
        for (symbol_id, symbol_name, symbol_kind, file_path, content_hash, embedding_model, blob, _dims) in rows {
            // Skip corrupted embeddings instead of panicking
            let embedding = match try_blob_to_embedding(&blob) {
                Ok(e) => e,
                Err(_) => {
                    // Log would go here in production
                    continue;
                }
            };
            let metadata = EmbeddingMetadata {
                symbol_id: symbol_id.clone(),
                symbol_name,
                symbol_kind,
                file_path,
                content_hash,
                embedding_model,
            };
            cache.insert(symbol_id, (embedding, metadata));
        }


        Ok(())
    }

    /// Store an embedding for a symbol.
    ///
    /// Upserts if symbol_id already exists.
    pub async fn store_embedding(
        &self,
        metadata: EmbeddingMetadata,
        embedding: &[f32],
    ) -> Result<()> {
        use rusqlite::Connection;

        let blob = embedding_to_blob(embedding);
        let dims = embedding.len() as i32;

        let path = self.db_path.clone();
        let meta = metadata.clone();
        let embedding_vec = embedding.to_vec();

        tokio::task::spawn_blocking(move || {
            let conn = Connection::open(&path)?;

            conn.execute(
                "INSERT INTO symbol_embeddings
                    (symbol_id, file_path, symbol_name, symbol_kind, embedding,
                     embedding_dims, embedding_model, content_hash)
                 VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8)
                 ON CONFLICT(symbol_id) DO UPDATE SET
                    file_path = excluded.file_path,
                    symbol_name = excluded.symbol_name,
                    symbol_kind = excluded.symbol_kind,
                    embedding = excluded.embedding,
                    embedding_dims = excluded.embedding_dims,
                    embedding_model = excluded.embedding_model,
                    content_hash = excluded.content_hash,
                    updated_at = datetime('now')",
                rusqlite::params![
                    meta.symbol_id,
                    meta.file_path,
                    meta.symbol_name,
                    meta.symbol_kind,
                    blob,
                    dims,
                    meta.embedding_model,
                    meta.content_hash,
                ],
            )?;

            Ok::<_, rusqlite::Error>(())
        }).await.map_err(|e| Error::internal(format!("Task join error: {}", e)))?
          .map_err(|e: rusqlite::Error| Error::database(format!("Store embedding failed: {}", e)))?;

        // Update cache
        self.embeddings.write().insert(
            metadata.symbol_id.clone(),
            (embedding_vec, metadata),
        );

        Ok(())
    }

    /// Check if a symbol's embedding is stale (content changed).
    pub fn is_stale(&self, symbol_id: &str, current_hash: &str) -> bool {
        let cache = self.embeddings.read();
        match cache.get(symbol_id) {
            Some((_, meta)) => meta.content_hash != current_hash,
            None => true, // Not in cache = needs embedding
        }
    }

    /// Search for similar embeddings using brute-force cosine similarity.
    ///
    /// Returns top `limit` results sorted by similarity (descending).
    pub fn search_similar(&self, query: &[f32], limit: usize) -> Vec<SearchResult> {
        let cache = self.embeddings.read();

        let mut results: Vec<_> = cache
            .iter()
            .filter_map(|(_, (embedding, meta))| {
                if embedding.len() != query.len() {
                    return None;
                }
                let similarity = cosine_similarity(query, embedding);
                Some(SearchResult {
                    symbol_id: meta.symbol_id.clone(),
                    symbol_name: meta.symbol_name.clone(),
                    symbol_kind: meta.symbol_kind.clone(),
                    file_path: meta.file_path.clone(),
                    similarity,
                })
            })
            .collect();

        // Sort by similarity descending
        results.sort_by(|a, b| {
            b.similarity.partial_cmp(&a.similarity).unwrap_or(std::cmp::Ordering::Equal)
        });

        results.truncate(limit);
        results
    }

    /// Get embedding for a specific symbol.
    pub fn get_embedding(&self, symbol_id: &str) -> Option<(Vec<f32>, EmbeddingMetadata)> {
        self.embeddings.read().get(symbol_id).cloned()
    }

    /// Delete all embeddings for a file (used when re-indexing).
    pub async fn delete_file_embeddings(&self, file_path: &str) -> Result<usize> {
        use rusqlite::Connection;

        let path = self.db_path.clone();
        let file = file_path.to_string();

        let deleted = tokio::task::spawn_blocking(move || {
            let conn = Connection::open(&path)?;

            let count = conn.execute(
                "DELETE FROM symbol_embeddings WHERE file_path = ?1",
                [&file],
            )?;

            Ok::<_, rusqlite::Error>(count)
        }).await.map_err(|e| Error::internal(format!("Task join error: {}", e)))?
          .map_err(|e: rusqlite::Error| Error::database(format!("Delete failed: {}", e)))?;

        // Update cache
        {
            let mut cache = self.embeddings.write();
            cache.retain(|_, (_, meta)| meta.file_path != file_path);
        }

        Ok(deleted)
    }

    /// Get the number of stored embeddings.
    pub fn count(&self) -> usize {
        self.embeddings.read().len()
    }

    /// Store a code relationship.
    pub async fn store_relationship(
        &self,
        source_id: &str,
        target_id: &str,
        rel_type: &str,
        weight: f32,
    ) -> Result<()> {
        use rusqlite::Connection;

        let path = self.db_path.clone();
        let src = source_id.to_string();
        let tgt = target_id.to_string();
        let rtype = rel_type.to_string();

        tokio::task::spawn_blocking(move || {
            let conn = Connection::open(&path)?;

            conn.execute(
                "INSERT INTO code_relationships
                    (source_symbol_id, target_symbol_id, relationship_type, weight)
                 VALUES (?1, ?2, ?3, ?4)
                 ON CONFLICT(source_symbol_id, target_symbol_id, relationship_type) DO UPDATE SET
                    weight = excluded.weight",
                rusqlite::params![src, tgt, rtype, weight],
            )?;

            Ok::<_, rusqlite::Error>(())
        }).await.map_err(|e| Error::internal(format!("Task join error: {}", e)))?
          .map_err(|e: rusqlite::Error| Error::database(format!("Store relationship failed: {}", e)))?;

        Ok(())
    }

    /// Get related symbols (graph traversal helper).
    pub async fn get_related(
        &self,
        symbol_id: &str,
        rel_type: Option<&str>,
        limit: usize,
    ) -> Result<Vec<(String, String, f32)>> {
        use rusqlite::Connection;

        let path = self.db_path.clone();
        let sym = symbol_id.to_string();
        let rtype = rel_type.map(|s| s.to_string());

        let results = tokio::task::spawn_blocking(move || {
            let conn = Connection::open(&path)?;

            let sql = match &rtype {
                Some(_) =>
                    "SELECT target_symbol_id, relationship_type, weight
                     FROM code_relationships
                     WHERE source_symbol_id = ?1 AND relationship_type = ?2
                     ORDER BY weight DESC LIMIT ?3",
                None =>
                    "SELECT target_symbol_id, relationship_type, weight
                     FROM code_relationships
                     WHERE source_symbol_id = ?1
                     ORDER BY weight DESC LIMIT ?2",
            };

            let mut stmt = conn.prepare(sql)?;

            let rows: Vec<_> = if let Some(ref rt) = rtype {
                stmt.query_map(rusqlite::params![sym, rt, limit as i64], |row| {
                    Ok((
                        row.get::<_, String>(0)?,
                        row.get::<_, String>(1)?,
                        row.get::<_, f32>(2)?,
                    ))
                })?.collect::<std::result::Result<Vec<_>, _>>()?
            } else {
                stmt.query_map(rusqlite::params![sym, limit as i64], |row| {
                    Ok((
                        row.get::<_, String>(0)?,
                        row.get::<_, String>(1)?,
                        row.get::<_, f32>(2)?,
                    ))
                })?.collect::<std::result::Result<Vec<_>, _>>()?
            };

            Ok::<_, rusqlite::Error>(rows)
        }).await.map_err(|e| Error::internal(format!("Task join error: {}", e)))?
          .map_err(|e: rusqlite::Error| Error::database(format!("Get related failed: {}", e)))?;

        Ok(results)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[tokio::test]
    async fn test_repository_open() {
        let temp = tempfile::tempdir().unwrap();
        let db_path = temp.path().join("test.db");

        let repo = EmbeddingRepository::open(&db_path).await.unwrap();
        assert_eq!(repo.count(), 0);
    }

    #[tokio::test]
    async fn test_store_and_search() {
        let temp = tempfile::tempdir().unwrap();
        let db_path = temp.path().join("test.db");

        let repo = EmbeddingRepository::open(&db_path).await.unwrap();

        // Store an embedding
        let metadata = EmbeddingMetadata {
            symbol_id: "sym1".to_string(),
            symbol_name: "test_func".to_string(),
            symbol_kind: "Function".to_string(),
            file_path: "src/lib.rs".to_string(),
            content_hash: "abc123".to_string(),
            embedding_model: "test".to_string(),
        };
        let embedding = vec![1.0f32, 0.0, 0.0];

        repo.store_embedding(metadata, &embedding).await.unwrap();
        assert_eq!(repo.count(), 1);

        // Search
        let query = vec![1.0f32, 0.0, 0.0];
        let results = repo.search_similar(&query, 10);

        assert_eq!(results.len(), 1);
        assert!((results[0].similarity - 1.0).abs() < 0.0001);
        assert_eq!(results[0].symbol_name, "test_func");
    }

    #[tokio::test]
    async fn test_staleness_check() {
        let temp = tempfile::tempdir().unwrap();
        let db_path = temp.path().join("test.db");

        let repo = EmbeddingRepository::open(&db_path).await.unwrap();

        let metadata = EmbeddingMetadata {
            symbol_id: "sym1".to_string(),
            symbol_name: "test".to_string(),
            symbol_kind: "Function".to_string(),
            file_path: "test.rs".to_string(),
            content_hash: "hash1".to_string(),
            embedding_model: "test".to_string(),
        };

        repo.store_embedding(metadata, &[1.0, 2.0]).await.unwrap();

        // Same hash = not stale
        assert!(!repo.is_stale("sym1", "hash1"));

        // Different hash = stale
        assert!(repo.is_stale("sym1", "hash2"));

        // Unknown symbol = stale (needs embedding)
        assert!(repo.is_stale("unknown", "any"));
    }

    #[tokio::test]
    async fn test_store_and_get_relationships() {
        let temp = tempfile::tempdir().unwrap();
        let db_path = temp.path().join("test.db");

        let repo = EmbeddingRepository::open(&db_path).await.unwrap();

        // Store relationships
        repo.store_relationship("sym_a", "sym_b", "calls", 1.0).await.unwrap();
        repo.store_relationship("sym_a", "sym_c", "imports", 0.8).await.unwrap();

        // Get related symbols
        let related = repo.get_related("sym_a", None, 10).await.unwrap();
        assert_eq!(related.len(), 2);

        // Check ordering by weight (descending)
        assert_eq!(related[0].0, "sym_b"); // weight 1.0
        assert_eq!(related[1].0, "sym_c"); // weight 0.8

        // Filter by type
        let calls_only = repo.get_related("sym_a", Some("calls"), 10).await.unwrap();
        assert_eq!(calls_only.len(), 1);
        assert_eq!(calls_only[0].0, "sym_b");
    }

    #[tokio::test]
    async fn test_delete_file_embeddings() {
        let temp = tempfile::tempdir().unwrap();
        let db_path = temp.path().join("test.db");

        let repo = EmbeddingRepository::open(&db_path).await.unwrap();

        // Store embeddings for two files
        let meta1 = EmbeddingMetadata {
            symbol_id: "sym1".to_string(),
            symbol_name: "func1".to_string(),
            symbol_kind: "Function".to_string(),
            file_path: "file_a.rs".to_string(),
            content_hash: "hash1".to_string(),
            embedding_model: "test".to_string(),
        };
        let meta2 = EmbeddingMetadata {
            symbol_id: "sym2".to_string(),
            symbol_name: "func2".to_string(),
            symbol_kind: "Function".to_string(),
            file_path: "file_b.rs".to_string(),
            content_hash: "hash2".to_string(),
            embedding_model: "test".to_string(),
        };

        repo.store_embedding(meta1, &[1.0, 2.0]).await.unwrap();
        repo.store_embedding(meta2, &[3.0, 4.0]).await.unwrap();
        assert_eq!(repo.count(), 2);

        // Delete one file's embeddings
        let deleted = repo.delete_file_embeddings("file_a.rs").await.unwrap();
        assert_eq!(deleted, 1);
        assert_eq!(repo.count(), 1);

        // Verify correct one remains
        assert!(repo.get_embedding("sym2").is_some());
        assert!(repo.get_embedding("sym1").is_none());
    }
}

