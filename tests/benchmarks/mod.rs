use std::fs;
use std::path::Path;
use std::time::{Duration, Instant};
use tempfile::TempDir;

pub struct BenchmarkResult {
    pub name: String,
    pub duration: Duration,
    pub files_processed: usize,
    pub total_lines: usize,
    pub memory_usage_mb: f64,
}

impl BenchmarkResult {
    pub fn throughput_lines_per_sec(&self) -> f64 {
        self.total_lines as f64 / self.duration.as_secs_f64()
    }

    pub fn throughput_files_per_sec(&self) -> f64 {
        self.files_processed as f64 / self.duration.as_secs_f64()
    }
}

pub fn generate_large_python_file(lines: usize) -> String {
    let mut content = String::new();
    content.push_str("# Large Python file for performance testing\n");
    content.push_str("import os\nimport sys\nfrom typing import List, Dict, Any\n\n");

    for i in 0..lines / 10 {
        content.push_str(&format!(
            r#"
class TestClass{}:
    """Test class number {}."""
    
    def __init__(self, value: int):
        self.value = value
        self.id = {}
    
    def method_{}(self) -> int:
        """Method {}."""
        return self.value * {}
    
    def process_data(self, data: List[Dict[str, Any]]) -> Dict[str, Any]:
        """Process some data."""
        result = {{}}
        for item in data:
            key = f"item_{{item.get('id', 0)}}"
            result[key] = self.method_{}() + item.get('value', 0)
        return result

def function_{}(x: int, y: int) -> int:
    """Test function {}."""
    instance = TestClass{}(x)
    return instance.method_{}() + y

"#,
            i, i, i, i, i, i, i, i, i, i, i
        ));
    }

    content
}

pub fn generate_large_typescript_file(lines: usize) -> String {
    let mut content = String::new();
    content.push_str("// Large TypeScript file for performance testing\n");
    content.push_str("export interface BaseEntity {\n  id: number;\n  name: string;\n}\n\n");

    for i in 0..lines / 15 {
        content.push_str(&format!(
            r#"
export interface Entity{} extends BaseEntity {{
    value: number;
    metadata: Record<string, any>;
    createdAt: Date;
}}

export class Service{} {{
    private entities: Map<number, Entity{}> = new Map();
    private counter: number = 0;

    constructor(private readonly prefix: string = "service_{}") {{
        this.counter = 0;
    }}

    public async createEntity(data: Partial<Entity{}>): Promise<Entity{}> {{
        const entity: Entity{} = {{
            id: this.counter++,
            name: `${{this.prefix}}_${{this.counter}}`,
            value: data.value || {},
            metadata: data.metadata || {{}},
            createdAt: new Date()
        }};
        
        this.entities.set(entity.id, entity);
        return entity;
    }}

    public async getEntity(id: number): Promise<Entity{} | undefined> {{
        return this.entities.get(id);
    }}

    public async updateEntity(id: number, updates: Partial<Entity{}>): Promise<Entity{} | null> {{
        const existing = this.entities.get(id);
        if (!existing) return null;

        const updated: Entity{} = {{
            ...existing,
            ...updates,
            id: existing.id // Prevent ID changes
        }};

        this.entities.set(id, updated);
        return updated;
    }}

    public async deleteEntity(id: number): Promise<boolean> {{
        return this.entities.delete(id);
    }}

    public async listEntities(): Promise<Entity{}[]> {{
        return Array.from(this.entities.values());
    }}
}}

export function processEntity{}(entity: Entity{}): number {{
    return entity.value * {} + entity.id;
}}

export function validateEntity{}(entity: Partial<Entity{}>): boolean {{
    return entity.name !== undefined && 
           entity.value !== undefined && 
           entity.value > 0;
}}

"#,
            i, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i
        ));
    }

    content
}

