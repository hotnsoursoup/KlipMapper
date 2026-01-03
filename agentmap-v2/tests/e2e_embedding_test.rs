//! End-to-End Embedding Test with Gemini API
//!
//! This test demonstrates the full pipeline:
//! 1. Parse code with AgentMap
//! 2. Generate embeddings with Gemini
//! 3. Store in SQLite via db-kit
//! 4. Perform vector similarity search
//!
//! Run with: GEMINI_API_KEY=your-key cargo test --features embedding -- e2e_embedding --nocapture

#[cfg(feature = "embedding")]
mod embedding_tests {
    use agentmap::{AgentMap, Symbol, CodeAnalysis};
    use std::path::Path;

    /// Test that we can analyze code and prepare it for embedding.
    #[test]
    fn test_analyze_and_prepare_for_embedding() {
        let agent = AgentMap::new();
        let analysis = agent.analyze_file("src/lib.rs").expect("Failed to analyze");

        // Each symbol's code_content is suitable for embedding
        let embeddable_texts: Vec<&str> = analysis.symbols.iter()
            .filter(|s| !s.code_content.is_empty())
            .map(|s| s.code_content.as_str())
            .collect();

        println!("\n=== Embeddable Symbols ===");
        println!("Total symbols with code: {}", embeddable_texts.len());

        for (i, text) in embeddable_texts.iter().take(3).enumerate() {
            println!("\n--- Symbol {} (first 200 chars) ---", i + 1);
            println!("{}", &text[..text.len().min(200)]);
        }

        assert!(!embeddable_texts.is_empty(), "Should have embeddable content");
    }

    /// Test embedding generation with Gemini (requires API key).
    #[tokio::test]
    #[ignore] // Run with: GEMINI_API_KEY=... cargo test --features embedding -- --ignored
    async fn test_gemini_embedding_generation() {
        use db_kit_lib::embedding::{EmbeddingProvider, GeminiEmbeddings};

        // Get embedder from env
        let embedder = GeminiEmbeddings::from_env()
            .expect("GEMINI_API_KEY or GOOGLE_API_KEY must be set");

        println!("\n=== Gemini Embedding Test ===");
        println!("Model dimensions: {}", embedder.dimensions());

        // Embed a code snippet
        let code = r#"
pub fn analyze_file(&self, path: impl AsRef<std::path::Path>) -> Result<CodeAnalysis> {
    let path = path.as_ref();
    let content = std::fs::read_to_string(path)?;
    let language = Language::detect_from_path(path)?;
    self.parser.parse(&content, language)
}
"#;

        let embedding = embedder.embed_one(code).await
            .expect("Failed to generate embedding");

        println!("Generated embedding with {} dimensions", embedding.len());
        println!("First 5 values: {:?}", &embedding[..5]);

        assert_eq!(embedding.len(), 768, "Gemini text-embedding-004 should return 768 dimensions");
    }

    /// Full end-to-end test: Analyze -> Embed -> Store -> Search
    #[tokio::test]
    #[ignore] // Run with: GEMINI_API_KEY=... cargo test --features embedding -- --ignored e2e_full
    async fn test_e2e_full_pipeline() {
        use db_kit_lib::embedding::{EmbeddingProvider, GeminiEmbeddings};
        use std::collections::HashMap;

        println!("\n=== Full E2E Pipeline Test ===");

        // Step 1: Analyze code
        println!("\n[Step 1] Analyzing codebase...");
        let agent = AgentMap::new();
        let analyses = agent.analyze_directory("src/core")
            .expect("Failed to analyze directory");

        let total_symbols: usize = analyses.iter().map(|a| a.symbols.len()).sum();
        println!("  Analyzed {} files, {} symbols", analyses.len(), total_symbols);

        // Step 2: Prepare texts for embedding
        println!("\n[Step 2] Preparing symbol texts...");
        let mut symbol_texts: Vec<(String, String)> = Vec::new(); // (id, text)

        for analysis in &analyses {
            for symbol in &analysis.symbols {
                if !symbol.code_content.is_empty() && symbol.code_content.len() < 4000 {
                    // Create a rich text for embedding
                    let rich_text = format!(
                        "// File: {}\n// Symbol: {} ({})\n{}",
                        analysis.file_path.display(),
                        symbol.name,
                        symbol.kind,
                        symbol.code_content
                    );
                    symbol_texts.push((symbol.id.to_string(), rich_text));
                }
            }
        }
        println!("  Prepared {} symbols for embedding", symbol_texts.len());

        // Step 3: Generate embeddings
        println!("\n[Step 3] Generating embeddings with Gemini...");
        let embedder = GeminiEmbeddings::from_env()
            .expect("GEMINI_API_KEY must be set");

        let texts: Vec<&str> = symbol_texts.iter()
            .take(10) // Limit for testing
            .map(|(_, t)| t.as_str())
            .collect();

        let embeddings = embedder.embed(&texts).await
            .expect("Failed to generate embeddings");

        println!("  Generated {} embeddings ({} dimensions each)",
            embeddings.len(),
            embeddings.first().map(|e| e.len()).unwrap_or(0)
        );

        // Step 4: Store in memory (simulate vector DB)
        println!("\n[Step 4] Storing embeddings...");
        let mut vector_store: HashMap<String, Vec<f32>> = HashMap::new();

        for (i, embedding) in embeddings.into_iter().enumerate() {
            let id = &symbol_texts[i].0;
            vector_store.insert(id.clone(), embedding);
        }
        println!("  Stored {} vectors", vector_store.len());

        // Step 5: Similarity search
        println!("\n[Step 5] Testing similarity search...");
        let query = "function that reads a file and parses it";
        let query_embedding = embedder.embed_one(query).await
            .expect("Failed to embed query");

        // Calculate cosine similarity
        let mut similarities: Vec<(String, f32)> = vector_store.iter()
            .map(|(id, vec)| {
                let sim = cosine_similarity(&query_embedding, vec);
                (id.clone(), sim)
            })
            .collect();

        similarities.sort_by(|a, b| b.1.partial_cmp(&a.1).unwrap());

        println!("\n  Query: \"{}\"", query);
        println!("\n  Top 3 results:");
        for (id, sim) in similarities.iter().take(3) {
            println!("    - {} (similarity: {:.4})", id, sim);
        }

        println!("\n=== E2E Test Complete ===");
    }

    /// Cosine similarity between two vectors.
    fn cosine_similarity(a: &[f32], b: &[f32]) -> f32 {
        let dot: f32 = a.iter().zip(b.iter()).map(|(x, y)| x * y).sum();
        let norm_a: f32 = a.iter().map(|x| x * x).sum::<f32>().sqrt();
        let norm_b: f32 = b.iter().map(|x| x * x).sum::<f32>().sqrt();

        if norm_a == 0.0 || norm_b == 0.0 {
            0.0
        } else {
            dot / (norm_a * norm_b)
        }
    }
}

#[cfg(not(feature = "embedding"))]
mod embedding_tests {
    #[test]
    fn test_embedding_feature_disabled() {
        println!("Embedding tests require the 'embedding' feature.");
        println!("Run with: cargo test --features embedding");
    }
}
