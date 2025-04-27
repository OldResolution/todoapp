import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mad_lab_mini/data/models/task.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  final service = NotificationService();
  service.initialize();
  return service;
});

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _notifications.initialize(settings, onSelectNotification: (_) {});
  }

  Future<void> showTimerCompleteNotification(bool isBreak) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'pomodoro_channel',
          'Pomodoro Timer',
          channelDescription: 'Timer notifications',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: false,
          autoCancel: true,
        );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _notifications.show(
      0,
      isBreak ? 'Break Time!' : 'Work Time Complete!',
      isBreak ? 'Take a short break' : 'Time to focus on your task',
      details,
    );
  }

  Future<void> scheduleTaskReminder(Task task) async {
    if (task.dueDate == null) return;

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'task_reminder_channel',
          'Task Reminders',
          channelDescription: 'Task reminder notifications',
          importance: Importance.high,
          priority: Priority.high,
        );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _notifications.schedule(
      task.id.hashCode,
      'Task Reminder: ${task.title}',
      task.description ?? 'This task is due soon!',
      task.dueDate!,
      details,
      androidAllowWhileIdle: true,
    );
  }

  Future<void> cancelReminder(String taskId) async {
    await _notifications.cancel(taskId.hashCode);
  }
}
