import 'package:personal_task_manager/features/task/domain/entities/result.dart';
import 'package:personal_task_manager/features/task/domain/repository/task_repository_interface.dart';

/// Use case for clearing all tasks
class ClearAllTasksUseCase {
  final TaskRepositoryInterface repository;

  ClearAllTasksUseCase(this.repository);

  Future<Result<void>> execute() async {
    // You might want to add confirmation logic here
    // or handle this in the UI layer
    return await repository.clearAllTasks();
  }
}
