import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:personal_task_manager/core/theme/app_theme.dart';
import 'package:personal_task_manager/shared/utils/mixins/context.dart';
import 'package:personal_task_manager/shared/widgets/gap.dart';

class AppEdgeInsets extends Equatable {
  const AppEdgeInsets.all(AppGapSize value)
    : left = value,
      top = value,
      right = value,
      bottom = value;

  const AppEdgeInsets.symmetric({
    AppGapSize vertical = AppGapSize.none,
    AppGapSize horizontal = AppGapSize.none,
  }) : left = horizontal,
       top = vertical,
       right = horizontal,
       bottom = vertical;

  const AppEdgeInsets.only({
    this.left = AppGapSize.none,
    this.top = AppGapSize.none,
    this.right = AppGapSize.none,
    this.bottom = AppGapSize.none,
  });

  const AppEdgeInsets.small()
    : left = AppGapSize.small,
      top = AppGapSize.small,
      right = AppGapSize.small,
      bottom = AppGapSize.small;

  const AppEdgeInsets.semiSmall()
    : left = AppGapSize.semiSmall,
      top = AppGapSize.semiSmall,
      right = AppGapSize.semiSmall,
      bottom = AppGapSize.semiSmall;

  const AppEdgeInsets.regular()
    : left = AppGapSize.regular,
      top = AppGapSize.regular,
      right = AppGapSize.regular,
      bottom = AppGapSize.regular;

  const AppEdgeInsets.semiBig()
    : left = AppGapSize.semiBig,
      top = AppGapSize.semiBig,
      right = AppGapSize.semiBig,
      bottom = AppGapSize.semiBig;

  const AppEdgeInsets.big()
    : left = AppGapSize.big,
      top = AppGapSize.big,
      right = AppGapSize.big,
      bottom = AppGapSize.big;

  final AppGapSize left;
  final AppGapSize top;
  final AppGapSize right;
  final AppGapSize bottom;

  @override
  List<Object?> get props => [left, top, right, bottom];

  EdgeInsets toEdgeInsets(AppThemeData theme) {
    return EdgeInsets.only(
      left: left.getSpacing(theme),
      top: top.getSpacing(theme),
      right: right.getSpacing(theme),
      bottom: bottom.getSpacing(theme),
    );
  }
}

class AppPadding extends StatelessWidget {
  const AppPadding({
    super.key,
    this.padding = const AppEdgeInsets.all(AppGapSize.none),
    this.child,
  });

  const AppPadding.small({super.key, this.child})
    : padding = const AppEdgeInsets.all(AppGapSize.none);

  const AppPadding.semiSmall({super.key, this.child})
    : padding = const AppEdgeInsets.all(AppGapSize.semiSmall);

  const AppPadding.regular({super.key, this.child})
    : padding = const AppEdgeInsets.all(AppGapSize.regular);

  const AppPadding.semiBig({super.key, this.child})
    : padding = const AppEdgeInsets.all(AppGapSize.semiBig);

  const AppPadding.big({super.key, this.child})
    : padding = const AppEdgeInsets.all(AppGapSize.big);

  final AppEdgeInsets padding;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Padding(padding: padding.toEdgeInsets(theme), child: child);
  }
}
