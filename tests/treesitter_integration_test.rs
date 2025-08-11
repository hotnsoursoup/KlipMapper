// Integration test for the modern TreeSitter parsing architecture
// This test verifies that our new parsing system works with real Dart code

use agentmap::parsers::treesitter_engine::ModernTreeSitterEngine;
use std::path::Path;

#[tokio::test]
async fn test_dart_class_parsing() {
    // Initialize the TreeSitter engine
    let mut engine = ModernTreeSitterEngine::new().expect("Failed to create TreeSitter engine");
    
    // Sample Dart code with class definitions
    let dart_code = r#"
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;

class UserModel {
  final String name;
  final int age;
  
  UserModel({required this.name, required this.age});
  
  String getName() => name;
  
  void setAge(int newAge) {
    age = newAge;
  }
}

@widget 
class UserWidget extends StatelessWidget {
  const UserWidget({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('User Widget'),
    );
  }
}
"#;
    
    // Parse the Dart code
    let file_path = Path::new("test_sample.dart");
    let result = engine.analyze_file(file_path, dart_code).await;
    
    match result {
        Ok(parse_result) => {
            println!("✅ Successfully parsed Dart code!");
            println!("📁 Language: {:?}", parse_result.language);
            println!("🔍 Found {} symbols", parse_result.symbols.len());
            println!("📦 Found {} imports", parse_result.imports.len());
            println!("🏷️ Found {} annotations", parse_result.annotations.len());
            
            // Verify we found the expected classes
            let class_symbols: Vec<_> = parse_result.symbols.iter()
                .filter(|s| matches!(s.symbol.kind, agentmap::core::symbol_types::SymbolKind::Class { .. }))
                .collect();
            
            println!("🏛️ Found {} classes:", class_symbols.len());
            for symbol in &class_symbols {
                println!("  - {}", symbol.symbol.name);
            }
            
            // Verify we found imports
            println!("📥 Imports found:");
            for import in &parse_result.imports {
                println!("  - {} (items: {:?})", import.source, import.items);
                if let Some(alias) = &import.alias {
                    println!("    alias: {}", alias);
                }
            }
            
            // Verify we found annotations
            println!("🏷️ Annotations found:");
            for annotation in &parse_result.annotations {
                println!("  - {}", annotation.name);
            }
            
            // Basic assertions
            assert!(!parse_result.symbols.is_empty(), "Should find at least some symbols");
            assert!(!parse_result.imports.is_empty(), "Should find import statements");
            assert!(!class_symbols.is_empty(), "Should find class definitions");
            
            // Check if we found the expected classes
            let class_names: Vec<_> = class_symbols.iter().map(|s| s.symbol.name.as_str()).collect();
            assert!(class_names.contains(&"UserModel"), "Should find UserModel class");
            assert!(class_names.contains(&"UserWidget"), "Should find UserWidget class");
            
            println!("✅ All assertions passed! TreeSitter integration working correctly.");
        },
        Err(e) => {
            eprintln!("❌ Failed to parse Dart code: {}", e);
            panic!("TreeSitter parsing failed: {}", e);
        }
    }
}

#[tokio::test]
async fn test_unsupported_file_type() {
    let mut engine = ModernTreeSitterEngine::new().expect("Failed to create TreeSitter engine");
    
    // Try to parse an unsupported file type
    let result = engine.analyze_file(Path::new("test.unknown"), "some content").await;
    
    assert!(result.is_err(), "Should fail for unsupported file types");
    println!("✅ Correctly rejected unsupported file type");
}

#[test]
fn test_engine_initialization() {
    let result = ModernTreeSitterEngine::new();
    assert!(result.is_ok(), "TreeSitter engine should initialize successfully");
    println!("✅ TreeSitter engine initialized successfully");
}