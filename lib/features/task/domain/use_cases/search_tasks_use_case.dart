// SearchTasksUseCase - builds a TaskQuery with the search query and preserves other filters.
import 'package:personal_task_manager/features/task/domain/repository/task_repository_interface.dart';

class SearchTasksUseCase {
  final TaskRepositoryInterface repository;
  SearchTasksUseCase(this.repository);

  Future<void> execute(String search) async {
    final current = repository.currentQuery;
    final newQuery = current.copyWith(
      searchQuery: search.isEmpty ? null : search,
    );
    await repository.updateQuery(newQuery);
  }
}
