// Greeting Header Component
import 'package:flutter/material.dart';
import 'package:personal_task_manager/shared/utils/mixins/context.dart';
import 'package:personal_task_manager/shared/widgets/base.dart';

class AppTitleHeader extends StatelessWidget {
  const AppTitleHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return AppText.title3("Task Manager", color: theme.colors.foreground);
  }
}