pub fn generate_large_rust_file(lines: usize) -> String {
    let mut content = String::new();
    content.push_str("// Large Rust file for performance testing\n");
    content.push_str("use std::collections::HashMap;\nuse serde::{Deserialize, Serialize};\n\n");

    for i in 0..lines / 20 {
        content.push_str(&format!(
            r#"
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Entity{} {{
    pub id: u32,
    pub name: String,
    pub value: f64,
    pub metadata: HashMap<String, String>,
    pub active: bool,
}}

impl Entity{} {{
    pub fn new(id: u32, name: String, value: f64) -> Self {{
        Self {{
            id,
            name,
            value,
            metadata: HashMap::new(),
            active: true,
        }}
    }}

    pub fn set_metadata(&mut self, key: String, value: String) {{
        self.metadata.insert(key, value);
    }}

    pub fn get_metadata(&self, key: &str) -> Option<&String> {{
        self.metadata.get(key)
    }}

    pub fn calculate_score(&self) -> f64 {{
        if self.active {{
            self.value * 1.{} + self.id as f64
        }} else {{
            0.0
        }}
    }}

    pub fn deactivate(&mut self) {{
        self.active = false;
    }}

    pub fn activate(&mut self) {{
        self.active = true;
    }}
}}

impl Default for Entity{} {{
    fn default() -> Self {{
        Self::new({}, format!("entity_{}", {}), {}.0)
    }}
}}

pub trait Repository{} {{
    type Error;

    fn create(&mut self, entity: Entity{}) -> Result<Entity{}, Self::Error>;
    fn read(&self, id: u32) -> Result<Option<Entity{}>, Self::Error>;
    fn update(&mut self, id: u32, entity: Entity{}) -> Result<Option<Entity{}>, Self::Error>;
    fn delete(&mut self, id: u32) -> Result<bool, Self::Error>;
    fn list(&self) -> Result<Vec<Entity{}>, Self::Error>;
}}

pub struct InMemoryRepository{} {{
    entities: HashMap<u32, Entity{}>,
    next_id: u32,
}}

impl InMemoryRepository{} {{
    pub fn new() -> Self {{
        Self {{
            entities: HashMap::new(),
            next_id: 1,
        }}
    }}
}}

#[derive(Debug)]
pub enum RepositoryError{} {{
    NotFound,
    InvalidData,
    DatabaseError(String),
}}

impl Repository{} for InMemoryRepository{} {{
    type Error = RepositoryError{};

    fn create(&mut self, mut entity: Entity{}) -> Result<Entity{}, Self::Error> {{
        entity.id = self.next_id;
        self.next_id += 1;
        self.entities.insert(entity.id, entity.clone());
        Ok(entity)
    }}

    fn read(&self, id: u32) -> Result<Option<Entity{}>, Self::Error> {{
        Ok(self.entities.get(&id).cloned())
    }}

    fn update(&mut self, id: u32, entity: Entity{}) -> Result<Option<Entity{}>, Self::Error> {{
        if self.entities.contains_key(&id) {{
            self.entities.insert(id, entity.clone());
            Ok(Some(entity))
        }} else {{
            Ok(None)
        }}
    }}

    fn delete(&mut self, id: u32) -> Result<bool, Self::Error> {{
        Ok(self.entities.remove(&id).is_some())
    }}

    fn list(&self) -> Result<Vec<Entity{}>, Self::Error> {{
        Ok(self.entities.values().cloned().collect())
    }}
}}

pub fn process_entities_{}(entities: &[Entity{}]) -> f64 {{
    entities.iter()
        .filter(|e| e.active)
        .map(|e| e.calculate_score())
        .sum()
}}

pub fn find_entity_by_name_{}(entities: &[Entity{}], name: &str) -> Option<&Entity{}> {{
    entities.iter().find(|e| e.name == name)
}}

"#,
            i, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i, i
        ));
    }

    content
}

pub fn create_large_test_project(temp_dir: &TempDir, files_per_lang: usize, lines_per_file: usize) -> usize {
    let project_path = temp_dir.path();
    let mut total_lines = 0;

    // Create Python files
    let python_dir = project_path.join("python");
    fs::create_dir_all(&python_dir).unwrap();
    for i in 0..files_per_lang {
        let content = generate_large_python_file(lines_per_file);
        total_lines += content.lines().count();
        fs::write(python_dir.join(format!("module_{}.py", i)), content).unwrap();
    }

    // Create TypeScript files
    let ts_dir = project_path.join("typescript");
    fs::create_dir_all(&ts_dir).unwrap();
    for i in 0..files_per_lang {
        let content = generate_large_typescript_file(lines_per_file);
        total_lines += content.lines().count();
        fs::write(ts_dir.join(format!("service_{}.ts", i)), content).unwrap();
    }

    // Create Rust files
    let rust_dir = project_path.join("rust");
    fs::create_dir_all(&rust_dir).unwrap();
    for i in 0..files_per_lang {
        let content = generate_large_rust_file(lines_per_file);
        total_lines += content.lines().count();
        fs::write(rust_dir.join(format!("lib_{}.rs", i)), content).unwrap();
    }

    total_lines
}

