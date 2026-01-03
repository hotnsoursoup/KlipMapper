//! Vector conversion utilities for SQLite BLOB storage.
//!
//! Embeddings are stored as BLOB in little-endian f32 format.

use thiserror::Error;

/// Error type for blob conversion operations.
#[derive(Error, Debug, Clone, PartialEq)]
pub enum BlobConversionError {
    /// Blob length is not a multiple of 4 (expected for f32 array).
    #[error("Invalid blob length {actual}, expected multiple of {expected_multiple}")]
    InvalidLength {
        actual: usize,
        expected_multiple: usize,
    },
}


/// Convert a Vec<f32> embedding to SQLite BLOB format.
///
/// Uses little-endian byte order (4 bytes per float).
///
/// # Example
///
/// ```
/// # use agentmap::storage::embedding_to_blob;
/// let embedding = vec![1.0f32, 2.0, 3.0];
/// let blob = embedding_to_blob(&embedding);
/// assert_eq!(blob.len(), 12); // 3 floats * 4 bytes
/// ```
pub fn embedding_to_blob(embedding: &[f32]) -> Vec<u8> {
    embedding
        .iter()
        .flat_map(|f| f.to_le_bytes())
        .collect()
}

/// Convert a SQLite BLOB back to Vec<f32> embedding.
///
/// Expects little-endian byte order (4 bytes per float).
/// Returns an error if blob length is not divisible by 4.
///
/// # Example
///
/// ```
/// # use agentmap::storage::{embedding_to_blob, try_blob_to_embedding};
/// let original = vec![1.0f32, 2.0, 3.0];
/// let blob = embedding_to_blob(&original);
/// let recovered = try_blob_to_embedding(&blob).unwrap();
/// assert_eq!(original, recovered);
/// ```
pub fn try_blob_to_embedding(blob: &[u8]) -> Result<Vec<f32>, BlobConversionError> {
    if blob.len() % 4 != 0 {
        return Err(BlobConversionError::InvalidLength {
            actual: blob.len(),
            expected_multiple: 4,
        });
    }

    Ok(blob.chunks_exact(4)
        .map(|chunk| {
            let bytes: [u8; 4] = [chunk[0], chunk[1], chunk[2], chunk[3]];
            f32::from_le_bytes(bytes)
        })
        .collect())
}

/// Convert a SQLite BLOB back to Vec<f32> embedding.
///
/// # Panics
///
/// Panics if the blob length is not divisible by 4.
/// Prefer `try_blob_to_embedding` for production code.
#[deprecated(since = "2.1.0", note = "Use try_blob_to_embedding instead to avoid panics")]
pub fn blob_to_embedding(blob: &[u8]) -> Vec<f32> {
    try_blob_to_embedding(blob).expect("Blob length must be divisible by 4")
}


/// Compute cosine similarity between two embeddings.
///
/// Returns a value in range [-1, 1] where:
/// - 1.0 = identical direction
/// - 0.0 = orthogonal (unrelated)
/// - -1.0 = opposite direction
///
/// # Panics
///
/// Panics if embeddings have different lengths.
///
/// # Example
///
/// ```
/// # use agentmap::storage::cosine_similarity;
/// let a = vec![1.0, 0.0, 0.0];
/// let b = vec![1.0, 0.0, 0.0];
/// assert!((cosine_similarity(&a, &b) - 1.0).abs() < 0.0001);
///
/// let c = vec![0.0, 1.0, 0.0];
/// assert!((cosine_similarity(&a, &c) - 0.0).abs() < 0.0001);
/// ```
pub fn cosine_similarity(a: &[f32], b: &[f32]) -> f32 {
    assert_eq!(
        a.len(),
        b.len(),
        "Embedding lengths differ: {} vs {}",
        a.len(),
        b.len()
    );

    if a.is_empty() {
        return 0.0;
    }

    let mut dot_product = 0.0f32;
    let mut norm_a = 0.0f32;
    let mut norm_b = 0.0f32;

    for (x, y) in a.iter().zip(b.iter()) {
        dot_product += x * y;
        norm_a += x * x;
        norm_b += y * y;
    }

    let norm_product = (norm_a.sqrt() * norm_b.sqrt()).max(f32::EPSILON);
    dot_product / norm_product
}

