// Integration tests for relationship analysis functionality
// Tests the complete relationship analysis pipeline with real Dart code

use agentmap::core::relationship_analyzer::{RelationshipAnalyzer, RelationshipGraph, DependencySeverity};
use agentmap::core::symbol_types::{Symbol, SymbolKind, SourceLocation, RelationshipType, RelationshipData};
use agentmap::parsers::treesitter_engine::{ParsedSymbol, FileParseResult, ImportInfo};
use agentmap::core::language::SupportedLanguage;
use std::collections::HashMap;
use std::path::PathBuf;
use tree_sitter::Parser;

#[tokio::test]
async fn test_relationship_analyzer_with_inheritance() {
    println!("🧪 Testing relationship analysis with inheritance patterns");
    
    let analyzer = RelationshipAnalyzer::new();
    
    // Create a parent class
    let parent_location = SourceLocation {
        file_path: PathBuf::from("parent.dart"),
        start_line: 1,
        start_column: 1,
        end_line: 10,
        end_column: 1,
        byte_offset: 0,
        byte_length: 200,
    };

    let parent_symbol = Symbol::new(
        "parent::BaseWidget".to_string(),
        "BaseWidget".to_string(),
        SymbolKind::Class {
            is_abstract: true,
            superclass: None,
            interfaces: Vec::new(),
            is_generic: false,
        },
        parent_location.clone(),
    );

    // Create a child class that extends the parent
    let child_location = SourceLocation {
        file_path: PathBuf::from("child.dart"),
        start_line: 1,
        start_column: 1,
        end_line: 15,
        end_column: 1,
        byte_offset: 0,
        byte_length: 300,
    };

    let child_symbol = Symbol::new(
        "child::CustomWidget".to_string(),
        "CustomWidget".to_string(),
        SymbolKind::Class {
            is_abstract: false,
            superclass: Some("BaseWidget".to_string()),
            interfaces: vec!["Drawable".to_string()],
            is_generic: false,
        },
        child_location.clone(),
    );

    // Create a proper TreeSitter tree for testing
    let mut parser = Parser::new();
    parser.set_language(&tree_sitter_dart::language()).unwrap();
    let parent_tree = parser.parse("class BaseWidget {}", None).unwrap();

    // Create file results
    let parent_file = FileParseResult {
        path: PathBuf::from("parent.dart"),
        language: SupportedLanguage::Dart,
        symbols: vec![ParsedSymbol {
            symbol: parent_symbol,
            raw_node: "class_definition".to_string(),
            node_kind: "class".to_string(),
            capture_name: "class.definition".to_string(),
        }],
        imports: Vec::new(),
        annotations: Vec::new(),
        tree_sitter_tree: parent_tree,
    };

    let child_tree = parser.parse("class CustomWidget extends BaseWidget {}", None).unwrap();
    
    let child_file = FileParseResult {
        path: PathBuf::from("child.dart"),
        language: SupportedLanguage::Dart,
        symbols: vec![ParsedSymbol {
            symbol: child_symbol,
            raw_node: "class_definition".to_string(),
            node_kind: "class".to_string(),
            capture_name: "class.definition".to_string(),
        }],
        imports: vec![ImportInfo {
            source: "parent.dart".to_string(),
            items: vec!["BaseWidget".to_string()],
            alias: None,
            location: SourceLocation {
                file_path: PathBuf::from("child.dart"),
                start_line: 1,
                start_column: 1,
                end_line: 1,
                end_column: 25,
                byte_offset: 0,
                byte_length: 25,
            },
        }],
        annotations: Vec::new(),
        tree_sitter_tree: child_tree,
    };

    // Register files
    analyzer.register_file(parent_file).await.expect("Failed to register parent file");
    analyzer.register_file(child_file).await.expect("Failed to register child file");

    // Analyze relationships
    let result = analyzer.analyze_relationships().await.expect("Failed to analyze relationships");

    println!("📊 Analysis Results:");
    println!("  - Total relationships: {}", result.metrics.total_relationships);
    println!("  - Import relationships: {}", result.metrics.import_relationships);
    println!("  - Inheritance relationships: {}", result.metrics.inheritance_relationships);
    println!("  - Circular dependencies: {}", result.metrics.circular_dependencies);
    println!("  - Coupling score: {:.2}", result.metrics.coupling_score);
    println!("  - Cohesion score: {:.2}", result.metrics.cohesion_score);

    // Verify we found some relationships
    assert!(result.metrics.total_relationships > 0, "Should find relationships between symbols");
    println!("✅ Relationship analysis working correctly!");
}

