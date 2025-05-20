/* eslint-disable @typescript-eslint/no-unused-vars */
import { Inject, Injectable, UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PassportStrategy } from '@nestjs/passport';
import { WINSTON_MODULE_PROVIDER } from 'nest-winston';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { PrismaService } from 'src/common/prisma.service';
import { Logger } from 'winston';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(
    private configService: ConfigService,
    private prismaService: PrismaService,
    @Inject(WINSTON_MODULE_PROVIDER) private logger: Logger,
  ) {
    const jwtSecret =
      configService.get<string>('JWT_SECRET') || 'fallback-secret';

    logger.debug(
      `JWT Strategy initialized with secret length: ${jwtSecret.length}`,
    );

    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: jwtSecret,
    });
  }

  async validate(payload: { sub: string; email: string }) {
    this.logger.debug(`JWT validation attempt for user: ${payload.email}`);

    try {
      const user = await this.prismaService.user.findUnique({
        where: {
          id: payload.sub,
        },
      });

      if (!user) {
        this.logger.warn(
          `JWT validation failed: User ${payload.email} not found`,
        );
        throw new UnauthorizedException('Akses Ditolak');
      }

      this.logger.debug(`JWT validation successful for user: ${user.email}`);

      // Fix untuk error "operand of delete must be optional"
      const { password, ...userWithoutPassword } = user;
      return userWithoutPassword;
    } catch (error) {
      this.logger.error(`JWT validation error: ${error}`, {
        userId: payload.sub,
        email: payload.email,
      });
      throw error;
    }
  }
}
