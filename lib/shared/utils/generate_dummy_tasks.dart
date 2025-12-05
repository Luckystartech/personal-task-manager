import 'package:personal_task_manager/features/task/data/models/task_model.dart';
import 'package:uuid/uuid.dart';

final uuid = Uuid();

List<TaskModel> generateDummyTasks() {
  final List<TaskModel> tasks = [];

  final titles = [
    "Buy groceries",
    "Finish project report",
    "Clean the house",
    "Prepare meeting slides",
    "Study Flutter Riverpod",
    "Workout session",
    "Plan the weekend trip",
    "Call the electrician",
    "Read a new book",
    "Backup project files",
  ];

  final descriptions = [
    "This task needs to be done before evening.",
    "High priority task.",
    "Remember to check progress.",
    "Can be postponed if necessary.",
    "Very important for this week.",
    null,
    null,
    null,
  ];

  final now = DateTime.now();

  for (int i = 0; i < 70; i++) {
    final randomTitle = titles[i % titles.length];
    final randomDescription = descriptions[i % descriptions.length];
    final randomCompleted = (i % 3 == 0); // every 3rd task completed

    final randomDate = now.subtract(Duration(days: i));
    final randomTime = DateTime(
      now.year,
      now.month,
      now.day,
      (8 + (i % 10)), // hours vary 8–17
      (i * 3) % 60,
    );

    tasks.add(
      TaskModel(
        id: uuid.v4(),
        title: "$randomTitle #${i + 1}",
        description: randomDescription,
        isCompleted: randomCompleted,
        taskDate: randomDate,
        taskTime: randomTime,
      ),
    );
  }

  return tasks;
}
