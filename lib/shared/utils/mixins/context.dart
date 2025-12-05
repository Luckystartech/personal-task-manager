// THeme Extension on BuildContext for easy access
import 'package:flutter/material.dart';
import 'package:personal_task_manager/core/theme/app_theme.dart';

extension AppThemeExtension on BuildContext {
  AppThemeData get theme => AppTheme.of(this);
  double get deviceWidth => MediaQuery.sizeOf(this).width;
  double get deviceHeight => MediaQuery.sizeOf(this).height;
}
