use agentmap::symbol_table::{
    ProjectSymbolTable, SymbolDefinition, SymbolUsage, UsageContext, EnclosingScope
};
use std::path::PathBuf;

#[test]
fn test_empty_symbol_table() {
    let table = ProjectSymbolTable::new();
    
    assert_eq!(table.definitions.len(), 0);
    assert_eq!(table.usages.len(), 0);
    assert_eq!(table.imports.len(), 0);
    assert_eq!(table.aliases.len(), 0);
}

#[test]
fn test_add_and_resolve_symbol() {
    let mut table = ProjectSymbolTable::new();
    
    let def = SymbolDefinition {
        name: "Employee".to_string(),
        kind: "class".to_string(),
        file: PathBuf::from("lib/models/employee.dart"),
        line: 5,
        end_line: 25,
        scope: None,
    };
    
    table.add_definition(def);
    
    let resolved = table.resolve_symbol("Employee");
    assert!(resolved.is_some());
    
    let defs = resolved.unwrap();
    assert_eq!(defs.len(), 1);
    assert_eq!(defs[0].name, "Employee");
    assert_eq!(defs[0].kind, "class");
    assert_eq!(defs[0].line, 5);
}

#[test]
fn test_multiple_definitions_same_symbol() {
    let mut table = ProjectSymbolTable::new();
    
    // Same symbol defined in multiple files (e.g., interfaces)
    let def1 = SymbolDefinition {
        name: "User".to_string(),
        kind: "interface".to_string(),
        file: PathBuf::from("frontend/types/user.ts"),
        line: 3,
        end_line: 10,
        scope: None,
    };
    
    let def2 = SymbolDefinition {
        name: "User".to_string(),
        kind: "class".to_string(),
        file: PathBuf::from("backend/models/user.py"),
        line: 15,
        end_line: 50,
        scope: None,
    };
    
    table.add_definition(def1);
    table.add_definition(def2);
    
    let resolved = table.resolve_symbol("User");
    assert!(resolved.is_some());
    
    let defs = resolved.unwrap();
    assert_eq!(defs.len(), 2);
    assert!(defs.iter().any(|d| d.file.to_str().unwrap().contains("frontend")));
    assert!(defs.iter().any(|d| d.file.to_str().unwrap().contains("backend")));
}

#[test]
fn test_add_and_find_usages() {
    let mut table = ProjectSymbolTable::new();
    
    let usage = SymbolUsage {
        symbol: "Employee".to_string(),
        file: PathBuf::from("lib/ui/dashboard.dart"),
        line: 134,
        context: UsageContext {
            usage_type: "reference".to_string(),
            enclosing: Some(EnclosingScope {
                scope_type: "method".to_string(),
                name: "buildEmployeeCard".to_string(),
                range: (130, 140),
            }),
        },
    };
    
    table.add_usage(usage);
    
    let usages = table.find_symbol_usages("Employee");
    assert!(usages.is_some());
    
    let usage_list = usages.unwrap();
    assert_eq!(usage_list.len(), 1);
    assert_eq!(usage_list[0].symbol, "Employee");
    assert_eq!(usage_list[0].line, 134);
    assert_eq!(usage_list[0].context.usage_type, "reference");
}

#[test]
fn test_cross_references() {
    let mut table = ProjectSymbolTable::new();
    
    // Add definition
    let def = SymbolDefinition {
        name: "Calculator".to_string(),
        kind: "class".to_string(),
        file: PathBuf::from("lib/calculator.dart"),
        line: 1,
        end_line: 20,
        scope: None,
    };
    table.add_definition(def);
    
    // Add multiple usages
    let usage1 = SymbolUsage {
        symbol: "Calculator".to_string(),
        file: PathBuf::from("lib/main.dart"),
        line: 10,
        context: UsageContext {
            usage_type: "instantiation".to_string(),
            enclosing: None,
        },
    };
    
    let usage2 = SymbolUsage {
        symbol: "Calculator".to_string(),
        file: PathBuf::from("test/calculator_test.dart"),
        line: 25,
        context: UsageContext {
            usage_type: "reference".to_string(),
            enclosing: Some(EnclosingScope {
                scope_type: "function".to_string(),
                name: "testCalculator".to_string(),
                range: (20, 30),
            }),
        },
    };
    
    table.add_usage(usage1);
    table.add_usage(usage2);
    
    let cross_refs = table.get_cross_references("Calculator");
    
    assert_eq!(cross_refs.symbol, "Calculator");
    assert_eq!(cross_refs.definitions.len(), 1);
    assert_eq!(cross_refs.usages.len(), 2);
    assert_eq!(cross_refs.total_refs, 2);
    assert_eq!(cross_refs.files_count, 2); // Used in 2 different files
}

