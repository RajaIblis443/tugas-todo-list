import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/model/response_todos/datum.dart';
import 'package:mobile_app/model/response_todos/response_todos.dart';
import 'package:mobile_app/setings.dart';

class TodoNotifierAsync extends AsyncNotifier<List<Datum>> {
  late final Dio _dio;

  @override
  FutureOr<List<Datum>> build() async {
    final baseUrl = base_url;

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    return _fetchTodos();
  }

  Future<List<Datum>> _fetchTodos() async {
    try {
      final response = await _dio.get('/tasks');
      final json = response.data;

      final list =
          json is List
              ? json.map((e) => Datum.fromMap(e)).toList()
              : ResponseTodos.fromMap(json).data ?? [];

      return _sortTodos(list);
    } catch (e, st) {
      log('Unexpected error', error: e, stackTrace: st);
      return [];
    }
  }

  List<Datum> _sortTodos(List<Datum> list) {
    return list..sort((a, b) {
      if (a.priority != true && b.priority == true) return 1;

      if (a.isFinished == true && b.isFinished != true) return 1;
      if (a.isFinished != true && b.isFinished == true) return -1;

      return 0;
    });
  }

  Future<void> refreshTodos() async {
    try {
      state = await AsyncValue.guard(() async {
        final todos = await _fetchTodos();
        return todos;
      });
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addTodo({
    required String title,
    required String description,
    DateTime? dueDate,
    bool? priority,
  }) async {
    state = const AsyncValue.loading();
    try {
      final payload = {
        'title': title,
        'description': description,
        'due_date': dueDate?.toIso8601String(),
        'priority': priority ?? false,
      };

      await _dio.post('/tasks', data: payload);
      await refreshTodos();
    } catch (e, st) {
      log('Failed to add todo', error: e, stackTrace: st);
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateTodo({
    required int id,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? priority,
    bool? isFinished,
  }) async {
    state = const AsyncValue.loading();
    try {
      final payload = {
        'id': id,
        if (title != null) 'title': title,
        if (description != null) 'description': description,
        if (dueDate != null) 'due_date': dueDate.toIso8601String(),
        if (priority != null) 'priority': priority,
        if (isFinished != null) 'isFinished': isFinished,
      };

      await _dio.put('/tasks', data: payload);
      await refreshTodos();
    } catch (e, st) {
      log('Failed to update todo', error: e, stackTrace: st);
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> cheackTodo({
    required int id,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? priority,
    bool? isFinished,
  }) async {
    state = const AsyncValue.loading();
    try {
      final payload = {
        'id': id,
        if (title != null) 'title': title,
        if (description != null) 'description': description,
        if (dueDate != null) 'due_date': dueDate.toIso8601String(),
        if (priority != null) 'priority': priority,
        if (isFinished != null) 'isFinished': !isFinished,
      };

      await _dio.put('/tasks', data: payload);
      await refreshTodos();
    } catch (e, st) {
      log('Failed to check todo', error: e, stackTrace: st);
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteTodo(int id) async {
    state = const AsyncValue.loading();
    try {
      await _dio.delete('/tasks/$id');
      await refreshTodos();
    } catch (e, st) {
      log('Failed to delete todo', error: e, stackTrace: st);
      state = AsyncValue.error(e, st);
    }
  }
}

final todoAsyncProvider = AsyncNotifierProvider<TodoNotifierAsync, List<Datum>>(
  () => TodoNotifierAsync(),
);
