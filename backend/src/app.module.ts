import { Module } from '@nestjs/common';
import { TodoModule } from './todos/todo.module';
import { CommonModule } from './common/common.module';

@Module({
  imports: [TodoModule, CommonModule],
  controllers: [],
  providers: [],
  exports: [],
})
export class AppModule {}
