import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/provider/todo_provider.dart';
import 'package:mobile/widget/todo_form.dart';
import 'package:intl/intl.dart';

class TodoScreen extends ConsumerWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoAsync = ref.watch(todoAsyncProvider);
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, d MMM').format(now);

    return Scaffold(
      backgroundColor: const Color(0xFF5F6DF6),
      body: SafeArea(
        child: todoAsync.when(
          data: (todos) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${todos.length} tasks",
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child:
                        todos.isEmpty
                            ? const Center(
                              child: Text(
                                'Belum ada todo 🎉',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                            : ListView.separated(
                              itemCount: todos.length,
                              separatorBuilder: (_, __) => const Divider(),
                              itemBuilder: (context, index) {
                                final todo = todos[index];

                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        ref
                                            .watch(todoAsyncProvider.notifier)
                                            .cheackTodo(
                                              id: todo.id!,
                                              title: todo.title,
                                              description: todo.description,
                                              dueDate: todo.dueDate,
                                              isFinished: todo.isFinished,
                                              priority: todo.priority,
                                            );
                                      },
                                      child: Icon(
                                        (todo.isFinished == true)
                                            ? Icons.radio_button_checked
                                            : Icons.radio_button_unchecked,
                                        size: 24,
                                        color:
                                            (todo.isFinished == true)
                                                ? Colors.blue
                                                : Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          // Fitur edit
                                          showDialog(
                                            context: context,
                                            builder:
                                                (_) => Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        bottom: 20,
                                                      ),
                                                  child: TodoForm(
                                                    initialTodo: todo,
                                                  ), // << kirim todo untuk edit
                                                ),
                                          );
                                        },
                                        child: Text(
                                          todo.title ?? 'Tanpa Judul',
                                          style: TextStyle(
                                            fontSize: 16,
                                            decoration:
                                                todo.isFinished == true
                                                    ? TextDecoration.lineThrough
                                                    : TextDecoration.none,
                                            color:
                                                todo.isFinished == true
                                                    ? Colors.grey
                                                    : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      todo.dueDate != null
                                          ? DateFormat(
                                            'h:mma',
                                          ).format(todo.dueDate!).toLowerCase()
                                          : '',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    GestureDetector(
                                      onTap: () async {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder:
                                              (context) => AlertDialog(
                                                title: const Text("Konfirmasi"),
                                                content: const Text(
                                                  "Yakin ingin menghapus todo ini?",
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed:
                                                        () => Navigator.pop(
                                                          context,
                                                          false,
                                                        ),
                                                    child: const Text("Batal"),
                                                  ),
                                                  TextButton(
                                                    onPressed:
                                                        () => Navigator.pop(
                                                          context,
                                                          true,
                                                        ),
                                                    child: const Text("Hapus"),
                                                  ),
                                                ],
                                              ),
                                        );

                                        if (confirm == true) {}
                                      },
                                      child: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                  ),
                ],
              ),
            );
          },
          error:
              (e, st) => const Center(
                child: Text('Terjadi Kesalahan Saat Mengambil Data'),
              ),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        shape: const CircleBorder(),
        onPressed: () {
          showDialog(
            context: context,
            builder:
                (_) => const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: TodoForm(),
                ),
          );
        },
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }
}
