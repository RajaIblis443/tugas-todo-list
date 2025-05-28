<template>
  <div class="px-4 py-4 sm:px-6 hover:bg-blue-50 transition-colors duration-200 group">
    <div class="flex items-start">
      <!-- Checkbox with improved animation -->
      <div class="mr-4 mt-1">
        <label class="inline-flex items-center cursor-pointer">
          <input 
            type="checkbox" 
            :checked="todo.isFinished" 
            @change="$emit('toggle', todo.id, !todo.isFinished)"
            class="sr-only"
          />
          <span 
            class="flex items-center justify-center w-6 h-6 border-2 rounded-full transition-colors duration-200" 
            :class="{
              'bg-green-500 border-green-500': todo.isFinished, 
              'border-gray-300': !todo.isFinished,
              'group-hover:border-blue-400': !todo.isFinished
            }"
          >
            <svg v-if="todo.isFinished" class="h-3 w-3 text-white" viewBox="0 0 20 20" fill="currentColor">
              <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd" />
            </svg>
          </span>
        </label>
      </div>
      
      <!-- Content with better organization -->
      <div class="flex-1 min-w-0">
        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between">
          <div class="mb-2 sm:mb-0">
            <h3 
              :class="{
                'line-through text-gray-500': todo.isFinished, 
                'text-gray-900 font-medium': !todo.isFinished
              }"
              class="text-base transition-all duration-200"
            >
              {{ todo.title }}
              <span v-if="todo.priority" class="ml-2 inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">
                <svg class="mr-1 h-3 w-3 text-red-500" fill="currentColor" viewBox="0 0 20 20">
                  <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                </svg>
                Priority
              </span>
            </h3>
            
            <!-- Due date with better visualization -->
            <div class="mt-1 flex items-center">
              <svg class="flex-shrink-0 mr-1.5 h-4 w-4 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M6 2a1 1 0 00-1 1v1H4a2 2 0 00-2 2v10a2 2 0 002 2h12a2 2 0 002-2V6a2 2 0 00-2-2h-1V3a1 1 0 10-2 0v1H7V3a1 1 0 00-1-1zm0 5a1 1 0 000 2h8a1 1 0 100-2H6z" clip-rule="evenodd" />
              </svg>
              <span 
                class="text-sm"
                :class="{
                  'text-red-600 font-medium': isOverdue(todo.due_date) && !todo.isFinished,
                  'text-gray-500': !isOverdue(todo.due_date) || todo.isFinished
                }"
              >
                {{ formatDueDate(todo.due_date) }}
              </span>
            </div>
          </div>
          
          <!-- Actions with hover effects -->
           <div>
            <div class="m-2" >
               <div class="flex flex-shrink-0">
               <button 
              @click="$emit('edit', todo)"
              class="inline-flex items-center px-3 py-1.5 border border-transparent text-xs font-medium rounded-md text-blue-700 bg-blue-100 hover:bg-blue-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transition-colors duration-200"
            >
            <svg class="-ml-0.5 mr-1.5 h-4 w-4" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                <path d="M13.586 3.586a2 2 0 112.828 2.828l-.793.793-2.828-2.828.793-.793zM11.379 5.793L3 14.172V17h2.828l8.38-8.379-2.83-2.828z" />
              </svg>
              Edit
            </button>
            <button 
              @click="$emit('delete', todo.id)"
              class="ml-2 inline-flex items-center px-3 py-1.5 border border-transparent text-xs font-medium rounded-md text-red-700 bg-red-100 hover:bg-red-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 transition-colors duration-200"
            >
            <svg class="-ml-0.5 mr-1.5 h-4 w-4" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
              <path fill-rule="evenodd" d="M9 2a1 1 0 00-.894.553L7.382 4H4a1 1 0 000 2v10a2 2 0 002 2h8a2 2 0 002-2V6a1 1 0 100-2h-3.382l-.724-1.447A1 1 0 0011 2H9zM7 8a1 1 0 012 0v6a1 1 0 11-2 0V8zm5-1a1 1 0 00-1 1v6a1 1 0 102 0V8a1 1 0 00-1-1z" clip-rule="evenodd" />
            </svg>
            Delete
          </button>
        </div>
        <p v-if="todo.isFinished == true"  class="text-xs text-gray-500 mt-1">
          Finished on {{ formatDate(todo.updateAt!) }}
        </p>
      </div>
      </div>
    </div>
    
        <p v-if="todo.description" class="mt-2 text-sm text-gray-600 leading-relaxed">
          {{ todo.description }}
        </p>
        
        <!-- Category with improved styling -->
        <div class="mt-2 flex items-center text-xs">
          <span v-if="todo.category" class="inline-flex items-center px-2.5 py-1 rounded-full bg-blue-100 text-blue-800">
            <svg class="-ml-0.5 mr-1.5 h-3 w-3 text-blue-500" fill="currentColor" viewBox="0 0 20 20">
              <path fill-rule="evenodd" d="M17.707 9.293a1 1 0 010 1.414l-7 7a1 1 0 01-1.414 0l-7-7A.997.997 0 012 10V5a3 3 0 013-3h5c.256 0 .512.098.707.293l7 7zM5 6a1 1 0 100-2 1 1 0 000 2z" clip-rule="evenodd" />
            </svg>
            {{ todo.category }}
          </span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { defineProps, defineEmits } from 'vue';
import type { List } from '../../types/list.type';

const props = defineProps<{
  todo: List
}>();

defineEmits(['toggle', 'edit', 'delete']);

// Format date to local string with better formatting
const formatDate = (date: string | Date): string => {
  return new Date(date).toLocaleDateString('en-US', { 
    year: 'numeric',
    month: 'short',
    day: 'numeric'
  });
};

// Format due date with relative time
const formatDueDate = (date: string | Date): string => {
  const dueDate = new Date(date);
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  
  const tomorrow = new Date(today);
  tomorrow.setDate(tomorrow.getDate() + 1);
  
  const yesterday = new Date(today);
  yesterday.setDate(yesterday.getDate() - 1);
  
  if (dueDate.getTime() === today.getTime()) {
    return 'Due: Today';
  } else if (dueDate.getTime() === tomorrow.getTime()) {
    return 'Due: Tomorrow';
  } else if (dueDate.getTime() === yesterday.getTime()) {
    return 'Due: Yesterday';
  } else if (dueDate < today) {
    const days = Math.floor((today.getTime() - dueDate.getTime()) / (1000 * 60 * 60 * 24));
    return `Overdue: ${days} ${days === 1 ? 'day' : 'days'} ago`;
  } else {
    return `Due: ${formatDate(date)}`;
  }
};

// Check if a due date is in the past
const isOverdue = (date: string | Date): boolean => {
  const dueDate = new Date(date);
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  return dueDate < today;
};
</script>