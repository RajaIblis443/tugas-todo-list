import { Request } from 'express';

export class loginUser {
  email: string;
  password: string;
}

export class registerUser {
  name: string;
  email: string;
  password: string;
}

export class ResponseUser {
  id: string;
  name: string;
  email: string;
  createdAt?: Date;
  updatedAt?: Date;
}

export interface JwtAuthRequest extends Request {
  user: {
    id: string;
    email: string;
    name: string;
  };
}
