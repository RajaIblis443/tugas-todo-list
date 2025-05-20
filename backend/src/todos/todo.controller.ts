import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  Param,
  ParseIntPipe,
  Post,
  Put,
  Request,
  UseGuards,
} from '@nestjs/common';
import { TodoService } from './todo.service';
import {
  RequestTodos,
  RequestUpdateTodos,
  ResponseTodos,
} from 'src/model/todo.model';
import { WebResponse } from 'src/model/web.model';
import { JwtAuthGuard } from 'src/auth/jwt-auth.guard';
import { JwtAuthRequest } from 'src/model/auth.model';

@Controller('api/tasks')
export class TodoController {
  constructor(private todoService: TodoService) {}

  @UseGuards(JwtAuthGuard)
  @Post()
  @HttpCode(200)
  async addTodos(
    @Body() request: RequestTodos,
    @Request() req: JwtAuthRequest,
  ): Promise<WebResponse<ResponseTodos>> {
    const result = await this.todoService.add_todo({
      ...request,
      userId: req.user.id,
    });
    return {
      data: result,
    };
  }

  @UseGuards(JwtAuthGuard)
  @Get()
  @HttpCode(200)
  async getTodos(
    @Request() req: JwtAuthRequest,
  ): Promise<WebResponse<ResponseTodos[]>> {
    const result = await this.todoService.get_todo(req.user.id); // Gunakan userId dari JWT
    return {
      message: 'Berhasil',
      data: result,
    };
  }

  @UseGuards(JwtAuthGuard)
  @Put()
  @HttpCode(200)
  async updateTodos(
    @Body() request: RequestUpdateTodos,
    @Request() req: JwtAuthRequest,
  ): Promise<WebResponse<ResponseTodos>> {
    const result = await this.todoService.update_todo({
      ...request,
      userId: req.user.id,
    });
    return {
      data: result,
      message: 'berhasil di update',
    };
  }

  @UseGuards(JwtAuthGuard)
  @Delete(':id')
  @HttpCode(200)
  async deleteTodos(
    @Param('id', ParseIntPipe) id: number,
    @Request() req: JwtAuthRequest,
  ): Promise<WebResponse<ResponseTodos>> {
    const result = await this.todoService.delete_todo(id, req.user.id); // Gunakan userId dari JWT
    return {
      data: result,
      message: 'berhasil di hapus',
    };
  }
}
