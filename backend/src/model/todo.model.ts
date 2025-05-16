export class ResponseTodos {
  id?: number;
  title?: string;
  priority?: boolean;
  due_date: Date;
  description?: string;
  category?: string;
  isFinished?: boolean;
  createdAt?: Date;
}

export class RequestTodos {
  id?: number;
  title: string;
  priority: boolean;
  due_date: Date;
  description: string;
  category?: string;
  isFinished?: boolean;
}
