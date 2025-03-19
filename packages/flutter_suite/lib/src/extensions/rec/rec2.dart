import 'package:flutter/material.dart';

class $Rec2 {
  final num $1;
  final num $2;

  $Rec2(this.$1, this.$2);

  /// ### (left, right)
  /// Creates a `BorderRadius` with custom values for the left and right sides.
  ///
  /// ```
  ///  ⇢ ╭───────╮  ⇠
  ///  ⇢ │       │  ⇠
  ///  ⇢ ╰───────╯  ⇠
  /// ```
  ///
  BorderRadius get roundedHorizontally => BorderRadius.horizontal(
        left: Radius.circular($1.toDouble()),
        right: Radius.circular($2.toDouble()),
      );

  /// ### (top, bottom)
  /// Creates a `BorderRadius` with custom values for the top and bottom sides.
  /// ```
  ///   ⇣ ⇣ ⇣
  /// ╭───────╮
  /// │       │
  /// ╰───────╯
  ///   ⇡ ⇡ ⇡
  BorderRadius get roundedVertically => BorderRadius.vertical(
        top: Radius.circular($1.toDouble()),
        bottom: Radius.circular($2.toDouble()),
      );

  /// ### (topLeft, topRight, bottomLeft, bottomRight)
  /// Creates a `BorderRadius` with custom values for the top-left and bottom-right,
  /// and top-right and bottom-left corners.
  /// ```
  /// ⇣
  /// ╭───────╮
  /// │       │
  /// ╰───────╯
  ///         ⇡
  /// ```
  BorderRadius get roundedDiagonally => BorderRadius.only(
        topLeft: Radius.circular($1.toDouble()),
        bottomRight: Radius.circular($1.toDouble()),
        topRight: Radius.circular($2.toDouble()),
        bottomLeft: Radius.circular($2.toDouble()),
      );

  /// ### (vertical, horizontal)
  /// Creates an `EdgeInsets` with symmetric vertical and horizontal values.
  EdgeInsets get edges {
    return EdgeInsets.symmetric(vertical: $1.toDouble(), horizontal: $2.toDouble());
  }

  /// ### (width, height)
  /// Creates a `Size` object with custom width and height.
  Size get size => Size($1.toDouble(), $2.toDouble());

  /// Creates an elliptical `Radius` with custom horizontal and vertical radii.
  Radius get ellipticalRadius => Radius.elliptical($1.toDouble(), $2.toDouble());

  /// Creates a `BorderRadius` with an elliptical radius.
  BorderRadius get elliptical => BorderRadius.all(ellipticalRadius);
}
