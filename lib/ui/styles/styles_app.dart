import 'package:flutter/material.dart';

class StylesApp {
  static gradient(ColorScheme colorsScheme) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: const [0.0, 0.5, 1.0],
      colors: [
        colorsScheme.onPrimary.withOpacity(0.8),
        colorsScheme.inversePrimary,
        colorsScheme.onPrimary.withOpacity(0.8),
      ],
    );
  }
}
