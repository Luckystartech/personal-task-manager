import 'package:hive_flutter/hive_flutter.dart';

part 'task_model.g.dart'; // This will be generated

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  String id; // Unique ID (e.g., UUID)

  @HiveField(1)
  String title;

  @HiveField(2)
  String? description;

  @HiveField(3)
  bool isCompleted = false;

  @HiveField(4)
  DateTime taskDate;

  @HiveField(5)
  DateTime taskTime;

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    required this.taskDate,
    required this.taskTime,
  });
}
