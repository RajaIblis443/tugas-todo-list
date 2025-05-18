import 'package:go_router/go_router.dart';
import 'package:mobile_app/model/response_todos/datum.dart';
import 'package:mobile_app/screen/todo_detail_screen.dart';
import 'package:mobile_app/screen/todo_screen.dart';

final router = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(path: '/home', builder: (context, state) => const TodoScreen()),
    GoRoute(
      path: '/todo/:id',
      builder: (context, state) => TodoDetailScreen(todo: state.extra as Datum),
    ),
  ],
);
