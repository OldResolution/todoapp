import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mad_lab_mini/data/models/pomodoro_session.dart';
import 'package:mad_lab_mini/data/models/task.dart';

class FirestoreService {
  final FirebaseFirestore _firestore;
  final String userId;

  FirestoreService({required this.userId})
    : _firestore = FirebaseFirestore.instance;

  // Tasks Collection Reference
  CollectionReference<Map<String, dynamic>> get _tasksCollection =>
      _firestore.collection('users').doc(userId).collection('tasks');

  // Pomodoro Sessions Collection Reference
  CollectionReference<Map<String, dynamic>> get _sessionsCollection =>
      _firestore.collection('users').doc(userId).collection('sessions');

  // Task Operations
  Future<void> addTask(Task task) async {
    await _tasksCollection.doc(task.id).set(task.toMap());
  }

  Future<void> updateTask(Task task) async {
    await _tasksCollection.doc(task.id).update(task.toMap());
  }

  Future<void> deleteTask(String taskId) async {
    await _tasksCollection.doc(taskId).delete();
  }

  Stream<List<Task>> watchTasks() {
    return _tasksCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Task.fromMap(doc.data())).toList(),
        );
  }

  // Pomodoro Session Operations
  Future<void> addPomodoroSession(PomodoroSession session) async {
    await _sessionsCollection.doc(session.id).set(session.toMap());
  }

  Stream<List<PomodoroSession>> watchSessions(String taskId) {
    return _sessionsCollection
        .where('taskId', isEqualTo: taskId)
        .orderBy('startTime', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => PomodoroSession.fromMap(doc.data()))
                  .toList(),
        );
  }

  // Statistics
  Stream<int> watchCompletedPomodoros(String taskId) {
    return _sessionsCollection
        .where('taskId', isEqualTo: taskId)
        .where('isCompleted', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.size);
  }
}
