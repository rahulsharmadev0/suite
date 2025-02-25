/// A utility class for converting strings between different cases.
///
/// Supported cases include:
/// * camelCase
/// * PascalCase
/// * snake_case
/// * CONSTANT_CASE
/// * dot.case
/// * param-case
/// * path/case
/// * Title Case
/// * Sentence case
/// * Header-Case
class ReCase {
  final RegExp _upperAlphaRegex = RegExp(r'[A-Z]');

  /// {@template default_symbol_set}
  /// Set of Default symbols used to identify word boundaries.
  ///
  /// This set includes:
  /// * Space ( )
  /// * Period (.)
  /// * Forward slash (/)
  /// * Underscore (_)
  /// * Backslash (\)
  /// * Hyphen (-)
  /// {@endtemplate}
  static const Set<String> defaultSymbolSet = {' ', '.', '/', '_', '\\', '-'};

  final Set<String> symbolSet;
  late String originalText;
  late List<String> _words;

  ReCase._(String text, [Set<String>? symbolSet]) : symbolSet = symbolSet ?? defaultSymbolSet {
    originalText = text;
    _words = _getWords(text);
  }

  /// Splits the input text into words based on case and symbols.
  List<String> _getWords(String text) {
    StringBuffer sb = StringBuffer();
    List<String> words = [];
    bool isAllCaps = text.toUpperCase() == text;

    for (int i = 0; i < text.length; i++) {
      String char = text[i];
      String? nextChar = i + 1 == text.length ? null : text[i + 1];

      if (symbolSet.contains(char)) continue;

      sb.write(char);

      bool isEndOfWord = nextChar == null ||
          (_upperAlphaRegex.hasMatch(nextChar) && !isAllCaps) ||
          symbolSet.contains(nextChar);

      if (isEndOfWord) {
        words.add(sb.toString());
        sb.clear();
      }
    }

    return words;
  }

  /// {@template recase.case_format}
  /// Converts string to camelCase.
  ///
  /// Example: 'foo_bar' => 'fooBar'
  /// {@endtemplate}
  String get camelCase => getCamelCase();

  /// {@template recase.constant_case}
  /// Converts string to CONSTANT_CASE.
  ///
  /// Example: 'fooBar' => 'FOO_BAR'
  /// {@endtemplate}
  String get constantCase => getConstantCase();

  /// {@template recase.sentence_case}
  /// Converts string to Sentence case.
  ///
  /// Example: 'fooBar' => 'Foo bar'
  /// {@endtemplate}
  String get sentenceCase => getSentenceCase();

  /// {@macro recase.case_format}
  String get snakeCase => getSnakeCase();

  /// {@template recase.dot_case}
  /// Converts string to dot.case.
  ///
  /// Example: 'fooBar' => 'foo.bar'
  /// {@endtemplate}
  String get dotCase => getSnakeCase(separator: '.');

  /// {@template recase.param_case}
  /// Converts string to param-case.
  ///
  /// Example: 'fooBar' => 'foo-bar'
  /// {@endtemplate}
  String get paramCase => getSnakeCase(separator: '-');

  /// {@template recase.path_case}
  /// Converts string to path/case.
  ///
  /// Example: 'fooBar' => 'foo/bar'
  /// {@endtemplate}
  String get pathCase => getSnakeCase(separator: '/');

  /// {@template recase.pascal_case}
  /// Converts string to PascalCase.
  ///
  /// Example: 'foo_bar' => 'FooBar'
  /// {@endtemplate}
  String get pascalCase => getPascalCase();

  /// {@macro recase.pascal_case}
  String get headerCase => getPascalCase(separator: '-');

  /// {@macro recase.pascal_case}
  String get titleCase => getPascalCase(separator: ' ');

  String getCamelCase({String separator = ''}) {
    List<String> words = _words.map(upperCaseFirstLetter).toList();
    if (_words.isNotEmpty) {
      words[0] = words[0].toLowerCase();
    }
    return words.join(separator);
  }

  String getConstantCase({String separator = '_'}) {
    List<String> words = _words.map((word) => word.toUpperCase()).toList();
    return words.join(separator);
  }

  String getPascalCase({String separator = ''}) {
    List<String> words = _words.map(upperCaseFirstLetter).toList();
    return words.join(separator);
  }

  String getSentenceCase({String separator = ' '}) {
    List<String> words = _words.map((word) => word.toLowerCase()).toList();
    if (_words.isNotEmpty) {
      words[0] = upperCaseFirstLetter(words[0]);
    }
    return words.join(separator);
  }

  String getSnakeCase({String separator = '_'}) {
    List<String> words = _words.map((word) => word.toLowerCase()).toList();
    return words.join(separator);
  }

  String upperCaseFirstLetter(String word) {
    return '${word.substring(0, 1).toUpperCase()}${word.substring(1).toLowerCase()}';
  }
}

//-----------------------------------------------------------------------------

extension ReCaseExtension on String {
  /// {@macro default_symbol_set}
  ReCase get reCase => ReCase._(this);
}
