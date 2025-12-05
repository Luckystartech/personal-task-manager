// Add Task Button Component
import 'package:flutter/material.dart';
import 'package:personal_task_manager/features/task/presentation/screens/add_task_screen.dart';
import 'package:personal_task_manager/shared/utils/mixins/context.dart';

class AddTaskButton extends StatelessWidget {
  const AddTaskButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => const AddTaskScreen(),
          ),
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius:
            theme.radius.asBorderRadius().big +
            theme.radius.asBorderRadius().big,
      ),
      backgroundColor: theme.colors.primary,
      child: Icon(Icons.add, color: theme.colors.primaryOpposite, size: 28),
    );
  }
}
