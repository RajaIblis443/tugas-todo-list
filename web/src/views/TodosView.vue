<template>
  <div class="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-50">
    <!-- Header with better styling -->
    <header class="bg-white shadow-md sticky top-0 z-10">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4 flex items-center justify-between">
        <div class="flex items-center">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-blue-600 mr-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
          </svg>
          <h1 class="text-2xl font-bold text-gray-900 bg-clip-text text-transparent bg-gradient-to-r from-blue-600 to-indigo-600">
            My Tasks
          </h1>
        </div>
        <div class="flex space-x-3">
          <button 
            @click="showAddTodoModal = true"
            class="inline-flex items-center px-4 py-2 border border-transparent rounded-full shadow-sm text-sm font-medium text-white bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-700 hover:to-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transition-all duration-200 transform hover:scale-105"
          >
            <svg class="-ml-1 mr-2 h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
              <path fill-rule="evenodd" d="M10 5a1 1 0 011 1v3h3a1 1 0 110 2h-3v3a1 1 0 11-2 0v-3H6a1 1 0 110-2h3V6a1 1 0 011-1z" clip-rule="evenodd" />
            </svg>
            Add Task
          </button>
          <button @click="logout" class="text-gray-600 hover:text-red-600 transition-colors p-2 rounded-full hover:bg-red-50">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
            </svg>
          </button>
        </div>
      </div>
    </header>

    <!-- Content -->
    <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
      <!-- Loading state with animation -->
      <div v-if="loading" class="flex flex-col items-center justify-center py-16">
        <div class="w-16 h-16 border-4 border-blue-200 border-t-blue-600 rounded-full animate-spin"></div>
        <p class="mt-4 text-gray-600 font-medium">Loading your tasks...</p>
      </div>
      
      <!-- Error state with better visualization -->
      <div v-else-if="error" class="bg-red-50 border-l-4 border-red-400 p-5 rounded-md shadow-sm mb-6 animate-pulse">
        <div class="flex">
          <div class="flex-shrink-0">
            <svg class="h-5 w-5 text-red-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
              <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
            </svg>
          </div>
          <div class="ml-3">
            <h3 class="text-sm font-medium text-red-800">Something went wrong</h3>
            <p class="mt-1 text-sm text-red-700">{{ error }}</p>
            <button 
              @click="fetchTodos" 
              class="mt-2 inline-flex items-center px-3 py-1 border border-transparent text-xs font-medium rounded-md text-red-700 bg-red-100 hover:bg-red-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500"
            >
              Try again
            </button>
          </div>
        </div>
      </div>

      <div v-else>
        <!-- Search and filter with improved styling -->
        <div class="mb-8 bg-white p-4 rounded-lg shadow-sm">
          <div class="flex flex-col sm:flex-row items-center justify-between gap-4">
            <!-- Date filter -->
            <div class="flex flex-wrap items-center gap-2">
              <button 
                @click="setDateFilter('all')"
                :class="{
                  'bg-blue-600 text-white ring-2 ring-blue-600 ring-offset-2': filters.dateFilter === 'all',
                  'bg-white text-gray-700 hover:bg-gray-100 border border-gray-300': filters.dateFilter !== 'all'
                }"
                class="px-4 py-2 rounded-md text-sm font-medium transition-all duration-200"
              >
                Semua Tanggal
              </button>
              <button 
                @click="setDateFilter('today')"
                :class="{
                  'bg-blue-600 text-white ring-2 ring-blue-600 ring-offset-2': filters.dateFilter === 'today',
                  'bg-white text-gray-700 hover:bg-gray-100 border border-gray-300': filters.dateFilter !== 'today'
                }"
                class="px-4 py-2 rounded-md text-sm font-medium transition-all duration-200"
              >
                Hari Ini
              </button>
              <button 
                @click="setDateFilter('upcoming')"
                :class="{
                  'bg-blue-600 text-white ring-2 ring-blue-600 ring-offset-2': filters.dateFilter === 'upcoming',
                  'bg-white text-gray-700 hover:bg-gray-100 border border-gray-300': filters.dateFilter !== 'upcoming'
                }"
                class="px-4 py-2 rounded-md text-sm font-medium transition-all duration-200"
              >
                Mendatang
              </button>
              <button 
                @click="setDateFilter('overdue')"
                :class="{
                  'bg-red-600 text-white ring-2 ring-red-600 ring-offset-2': filters.dateFilter === 'overdue',
                  'bg-white text-gray-700 hover:bg-gray-100 border border-gray-300': filters.dateFilter !== 'overdue'
                }"
                class="px-4 py-2 rounded-md text-sm font-medium transition-all duration-200"
              >
                Terlambat
              </button>
            </div>

            <!-- Priority filter -->
            <div class="flex items-center">
              <label class="inline-flex items-center cursor-pointer">
                <input 
                  type="checkbox" 
                  v-model="filters.showPriorityOnly"
                  class="form-checkbox h-5 w-5 text-blue-600 transition duration-150 ease-in-out"
                />
                <span class="ml-2 text-sm text-gray-700">Prioritas Saja</span>
              </label>
            </div>
          </div>

          <!-- Status filter -->
          <div class="mt-4 flex flex-wrap items-center gap-2">
            <button 
              @click="setCompletionFilter('all')"
              :class="{
                'bg-blue-600 text-white ring-2 ring-blue-600 ring-offset-2': filters.completionStatus === 'all',
                'bg-white text-gray-700 hover:bg-gray-100 border border-gray-300': filters.completionStatus !== 'all'
              }"
              class="px-4 py-2 rounded-md text-sm font-medium transition-all duration-200"
            >
              Semua ({{ todos.length }})
            </button>
            <button 
              @click="setCompletionFilter('pending')"
              :class="{
                'bg-blue-600 text-white ring-2 ring-blue-600 ring-offset-2': filters.completionStatus === 'pending',
                'bg-white text-gray-700 hover:bg-gray-100 border border-gray-300': filters.completionStatus !== 'pending'
              }"
              class="px-4 py-2 rounded-md text-sm font-medium transition-all duration-200"
            >
              Aktif ({{ pendingTodos.length }})
            </button>
            <button 
              @click="setCompletionFilter('completed')"
              :class="{
                'bg-blue-600 text-white ring-2 ring-blue-600 ring-offset-2': filters.completionStatus === 'completed',
                'bg-white text-gray-700 hover:bg-gray-100 border border-gray-300': filters.completionStatus !== 'completed'
              }"
              class="px-4 py-2 rounded-md text-sm font-medium transition-all duration-200"
            >
              Selesai ({{ completedTodos.length }})
            </button>
            <button 
              @click="resetFilters"
              class="ml-auto px-4 py-2 rounded-md text-sm font-medium bg-gray-200 text-gray-700 hover:bg-gray-300 transition-all duration-200"
            >
              Reset Filter
            </button>
          </div>
        </div>

        <!-- Todo list with animation -->
        <div v-if="sortedTodos.length > 0">
          <transition-group name="list" tag="div" class="bg-white shadow rounded-lg divide-y divide-gray-200">
            <todo-item
              v-for="todo in sortedTodos"
              :key="todo.id"
              :todo="todo"
              @toggle="toggleTodo"
              @edit="editTodo"
              @delete="showDeleteConfirm"
            />
          </transition-group>
        </div>
        <div v-else class="text-center py-16 bg-white rounded-lg shadow-sm">
          <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
          </svg>
          <h3 class="mt-2 text-lg font-medium text-gray-900">No tasks found</h3>
          <p class="mt-1 text-gray-500">{{ getEmptyStateMessage() }}</p>
          <div class="mt-6">
            <button
              @click="showAddTodoModal = true" 
              class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
            >
              Add your first task
            </button>
          </div>
        </div>
      </div>
    </main>

    <!-- Add/Edit Todo Modal -->
    <todo-form-modal
      v-if="showAddTodoModal" 
      :todo="editingTodo"
      @close="closeModal"
      @save="saveTodo"
    />

    <!-- Delete Confirmation Modal -->
    <confirmation-modal
      v-if="showDeleteModal"
      title="Delete Task"
      message="Are you sure you want to delete this task? This action cannot be undone."
      @confirm="confirmDelete"
      @cancel="cancelDelete"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import useTodos from '../composable/useTodos';
