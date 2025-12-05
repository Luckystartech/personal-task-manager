import 'package:personal_task_manager/features/task/data/models/task_model.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime taskDate;
  final DateTime taskTime;

  factory Task.fromTaskModel(TaskModel taskModel) {
    return Task(
      id: taskModel.id,
      title: taskModel.title,
      description: taskModel.description ?? '',
      isCompleted: taskModel.isCompleted,
      taskDate: taskModel.taskDate,
      taskTime: taskModel.taskTime,
    );
  }

  TaskModel toTaskModel() {
    return TaskModel(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted,
      taskDate: taskDate,
      taskTime: taskTime,
    );
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? taskDate,
    DateTime? taskTime,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      taskDate: taskDate ?? this.taskDate,
      taskTime: taskTime ?? this.taskTime,
    );
  }

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.taskDate,
    required this.taskTime,
  });
}
