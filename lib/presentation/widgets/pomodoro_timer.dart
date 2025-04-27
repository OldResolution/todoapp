import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async';
import '../widgets/common_widgets.dart';

class PomodoroTimer extends StatefulWidget {
  const PomodoroTimer({super.key});

  @override
  State<PomodoroTimer> createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends State<PomodoroTimer>
    with SingleTickerProviderStateMixin {
  static const int workDuration = 25 * 60;
  static const int breakDuration = 5 * 60;
  static const int longBreakDuration = 15 * 60;
  static const int pomodorosBeforeLongBreak = 4;

  int timeLeft = workDuration;
  bool isWorking = true;
  bool isRunning = false;
  int completedPomodoros = 0;
  Timer? timer;
  late AnimationController _animationController;
  double _progress = 1.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void startTimer() {
    HapticFeedback.lightImpact();
    setState(() => isRunning = true);
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
          _progress = timeLeft / (isWorking ? workDuration : breakDuration);
        } else {
          timer.cancel();
          _animationController.forward(from: 0);
          HapticFeedback.heavyImpact();
          if (isWorking) {
            completedPomodoros++;
            timeLeft =
                completedPomodoros % pomodorosBeforeLongBreak == 0
                    ? longBreakDuration
                    : breakDuration;
          } else {
            timeLeft = workDuration;
          }
          isWorking = !isWorking;
          startTimer();
        }
      });
    });
  }

  void pauseTimer() {
    HapticFeedback.lightImpact();
    setState(() => isRunning = false);
    timer?.cancel();
  }

  void resetTimer() {
    HapticFeedback.mediumImpact();
    setState(() {
      isRunning = false;
      isWorking = true;
      timeLeft = workDuration;
      _progress = 1.0;
      completedPomodoros = 0;
    });
    timer?.cancel();
    _animationController.reset();
  }

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  Color getTimerColor(BuildContext context) {
    final theme = Theme.of(context);
    return isWorking ? theme.colorScheme.error : theme.colorScheme.secondary;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timerColor = getTimerColor(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return SizedBox(
                  width: 220,
                  height: 220,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: _progress,
                        strokeWidth: 12,
                        backgroundColor: timerColor.withOpacity(0.2),
                        color: timerColor,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            isWorking ? 'Focus' : 'Break',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: timerColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            formatTime(timeLeft),
                            style: theme.textTheme.displaySmall?.copyWith(
                              color: timerColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ).animate().fadeIn(duration: 600.ms).scale(),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonWidgets.buildIconButton(
                  onPressed: isRunning ? pauseTimer : startTimer,
                  icon: isRunning ? Icons.pause : Icons.play_arrow,
                  backgroundColor: timerColor,
                  iconColor: theme.colorScheme.onPrimary,
                  size: 56,
                ).animate().fadeIn(duration: 600.ms, delay: 100.ms).scale(),
                const SizedBox(width: 16),
                CommonWidgets.buildIconButton(
                  onPressed: resetTimer,
                  icon: Icons.replay,
                  backgroundColor: theme.colorScheme.surface,
                  iconColor: theme.colorScheme.onSurface,
                  size: 56,
                ).animate().fadeIn(duration: 600.ms, delay: 200.ms).scale(),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Pomodoros: $completedPomodoros',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onBackground.withOpacity(0.7),
              ),
            ).animate().fadeIn(duration: 600.ms, delay: 300.ms),
          ],
        ),
      ),
    );
  }
}
