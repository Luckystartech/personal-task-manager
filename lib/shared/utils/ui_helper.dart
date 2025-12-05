import 'package:flutter/material.dart';
import 'package:personal_task_manager/shared/utils/mixins/context.dart';
import 'package:personal_task_manager/shared/widgets/text.dart';

class UiHelper {
  UiHelper._();

  static void showSnackBar(
    String message, {
    required BuildContext context,
    Color? bgColor,
    VoidCallback? action,
  }) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AppText.paragraph2(
            message,
            color: context.theme.colors.primaryOpposite,
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: bgColor ?? context.theme.colors.accent,
          duration: const Duration(seconds: 3),
          action: action != null
              ? SnackBarAction(
                  label: 'Dismiss',
                  textColor: context.theme.colors.primaryOpposite,
                  onPressed: action,
                )
              : null,
        ),
      );
    }
  }
}
