// Simple test to verify TreeSitter parsing functionality
// This is a basic test to ensure our new architecture can parse Dart code

#[cfg(test)]
mod tests {
    use super::*;
    use crate::parsers::treesitter_engine::ModernTreeSitterEngine;
    use std::path::Path;
    use tokio;

    #[tokio::test]
    async fn test_dart_parsing() {
        // Initialize the TreeSitter engine
        let mut engine = ModernTreeSitterEngine::new().expect("Failed to create TreeSitter engine");
        
        // Sample Dart code with various constructs
        let dart_code = r#"
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
"#;
        
        // Parse the Dart code
        let file_path = Path::new("test_sample.dart");
        let result = engine.analyze_file(file_path, dart_code).await;
        
        match result {
            Ok(parse_result) => {
                println!("Successfully parsed Dart code!");
                println!("Language: {:?}", parse_result.language);
                println!("Found {} symbols", parse_result.symbols.len());
                println!("Found {} imports", parse_result.imports.len());
                println!("Found {} annotations", parse_result.annotations.len());
                
                // Print symbol details
                for symbol in &parse_result.symbols {
                    println!("Symbol: {} - {:?}", symbol.symbol.name, symbol.symbol.kind);
                }
                
                // Print import details
                for import in &parse_result.imports {
                    println!("Import: {}", import.source);
                }
                
                // Print annotation details
                for annotation in &parse_result.annotations {
                    println!("Annotation: {}", annotation.name);
                }
                
                assert!(!parse_result.symbols.is_empty(), "Should find at least some symbols");
            },
            Err(e) => {
                eprintln!("Failed to parse Dart code: {}", e);
                panic!("TreeSitter parsing failed");
            }
        }
    }
}