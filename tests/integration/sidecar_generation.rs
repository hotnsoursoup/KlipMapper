use assert_cmd::Command;
use std::fs;
use std::path::Path;
use tempfile::TempDir;
use serde_yaml::Value;

fn setup_test_project() -> TempDir {
    let temp_dir = TempDir::new().unwrap();
    let project_path = temp_dir.path();

    // Create Python file
    let python_code = r#"
import os
from typing import List, Optional

class DatabaseManager:
    """Manages database connections and operations."""
    
    def __init__(self, connection_string: str):
        self.connection_string = connection_string
        self.is_connected = False
    
    def connect(self) -> bool:
        """Establish database connection."""
        # Implementation would go here
        self.is_connected = True
        return True
    
    def disconnect(self) -> None:
        """Close database connection."""
        self.is_connected = False

def get_user_by_id(user_id: int) -> Optional[dict]:
    """Retrieve user by ID from database."""
    # Implementation would go here
    return None

def create_tables():
    """Initialize database tables."""
    pass

# Constants
MAX_CONNECTIONS = 100
DEFAULT_TIMEOUT = 30
"#;
    
    fs::write(project_path.join("database.py"), python_code).unwrap();

    temp_dir
}

#[test]
fn test_sidecar_file_creation() {
    let temp_dir = setup_test_project();
    let project_path = temp_dir.path();
    let source_file = project_path.join("database.py");
    let sidecar_dir = project_path.join(".agentmap");
    let sidecar_file = sidecar_dir.join("database.py.yaml");

    // Run scan command
    let mut cmd = Command::cargo_bin("agentmap").unwrap();
    cmd.arg("scan")
       .arg(project_path.to_str().unwrap())
       .assert()
       .success();

    // Verify sidecar directory and file exist
    assert!(sidecar_dir.exists(), "Sidecar directory should be created");
    assert!(sidecar_file.exists(), "Sidecar file should be created");
}

#[test]
fn test_sidecar_content_structure() {
    let temp_dir = setup_test_project();
    let project_path = temp_dir.path();
    let sidecar_file = project_path.join(".agentmap").join("database.py.yaml");

    // Run scan command
    let mut cmd = Command::cargo_bin("agentmap").unwrap();
    cmd.arg("scan")
       .arg(project_path.to_str().unwrap())
       .assert()
       .success();

    // Read and parse sidecar file
    let content = fs::read_to_string(&sidecar_file).unwrap();
    let yaml: Value = serde_yaml::from_str(&content).unwrap();

    // Verify basic structure
    assert!(yaml.get("metadata").is_some(), "Should have metadata section");
    assert!(yaml.get("symbols").is_some(), "Should have symbols section");
    
    if let Some(metadata) = yaml.get("metadata") {
        assert!(metadata.get("source_file").is_some(), "Should have source_file");
        assert!(metadata.get("language").is_some(), "Should have language");
        assert!(metadata.get("generated_at").is_some(), "Should have timestamp");
        assert!(metadata.get("file_hash").is_some(), "Should have file hash");
    }
}

#[test]
fn test_sidecar_symbols_content() {
    let temp_dir = setup_test_project();
    let project_path = temp_dir.path();
    let sidecar_file = project_path.join(".agentmap").join("database.py.yaml");

    // Run scan command
    let mut cmd = Command::cargo_bin("agentmap").unwrap();
    cmd.arg("scan")
       .arg(project_path.to_str().unwrap())
       .assert()
       .success();

    // Read and parse sidecar file
    let content = fs::read_to_string(&sidecar_file).unwrap();
    let yaml: Value = serde_yaml::from_str(&content).unwrap();

    // Verify symbols are captured
    let symbols = yaml.get("symbols").unwrap();
    
    // Check for expected symbols (depending on query implementation)
    let symbols_str = serde_yaml::to_string(symbols).unwrap();
    
    // Should contain class and function definitions
    assert!(symbols_str.contains("DatabaseManager") || 
            symbols_str.contains("class"), "Should capture class definitions");
    
    // Should contain function definitions  
    assert!(symbols_str.contains("get_user_by_id") || 
            symbols_str.contains("create_tables") ||
            symbols_str.contains("function"), "Should capture function definitions");
}

