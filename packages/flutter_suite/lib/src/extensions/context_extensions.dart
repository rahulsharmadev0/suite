// ignore_for_file: non_constant_identifier_names

import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_suite/src/extensions/theme/text_theme_model.dart';

extension ContextExtensions on BuildContext {
//------------------Media Query Utilities------------------

  Size get $size => MediaQuery.sizeOf(this);

  Orientation get $orientation => MediaQuery.orientationOf(this);

  double get $devicePixelRatio => MediaQuery.devicePixelRatioOf(this);

  @Deprecated(
    'Use textScalerOf instead. '
    'Use of textScaleFactor was deprecated in preparation for the upcoming nonlinear text scaling support. '
    'This feature was deprecated after v3.12.0-2.0.pre.',
  )
  double get $textScaleFactor => MediaQuery.textScaleFactorOf(this);

  TextScaler get $textScaler => MediaQuery.textScalerOf(this);

  Brightness get $platformBrightness => MediaQuery.platformBrightnessOf(this);

  EdgeInsets get $padding => MediaQuery.paddingOf(this);

  EdgeInsets get $viewInsets => MediaQuery.viewInsetsOf(this);

  EdgeInsets get $systemGestureInsets => MediaQuery.systemGestureInsetsOf(this);

  EdgeInsets get $viewPadding => MediaQuery.viewPaddingOf(this);

  bool get $alwaysUse24HourFormat => MediaQuery.alwaysUse24HourFormatOf(this);

  bool get $accessibleNavigation => MediaQuery.accessibleNavigationOf(this);

  bool get $invertColors => MediaQuery.invertColorsOf(this);

  bool get $highContrast => MediaQuery.highContrastOf(this);

  bool get $onOffSwitchLabels => MediaQuery.onOffSwitchLabelsOf(this);

  bool get $disableAnimations => MediaQuery.disableAnimationsOf(this);

  bool get $boldText => MediaQuery.boldTextOf(this);

  NavigationMode get $navigationMode => MediaQuery.navigationModeOf(this);

  DeviceGestureSettings get $gestureSettings => MediaQuery.gestureSettingsOf(this);

  List<DisplayFeature> get $displayFeatures => MediaQuery.displayFeaturesOf(this);

  //---------------------Size & Orientation Utilities--------------------
  double get $devicePixelsPerInch {
    Size size = MediaQuery.sizeOf(this);
    double diagonalPixels = math.sqrt(math.pow(size.width, 2) + math.pow(size.height, 2));
    double screenInches =
        diagonalPixels / $devicePixelRatio; // Convert to inches directly
    return diagonalPixels / screenInches; // Pixels per inch (PPI)
  }

  /// Checks if the device is in landscape orientation.
  bool get $isLandscape => $orientation == Orientation.landscape;

  /// Checks if the device is in portrait orientation.
  bool get $isPortrait => $orientation == Orientation.portrait;

  // ------------------Dimension Calculations------------
  /// Calculates a height percentage (default: 100%).
  ///
  /// Example:
  /// ```dart
  /// double fullHeight = heightOf(); // 100% of height
  /// double halfHeight = heightOf(50); // 50% of height
  /// ```
  double $heightOf([double percentage = 100]) => $size.height * percentage * 0.01;

  /// Calculates a width percentage (default: 100%).
  ///
  /// Example:
  /// ```dart
  /// double fullWidth = widthOf(); // 100% of width
  /// double halfWidth = widthOf(50); // 50% of width
  /// ```
  double $widthOf([double percentage = 100]) => $size.width * percentage * 0.01;

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
  double $heightTransformer({double dividedBy = 1, double reducedBy = 0.0}) {
    double height = $size.height;
    if (height == 0 || dividedBy == 0) return 0.0; // Avoid zero
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
  double $widthTransformer({double dividedBy = 1, double reducedBy = 0.0}) {
    double width = $size.width;
    if (width == 0 || dividedBy == 0) return 0.0; // Avoid zero
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
  double $ratio({
    double dividedBy = 1,
    double reducedByW = 0.0,
    double reducedByH = 0.0,
  }) {
    return $heightTransformer(dividedBy: dividedBy, reducedBy: reducedByH) /
        $widthTransformer(dividedBy: dividedBy, reducedBy: reducedByW);
  }

  //--------------------Theme Utilities--------------------

  /// Access the theme's color scheme.
  ColorScheme get $colorScheme => Theme.of(this).colorScheme;

  /// Access the theme's data.
  ThemeData get $theme => Theme.of(this);

  /// Check if dark mode is enabled.
  bool get $isDark => Theme.of(this).brightness == Brightness.dark;

  /// Access the theme's icon color.
  Color? get $iconColor => $theme.iconTheme.color;

  /// Access the theme's text theme.
  TextSelectionThemeData get $textSelectionTheme => Theme.of(this).textSelectionTheme;

  /// Access the theme's text theme.
  $TextTheme get $TxT => $TextTheme(Theme.of(this).textTheme);

  /// Access the theme's primary text theme.
  $TextTheme get $pTxT => $TextTheme(Theme.of(this).primaryTextTheme);
}
