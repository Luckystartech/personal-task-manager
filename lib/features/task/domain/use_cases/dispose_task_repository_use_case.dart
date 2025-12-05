import 'package:personal_task_manager/features/task/domain/repository/task_repository_interface.dart';

/// Use case for disposing repository resources
class DisposeTaskRepositoryUseCase {
  final TaskRepositoryInterface repository;

  DisposeTaskRepositoryUseCase(this.repository);

  Future<void> execute() async {
    await repository.dispose();
  }
}
