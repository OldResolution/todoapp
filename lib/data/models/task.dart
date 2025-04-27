import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String id;
  final String title;
  final String? description;
  final DateTime createdAt;
  final DateTime? dueDate;
  final bool isImportant;
  final bool isCompleted;

  const Task({
    required this.id,
    required this.title,
    this.description,
    required this.createdAt,
    this.dueDate,
    this.isImportant = false,
    this.isCompleted = false,
  });

  factory Task.fromMap(Map<String, dynamic> map) => Task(
    id: map['id'] as String,
    title: map['title'] as String,
    description: map['description'] as String?,
    createdAt: DateTime.parse(map['createdAt'] as String),
    dueDate:
        map['dueDate'] != null
            ? DateTime.parse(map['dueDate'] as String)
            : null,
    isImportant: map['isImportant'] as bool? ?? false,
    isCompleted: map['isCompleted'] as bool? ?? false,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'createdAt': createdAt.toIso8601String(),
    'dueDate': dueDate?.toIso8601String(),
    'isImportant': isImportant,
    'isCompleted': isCompleted,
  };

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    createdAt,
    dueDate,
    isImportant,
    isCompleted,
  ];
}
