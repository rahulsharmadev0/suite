import 'package:flutter/material.dart';

class $Rec1 {
  final num value;

  $Rec1(this.value);

  /// Creates a `BorderRadius` with the same radius for all corners.
  BorderRadius get rounded => BorderRadius.circular(value.toDouble());

  /// Creates a circular `Radius` with the given value.
  Radius get radius => Radius.circular(value.toDouble());

  /// Creates an `EdgeInsets` with the same padding for all sides.
  EdgeInsets get edges => EdgeInsets.all(value.toDouble());
}
