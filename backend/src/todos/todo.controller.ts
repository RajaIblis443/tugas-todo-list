import { Body, Controller, Get, HttpCode, Post, Put } from '@nestjs/common';
import { TodoService } from './todo.service';
import { RequestTodos, ResponseTodos } from 'src/model/todo.model';
import { WebResponse } from 'src/model/web.model';

@Controller('api/tasks')
export class TodoController {
  constructor(private todoService: TodoService) {}

  @Post()
  @HttpCode(200)
  async addTodos(
    @Body() request: RequestTodos,
  ): Promise<WebResponse<ResponseTodos>> {
    const result = await this.todoService.add_todo(request);
    return {
      data: result,
    };
  }

  @Get()
  @HttpCode(200)
  async getTodos(): Promise<WebResponse<ResponseTodos[]>> {
    const result = await this.todoService.get_todo();
    return {
      message: 'Berhasil',
      data: result,
    };
  }

  @Put()
  @HttpCode(200)
  async updateTodos(
    @Body() request: RequestTodos,
  ): Promise<WebResponse<ResponseTodos>> {
    const result = await this.todoService.update_todo(request);
    return {
      data: result,
      message: 'berhasil di update',
    };
  }
}