import useAuth from '../composable/useAuth';
import type { List } from '../types/list.type';
import TodoItem from '../components/todo/TodoItem.vue';
import TodoFormModal from '../components/todo/TodoFormModal.vue';
import ConfirmationModal from '../components/common/ConfirmationModal.vue';

// Initialize composables
const { 
  todos, 
  sortedTodos, 
  completedTodos, 
  pendingTodos, 
  loading, 
  error, 
  filters,
  setDateFilter,
  setCompletionFilter,
  resetFilters,
  fetchTodos, 
  createTodo, 
  updateTodo, 
  toggleTodoCompletion, 
  deleteTodo 
} = useTodos();
const { logout: authLogout } = useAuth();
const router = useRouter();

// Local state
const showAddTodoModal = ref(false);
const showDeleteModal = ref(false);
const filterStatus = ref('all');
const searchQuery = ref('');
const editingTodo = ref<List | null>(null);
const todoToDelete = ref<string | number | null>(null);
const dateFilter = ref('all');

// Fetch todos on mount
onMounted(async () => {
  await fetchTodos();
});

const editTodo = (todo: List) => {
  editingTodo.value = {...todo};
  showAddTodoModal.value = true;
};

const showDeleteConfirm = (id: string | number) => {
  todoToDelete.value = id;
  showDeleteModal.value = true;
};

const confirmDelete = async () => {
  if (todoToDelete.value) {
    await deleteTodo(todoToDelete.value);
    showDeleteModal.value = false;
    todoToDelete.value = null;
  }
};

const cancelDelete = () => {
  showDeleteModal.value = false;
  todoToDelete.value = null;
};

const closeModal = () => {
  showAddTodoModal.value = false;
  editingTodo.value = null;
};

const saveTodo = async (todoData: any) => {
  if (editingTodo.value) {
    // Update existing todo
    await updateTodo(editingTodo.value.id, todoData);
  } else {
    // Create new todo
    await createTodo({
      ...todoData,
      userId: localStorage.getItem('userId') || ''
    });
  }
  closeModal();
};

const logout = () => {
  authLogout();
  router.push('/login');
};

const getEmptyStateMessage = () => {
  if (searchQuery.value) {
    return `No tasks matching "${searchQuery.value}"`;
  }
  
  switch(filterStatus.value) {
    case 'active':
      return 'You have no active tasks - everything is done!';
    case 'completed':
      return 'You have no completed tasks yet.';
    default:
      return 'Get started by adding a task.';
  }
};

const toggleTodo = async (id: string | number, isFinished: boolean) => {
  await toggleTodoCompletion(id, isFinished);
};
</script>

<style scoped>
.list-enter-active,
.list-leave-active {
  transition: all 0.3s ease;
}
.list-enter-from,
.list-leave-to {
  opacity: 0;
  transform: translateX(30px);
}
</style>