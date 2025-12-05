import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';
import 'package:personal_task_manager/shared/utils/named.dart';

class AppRadiusData extends Equatable {
  const AppRadiusData({
    required this.small,
    required this.regular,
    required this.big,
  });

  const AppRadiusData.regular()
    : small = const Radius.circular(12),
      regular = const Radius.circular(16),
      big = const Radius.circular(20);

  final Radius small;
  final Radius regular;
  final Radius big;

  AppBorderRadiusData asBorderRadius() => AppBorderRadiusData(this);

  @override
  List<Object?> get props => [
    small.named('small'),
    regular.named('regular'),
    big.named('big'),
  ];
}

class AppBorderRadiusData extends Equatable {
  const AppBorderRadiusData(this._radius);

  BorderRadius get small => BorderRadius.all(_radius.small);
  BorderRadius get regular => BorderRadius.all(_radius.regular);
  BorderRadius get big => BorderRadius.all(_radius.big);

  final AppRadiusData _radius;

  @override
  List<Object?> get props => [_radius];
}