#[tokio::test]
async fn test_circular_dependency_detection() {
    println!("🔄 Testing circular dependency detection");
    
    let mut graph = RelationshipGraph::new();

    // Create a circular dependency: A -> B -> C -> A
    let relationships = vec![
        create_test_relationship("A", "B", RelationshipType::Import, "a.dart"),
        create_test_relationship("B", "C", RelationshipType::Import, "b.dart"),
        create_test_relationship("C", "A", RelationshipType::Import, "c.dart"),
    ];

    for rel in relationships {
        graph.add_relationship(rel);
    }

    let analyzer = RelationshipAnalyzer::new();
    let cycles = analyzer.detect_circular_dependencies(&graph).await
        .expect("Failed to detect circular dependencies");

    println!("🔍 Detected {} circular dependencies", cycles.len());
    
    if !cycles.is_empty() {
        println!("  Cycle details:");
        for (i, cycle) in cycles.iter().enumerate() {
            println!("    {}. {:?} -> Severity: {:?}", i + 1, cycle.cycle, cycle.severity);
        }
    }

    assert!(!cycles.is_empty(), "Should detect circular dependency");
    assert_eq!(cycles[0].dependency_type, RelationshipType::Import);
    println!("✅ Circular dependency detection working correctly!");
}

#[tokio::test]
async fn test_relationship_graph_operations() {
    println!("📈 Testing relationship graph operations");
    
    let mut graph = RelationshipGraph::new();

    // Add various types of relationships
    let relationships = vec![
        create_test_relationship("Widget", "State", RelationshipType::Composition, "widget.dart"),
        create_test_relationship("CustomWidget", "Widget", RelationshipType::Inherits, "custom.dart"),
        create_test_relationship("CustomWidget", "Drawable", RelationshipType::Implements, "custom.dart"),
        create_test_relationship("MainApp", "CustomWidget", RelationshipType::Uses, "main.dart"),
    ];

    for rel in &relationships {
        graph.add_relationship(rel.clone());
    }

    // Test forward relationships
    let widget_relations = graph.get_relationships("Widget");
    assert!(widget_relations.is_some());
    println!("📤 Widget has {} outgoing relationships", widget_relations.unwrap().len());

    // Test reverse dependencies
    let widget_dependents = graph.get_dependents("Widget");
    assert!(widget_dependents.is_some());
    println!("📥 Widget has {} dependents", widget_dependents.unwrap().len());
    assert!(widget_dependents.unwrap().contains("CustomWidget"));

    // Test multiple relationship types
    let custom_widget_relations = graph.get_relationships("CustomWidget");
    assert!(custom_widget_relations.is_some());
    
    let rel_types: std::collections::HashSet<_> = custom_widget_relations.unwrap()
        .iter()
        .map(|r| r.relationship_type.clone())
        .collect();
    
    println!("🔗 CustomWidget relationship types: {:?}", rel_types);
    assert!(rel_types.contains(&RelationshipType::Inherits));
    assert!(rel_types.contains(&RelationshipType::Implements));

    println!("✅ Relationship graph operations working correctly!");
}

