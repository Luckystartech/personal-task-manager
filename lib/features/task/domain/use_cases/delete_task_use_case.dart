import 'package:personal_task_manager/features/task/domain/entities/result.dart';
import 'package:personal_task_manager/features/task/domain/repository/task_repository_interface.dart';

/// Use case for deleting a task
class DeleteTaskUseCase {
  final TaskRepositoryInterface repository;

  DeleteTaskUseCase(this.repository);

  Future<Result<void>> execute(String taskId) async {
    if (taskId.trim().isEmpty) {
      return Result.failure('Task ID cannot be empty');
    }

    // Verify task exists before deleting
    final existingTaskResult = await repository.getTaskById(taskId);
    if (!existingTaskResult.isSuccess) {
      return Result.failure('Task not found');
    }

    return await repository.deleteTask(taskId);
  }
}
