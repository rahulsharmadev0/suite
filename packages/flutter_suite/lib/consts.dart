// ignore_for_file: avoid_print, unused_local_variable, library_private_types_in_public_api, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_suite/flutter_suite.dart';


/// {@template large}
/// ## Large (32.0)
/// A constant representing a large spacing value used throughout the UI theme.
///
/// This value is typically used for significant padding, margin, or spacing
/// requirements to ensure consistent and visually appealing layouts.
///
/// - Value: `32.0`
/// {@endtemplate}
const $large = 32.0;

/// {@template normal}
/// ## Normal (16.0)
/// A constant representing a normal spacing value used throughout the UI theme.
///
/// This value is typically used for standard padding, margin, or spacing
/// requirements to ensure consistent and visually appealing layouts.
///
/// - Value: `16.0`
/// {@endtemplate}
const $normal = 16.0;

/// {@template medium}
/// ## Medium (12.0)
/// A constant representing a medium spacing value used throughout the UI theme.
///
/// This value is typically used for moderate padding, margin, or spacing
/// requirements to ensure consistent and visually appealing layouts.
///
/// - Value: `12.0`
/// {@endtemplate}
const $medium = 12.0;

/// {@template small}
/// ## Small (8.0)
/// A constant representing a small spacing value used throughout the UI theme.
///
/// This value is typically used for minor padding, margin, or spacing
/// requirements to ensure consistent and visually appealing layouts.
///
/// - Value: `8.0`
/// {@endtemplate}
const $small = 8.0;

/// {@template tiny}
/// ## Tiny (4.0)
/// A constant representing a tiny spacing value used throughout the UI theme.
///
/// This value is typically used for very small padding, margin, or spacing
/// requirements to ensure consistent and visually appealing layouts.
///
/// - Value: `4.0`
/// {@endtemplate}
const $tiny = 4.0;

/// {@template micro}
/// ## Micro (2.0)
/// A constant representing a micro spacing value used throughout the UI theme.
///
/// This value is typically used for very small padding, margin, or spacing
/// requirements to ensure consistent and visually appealing layouts.
///
/// - Value: `2.0`
/// {@endtemplate}
const $micro = 2.0;

// -------------
// Gaps
// -------------
@immutable
abstract final class $Gap {
  ///{@macro large}
  static const large = Gap($large);

  ///{@macro normal}
  static const normal = Gap($normal);

  ///{@macro medium}
  static const medium = Gap($medium);

  ///{@macro small}
  static const small = Gap($small);

  ///{@macro tiny}
  static const tiny = Gap($tiny);

  ///{@macro micro}
  static const micro = Gap($micro);
}

// -------------
// Radius
// -------------
@immutable
abstract final class $Radius {
  ///{@macro large}
  static const large = Radius.circular($large);

  ///{@macro normal}
  static const normal = Radius.circular($normal);

  ///{@macro medium}
  static const medium = Radius.circular($medium);

  ///{@macro small}
  static const small = Radius.circular($small);

  ///{@macro tiny}
  static const tiny = Radius.circular($tiny);

  ///{@macro micro}
  static const micro = Radius.circular($micro);
}

// -------------
// Border Radius
// -------------
@immutable
abstract final class $BorderRadius {
  ///{@macro large}
  static const large = BorderRadius.all($Radius.large);

  ///{@macro normal}
  static const normal = BorderRadius.all($Radius.normal);

  ///{@macro medium}
  static const medium = BorderRadius.all($Radius.medium);

  ///{@macro small}
  static const small = BorderRadius.all($Radius.small);

  ///{@macro tiny}
  static const tiny = BorderRadius.all($Radius.tiny);

  ///{@macro micro}
  static const micro = BorderRadius.all($Radius.micro);
}

// -------------
// EdgeInsets
// -------------
@immutable
abstract final class $EdgeInsets {
  ///{@macro large}
  static const EdgeInsets large = EdgeInsets.all($large);

  ///{@macro normal}
  static const EdgeInsets normal = EdgeInsets.all($normal);

  ///{@macro medium}
  static const EdgeInsets medium = EdgeInsets.all($medium);

  ///{@macro small}
  static const EdgeInsets small = EdgeInsets.all($small);

  ///{@macro tiny}
  static const EdgeInsets tiny = EdgeInsets.all($tiny);

  ///{@macro micro}
  static const EdgeInsets micro = EdgeInsets.all($micro);

  // Horizontal

  ///{@macro large}
  static const horizontalLarge = EdgeInsets.symmetric(horizontal: $large);

  ///{@macro normal}
  static const horizontalNormal = EdgeInsets.symmetric(horizontal: $normal);

  ///{@macro medium}
  static const horizontalMedium = EdgeInsets.symmetric(horizontal: $medium);

  ///{@macro small}
  static const horizontalSmall = EdgeInsets.symmetric(horizontal: $small);

  ///{@macro tiny}
  static const horizontalTiny = EdgeInsets.symmetric(horizontal: $tiny);

  ///{@macro micro}
  static const horizontalMicro = EdgeInsets.symmetric(horizontal: $micro);

  // Vertical

  ///{@macro large}
  static const verticalLarge = EdgeInsets.symmetric(vertical: $large);

  ///{@macro normal}
  static const verticalNormal = EdgeInsets.symmetric(vertical: $normal);

  ///{@macro medium}
  static const verticalMedium = EdgeInsets.symmetric(vertical: $medium);

  ///{@macro small}
  static const verticalSmall = EdgeInsets.symmetric(vertical: $small);

  ///{@macro tiny}
  static const verticalTiny = EdgeInsets.symmetric(vertical: $tiny);

  ///{@macro micro}
  static const verticalMicro = EdgeInsets.symmetric(vertical: $micro);
}

// -------------
// RoundedRectangleBorder
// -------------
@immutable
abstract final class $RoundedRectangleBorder {
  ///{@macro large}
  static const large = RoundedRectangleBorder(
    borderRadius: $BorderRadius.large,
  );

  ///{@macro normal}
  static const normal = RoundedRectangleBorder(
    borderRadius: $BorderRadius.normal,
  );

  ///{@macro medium}
  static const medium = RoundedRectangleBorder(
    borderRadius: $BorderRadius.medium,
  );

  ///{@macro small}
  static const small = RoundedRectangleBorder(
    borderRadius: $BorderRadius.small,
  );

  ///{@macro tiny}
  static const tiny = RoundedRectangleBorder(borderRadius: $BorderRadius.tiny);

  ///{@macro micro}
  static const micro = RoundedRectangleBorder(
    borderRadius: $BorderRadius.micro,
  );
}

// -------------
// Duration
// -------------
@immutable
abstract final class $Duration {
  /// 1000ms
  static const long = Duration(milliseconds: 1000);

  /// 500ms
  static const normal = Duration(milliseconds: 500);

  /// 300ms
  static const short = Duration(milliseconds: 300);

  /// 150ms
  static const quick = Duration(milliseconds: 150);

  /// 75ms
  static const instant = Duration(milliseconds: 75);
}
