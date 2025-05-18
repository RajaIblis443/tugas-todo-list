import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/model/response_todos/datum.dart';
import 'package:mobile_app/provider/todo_provider.dart';
import 'package:mobile_app/widget/todo_form.dart';

class TodoItemCard extends ConsumerWidget {
  final Datum todo;

  const TodoItemCard({super.key, required this.todo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoNotifier = ref.read(todoAsyncProvider.notifier);

    return Slidable(
      key: ValueKey(todo.id),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              HapticFeedback.lightImpact();
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Delete Todo'),
                      content: const Text(
                        'Are you sure you want to delete this todo?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            todoNotifier.deleteTodo(todo.id!);
                            Navigator.of(context).pop();
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
              );
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(16),
            ),
            label: 'Delete',
          ),
          SlidableAction(
            onPressed: (context) {
              HapticFeedback.lightImpact();
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                backgroundColor: Colors.transparent,
                builder:
                    (_) => Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: TodoForm(todo: todo), // Pass todo untuk mode edit
                    ),
              );
            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(16),
            ),
            label: 'Edit',
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          context.go('/todo/${todo.id}');
        },
        child: Card(
          elevation: 2,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side:
                todo.priority == true
                    ? BorderSide(color: Colors.red.shade200, width: 1.5)
                    : BorderSide.none,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: CheckboxListTile(
              value: todo.isFinished ?? false,
              onChanged: (value) {
                HapticFeedback.lightImpact();
                todoNotifier.cheackTodo(
                  id: todo.id!,
                  description: todo.description,
                  dueDate: todo.dueDate,
                  isFinished: !value!,
                  priority: todo.priority,
                  title: todo.title,
                );
              },
              title: Text(
                todo.title ?? 'No title',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight:
                      (todo.isFinished ?? false)
                          ? FontWeight.normal
                          : FontWeight.w600,
                  decoration:
                      (todo.isFinished ?? false)
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                  color:
                      (todo.isFinished ?? false)
                          ? Colors.grey
                          : Colors.grey[800],
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (todo.dueDate != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('MMM d hh:mm').format(todo.dueDate!),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              secondary:
                  (todo.priority ?? false)
                      ? Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.priority_high,
                          color: Colors.red,
                        ),
                      )
                      : null,
              checkboxShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              activeColor: Colors.blue,
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
      ),
    );
  }
}