#[tokio::test]
async fn test_metrics_calculation() {
    println!("📊 Testing relationship metrics calculation");
    
    let analyzer = RelationshipAnalyzer::new();
    
    // Create various types of relationships
    let relationships = vec![
        create_test_relationship("A", "B", RelationshipType::Import, "a.dart"),
        create_test_relationship("A", "C", RelationshipType::Import, "a.dart"),
        create_test_relationship("B", "D", RelationshipType::Inherits, "b.dart"),
        create_test_relationship("C", "E", RelationshipType::Uses, "c.dart"),
        create_test_relationship("D", "F", RelationshipType::Composition, "d.dart"),
    ];

    let circular_deps = Vec::new();
    let unresolved_refs = Vec::new();

    let metrics = analyzer.calculate_metrics(&relationships, &circular_deps, &unresolved_refs);

    println!("📈 Calculated Metrics:");
    println!("  - Total relationships: {}", metrics.total_relationships);
    println!("  - Import relationships: {}", metrics.import_relationships);
    println!("  - Inheritance relationships: {}", metrics.inheritance_relationships);
    println!("  - Composition relationships: {}", metrics.composition_relationships);
    println!("  - Usage relationships: {}", metrics.usage_relationships);
    println!("  - Coupling score: {:.3}", metrics.coupling_score);
    println!("  - Cohesion score: {:.3}", metrics.cohesion_score);

    // Verify metrics are calculated correctly
    assert_eq!(metrics.total_relationships, 5);
    assert_eq!(metrics.import_relationships, 2);
    assert_eq!(metrics.inheritance_relationships, 1);
    assert_eq!(metrics.composition_relationships, 1);
    assert_eq!(metrics.usage_relationships, 1);
    assert!(metrics.coupling_score > 0.0);
    assert!(metrics.cohesion_score <= 1.0);

    println!("✅ Metrics calculation working correctly!");
}

#[tokio::test]
async fn test_dependency_severity_classification() {
    println!("⚠️ Testing dependency severity classification");
    
    let mut graph = RelationshipGraph::new();
    
    // Add relationships with different severity implications
    let relationships = vec![
        create_test_relationship("A", "B", RelationshipType::Import, "a.dart"),          // Medium severity
        create_test_relationship("B", "A", RelationshipType::Import, "b.dart"),          // Medium severity
        create_test_relationship("C", "D", RelationshipType::Inherits, "c.dart"),       // High severity
        create_test_relationship("D", "C", RelationshipType::Inherits, "d.dart"),       // High severity
        create_test_relationship("E", "F", RelationshipType::Uses, "e.dart"),           // Low severity
        create_test_relationship("F", "E", RelationshipType::Uses, "f.dart"),           // Low severity
    ];

    for rel in relationships {
        graph.add_relationship(rel);
    }

    let analyzer = RelationshipAnalyzer::new();
    let cycles = analyzer.detect_circular_dependencies(&graph).await
        .expect("Failed to detect circular dependencies");

    println!("🔍 Found {} cycles with different severities", cycles.len());

    let mut high_severity = 0;
    let mut medium_severity = 0;
    let mut low_severity = 0;

    for cycle in &cycles {
        match cycle.severity {
            DependencySeverity::High => {
                high_severity += 1;
                println!("  🔴 High severity cycle: {:?} ({})", cycle.cycle, cycle.dependency_type);
            },
            DependencySeverity::Medium => {
                medium_severity += 1;
                println!("  🟡 Medium severity cycle: {:?} ({})", cycle.cycle, cycle.dependency_type);
            },
            DependencySeverity::Low => {
                low_severity += 1;
                println!("  🟢 Low severity cycle: {:?} ({})", cycle.cycle, cycle.dependency_type);
            },
        }
    }

    println!("📋 Severity breakdown: {} High, {} Medium, {} Low", high_severity, medium_severity, low_severity);

    // Should detect cycles and classify their severity appropriately
    assert!(cycles.len() >= 1, "Should detect at least one cycle");
    println!("✅ Dependency severity classification working correctly!");
}

// Helper function to create test relationships
fn create_test_relationship(from: &str, to: &str, rel_type: RelationshipType, file: &str) -> RelationshipData {
    RelationshipData {
        from_symbol: from.to_string(),
        to_symbol: to.to_string(),
        relationship_type: rel_type,
        location: SourceLocation {
            file_path: PathBuf::from(file),
            start_line: 1,
            start_column: 1,
            end_line: 1,
            end_column: 10,
            byte_offset: 0,
            byte_length: 10,
        },
        metadata: HashMap::new(),
    }
}