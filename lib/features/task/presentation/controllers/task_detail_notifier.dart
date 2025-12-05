import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_task_manager/features/task/domain/entities/task.dart';
import 'package:personal_task_manager/features/task/domain/use_cases/task_use_case.dart';

// TASK DETAIL NOTIFIER (Get Task by ID)

/// State for task detail view
class TaskDetailState {
  final Task? task;
  final bool isLoading;
  final String? error;

  const TaskDetailState({this.task, this.isLoading = false, this.error});

  TaskDetailState copyWith({Task? task, bool? isLoading, String? error}) {
    return TaskDetailState(
      task: task ?? this.task,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notifier that handles fetching a single task by ID
class TaskDetailNotifier extends Notifier<TaskDetailState> {
  late final TaskUseCases _useCases;
  String? _currentTaskId;

  @override
  TaskDetailState build() {
    _useCases = ref.watch(taskUseCasesProvider);
    return const TaskDetailState();
  }

  /// Load a task by ID
  Future<void> loadTask(String taskId) async {
    if (_currentTaskId == taskId && state.task != null) {
      // Already loaded this task
      return;
    }

    _currentTaskId = taskId;
    state = state.copyWith(isLoading: true, error: null);

    final result = await _useCases.getTaskById.execute(taskId);

    if (result.isSuccess) {
      state = TaskDetailState(task: result.data, isLoading: false, error: null);
    } else {
      state = TaskDetailState(
        task: null,
        isLoading: false,
        error: result.error,
      );
    }
  }

  /// Refresh the current task
  Future<void> refresh() async {
    if (_currentTaskId != null) {
      await loadTask(_currentTaskId!);
    }
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider for TaskDetailNotifier
final taskDetailNotifierProvider =
    NotifierProvider.autoDispose<TaskDetailNotifier, TaskDetailState>(
      TaskDetailNotifier.new,
    );
