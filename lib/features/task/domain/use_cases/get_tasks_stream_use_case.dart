import 'package:personal_task_manager/features/task/domain/entities/result.dart';
import 'package:personal_task_manager/features/task/domain/entities/task.dart';
import 'package:personal_task_manager/features/task/domain/repository/task_repository_interface.dart';

/// Use case for getting tasks stream
class GetTasksStreamUseCase {
  final TaskRepositoryInterface repository;

  GetTasksStreamUseCase(this.repository);

  Stream<Result<List<Task>>> execute() {
    return repository.tasksStreamWithErrorHandling;
  }
}
