import { z, ZodType } from 'zod';

export class AuthValidation {
  static readonly LOGIN_USER: ZodType = z.object({
    email: z.string().email(),
    password: z.string().min(6).max(20),
  });

  static readonly REGISTER_USER: ZodType = z.object({
    name: z.string().min(1).max(30),
    email: z.string().email(),
    password: z.string().min(6).max(20),
  });
}