#[cfg(test)]
mod performance_tests {
    use super::*;
    use assert_cmd::Command;

    #[test]
    #[ignore] // Run with --ignored flag for performance testing
    fn benchmark_small_project() {
        let temp_dir = TempDir::new().unwrap();
        let total_lines = create_large_test_project(&temp_dir, 5, 100);
        
        let start = Instant::now();
        let mut cmd = Command::cargo_bin("agentmap").unwrap();
        let output = cmd.arg("scan")
            .arg(temp_dir.path().to_str().unwrap())
            .assert()
            .success();

        let duration = start.elapsed();
        
        let result = BenchmarkResult {
            name: "small_project".to_string(),
            duration,
            files_processed: 15, // 5 files per 3 languages
            total_lines,
            memory_usage_mb: 0.0, // Would need process monitoring to measure
        };

        println!("Small Project Benchmark:");
        println!("  Duration: {:?}", result.duration);
        println!("  Files: {}", result.files_processed);
        println!("  Lines: {}", result.total_lines);
        println!("  Throughput: {:.2} lines/sec", result.throughput_lines_per_sec());
        println!("  Throughput: {:.2} files/sec", result.throughput_files_per_sec());

        // Basic performance assertions
        assert!(result.duration.as_secs() < 30, "Should complete in under 30 seconds");
        assert!(result.throughput_lines_per_sec() > 100.0, "Should process at least 100 lines/sec");
    }

    #[test]
    #[ignore]
    fn benchmark_medium_project() {
        let temp_dir = TempDir::new().unwrap();
        let total_lines = create_large_test_project(&temp_dir, 20, 500);
        
        let start = Instant::now();
        let mut cmd = Command::cargo_bin("agentmap").unwrap();
        cmd.arg("scan")
            .arg(temp_dir.path().to_str().unwrap())
            .timeout(Duration::from_secs(120))
            .assert()
            .success();

        let duration = start.elapsed();
        
        let result = BenchmarkResult {
            name: "medium_project".to_string(),
            duration,
            files_processed: 60, // 20 files per 3 languages
            total_lines,
            memory_usage_mb: 0.0,
        };

        println!("Medium Project Benchmark:");
        println!("  Duration: {:?}", result.duration);
        println!("  Files: {}", result.files_processed);
        println!("  Lines: {}", result.total_lines);
        println!("  Throughput: {:.2} lines/sec", result.throughput_lines_per_sec());
        println!("  Throughput: {:.2} files/sec", result.throughput_files_per_sec());

        assert!(result.duration.as_secs() < 120, "Should complete in under 2 minutes");
        assert!(result.throughput_lines_per_sec() > 50.0, "Should process at least 50 lines/sec");
    }

    #[test]
    #[ignore]
    fn benchmark_check_performance() {
        let temp_dir = TempDir::new().unwrap();
        let total_lines = create_large_test_project(&temp_dir, 10, 200);
        
        // First scan to generate sidecars
        let mut scan_cmd = Command::cargo_bin("agentmap").unwrap();
        scan_cmd.arg("scan")
            .arg(temp_dir.path().to_str().unwrap())
            .assert()
            .success();

        // Then benchmark the check command
        let start = Instant::now();
        let mut check_cmd = Command::cargo_bin("agentmap").unwrap();
        check_cmd.arg("check")
            .arg(temp_dir.path().to_str().unwrap())
            .assert()
            .success();

        let duration = start.elapsed();
        
        println!("Check Command Benchmark:");
        println!("  Duration: {:?}", duration);
        println!("  Files: 30");
        println!("  Lines: {}", total_lines);

        // Check should be faster than scan
        assert!(duration.as_secs() < 10, "Check should complete in under 10 seconds");
    }
}