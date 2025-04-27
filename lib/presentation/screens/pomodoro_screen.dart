import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mad_lab_mini/logic/providers/pomodoro_provider.dart';
import 'package:mad_lab_mini/core/utils.dart';

class PomodoroScreen extends ConsumerWidget {
  final String taskId;

  const PomodoroScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pomodoroState = ref.watch(activePomodoroProvider);
    final theme = Theme.of(context);

    if (pomodoroState.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppUtils.showSnackBar(context, pomodoroState.error!);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pomodoro Timer'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${pomodoroState.timeLeft ~/ 60}:${(pomodoroState.timeLeft % 60).toString().padLeft(2, '0')}',
              style: theme.textTheme.headlineLarge,
            ).animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 16),
            Text(
              pomodoroState.isWorkSession ? 'Work' : 'Break',
              style: theme.textTheme.titleLarge,
            ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed:
                      pomodoroState.isRunning
                          ? () =>
                              ref
                                  .read(activePomodoroProvider.notifier)
                                  .pauseTimer()
                          : () => ref
                              .read(activePomodoroProvider.notifier)
                              .startTimer(taskId),
                  child: Text(pomodoroState.isRunning ? 'Pause' : 'Start'),
                ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed:
                      () =>
                          ref
                              .read(activePomodoroProvider.notifier)
                              .resetTimer(),
                  child: const Text('Reset'),
                ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
