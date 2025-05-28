export interface User {
  id: string | number;
  name: string;
  email: string;
  password?: string; // Optional as it might not be returned from API
  createdAt?: Date | string;
  updatedAt?: Date | string;
}

export interface LoginRequest {
  email: string;
  password: string;
}

export interface RegisterRequest {
  name: string;
  email: string;
  password: string;
}

export interface AuthResponse {
  data: User;
  token?: string;
  messsage?: string;
  error?: string;
}