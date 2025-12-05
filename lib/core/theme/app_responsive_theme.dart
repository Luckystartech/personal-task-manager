import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:personal_task_manager/core/theme/data/spacing.dart';

import 'app_theme.dart';
import 'data/colors.dart';
import 'data/typography.dart';

enum AppThemeColorMode { light, dark }

class AppResponsiveTheme extends StatelessWidget {
  const AppResponsiveTheme({super.key, required this.child, this.colorMode});

  final Widget child;
  final AppThemeColorMode? colorMode;

  static AppThemeColorMode colorModeOf(BuildContext context) {
    final brightness = MediaQuery.platformBrightnessOf(context);
    return brightness == ui.Brightness.dark
        ? AppThemeColorMode.dark
        : AppThemeColorMode.light;
  }

  @override
  Widget build(BuildContext context) {
    var theme = AppThemeData.regular();

    // Dark mode
    final mode = colorMode ?? colorModeOf(context);
    if (mode == AppThemeColorMode.dark) {
      theme = theme.copyWith(colors: AppColorsData.dark());
    }

    // Responsive typography (optional – you can remove if not needed)
    final width = MediaQuery.sizeOf(context).width;
    if (width < 360) {
      theme = theme.copyWith(
        typography: AppTypographyData.small(),
        spacing: AppSpacingData.regular(),
      );
    }

    return AppTheme(data: theme, child: child);
  }
}
