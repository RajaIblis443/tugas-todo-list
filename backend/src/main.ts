/* eslint-disable @typescript-eslint/no-unsafe-call */
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { WinstonModule } from 'nest-winston';
import * as winston from 'winston';

async function bootstrap() {
  const app = await NestFactory.create(AppModule, {
    logger: WinstonModule.createLogger({
      transports: [
        new winston.transports.Console({
          format: winston.format.combine(
            winston.format.timestamp(),
            winston.format.colorize(),
            winston.format.simple(),
          ),
        }),
      ],
    }),
  });

  // Konfigurasi CORS yang lebih lengkap
  app.enableCors({
    origin: (origin, callback) => {
      callback(null, true); // 🚨 Allow all (hati-hati di production)
    },
    credentials: true,
  });

  await app.listen(process.env.PORT ?? 3000);
  console.log(`Server running on ${await app.getUrl()}`);
}
bootstrap();
