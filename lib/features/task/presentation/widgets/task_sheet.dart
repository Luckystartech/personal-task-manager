import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:personal_task_manager/features/task/presentation/controllers/task_detail_notifier.dart';
import 'package:personal_task_manager/features/task/presentation/controllers/task_list_notifier.dart';
import 'package:personal_task_manager/features/task/presentation/screens/add_task_screen.dart';
import 'package:personal_task_manager/shared/utils/mixins/context.dart';
import 'package:personal_task_manager/shared/widgets/gap.dart';
import 'package:personal_task_manager/shared/widgets/padding.dart';
import 'package:personal_task_manager/shared/widgets/text.dart';

class TaskSheet extends ConsumerStatefulWidget {
  const TaskSheet({super.key, required this.taskId});

  final String taskId;

  @override
  ConsumerState<TaskSheet> createState() => _TaskSheetState();
}

class _TaskSheetState extends ConsumerState<TaskSheet> {
  @override
  void initState() {
    super.initState();
    // Load task when sheet opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(taskDetailNotifierProvider.notifier).loadTask(widget.taskId);
    });
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String _formatTime(DateTime date) {
    return DateFormat('h:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final state = ref.watch(taskDetailNotifierProvider);

    return Container(
      decoration: BoxDecoration(
        color: theme.colors.actionBarBackground,
        borderRadius: BorderRadius.vertical(top: theme.radius.big),
      ),
      child: AppPadding(
        padding: const AppEdgeInsets.only(
          left: AppGapSize.semiBig,
          right: AppGapSize.semiBig,
          top: AppGapSize.semiBig,
          bottom: AppGapSize.big,
        ),
        child: _buildContent(context, theme, state),
      ),
    );
  }

  Widget _buildContent(BuildContext context, theme, TaskDetailState state) {
    if (state.isLoading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: CircularProgressIndicator(color: theme.colors.primary),
        ),
      );
    }

    if (state.error != null) {
      return Center(
        child: AppPadding.regular(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: theme.colors.foreground.withAlpha(150),
              ),
              const AppGap.regular(),
              AppText.paragraph1(state.error!, color: theme.colors.foreground),
              const AppGap.regular(),
              TextButton(
                onPressed: () {
                  ref.read(taskDetailNotifierProvider.notifier).refresh();
                },
                child: AppText.paragraph2('Retry', color: theme.colors.primary),
              ),
            ],
          ),
        ),
      );
    }

    final task = state.task;
    if (task == null) {
      return Center(
        child: AppPadding.regular(
          child: AppText.paragraph1(
            'Task not found',
            color: theme.colors.foreground,
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown, // Shrinks text if too wide
                alignment: Alignment.centerLeft,
                child: AppText.title1(
                  task.title,
                  color: theme.colors.foreground,
                  maxLines: 2,
                ),
              ),
            ),
            //Edit Icon
            IconButton(
              onPressed: () => _onEdit(task),
              icon: Icon(Icons.edit, size: 20, color: theme.colors.foreground),
            ),
          ],
        ),

        // Status
        Row(
          children: [
            AppText.paragraph2(
              'Status: ${task.isCompleted ? 'Completed' : 'Incomplete'}',

              color: task.isCompleted
                  ? Colors.green
                  : theme.colors.foreground.withAlpha(200),
            ),
          ],
        ),
        const AppGap.semiBig(),

        // Date
        Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: theme.colors.foreground.withAlpha(200),
            ),
            const AppGap.small(),
            AppText.paragraph2(
              'Task Date: ${_formatDate(task.taskDate)}',
              color: theme.colors.foreground.withAlpha(200),
            ),
          ],
        ),
        const AppGap.small(),

        // Time
        Row(
          children: [
            Icon(
              Icons.access_time,
              size: 16,
              color: theme.colors.foreground.withAlpha(200),
            ),
            const AppGap.small(),
            AppText.paragraph2(
              'Task Time: ${_formatTime(task.taskTime)}',
              color: theme.colors.foreground.withAlpha(200),
            ),
          ],
        ),
        const AppGap.semiBig(),

        // Details heading
        AppText.title2('Details', color: theme.colors.foreground),
        const AppGap.semiSmall(),

        // Description
        if (task.description.isNotEmpty)
          AppText.paragraph1(
            task.description,
            color: theme.colors.foreground.withAlpha(230),
          ),
        if (task.description.isEmpty)
          AppText.paragraph1(
            'No description provided',
            color: theme.colors.foreground.withAlpha(150),
          ),
      ],
    );
  }

  void _onEdit(task) async {
    if (task == null) return;
    // Navigator.pop(context); // Close sheet first
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => AddTaskScreen(taskToEdit: task),
      ),
    );

    // Refresh list if task was updated
    if (result == true) {
      if (context.mounted) {
        Navigator.pop(context);
        ref.read(taskListNotifierProvider.notifier).refresh();
      }
    }
  }
}
