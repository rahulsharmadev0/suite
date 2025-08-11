import 'package:test/test.dart';
import 'package:dart_suite/dart_suite.dart';

void main() {
  group('Debounce', () {
    test('should debounce function calls', () async {
      var callCount = 0;
      String? lastValue;

      void testFunction(String value) {
        callCount++;
        lastValue = value;
      }

      final debouncedFunction = debounce(
        testFunction,
        const Duration(milliseconds: 100),
      );

      // Make multiple calls in quick succession
      debouncedFunction.execute(['first']);
      debouncedFunction.execute(['second']);
      debouncedFunction.execute(['third']);

      // Should not have been called yet
      expect(callCount, equals(0));
      expect(lastValue, isNull);

      // Wait for debounce delay
      await Future.delayed(const Duration(milliseconds: 150));

      // Should have been called only once with the last value
      expect(callCount, equals(1));
      expect(lastValue, equals('third'));
    });

    test('should support leading edge invocation', () async {
      var callCount = 0;
      String? lastValue;

      void testFunction(String value) {
        callCount++;
        lastValue = value;
      }

      final debouncedFunction = debounce(
        testFunction,
        const Duration(milliseconds: 100),
        leading: true,
        trailing: false,
      );

      // Make multiple calls in quick succession
      debouncedFunction.execute(['first']);
      debouncedFunction.execute(['second']);
      debouncedFunction.execute(['third']);

      // Should have been called immediately with the first value
      expect(callCount, equals(1));
      expect(lastValue, equals('first'));

      // Wait for debounce delay
      await Future.delayed(const Duration(milliseconds: 150));

      // Should still be called only once
      expect(callCount, equals(1));
      expect(lastValue, equals('first'));
    });

    test('should support both leading and trailing edge', () async {
      var callCount = 0;
      final values = <String>[];

      void testFunction(String value) {
        callCount++;
        values.add(value);
      }

      final debouncedFunction = debounce(
        testFunction,
        const Duration(milliseconds: 100),
        leading: true,
        trailing: true,
      );

      // Make multiple calls in quick succession
      debouncedFunction.execute(['first']);
      
      // Should be called immediately (leading edge)
      expect(callCount, equals(1));
      expect(values, equals(['first']));

      debouncedFunction.execute(['second']);
      debouncedFunction.execute(['third']);

      // Wait for debounce delay
      await Future.delayed(const Duration(milliseconds: 150));

      // Should be called again with the last value (trailing edge)
      expect(callCount, equals(2));
      expect(values, equals(['first', 'third']));
    });

    test('should support maxWait option', () async {
      var callCount = 0;
      final values = <String>[];

      void testFunction(String value) {
        callCount++;
        values.add(value);
      }

      final debouncedFunction = debounce(
        testFunction,
        const Duration(milliseconds: 100),
        maxWait: const Duration(milliseconds: 200),
      );

      // Make calls that would normally be debounced
      debouncedFunction.execute(['first']);
      await Future.delayed(const Duration(milliseconds: 50));
      
      debouncedFunction.execute(['second']);
      await Future.delayed(const Duration(milliseconds: 50));
      
      debouncedFunction.execute(['third']);
      await Future.delayed(const Duration(milliseconds: 50));
      
      debouncedFunction.execute(['fourth']);

      // Should be called due to maxWait
      await Future.delayed(const Duration(milliseconds: 100));
      expect(callCount, equals(1));
      expect(values.last, equals('fourth'));
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

      final debouncedFunction = debounce(
        testFunction,
        const Duration(milliseconds: 100),
      );

      debouncedFunction.execute(['test'], {#flag: true});

      await Future.delayed(const Duration(milliseconds: 150));

      expect(callCount, equals(1));
      expect(positionalArg, equals('test'));
      expect(namedArg, isTrue);
    });

    test('should cancel pending invocations', () async {
      var callCount = 0;

      void testFunction() {
        callCount++;
      }

      final debouncedFunction = debounce(
        testFunction,
        const Duration(milliseconds: 100),
      );

      debouncedFunction.execute();
      expect(debouncedFunction.isPending, isTrue);

      debouncedFunction.cancel();
      expect(debouncedFunction.isPending, isFalse);

      await Future.delayed(const Duration(milliseconds: 150));

      expect(callCount, equals(0));
    });

    test('should flush pending invocations immediately', () async {
      var callCount = 0;
      String? lastValue;

      void testFunction(String value) {
        callCount++;
        lastValue = value;
      }

      final debouncedFunction = debounce(
        testFunction,
        const Duration(milliseconds: 100),
      );

      debouncedFunction.execute(['test']);
      expect(debouncedFunction.isPending, isTrue);

      debouncedFunction.flush();
      expect(debouncedFunction.isPending, isFalse);
      expect(callCount, equals(1));
      expect(lastValue, equals('test'));
    });

    test('should work with zero duration', () async {
      var callCount = 0;

      void testFunction() {
        callCount++;
      }

      final debouncedFunction = debounce(
        testFunction,
        Duration.zero,
      );

      debouncedFunction.execute();
      debouncedFunction.execute();
      debouncedFunction.execute();

      // Wait for next tick
      await Future.delayed(Duration.zero);

      expect(callCount, equals(1));
    });

    test('should return the result of the function', () async {
      String testFunction(String input) {
        return 'processed: $input';
      }

      final debouncedFunction = debounce(
        testFunction,
        const Duration(milliseconds: 100),
      );

      debouncedFunction.execute(['test']);
      await Future.delayed(const Duration(milliseconds: 150));

      // The result should be available after the function executes
      final flushResult = debouncedFunction.flush();
      expect(flushResult, equals('processed: test'));
    });

    test('should work with extension method', () async {
      var callCount = 0;

      void testFunction() {
        callCount++;
      }

      final debouncedFunction = testFunction.debounced(
        const Duration(milliseconds: 100),
      );

      debouncedFunction.execute();
      debouncedFunction.execute();

      await Future.delayed(const Duration(milliseconds: 150));

      expect(callCount, equals(1));
    });

    test('should handle async functions', () async {
      var callCount = 0;

      Future<String> asyncFunction(String input) async {
        callCount++;
        await Future.delayed(const Duration(milliseconds: 10));
        return 'async: $input';
      }

      final debouncedFunction = debounce(
        asyncFunction,
        const Duration(milliseconds: 100),
      );

      debouncedFunction.execute(['test']);
      await Future.delayed(const Duration(milliseconds: 150));

      expect(callCount, equals(1));
    });

    test('should handle multiple rapid calls correctly', () async {
      var callCount = 0;
      final callTimes = <DateTime>[];

      void testFunction() {
        callCount++;
        callTimes.add(DateTime.now());
      }

      final debouncedFunction = debounce(
        testFunction,
        const Duration(milliseconds: 100),
      );

      // Make 10 rapid calls
      for (int i = 0; i < 10; i++) {
        debouncedFunction.execute();
        await Future.delayed(const Duration(milliseconds: 10));
      }

      await Future.delayed(const Duration(milliseconds: 150));

      // Should only be called once despite 10 calls
      expect(callCount, equals(1));
      expect(callTimes.length, equals(1));
    });

    test('isPending should return correct status', () async {
      void testFunction() {}

      final debouncedFunction = debounce(
        testFunction,
        const Duration(milliseconds: 100),
      );

      expect(debouncedFunction.isPending, isFalse);

      debouncedFunction.execute();
      expect(debouncedFunction.isPending, isTrue);

      await Future.delayed(const Duration(milliseconds: 150));
      expect(debouncedFunction.isPending, isFalse);
    });
  });
}
