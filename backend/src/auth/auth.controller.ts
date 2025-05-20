import { Body, Controller, Post } from '@nestjs/common';
import { AuthService } from './auth.service';
import { loginUser, ResponseUser } from 'src/model/auth.model';
import { WebResponse } from 'src/model/web.model';

@Controller('api/auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post('login')
  async login(@Body() body: loginUser): Promise<WebResponse<ResponseUser>> {
    return this.authService.login(body);
  }

  @Post('register')
  async register(
    @Body() body: { name: string; email: string; password: string },
  ) {
    return this.authService.register(body.name, body.email, body.password);
  }
}
