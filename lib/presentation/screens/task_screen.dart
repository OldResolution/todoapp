import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../core/utils.dart';
import '../../data/models/task.dart';
import '../../logic/providers/task_provider.dart';
import '../widgets/common_widgets.dart';

class TaskScreen extends ConsumerStatefulWidget {
  const TaskScreen({super.key});

  @override
  ConsumerState<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends ConsumerState<TaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _dueDate;
  bool _isImportant = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (_titleController.text.isEmpty) {
      HapticFeedback.heavyImpact();
      AppUtils.showSnackBar(context, 'Please enter a task title');
      return;
    }

    final task = Task(
      id: const Uuid().v4(),
      title: _titleController.text,
      description:
          _descriptionController.text.isEmpty
              ? null
              : _descriptionController.text,
      createdAt: DateTime.now(),
      dueDate: _dueDate,
      isImportant: _isImportant,
    );

    ref
        .read(taskNotifierProvider.notifier)
        .addTask(task)
        .then((_) {
          Navigator.pop(context);
          HapticFeedback.lightImpact();
          // Navigate to PomodoroScreen after saving
          Navigator.pushNamed(
            context,
            '/pomodoro',
            arguments: {'taskId': task.id},
          );
        })
        .catchError((e) {
          AppUtils.showSnackBar(context, 'Error saving task: $e');
        });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Task'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CommonWidgets.buildTextField(
              controller: _titleController,
              label: 'Task Title',
              hintText: 'What needs to be done?',
              prefixIcon: Icon(Icons.task, color: theme.colorScheme.primary),
            ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2, end: 0.0),
            const SizedBox(height: 16),
            CommonWidgets.buildTextField(
                  controller: _descriptionController,
                  label: 'Description (optional)',
                  hintText: 'Add details...',
                  prefixIcon: Icon(
                    Icons.description,
                    color: theme.colorScheme.primary,
                  ),
                  maxLines: 4,
                )
                .animate()
                .fadeIn(duration: 400.ms, delay: 100.ms)
                .slideX(begin: 0.2, end: 0.0),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Important'),
                    secondary: Icon(
                      Icons.priority_high,
                      color:
                          _isImportant
                              ? theme.colorScheme.error
                              : theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                    value: _isImportant,
                    onChanged: (value) {
                      setState(() => _isImportant = value);
                      HapticFeedback.selectionClick();
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(
                      Icons.calendar_today,
                      color: theme.colorScheme.primary,
                    ),
                    title: Text(
                      _dueDate == null
                          ? 'Add Due Date'
                          : 'Due: ${_dueDate!.toLocal().toString().split(' ')[0]}',
                    ),
                    trailing:
                        _dueDate != null
                            ? IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: theme.colorScheme.error,
                              ),
                              onPressed: () => setState(() => _dueDate = null),
                            )
                            : null,
                    onTap: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2030),
                        builder:
                            (context, child) => Theme(
                              data: theme.copyWith(
                                dialogTheme: DialogTheme(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                              child: child!,
                            ),
                      );
                      if (selectedDate != null) {
                        setState(() => _dueDate = selectedDate);
                      }
                    },
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
            const SizedBox(height: 24),
            CommonWidgets.buildButton(
              onPressed: _saveTask,
              label: 'Save & Start Pomodoro',
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
            ).animate().fadeIn(duration: 400.ms, delay: 300.ms).scale(),
          ],
        ),
      ),
    );
  }
}
