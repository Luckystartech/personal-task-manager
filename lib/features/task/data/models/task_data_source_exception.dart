/// Exception thrown when a task operation fails
class TaskDataSourceException implements Exception {
  final String message;
  final dynamic error;

  TaskDataSourceException(this.message, [this.error]);

  @override
  String toString() =>
      'TaskDataSourceException: $message${error != null ? ' - $error' : ''}';
}
