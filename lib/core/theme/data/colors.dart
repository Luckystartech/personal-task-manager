import 'package:flutter/material.dart';

class AppColorsData {
  const AppColorsData({
    required this.background,
    required this.foreground,
    required this.accent,
    required this.accentOpposite,
    required this.primary,
    required this.primaryOpposite,

    required this.actionBarBackground,
    required this.actionBarForeground,
  });

  final Color background;
  final Color foreground;
  final Color accent;
  final Color primary;
  final Color primaryOpposite;
  final Color accentOpposite;
  final Color actionBarBackground;
  final Color actionBarForeground;

  static AppColorsData light() => const AppColorsData(
    background: Color(0xFFfafbfe),
    foreground: Color(0xFF22315E),
    accent: Color(0xFFeb06fc),
    accentOpposite: Color(0xFFfafbfe),
    primary: Color(0xFF0b54b9),
    primaryOpposite: Color(0xFFfafbfe),
    actionBarBackground: Color(0xFFFFFFFF),
    actionBarForeground: Color(0xFF22315E),
  );

  static AppColorsData dark() => const AppColorsData(
    background: Color(0xFF22315E),
    foreground: Color(0xFFfafbfe),
    accent: Color(0xFF0b54b9),
    accentOpposite: Color(0xFF22315E),
    primary: Color(0xFFeb06fc),
    primaryOpposite: Color(0xFFfafbfe),
    actionBarBackground: Color(0xFF031956),
    actionBarForeground: Color(0xFFfafbfe),
  );
}