#[test]
fn test_alias_resolution() {
    let mut table = ProjectSymbolTable::new();
    
    // Add definition with original name
    let def = SymbolDefinition {
        name: "LongClassName".to_string(),
        kind: "class".to_string(),
        file: PathBuf::from("lib/models.dart"),
        line: 1,
        end_line: 10,
        scope: None,
    };
    table.add_definition(def);
    
    // Add alias mapping
    table.add_alias("ShortName".to_string(), "LongClassName".to_string());
    
    // Should resolve through alias
    let resolved = table.resolve_symbol("ShortName");
    assert!(resolved.is_some());
    
    let defs = resolved.unwrap();
    assert_eq!(defs.len(), 1);
    assert_eq!(defs[0].name, "LongClassName");
}

#[test]
fn test_pattern_matching() {
    let mut table = ProjectSymbolTable::new();
    
    // Add various symbols
    let symbols = ["Employee", "EmployeeService", "User", "UserController", "Calculator"];
    for symbol in symbols {
        let def = SymbolDefinition {
            name: symbol.to_string(),
            kind: "class".to_string(),
            file: PathBuf::from(format!("lib/{}.dart", symbol.to_lowercase())),
            line: 1,
            end_line: 10,
            scope: None,
        };
        table.add_definition(def);
    }
    
    let employee_matches = table.query_symbols_by_pattern("Employee");
    assert_eq!(employee_matches.len(), 2);
    assert!(employee_matches.contains(&"Employee".to_string()));
    assert!(employee_matches.contains(&"EmployeeService".to_string()));
    
    let user_matches = table.query_symbols_by_pattern("User");
    assert_eq!(user_matches.len(), 2);
    assert!(user_matches.contains(&"User".to_string()));
    assert!(user_matches.contains(&"UserController".to_string()));
}

#[test]
fn test_symbols_in_file() {
    let mut table = ProjectSymbolTable::new();
    
    let file_path = PathBuf::from("lib/models.dart");
    
    // Add symbols from different files
    let symbols_in_file = ["User", "Employee"];
    let symbols_elsewhere = ["Calculator", "Service"];
    
    for symbol in symbols_in_file {
        let def = SymbolDefinition {
            name: symbol.to_string(),
            kind: "class".to_string(),
            file: file_path.clone(),
            line: 1,
            end_line: 10,
            scope: None,
        };
        table.add_definition(def);
    }
    
    for symbol in symbols_elsewhere {
        let def = SymbolDefinition {
            name: symbol.to_string(),
            kind: "class".to_string(),
            file: PathBuf::from(format!("lib/{}.dart", symbol.to_lowercase())),
            line: 1,
            end_line: 10,
            scope: None,
        };
        table.add_definition(def);
    }
    
    let file_symbols = table.get_symbols_in_file(&file_path);
    assert_eq!(file_symbols.len(), 2);
    assert!(file_symbols.iter().any(|s| s.name == "User"));
    assert!(file_symbols.iter().any(|s| s.name == "Employee"));
    assert!(!file_symbols.iter().any(|s| s.name == "Calculator"));
}

#[test]
fn test_usage_statistics() {
    let mut table = ProjectSymbolTable::new();
    
    // Add definitions
    for symbol in ["A", "B", "C"] {
        let def = SymbolDefinition {
            name: symbol.to_string(),
            kind: "class".to_string(),
            file: PathBuf::from(format!("{}.dart", symbol)),
            line: 1,
            end_line: 10,
            scope: None,
        };
        table.add_definition(def);
    }
    
    // Add varying numbers of usages
    // A: 5 usages, B: 3 usages, C: 1 usage
    for i in 0..5 {
        let usage = SymbolUsage {
            symbol: "A".to_string(),
            file: PathBuf::from(format!("usage{}.dart", i)),
            line: 10,
            context: UsageContext {
                usage_type: "reference".to_string(),
                enclosing: None,
            },
        };
        table.add_usage(usage);
    }
    
    for i in 0..3 {
        let usage = SymbolUsage {
            symbol: "B".to_string(),
            file: PathBuf::from(format!("usage{}.dart", i)),
            line: 10,
            context: UsageContext {
                usage_type: "reference".to_string(),
                enclosing: None,
            },
        };
        table.add_usage(usage);
    }
    
    let usage = SymbolUsage {
        symbol: "C".to_string(),
        file: PathBuf::from("usage.dart"),
        line: 10,
        context: UsageContext {
            usage_type: "reference".to_string(),
            enclosing: None,
        },
    };
    table.add_usage(usage);
    
    let stats = table.get_usage_stats();
    
    assert_eq!(stats.total_symbols, 3);
    assert_eq!(stats.total_definitions, 3);
    assert_eq!(stats.total_usages, 9); // 5 + 3 + 1
    
    let (most_used_symbol, count) = stats.most_used_symbol.unwrap();
    assert_eq!(most_used_symbol, "A");
    assert_eq!(count, 5);
}