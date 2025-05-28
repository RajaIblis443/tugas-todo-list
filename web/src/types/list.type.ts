export interface List {
  id: string | number;
  title: string;
  priority: boolean;
  due_date: Date | string;
  description?: string;
  category?: string;
  isFinished: boolean;
  userId: string | number;
  createdAt?: Date | string;
  updateAt?: Date | string;
}

export interface AddListRequest {
  title: string;
  priority: boolean;
  due_date: Date | string;
  description?: string;
  category?: string;
  userId: string | number;
}

export interface UpdateListRequest {
  title?: string;
  priority?: boolean;
  due_date?: Date | string;
  description?: string;
  category?: string;
  isFinished?: boolean;
}

// Proper response type for list operations
export interface ListResponse {
  message: string;
  data: List[];
}

// Single list item response
export interface SingleListResponse {
  message: string;
  data: List;
}

// Remove AuthResponse from here as it's not related to todo lists
// It should be in user.type.ts instead