import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/models/task.dart';
import '../../data/services/firestore_service.dart';
import '../../data/services/notification_service.dart';
import 'auth_provider.dart';

final taskServiceProvider = Provider<FirestoreService>((ref) {
  final userId = ref.watch(authStateProvider).value?.uid ?? '';
  return FirestoreService(userId: userId);
});

final tasksProvider = StreamProvider<List<Task>>((ref) {
  final service = ref.watch(taskServiceProvider);
  return service.watchTasks();
});

final taskNotifierProvider =
    StateNotifierProvider<TaskNotifier, AsyncValue<void>>((ref) {
      final service = ref.watch(taskServiceProvider);
      final notificationService = NotificationService();
      return TaskNotifier(service, notificationService);
    });

class TaskNotifier extends StateNotifier<AsyncValue<void>> {
  final FirestoreService _service;
  final NotificationService _notificationService;

  TaskNotifier(this._service, this._notificationService)
    : super(const AsyncValue.data(null));

  Future<void> addTask(Task task) async {
    state = const AsyncValue.loading();
    try {
      await _service.addTask(task);
      if (task.dueDate != null) {
        await _notificationService.scheduleTaskReminder(task);
      }
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateTask(Task task) async {
    state = const AsyncValue.loading();
    try {
      await _service.updateTask(task);
      await _notificationService.cancelReminder(task.id);
      if (task.dueDate != null) {
        await _notificationService.scheduleTaskReminder(task);
      }
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteTask(String taskId) async {
    state = const AsyncValue.loading();
    try {
      await _service.deleteTask(taskId);
      await _notificationService.cancelReminder(taskId);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
