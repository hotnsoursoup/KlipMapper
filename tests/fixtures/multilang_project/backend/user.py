# <r:imports>
from dataclasses import dataclass
from typing import Optional, Dict, Any
from datetime import datetime

# <r:models>
@dataclass
class User:
    """User data model."""
    id: int
    username: str
    email: str
    created_at: datetime
    is_active: bool = True
    
    def to_dict(self) -> Dict[str, Any]:
        """Convert user to dictionary."""
        return {
            'id': self.id,
            'username': self.username,
            'email': self.email,
            'created_at': self.created_at.isoformat(),
            'is_active': self.is_active
        }
    
    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> 'User':
        """Create user from dictionary."""
        return cls(
            id=data['id'],
            username=data['username'],
            email=data['email'],
            created_at=datetime.fromisoformat(data['created_at']),
            is_active=data.get('is_active', True)
        )

# <r:repository>
class UserRepository:
    """Repository for user data operations."""
    
    def __init__(self):
        self._users: Dict[int, User] = {}
        self._next_id = 1
    
    def create_user(self, username: str, email: str) -> User:
        """Create a new user."""
        user = User(
            id=self._next_id,
            username=username,
            email=email,
            created_at=datetime.now()
        )
        self._users[user.id] = user
        self._next_id += 1
        return user
    
    def get_user(self, user_id: int) -> Optional[User]:
        """Get user by ID."""
        return self._users.get(user_id)
    
    def get_user_by_username(self, username: str) -> Optional[User]:
        """Get user by username."""
        for user in self._users.values():
            if user.username == username:
                return user
        return None
    
    def update_user(self, user_id: int, **kwargs) -> Optional[User]:
        """Update user fields."""
        user = self._users.get(user_id)
        if user:
            for key, value in kwargs.items():
                if hasattr(user, key):
                    setattr(user, key, value)
        return user
    
    def delete_user(self, user_id: int) -> bool:
        """Delete user."""
        return self._users.pop(user_id, None) is not None
    
    def list_users(self) -> list[User]:
        """List all users."""
        return list(self._users.values())