import 'package:flutter/material.dart';

enum OrientationFilter {
  landscape(Icons.crop_landscape),
  portrait(Icons.crop_portrait),
  squarish(Icons.crop_square);

  final IconData icon;
  const OrientationFilter(this.icon);
}

enum ColorFilter {
  blackWhite(Colors.grey),
  black(Colors.black),
  white(Colors.white),
  yellow(Colors.yellow),
  orange(Colors.orange),
  red(Colors.red),
  purple(Colors.purple),
  magenta(Color(0xFFFF00FF)),
  //pink(Colors.pink),
  green(Colors.green),
  teal(Colors.teal),
  blue(Colors.blue);

  final Color color;
  const ColorFilter(this.color);
}

class FilterRequest {
  final OrientationFilter? orientation;
  final ColorFilter? color;

  const FilterRequest({
    this.orientation,
    this.color,
  });
}
