<template>
  <div class="min-h-screen flex items-center justify-center bg-gradient-to-r from-blue-500 to-purple-600 p-4">
    <div 
      class="bg-white rounded-xl shadow-2xl overflow-hidden w-full max-w-md transition-all duration-500"
      :class="{ 'transform scale-105': isAnimating }"
    >
      <div class="h-2 bg-gradient-to-r from-green-400 to-blue-500"></div>
      
      <div class="relative p-8">
        <!-- Login Form -->
        <div 
          class="transition-all duration-500 transform"
          :class="{ 'translate-x-0 opacity-100': showLogin, 'translate-x-full opacity-0 absolute inset-0': !showLogin }"
        >
          <h2 class="text-3xl font-bold text-gray-800 mb-8 text-center">Welcome Back</h2>
          <form @submit.prevent="handleLogin">
            <!-- Email field -->
            <div class="mb-6">
              <label class="block text-gray-700 text-sm font-semibold mb-2" for="email">
                Email
              </label>
              <div class="relative">
                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                  <svg class="h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                    <path d="M2.003 5.884L10 9.882l7.997-3.998A2 2 0 0016 4H4a2 2 0 00-1.997 1.884z" />
                    <path d="M18 8.118l-8 4-8-4V14a2 2 0 002 2h12a2 2 0 002-2V8.118z" />
                  </svg>
                </div>
                <input
                  id="email"
                  v-model="loginForm.email"
                  type="email"
                  required
                  class="appearance-none block w-full pl-10 pr-3 py-2 border border-gray-300 rounded-lg shadow-sm placeholder-gray-400 focus:outline-none focus:ring-blue-500 focus:border-blue-500"
                  placeholder="your@email.com"
                />
              </div>
            </div>
            
            <!-- Password field -->
            <div class="mb-6">
              <div class="flex items-center justify-between mb-2">
                <label class="block text-gray-700 text-sm font-semibold" for="password">
                  Password
                </label>
                <a href="#" class="text-xs text-blue-600 hover:text-blue-800">Forgot Password?</a>
              </div>
              <div class="relative">
                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                  <svg class="h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                    <path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" clip-rule="evenodd" />
                  </svg>
                </div>
                <input
                  id="password"
                  v-model="loginForm.password"
                  type="password"
                  required
                  class="appearance-none block w-full pl-10 pr-3 py-2 border border-gray-300 rounded-lg shadow-sm placeholder-gray-400 focus:outline-none focus:ring-blue-500 focus:border-blue-500"
                  placeholder="••••••••"
                />
              </div>
            </div>

            <button
              type="submit"
              class="w-full flex justify-center py-2.5 px-4 border border-transparent rounded-lg shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transition-colors"
            >
              Sign in
            </button>
          </form>
          
          <div class="mt-8 text-center">
            <p class="text-sm text-gray-600">
              Don't have an account?
              <a @click.prevent="toggleForm" class="font-medium text-blue-600 hover:text-blue-500 cursor-pointer">
                Create an account
              </a>
            </p>
          </div>
        </div>
        
        <!-- Register Form -->
        <div 
          class="transition-all duration-500 transform"
          :class="{ 'translate-x-0 opacity-100': !showLogin, 'translate-x-full opacity-0 absolute inset-0': showLogin }"
        >
          <h2 class="text-3xl font-bold text-gray-800 mb-6 text-center">Create Account</h2>
          <form @submit.prevent="handleRegister">
            <div class="mb-4">
              <label class="block text-gray-700 text-sm font-semibold mb-2" for="name">
                Full Name
              </label>
              <div class="relative">
                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                  <svg class="h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                    <path fill-rule="evenodd" d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z" clip-rule="evenodd" />
                  </svg>
                </div>
                <input
                  id="name"
                  v-model="registerForm.name"
                  type="text"
                  required
                  class="appearance-none block w-full pl-10 pr-3 py-2 border border-gray-300 rounded-lg shadow-sm placeholder-gray-400 focus:outline-none focus:ring-blue-500 focus:border-blue-500"
                  placeholder="John Doe"
                />
              </div>
            </div>
            
            <!-- Email field -->
            <div class="mb-4">
              <label class="block text-gray-700 text-sm font-semibold mb-2" for="register-email">
                Email
              </label>
              <div class="relative">
                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                  <svg class="h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                    <path d="M2.003 5.884L10 9.882l7.997-3.998A2 2 0 0016 4H4a2 2 0 00-1.997 1.884z" />
                    <path d="M18 8.118l-8 4-8-4V14a2 2 0 002 2h12a2 2 0 002-2V8.118z" />
                  </svg>
                </div>
                <input
                  id="register-email"
                  v-model="registerForm.email"
                  type="email"
                  required
                  class="appearance-none block w-full pl-10 pr-3 py-2 border border-gray-300 rounded-lg shadow-sm placeholder-gray-400 focus:outline-none focus:ring-blue-500 focus:border-blue-500"
                  placeholder="your@email.com"
                />
              </div>
            </div>
            
            <!-- Password field -->
            <div class="mb-4">
              <label class="block text-gray-700 text-sm font-semibold mb-2" for="register-password">
                Password
              </label>
              <div class="relative">
                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                  <svg class="h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                    <path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" clip-rule="evenodd" />
                  </svg>
                </div>
                <input
                  id="register-password"
                  v-model="registerForm.password"
                  type="password"
                  required
                  class="appearance-none block w-full pl-10 pr-3 py-2 border border-gray-300 rounded-lg shadow-sm placeholder-gray-400 focus:outline-none focus:ring-blue-500 focus:border-blue-500"
                  placeholder="••••••••"
                />
              </div>
            </div>
            
            <!-- Confirm Password field -->
            <div class="mb-6">
              <label class="block text-gray-700 text-sm font-semibold mb-2" for="confirm-password">
                Confirm Password
              </label>
              <div class="relative">
                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                  <svg class="h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                    <path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" clip-rule="evenodd" />
                  </svg>
                </div>
                <input
                  id="confirm-password"
                  v-model="registerForm.confirmPassword"
                  type="password"
                  required
                  class="appearance-none block w-full pl-10 pr-3 py-2 border border-gray-300 rounded-lg shadow-sm placeholder-gray-400 focus:outline-none focus:ring-blue-500 focus:border-blue-500"
                  placeholder="••••••••"
                />
              </div>
            </div>
            <button
              type="submit"
              class="w-full flex justify-center py-2.5 px-4 border border-transparent rounded-lg shadow-sm text-sm font-medium text-white bg-green-600 hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500 transition-colors"
            >
              Create account
            </button>
          </form>
          
          <div class="mt-6 text-center">
            <p class="text-sm text-gray-600">
              Already have an account?
              <a @click.prevent="toggleForm" class="font-medium text-blue-600 hover:text-blue-500 cursor-pointer">
                Sign in
              </a>
            </p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import type { LoginRequest } from '../types/user.type';
import useAuth from '../composable/useAuth';

// State for form visibility
const showLogin = ref(true);
const isAnimating = ref(false);


const loginForm = ref<LoginRequest>({
  email: '',
  password: ''
});

const registerForm = ref({
  name: '',
  email: '',
  password: '',
  confirmPassword: ''
});

const { login, register } = useAuth();

const toggleForm = () => {
  isAnimating.value = true;
  setTimeout(() => {
    showLogin.value = !showLogin.value;
    setTimeout(() => {
      isAnimating.value = false;
    }, 300);
  }, 200);
};

const handleLogin = async () => {
  await login(loginForm.value);
};

const handleRegister = async () => {
  if (registerForm.value.password !== registerForm.value.confirmPassword) {
    alert('Passwords do not match');
    return;
  }
  
  const registerData = {
    name: registerForm.value.name,
    email: registerForm.value.email,
    password: registerForm.value.password
  };
  
  const isRegister = await register(registerData);
  if (isRegister) {
    toggleForm();
  } else {
    alert('Registration failed. Please try again.');
  }
};
</script>

<style scoped>
/* Any additional custom styles */
</style>