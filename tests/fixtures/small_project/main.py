# <r:imports>
import os
import sys
from typing import Optional, List

# <r:models>
class User:
    """A simple user model."""
    
    def __init__(self, name: str, email: str):
        self.name = name
        self.email = email
    
    def __str__(self) -> str:
        return f"User({self.name}, {self.email})"

class UserService:
    """Service for managing users."""
    
    def __init__(self):
        self.users: List[User] = []
    
    def add_user(self, user: User) -> None:
        """Add a user to the service."""
        self.users.append(user)
    
    def find_user(self, name: str) -> Optional[User]:
        """Find a user by name."""
        for user in self.users:
            if user.name == name:
                return user
        return None
    
    def list_users(self) -> List[User]:
        """List all users."""
        return self.users.copy()

# <r:utilities>
def validate_email(email: str) -> bool:
    """Simple email validation."""
    return "@" in email and "." in email

def create_sample_users() -> List[User]:
    """Create sample users for testing."""
    return [
        User("Alice", "alice@example.com"),
        User("Bob", "bob@example.com"),
        User("Charlie", "charlie@test.org"),
    ]

# <r:main>
def main():
    """Main function demonstrating the user service."""
    service = UserService()
    
    # Add sample users
    for user in create_sample_users():
        if validate_email(user.email):
            service.add_user(user)
    
    # List all users
    print("All users:")
    for user in service.list_users():
        print(f"  {user}")
    
    # Find specific user
    alice = service.find_user("Alice")
    if alice:
        print(f"\nFound user: {alice}")

if __name__ == "__main__":
    main()