import { Module } from '@nestjs/common';
import { TodoModule } from './todos/todo.module';
import { CommonModule } from './common/common.module';
import { AuthModule } from './auth/auth.module';

@Module({
  imports: [TodoModule, CommonModule, AuthModule],
  controllers: [],
  providers: [],
  exports: [],
})
export class AppModule {}
