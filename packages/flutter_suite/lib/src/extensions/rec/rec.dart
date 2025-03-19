export 'rec1.dart';
export 'rec2.dart';
export 'rec4.dart';

import 'package:flutter/material.dart';
import 'rec1.dart';
import 'rec2.dart';
import 'rec4.dart';

extension Rec4 on (num, num, num, num) {
  $Rec4 get $ => $Rec4(this.$1, this.$2, this.$3, this.$4);
}

/// Extension on a tuple of two numeric values, providing methods for
/// creating various `BorderRadius`, `EdgeInsets`, `Size`, and `Radius` objects.
extension Rec2 on (num, num) {
  $Rec2 get $ => $Rec2(this.$1, this.$2);
}

/// Extension on a single numeric value, providing methods for
/// creating `BorderRadius`, `Radius`, and `EdgeInsets` objects.
extension Rec1 on num {
  $Rec1 get $ => $Rec1(this);
}

/// Extension on `BorderRadius` to provide a method for creating
/// a `RoundedRectangleBorder`.
extension RadiusExt on BorderRadius {
  /// Creates a `RoundedRectangleBorder` with the given `BorderRadius`.
  RoundedRectangleBorder get shape => RoundedRectangleBorder(borderRadius: this);
}
