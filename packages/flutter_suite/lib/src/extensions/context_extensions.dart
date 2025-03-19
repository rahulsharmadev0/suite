// ignore_for_file: non_constant_identifier_names

import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_suite/src/theme/text_theme_model.dart';

extension ContextExtensions on BuildContext {
//------------------Media Query Utilities------------------

  /// Platform's Height
  double get height => mQ.size.height;

  /// Platform's Width
  double get width => mQ.size.width;

  double get dpr => mQ.devicePixelRatio;
  Size get flipped => mQ.size.flipped;
  double get aspectRatio => mQ.size.aspectRatio;
  double get longestSide => mQ.size.longestSide;
  double get shortestSide => mQ.size.shortestSide;

  double get dpi => _calculateDpi(height, width, dpr);

  MediaQueryData get mQ => MediaQuery.of(this);

  FlutterView get fview => View.of(this);

  /// Checks if the device is in landscape orientation.
  bool get isLandscape => MediaQuery.of(this).orientation == Orientation.landscape;

  /// Checks if the device is in portrait orientation.
  bool get isPortrait => MediaQuery.of(this).orientation == Orientation.portrait;

  //--------------------Theme Utilities--------------------

  /// Access the theme's color scheme.
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Access the theme's data.
  ThemeData get theme => Theme.of(this);

  /// Check if dark mode is enabled.
  bool get isDark => theme.brightness == Brightness.dark;

  /// Access the theme's icon color.
  Color? get iconColor => theme.iconTheme.color;

  /// Access the theme's text theme.
  TextSelectionThemeData get textSelectionTheme => theme.textSelectionTheme;

  /// Access the theme's text theme.
  $TextTheme get TxT => $TextTheme(theme.textTheme);

  /// Access the theme's primary text theme.
  $TextTheme get pTxT => $TextTheme(theme.primaryTextTheme);

  // ------------------Dimension Calculations------------

  /// Calculates a height percentage (default: 100%).
  ///
  /// Example:
  /// ```dart
  /// double fullHeight = heightOf(); // 100% of height
  /// double halfHeight = heightOf(50); // 50% of height
  /// ```
  double heightOf([double percentage = 100]) => height * percentage * 0.01;

  /// Calculates a width percentage (default: 100%).
  ///
  /// Example:
  /// ```dart
  /// double fullWidth = widthOf(); // 100% of width
  /// double halfWidth = widthOf(50); // 50% of width
  /// ```
  double widthOf([double percentage = 100]) => width * percentage * 0.01;

  /// Calculates a portion of the height.
  ///
  /// - [dividedBy]: Divides the height by this value.
  /// - [reducedBy]: Reduces the height by a percentage.
  ///
  /// Example:
  /// ```dart
  /// double thirdHeight = heightTransformer(dividedBy: 3); // 1/3 of height
  /// double reducedHeight = heightTransformer(reducedBy: 20); // 80% of height
  /// ```
  double heightTransformer({double dividedBy = 1, double reducedBy = 0.0}) {
    return (height - ((height / 100) * reducedBy)) / dividedBy;
  }

  /// Calculates a portion of the width.
  ///
  /// - [dividedBy]: Divides the width by this value.
  /// - [reducedBy]: Reduces the width by a percentage.
  ///
  /// Example:
  /// ```dart
  /// double halfWidth = widthTransformer(dividedBy: 2); // 1/2 of width
  /// double reducedWidth = widthTransformer(reducedBy: 10); // 90% of width
  /// ```
  double widthTransformer({double dividedBy = 1, double reducedBy = 0.0}) {
    return (width - ((width / 100) * reducedBy)) / dividedBy;
  }

  /// Calculates a proportional ratio of height and width.
  ///
  /// - [dividedBy]: Divides the dimensions by this value.
  /// - [reducedByW]: Reduces the width by a percentage.
  /// - [reducedByH]: Reduces the height by a percentage.
  ///
  /// Example:
  /// ```dart
  /// double ratio = ratio(dividedBy: 2, reducedByH: 20, reducedByW: 10);
  /// ```
  double ratio({
    double dividedBy = 1,
    double reducedByW = 0.0,
    double reducedByH = 0.0,
  }) {
    return heightTransformer(dividedBy: dividedBy, reducedBy: reducedByH) /
        widthTransformer(dividedBy: dividedBy, reducedBy: reducedByW);
  }
}

double _calculateDpi(
  double height,
  double width,
  double devicePixelRatio,
) {
  double diagonalPixels = math.sqrt(width * width + height * height);
  double screenInches = diagonalPixels / devicePixelRatio; // Convert to inches directly
  return diagonalPixels / screenInches; // Pixels per inch (PPI)
}
