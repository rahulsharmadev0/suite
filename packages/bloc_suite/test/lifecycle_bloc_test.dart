import 'package:bloc/bloc.dart';
import 'package:bloc_suite/bloc_suite.dart';
import 'package:flutter_test/flutter_test.dart';

abstract class CounterEvent extends LifecycleEvent {
  CounterEvent({super.onCompleted, super.onError});
}

class Increment extends CounterEvent {
  Increment({super.onCompleted, super.onError});
}

class Decrement extends CounterEvent {
  Decrement({super.onCompleted, super.onError});
}

class CounterBloc extends LifecycleBloc<CounterEvent, int> {
  CounterBloc([
    EventTransformer<Increment>? incrementTransformer,
    EventTransformer<Decrement>? decrementTransformer,
  ]) : super(0) {
    on<Increment>((event, emit) async => emit(state + 1), transformer: incrementTransformer);
    on<Decrement>((event, emit) async => emit(state - 1), transformer: decrementTransformer);
  }
  void reset() => emit(0);
}

void main() {
  group('Simple CounterBloc', () {
    late CounterBloc counterBloc;

    setUp(() {
      counterBloc = CounterBloc();
    });

    tearDown(() async {
      await counterBloc.close();
    });

    test('initial state is 0', () {
      expect(counterBloc.state, 0);
    });

    test('onCompleted is called after event processing', () async {
      bool onCompletedCalled = false;

      void onCompleted() => onCompletedCalled = true;

      counterBloc.add(Increment(onCompleted: onCompleted));

      await Future.delayed(Duration.zero);

      expect(onCompletedCalled, isTrue);
    });

    test('increments state on Increment event', () async {
      counterBloc.add(Increment());

      await expectLater(counterBloc.stream, emits(1));
    });

    test('decrements state on Decrement event', () async {
      counterBloc.add(Decrement());

      await expectLater(counterBloc.stream, emits(-1));
    });

    test('handles multiple events in sequence', () async {
      counterBloc = CounterBloc();

      counterBloc.add(Increment());
      await expectLater(counterBloc.stream, emits(1));

      counterBloc.add(Increment());
      await expectLater(counterBloc.stream, emits(2));

      counterBloc.add(Increment());
      await expectLater(counterBloc.stream, emits(3));

      counterBloc.add(Decrement());
      await expectLater(counterBloc.stream, emits(2));
    });

    test('Bloc delay transformer', () async {
      final delay = const Duration(milliseconds: 500);
      counterBloc = CounterBloc(
        BlocEventTransformer.delay<Increment>(delay),
        BlocEventTransformer.delay<Decrement>(delay),
      );

      counterBloc.add(Increment());
      await Future.delayed(delay ~/ 2);
      expect(counterBloc.state, equals(0)); // Should still be 0 before delay completes

      await Future.delayed(delay);
      expect(counterBloc.state, equals(1)); // Should be 1 after delay

      counterBloc.add(Decrement());
      await Future.delayed(delay ~/ 2);
      expect(counterBloc.state, equals(1)); // Should still be 1 before delay completes

      await Future.delayed(delay);
      expect(counterBloc.state, equals(0)); // Should be 0 after delay
    });

    test('Bloc debounce transformer', () async {
      final debounce = const Duration(milliseconds: 500);
      counterBloc = CounterBloc(
        BlocEventTransformer.debounce<Increment>(debounce),
        BlocEventTransformer.debounce<Decrement>(debounce),
      );

      counterBloc.add(Increment());
      await Future.delayed(debounce ~/ 2);
      expect(counterBloc.state, equals(0)); // Should still be 0 before debounce completes

      await Future.delayed(debounce);
      expect(counterBloc.state, equals(1)); // Should be 1 after debounce

      counterBloc.add(Decrement());
      await Future.delayed(debounce ~/ 2);
      expect(counterBloc.state, equals(1)); // Should still be 1 before debounce completes

      await Future.delayed(debounce);
      expect(counterBloc.state, equals(0)); // Should be 0 after debounce
    });

    test('Bloc skip transformer', () async {
      counterBloc = CounterBloc(
        BlocEventTransformer.skip<Increment>(3),
        BlocEventTransformer.skip<Decrement>(3),
      );

      counterBloc.add(Increment());
      counterBloc.add(Increment());
      counterBloc.add(Increment());
      counterBloc.add(Increment());
      counterBloc.add(Decrement());
      counterBloc.add(Decrement());
      counterBloc.add(Decrement());
      counterBloc.add(Decrement());

      await expectLater(counterBloc.stream, emitsInOrder([1, 0]));
    });

    test('Bloc throttle transformer', () async {
      final throttle = const Duration(milliseconds: 500);

      counterBloc = CounterBloc(
        BlocEventTransformer.throttle<Increment>(throttle),
        BlocEventTransformer.throttle<Decrement>(throttle),
      );

      counterBloc.add(Increment()); // at 0s

      // Give enough time for the first event to be processed
      await Future.delayed(throttle + const Duration(milliseconds: 50));
      expect(counterBloc.state, equals(1)); // Should be 1

      counterBloc.add(Increment()); //? increment successfully
      counterBloc.add(Increment()); //! this event should be throttled
      await Future.delayed(throttle ~/ 2); // wait for 250ms
      expect(counterBloc.state, equals(2)); //! should be 2

      await Future.delayed(throttle * 2); // wait for 1000ms
      counterBloc.add(Decrement());
      await Future.delayed(Duration.zero); // due to async nature
      expect(counterBloc.state, equals(1)); //? Should be 1
    });
  });
}
