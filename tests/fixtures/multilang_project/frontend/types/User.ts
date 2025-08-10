export interface User {
  id: number;
  username: string;
  email: string;
  created_at: string;
  is_active: boolean;
}

export interface CreateUserRequest {
  username: string;
  email: string;
}

export interface UpdateUserRequest {
  username?: string;
  email?: string;
  is_active?: boolean;
}

export interface UserListResponse {
  users: User[];
  total: number;
  page: number;
  page_size: number;
}

export type UserStatus = 'active' | 'inactive';

export interface UserFilter {
  status?: UserStatus;
  search?: string;
  created_after?: string;
  created_before?: string;
}

export class UserValidator {
  static validateEmail(email: string): boolean {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  }

  static validateUsername(username: string): boolean {
    return username.length >= 3 && username.length <= 50;
  }

  static validateUser(user: CreateUserRequest): string[] {
    const errors: string[] = [];

    if (!this.validateUsername(user.username)) {
      errors.push('Username must be between 3 and 50 characters');
    }

    if (!this.validateEmail(user.email)) {
      errors.push('Invalid email format');
    }

    return errors;
  }
}