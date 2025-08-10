import React from 'react';
import { User } from '../types/User';
import { formatDate } from '../utils/dateUtils';

interface UserCardProps {
  user: User;
  onEdit?: (user: User) => void;
  onDelete?: (userId: number) => void;
  showActions?: boolean;
}

export const UserCard: React.FC<UserCardProps> = ({
  user,
  onEdit,
  onDelete,
  showActions = true
}) => {
  const handleEdit = () => {
    if (onEdit) {
      onEdit(user);
    }
  };

  const handleDelete = () => {
    if (onDelete) {
      onDelete(user.id);
    }
  };

  return (
    <div className="user-card">
      <div className="user-header">
        <h3 className="user-name">{user.username}</h3>
        <span className={`status ${user.is_active ? 'active' : 'inactive'}`}>
          {user.is_active ? 'Active' : 'Inactive'}
        </span>
      </div>
      
      <div className="user-details">
        <p className="user-email">{user.email}</p>
        <p className="user-created">
          Joined: {formatDate(user.created_at)}
        </p>
      </div>

      {showActions && (
        <div className="user-actions">
          <button 
            className="btn-edit" 
            onClick={handleEdit}
            aria-label={`Edit ${user.username}`}
          >
            Edit
          </button>
          <button 
            className="btn-delete" 
            onClick={handleDelete}
            aria-label={`Delete ${user.username}`}
          >
            Delete
          </button>
        </div>
      )}
    </div>
  );
};

export default UserCard;