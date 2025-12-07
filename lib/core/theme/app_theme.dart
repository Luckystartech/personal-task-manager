import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'data/colors.dart';
import 'data/radius.dart';
import 'data/spacing.dart';
import 'data/typography.dart';

class AppThemeData extends Equatable {
  const AppThemeData({
    required this.colors,
    required this.typography,
    required this.spacing,
    required this.radius,
    required this.platform,
  });

  final AppColorsData colors;
  final AppTypographyData typography;
  final AppSpacingData spacing;
  final AppRadiusData radius;
  final TargetPlatform platform;

  factory AppThemeData.regular() => AppThemeData(
    colors: AppColorsData.light(),
    typography: AppTypographyData.regular(),
    spacing: AppSpacingData.regular(),
    radius: const AppRadiusData.regular(),
    platform: defaultTargetPlatform,
  );

  AppThemeData copyWith({
    AppColorsData? colors,
    AppTypographyData? typography,
    AppSpacingData? spacing,
    AppRadiusData? radius,
  }) => AppThemeData(
    colors: colors ?? this.colors,
    typography: typography ?? this.typography,
    spacing: spacing ?? this.spacing,
    radius: radius ?? this.radius,
    platform: platform,
  );

  @override
  List<Object?> get props => [colors, typography, spacing, radius, platform];
}

class AppTheme extends InheritedWidget {
  const AppTheme({super.key, required this.data, required super.child});

  final AppThemeData data;

  static AppThemeData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppTheme>()!.data;
  }

  @override
  bool updateShouldNotify(AppTheme old) => data != old.data;
}
