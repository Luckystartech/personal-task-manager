import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:personal_task_manager/features/task/data/models/task_data_source_exception.dart';
import 'package:personal_task_manager/features/task/data/models/task_model.dart';
import 'package:personal_task_manager/features/task/data/models/task_query.dart';

/// Simple data source for managing tasks using Hive storage
class TaskDataSource {
  TaskDataSource() {
    initialize();
  }

  static const String _boxName = 'tasks';
  Box<TaskModel>? _taskBox;

  final _tasksStreamController = StreamController<List<TaskModel>>.broadcast();

  TaskQuery _currentQuery = const TaskQuery();

  /// Stream that emits filtered tasks based on current query
  Stream<List<TaskModel>> get tasksStream => _tasksStreamController.stream;

  /// Get current query
  TaskQuery get currentQuery => _currentQuery;

  /// Initialize the data source and open the Hive box
  Future<void> initialize() async {
    try {
      await Hive.initFlutter();
      Hive.registerAdapter(TaskModelAdapter());
      if (_taskBox?.isOpen ?? false) return;

      _taskBox = await Hive.openBox<TaskModel>(_boxName);
      // generateTasks();
      _emitTasks();
    } catch (e) {
      throw TaskDataSourceException('Failed to initialize task data source', e);
    }
  }

  // void generateTasks() {
  //   final tasks = generateDummyTasks();
  //   for (final t in tasks) {
  //     createTask(t);
  //   }
  // }

  /// Update the query and emit filtered results
  void updateQuery(TaskQuery query) {
    _currentQuery = query;
    _emitTasks();
  }

  /// Get a paginated slice of tasks (for one-time fetches, not streaming)
  Future<List<TaskModel>> getTasks({
    required int limit,
    required int offset,
    TaskQuery? query,
  }) async {
    try {
      _ensureBoxIsOpen();

      final q = query ?? _currentQuery;
      var tasks = _applyQuery(_taskBox!.values.toList(), q);

      return tasks.skip(offset).take(limit).toList();
    } catch (e) {
      throw TaskDataSourceException('Failed to get tasks', e);
    }
  }

  /// Get total count of filtered tasks
  Future<int> getTaskCount({TaskQuery? query}) async {
    try {
      _ensureBoxIsOpen();

      final q = query ?? _currentQuery;
      var tasks = _applyQuery(_taskBox!.values.toList(), q);

      return tasks.length;
    } catch (e) {
      throw TaskDataSourceException('Failed to get task count', e);
    }
  }

  /// Create a new task
  Future<void> createTask(TaskModel task) async {
    try {
      _ensureBoxIsOpen();
      await _taskBox!.put(task.id, task);
      _emitTasks();
    } catch (e) {
      throw TaskDataSourceException('Failed to create task', e);
    }
  }

  /// Update an existing task
  Future<void> updateTask(TaskModel task) async {
    try {
      _ensureBoxIsOpen();

      if (!_taskBox!.containsKey(task.id)) {
        throw TaskDataSourceException('Task with id ${task.id} not found');
      }

      await _taskBox!.put(task.id, task);
      _emitTasks();
    } catch (e) {
      throw TaskDataSourceException('Failed to update task', e);
    }
  }

  /// Delete a task by ID
  Future<void> deleteTask(String taskId) async {
    try {
      _ensureBoxIsOpen();

      if (!_taskBox!.containsKey(taskId)) {
        throw TaskDataSourceException('Task with id $taskId not found');
      }

      await _taskBox!.delete(taskId);
      _emitTasks();
    } catch (e) {
      throw TaskDataSourceException('Failed to delete task', e);
    }
  }

  /// Get a single task by ID
  Future<TaskModel?> getTaskById(String taskId) async {
    try {
      _ensureBoxIsOpen();
      return _taskBox!.get(taskId);
    } catch (e) {
      throw TaskDataSourceException('Failed to get task', e);
    }
  }

  /// Clear all tasks
  Future<void> clearAllTasks() async {
    try {
      _ensureBoxIsOpen();
      await _taskBox!.clear();
      _emitTasks();
    } catch (e) {
      throw TaskDataSourceException('Failed to clear tasks', e);
    }
  }

  /// Apply filters, search, and sorting to a list of tasks
  List<TaskModel> _applyQuery(List<TaskModel> tasks, TaskQuery query) {
    // Apply search
    if (query.searchQuery != null && query.searchQuery!.isNotEmpty) {
      final lowerQuery = query.searchQuery!.toLowerCase();
      tasks = tasks.where((task) {
        return task.title.toLowerCase().contains(lowerQuery) ||
            (task.description?.toLowerCase().contains(lowerQuery) ?? false);
      }).toList();
    }

    // Apply completion filter
    if (query.isCompleted != null) {
      tasks = tasks
          .where((task) => task.isCompleted == query.isCompleted)
          .toList();
    }

    // Apply date filter
    if (query.filterDate != null) {
      tasks = tasks.where((task) {
        if (task.taskDate == null) return false;
        return task.taskDate.year == query.filterDate!.year &&
            task.taskDate.month == query.filterDate!.month &&
            task.taskDate.day == query.filterDate!.day;
      }).toList();
    }

    // Sort by date (newest first)
    tasks.sort((a, b) {
      final aDate = a.taskDate ?? DateTime(1970);
      final bDate = b.taskDate ?? DateTime(1970);
      return bDate.compareTo(aDate);
    });

    return tasks;
  }

  /// Emit all filtered tasks to the stream (no pagination here)
  void _emitTasks() {
    if (_taskBox != null && _taskBox!.isOpen) {
      final tasks = _applyQuery(_taskBox!.values.toList(), _currentQuery);
      _tasksStreamController.add(tasks);
    }
  }

  /// Ensure the Hive box is open
  void _ensureBoxIsOpen() {
    if (_taskBox == null || !_taskBox!.isOpen) {
      throw TaskDataSourceException(
        'Task box is not initialized or has been closed',
      );
    }
  }

  /// Dispose resources
  Future<void> dispose() async {
    await _tasksStreamController.close();
    await _taskBox?.close();
  }
}

final taskDataSourceProvider = Provider<TaskDataSource>((ref) {
  final taskDataSource = TaskDataSource();
  ref.onDispose(() {
    taskDataSource.dispose();
  });
  return taskDataSource;
});
