import axios from 'axios';
import type { LoginRequest, RegisterRequest, AuthResponse, User } from '../types/user.type';

// API base URL - you may want to load this from environment variables
const API_URL = 'http://localhost:3000/api';

/**
 * Service for authentication-related API calls
 */
class AuthService {
  /**
   * Login user
   * @param credentials User login credentials
   * @returns Promise with auth response data
   */
  async login(credentials: LoginRequest): Promise<AuthResponse> {
    try {
      const response = await axios.post(`${API_URL}/auth/login`, credentials);
      
      if (response.data.token) {
        localStorage.setItem('token', response.data.token);
        localStorage.setItem('userId', response.data.data.id);
      }
      
      return response.data;
    } catch (error) {
      console.error('Login error:', error);
      throw error;
    }
  }

  /**
   * Register new user
   * @param userData User registration data
   * @returns Promise with auth response data
   */
  async register(userData: RegisterRequest): Promise<AuthResponse> {
    try {
      const response = await axios.post(`${API_URL}/auth/register`, userData);
      
      if (response.data.token) {
        localStorage.setItem('token', response.data.token);
        localStorage.setItem('userId', response.data.data.id);
      }
      
      return response.data;
    } catch (error) {
      console.error('Registration error:', error);
      throw error;
    }
  }

  /**
   * Logout user
   */
  logout(): void {
    localStorage.removeItem('token');
    localStorage.removeItem('user');
  }

  /**
   * Get current token
   * @returns Current authentication token or null
   */
  getToken(): string | null {
    return localStorage.getItem('token');
  }

  /**
   * Get current user
   * @returns Current user object or null
   */
  getCurrentUser(): User | null {
    const userString = localStorage.getItem('user');
    if (userString) {
      return JSON.parse(userString);
    }
    return null;
  }

  /**
   * Check if user is authenticated
   * @returns Boolean indicating if user is authenticated
   */
  isAuthenticated(): boolean {
    return !!this.getToken();
  }
}

export default new AuthService();