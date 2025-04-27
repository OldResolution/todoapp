import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mad_lab_mini/core/utils.dart';
import '../../data/models/task.dart';
import '../../logic/providers/task_provider.dart';

class TaskTile extends ConsumerStatefulWidget {
  final Task task;
  const TaskTile({super.key, required this.task});

  @override
  ConsumerState<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends ConsumerState<TaskTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final task = widget.task;

    return Dismissible(
      key: Key(task.id),
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: theme.colorScheme.error,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: Icon(Icons.delete, color: theme.colorScheme.onError),
      ),
      onDismissed: (direction) {
        ref.read(taskNotifierProvider.notifier).deleteTask(task.id);
        AppUtils.showSnackBar(context, 'Task "${task.title}" deleted');
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            setState(() => _isExpanded = !_isExpanded);
            HapticFeedback.selectionClick();
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: task.isCompleted,
                      onChanged: (value) {
                        ref
                            .read(taskNotifierProvider.notifier)
                            .updateTask(
                              task.copyWith(isCompleted: value ?? false),
                            );
                        HapticFeedback.lightImpact();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      activeColor: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        task.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          decoration:
                              task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                          color:
                              task.isCompleted
                                  ? theme.colorScheme.onSurface.withOpacity(0.5)
                                  : theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    if (task.isImportant)
                      Icon(
                        Icons.priority_high,
                        color: theme.colorScheme.error,
                        size: 20,
                      ),
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: theme.colorScheme.error.withOpacity(0.6),
                      ),
                      onPressed: () {
                        ref
                            .read(taskNotifierProvider.notifier)
                            .deleteTask(task.id);
                        AppUtils.showSnackBar(
                          context,
                          'Task "${task.title}" deleted',
                        );
                      },
                    ),
                  ],
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  child:
                      _isExpanded
                          ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (task.description != null)
                                Text(
                                  task.description!,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.7),
                                  ),
                                ),
                              if (task.dueDate != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        size: 16,
                                        color: theme.colorScheme.primary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Due: ${task.dueDate!.toLocal().toString().split(' ')[0]}',
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: theme.colorScheme.primary,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          )
                          : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension on Task {
  Task copyWith({bool? isCompleted, bool? isImportant}) {
    return Task(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted ?? this.isCompleted,
      isImportant: isImportant ?? this.isImportant,
      createdAt: createdAt,
      dueDate: dueDate,
    );
  }
}
