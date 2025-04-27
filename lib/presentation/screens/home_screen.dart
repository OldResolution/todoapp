import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../logic/providers/task_provider.dart';
import '../widgets/task_tile.dart';
import 'task_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/settings',
              ).then((_) => HapticFeedback.lightImpact());
            },
          ),
        ],
      ),
      body: tasks.when(
        data:
            (taskList) =>
                taskList.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                                Icons.task_alt,
                                size: 80,
                                color: theme.colorScheme.primary.withOpacity(
                                  0.3,
                                ),
                              )
                              .animate()
                              .fadeIn(duration: 600.ms)
                              .scale(begin: Offset(0.8, 0.8)),
                          const SizedBox(height: 16),
                          Text(
                                'No Tasks Yet!',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.6),
                                ),
                              )
                              .animate()
                              .fadeIn(duration: 600.ms, delay: 100.ms)
                              .slideY(begin: 0.2, end: 0.0),
                          const SizedBox(height: 8),
                          Text(
                            'Add a task to get started',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.5,
                              ),
                            ),
                          ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      itemCount: taskList.length,
                      itemBuilder: (context, index) {
                        final task = taskList[index];
                        return TaskTile(task: task)
                            .animate()
                            .fadeIn(duration: 400.ms, delay: (index * 100).ms)
                            .slideX(begin: 0.3, end: 0.0);
                      },
                    ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton:
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TaskScreen()),
              ).then((_) => HapticFeedback.lightImpact());
            },
            backgroundColor: theme.colorScheme.secondary,
            foregroundColor: theme.colorScheme.onSecondary,
            child: const Icon(Icons.add, size: 28),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ).animate().fadeIn(duration: 600.ms).scale(),
    );
  }
}
