import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/model/response_todos/datum.dart';
import 'package:mobile_app/provider/todo_provider.dart';

class TodoForm extends ConsumerStatefulWidget {
  final Datum? todo; // Parameter baru untuk todo yang akan diupdate

  const TodoForm({super.key, this.todo});

  @override
  ConsumerState<TodoForm> createState() => _TodoFormState();
}

class _TodoFormState extends ConsumerState<TodoForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  bool _isPriority = false;
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();

    // Inisialisasi form dengan data yang ada jika mode edit
    if (widget.todo != null) {
      _titleController.text = widget.todo!.title ?? '';
      _descController.text = widget.todo!.description ?? '';
      _isPriority = widget.todo!.priority ?? false;
      _dueDate = widget.todo!.dueDate;
    }

    _titleController.addListener(() {
      setState(() {});
    });
    _descController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (widget.todo == null) {
        // Menambah todo baru
        await ref
            .read(todoAsyncProvider.notifier)
            .addTodo(
              title: _titleController.text,
              description: _descController.text,
              dueDate: _dueDate,
              priority: _isPriority,
            );
      } else {
        // Update todo yang sudah ada
        await ref
            .read(todoAsyncProvider.notifier)
            .updateTodo(
              id: widget.todo!.id!,
              title: _titleController.text,
              description: _descController.text,
              dueDate: _dueDate,
              priority: _isPriority,
              isFinished: widget.todo!.isFinished,
            );
      }

      if (mounted) {
        GoRouter.of(context).pop();
      }
    }
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: now.subtract(
        const Duration(days: 365),
      ), // Untuk edit, bisa pilih tanggal lalu
      lastDate: DateTime(now.year + 1),
    );

    if (picked != null && mounted) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime:
            _dueDate != null
                ? TimeOfDay(hour: _dueDate!.hour, minute: _dueDate!.minute)
                : TimeOfDay.now(),
      );

      if (pickedTime != null && mounted) {
        setState(() {
          _dueDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      } else if (mounted) {
        setState(() => _dueDate = picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditMode = widget.todo != null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 20),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        elevation: 5,
        color: theme.colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Wrap(
              runSpacing: 16,
              children: [
                Text(
                  isEditMode ? 'Edit Todo' : 'Tambah Todo',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Judul',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.title),
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Judul wajib diisi'
                              : null,
                ),
                TextFormField(
                  controller: _descController,
                  decoration: InputDecoration(
                    labelText: 'Deskripsi',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.description),
                  ),
                  maxLines: 3,
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Deskripsi wajib diisi'
                              : null,
                ),
                Row(
                  children: [
                    const Icon(Icons.flag),
                    const SizedBox(width: 8),
                    const Expanded(child: Text('Prioritas Tinggi')),
                    Switch(
                      value: _isPriority,
                      onChanged: (value) => setState(() => _isPriority = value),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _dueDate == null
                            ? 'Tidak ada tenggat waktu'
                            : 'Tenggat: ${_dueDate!.toLocal().toString().split(' ')[0]}',
                      ),
                    ),
                    TextButton(
                      onPressed: _pickDueDate,
                      child: const Text('Pilih Tanggal'),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.save),
                    label: Text(isEditMode ? 'Perbarui Todo' : 'Simpan Todo'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
