export class ResponseTodos {
  id?: number;
  title?: string;
  priority?: boolean;
  due_date?: Date;
  description?: string;
  category?: string;
  isFinished?: boolean;
  createdAt?: Date;
  userId: string;
}

export class RequestAddTodos {
  title: string;
  priority: boolean;
  due_date: Date;
  description: string;
  category?: string;
  isFinished?: boolean;
  userId: string;
}

export class RequestUpdateTodos extends RequestAddTodos {
  id: number;
}

export class RequestTodos extends RequestAddTodos {}
