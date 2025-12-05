// UpdateTaskQueryUseCase
import 'package:personal_task_manager/features/task/data/models/task_query.dart';
import 'package:personal_task_manager/features/task/domain/repository/task_repository_interface.dart';

class TaskQueryUseCase {
  final TaskRepositoryInterface repository;
  TaskQueryUseCase(this.repository);

  Future<void> updateQuery(TaskQuery query) async {
    await repository.updateQuery(query);
  }

  TaskQuery getQuery() {
    return repository.currentQuery;
  }
}
