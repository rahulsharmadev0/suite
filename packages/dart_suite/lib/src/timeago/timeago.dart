// ignore_for_file: unused_field

import 'timeago_symbol.dart';
import 'timeago_symbol_data_local.dart';
import 'package:intl/intl.dart' as intl;

export 'timeago_symbol.dart';
export 'timeago_extensions.dart';

extension on TimeagoSymbolValue {
  String get(bool short) => short ? this.SHORT : this.LONG;
}

class Timeago {
  final Duration duration;
  final TimeagoSymbol _symbol;
  Timeago(this.duration, {String? locale, TimeagoSymbol? symbol})
      : _symbol = symbol ?? _getSymbol(locale, symbol);

  factory Timeago.since(DateTime dateTime,
          {String? locale, TimeagoSymbol? symbol}) =>
      Timeago(DateTime.now().difference(dateTime),
          locale: locale, symbol: symbol);

  static TimeagoSymbol _getSymbol(String? locale, TimeagoSymbol? symbol) {
    if (symbol != null && locale != null) {
      throw ArgumentError('You can only pass one of locale or symbol.');
    }

    locale = locale ?? intl.Intl.defaultLocale ?? intl.Intl.systemLocale;
    symbol = timeagoSymbolMap()[locale];
    if (symbol == null) throw ArgumentError("Locale '$locale' not found");
    return symbol;
  }

  bool enableShort = false;
  bool enableSuffix = true;

  String get justnow => _symbol.JUST_NOW.get(enableShort);
  String get seconds => _symbol.SECONDS.get(enableShort);
  String get oneMinute => _symbol.ONE_MINUTE.get(enableShort);
  String get minutes => _symbol.MINUTES.get(enableShort);
  String get oneHour => _symbol.ONE_HOUR.get(enableShort);
  String get hours => _symbol.HOURS.get(enableShort);
  String get oneDay => _symbol.ONE_DAY.get(enableShort);
  String get days => _symbol.DAYS.get(enableShort);
  String get oneMonth => _symbol.ONE_MONTH.get(enableShort);
  String get months => _symbol.MONTHS.get(enableShort);
  String get suffix => _symbol.SUFFIX.get(enableShort);
  String get oneYear => _symbol.ONE_YEAR.get(enableShort);
  String get years => _symbol.YEARS.get(enableShort);
  String get separator => _symbol.SEPARATOR.get(enableShort);

  String _seconds(int second) {
    return second < 10 ? justnow : '$second$separator$seconds';
  }

  String _minutes(int minute) {
    return minute == 1 ? oneMinute : '$minute$separator$minutes';
  }

  String _hours(int hour) {
    return hour == 1 ? oneHour : '$hour$separator$hours';
  }

  String _days(int day) {
    return day == 1 ? oneDay : '$day$separator$days';
  }

  String _months(int month) {
    return month == 1 ? oneMonth : '$month$separator$months';
  }

  String _years(int year) {
    return year == 1 ? oneYear : '$year$separator$years';
  }

  String format() {
    var seconds = duration.inSeconds;
    final minutes = duration.inMinutes;
    final time = switch (minutes) {
      < 1 => _seconds(seconds),
      < 1 * 60 => _minutes(minutes),
      < 24 * 60 => _hours(duration.inHours),
      < 30 * 24 * 60 => _days(duration.inDays),
      < 365 * 24 * 60 => _months((duration.inDays / 30).floor()),
      _ => _years((duration.inDays / 365).floor())
    };
    return enableSuffix && seconds > 10 ? '$time $suffix' : time;
  }
}
