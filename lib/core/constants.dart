class AppConstants {
  static const String appName = 'Pomodoro To-Do';
  static const double defaultPadding = 16.0;
  static const double borderRadius = 12.0;
  static const double cardElevation = 1.0;

  // Timer durations in seconds
  static const int workDuration = 25 * 60;
  static const int shortBreakDuration = 5 * 60;
  static const int longBreakDuration = 15 * 60;
  static const int pomodorosBeforeLongBreak = 4;

  // Animation durations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration fastAnimationDuration = Duration(milliseconds: 150);
}
