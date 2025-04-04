import 'package:flutter/material.dart';

extension HexColor on Color {
  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String get $toHex => '#${toARGB32().toRadixString(16)}';

  /// Generates and returns a MaterialColor from a single Color.
  ///
  /// Useful for easily conforming to [ThemeData.primarySwatch].
  MaterialColor $materialColor([bool veryHighAccuracy = false]) {
    return veryHighAccuracy ? _createMaterialColor2(this) : _createMaterialColor(this);
  }
}

MaterialColor _createMaterialColor2(Color color) {
  List strengths = <double>[.05];
  final swatch = <int, Color>{};
  final double r = color.r, g = color.g, b = color.b;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.from(
      alpha: color.a / 255,
      red: r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      green: g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      blue: b + ((ds < 0 ? b : (255 - b)) * ds).round(),
    );
  }
  return MaterialColor(color.toARGB32(), swatch);
}

MaterialColor _createMaterialColor(Color color) {
  final double red = color.r;
  final double green = color.g;
  final double blue = color.b;
  final double alpha = color.a;
  final Map<int, Color> shades = {
    50: Color.from(alpha: alpha, red: red, green: green, blue: blue),
    100: Color.from(alpha: alpha, red: red, green: green, blue: blue),
    200: Color.from(alpha: alpha, red: red, green: green, blue: blue),
    300: Color.from(alpha: alpha, red: red, green: green, blue: blue),
    400: Color.from(alpha: alpha, red: red, green: green, blue: blue),
    500: Color.from(alpha: alpha, red: red, green: green, blue: blue),
    600: Color.from(alpha: alpha, red: red, green: green, blue: blue),
    700: Color.from(alpha: alpha, red: red, green: green, blue: blue),
    800: Color.from(alpha: alpha, red: red, green: green, blue: blue),
    900: Color.from(alpha: alpha, red: red, green: green, blue: blue),
  };
  return MaterialColor(color.toARGB32(), shades);
}
