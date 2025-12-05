import 'package:personal_task_manager/features/task/data/models/task_query.dart';
import 'package:personal_task_manager/features/task/domain/entities/result.dart';
import 'package:personal_task_manager/features/task/domain/entities/task.dart';

abstract class TaskRepositoryInterface {
  /// Initialize the repository
  Future<Result<void>> initialize();

  /// Create a new task
  Future<Result<void>> createTask(Task task);

  /// Update an existing task
  Future<Result<void>> updateTask(Task task);

  /// Delete a task
  Future<Result<void>> deleteTask(String taskId);

  /// Get a single task by ID
  Future<Result<Task>> getTaskById(String taskId);

  /// Clear all tasks
  Future<Result<void>> clearAllTasks();

  /// Toggle task completion status
  Future<Result<void>> toggleTaskCompletion(String taskId);

  /// Get stream with error handling wrapper
  Stream<Result<List<Task>>> get tasksStreamWithErrorHandling;

  /// update the current query (search/filter) in the data source.
  Future<void> updateQuery(TaskQuery query);

  /// get current query
  TaskQuery get currentQuery;

  /// Dispose resources
  Future<void> dispose();
}
