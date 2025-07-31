import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.green,
      surfaceContainerLowest: Color(0xffe9f8e2),
    ),
    fontFamily: 'Urbanist',
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.green,
      brightness: Brightness.dark,
      surfaceContainerLowest: Color(0xff142213),
      primaryFixedDim: Color(0xff1b411c),
    ),
    fontFamily: 'Urbanist',
  );
}
