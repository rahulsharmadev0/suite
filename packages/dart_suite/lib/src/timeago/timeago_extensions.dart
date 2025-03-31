import 'package:dart_suite/src/timeago/timeago.dart';

extension DurationExt on Duration {
  /// Sample
  /// ```dart
  /// void main(List<String> args) {
  ///   var timeago = Duration(hours: 34).timeago();
  ///   print(timeago.format()); // 1 day ago
  /// }
  /// ```
  Timeago timeago({String? locale, TimeagoSymbol? symbol}) {
    return Timeago(this, locale: locale, symbol: symbol);
  }
}

extension DateTimeExt on DateTime {
  /// Sample
  /// ```dart
  /// void main(List<String> args) {
  ///   var timeago = DateTime(2001, 12, 01).timeago();
  ///   print(timeago.format()); // 22 years ago
  /// }
  /// ```
  Timeago timeago({String? locale, TimeagoSymbol? symbol}) =>
      Timeago.since(this, locale: locale, symbol: symbol);
}
