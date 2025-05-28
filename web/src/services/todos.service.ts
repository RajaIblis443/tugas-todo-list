import axios from "axios";
import type { 
  AddListRequest, 
  UpdateListRequest, 
  ListResponse, 
  SingleListResponse 
} from '../types/list.type';

const API_URL = 'http://127.0.0.1:3000/api';

class TodosService {
  constructor() {
    axios.defaults.baseURL = API_URL;
    axios.defaults.headers.common['Authorization'] = `Bearer ${localStorage.getItem('token')}`;
  }

  /**
   * Fetch all tasks
   * @returns Promise with tasks data
   */
  async getTodos(): Promise<ListResponse> {
    try {
      const response = await axios.get('/tasks');
      return response.data;
    } catch (error) {
      console.error('Error fetching tasks:', error);
      throw error;
    }
  }

  /**
   * Get a specific todo by ID
   * Catatan: Backend sepertinya tidak mendukung endpoint ini
   * @param id Todo ID
   * @returns Promise with single todo response
   */
  async getTodoById(id: string | number): Promise<SingleListResponse> {
    try {
      // Karena tidak ada endpoint detail, kita ambil semua todo lalu filter
      const allTodos = await this.getTodos();
      const todo = allTodos.data.find((item: any) => item.id == id);
      
      if (!todo) {
        throw new Error('Todo not found');
      }
      
      return {
        data: todo,
        message: 'Todo retrieved successfully'
      };
    } catch (error) {
      console.error(`Error fetching todo ${id}:`, error);
      throw error;
    }
  }

  /**
   * Create a new todo
   * @param todoData Todo data to create
   * @returns Promise with created todo response
   */
  async createTodo(todoData: AddListRequest): Promise<SingleListResponse> {
    try {
      const response = await axios.post('/tasks', todoData);
      return response.data;
    } catch (error) {
      console.error('Error creating todo:', error);
      throw error;
    }
  }

  /**
   * Update an existing todo
   * @param id Todo ID to update
   * @param todoData Updated todo data
   * @returns Promise with updated todo response
   */
  async updateTodo(id: string | number, todoData: UpdateListRequest): Promise<SingleListResponse> {
    try {
      // Perbaikan URL dan format request
      const response = await axios.put('/tasks', {
        ...todoData,
        id: id
      });
      return response.data;
    } catch (error) {
      console.error(`Error updating todo ${id}:`, error);
      throw error;
    }
  }

  /**
   * Toggle completion status of a todo
   * @param id Todo ID
   * @param isFinished New completion status
   * @returns Promise with updated todo response
   */
  async toggleCompletion(id: string | number, isFinished: boolean): Promise<SingleListResponse> {
    try {
      // Langsung kirim update status tanpa fetch dulu
      const response = await axios.put('/tasks', {
        id: id,
        isFinished: isFinished
      });
      return response.data;
    } catch (error) {
      console.error(`Error toggling completion for todo ${id}:`, error);
      throw error;
    }
  }

  /**
   * Delete a todo
   * @param id Todo ID to delete
   * @returns Promise with delete operation response
   */
  async deleteTodo(id: string | number): Promise<{ message: string }> {
    try {
      const response = await axios.delete(`/tasks/${id}`);
      return response.data;
    } catch (error) {
      console.error(`Error deleting todo ${id}:`, error);
      throw error;
    }
  }
}

export default new TodosService();