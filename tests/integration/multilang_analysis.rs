use assert_cmd::Command;
use std::fs;
use std::path::Path;
use tempfile::TempDir;
use serde_yaml::Value;

fn setup_multilang_project() -> TempDir {
    let temp_dir = TempDir::new().unwrap();
    let project_path = temp_dir.path();

    // Create project structure
    fs::create_dir_all(project_path.join("src")).unwrap();
    fs::create_dir_all(project_path.join("frontend")).unwrap();
    fs::create_dir_all(project_path.join("backend")).unwrap();

    // Rust code with cross-references
    let rust_code = r#"
use serde::{Deserialize, Serialize};
use std::collections::HashMap;

#[derive(Debug, Serialize, Deserialize)]
pub struct User {
    pub id: u32,
    pub name: String,
    pub email: String,
}

pub trait UserRepository {
    fn create_user(&mut self, user: User) -> Result<User, String>;
    fn get_user(&self, id: u32) -> Option<User>;
}

pub struct InMemoryRepository {
    users: HashMap<u32, User>,
}

impl UserRepository for InMemoryRepository {
    fn create_user(&mut self, user: User) -> Result<User, String> {
        self.users.insert(user.id, user.clone());
        Ok(user)
    }

    fn get_user(&self, id: u32) -> Option<User> {
        self.users.get(&id).cloned()
    }
}
"#;
    fs::write(project_path.join("src/lib.rs"), rust_code).unwrap();

    // TypeScript code that references similar concepts
    let ts_code = r#"
export interface User {
    id: number;
    name: string;
    email: string;
}

export interface UserRepository {
    createUser(user: User): Promise<User>;
    getUser(id: number): Promise<User | null>;
}

export class ApiUserRepository implements UserRepository {
    private apiUrl: string;

    constructor(apiUrl: string) {
        this.apiUrl = apiUrl;
    }

    async createUser(user: User): Promise<User> {
        const response = await fetch(`${this.apiUrl}/users`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(user)
        });
        
        if (!response.ok) {
            throw new Error('Failed to create user');
        }
        
        return response.json();
    }

    async getUser(id: number): Promise<User | null> {
        const response = await fetch(`${this.apiUrl}/users/${id}`);
        
        if (response.status === 404) {
            return null;
        }
        
        if (!response.ok) {
            throw new Error('Failed to get user');
        }
        
        return response.json();
    }
}

export function validateUser(user: User): boolean {
    return user.name.length > 0 && user.email.includes('@');
}
"#;
    fs::write(project_path.join("frontend/user-api.ts"), ts_code).unwrap();

    // Python code with similar patterns
    let python_code = r#"
from abc import ABC, abstractmethod
from dataclasses import dataclass
from typing import Optional, Dict
import json

@dataclass
class User:
    id: int
    name: str
    email: str
    
    def to_dict(self) -> Dict:
        return {
            'id': self.id,
            'name': self.name,
            'email': self.email
        }
    
    @classmethod
    def from_dict(cls, data: Dict) -> 'User':
        return cls(
            id=data['id'],
            name=data['name'],
            email=data['email']
        )

class UserRepository(ABC):
    @abstractmethod
    def create_user(self, user: User) -> User:
        pass
    
    @abstractmethod
    def get_user(self, user_id: int) -> Optional[User]:
        pass

class FileUserRepository(UserRepository):
    def __init__(self, filename: str):
        self.filename = filename
        self._users: Dict[int, User] = {}
        self._load_users()
    
    def _load_users(self):
        try:
            with open(self.filename, 'r') as f:
                data = json.load(f)
                for user_data in data:
                    user = User.from_dict(user_data)
                    self._users[user.id] = user
        except FileNotFoundError:
            pass
    
    def _save_users(self):
        with open(self.filename, 'w') as f:
            users_data = [user.to_dict() for user in self._users.values()]
            json.dump(users_data, f, indent=2)
    
    def create_user(self, user: User) -> User:
        self._users[user.id] = user
        self._save_users()
        return user
    
    def get_user(self, user_id: int) -> Optional[User]:
        return self._users.get(user_id)

def validate_email(email: str) -> bool:
    return '@' in email and '.' in email
"#;
    fs::write(project_path.join("backend/user_service.py"), python_code).unwrap();

    temp_dir
}

#[test]
fn test_multilang_symbol_extraction() {
    let temp_dir = setup_multilang_project();
    let project_path = temp_dir.path();

    // Run scan on the entire project
    let mut cmd = Command::cargo_bin("agentmap").unwrap();
    cmd.arg("scan")
       .arg(project_path.to_str().unwrap())
       .assert()
       .success()
       .stdout(predicates::str::contains("files processed"));

    // Verify sidecar files were created for all languages
    let sidecar_dir = project_path.join(".agentmap");
    assert!(sidecar_dir.join("src/lib.rs.yaml").exists());
    assert!(sidecar_dir.join("frontend/user-api.ts.yaml").exists());
    assert!(sidecar_dir.join("backend/user_service.py.yaml").exists());
}

