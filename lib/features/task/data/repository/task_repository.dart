// Repository for managing task operations with error handling
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_task_manager/features/task/data/data_sources/task_data_source.dart';
import 'package:personal_task_manager/features/task/data/models/task_data_source_exception.dart';
import 'package:personal_task_manager/features/task/data/models/task_model.dart';
import 'package:personal_task_manager/features/task/data/models/task_query.dart';
import 'package:personal_task_manager/features/task/domain/entities/result.dart';
import 'package:personal_task_manager/features/task/domain/entities/task.dart';
import 'package:personal_task_manager/features/task/domain/repository/task_repository_interface.dart';

class TaskRepository implements TaskRepositoryInterface {
  final TaskDataSource _dataSource;

  TaskRepository(this._dataSource);

  /// Initialize the repository
  @override
  Future<Result<void>> initialize() async {
    try {
      await _dataSource.initialize();
      return Result.success(null);
    } on TaskDataSourceException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Unexpected error during initialization: $e');
    }
  }

  /// Create a new task
  @override
  Future<Result<void>> createTask(Task task) async {
    try {
      await _dataSource.createTask(task.toTaskModel());
      return Result.success(null);
    } on TaskDataSourceException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Failed to create task: $e');
    }
  }

  /// Update an existing task
  @override
  Future<Result<void>> updateTask(Task task) async {
    try {
      await _dataSource.updateTask(task.toTaskModel());
      return Result.success(null);
    } on TaskDataSourceException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Failed to update task: $e');
    }
  }

  /// Delete a task
  @override
  Future<Result<void>> deleteTask(String taskId) async {
    try {
      await _dataSource.deleteTask(taskId);
      return Result.success(null);
    } on TaskDataSourceException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Failed to delete task: $e');
    }
  }

  /// Get a single task by ID
  @override
  Future<Result<Task>> getTaskById(String taskId) async {
    try {
      final taskModel = await _dataSource.getTaskById(taskId);
      if (taskModel != null) {
        return Result.success(Task.fromTaskModel(taskModel));
      }
      return Result.failure('Task Not Found');
    } on TaskDataSourceException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Failed to get task: $e');
    }
  }

  /// Clear all tasks
  @override
  Future<Result<void>> clearAllTasks() async {
    try {
      await _dataSource.clearAllTasks();
      return Result.success(null);
    } on TaskDataSourceException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Failed to clear tasks: $e');
    }
  }

  /// Toggle task completion status
  @override
  Future<Result<void>> toggleTaskCompletion(String taskId) async {
    try {
      final task = await _dataSource.getTaskById(taskId);

      if (task == null) {
        return Result.failure('Task not found');
      }

      task.isCompleted = !task.isCompleted;
      await _dataSource.updateTask(task);

      return Result.success(null);
    } on TaskDataSourceException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Failed to toggle task completion: $e');
    }
  }

  /// Get stream with error handling wrapper
  @override
  Stream<Result<List<Task>>> get tasksStreamWithErrorHandling {
    return _dataSource.tasksStream
        .map((taskModels) {
          final tasks = taskModels.map((t) => Task.fromTaskModel(t)).toList();
          return Result.success(tasks);
        })
        .handleError((error) {
          return Result<List<TaskModel>>.failure(
            error is TaskDataSourceException ? error.message : error.toString(),
          );
        });
  }

  // query methods that delegate to the data source ---
  @override
  Future<void> updateQuery(TaskQuery query) async {
    // Update DS query and emit
    _dataSource.updateQuery(query);
  }

  @override
  TaskQuery get currentQuery => _dataSource.currentQuery;

  /// Dispose resources
  @override
  Future<void> dispose() async {
    await _dataSource.dispose();
  }
}

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final taskDs = ref.read(taskDataSourceProvider);
  final taskRepo = TaskRepository(taskDs);
  ref.onDispose(() {
    taskRepo.dispose();
  });
  return taskRepo;
});
