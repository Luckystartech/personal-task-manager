import 'package:personal_task_manager/features/task/domain/entities/result.dart';
import 'package:personal_task_manager/features/task/domain/entities/task.dart';
import 'package:personal_task_manager/features/task/domain/repository/task_repository_interface.dart';

/// Use case for updating an existing task
class UpdateTaskUseCase {
  final TaskRepositoryInterface repository;

  UpdateTaskUseCase(this.repository);

  Future<Result<void>> execute({
    required String id,
    required String title,
    required String description,
    required bool isCompleted,
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

    // Verify task exists
    final existingTaskResult = await repository.getTaskById(id);
    if (!existingTaskResult.isSuccess) {
      return Result.failure('Task not found');
    }

    // Update task
    final task = Task(
      id: id,
      title: title.trim(),
      description: description.trim(),
      isCompleted: isCompleted,
      taskDate: taskDate,
      taskTime: taskTime,
    );

    return await repository.updateTask(task);
  }
}
