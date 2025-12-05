import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:personal_task_manager/core/theme/app_theme.dart';
import 'package:personal_task_manager/shared/utils/mixins/context.dart';

enum AppGapSize { none, small, semiSmall, regular, semiBig, big }

extension AppGapSizeExtension on AppGapSize {
  double getSpacing(AppThemeData theme) {
    switch (this) {
      case AppGapSize.none:
        return 0;
      case AppGapSize.small:
        return theme.spacing.regular;
      case AppGapSize.semiSmall:
        return theme.spacing.semiSmall;
      case AppGapSize.regular:
        return theme.spacing.regular;
      case AppGapSize.semiBig:
        return theme.spacing.semiBig;
      case AppGapSize.big:
        return theme.spacing.big;
    }
  }
}

class AppGap extends StatelessWidget {
  const AppGap(this.size, {super.key});

  const AppGap.small({super.key}) : size = AppGapSize.small;

  const AppGap.semiSmall({super.key}) : size = AppGapSize.semiSmall;

  const AppGap.regular({super.key}) : size = AppGapSize.regular;

  const AppGap.semiBig({super.key}) : size = AppGapSize.semiBig;

  const AppGap.big({super.key}) : size = AppGapSize.big;

  final AppGapSize size;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Gap(size.getSpacing(theme));
  }
}
