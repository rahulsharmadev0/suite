import 'package:flutter/material.dart';

class $Rec4 {
  final num $1, $2, $3, $4;
  $Rec4(this.$1, this.$2, this.$3, this.$4);

  /// ### (topLeft, topRight, bottomLeft, bottomRight)
  /// Creates a `BorderRadius` with custom values for each corner.
  BorderRadius get rounded => BorderRadius.only(
        topLeft: Radius.circular($1.toDouble()),
        topRight: Radius.circular($2.toDouble()),
        bottomLeft: Radius.circular($3.toDouble()),
        bottomRight: Radius.circular($4.toDouble()),
      );

  /// Creates an `EdgeInsets` with custom values for left, top, right, and bottom.
  EdgeInsets get edges =>
      EdgeInsets.fromLTRB($1.toDouble(), $2.toDouble(), $3.toDouble(), $4.toDouble());
}
