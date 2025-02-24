import 'dart:async';
import 'package:bloc_suite/bloc_suite.dart';
import 'package:test/test.dart';

Future<({T output, int ms})> asyncDelayCount<T>(Future<T> Function() fun) async {
  final start = DateTime.now();
  final output = await fun();
  final end = DateTime.now();
  return (output: output, ms: end.difference(start).inMilliseconds);
}

const delay = Duration(milliseconds: 30);

Future<void> wait() => Future.delayed(delay);
Future<void> tick() => Future.delayed(Duration.zero);

void main() {
  group('delay, debounce, skip & throttle transformers test', () {
    test('delay transformer', () async {
      final transformer = BlocEventTransformer.delay<int>(const Duration(milliseconds: 100));
      final input = Stream.periodic(const Duration(milliseconds: 50), (i) => i).take(5);
      final output = transformer(input, (event) => Stream.value(event));

      final result = await asyncDelayCount(() => output.toList());

      expect(result.ms > 350 && result.ms < 400, isTrue);
      expect(result.output, [0, 1, 2, 3, 4]);
    });

    test('debounce transformer', () async {
      final transformer = BlocEventTransformer.debounce<int>(const Duration(milliseconds: 500));
      var tests = [
        (count: 10, result: [9], time: 2500),
        (count: 5, result: [4], time: 1250),
        (count: 3, result: [2], time: 750),
      ];
      for (var test in tests) {
        final input = Stream.periodic(const Duration(milliseconds: 250), (i) => i).take(test.count);
        final output = transformer(input, (event) => Stream.value(event));
        final result = await asyncDelayCount(() => output.toList());
        expect(result.output, test.result);
        var processingMargin = 100;
        expect(
          result.ms >= test.time && result.ms < test.time + processingMargin,
          isTrue,
          reason: 'Expected:${test.time}\nActual:${result.ms}',
        );
      }
    });

    test('skip transformer', () async {
      final transformer = BlocEventTransformer.skip<int>(50);
      var list = List.generate(100, (i) => i);
      final input = Stream.fromIterable(list);
      final output = transformer(input, (event) => Stream.value(event));
      final result = await output.toList();
      expect(result, list.skip(50));
    });

    test('throttle transformer', () async {
      final transformer = BlocEventTransformer.throttle<int>(const Duration(milliseconds: 100));
      var tests = [
        (count: 10, result: [0, 2, 4, 6, 8], time: 1000),
        (count: 5, result: [0, 2, 4], time: 600),
        (count: 3, result: [0, 2], time: 400),
      ];
      for (var test in tests) {
        final input = Stream.periodic(const Duration(milliseconds: 100), (i) => i).take(test.count);
        final output = transformer(input, (event) => Stream.value(event));
        final result = await asyncDelayCount(() => output.toList());
        expect(result.output, test.result);
        var processingMargin = 50;
        expect(
          result.ms >= test.time && result.ms < test.time + processingMargin,
          isTrue,
          reason: 'Expected:${test.time}\nActual:${result.ms}',
        );
      }
    });
  });

  group('droppable transformer test', () {
    test('processes only the current event and ignores remaining', () async {
      final states = <int>[]; // To hold the results of the stream
      final controller = StreamController<int>.broadcast(); // Custom stream controller

      // Apply the droppable transformer to the stream
      final stream = BlocEventTransformer.droppable<int>()(controller.stream, (event) async* {
        await wait(); // Simulate a delay in processing
        yield event; // Emit the event after delay
      });

      final subscription = stream.listen(states.add); // Listen to the transformed stream

      controller
        ..add(1) // Processed
        ..add(2) // Dropped
        ..add(3); // Dropped

      await tick(); // Zero delay
      expect(states, equals([])); // Since no event should have been processed yet

      await wait(); // Wait for 30ms
      expect(states, equals([1])); // Only the first event should be processed

      /// ---- End ----

      // Add more events
      controller
        ..add(4) // Processed
        ..add(5) // Dropped
        ..add(6); // Dropped

      await tick();
      expect(states, equals([1])); // No event should have been processed yet

      await wait();
      expect(states, equals([1, 4])); // Only the 4th event should be processed

      controller
        ..add(7) // Processed
        ..add(8) // Dropped
        ..add(9); // Dropped

      await tick();
      expect(states, equals([1, 4])); // No event should have been processed yet

      await wait();
      expect(states, equals([1, 4, 7])); // Only the 7th event should be processed

      await subscription.cancel(); // Cancel the subscription when done
      await controller.close(); // Close the controller
    });

    test('cancels the mapped subscription when it is active.', () async {
      final states = <int>[];
      final controller = StreamController<int>.broadcast();
      final stream = BlocEventTransformer.droppable<int>()(controller.stream, (x) async* {
        await wait();
        yield x;
      });

      final subscription = stream.listen(states.add);

      controller.add(0);

      await wait();

      expect(states, isEmpty);
      expect(controller.hasListener, isTrue);

      await subscription.cancel();

      expect(states, isEmpty);
      expect(controller.hasListener, isFalse);

      await controller.close();

      expect(states, isEmpty);
    });
  });
}
