import 'package:dart_suite/dart_suite.dart';
import 'package:test/test.dart';

void main() {
  test('TimeAgo', () {
    var testCase = {
      5.seconds: ['just now', 'now', 'now'],
      30.minutes: ['30 minutes ago', '30m ago', '30m'],
      1.hours: ['an hour ago', '1h ago', '1h'],
      23.hours: ['23 hours ago', '23h ago', '23h'],
      1.days: ['a day ago', '1d ago', '1d'],
      12.days: ['12 days ago', '12d ago', '12d'],
      365.days: ['a year ago', '1yr ago', '1yr'],
      900.days: ['2 years ago', '2yr ago', '2yr'],
    };

    testCase.forEach((duration, expected) {
      var timeAgo = Timeago(duration);
      expect(timeAgo.format(), expected[0]);

      timeAgo.enableShort = true;
      expect(timeAgo.format(), expected[1]);

      timeAgo.enableSuffix = false;
      expect(timeAgo.format(), expected[2]);
    });
  });
}
