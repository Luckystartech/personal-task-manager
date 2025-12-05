import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_task_manager/features/task/domain/entities/task.dart';
import 'package:personal_task_manager/features/task/presentation/controllers/task_list_notifier.dart';
import 'package:personal_task_manager/features/task/presentation/screens/add_task_screen.dart';
import 'package:personal_task_manager/features/task/presentation/widgets/task_item.dart';
import 'package:personal_task_manager/shared/utils/mixins/context.dart';
import 'package:personal_task_manager/shared/utils/ui_helper.dart';
import 'package:personal_task_manager/shared/widgets/base.dart';

class TodayTasksSection extends ConsumerStatefulWidget {
  const TodayTasksSection({super.key});

  @override
  ConsumerState<TodayTasksSection> createState() => _TodayTasksSectionState();
}

class _TodayTasksSectionState extends ConsumerState<TodayTasksSection> {
  final Map<String, Task> _deletedTasks = {};

  void _handleDelete(Task task) {
    _deletedTasks[task.id] = task;
    ref.read(taskListNotifierProvider.notifier).deleteTask(task.id);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          behavior: SnackBarBehavior.floating,
          content: Text('Task "${task.title}" deleted'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () => _handleUndo(task),
          ),
          duration: const Duration(seconds: 4),
          onVisible: () {
            Future.delayed(const Duration(seconds: 5), () {
              _deletedTasks.remove(task.id);
            });
          },
        ),
      );
    }
  }

  Future<void> _handleUndo(Task task) async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final result = await ref
        .read(taskListNotifierProvider.notifier)
        .undoDelete(
          title: task.title,
          taskDate: task.taskDate,
          taskTime: task.taskTime,
          description: task.description,
        );

    if (result.isSuccess) {
      _deletedTasks.remove(task.id);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Failed to undo: ${result.error}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handleToggle(Task task) {
    ref.read(taskListNotifierProvider.notifier).toggleTaskCompletion(task.id);
  }

  void _handleEdit(Task task) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => AddTaskScreen(taskToEdit: task),
      ),
    );

    if (result == true) {
      ref.read(taskListNotifierProvider.notifier).refresh();
    }
  }

  Future<bool?> _confirmDeleteAll(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: const AppText.title3('Delete All Task?'),
        content: AppText.paragraph2(
          'Are you sure you want to delete all task? this action cannot be undone',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const AppText.paragraph2('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(taskListNotifierProvider.notifier).clearAllTasks();
              Navigator.of(context).pop(false);
            },
            child: const AppText.paragraph2('Delete', color: Colors.red),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final state = ref.watch(taskListNotifierProvider);

    ref.listen<TaskListState>(taskListNotifierProvider, (previous, next) {
      if (next.error != null && mounted) {
        UiHelper.showSnackBar(
          next.error!,
          context: context,
          action: () {
            ref.read(taskListNotifierProvider.notifier).clearError();
          },
          bgColor: Colors.red,
        );
        Future.delayed(const Duration(milliseconds: 100), () {
          ref.read(taskListNotifierProvider.notifier).clearError();
        });
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.tasks.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "YOUR TASKS",
                style: theme.typography.paragraph2.copyWith(
                  color: theme.colors.foreground.withAlpha(60),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),

              TextButton(
                onPressed: () => _confirmDeleteAll(context),
                child: Row(
                  children: [
                    AppText.paragraph2(
                      'Clear All',
                      // color: theme.colors.foreground.withAlpha(60),
                    ),
                    AppGap.semiSmall(),
                    Icon(Icons.clear_all_rounded),
                  ],
                ),
              ),
            ],
          ),
          AppGap.semiBig(),
        ],

        if (state.isLoading)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: CircularProgressIndicator(color: theme.colors.primary),
            ),
          ),

        if (state.error != null && state.tasks.isEmpty)
          Center(
            child: Padding(
              padding: const AppEdgeInsets.all(
                AppGapSize.big,
              ).toEdgeInsets(theme),
              child: Column(
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: theme.colors.foreground.withAlpha(50),
                  ),
                  AppGap.regular(),
                  Text(
                    state.error!,
                    textAlign: TextAlign.center,
                    style: theme.typography.paragraph1.copyWith(
                      color: theme.colors.foreground.withAlpha(70),
                    ),
                  ),
                  AppGap.regular(),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(taskListNotifierProvider.notifier).refresh();
                    },
                    child: const AppText.paragraph2('Retry'),
                  ),
                ],
              ),
            ),
          ),

        if (!state.isLoading && state.tasks.isEmpty && state.error == null)
          Center(
            child: AppPadding(
              padding: const AppEdgeInsets.all(AppGapSize.regular),
              child: Column(
                children: [
                  Icon(
                    Icons.task_alt,
                    size: 64,
                    color: theme.colors.foreground.withAlpha(30),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No tasks yet',
                    style: theme.typography.title2.copyWith(
                      color: theme.colors.foreground.withAlpha(70),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to add your first task',
                    style: theme.typography.paragraph1.copyWith(
                      color: theme.colors.foreground.withAlpha(50),
                    ),
                  ),
                ],
              ),
            ),
          ),

        if (state.tasks.isNotEmpty)
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.tasks.length + (state.hasMore ? 1 : 0),
            separatorBuilder: (context, index) => AppGap.regular(),
            itemBuilder: (context, index) {
              if (index == state.tasks.length) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: state.isLoadingMore
                        ? CircularProgressIndicator(color: theme.colors.primary)
                        : const SizedBox.shrink(),
                  ),
                );
              }

              final task = state.tasks[index];
              return TaskItem(
                key: ValueKey(task.id),
                task: task,
                onToggle: () => _handleToggle(task),
                onDelete: () => _handleDelete(task),
                onEdit: () => _handleEdit(task),
              );
            },
          ),
      ],
    );
  }
}
