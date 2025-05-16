import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/model/response_todos/datum.dart';
import 'package:mobile/model/response_todos/response_todos.dart';

class TodoNotiferAsync extends AsyncNotifier<List<Datum>> {
  final _dio = Dio(BaseOptions(baseUrl: 'http://192.168.11.240:3000/api'));

  @override
  FutureOr<List<Datum>> build() async {
    try {
      final response = await _dio.get('/tasks');
      final json = response.data;
      if (json is List) {
        return json.map((e) => Datum.fromMap(e)).toList();
      }
      final data = ResponseTodos.fromMap(json);
      log('$data');

      final list = data.data ?? [];

      list.sort((a, b) {
        if (a.priority == true && b.priority != true) return -1;
        if (a.priority != true && b.priority == true) return 1;

        if (a.isFinished == true && b.isFinished != true) return 1;
        if (a.isFinished != true && b.isFinished == true) return -1;

        return 0;
      });
      return list;
    } catch (e, st) {
      log('Gagal fetch data', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<void> addTodo({
    required String title,
    required String description,
    DateTime? dueDate,
    bool? priority,
  }) async {
    try {
      final payload = {
        'title': title,
        'description': description,
        'due_date': dueDate?.toIso8601String(),
        'priority': priority ?? false,
      };

      await _dio.post('/tasks', data: payload);
      ref.invalidateSelf(); // refresh state
      await future; // re-fetch
    } catch (e, st) {
      log('Gagal tambah todo', error: e, stackTrace: st);
      rethrow;
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
      ref.invalidateSelf();
      await future;
    } catch (e, st) {
      log('Gagal update todo', error: e, stackTrace: st);
      rethrow;
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
      ref.invalidateSelf();
      await future;
    } catch (e, st) {
      log('Gagal update todo', error: e, stackTrace: st);
      rethrow;
    }
  }
}

final todoAsyncProvider = AsyncNotifierProvider<TodoNotiferAsync, List<Datum>>(
  () => TodoNotiferAsync(),
);
