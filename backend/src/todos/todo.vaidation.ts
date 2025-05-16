import { z, ZodType } from 'zod';

export class TodoValidation {
  static readonly ADD_TODO: ZodType = z.object({
    title: z.string().min(1).max(30),
    priority: z.boolean().optional(),
    due_date: z.string().transform((val) => new Date(val)),
    description: z.string(),
    category: z.string().optional(),
    isFinished: z.boolean().optional(),
  });

  static readonly UPDATE_TODO: ZodType = z.object({
    id: z.number(),
    title: z.string().min(1).max(30),
    priority: z.boolean().optional(),
    due_date: z.string().transform((val) => new Date(val)),
    description: z.string(),
    category: z.string().optional(),
    isFinished: z.boolean().optional(),
  });

  static readonly CHECK_TODO: ZodType = z.object({
    isFinished: z.boolean(),
  });
}
