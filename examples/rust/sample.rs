// <r:imports>
use std::collections::HashMap;
use serde::{Deserialize, Serialize};

// <r:structs>
#[derive(Debug, Serialize, Deserialize)]
pub struct User {
    pub id: u32,
    pub name: String,
    pub email: String,
}

// <r:impl>
impl User {
    pub fn new(id: u32, name: String, email: String) -> Self {
        Self { id, name, email }
    }
    
    pub fn is_valid(&self) -> bool {
        !self.name.is_empty() && self.email.contains('@')
    }
}

// <r:functions>
pub fn create_user_map() -> HashMap<u32, User> {
    let mut users = HashMap::new();
    users.insert(1, User::new(1, "Alice".to_string(), "alice@example.com".to_string()));
    users.insert(2, User::new(2, "Bob".to_string(), "bob@example.com".to_string()));
    users
}