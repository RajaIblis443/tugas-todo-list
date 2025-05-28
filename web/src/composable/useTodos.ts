import { ref, computed } from 'vue';
import { useRouter } from 'vue-router';
import todosService from '../services/todos.service';
import type { List, AddListRequest, UpdateListRequest } from '../types/list.type';

/**
 * Todo management composable for Vue components
 */
export default function useTodos() {
  const router = useRouter();
  const todos = ref<List[]>([]);
  const currentTodo = ref<List | null>(null);
  const loading = ref(false);
  const error = ref<string | null>(null);
  
  // Filter states
  const filters = ref({
    dateFilter: 'all', 
    showPriorityOnly: false,
    completionStatus: 'all' 
  });
  
  // Get current user ID from localStorage
  const getCurrentUserId = (): string | null => {
    return localStorage.getItem('userId');
  };
  
  const userTodos = computed(() => {
    const currentUserId = getCurrentUserId();
    if (!currentUserId) {
      return [];
    }
    return todos.value.filter(todo => {
      return String(todo.userId) === String(currentUserId);
    });
  });
  
  // Get today's date with time set to start of day
  const today = computed(() => {
    const date = new Date();
    date.setHours(0, 0, 0, 0);
    return date;
  });

  // Filter todos by date (based on user's todos)
  const todosByDate = computed(() => {
    if (filters.value.dateFilter === 'all') {
      return userTodos.value;
    }
    
    return userTodos.value.filter(todo => {
      const dueDate = new Date(todo.due_date);
      dueDate.setHours(0, 0, 0, 0);
      
      switch (filters.value.dateFilter) {
        case 'today':
          return dueDate.getTime() === today.value.getTime();
        case 'upcoming':
          return dueDate > today.value;
        case 'overdue':
          return dueDate < today.value && !todo.isFinished;
        default:
          return true;
      }
    });
  });

  // Filter todos by priority
  const todosByPriority = computed(() => {
    if (!filters.value.showPriorityOnly) {
      return todosByDate.value;
    }
    return todosByDate.value.filter(todo => todo.priority);
  });

  // Filter todos by completion status
  const filteredTodos = computed(() => {
    if (filters.value.completionStatus === 'all') {
      return todosByPriority.value;
    } 
    else if (filters.value.completionStatus === 'completed') {
      return todosByPriority.value.filter(todo => todo.isFinished);
    }
    else { // pending
      return todosByPriority.value.filter(todo => !todo.isFinished);
    }
  });
  
  // Sort filtered todos
  const sortedTodos = computed(() => {
    return [...filteredTodos.value].sort((a, b) => {
      // First by completion status
      if (a.isFinished !== b.isFinished) {
        return a.isFinished ? 1 : -1;
      }
      // Then by priority
      if (a.priority !== b.priority) {
        return a.priority ? -1 : 1;
      }
      // Finally by due date
      return new Date(a.due_date).getTime() - new Date(b.due_date).getTime();
    });
  });
  
  // Define completedTodos and pendingTodos as computed properties (based on user's todos)
  const completedTodos = computed(() => 
    userTodos.value.filter(todo => todo.isFinished)
  );
  
  const pendingTodos = computed(() => 
    userTodos.value.filter(todo => !todo.isFinished)
  );

  // Filter setters
  const setDateFilter = (filter: 'all' | 'today' | 'upcoming' | 'overdue') => {
    filters.value.dateFilter = filter;
  };
  
  const setPriorityFilter = (priorityOnly: boolean) => {
    filters.value.showPriorityOnly = priorityOnly;
  };
  
  const setCompletionFilter = (status: 'all' | 'completed' | 'pending') => {
    filters.value.completionStatus = status;
  };
  
  const resetFilters = () => {
    filters.value = {
      dateFilter: 'all',
      showPriorityOnly: false,
      completionStatus: 'all'
    };
  };
  
  /**
   * Fetch all todos (backend returns all, we filter by userId in frontend)
   */
  const fetchTodos = async (): Promise<void> => {
    loading.value = true;
    error.value = null;
    
    try {
      // Check if user is authenticated
      const token = localStorage.getItem('token');
      const userId = localStorage.getItem('userId');
      
      if (!token || !userId) {
        router.push('/login');
        return;
      }

      const response = await todosService.getTodos();
      // Store all todos, filtering will be done by computed properties
      todos.value = response.data;
    } catch (err: any) {
      if (err.response?.status === 401) {
        // Token invalid atau expired
        localStorage.removeItem('token');
        localStorage.removeItem('userId');
        router.push('/login');
      } else {
        error.value = err.response?.data?.message || 'Failed to fetch todos';
        console.error('Error fetching todos:', err);
      }
    } finally {
      loading.value = false;
    }
  };

  /**
   * Create a new todo for authenticated user
   */
  const createTodo = async (todoData: AddListRequest): Promise<void> => {
    loading.value = true;
    error.value = null;
    
    try {
      const userId = getCurrentUserId();
      if (!userId) {
        router.push('/login');
        return;
      }

      const response = await todosService.createTodo(todoData);
      
      // Ensure the new todo has the correct userId
      const newTodo = {
        ...response.data,
        userId: userId
      };
      
      todos.value = [...todos.value, newTodo];
    } catch (err: any) {
      if (err.response?.status === 401) {
        router.push('/login');
      } else {
        error.value = err.response?.data?.message || 'Failed to create todo';
        console.error('Error creating todo:', err);
      }
    } finally {
      loading.value = false;
    }
  };

  /**
   * Update todo (only user's own todos)
   */
  const updateTodo = async (id: string | number, todoData: UpdateListRequest): Promise<void> => {
    loading.value = true;
    error.value = null;
    
    try {
      const userId = getCurrentUserId();
      if (!userId) {
        router.push('/login');
        return;
      }

      // Check if todo belongs to current user
      const todoToUpdate = todos.value.find(todo => 
        todo.id === id && String(todo.userId) === String(userId)
      );
      
      if (!todoToUpdate) {
        throw new Error('Todo not found or access denied');
      }

      const response = await todosService.updateTodo(id, todoData);
      
      // Update the todos array with the updated todo
      todos.value = todos.value.map(todo =>
        todo.id === id ? { ...response.data, userId: userId } : todo
      );
      
      // Update currentTodo if it's the same as the updated one
      if (currentTodo.value && currentTodo.value.id === id) {
        currentTodo.value = { ...response.data, userId: userId };
      }
    } catch (err: any) {
      if (err.response?.status === 401) {
        router.push('/login');
      } else {
        error.value = err.response?.data?.message || 'Failed to update todo';
        console.error('Error updating todo:', err);
      }
    } finally {
      loading.value = false;
    }
  };

  /**
   * Toggle todo completion status (only user's own todos)
   */
  const toggleTodoCompletion = async (id: string | number, isFinished: boolean): Promise<void> => {
    loading.value = true;
    error.value = null;
    
    try {
      const userId = getCurrentUserId();
      if (!userId) {
        router.push('/login');
        return;
      }

      // Cari todo dari state yang sudah ada dan pastikan milik user yang sedang login
      const todoToUpdate = todos.value.find(todo => 
        todo.id === id && String(todo.userId) === String(userId)
      );
      
      if (!todoToUpdate) {
        throw new Error('Todo not found or access denied');
      }
      
      // Kirim seluruh data todo dengan isFinished yang diperbarui
      const updatedData = {
        ...todoToUpdate,
        isFinished: isFinished
      };
      
      // Gunakan updateTodo regular
      const response = await todosService.updateTodo(id, updatedData);
      
      // Update state lokal
      todos.value = todos.value.map(todo => 
        todo.id === id ? { ...response.data, userId: userId } : todo
      );
    } catch (err: any) {
      if (err.response?.status === 401) {
        router.push('/login');
      } else {
        error.value = err.response?.data?.message || 'Failed to update todo status';
        console.error('Error updating todo status:', err);
      }
    } finally {
      loading.value = false;
    }
  };

  /**
   * Delete todo (only user's own todos)
   */
  const deleteTodo = async (id: string | number): Promise<void> => {
    loading.value = true;
    error.value = null;
    
    try {
      const userId = getCurrentUserId();
      if (!userId) {
        router.push('/login');
        return;
      }

      // Check if todo belongs to current user
      const todoToDelete = todos.value.find(todo => 
        todo.id === id && String(todo.userId) === String(userId)
      );
      
      if (!todoToDelete) {
        throw new Error('Todo not found or access denied');
      }

      await todosService.deleteTodo(id);
      
      // Remove the deleted todo from the todos array
      todos.value = todos.value.filter(todo => todo.id !== id);
      
      // Clear currentTodo if it was the deleted one
      if (currentTodo.value && currentTodo.value.id === id) {
        currentTodo.value = null;
      }
    } catch (err: any) {
      if (err.response?.status === 401) {
        router.push('/login');
      } else {
        error.value = err.response?.data?.message || 'Failed to delete todo';
        console.error('Error deleting todo:', err);
      }
    } finally {
      loading.value = false;
    }
  };

  return {
    todos: userTodos, // Return filtered todos instead of all todos
    sortedTodos,
    filteredTodos,
    completedTodos,
    pendingTodos,
    currentTodo,
    loading,
    error,
    // Filter states and setters
    filters,
    setDateFilter,
    setPriorityFilter,
    setCompletionFilter,
    resetFilters,
    // Functions
    fetchTodos,
    fetchTodo: async () => {}, // placeholder
    createTodo,
    updateTodo,
    toggleTodoCompletion,
    deleteTodo
  };
}