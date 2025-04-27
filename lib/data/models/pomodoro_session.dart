import 'package:equatable/equatable.dart';

class PomodoroSession extends Equatable {
  final String id;
  final String taskId;
  final DateTime startTime;
  final int duration; // in seconds
  final bool isCompleted;
  final bool isBreak;

  const PomodoroSession({
    required this.id,
    required this.taskId,
    required this.startTime,
    required this.duration,
    this.isCompleted = false,
    this.isBreak = false,
  });

  factory PomodoroSession.fromMap(Map<String, dynamic> map) => PomodoroSession(
    id: map['id'] as String,
    taskId: map['taskId'] as String,
    startTime: DateTime.parse(map['startTime'] as String),
    duration: map['duration'] as int,
    isCompleted: map['isCompleted'] as bool? ?? false,
    isBreak: map['isBreak'] as bool? ?? false,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'taskId': taskId,
    'startTime': startTime.toIso8601String(),
    'duration': duration,
    'isCompleted': isCompleted,
    'isBreak': isBreak,
  };

  @override
  List<Object?> get props => [
    id,
    taskId,
    startTime,
    duration,
    isCompleted,
    isBreak,
  ];
}
