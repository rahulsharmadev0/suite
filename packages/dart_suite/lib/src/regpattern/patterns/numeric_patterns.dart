// ignore_for_file: unused_element, constant_identifier_names, prefer_interpolation_to_compose_strings
part of '../regpatterns.dart';

mixin _NumericRegPatterns {
  /// Use this function to create a regular expression pattern that matches
  /// strings consisting only of digits with allow additional characters within a
  /// specified range of lengths.
  ///
  /// - [**type**]: The type of numbers to match (e.g., decimal, binary, octal).
  /// - [**allowEmptyString**]:
  ///
  ///       - If `true`, the pattern allows for an empty string.
  ///       - If `false`, the pattern requires at least one digit.
  ///
  /// - [**allowSpecialChar**]: Additional characters to allow within the number pattern.
  /// - [**minLength**]: The minimum length required for the number (default is 1).
  /// - [**maxLength**]: The maximum length required for the number (default is 16).
  ///
  ///
  /// ### Example...
  ///```dart
  ///      RegPatterns.number(
  ///               type: Number.octal, // only use [0-7]
  ///               allowEmptyString: true,
  ///               allowSpecialChar: ".,", // allow dots and comma
  ///               minLength: 4,
  ///               maxLength: 8 );
  ///```
  ///
  /// Returns a [RegPatterns] instance with the generated regular expression pattern.
  RegPattern number({
    Number type = Number.decimal,
    bool allowEmptyString = false,
    String allowSpecialChar = '',
    int minLength = 2,
    int maxLength = 16,
  }) {
    final range = RegExp.escape(type.range + allowSpecialChar);
    final value = allowEmptyString
        ? '^(|[$range]{$minLength,$maxLength})\$'
        : '^[$range]{$minLength,$maxLength}\$';
    return RegPattern(
      pattern: value,
      message:
          'Only contain the numbers ${type.range} ${allowSpecialChar.split('').join(' ')} '
          'and the length should be larger than $minLength but less than $maxLength.',
    );
  }
}
