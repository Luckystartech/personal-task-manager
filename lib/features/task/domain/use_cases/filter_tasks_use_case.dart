// FilterTasksUseCase - accepts a TaskQuery and applies it
import 'package:personal_task_manager/features/task/data/models/task_query.dart';
import 'package:personal_task_manager/features/task/domain/repository/task_repository_interface.dart';

class FilterTasksUseCase {
  final TaskRepositoryInterface repository;
  FilterTasksUseCase(this.repository);

  Future<void> execute(TaskQuery query) async {
    await repository.updateQuery(query);
  }
}
