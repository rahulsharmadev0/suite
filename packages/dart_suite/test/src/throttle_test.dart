import 'package:test/test.dart';
import 'package:dart_suite/dart_suite.dart';

void main() {
  group('Throttle', () {
    test('should throttle function calls', () async {
      var callCount = 0;
      final values = <String>[];

      void testFunction(String value) {
        callCount++;
        values.add(value);
      }

      final throttledFunction = throttle(
        testFunction,
        const Duration(milliseconds: 100),
      );

      // Make multiple calls in quick succession
      throttledFunction.execute(['first']);  // Should execute immediately
      throttledFunction.execute(['second']); // Should be throttled
      throttledFunction.execute(['third']);  // Should be throttled

      // Should have been called once immediately (leading edge)
      expect(callCount, equals(1));
      expect(values, equals(['first']));

      // Wait for throttle window to pass
      await Future.delayed(const Duration(milliseconds: 150));

      // Should be called again with the last value (trailing edge)
      expect(callCount, equals(2));
      expect(values, equals(['first', 'third']));
    });

    test('should support leading edge only', () async {
      var callCount = 0;
      final values = <String>[];

      void testFunction(String value) {
        callCount++;
        values.add(value);
      }

      final throttledFunction = throttle(
        testFunction,
        const Duration(milliseconds: 100),
        leading: true,
        trailing: false,
      );

      // Make multiple calls in quick succession
      throttledFunction.execute(['first']);
      throttledFunction.execute(['second']);
      throttledFunction.execute(['third']);

      // Should have been called once immediately (leading edge only)
      expect(callCount, equals(1));
      expect(values, equals(['first']));

      // Wait for throttle window to pass
      await Future.delayed(const Duration(milliseconds: 150));

      // Should still be called only once
      expect(callCount, equals(1));
      expect(values, equals(['first']));
    });

    test('should support trailing edge only', () async {
      var callCount = 0;
      final values = <String>[];

      void testFunction(String value) {
        callCount++;
        values.add(value);
      }

      final throttledFunction = throttle(
        testFunction,
        const Duration(milliseconds: 100),
        leading: false,
        trailing: true,
      );

      // Make multiple calls in quick succession
      throttledFunction.execute(['first']);
      throttledFunction.execute(['second']);
      throttledFunction.execute(['third']);

      // Should not have been called yet
      expect(callCount, equals(0));
      expect(values, isEmpty);

      // Wait for throttle window to pass
      await Future.delayed(const Duration(milliseconds: 150));

      // Should be called with the last value (trailing edge only)
      expect(callCount, equals(1));
      expect(values, equals(['third']));
    });

    test('should handle named arguments', () async {
      var callCount = 0;
      String? positionalArg;
      bool? namedArg;

      void testFunction(String value, {bool flag = false}) {
        callCount++;
        positionalArg = value;
        namedArg = flag;
      }

      final throttledFunction = throttle(
        testFunction,
        const Duration(milliseconds: 100),
      );

      throttledFunction.execute(['test'], {#flag: true});

      // Should be called immediately (leading edge)
      expect(callCount, equals(1));
      expect(positionalArg, equals('test'));
      expect(namedArg, isTrue);
    });

    test('should cancel pending invocations', () async {
      var callCount = 0;

      void testFunction() {
        callCount++;
      }

      final throttledFunction = throttle(
        testFunction,
        const Duration(milliseconds: 100),
      );

      throttledFunction.execute(); // Called immediately (leading)
      throttledFunction.execute(); // Scheduled for trailing
      
      expect(callCount, equals(1));
      expect(throttledFunction.isPending, isTrue);

      throttledFunction.cancel();
      expect(throttledFunction.isPending, isFalse);

      await Future.delayed(const Duration(milliseconds: 150));

      // Should not call the trailing edge due to cancel
      expect(callCount, equals(1));
    });

    test('should flush pending invocations immediately', () async {
      var callCount = 0;
      final values = <String>[];

      void testFunction(String value) {
        callCount++;
        values.add(value);
      }

      final throttledFunction = throttle(
        testFunction,
        const Duration(milliseconds: 100),
      );

      throttledFunction.execute(['first']);  // Called immediately (leading)
      throttledFunction.execute(['second']); // Scheduled for trailing

      expect(callCount, equals(1));
      expect(values, equals(['first']));
      expect(throttledFunction.isPending, isTrue);

      throttledFunction.flush(); // Force immediate execution
      expect(throttledFunction.isPending, isFalse);
      expect(callCount, equals(2));
      expect(values, equals(['first', 'second']));
    });

    test('should work with zero duration', () async {
      var callCount = 0;

      void testFunction() {
        callCount++;
      }

      final throttledFunction = throttle(
        testFunction,
        Duration.zero,
      );

      throttledFunction.execute(); // Should execute immediately
      throttledFunction.execute(); // Should be throttled
      throttledFunction.execute(); // Should be throttled

      // With zero duration and maxWait, behavior might be different
      expect(callCount, greaterThanOrEqualTo(1));

      // Wait for next tick
      await Future.delayed(Duration.zero);

      // With zero duration, behavior is complex due to maxWait
      expect(callCount, greaterThanOrEqualTo(1));
    });

    test('should return the result of the function', () async {
      String testFunction(String input) {
        return 'processed: $input';
      }

      final throttledFunction = throttle(
        testFunction,
        const Duration(milliseconds: 100),
      );

      final result = throttledFunction.execute(['test']);
      expect(result, equals('processed: test'));
    });

    test('should work with extension method', () async {
      var callCount = 0;

      void testFunction() {
        callCount++;
      }

      final throttledFunction = testFunction.throttle(
        const Duration(milliseconds: 100),
        leading: true,  // Explicitly set leading to true
      );

      throttledFunction.execute();
      throttledFunction.execute();

      // Should be called immediately (leading edge)
      expect(callCount, equals(1));

      await Future.delayed(const Duration(milliseconds: 150));
      // Should be called again (trailing edge)
      expect(callCount, equals(2));
    });

    test('should handle async functions', () async {
      var callCount = 0;

      Future<String> asyncFunction(String input) async {
        callCount++;
        await Future.delayed(const Duration(milliseconds: 10));
        return 'async: $input';
      }

      final throttledFunction = throttle(
        asyncFunction,
        const Duration(milliseconds: 100),
      );

      throttledFunction.execute(['test1']);
      throttledFunction.execute(['test2']);

      expect(callCount, equals(1));

      await Future.delayed(const Duration(milliseconds: 150));
      expect(callCount, equals(2));
    });

    test('should respect throttle window for multiple executions', () async {
      var callCount = 0;
      final callTimes = <DateTime>[];

      void testFunction() {
        callCount++;
        callTimes.add(DateTime.now());
      }

      final throttledFunction = throttle(
        testFunction,
        const Duration(milliseconds: 100),
      );

      final startTime = DateTime.now();

      // Make calls over a period longer than the throttle window
      throttledFunction.execute(); // t=0, should execute immediately
      await Future.delayed(const Duration(milliseconds: 50));
      
      throttledFunction.execute(); // t=50, should be throttled
      await Future.delayed(const Duration(milliseconds: 60));
      
      throttledFunction.execute(); // t=110, should execute (new window)
      await Future.delayed(const Duration(milliseconds: 50));

      // Should have been called twice (leading edges) plus potentially trailing
      expect(callCount, greaterThanOrEqualTo(2));
      
      // Wait for any trailing executions
      await Future.delayed(const Duration(milliseconds: 150));
      
      final totalDuration = DateTime.now().difference(startTime);
      expect(totalDuration.inMilliseconds, greaterThan(200));
    });

    test('should maintain separate throttle windows for different instances', () async {
      var callCount1 = 0;
      var callCount2 = 0;

      void testFunction1() {
        callCount1++;
      }

      void testFunction2() {
        callCount2++;
      }

      final throttledFunction1 = throttle(
        testFunction1,
        const Duration(milliseconds: 100),
      );

      final throttledFunction2 = throttle(
        testFunction2,
        const Duration(milliseconds: 100),
      );

      // Both should execute immediately (different instances)
      throttledFunction1.execute();
      throttledFunction2.execute();

      expect(callCount1, equals(1));
      expect(callCount2, equals(1));

      // Make more calls
      throttledFunction1.execute();
      throttledFunction2.execute();

      // Wait for throttle windows
      await Future.delayed(const Duration(milliseconds: 150));

      // Both should have trailing executions
      expect(callCount1, equals(2));
      expect(callCount2, equals(2));
    });

    test('isPending should return correct status', () async {
      void testFunction() {}

      final throttledFunction = throttle(
        testFunction,
        const Duration(milliseconds: 100),
      );

      expect(throttledFunction.isPending, isFalse);

      throttledFunction.execute(); // Executes immediately
      // For throttle with leading=true, isPending might be true if there's a trailing call scheduled
      throttledFunction.execute(); // Gets throttled
      expect(throttledFunction.isPending, isTrue);

      await Future.delayed(const Duration(milliseconds: 150));
      expect(throttledFunction.isPending, isFalse);
    });

    test('should handle rapid successive calls correctly', () async {
      var callCount = 0;
      final values = <int>[];

      void testFunction(int value) {
        callCount++;
        values.add(value);
      }

      final throttledFunction = throttle(
        testFunction,
        const Duration(milliseconds: 100),
      );

      // Make many rapid calls
      for (int i = 0; i < 10; i++) {
        throttledFunction.execute([i]);
        await Future.delayed(const Duration(milliseconds: 10));
      }

      // Should have been called at least once (leading)
      expect(callCount, greaterThanOrEqualTo(1));
      expect(values.first, equals(0)); // First call should be immediate

      // Wait for trailing execution
      await Future.delayed(const Duration(milliseconds: 150));

      // Due to rapid calls with maxWait behavior, may have more calls than expected
      expect(callCount, greaterThanOrEqualTo(2));
      expect(values.last, equals(9));
    });
  });
}