/// Normalize a vector to unit length (L2 normalization).
///
/// Useful for ensuring consistent cosine similarity computations.
pub fn normalize_vector(v: &[f32]) -> Vec<f32> {
    let norm: f32 = v.iter().map(|x| x * x).sum::<f32>().sqrt();
    if norm < f32::EPSILON {
        return v.to_vec();
    }
    v.iter().map(|x| x / norm).collect()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_embedding_roundtrip() {
        let original = vec![1.0f32, -2.5, 3.14159, 0.0, -0.001];
        let blob = embedding_to_blob(&original);
        let recovered = blob_to_embedding(&blob);

        for (a, b) in original.iter().zip(recovered.iter()) {
            assert!((a - b).abs() < 1e-7, "Mismatch: {} vs {}", a, b);
        }
    }

    #[test]
    fn test_cosine_similarity_identical() {
        let a = vec![1.0, 2.0, 3.0];
        let b = vec![1.0, 2.0, 3.0];
        let sim = cosine_similarity(&a, &b);
        assert!((sim - 1.0).abs() < 0.0001, "Expected 1.0, got {}", sim);
    }

    #[test]
    fn test_cosine_similarity_orthogonal() {
        let a = vec![1.0, 0.0, 0.0];
        let b = vec![0.0, 1.0, 0.0];
        let sim = cosine_similarity(&a, &b);
        assert!((sim - 0.0).abs() < 0.0001, "Expected 0.0, got {}", sim);
    }

    #[test]
    fn test_cosine_similarity_opposite() {
        let a = vec![1.0, 0.0, 0.0];
        let b = vec![-1.0, 0.0, 0.0];
        let sim = cosine_similarity(&a, &b);
        assert!((sim - (-1.0)).abs() < 0.0001, "Expected -1.0, got {}", sim);
    }

    #[test]
    fn test_normalize_vector() {
        let v = vec![3.0, 4.0];
        let normalized = normalize_vector(&v);

        // Check unit length
        let norm: f32 = normalized.iter().map(|x| x * x).sum::<f32>().sqrt();
        assert!((norm - 1.0).abs() < 0.0001);

        // Check direction preserved
        assert!((normalized[0] - 0.6).abs() < 0.0001);
        assert!((normalized[1] - 0.8).abs() < 0.0001);
    }

    #[test]
    fn test_empty_embedding() {
        let empty: Vec<f32> = vec![];
        let blob = embedding_to_blob(&empty);
        assert!(blob.is_empty());
        let recovered = try_blob_to_embedding(&blob).expect("empty should work");
        assert!(recovered.is_empty());
    }

    #[test]
    fn test_cosine_similarity_empty() {
        let a: Vec<f32> = vec![];
        let b: Vec<f32> = vec![];
        let sim = cosine_similarity(&a, &b);
        assert_eq!(sim, 0.0);
    }

    #[test]
    fn test_try_blob_to_embedding_invalid_length() {
        // 5 bytes is not divisible by 4
        let invalid_blob = vec![0u8, 1, 2, 3, 4];
        let result = try_blob_to_embedding(&invalid_blob);
        assert!(result.is_err());

        match result {
            Err(BlobConversionError::InvalidLength { actual, expected_multiple }) => {
                assert_eq!(actual, 5);
                assert_eq!(expected_multiple, 4);
            }
            _ => panic!("Expected InvalidLength error"),
        }
    }

    #[test]
    fn test_try_blob_to_embedding_success() {
        let original = vec![1.0f32, 2.0, 3.0];
        let blob = embedding_to_blob(&original);
        let recovered = try_blob_to_embedding(&blob).expect("should succeed");
        assert_eq!(original, recovered);
    }
}

