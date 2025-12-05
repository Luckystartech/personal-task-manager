import 'package:flutter/material.dart' as mat;
import 'package:flutter/material.dart';

import 'app_responsive_theme.dart';
import 'app_theme.dart';
import 'data/colors.dart';

class AppBase extends StatelessWidget {
  const AppBase({
    super.key,
    required this.child,
    this.title = 'Personal Task Manager',
    this.debugShowCheckedModeBanner = false,
  });

  final Widget child;
  final String title;
  final bool debugShowCheckedModeBanner;

  mat.ThemeData _materialTheme(AppThemeData t) => mat.ThemeData(
    useMaterial3: true,
    colorScheme: mat.ColorScheme.fromSeed(
      seedColor: t.colors.accent,
      brightness: t.colors.background.computeLuminance() > 0.5
          ? mat.Brightness.light
          : mat.Brightness.dark,
      surface: t.colors.background,
    ),
    scaffoldBackgroundColor: t.colors.background,
    appBarTheme: mat.AppBarTheme(
      backgroundColor: t.colors.actionBarBackground,
      foregroundColor: t.colors.actionBarForeground,
      elevation: 0,
      titleTextStyle: t.typography.title3.copyWith(
        color: t.colors.actionBarForeground,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: mat.CardThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: t.radius.asBorderRadius().regular,
      ),
      elevation: 4,
    ),
    inputDecorationTheme: mat.InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: t.radius.asBorderRadius().regular,
      ),
      contentPadding: t.spacing.asInsets().regular,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return AppResponsiveTheme(
      child: Builder(
        builder: (context) {
          final theme = AppTheme.of(context);

          final app = mat.MaterialApp(
            debugShowCheckedModeBanner: debugShowCheckedModeBanner,
            title: title,
            theme: _materialTheme(theme),
            darkTheme: _materialTheme(
              theme.copyWith(colors: AppColorsData.dark()),
            ),
            themeMode: mat.ThemeMode.system,
            home: child,
          );

          return app;
        },
      ),
    );
  }
}
