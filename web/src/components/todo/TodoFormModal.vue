<template>
  <div class="fixed inset-0 z-20 overflow-y-auto" aria-labelledby="modal-title" role="dialog" aria-modal="true">
    <div class="flex items-center justify-center min-h-screen px-4 py-6 sm:p-0">
      <!-- Background overlay with proper opacity -->
      <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" aria-hidden="true"></div>
      
      <!-- Modal panel with better sizing -->
      <div class="relative bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:max-w-lg sm:w-full mx-auto">
        <form @submit.prevent="handleSubmit" class="border-t-4 border-blue-600">
          <div class="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
            <div class="mb-4 flex items-center justify-between">
              <h3 class="text-lg leading-6 font-medium text-gray-900">
                {{ todo ? 'Edit Task' : 'Add New Task' }}
              </h3>
              <!-- Close button in top-right corner -->
              <button 
                type="button" 
                @click="$emit('close')"
                class="rounded-full p-1 hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500"
              >
                <svg class="h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                  <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" />
                </svg>
              </button>
            </div>

            <!-- Title -->
            <div class="mb-4">
              <label for="title" class="block text-sm font-medium text-gray-700">Title</label>
              <input
                type="text"
                id="title"
                v-model="form.title"
                required
                class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm"
                placeholder="Task title"
              />
            </div>

            <!-- Description -->
            <div class="mb-4">
              <label for="description" class="block text-sm font-medium text-gray-700">Description</label>
              <textarea
                id="description"
                v-model="form.description"
                rows="3"
                class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm"
                placeholder="Task description"
              ></textarea>
            </div>

            <!-- Due Date -->
            <div class="mb-4">
              <label for="dueDate" class="block text-sm font-medium text-gray-700">Due Date</label>
              <input
                type="date"
                id="dueDate"
                v-model="form.due_date"
                required
                class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm"
              />
            </div>

            <!-- Category -->
            <div class="mb-4">
              <label for="category" class="block text-sm font-medium text-gray-700">Category</label>
              <input
                type="text"
                id="category"
                v-model="form.category"
                class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm"
                placeholder="Category (optional)"
              />
            </div>

            <!-- Priority -->
            <div class="mb-4">
              <div class="flex items-center">
                <input
                  id="priority"
                  type="checkbox"
                  v-model="form.priority"
                  class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                />
                <label for="priority" class="ml-2 block text-sm text-gray-900">
                  Mark as priority
                </label>
              </div>
            </div>

            <!-- Completed status (only for editing) -->
            <div v-if="todo" class="mb-4">
              <div class="flex items-center">
                <input
                  id="completed"
                  type="checkbox"
                  v-model="form.isFinished"
                  class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                />
                <label for="completed" class="ml-2 block text-sm text-gray-900">
                  Mark as completed
                </label>
              </div>
            </div>
          </div>

          <!-- Modal actions -->
          <div class="bg-gray-50 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse border-t border-gray-100">
            <button
              type="submit"
              class="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-blue-600 text-base font-medium text-white hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 sm:ml-3 sm:w-auto sm:text-sm"
            >
              {{ todo ? 'Update Task' : 'Add Task' }}
            </button>
            <button
              type="button"
              @click="$emit('close')"
              class="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:mt-0 sm:w-auto sm:text-sm"
            >
              Cancel
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import type { List } from '../../types/list.type';

const props = defineProps<{
  todo: List | null
}>();

const emit = defineEmits(['save', 'close']);

// Form state
const form = ref({
  title: '',
  description: '',
  due_date: new Date().toISOString().split('T')[0], // Today's date in YYYY-MM-DD format
  category: '',
  priority: false,
  isFinished: false
});

// Initialize form with todo data if editing
onMounted(() => {
  if (props.todo) {
    form.value = {
      title: props.todo.title,
      description: props.todo.description || '',
      due_date: new Date(props.todo.due_date).toISOString().split('T')[0],
      category: props.todo.category || '',
      priority: props.todo.priority,
      isFinished: props.todo.isFinished
    };
  }
});

// Handle form submission
const handleSubmit = () => {
  emit('save', {
    title: form.value.title,
    description: form.value.description || undefined,
    due_date: form.value.due_date,
    category: form.value.category || undefined,
    priority: form.value.priority,
    isFinished: form.value.isFinished
  });
};
</script>

<style scoped>
/* Add some mobile optimization */
@media (max-width: 640px) {
  .fixed.inset-0.bg-gray-500 {
    background-color: rgba(107, 114, 128, 0.85);
  }
}
</style>