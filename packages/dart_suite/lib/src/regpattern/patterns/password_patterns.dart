// ignore_for_file: constant_identifier_names

part of '../regpatterns.dart';

mixin _PasswordRegPatterns {
  /// ### Password validation based on the specified `PasswordType`.
  ///
  /// The function supports various password types, including requirements for minimum and maximum length,
  /// whether whitespace is allowed, and custom failure messages.
  ///
  /// - [type]: The desired [PasswordType] for the password pattern.
  /// - [minLength]: The minimum length required for the password (default is 8).
  /// - [maxLength]: The maximum length required for the password (default is 24).
  /// - [allowSpace]: Determines if whitespace characters are allowed in the password (default is false).
  /// - [failedMessage]: An optional custom message to display when password validation fails.
  ///
  RegPattern password(
    PasswordType type, {
    int minLength = 8,
    int maxLength = 24,
    bool allowSpace = false,
    String? failedMessage,
  }) {
    late final String value;
    var min = minLength.toString();
    var max = maxLength.toString();
    switch (type) {
      case PasswordType.ANY_CHAR:
        value = allowSpace
            ? r'^[\S ]{' + min + r',' + max + r'}$'
            : r'^\S{' + min + r',' + max + r'}$';

      case PasswordType.ALL_CHAR_LETTER_NUM:
        value = allowSpace
            ? r'^(?=.*[A-Za-z])(?=.*\d)[\S ]{' + min + r',' + max + r'}$'
            : r'^(?=.*[A-Za-z])(?=.*\d)\S{' + min + r',' + max + r'}$';

      case PasswordType.ONLY_LETTER_NUM:
        value = allowSpace
            ? r'^(?=.*[A-Za-z])(?=.*\d)[a-zA-Z0-9 ]{' + min + r',' + max + r'}$'
            : r'^(?=.*[A-Za-z])(?=.*\d)[a-zA-Z0-9]{' + min + r',' + max + r'}$';

      case PasswordType.ALL_CHARS_UPPER_LOWER_NUM:
        value = allowSpace
            ? r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[\S ]{' +
                min +
                r',' +
                max +
                r'}$'
            : r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)\S{' + min + r',' + max + r'}$';

      default:
        value = allowSpace
            ? r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_])[\S ]{' +
                min +
                r',' +
                max +
                r'}$'
            : r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_])\S{' +
                min +
                r',' +
                max +
                r'}$';
    }
    return RegPattern(
      pattern: value,
      message: failedMessage ?? type.message,
    );
  }
}

enum PasswordType {
  /// Allowing all character with
  /// Requires at least: 1 uppercase letter, 1 lowecase letter, 1 number, & 1 special character (symbol)
  ALL_CHARS_UPPER_LOWER_NUM_SPECIAL(
      message:
          'Allowing all character with Requires at least: 1 uppercase & 1 lowecase letter, 1 number, & 1 special character'),

  /// Allowing all character with
  /// Requires at least: 1 uppercase letter, 1 lowecase letter & 1 number
  ALL_CHARS_UPPER_LOWER_NUM(
      message:
          'Allowing all character with Requires at least: 1 uppercase & 1 lowecase letter, 1 number'),

  /// Allowing all character with
  /// Requires at least: 1 letter & 1 number
  ALL_CHAR_LETTER_NUM(
      message:
          'Allowing all character with Requires at least: 1 letter & 1 number'),

  /// Allowing only letter &  number
  ONLY_LETTER_NUM(message: 'Allowing only letter &  number'),

  /// Allows all characters without specific character requirements
  ANY_CHAR(
      message: 'Allows all characters without specific character requirements');

  final String message;
  const PasswordType({required this.message});
}
