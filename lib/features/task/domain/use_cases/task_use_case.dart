import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_task_manager/features/task/data/repository/task_repository.dart';
import 'package:personal_task_manager/features/task/domain/repository/task_repository_interface.dart';
import 'package:personal_task_manager/features/task/domain/use_cases/clear_all_task_use_case.dart';
import 'package:personal_task_manager/features/task/domain/use_cases/create_task_use_case.dart';
import 'package:personal_task_manager/features/task/domain/use_cases/delete_task_use_case.dart';
import 'package:personal_task_manager/features/task/domain/use_cases/dispose_task_repository_use_case.dart';
import 'package:personal_task_manager/features/task/domain/use_cases/filter_tasks_use_case.dart';
import 'package:personal_task_manager/features/task/domain/use_cases/get_task_by_id_use_case.dart';
import 'package:personal_task_manager/features/task/domain/use_cases/get_tasks_stream_use_case.dart';
import 'package:personal_task_manager/features/task/domain/use_cases/search_tasks_use_case.dart';
import 'package:personal_task_manager/features/task/domain/use_cases/toggle_task_completion_use_case.dart';
import 'package:personal_task_manager/features/task/domain/use_cases/update_task_query_use_case.dart';
import 'package:personal_task_manager/features/task/domain/use_cases/update_task_use_case.dart';

/// Aggregate use case class that contains all task-related use cases
/// This makes dependency injection easier
class TaskUseCases {
  final CreateTaskUseCase createTask;
  final UpdateTaskUseCase updateTask;
  final DeleteTaskUseCase deleteTask;
  final GetTaskByIdUseCase getTaskById;
  final ClearAllTasksUseCase clearAllTasks;
  final ToggleTaskCompletionUseCase toggleTaskCompletion;
  final GetTasksStreamUseCase getTasksStream;
  final TaskQueryUseCase taskQuery;
  final SearchTasksUseCase searchTasks;
  final FilterTasksUseCase filterTasks;
  final DisposeTaskRepositoryUseCase dispose;

  TaskUseCases(TaskRepositoryInterface repository)
    : createTask = CreateTaskUseCase(repository),
      updateTask = UpdateTaskUseCase(repository),
      deleteTask = DeleteTaskUseCase(repository),
      getTaskById = GetTaskByIdUseCase(repository),
      clearAllTasks = ClearAllTasksUseCase(repository),
      toggleTaskCompletion = ToggleTaskCompletionUseCase(repository),
      getTasksStream = GetTasksStreamUseCase(repository),
      taskQuery = TaskQueryUseCase(repository),
      searchTasks = SearchTasksUseCase(repository),
      filterTasks = FilterTasksUseCase(repository),
      dispose = DisposeTaskRepositoryUseCase(repository);
}

final taskUseCasesProvider = Provider<TaskUseCases>((ref) {
  final taskRepo = ref.watch(taskRepositoryProvider);
  ref.onDispose(() {
    taskRepo.dispose();
  });
  return TaskUseCases(taskRepo);
});
