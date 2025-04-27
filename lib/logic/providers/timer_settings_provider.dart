import 'package:hooks_riverpod/hooks_riverpod.dart';

class TimerSettings {
  final int workDuration; // in seconds
  final int shortBreakDuration;
  final int longBreakDuration;

  TimerSettings({
    required this.workDuration,
    required this.shortBreakDuration,
    required this.longBreakDuration,
  });
}

final timerSettingsProvider = StateProvider<TimerSettings>((ref) {
  return TimerSettings(
    workDuration: 25 * 60, // 25 minutes
    shortBreakDuration: 5 * 60, // 5 minutes
    longBreakDuration: 15 * 60, // 15 minutes
  );
});
