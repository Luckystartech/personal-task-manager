import 'package:flutter/material.dart';
import 'package:personal_task_manager/features/task/domain/entities/task.dart';
import 'package:personal_task_manager/features/task/presentation/widgets/task_sheet.dart';
import 'package:personal_task_manager/shared/utils/mixins/context.dart';
import 'package:personal_task_manager/shared/widgets/gap.dart';
import 'package:personal_task_manager/shared/widgets/padding.dart';
import 'package:personal_task_manager/shared/widgets/text.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const TaskItem({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  Future<bool?> _confirmDismiss(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: const AppText.title3('Delete Task?'),
        content: AppText.paragraph2(
          'Are you sure you want to delete "${task.title}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const AppText.paragraph2('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const AppText.paragraph2('Delete', color: Colors.red),
          ),
        ],
      ),
    );
  }

  Color _getTaskColor() {
    // You can customize this based on task category or other properties
    return task.isCompleted ? const Color(0xFF2196F3) : const Color(0xFFE91E63);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Dismissible(
      key: ValueKey(task.id),
      confirmDismiss: (direction) => _confirmDismiss(context),
      onDismissed: (direction) => onDelete(),
      background: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: theme.colors.primary,
          borderRadius: theme.radius.asBorderRadius().big,
        ),
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Container(
        padding: const AppEdgeInsets.symmetric(
          horizontal: AppGapSize.semiBig,
          vertical: AppGapSize.regular,
        ).toEdgeInsets(theme),
        decoration: BoxDecoration(
          color: theme.colors.actionBarBackground,
          borderRadius: theme.radius.asBorderRadius().big,
          boxShadow: [
            BoxShadow(
              color: theme.colors.primary.withAlpha(10),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: onToggle,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: task.isCompleted
                      ? _getTaskColor()
                      : Colors.transparent,
                  border: Border.all(color: _getTaskColor(), width: 2.5),
                ),
                child: task.isCompleted
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
            ),
            SizedBox(width: AppGapSize.semiBig.getSpacing(theme)),
            Expanded(
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: theme.colors.background,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    builder: (_) => TaskSheet(taskId: task.id),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: theme.typography.paragraph2.copyWith(
                        color: theme.colors.foreground,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        decorationThickness: 2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (task.description.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          task.description,
                          style: theme.typography.paragraph1.copyWith(
                            color: theme.colors.foreground.withAlpha(80),
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: onEdit,
              icon: Icon(Icons.edit, size: 20, color: theme.colors.foreground),
            ),
          ],
        ),
      ),
    );
  }
}
