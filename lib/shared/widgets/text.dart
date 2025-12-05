import 'package:flutter/material.dart';
import 'package:personal_task_manager/shared/utils/mixins/context.dart';

enum AppTextLevel { paragraph1, paragraph2, title1, title2, title3 }

class AppText extends StatelessWidget {
  const AppText(
    this.data, {
    super.key,
    this.color,
    this.fontSize,
    this.maxLines,
    this.level = AppTextLevel.paragraph1,
  });

  const AppText.paragraph1(
    this.data, {
    super.key,
    this.color,
    this.fontSize,
    this.maxLines,
  }) : level = AppTextLevel.paragraph1;

  const AppText.paragraph2(
    this.data, {
    super.key,
    this.color,
    this.fontSize,
    this.maxLines,
  }) : level = AppTextLevel.paragraph2;

  const AppText.title1(
    this.data, {
    super.key,
    this.color,
    this.fontSize,
    this.maxLines,
  }) : level = AppTextLevel.title1;

  const AppText.title2(
    this.data, {
    super.key,
    this.color,
    this.fontSize,
    this.maxLines,
  }) : level = AppTextLevel.title2;

  const AppText.title3(
    this.data, {
    super.key,
    this.color,
    this.fontSize,
    this.maxLines,
  }) : level = AppTextLevel.title3;

  final String data;
  final AppTextLevel level;
  final Color? color;
  final double? fontSize;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final color = this.color ?? theme.colors.foreground;
    final style = () {
      switch (level) {
        case AppTextLevel.paragraph1:
          return theme.typography.paragraph1;
        case AppTextLevel.paragraph2:
          return theme.typography.paragraph2;
        case AppTextLevel.title1:
          return theme.typography.title1;
        case AppTextLevel.title2:
          return theme.typography.title2;
        case AppTextLevel.title3:
          return theme.typography.title3;
      }
    }();
    return Text(
      data,
      style: style.copyWith(color: color, fontSize: fontSize),
      maxLines: maxLines,
    );
  }
}
