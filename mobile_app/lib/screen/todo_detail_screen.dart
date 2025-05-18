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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Detail Tugas',
          style: TextStyle(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
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
            icon: const Icon(Icons.delete_outline),
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status bar
            Row(
              children: [
                if (todo.priority == true)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 50),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.flag_rounded,
                          color: Colors.red.shade500,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Prioritas',
                          style: TextStyle(
                            color: Colors.red.shade500,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                const Spacer(),
                Text(
                  todo.isFinished ?? false ? 'Selesai' : 'Belum Selesai',
                  style: TextStyle(
                    color:
                        (todo.isFinished ?? false)
                            ? Colors.green.shade600
                            : Colors.orange.shade600,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 8),
                Switch(
                  value: todo.isFinished ?? false,
                  activeColor: Colors.green.shade400,
                  onChanged: (value) {
                    todoNotifier.cheackTodo(
                      id: todo.id!,
                      title: todo.title,
                      description: todo.description,
                      dueDate: todo.dueDate,
                      priority: todo.priority,
                      isFinished: !(todo.isFinished ?? false),
                    );
                  },
                ),
              ],
            ),

            // Title section
            const SizedBox(height: 20),
            Text(
              todo.title ?? 'Tanpa Judul',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                decoration:
                    (todo.isFinished ?? false)
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                color:
                    (todo.isFinished ?? false)
                        ? Colors.grey.shade400
                        : Colors.black87,
              ),
            ),

            // Due date section
            if (todo.dueDate != null) ...[
              const SizedBox(height: 20),
              Row(
                children: [
                  Icon(
                    Icons.schedule_rounded,
                    color: theme.colorScheme.primary.withValues(alpha: 50),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat(
                      'EEEE, d MMMM y • HH:mm',
                      'id_ID',
                    ).format(todo.dueDate!),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary.withValues(alpha: 50),
                    ),
                  ),
                ],
              ),
            ],

            // Description section
            const SizedBox(height: 30),
            Text(
              'Deskripsi',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                todo.description ?? 'Tidak ada deskripsi',
                style: theme.textTheme.bodyLarge?.copyWith(
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
