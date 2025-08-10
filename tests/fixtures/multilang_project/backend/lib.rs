use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use chrono::{DateTime, Utc};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct User {
    pub id: u32,
    pub username: String,
    pub email: String,
    pub created_at: DateTime<Utc>,
    pub is_active: bool,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct CreateUserRequest {
    pub username: String,
    pub email: String,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct UpdateUserRequest {
    pub username: Option<String>,
    pub email: Option<String>,
    pub is_active: Option<bool>,
}

pub trait UserRepository {
    type Error;

    fn create_user(&mut self, request: CreateUserRequest) -> Result<User, Self::Error>;
    fn get_user(&self, id: u32) -> Result<Option<User>, Self::Error>;
    fn update_user(&mut self, id: u32, request: UpdateUserRequest) -> Result<Option<User>, Self::Error>;
    fn delete_user(&mut self, id: u32) -> Result<bool, Self::Error>;
    fn list_users(&self) -> Result<Vec<User>, Self::Error>;
}

pub struct InMemoryUserRepository {
    users: HashMap<u32, User>,
    next_id: u32,
}

#[derive(Debug)]
pub enum RepositoryError {
    UserNotFound,
    ValidationError(String),
    DatabaseError(String),
}

impl InMemoryUserRepository {
    pub fn new() -> Self {
        Self {
            users: HashMap::new(),
            next_id: 1,
        }
    }

    fn validate_user_data(username: &str, email: &str) -> Result<(), RepositoryError> {
        if username.len() < 3 || username.len() > 50 {
            return Err(RepositoryError::ValidationError(
                "Username must be between 3 and 50 characters".to_string()
            ));
        }

        if !email.contains('@') || !email.contains('.') {
            return Err(RepositoryError::ValidationError(
                "Invalid email format".to_string()
            ));
        }

        Ok(())
    }
}

impl UserRepository for InMemoryUserRepository {
    type Error = RepositoryError;

    fn create_user(&mut self, request: CreateUserRequest) -> Result<User, Self::Error> {
        Self::validate_user_data(&request.username, &request.email)?;

        let user = User {
            id: self.next_id,
            username: request.username,
            email: request.email,
            created_at: Utc::now(),
            is_active: true,
        };

        self.users.insert(user.id, user.clone());
        self.next_id += 1;

        Ok(user)
    }

    fn get_user(&self, id: u32) -> Result<Option<User>, Self::Error> {
        Ok(self.users.get(&id).cloned())
    }

    fn update_user(&mut self, id: u32, request: UpdateUserRequest) -> Result<Option<User>, Self::Error> {
        let user = match self.users.get_mut(&id) {
            Some(user) => user,
            None => return Ok(None),
        };

        if let Some(username) = request.username {
            if let Some(email) = &request.email {
                Self::validate_user_data(&username, email)?;
            } else {
                Self::validate_user_data(&username, &user.email)?;
            }
            user.username = username;
        }

        if let Some(email) = request.email {
            Self::validate_user_data(&user.username, &email)?;
            user.email = email;
        }

        if let Some(is_active) = request.is_active {
            user.is_active = is_active;
        }

        Ok(Some(user.clone()))
    }

    fn delete_user(&mut self, id: u32) -> Result<bool, Self::Error> {
        Ok(self.users.remove(&id).is_some())
    }

    fn list_users(&self) -> Result<Vec<User>, Self::Error> {
        Ok(self.users.values().cloned().collect())
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_create_user() {
        let mut repo = InMemoryUserRepository::new();
        let request = CreateUserRequest {
            username: "testuser".to_string(),
            email: "test@example.com".to_string(),
        };

        let result = repo.create_user(request);
        assert!(result.is_ok());

        let user = result.unwrap();
        assert_eq!(user.username, "testuser");
        assert_eq!(user.email, "test@example.com");
        assert_eq!(user.id, 1);
        assert!(user.is_active);
    }

    #[test]
    fn test_validation_error() {
        let mut repo = InMemoryUserRepository::new();
        let request = CreateUserRequest {
            username: "x".to_string(), // Too short
            email: "invalid-email".to_string(), // Invalid format
        };

        let result = repo.create_user(request);
        assert!(result.is_err());
    }
}