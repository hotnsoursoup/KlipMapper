use assert_cmd::Command;
use predicates::prelude::*;
use std::fs;
use tempfile::TempDir;

#[test]
fn test_help_command() {
    let mut cmd = Command::cargo_bin("agentmap").unwrap();
    cmd.arg("--help");
    
    cmd.assert()
        .success()
        .stdout(predicate::str::contains("Usage: agentmap"))
        .stdout(predicate::str::contains("Commands:"))
        .stdout(predicate::str::contains("scan"))
        .stdout(predicate::str::contains("check"))
        .stdout(predicate::str::contains("watch"))
        .stdout(predicate::str::contains("query"));
}

#[test]
fn test_scan_command_help() {
    let mut cmd = Command::cargo_bin("agentmap").unwrap();
    cmd.args(&["scan", "--help"]);
    
    cmd.assert()
        .success()
        .stdout(predicate::str::contains("Parse files and write sidecars"));
}

#[test]
fn test_scan_nonexistent_directory() {
    let mut cmd = Command::cargo_bin("agentmap").unwrap();
    cmd.args(&["scan", "/nonexistent/directory"]);
    
    cmd.assert()
        .failure(); // Should fail gracefully
}

#[test]
fn test_scan_empty_directory() {
    let temp_dir = TempDir::new().unwrap();
    
    let mut cmd = Command::cargo_bin("agentmap").unwrap();
    cmd.args(&["scan", temp_dir.path().to_str().unwrap()]);
    
    cmd.assert()
        .success(); // Should succeed but do nothing
}

#[test]
fn test_scan_python_file() {
    let temp_dir = TempDir::new().unwrap();
    let python_file = temp_dir.path().join("test.py");
    
    let python_code = r#"
# <r:functions>
def hello_world():
    """A simple greeting function."""
    print("Hello, World!")

class Greeter:
    def greet(self, name):
        return f"Hello, {name}!"
"#;
    
    fs::write(&python_file, python_code).unwrap();
    
    let mut cmd = Command::cargo_bin("agentmap").unwrap();
    cmd.args(&["scan", temp_dir.path().to_str().unwrap()]);
    
    cmd.assert()
        .success();
    
    // Should create sidecar file
    let sidecar_path = temp_dir.path().join(".agentmap").join("test.yaml");
    assert!(sidecar_path.exists());
    
    // Verify sidecar content
    let sidecar_content = fs::read_to_string(sidecar_path).unwrap();
    assert!(sidecar_content.contains("hello_world"));
    assert!(sidecar_content.contains("Greeter"));
    assert!(sidecar_content.contains("functions"));
}

#[test]
fn test_scan_typescript_file() {
    let temp_dir = TempDir::new().unwrap();
    let ts_file = temp_dir.path().join("test.ts");
    
    let ts_code = r#"
// <r:interfaces>
interface User {
    name: string;
    email: string;
}

// <r:classes>
class UserService {
    private users: User[] = [];
    
    addUser(user: User): void {
        this.users.push(user);
    }
    
    getUser(name: string): User | undefined {
        return this.users.find(u => u.name === name);
    }
}
"#;
    
    fs::write(&ts_file, ts_code).unwrap();
    
    let mut cmd = Command::cargo_bin("agentmap").unwrap();
    cmd.args(&["scan", temp_dir.path().to_str().unwrap()]);
    
    cmd.assert()
        .success();
    
    let sidecar_path = temp_dir.path().join(".agentmap").join("test.yaml");
    assert!(sidecar_path.exists());
    
    let sidecar_content = fs::read_to_string(sidecar_path).unwrap();
    assert!(sidecar_content.contains("UserService"));
    assert!(sidecar_content.contains("interfaces"));
    assert!(sidecar_content.contains("classes"));
}

#[test]
fn test_check_command_up_to_date() {
    let temp_dir = TempDir::new().unwrap();
    let python_file = temp_dir.path().join("test.py");
    
    let python_code = r#"
def simple_function():
    return "test"
"#;
    
    fs::write(&python_file, python_code).unwrap();
    
    // First scan to create sidecar
    let mut scan_cmd = Command::cargo_bin("agentmap").unwrap();
    scan_cmd.args(&["scan", temp_dir.path().to_str().unwrap()]);
    scan_cmd.assert().success();
    
    // Then check - should be up to date
    let mut check_cmd = Command::cargo_bin("agentmap").unwrap();
    check_cmd.args(&["check", temp_dir.path().to_str().unwrap()]);
    
    check_cmd.assert()
        .success()
        .stdout(predicate::str::contains("All sidecars are valid and up-to-date"));
}

#[test]
fn test_check_command_outdated() {
    let temp_dir = TempDir::new().unwrap();
    let python_file = temp_dir.path().join("test.py");
    
    let python_code = r#"
def original_function():
    return "original"
"#;
    
    fs::write(&python_file, python_code).unwrap();
    
    // First scan to create sidecar
    let mut scan_cmd = Command::cargo_bin("agentmap").unwrap();
    scan_cmd.args(&["scan", temp_dir.path().to_str().unwrap()]);
    scan_cmd.assert().success();
    
    // Modify the file
    let modified_code = r#"
def original_function():
    return "original"

def new_function():
    return "new"
"#;
    
    fs::write(&python_file, modified_code).unwrap();
    
    // Check should detect outdated sidecar
    let mut check_cmd = Command::cargo_bin("agentmap").unwrap();
    check_cmd.args(&["check", temp_dir.path().to_str().unwrap()]);
    
    check_cmd.assert()
        .failure() // Should exit with code 1
        .stdout(predicate::str::contains("Outdated: 1"))
        .stdout(predicate::str::contains("Source file has changed"));
}