#[test]
fn test_sidecar_file_hash() {
    let temp_dir = setup_test_project();
    let project_path = temp_dir.path();
    let source_file = project_path.join("database.py");
    let sidecar_file = project_path.join(".agentmap").join("database.py.yaml");

    // Run scan command
    let mut cmd = Command::cargo_bin("agentmap").unwrap();
    cmd.arg("scan")
       .arg(project_path.to_str().unwrap())
       .assert()
       .success();

    // Get original hash
    let content1 = fs::read_to_string(&sidecar_file).unwrap();
    let yaml1: Value = serde_yaml::from_str(&content1).unwrap();
    let hash1 = yaml1.get("metadata").unwrap().get("file_hash").unwrap().as_str().unwrap();

    // Modify source file
    let modified_code = r#"
# Modified file
def new_function():
    pass
"#;
    fs::write(&source_file, modified_code).unwrap();

    // Run scan again
    let mut cmd = Command::cargo_bin("agentmap").unwrap();
    cmd.arg("scan")
       .arg(project_path.to_str().unwrap())
       .assert()
       .success();

    // Verify hash changed
    let content2 = fs::read_to_string(&sidecar_file).unwrap();
    let yaml2: Value = serde_yaml::from_str(&content2).unwrap();
    let hash2 = yaml2.get("metadata").unwrap().get("file_hash").unwrap().as_str().unwrap();

    assert_ne!(hash1, hash2, "File hash should change when source is modified");
}

#[test]
fn test_multiple_language_sidecars() {
    let temp_dir = TempDir::new().unwrap();
    let project_path = temp_dir.path();

    // Create Python file
    fs::write(project_path.join("script.py"), "def hello(): pass").unwrap();
    
    // Create TypeScript file
    fs::write(project_path.join("app.ts"), "function greet() {}").unwrap();
    
    // Create JavaScript file
    fs::write(project_path.join("utils.js"), "const add = (a, b) => a + b;").unwrap();

    // Run scan command
    let mut cmd = Command::cargo_bin("agentmap").unwrap();
    cmd.arg("scan")
       .arg(project_path.to_str().unwrap())
       .assert()
       .success();

    // Verify all sidecar files were created
    let sidecar_dir = project_path.join(".agentmap");
    assert!(sidecar_dir.join("script.py.yaml").exists());
    assert!(sidecar_dir.join("app.ts.yaml").exists());
    assert!(sidecar_dir.join("utils.js.yaml").exists());
}

#[test]
fn test_nested_directory_structure() {
    let temp_dir = TempDir::new().unwrap();
    let project_path = temp_dir.path();

    // Create nested directory structure
    let src_dir = project_path.join("src");
    let utils_dir = src_dir.join("utils");
    fs::create_dir_all(&utils_dir).unwrap();

    fs::write(src_dir.join("main.py"), "def main(): pass").unwrap();
    fs::write(utils_dir.join("helpers.py"), "def helper(): pass").unwrap();

    // Run scan command
    let mut cmd = Command::cargo_bin("agentmap").unwrap();
    cmd.arg("scan")
       .arg(project_path.to_str().unwrap())
       .assert()
       .success();

    // Verify nested sidecar structure
    let sidecar_dir = project_path.join(".agentmap");
    let src_sidecar = sidecar_dir.join("src");
    let utils_sidecar = src_sidecar.join("utils");

    assert!(src_sidecar.join("main.py.yaml").exists());
    assert!(utils_sidecar.join("helpers.py.yaml").exists());
}

#[test]
fn test_gitignore_pattern_exclusion() {
    let temp_dir = TempDir::new().unwrap();
    let project_path = temp_dir.path();

    // Create files that should be ignored
    let node_modules = project_path.join("node_modules");
    fs::create_dir_all(&node_modules).unwrap();
    fs::write(node_modules.join("package.js"), "// dependency").unwrap();

    let target_dir = project_path.join("target");
    fs::create_dir_all(&target_dir).unwrap();
    fs::write(target_dir.join("build.rs"), "// build artifact").unwrap();

    // Create files that should be included
    fs::write(project_path.join("src.py"), "def code(): pass").unwrap();

    // Run scan command
    let mut cmd = Command::cargo_bin("agentmap").unwrap();
    cmd.arg("scan")
       .arg(project_path.to_str().unwrap())
       .assert()
       .success();

    // Verify only appropriate files were processed
    let sidecar_dir = project_path.join(".agentmap");
    assert!(sidecar_dir.join("src.py.yaml").exists());
    assert!(!sidecar_dir.join("node_modules").exists());
    assert!(!sidecar_dir.join("target").exists());
}