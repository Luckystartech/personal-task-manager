import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_task_manager/features/task/domain/use_cases/task_use_case.dart';

// TASK FORM NOTIFIER (Create & Update)

/// State for task form (create/update operations)
class TaskFormState {
  final bool isLoading;
  final bool isSuccess;
  final String? error;
  final String? successMessage;

  const TaskFormState({
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
    this.successMessage,
  });

  TaskFormState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? error,
    String? successMessage,
  }) {
    return TaskFormState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
      successMessage: successMessage,
    );
  }
}

/// Notifier that handles task creation and updates
class TaskFormNotifier extends Notifier<TaskFormState> {
  late final TaskUseCases _useCases;

  @override
  TaskFormState build() {
    _useCases = ref.watch(taskUseCasesProvider);
    return const TaskFormState();
  }

  /// Create a new task
  Future<void> createTask({
    required String title,
    required String description,
    required DateTime taskDate,
    required DateTime taskTime,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _useCases.createTask.execute(
      title: title,
      description: description,
      taskDate: taskDate,
      taskTime: taskTime,
    );

    if (result.isSuccess) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        successMessage: 'Task created successfully',
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        error: result.error,
      );
    }
  }

  /// Update an existing task
  Future<void> updateTask({
    required String id,
    required String title,
    required String description,
    required bool isCompleted,
    required DateTime taskDate,
    required DateTime taskTime,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _useCases.updateTask.execute(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted,
      taskDate: taskDate,
      taskTime: taskTime,
    );

    if (result.isSuccess) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        successMessage: 'Task updated successfully',
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        error: result.error,
      );
    }
  }

  /// Reset the form state (useful after navigation)
  void reset() {
    state = const TaskFormState();
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Clear success message
  void clearSuccess() {
    state = state.copyWith(isSuccess: false, successMessage: null);
  }
}

/// Provider for TaskFormNotifier
final taskFormNotifierProvider =
    NotifierProvider.autoDispose<TaskFormNotifier, TaskFormState>(
      TaskFormNotifier.new,
    );