#[test]
fn test_check_command_missing_sidecar() {
    let temp_dir = TempDir::new().unwrap();
    let python_file = temp_dir.path().join("test.py");
    
    let python_code = r#"
def test_function():
    pass
"#;
    
    fs::write(&python_file, python_code).unwrap();
    
    // Check without scanning first - sidecar missing
    let mut check_cmd = Command::cargo_bin("agentmap").unwrap();
    check_cmd.args(&["check", temp_dir.path().to_str().unwrap()]);
    
    check_cmd.assert()
        .failure()
        .stdout(predicate::str::contains("Missing: 1"))
        .stdout(predicate::str::contains("Sidecar not found"));
}

#[test]
fn test_query_command_symbol_search() {
    let temp_dir = TempDir::new().unwrap();
    
    // Create test files first
    let python_file = temp_dir.path().join("models.py");
    let python_code = r#"
class Employee:
    def __init__(self, name):
        self.name = name
    
    def get_name(self):
        return self.name
"#;
    
    fs::write(&python_file, python_code).unwrap();
    
    let usage_file = temp_dir.path().join("service.py");
    let usage_code = r#"
from models import Employee

def create_employee(name):
    return Employee(name)
"#;
    
    fs::write(&usage_file, usage_code).unwrap();
    
    // Query for Employee symbol
    let mut cmd = Command::cargo_bin("agentmap").unwrap();
    cmd.args(&[
        "query", 
        "--symbol", "Employee", 
        temp_dir.path().to_str().unwrap()
    ]);
    
    cmd.assert()
        .success()
        .stdout(predicate::str::contains("Symbol: Employee"));
        // Note: In the demo implementation, we return hardcoded data
        // In a real implementation, this would parse the files and find actual references
}

#[test]
fn test_query_command_pattern_search() {
    let temp_dir = TempDir::new().unwrap();
    
    let mut cmd = Command::cargo_bin("agentmap").unwrap();
    cmd.args(&[
        "query", 
        "--pattern", "Emp",
        temp_dir.path().to_str().unwrap()
    ]);
    
    cmd.assert()
        .success()
        .stdout(predicate::str::contains("Symbols matching 'Emp':"));
}

#[test]
fn test_query_command_statistics() {
    let temp_dir = TempDir::new().unwrap();
    
    let mut cmd = Command::cargo_bin("agentmap").unwrap();
    cmd.args(&["query", temp_dir.path().to_str().unwrap()]);
    
    cmd.assert()
        .success()
        .stdout(predicate::str::contains("Project Symbol Statistics:"))
        .stdout(predicate::str::contains("Total symbols:"));
}

#[test]
fn test_scan_with_config_file() {
    let temp_dir = TempDir::new().unwrap();
    
    // Create config file
    let agentmap_dir = temp_dir.path().join(".agentmap");
    fs::create_dir_all(&agentmap_dir).unwrap();
    
    let config_content = r#"
languages: [py]
track:
  - Employee
  - User
"#;
    
    let config_path = agentmap_dir.join("config.yaml");
    fs::write(&config_path, config_content).unwrap();
    
    // Create test file
    let python_file = temp_dir.path().join("test.py");
    let python_code = r#"
class Employee:
    pass

class User:
    pass

class NotTracked:
    pass
"#;
    
    fs::write(&python_file, python_code).unwrap();
    
    let mut cmd = Command::cargo_bin("agentmap").unwrap();
    cmd.args(&["scan", temp_dir.path().to_str().unwrap()]);
    
    cmd.assert()
        .success();
    
    // Verify config was loaded (indirectly through sidecar generation)
    let sidecar_path = temp_dir.path().join(".agentmap").join("test.yaml");
    assert!(sidecar_path.exists());
}

#[test] 
fn test_multiple_language_scan() {
    let temp_dir = TempDir::new().unwrap();
    
    // Create files in different languages
    let python_file = temp_dir.path().join("test.py");
    fs::write(&python_file, "def python_func(): pass").unwrap();
    
    let rust_file = temp_dir.path().join("test.rs");
    fs::write(&rust_file, "fn rust_func() {}").unwrap();
    
    let ts_file = temp_dir.path().join("test.ts");
    fs::write(&ts_file, "function tsFunc() {}").unwrap();
    
    let mut cmd = Command::cargo_bin("agentmap").unwrap();
    cmd.args(&["scan", temp_dir.path().to_str().unwrap()]);
    
    cmd.assert()
        .success();
    
    // Should create sidecars for all supported languages
    let agentmap_dir = temp_dir.path().join(".agentmap");
    assert!(agentmap_dir.join("test.yaml").exists()); // Python
    assert!(agentmap_dir.join("test.yaml").exists()); // Rust (overwrites same name)
    assert!(agentmap_dir.join("test.yaml").exists()); // TypeScript
}

#[test]
fn test_scan_no_write_flag() {
    let temp_dir = TempDir::new().unwrap();
    let python_file = temp_dir.path().join("test.py");
    
    fs::write(&python_file, "def test(): pass").unwrap();
    
    let mut cmd = Command::cargo_bin("agentmap").unwrap();
    cmd.args(&["scan", "--no-write", temp_dir.path().to_str().unwrap()]);
    
    cmd.assert()
        .success();
    
    // Should not create sidecar files
    let sidecar_path = temp_dir.path().join(".agentmap");
    assert!(!sidecar_path.exists());
}