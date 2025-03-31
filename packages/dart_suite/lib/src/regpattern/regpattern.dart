part of 'regpatterns.dart';

class RegPattern {
  // ignore: unused_field
  final String _pattern, message;
  const RegPattern({
    required String pattern,
    String? message,
  })  : message = message ?? 'Invalid format',
        _pattern = pattern;

  bool hasMatch(String value,
      {bool multiLine = false, bool throwError = false}) {
    var regExp = RegExp(_pattern, multiLine: multiLine);
    if (regExp.hasMatch(value)) return true;
    if (throwError) throw ArgumentError(message);
    return false;
  }
}

//
//---------------------------------------------------------------------
// Extension on String
//---------------------------------------------------------------------
//
extension RegPatternForStringExtension on String {
  bool regMatch(RegPattern regex,
      {bool throwError = false, bool multiLine = false}) {
    return regex.hasMatch(this, throwError: throwError, multiLine: multiLine);
  }

  bool regNotMatch(RegPattern regex,
      {bool throwError = false, bool multiLine = false}) {
    return !regex.hasMatch(this, throwError: throwError, multiLine: multiLine);
  }

  bool regAnyMatch(Set<RegPattern> regex,
          {bool throwError = false, bool multiLine = false}) =>
      regex.any((e) =>
          e.hasMatch(this, throwError: throwError, multiLine: multiLine));

  bool regAllMatch(Set<RegPattern> regex,
          {bool throwError = false, bool multiLine = false}) =>
      !regex.every((e) =>
          e.hasMatch(this, throwError: throwError, multiLine: multiLine));
}
