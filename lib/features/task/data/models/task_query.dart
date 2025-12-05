// lib/features/task/data/models/task_query.dart
import 'package:flutter/foundation.dart';

@immutable
class TaskQuery {
  final String? searchQuery;
  final bool? isCompleted; // null = both
  final DateTime? filterDate; // single-day filter
  final DateTime? rangeStart;
  final DateTime? rangeEnd;
  final bool sortDescending; // true => newest first

  const TaskQuery({
    this.searchQuery,
    this.isCompleted,
    this.filterDate,
    this.rangeStart,
    this.rangeEnd,
    this.sortDescending = true,
  });

  TaskQuery copyWith({
    String? searchQuery,
    bool? isCompleted,
    DateTime? filterDate,
    DateTime? rangeStart,
    DateTime? rangeEnd,
    bool? sortDescending,
  }) {
    return TaskQuery(
      searchQuery: searchQuery ?? this.searchQuery,
      isCompleted: isCompleted ?? this.isCompleted,
      filterDate: filterDate ?? this.filterDate,
      rangeStart: rangeStart ?? this.rangeStart,
      rangeEnd: rangeEnd ?? this.rangeEnd,
      sortDescending: sortDescending ?? this.sortDescending,
    );
  }

  static const empty = TaskQuery();

  bool get hasAnyFilter {
    return (searchQuery?.isNotEmpty ?? false) ||
        isCompleted != null ||
        filterDate != null ||
        (rangeStart != null && rangeEnd != null) ||
        !sortDescending; // user changed sorting
  }
}

/*
/// Query options for task filtering
class TaskQuery {
  final bool? isCompleted;
  final DateTime? filterDate;
  final String? searchQuery;

  const TaskQuery({this.isCompleted, this.filterDate, this.searchQuery});

  TaskQuery copyWith({
    bool? isCompleted,
    DateTime? filterDate,
    String? searchQuery,
  }) {
    return TaskQuery(
      isCompleted: isCompleted ?? this.isCompleted,
      filterDate: filterDate ?? this.filterDate,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TaskQuery &&
        other.isCompleted == isCompleted &&
        other.filterDate == filterDate &&
        other.searchQuery == searchQuery;
  }

  @override
  int get hashCode {
    return isCompleted.hashCode ^ filterDate.hashCode ^ searchQuery.hashCode;
  }
}


 */
