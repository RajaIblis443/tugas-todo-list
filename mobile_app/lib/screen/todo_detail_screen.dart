import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/model/response_todos/datum.dart';
import 'package:mobile_app/provider/todo_provider.dart';
import 'package:mobile_app/widget/todo_form.dart';

class TodoDetailScreen extends ConsumerWidget {
  final Datum todo;

  const TodoDetailScreen({super.key, required this.todo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final todoNotifier = ref.read(todoAsyncProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Tugas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                backgroundColor: Colors.transparent,
                builder:
                    (_) => Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: TodoForm(todo: todo),
                    ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Hapus Tugas'),
                      content: const Text(
                        'Apakah Anda yakin ingin menghapus tugas ini?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () {
                            todoNotifier.deleteTodo(todo.id!);
                            Navigator.pop(context);
                            context.pop();
                          },
                          child: const Text('Hapus'),
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side:
                    todo.priority == true
                        ? BorderSide(color: Colors.red.shade200, width: 1.5)
                        : BorderSide.none,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            todo.title ?? 'Tanpa Judul',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              decoration:
                                  (todo.isFinished ?? false)
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                            ),
                          ),
                        ),
                        Checkbox(
                          value: todo.isFinished ?? false,
                          onChanged: (value) {
                            todoNotifier.cheackTodo(
                              id: todo.id!,
                              title: todo.title,
                              description: todo.description,
                              dueDate: todo.dueDate,
                              priority: todo.priority,
                              isFinished: !(todo.isFinished ?? false),
                            );
                            context.pop();
                          },
                        ),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 8),
                    if (todo.dueDate != null) ...[
                      Row(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.grey[600]),
                          const SizedBox(width: 8),
                          Text(
                            'Tenggat: ${DateFormat('EEEE, d MMMM y HH:mm', 'id_ID').format(todo.dueDate!)}',
                            style: theme.textTheme.bodyLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (todo.priority == true) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.priority_high,
                              color: Colors.red.shade700,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Prioritas Tinggi',
                              style: TextStyle(color: Colors.red.shade700),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    Text(
                      'Deskripsi',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      todo.description ?? 'Tidak ada deskripsi',
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
