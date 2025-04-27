import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mad_lab_mini/data/models/pomodoro_session.dart';
import 'package:mad_lab_mini/data/services/firestore_service.dart';
import 'package:mad_lab_mini/data/services/notification_service.dart';
import 'auth_provider.dart';
import 'timer_settings_provider.dart';

final pomodoroServiceProvider = Provider<FirestoreService>((ref) {
  final userId = ref.watch(authStateProvider).value?.uid ?? '';
  return FirestoreService(userId: userId);
});

final pomodoroSessionsProvider =
    StreamProvider.family<List<PomodoroSession>, String>((ref, taskId) {
      final service = ref.watch(pomodoroServiceProvider);
      return service.watchSessions(taskId);
    });

final completedPomodorosProvider = StreamProvider.family<int, String>((
  ref,
  taskId,
) {
  final service = ref.watch(pomodoroServiceProvider);
  return service.watchCompletedPomodoros(taskId);
});

final activePomodoroProvider =
    StateNotifierProvider<PomodoroNotifier, PomodoroState>((ref) {
      return PomodoroNotifier(
        ref.watch(pomodoroServiceProvider),
        ref.watch(notificationServiceProvider),
        ref.watch(timerSettingsProvider),
      );
    });

class PomodoroNotifier extends StateNotifier<PomodoroState> {
  final FirestoreService _service;
  final NotificationService _notificationService;
  final TimerSettings _timerSettings;
  Timer? _timer;

  PomodoroNotifier(
    this._service,
    this._notificationService,
    this._timerSettings,
  ) : super(PomodoroState.initial(_timerSettings));

  void startTimer(String taskId) {
    if (state.isRunning) return;

    state = state.copyWith(
      isRunning: true,
      taskId: taskId,
      startTime: DateTime.now(),
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.timeLeft <= 0) {
        _completeSession();
        return;
      }
      state = state.copyWith(timeLeft: state.timeLeft - 1);
    });
  }

  void pauseTimer() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void resetTimer() {
    _timer?.cancel();
    state = PomodoroState.initial(_timerSettings);
  }

  Future<void> _completeSession() async {
    _timer?.cancel();

    final session = PomodoroSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      taskId: state.taskId!,
      startTime: state.startTime!,
      duration:
          state.isWorkSession
              ? _timerSettings.workDuration
              : _timerSettings.shortBreakDuration,
      isCompleted: true,
      isBreak: !state.isWorkSession,
    );

    try {
      await _service.addPomodoroSession(session);
      await _notificationService.showTimerCompleteNotification(
        !state.isWorkSession,
      );
      state = state.copyWith(
        isRunning: false,
        isWorkSession: !state.isWorkSession,
        timeLeft:
            state.isWorkSession
                ? _timerSettings.shortBreakDuration
                : _timerSettings.workDuration,
        startTime: null,
      );
    } catch (e) {
      state = state.copyWith(isRunning: false, error: e.toString());
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class PomodoroState {
  final bool isRunning;
  final bool isWorkSession;
  final int timeLeft;
  final String? taskId;
  final DateTime? startTime;
  final String? error;

  PomodoroState({
    required this.isRunning,
    required this.isWorkSession,
    required this.timeLeft,
    this.taskId,
    this.startTime,
    this.error,
  });

  factory PomodoroState.initial(TimerSettings settings) => PomodoroState(
    isRunning: false,
    isWorkSession: true,
    timeLeft: settings.workDuration,
  );

  PomodoroState copyWith({
    bool? isRunning,
    bool? isWorkSession,
    int? timeLeft,
    String? taskId,
    DateTime? startTime,
    String? error,
  }) {
    return PomodoroState(
      isRunning: isRunning ?? this.isRunning,
      isWorkSession: isWorkSession ?? this.isWorkSession,
      timeLeft: timeLeft ?? this.timeLeft,
      taskId: taskId ?? this.taskId,
      startTime: startTime ?? this.startTime,
      error: error ?? this.error,
    );
  }
}
