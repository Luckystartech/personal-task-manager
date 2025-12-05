import 'package:flutter/widgets.dart';

class AppTypographyData {
  const AppTypographyData({
    required this.title1,
    required this.title2,
    required this.title3,
    required this.paragraph1,
    required this.paragraph2,
  });

  final TextStyle title1;
  final TextStyle title2;
  final TextStyle title3;
  final TextStyle paragraph1;
  final TextStyle paragraph2;

  static AppTypographyData regular() => const AppTypographyData(
    title1: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      fontFamily: 'Poppins',
    ),
    title2: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      fontFamily: 'Poppins',
    ),
    title3: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      fontFamily: 'Poppins',
    ),
    paragraph1: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
    paragraph2: TextStyle(fontSize: 14, fontFamily: 'Poppins'),
  );

  static AppTypographyData small() => const AppTypographyData(
    title1: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      fontFamily: 'Poppins',
    ),
    title2: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      fontFamily: 'Poppins',
    ),
    title3: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      fontFamily: 'Poppins',
    ),
    paragraph1: TextStyle(fontSize: 15, fontFamily: 'Poppins'),
    paragraph2: TextStyle(fontSize: 13, fontFamily: 'Poppins'),
  );
}
