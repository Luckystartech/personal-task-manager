import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_task_manager/features/task/data/models/task_query.dart';
import 'package:personal_task_manager/features/task/domain/entities/result.dart';
import 'package:personal_task_manager/features/task/domain/entities/task.dart';
import 'package:personal_task_manager/features/task/domain/use_cases/task_use_case.dart';

/// State for task list with infinite scroll support
class TaskListState {
  final List<Task> tasks;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final bool hasFilter;
  final String? error;
  final int currentPage;

  const TaskListState({
    this.tasks = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.hasFilter = false,
    this.error,
    this.currentPage = 0,
  });

  TaskListState copyWith({
    List<Task>? tasks,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasFilter,
    bool? hasMore,
    String? error,
    int? currentPage,
  }) {
    return TaskListState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasFilter: hasFilter ?? this.hasFilter,
      hasMore: hasMore ?? this.hasMore,
      error: error,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

/// Notifier that handles task list operations with infinite scrolling
class TaskListNotifier extends Notifier<TaskListState> {
  static const int _pageSize = 20;
  Timer? _searchDebounce;
  late final TaskUseCases _useCases;
  StreamSubscription<Result<List<Task>>>? _streamSubscription;
  List<Task> _allFilteredTasks = []; // Cache of all filtered tasks from stream

  @override
  TaskListState build() {
    _useCases = ref.watch(taskUseCasesProvider);

    // Initialize and listen to stream
    // _initialize();
    Future.microtask(() => _initialize());

    // Cleanup on dispose
    ref.onDispose(() {
      _streamSubscription?.cancel();
    });

    return const TaskListState();
  }

  void _initialize() {
    state = state.copyWith(isLoading: true);

    // Listen to the tasks stream
    _streamSubscription = _useCases.getTasksStream.execute().listen(
      (result) {
        if (result.isSuccess) {
          _handleStreamUpdate(result.data!);
        } else {
          state = state.copyWith(
            error: result.error,
            isLoading: false,
            isLoadingMore: false,
          );
        }
      },
      onError: (error) {
        state = state.copyWith(
          error: error.toString(),
          isLoading: false,
          isLoadingMore: false,
        );
      },
    );
  }

  /// Handle stream updates and paginate from the cached list
  void _handleStreamUpdate(List<Task> allTasks) {
    _allFilteredTasks = allTasks;

    // Calculate how many items to show based on current page
    final itemsToShow = (state.currentPage + 1) * _pageSize;
    final paginatedTasks = _allFilteredTasks.take(itemsToShow).toList();

    state = state.copyWith(
      tasks: paginatedTasks,
      isLoading: false,
      isLoadingMore: false,
      hasMore: paginatedTasks.length < _allFilteredTasks.length,
      error: null,
    );
  }

  /// Load the next page (for infinite scrolling)
  void loadNextPage() {
    if (state.isLoadingMore || !state.hasMore || state.isLoading) return;

    state = state.copyWith(
      isLoadingMore: true,
      currentPage: state.currentPage + 1,
    );

    // Trigger re-pagination from cached data
    _handleStreamUpdate(_allFilteredTasks);
  }

  /// Refresh/reload the list (reset to first page)
  void refresh() {
    state = state.copyWith(currentPage: 0, isLoading: true);

    // Trigger re-pagination from cached data
    _handleStreamUpdate(_allFilteredTasks);
  }

  /// Toggle task completion status
  Future<void> toggleTaskCompletion(String taskId) async {
    // Optimistically update UI
    final optimisticTasks = state.tasks.map((task) {
      if (task.id == taskId) {
        return task.copyWith(isCompleted: !task.isCompleted);
      }
      return task;
    }).toList();

    state = state.copyWith(tasks: optimisticTasks);

    // Execute use case
    final result = await _useCases.toggleTaskCompletion.execute(taskId);

    if (!result.isSuccess) {
      // Revert on error - stream will emit correct state
      state = state.copyWith(error: result.error);
    }
    // Stream will automatically update with the correct state
  }

  /// Delete a task
  Future<void> deleteTask(String taskId) async {
    // Optimistically remove from UI
    final optimisticTasks = state.tasks
        .where((task) => task.id != taskId)
        .toList();
    state = state.copyWith(tasks: optimisticTasks);

    // Execute use case
    final result = await _useCases.deleteTask.execute(taskId);

    if (!result.isSuccess) {
      // Show error - stream will restore correct state
      state = state.copyWith(error: result.error);
    }
    // Stream will automatically update with the correct state
  }

  /// Clear all tasks
  Future<void> clearAllTasks() async {
    // Show loading
    state = state.copyWith(isLoading: true);

    // Execute use case
    final result = await _useCases.clearAllTasks.execute();

    if (result.isSuccess) {
      state = state.copyWith(
        tasks: [],
        isLoading: false,
        hasMore: false,
        currentPage: 0,
      );
    } else {
      state = state.copyWith(error: result.error, isLoading: false);
    }
    // Stream will automatically update with the correct state
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Undo delete by re-creating a task (for undo functionality)
  Future<Result<void>> undoDelete({
    required String title,
    required String description,
    required DateTime taskDate,
    required DateTime taskTime,
  }) async {
    return await _useCases.createTask.execute(
      title: title,
      description: description,
      taskDate: taskDate,
      taskTime: taskTime,
    );
  }

  /// Apply search with debounce
  void applySearch(String search) {
    _searchDebounce?.cancel();
    // Debounce interval 350ms
    _searchDebounce = Timer(const Duration(milliseconds: 350), () async {
      // Use use case to update query (this will cause the stream to emit)
      final currentQuery = _useCases.taskQuery.getQuery();
      late TaskQuery newQuery;
      if (search.isEmpty) {
        newQuery = TaskQuery.empty;
      } else {
        newQuery = currentQuery.copyWith(searchQuery: search);
      }
      await _useCases.taskQuery.updateQuery(newQuery);
      // reset pagination to first page to show top matching items
      state = state.copyWith(currentPage: 0, isLoading: true);

      _handleStreamUpdate(
        _allFilteredTasks,
      ); // _allFilteredTasks will be updated when stream emits
    });
  }

  /// Apply filter (pass a full TaskQuery)
  Future<void> applyFilter(TaskQuery query) async {
    // Apply immediately
    await _useCases.filterTasks.execute(query);
    // Reset pagination
    state = state.copyWith(hasFilter: true, currentPage: 0, isLoading: false);
    // stream emission will trigger _handleStreamUpdate
  }

  ///Clear Filter
  void clearFilter() {
    state = state.copyWith(hasFilter: false, currentPage: 0, isLoading: false);
    // applyFilter(TaskQuery.empty);
  }
}

/// Provider for TaskListNotifier
final taskListNotifierProvider =
    NotifierProvider.autoDispose<TaskListNotifier, TaskListState>(
      TaskListNotifier.new,
    );
