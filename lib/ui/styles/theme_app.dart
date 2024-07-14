import 'package:flutter/material.dart';

class ThemeApp {
  static ThemeData lightThemeData = themeData(lightColorScheme);

  static ThemeData darkThemeData = themeData(darkColorScheme);

  static ThemeData themeData(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      //scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: const AppBarTheme(color: Colors.transparent),
      //textTheme: TextTheme(),
      fontFamily: 'Nunito',
    );
  }

  static ColorScheme lightColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: Colors.blueAccent,
  );

  static ColorScheme darkColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: Colors.blueAccent,
  );
}
