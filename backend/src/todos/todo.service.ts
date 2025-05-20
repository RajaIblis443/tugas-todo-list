import { Inject, Injectable } from '@nestjs/common';
import { WINSTON_MODULE_PROVIDER } from 'nest-winston';
import { PrismaService } from 'src/common/prisma.service';
import { ValidationService } from 'src/common/validation.service';
import {
  RequestAddTodos,
  RequestUpdateTodos,
  ResponseTodos,
} from 'src/model/todo.model';
import { Logger } from 'winston';
import { TodoValidation } from './todo.vaidation';

@Injectable()
export class TodoService {
  constructor(
    private prismaService: PrismaService,
    private validationService: ValidationService,
    @Inject(WINSTON_MODULE_PROVIDER) private logger: Logger,
  ) {}

  async update_todo(request: RequestUpdateTodos): Promise<ResponseTodos> {
    this.logger.debug(`update todos ${JSON.stringify(request)}`);

    // Validasi input
    const validatedRequest = this.validationService.validate(
      TodoValidation.UPDATE_TODO,
      request,
    ) as RequestUpdateTodos;

    if (!validatedRequest.id) {
      throw new Error('ID todo wajib ada untuk update');
    }

    // Update data di DB
    const todo = await this.prismaService.list.update({
      where: { id: validatedRequest.id },
      data: {
        title: validatedRequest.title,
        description: validatedRequest.description,
        due_date: validatedRequest.due_date,
        priority: validatedRequest.priority,
        category: validatedRequest.category,
        isFinished: validatedRequest.isFinished,
      },
    });

    return {
      id: todo.id,
      title: todo.title,
      priority: todo.priority,
      due_date: todo.due_date,
      description: todo.description,
      category: todo.category ?? undefined,
      isFinished: todo.isFinished,
      createdAt: todo.createdAt,
      userId: todo.userId,
    };
  }

  async add_todo(request: RequestAddTodos): Promise<ResponseTodos> {
    this.logger.debug(`add todos ${JSON.stringify(request)}`);

    const validatedRequest = this.validationService.validate(
      TodoValidation.ADD_TODO,
      request,
    ) as RequestAddTodos;

    const dataToInsert = {
      title: validatedRequest.title,
      description: validatedRequest.description,
      category: validatedRequest.category,
      due_date: validatedRequest.due_date ?? new Date(),
      isFinished: validatedRequest.isFinished ?? false,
      priority: validatedRequest.priority ?? false,
      userId: validatedRequest.userId,
    };

    const todo = await this.prismaService.list.create({
      data: dataToInsert,
    });

    return {
      id: todo.id,
      title: todo.title,
      priority: todo.priority,
      due_date: todo.due_date,
      description: todo.description,
      category: todo.category ?? undefined,
      isFinished: todo.isFinished,
      createdAt: todo.createdAt,
      userId: todo.userId,
    };
  }

  async get_todo(userId: string): Promise<ResponseTodos[]> {
    // Tambahkan filter berdasarkan userId
    const todos = await this.prismaService.list.findMany({
      where: { userId },
    });

    return todos.map((todo) => ({
      id: todo.id,
      title: todo.title,
      priority: todo.priority,
      due_date: todo.due_date,
      description: todo.description,
      category: todo.category ?? undefined,
      isFinished: todo.isFinished,
      createdAt: todo.createdAt,
      userId: todo.userId,
    }));
  }

  async delete_todo(id: number, userId: string): Promise<ResponseTodos> {
    const todos = await this.prismaService.list.delete({
      where: {
        id: parseInt(String(id), 10),
        userId,
      },
    });

    return {
      id: todos.id,
      title: todos.title,
      priority: todos.priority,
      due_date: todos.due_date,
      description: todos.description,
      category: todos.category ?? undefined,
      isFinished: todos.isFinished,
      createdAt: todos.createdAt,
      userId: todos.userId,
    };
  }
}
