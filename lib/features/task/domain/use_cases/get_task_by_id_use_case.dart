import 'package:personal_task_manager/features/task/domain/entities/result.dart';
import 'package:personal_task_manager/features/task/domain/entities/task.dart';
import 'package:personal_task_manager/features/task/domain/repository/task_repository_interface.dart';

/// Use case for getting a task by ID
class GetTaskByIdUseCase {
  final TaskRepositoryInterface repository;

  GetTaskByIdUseCase(this.repository);

  Future<Result<Task>> execute(String taskId) async {
    if (taskId.trim().isEmpty) {
      return Result.failure('Task ID cannot be empty');
    }

    return await repository.getTaskById(taskId);
  }
}
