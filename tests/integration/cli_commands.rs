use assert_cmd::Command;
use predicates::prelude::*;
use std::fs;
use tempfile::TempDir;

fn setup_test_project() -> TempDir {
    let temp_dir = TempDir::new().unwrap();
    let project_path = temp_dir.path();

    // Create a simple Python file
    let python_code = r#"
class User:
    def __init__(self, name):
        self.name = name

def create_user(name):
    return User(name)
"#;
    
    fs::write(project_path.join("main.py"), python_code).unwrap();

    // Create a simple TypeScript file
    let ts_code = r#"
interface User {
    name: string;
    email: string;
}

class UserService {
    private users: User[] = [];

    addUser(user: User): void {
        this.users.push(user);
    }
}

function createUser(name: string, email: string): User {
    return { name, email };
}
"#;
    
    fs::write(project_path.join("service.ts"), ts_code).unwrap();

    temp_dir
}

#[test]
fn test_scan_command() {
    let temp_dir = setup_test_project();
    let project_path = temp_dir.path();

    let mut cmd = Command::cargo_bin("agentmap").unwrap();
    cmd.arg("scan")
       .arg(project_path.to_str().unwrap())
       .assert()
       .success()
       .stdout(predicate::str::contains("Scanning"))
       .stdout(predicate::str::contains("files processed"));
}

#[test]
fn test_scan_with_specific_language() {
    let temp_dir = setup_test_project();
    let project_path = temp_dir.path();

    let mut cmd = Command::cargo_bin("agentmap").unwrap();
    cmd.arg("scan")
       .arg("--language")
       .arg("python")
       .arg(project_path.to_str().unwrap())
       .assert()
       .success()
       .stdout(predicate::str::contains("Scanning"));
}

#[test]
fn test_check_command() {
    let temp_dir = setup_test_project();
    let project_path = temp_dir.path();

    // First, scan to create sidecar files
    let mut scan_cmd = Command::cargo_bin("agentmap").unwrap();
    scan_cmd.arg("scan")
        .arg(project_path.to_str().unwrap())
        .assert()
        .success();

    // Then check the files
    let mut check_cmd = Command::cargo_bin("agentmap").unwrap();
    check_cmd.arg("check")
        .arg(project_path.to_str().unwrap())
        .assert()
        .success()
        .stdout(predicate::str::contains("Checking"));
}

#[test]
fn test_check_missing_sidecars() {
    let temp_dir = setup_test_project();
    let project_path = temp_dir.path();

    // Run check without scanning first (no sidecar files exist)
    let mut cmd = Command::cargo_bin("agentmap").unwrap();
    cmd.arg("check")
       .arg(project_path.to_str().unwrap())
       .assert()
       .success()
       .stdout(predicate::str::contains("missing"));
}

#[test]
fn test_query_command() {
    let temp_dir = setup_test_project();
    let project_path = temp_dir.path();

    let mut cmd = Command::cargo_bin("agentmap").unwrap();
    cmd.arg("query")
       .arg("--language")
       .arg("python")
       .arg("--type")
       .arg("defs")
       .arg(project_path.join("main.py").to_str().unwrap())
       .assert()
       .success()
       .stdout(predicate::str::contains("Query results"));
}

#[test]
fn test_scan_with_verbose_output() {
    let temp_dir = setup_test_project();
    let project_path = temp_dir.path();

    let mut cmd = Command::cargo_bin("agentmap").unwrap();
    cmd.arg("scan")
       .arg("--verbose")
       .arg(project_path.to_str().unwrap())
       .assert()
       .success()
       .stdout(predicate::str::contains("DEBUG").or(predicate::str::contains("TRACE")));
}

#[test]
fn test_scan_invalid_path() {
    let mut cmd = Command::cargo_bin("agentmap").unwrap();
    cmd.arg("scan")
       .arg("/nonexistent/path")
       .assert()
       .failure()
       .stderr(predicate::str::contains("No such file or directory")
               .or(predicate::str::contains("cannot find the path")));
}

#[test]
fn test_help_command() {
    let mut cmd = Command::cargo_bin("agentmap").unwrap();
    cmd.arg("--help")
       .assert()
       .success()
       .stdout(predicate::str::contains("Usage:"))
       .stdout(predicate::str::contains("Commands:"))
       .stdout(predicate::str::contains("scan"))
       .stdout(predicate::str::contains("check"));
}

#[test]
fn test_version_command() {
    let mut cmd = Command::cargo_bin("agentmap").unwrap();
    cmd.arg("--version")
       .assert()
       .success()
       .stdout(predicate::str::contains("agentmap"));
}

#[test]
fn test_scan_with_include_pattern() {
    let temp_dir = setup_test_project();
    let project_path = temp_dir.path();

    // Create additional file that should be excluded
    fs::write(project_path.join("test.txt"), "Not a code file").unwrap();

    let mut cmd = Command::cargo_bin("agentmap").unwrap();
    cmd.arg("scan")
       .arg("--include")
       .arg("*.py")
       .arg(project_path.to_str().unwrap())
       .assert()
       .success()
       .stdout(predicate::str::contains("Scanning"));
}

#[test]
fn test_scan_with_exclude_pattern() {
    let temp_dir = setup_test_project();
    let project_path = temp_dir.path();

    let mut cmd = Command::cargo_bin("agentmap").unwrap();
    cmd.arg("scan")
       .arg("--exclude")
       .arg("*.ts")
       .arg(project_path.to_str().unwrap())
       .assert()
       .success()
       .stdout(predicate::str::contains("Scanning"));
}

// Test configuration file loading
#[test]
fn test_scan_with_config_file() {
    let temp_dir = setup_test_project();
    let project_path = temp_dir.path();

    // Create a config file
    let config_content = r#"
languages:
  - python
  - typescript
include:
  - "*.py"
  - "*.ts"
exclude:
  - "test_*"
tags:
  project: "test-project"
  team: "development"
"#;
    
    fs::write(project_path.join("agentmap.yaml"), config_content).unwrap();

    let mut cmd = Command::cargo_bin("agentmap").unwrap();
    cmd.arg("scan")
       .arg("--config")
       .arg(project_path.join("agentmap.yaml").to_str().unwrap())
       .arg(project_path.to_str().unwrap())
       .assert()
       .success()
       .stdout(predicate::str::contains("Scanning"));
}