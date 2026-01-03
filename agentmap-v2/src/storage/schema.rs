//! Database schema for embedding storage.
//!
//! Uses SQLite with BLOB storage for embeddings.

/// SQL schema for creating the embeddings database.
pub const SCHEMA: &str = r#"
-- Symbol embeddings table
CREATE TABLE IF NOT EXISTS symbol_embeddings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    symbol_id TEXT NOT NULL UNIQUE,
    file_path TEXT NOT NULL,
    symbol_name TEXT NOT NULL,
    symbol_kind TEXT NOT NULL,
    embedding BLOB NOT NULL,
    embedding_dims INTEGER NOT NULL,
    embedding_model TEXT NOT NULL,
    content_hash TEXT NOT NULL,
    created_at TEXT DEFAULT (datetime('now')),
    updated_at TEXT DEFAULT (datetime('now'))
);

-- Indexes for common queries
CREATE INDEX IF NOT EXISTS idx_symbol_file ON symbol_embeddings(file_path);
CREATE INDEX IF NOT EXISTS idx_symbol_kind ON symbol_embeddings(symbol_kind);
CREATE INDEX IF NOT EXISTS idx_content_hash ON symbol_embeddings(content_hash);

-- Code relationships table (graph edges for hybrid search)
CREATE TABLE IF NOT EXISTS code_relationships (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    source_symbol_id TEXT NOT NULL,
    target_symbol_id TEXT NOT NULL,
    relationship_type TEXT NOT NULL,
    weight REAL DEFAULT 1.0,
    created_at TEXT DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_rel_source ON code_relationships(source_symbol_id);
CREATE INDEX IF NOT EXISTS idx_rel_target ON code_relationships(target_symbol_id);
CREATE INDEX IF NOT EXISTS idx_rel_type ON code_relationships(relationship_type);

-- Unique constraint for relationships
CREATE UNIQUE INDEX IF NOT EXISTS idx_rel_unique
    ON code_relationships(source_symbol_id, target_symbol_id, relationship_type);

-- Metadata table for tracking database version
CREATE TABLE IF NOT EXISTS _agentmap_meta (
    key TEXT PRIMARY KEY,
    value TEXT NOT NULL
);

INSERT OR REPLACE INTO _agentmap_meta (key, value) VALUES ('schema_version', '1');
INSERT OR REPLACE INTO _agentmap_meta (key, value) VALUES ('created_at', datetime('now'));
"#;

/// SQL for dropping all tables (used for testing/reset).
pub const DROP_SCHEMA: &str = r#"
DROP TABLE IF EXISTS symbol_embeddings;
DROP TABLE IF EXISTS code_relationships;
DROP TABLE IF EXISTS _agentmap_meta;
"#;

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_schema_not_empty() {
        assert!(!SCHEMA.is_empty());
        assert!(SCHEMA.contains("symbol_embeddings"));
        assert!(SCHEMA.contains("code_relationships"));
    }
}
