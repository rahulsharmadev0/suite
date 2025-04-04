import 'dart:ui';

import 'package:flutter/material.dart';

extension StringToHex on String {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  Color get $toColor {
    final buffer = StringBuffer();
    if (length == 6 || length == 7) buffer.write('ff');
    buffer.write(replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
