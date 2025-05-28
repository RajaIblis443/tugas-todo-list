import { ref, computed } from "vue";
import { useRouter } from "vue-router";
import authService from "../services/auth.service";
import type { LoginRequest, RegisterRequest, User } from "../types/user.type";

/**
 * Authentication composable for Vue components
 */
export default function useAuth() {
  const router = useRouter();
  const user = ref<User | null>(authService.getCurrentUser());
  const isAuthenticated = computed(() => !!user.value);
  const loading = ref(false);
  const error = ref<string | null>(null);

  /**
   * Login user
   * @param credentials User login credentials
   */
  const login = async (credentials: LoginRequest): Promise<void> => {
    loading.value = true;
    error.value = null;

    try {
      const response = await authService.login(credentials);
      user.value = response.data;
      router.push("/todos"); // Redirect to todos page after login
    } catch (err: any) {
      error.value = err.response?.data?.message || "Login failed";
      console.error("Login error:", err);
    } finally {
      loading.value = false;
    }
  };

  /**
   * Register new user
   * @param userData User registration data
   */
  const register = async (userData: RegisterRequest): Promise<boolean> => {
    loading.value = true;
    error.value = null;

    try {
      const response = await authService.register(userData);
      user.value = response.data;
      router.replace("/"); 
      return true; // Registration successful
    } catch (err: any) {
      alert("Registration failed. Please try again. error : " + err);
      error.value = err.response?.data?.message || "Registration failed"; 
      return false;
    } finally {
      loading.value = false;
    }
  };

  /**
   * Logout user
   */
  const logout = (): void => {
    authService.logout();
    user.value = null;
    router.push("/login");
  };

  /**
   * Check authentication on app initialization
   */
  const checkAuth = (): void => {
    const currentUser = authService.getCurrentUser();
    user.value = currentUser;
  };

  return {
    user,
    isAuthenticated,
    loading,
    error,
    login,
    register,
    logout,
    checkAuth,
  };
}