#[test]
fn test_cross_language_symbol_consistency() {
    let temp_dir = setup_multilang_project();
    let project_path = temp_dir.path();

    // Run scan
    let mut cmd = Command::cargo_bin("agentmap").unwrap();
    cmd.arg("scan")
       .arg(project_path.to_str().unwrap())
       .assert()
       .success();

    // Read all sidecar files
    let sidecar_dir = project_path.join(".agentmap");
    
    let rust_content = fs::read_to_string(sidecar_dir.join("src/lib.rs.yaml")).unwrap();
    let ts_content = fs::read_to_string(sidecar_dir.join("frontend/user-api.ts.yaml")).unwrap();
    let python_content = fs::read_to_string(sidecar_dir.join("backend/user_service.py.yaml")).unwrap();

    // All files should reference similar concepts (User, UserRepository)
    // This is a basic check - in a real implementation you'd parse the YAML 
    // and check for specific symbols
    assert!(rust_content.contains("User") || rust_content.to_lowercase().contains("user"));
    assert!(ts_content.contains("User") || ts_content.to_lowercase().contains("user"));
    assert!(python_content.contains("User") || python_content.to_lowercase().contains("user"));
}

#[test]
fn test_language_specific_query_patterns() {
    let temp_dir = setup_multilang_project();
    let project_path = temp_dir.path();

    // Test Rust-specific query
    let mut rust_cmd = Command::cargo_bin("agentmap").unwrap();
    rust_cmd.arg("query")
        .arg("--language")
        .arg("rust")
        .arg("--type")
        .arg("defs")
        .arg(project_path.join("src/lib.rs").to_str().unwrap())
        .assert()
        .success()
        .stdout(predicates::str::contains("Query results"));

    // Test TypeScript-specific query
    let mut ts_cmd = Command::cargo_bin("agentmap").unwrap();
    ts_cmd.arg("query")
        .arg("--language")
        .arg("typescript")
        .arg("--type")
        .arg("defs")
        .arg(project_path.join("frontend/user-api.ts").to_str().unwrap())
        .assert()
        .success()
        .stdout(predicates::str::contains("Query results"));

    // Test Python-specific query
    let mut py_cmd = Command::cargo_bin("agentmap").unwrap();
    py_cmd.arg("query")
        .arg("--language")
        .arg("python")
        .arg("--type")
        .arg("defs")
        .arg(project_path.join("backend/user_service.py").to_str().unwrap())
        .assert()
        .success()
        .stdout(predicates::str::contains("Query results"));
}

#[test]
fn test_project_wide_analysis() {
    let temp_dir = setup_multilang_project();
    let project_path = temp_dir.path();

    // Run scan with symbol resolution enabled (if implemented)
    let mut cmd = Command::cargo_bin("agentmap").unwrap();
    cmd.arg("scan")
       .arg("--enable-symbol-resolution")
       .arg(project_path.to_str().unwrap())
       .assert()
       .success();

    // The implementation would analyze cross-file relationships
    // For now, just verify the command runs successfully
}

#[test]
fn test_check_consistency_across_languages() {
    let temp_dir = setup_multilang_project();
    let project_path = temp_dir.path();

    // First scan to generate sidecars
    let mut scan_cmd = Command::cargo_bin("agentmap").unwrap();
    scan_cmd.arg("scan")
        .arg(project_path.to_str().unwrap())
        .assert()
        .success();

    // Run check command
    let mut check_cmd = Command::cargo_bin("agentmap").unwrap();
    check_cmd.arg("check")
        .arg(project_path.to_str().unwrap())
        .assert()
        .success()
        .stdout(predicates::str::contains("files checked"));
}

#[test]
fn test_watch_mode_multilang() {
    let temp_dir = setup_multilang_project();
    let project_path = temp_dir.path();

    // Test that watch command starts successfully
    // Note: This test would need to be more sophisticated in a real implementation
    // to actually test file change detection
    let mut cmd = Command::cargo_bin("agentmap").unwrap();
    cmd.arg("watch")
       .arg("--timeout")
       .arg("1") // 1 second timeout for testing
       .arg(project_path.to_str().unwrap())
       .timeout(std::time::Duration::from_secs(2))
       .assert()
       .success()
       .stdout(predicates::str::contains("Watching").or(predicates::str::contains("watch")));
}

#[test]
fn test_language_detection_accuracy() {
    let temp_dir = setup_multilang_project();
    let project_path = temp_dir.path();

    // Run scan
    let mut cmd = Command::cargo_bin("agentmap").unwrap();
    cmd.arg("scan")
       .arg(project_path.to_str().unwrap())
       .assert()
       .success();

    // Check that each file was processed with correct language detection
    let sidecar_dir = project_path.join(".agentmap");
    
    // Read Rust sidecar
    let rust_content = fs::read_to_string(sidecar_dir.join("src/lib.rs.yaml")).unwrap();
    let rust_yaml: Value = serde_yaml::from_str(&rust_content).unwrap();
    if let Some(lang) = rust_yaml.get("metadata").and_then(|m| m.get("language")) {
        assert_eq!(lang.as_str().unwrap(), "rust");
    }

    // Read TypeScript sidecar  
    let ts_content = fs::read_to_string(sidecar_dir.join("frontend/user-api.ts.yaml")).unwrap();
    let ts_yaml: Value = serde_yaml::from_str(&ts_content).unwrap();
    if let Some(lang) = ts_yaml.get("metadata").and_then(|m| m.get("language")) {
        assert_eq!(lang.as_str().unwrap(), "typescript");
    }

    // Read Python sidecar
    let py_content = fs::read_to_string(sidecar_dir.join("backend/user_service.py.yaml")).unwrap();
    let py_yaml: Value = serde_yaml::from_str(&py_content).unwrap();
    if let Some(lang) = py_yaml.get("metadata").and_then(|m| m.get("language")) {
        assert_eq!(lang.as_str().unwrap(), "python");
    }
}