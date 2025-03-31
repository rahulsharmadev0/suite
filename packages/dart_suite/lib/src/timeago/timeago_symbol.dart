// ignore_for_file: non_constant_identifier_names

typedef TimeagoSymbolValue = ({String SHORT, String LONG});

class TimeagoSymbol {
  final TimeagoSymbolValue JUST_NOW;
  final TimeagoSymbolValue SECONDS;
  final TimeagoSymbolValue ONE_MINUTE;
  final TimeagoSymbolValue MINUTES;
  final TimeagoSymbolValue ONE_HOUR;
  final TimeagoSymbolValue HOURS;
  final TimeagoSymbolValue ONE_DAY;
  final TimeagoSymbolValue DAYS;
  final TimeagoSymbolValue ONE_MONTH;
  final TimeagoSymbolValue MONTHS;
  final TimeagoSymbolValue SUFFIX;
  final TimeagoSymbolValue ONE_YEAR;
  final TimeagoSymbolValue YEARS;
  final TimeagoSymbolValue SEPARATOR;

  const TimeagoSymbol(
      {required this.JUST_NOW,
      required this.SECONDS,
      required this.ONE_MINUTE,
      required this.MINUTES,
      required this.ONE_HOUR,
      required this.HOURS,
      required this.ONE_DAY,
      required this.DAYS,
      required this.ONE_MONTH,
      required this.MONTHS,
      required this.SUFFIX,
      required this.YEARS,
      required this.ONE_YEAR,
      required this.SEPARATOR});
}
