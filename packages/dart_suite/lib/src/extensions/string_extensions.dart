import 'dart:convert';

import 'package:collection/collection.dart';

extension StringExtensions on String {
  bool get isNotBlank => trim().isNotEmpty;
  bool get isBlank => trim().isEmpty;

  Uri uri([int start = 0, int? end]) => Uri.parse(this, start, end);

  /// Sample:
  /// ```
  /// void main(){
  ///   print('ABC1251365'.separate());
  /// }
  /// ```
  /// ----------
  /// ABC,251,365
  /// ----------
  String separate({
    int min = 1,
    int max = 3,
    String separator = ',',
    ({Pattern splitBy, String join})? pattern,
  }) {
    if (length < max) return this;
    String min0 = min.abs().toString();
    String max0 = max.abs().toString();
    RegExp readable = RegExp(r'(\w{' + min0 + r',' + max0 + r'})(?=(\w{' + max0 + r'})+(?!\w))');
    mathFunc(Match match) => '${match[1]}$separator';
    return pattern == null
        ? replaceAllMapped(readable, mathFunc)
        : removeAllSpace
            .split(pattern.splitBy)
            .map((e) => e.replaceAllMapped(readable, mathFunc))
            .join(pattern.join);
  }

  /// Sample
  /// ```
  /// void main(){
  ///   var path = 'roo/folder/sample.pdf';
  ///   print(path.format.isPDF)
  /// }
  /// ```
  String? get fileFormat {
    var startFrom = lastIndexOf('.');
    if (startFrom == -1) return null;
    var last = lastIndexOf('?');
    return substring(startFrom + 1, last == -1 ? null : last);
  }

  /// Checks if string is boolean.
  bool get isBool => isTrue || isFalse;

  /// Checks if string is `true`.
  bool get isTrue => trim() == 'true';

  /// Checks if string is `false`.
  bool get isFalse => trim() == 'false';

  /// Remove all whitespace inside string
  /// Example: your name => yourname
  String get removeAllSpace => replaceAll(' ', '');

  /// Trims leading/trailing whitespace and replaces multiple spaces with a single space.
  /// ```dart
  ///   String text = '  This   is   an   example   string.  ';
  ///   print(text.normalizeSpaces);   // Output: 'This is an example string.'
  /// }
  /// ```
  String get normalizeSpaces => trim().replaceAll(RegExp(r'\s+'), ' ');

  ///
  /// ```dart
  ///   String sample ='what is \n your name';
  ///   print(sample); \\ whatisyourname
  /// ```
  /// Remove all whitespace & newline inside string
  String get trimAll => replaceAll(RegExp(r'[ |\\n]+'), '');

  /// Extract numeric value of string
  /// Example: OTP 12312 27/04/2020 => 1231227042020
  /// If firstword only is true, then the example return is "12312"
  /// (first found numeric word)
  String numericOnly({
    int startFrom = 0,
    int? endAt,
    bool firstWordOnly = false,
  }) {
    var numericOnly = '';
    for (var i = startFrom; i < (endAt ?? length); i++) {
      var code = codeUnitAt(i);
      if (code >= 48 && code <= 57) numericOnly += this[i];
      if (firstWordOnly && numericOnly.isNotEmpty && code == 32) break;
    }
    return numericOnly;
  }

  String createPath([Iterable? segments]) {
    final path = startsWith('/') ? this : '/$this';

    if (segments == null || segments.isEmpty) {
      return path;
    }
    final list = segments.map((e) => '/$e');
    return path + list.join();
  }

  List<String> get toList => runes.map((r) => String.fromCharCode(r)).toList();

  List<String> get toReversedList => reversed.toList;

  /// Returns [this] with characters in reverse order.
  ///
  /// Example:
  /// ```dart
  /// 'word'.reversed; // 'drow'
  /// ```
  ///
  /// WARNING: This is the naive-est possible implementation, relying on native
  /// string indexing. Therefore, this method is almost guaranteed to exhibit
  /// unexpected behavior for non-ASCII characters.
  String get reversed {
    final stringBuffer = StringBuffer();
    for (var i = length - 1; i >= 0; i--) {
      stringBuffer.write(this[i]);
    }

    return stringBuffer.toString();
  }

  /// A palindrome is a sequence of characters that reads the same forwards and backwards
  /// when ignoring spaces, non-alphanumeric characters, and considering letter casing.
  ///
  /// Returns `true` if the string is a palindrome(normal and reversed are same), and ` false` otherwise.
  /// ```
  bool isPalindrom([removeAllSpace = false]) {
    final cleanString = removeAllSpace ? this.removeAllSpace : this;
    return cleanString == cleanString.reversed;
  }

  /// Base64 encryption
  String get toEncodedBase64 => base64.encode(utf8.encode(this));

  /// Base64 decryption
  String get toDecodedBase64 => String.fromCharCodes(base64.decode(this));

  /// Perform utf8 encoding
  List<int> get utf8Encode => utf8.encode(this);
}
