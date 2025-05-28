import { createRouter, createWebHistory, type RouteRecordRaw } from "vue-router";
import Login from "../views/Login.vue";
import TodosView from "../views/TodosView.vue";

const routes: RouteRecordRaw[] = [
  {
    path: '/',
    name: 'default',
    component: Login,
  },
  {
    path: '/login',
    name: 'login',
    component: Login
  },
  {
    path: '/todos',
    name: 'home',
    component: TodosView
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

export default router;