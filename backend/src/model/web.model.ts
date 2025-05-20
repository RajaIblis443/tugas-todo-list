export class WebResponse<T> {
  message?: string;
  data?: T;
  errors?: string;
  paging?: Paging;
  token?: string;
}

export class Paging {
  size: number;
  total_page: number;
  current_page: number;
}
