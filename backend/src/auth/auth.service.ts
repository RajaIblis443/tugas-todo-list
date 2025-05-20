/* eslint-disable @typescript-eslint/no-unused-vars */
import { Inject, Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { WINSTON_MODULE_PROVIDER } from 'nest-winston';
import { PrismaService } from 'src/common/prisma.service';
import { ValidationService } from 'src/common/validation.service';
import { loginUser, ResponseUser } from 'src/model/auth.model';
import { WebResponse } from 'src/model/web.model';
import { Logger } from 'winston';
import { AuthValidation } from './auth.validation';

@Injectable()
export class AuthService {
  constructor(
    private prisma: PrismaService,
    private jwtService: JwtService,
    private validationService: ValidationService,
    @Inject(WINSTON_MODULE_PROVIDER) private logger: Logger,
  ) {}

  async validateUser(request: loginUser): Promise<ResponseUser | null> {
    const validationRequest = this.validationService.validate(
      AuthValidation.LOGIN_USER,
      request,
    ) as loginUser;

    const user = await this.prisma.user.findUnique({
      where: { email: validationRequest.email },
    });

    if (
      user &&
      (await bcrypt.compare(validationRequest.password, user.password))
    ) {
      const { password, ...result } = user;
      return result as ResponseUser;
    }

    return null;
  }

  async login(request: loginUser): Promise<WebResponse<ResponseUser>> {
    try {
      this.logger.debug(`Login attempt: ${request.email}`);

      const user = await this.validateUser(request);

      if (!user) {
        throw new UnauthorizedException('Email atau password salah');
      }

      const payload = { sub: user.id, email: user.email };
      const token = this.jwtService.sign(payload);

      this.logger.debug(`User logged in successfully: ${user.email}`);

      return {
        token: token,
        data: user,
      };
    } catch (error) {
      this.logger.error(`Login error: ${error}`);

      if (error instanceof UnauthorizedException) {
        throw error;
      }

      throw new Error(`Login failed: ${error}`);
    }
  }

  async register(
    name: string,
    email: string,
    password: string,
  ): Promise<ResponseUser> {
    const existingUser = await this.prisma.user.findUnique({
      where: { email },
    });

    if (existingUser) {
      throw new UnauthorizedException('Email sudah terdaftar');
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const user = await this.prisma.user.create({
      data: {
        name,
        email,
        password: hashedPassword,
      },
    });

    const { password: _, ...result } = user;

    return result as ResponseUser;
  }
}
