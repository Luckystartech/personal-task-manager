import 'package:personal_task_manager/features/task/domain/entities/result.dart';
import 'package:personal_task_manager/features/task/domain/entities/task.dart';
import 'package:personal_task_manager/features/task/domain/repository/task_repository_interface.dart';
import 'package:uuid/uuid.dart';

/// Use case for creating a new task
class CreateTaskUseCase {
  final TaskRepositoryInterface repository;

  CreateTaskUseCase(this.repository);

  Future<Result<void>> execute({
    required String title,
    required String description,
    required DateTime taskDate,
    required DateTime taskTime,
  }) async {
    // Business logic validation
    if (title.trim().isEmpty) {
      return Result.failure('Task title cannot be empty');
    }

    if (title.length > 100) {
      return Result.failure('Task title is too long (max 100 characters)');
    }

    // Validate date is not in the past (optional business rule)
    final now = DateTime.now();
    final taskDateTime = DateTime(
      taskDate.year,
      taskDate.month,
      taskDate.day,
      taskTime.hour,
      taskTime.minute,
    );

    if (taskDateTime.isBefore(now)) {
      return Result.failure('Task date and time cannot be in the past');
    }

    // Create task with generated UUID
    final task = Task(
      id: const Uuid().v4(),
      title: title.trim(),
      description: description.trim(),
      isCompleted: false,
      taskDate: taskDate,
      taskTime: taskTime,
    );

    return await repository.createTask(task);
  }
}
