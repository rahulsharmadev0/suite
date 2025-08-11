import 'package:flutter/material.dart';

extension Rec4 on (num, num, num, num) {
  /// ### (topLeft, topRight, bottomLeft, bottomRight)
  /// BorderRadius with custom values for each corner.
  ///
  ///```
  ///  ↖╭───────╮↗
  ///   │       │
  ///  ↙╰───────╯↘
  ///  TL      TR
  ///  BL      BR
  ///```
  BorderRadius get $rounded => BorderRadius.only(
        topLeft: Radius.circular($1.toDouble()),
        topRight: Radius.circular($2.toDouble()),
        bottomLeft: Radius.circular($3.toDouble()),
        bottomRight: Radius.circular($4.toDouble()),
      );

  /// ### (left, top, right, bottom)
  /// EdgeInsets with custom values for each side.
  ///
  ///```
  ///   ↑ top
  /// ←   ╔══════╗   →
  /// left║      ║right
  /// ←   ╚══════╝   →
  ///   ↓ bottom
  ///```
  EdgeInsets get $edges =>
      EdgeInsets.fromLTRB($1.toDouble(), $2.toDouble(), $3.toDouble(), $4.toDouble());
}

/// Extension on a tuple of three numeric values, providing methods for
/// creating various BorderRadius, EdgeInsets, and Size objects.
extension Rec3 on (num, num, num) {
  /// ### (top, horizontal, bottom)
  /// EdgeInsets like CSS shorthand: top, left/right, bottom.
  ///
  ///```
  ///   ↑ top
  /// ←   ╔══════╗   →
  ///     ║      ║
  /// ←   ╚══════╝   →
  ///   ↓ bottom
  /// (left/right = horizontal)
  ///```
  EdgeInsets get $edges => EdgeInsets.only(
        top: $1.toDouble(),
        left: $2.toDouble(),
        right: $2.toDouble(),
        bottom: $3.toDouble(),
      );

  /// ### (top, horizontal, bottom)
  /// BorderRadius like CSS shorthand: top, left/right, bottom.
  ///
  ///```
  ///  ↖╭───────╮↗
  ///   │       │
  ///  ↙╰───────╯↘
  ///  TL/TR: top, BL/BR: bottom
  /// (left/right = horizontal)
  ///```
  BorderRadius get $rounded => BorderRadius.only(
        topLeft: Radius.circular($1.toDouble()),
        topRight: Radius.circular($1.toDouble()),
        bottomLeft: Radius.circular($3.toDouble()),
        bottomRight: Radius.circular($3.toDouble()),
      );
}

/// Extension on a tuple of two numeric values, providing methods for
/// creating various `BorderRadius`, `EdgeInsets`, `Size`, and `Radius` objects.
extension Rec2 on (num, num) {
  /// ### (left, right)
  /// Creates a `BorderRadius` with custom values for the left and right sides.
  ///
  ///```
  /// ⇢╭───────╮⇠
  /// ⇢│       │⇠
  /// ⇢╰───────╯⇠
  ///  L       R
  ///```
  BorderRadius get $roundedHorizontally => BorderRadius.horizontal(
        left: Radius.circular($1.toDouble()),
        right: Radius.circular($2.toDouble()),
      );

  /// ### (top, bottom)
  /// BorderRadius with custom values for top and bottom sides.
  ///
  ///```
  ///      T
  ///   ⇣  ⇣  ⇣
  ///  ╭───────╮
  ///  │       │
  ///  ╰───────╯
  ///   ⇡  ⇡  ⇡
  ///      B
  ///```
  BorderRadius get $roundedVertically => BorderRadius.vertical(
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
  BorderRadius get $roundedDiagonally => BorderRadius.only(
        topLeft: Radius.circular($1.toDouble()),
        bottomRight: Radius.circular($1.toDouble()),
        topRight: Radius.circular($2.toDouble()),
        bottomLeft: Radius.circular($2.toDouble()),
      );

  /// ### (vertical, horizontal)
  /// Creates an `EdgeInsets` with symmetric vertical and horizontal values.
  EdgeInsets get $edges {
    return EdgeInsets.symmetric(vertical: $1.toDouble(), horizontal: $2.toDouble());
  }

  /// ### (width, height)
  /// Creates a `Size` object with custom width and height.
  Size get $size => Size($1.toDouble(), $2.toDouble());

  /// Creates an elliptical `Radius` with custom horizontal and vertical radii.
  Radius get $ellipticalRadius => Radius.elliptical($1.toDouble(), $2.toDouble());

  /// Creates a `BorderRadius` with an elliptical radius.
  BorderRadius get $elliptical => BorderRadius.all($ellipticalRadius);
}

/// Extension on a single numeric value, providing methods for
/// creating `BorderRadius`, `Radius`, and `EdgeInsets` objects.
extension Rec1 on num {
  /// Creates a `BorderRadius` with the same radius for all corners.
  ///
  /// Example: `12.$rounded` creates a BorderRadius with 12px radius on all corners.
  BorderRadius get $rounded => BorderRadius.circular(toDouble());

  /// Creates a circular `Radius` with the given value.
  ///
  /// Example: `8.$radius` creates a Radius.circular(8.0).
  Radius get $radius => Radius.circular(toDouble());

  /// Creates a square `Size` with the same width and height.
  ///
  /// Example: `100.$size` creates a Size(100.0, 100.0).
  Size get $size => Size(toDouble(), toDouble());

  /// Creates a circular `Radius` with equal horizontal and vertical radii.
  ///
  /// Example: `16.$ellipticalRadius` creates a Radius.elliptical(16.0, 16.0).
  Radius get $ellipticalRadius => Radius.elliptical(toDouble(), toDouble());

  /// Creates a `BorderRadius` with elliptical corners using the same radius value.
  ///
  /// Example: `20.$elliptical` applies elliptical radius to all corners.
  BorderRadius get $elliptical => BorderRadius.all($ellipticalRadius);

  /// Creates uniform `EdgeInsets` with the same padding on all sides.
  ///
  /// Example: `16.$allEdges` creates EdgeInsets.all(16.0).
  EdgeInsets get $allEdges => EdgeInsets.all(toDouble());

  /// Creates `EdgeInsets` with padding only on the top side.
  ///
  /// Example: `10.$topEdge` creates EdgeInsets.only(top: 10.0).
  EdgeInsets get $topEdge => EdgeInsets.only(top: toDouble());

  /// Creates `EdgeInsets` with padding only on the bottom side.
  ///
  /// Example: `10.$bottomEdge` creates EdgeInsets.only(bottom: 10.0).
  EdgeInsets get $bottomEdge => EdgeInsets.only(bottom: toDouble());

  /// Creates `EdgeInsets` with padding only on the left side.
  ///
  /// Example: `10.$leftEdge` creates EdgeInsets.only(left: 10.0).
  EdgeInsets get $leftEdge => EdgeInsets.only(left: toDouble());

  /// Creates `EdgeInsets` with padding only on the right side.
  ///
  /// Example: `10.$rightEdge` creates EdgeInsets.only(right: 10.0).
  EdgeInsets get $rightEdge => EdgeInsets.only(right: toDouble());
}

/// Extension on `BorderRadius` to provide a method for creating
/// a `RoundedRectangleBorder`.
extension RadiusExt on BorderRadius {
  /// Creates a `RoundedRectangleBorder` with the given `BorderRadius`.
  RoundedRectangleBorder get $shape => RoundedRectangleBorder(borderRadius: this);
}
