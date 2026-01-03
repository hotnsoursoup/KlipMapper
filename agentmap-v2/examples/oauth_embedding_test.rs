//! OAuth-based Gemini Embedding Test
//!
//! Uses the access token from ~/.gemini/oauth_creds.json

use std::path::Path;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    println!("=== Gemini OAuth Embedding Test ===\n");

    // Read OAuth credentials
    let creds_path = dirs::home_dir()
        .expect("No home directory")
        .join(".gemini/oauth_creds.json");

    let creds_content = std::fs::read_to_string(&creds_path)?;
    let creds: serde_json::Value = serde_json::from_str(&creds_content)?;

    let access_token = creds["access_token"]
        .as_str()
        .expect("No access_token in oauth_creds.json");

    println!("✓ Loaded OAuth credentials");
    println!("  Token prefix: {}...", &access_token[..20]);

    // Prepare test code for embedding
    let test_code = r#"
pub fn analyze_file(&self, path: impl AsRef<std::path::Path>) -> Result<CodeAnalysis> {
    let path = path.as_ref();
    let content = std::fs::read_to_string(path)?;
    let language = Language::detect_from_path(path)?;
    self.parser.parse(&content, language)
}
"#;

    println!("\n[Step 1] Generating embedding for code snippet...");

    // Call Gemini Embedding API with OAuth Bearer token
    let client = reqwest::Client::new();
    let model = "text-embedding-004";
    let url = format!(
        "https://generativelanguage.googleapis.com/v1beta/models/{}:embedContent",
        model
    );

    let body = serde_json::json!({
        "model": format!("models/{}", model),
        "content": {
            "parts": [{"text": test_code}]
        }
    });

    let response = client
        .post(&url)
        .header("Authorization", format!("Bearer {}", access_token))
        .header("Content-Type", "application/json")
        .json(&body)
        .send()
        .await?;

    let status = response.status();
    println!("  API Response: {}", status);

    if !status.is_success() {
        let error_text = response.text().await?;
        println!("  Error: {}", error_text);
        return Err(format!("API error: {}", error_text).into());
    }

    let json: serde_json::Value = response.json().await?;

    // Extract embedding
    let values = json["embedding"]["values"]
        .as_array()
        .expect("No embedding values in response");

    println!("\n[Step 2] Embedding generated successfully!");
    println!("  Dimensions: {}", values.len());
    println!("  First 5 values: {:?}",
        values.iter().take(5).map(|v| v.as_f64().unwrap()).collect::<Vec<_>>());

    // Test batch embedding
    println!("\n[Step 3] Testing batch embedding...");

    let texts = vec![
        "fn parse(&self, content: &str) -> Result<ParsedFile>",
        "pub struct Symbol { name: String, kind: SymbolKind }",
        "impl Middleware for LoggingMiddleware",
    ];

    let batch_url = format!(
        "https://generativelanguage.googleapis.com/v1beta/models/{}:batchEmbedContents",
        model
    );

    let requests: Vec<_> = texts.iter()
        .map(|text| serde_json::json!({
            "model": format!("models/{}", model),
            "content": {"parts": [{"text": text}]}
        }))
        .collect();

    let batch_body = serde_json::json!({"requests": requests});

    let batch_response = client
        .post(&batch_url)
        .header("Authorization", format!("Bearer {}", access_token))
        .header("Content-Type", "application/json")
        .json(&batch_body)
        .send()
        .await?;

    if batch_response.status().is_success() {
        let batch_json: serde_json::Value = batch_response.json().await?;
        let embeddings = batch_json["embeddings"].as_array().unwrap();
        println!("  ✓ Batch embedding successful: {} embeddings", embeddings.len());
    } else {
        println!("  ✗ Batch embedding failed: {}", batch_response.status());
    }

    println!("\n=== Test Complete ===");
    Ok(())
}
