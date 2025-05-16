import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/model/response_todos/datum.dart';
import '../provider/todo_provider.dart';

class TodoForm extends ConsumerStatefulWidget {
  final Datum? initialTodo;
  const TodoForm({super.key, this.initialTodo});

  @override
  ConsumerState<TodoForm> createState() => _TodoFormState();
}

class _TodoFormState extends ConsumerState<TodoForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  late bool _isPriority;
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    _isPriority = widget.initialTodo?.priority ?? false;
    _titleController = TextEditingController(
      text: widget.initialTodo?.title ?? '',
    );
    _descController = TextEditingController(
      text: widget.initialTodo?.description ?? '',
    );
    _dueDate = widget.initialTodo?.dueDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _pickDueDate() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365 * 5)),
    );

    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_dueDate ?? now),
      );

      if (pickedTime != null) {
        final combinedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          _dueDate = combinedDateTime;
        });
      }
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text.trim();
      final desc = _descController.text.trim();

      if (widget.initialTodo == null) {
        ref
            .read(todoAsyncProvider.notifier)
            .addTodo(
              title: title,
              description: desc,
              dueDate: _dueDate,
              priority: _isPriority,
            );
      } else {
        ref
            .read(todoAsyncProvider.notifier)
            .updateTodo(
              id: widget.initialTodo!.id!,
              title: title,
              description: desc,
              dueDate: _dueDate,
              priority: _isPriority,
              isFinished: widget.initialTodo!.isFinished,
            );
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        widget.initialTodo == null ? 'Tambah Todo' : 'Edit Todo',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Judul',
                    hintText: 'Masukkan judul tugas',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Judul wajib diisi'
                              : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descController,
                  decoration: InputDecoration(
                    labelText: 'Deskripsi',
                    hintText: 'Opsional',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.calendar_today, size: 20),
                    const SizedBox(width: 8),
                    // Tanggal (Flexible biar gak overflow)
                    Expanded(
                      child: Text(
                        _dueDate != null
                            ? "${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}"
                            : 'Belum dipilih',
                        style: const TextStyle(fontSize: 15),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: _pickDueDate,
                      icon: const Icon(Icons.edit_calendar, size: 20),
                      label: const Text("Pilih Tanggal"),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Prioritas Tinggi'),
                  value: _isPriority,
                  onChanged: (val) {
                    setState(() {
                      _isPriority = val;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        ElevatedButton.icon(
          onPressed: _submit,
          icon: const Icon(Icons.check),
          label: const Text('Simpan'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
