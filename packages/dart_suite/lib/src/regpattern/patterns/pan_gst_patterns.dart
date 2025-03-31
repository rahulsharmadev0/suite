// ignore_for_file: constant_identifier_names

part of '../regpatterns.dart';

mixin _PanGstPatterns {
  RegPattern gstNumber(
      {PanType? typeRestriction,
      String? firstName,
      String? middle,
      String? lastName}) {
    var codes = typeRestriction?.code ?? PanType.codes;
    var nfc = (firstName?.trim()[0] ?? '') +
        (middle?.trim()[0] ?? '') +
        (lastName?.trim()[0] ?? '');
    if (nfc.isEmpty) nfc = 'A-Z';

    var stateCode =
        '01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36|37|38|97|99';
    return RegPattern(
      pattern: '^($stateCode)[A-Z]{3}[$codes]{1}[$nfc'
          r']{1}[0-9]{4}[A-Z]{1}\d{1}[A-Z]{1}[A-Z0-9]{1}',
      message: 'Invalid gst number.',
    );
  }

  /// Returns a regex pattern used for PAN number validation.
  ///
  /// The pattern ensures the PAN number format is:
  ///
  /// - First 3 characters: Any uppercase letters.
  /// - Fourth character: Specific to the `typeRestriction` if provided, otherwise any valid PAN type character.
  /// - Fifth character: Any letter from the first characters of `firstName`, `middle`, and `lastName` if provided, or 'A-Z' if none provided.
  /// - Last 4 characters: Numeric digits.
  /// - Last character: Any uppercase letter.
  ///
  /// Throws an error if the generated regex pattern is invalid.
  RegPattern panNumber(
      {PanType? typeRestriction,
      String? firstName,
      String? middle,
      String? lastName}) {
    var codes = typeRestriction?.code ?? PanType.codes;
    var nfc = (firstName?.trim()[0] ?? '') +
        (middle?.trim()[0] ?? '') +
        (lastName?.trim()[0] ?? '');
    if (nfc.isEmpty) nfc = 'A-Z';
    return RegPattern(
      pattern: '^[A-Z]{3}[$codes]{1}[$nfc]{1}[0-9]{4}[A-Z]{1}',
      message: 'Invalid PAN number.',
    );
  }
}

/// Enumeration of PAN (Permanent Account Number) types with corresponding code.
enum PanType {
  ASSOCIATION_OF_PERSONS('A'),
  BODY_OF_INDIVIDUALS('B'),
  COMPANY('C'),
  FIRM('F'),
  GOVERNMENT('G'),
  HINDU_UNDIVIDED_FAMILY('H'),
  LOCAL_AUTHORITY('L'),
  ARTIFICIAL_JURIDICAL_PERSON('J'),
  INDIVIDUAL_PERSON('P'),
  TRUST_ASSOCIATION_OF_PERSONS('T');

  final String code;
  const PanType(this.code);
  static const codes = 'ABCFGHLJPT'; // Valid codes for PAN types
}

/// An enumeration (enum) representing different number systems.
enum Number {
  /// Represents [0-1] binary numbers.
  binary(range: '0-1'),

  /// Represents [0-7] octal numbers.
  octal(range: '0-8'),

  /// Represents [0-9] decimal numbers.
  decimal(range: '0-9'),

  /// Represents [0-9, A-F] hexadecimal numbers.
  hexDecimal(range: '0-9A-Fa-f');

  final String range;
  const Number({required this.range});
}
