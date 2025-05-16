import 'package:go_router/go_router.dart';
import 'package:mobile/screen/todo_screen.dart';

final router = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(path: '/home', builder: (context, state) => const TodoScreen()),
  ],
);
