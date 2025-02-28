import 'package:bloc/bloc.dart';
import 'package:bloc_suite/bloc_suite.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

// Mock classes
class MockLogger extends Mock implements Logger {}

class MockBloc extends Mock implements Bloc {}

void main() {
  late MockLogger mockLogger;
  late FlutterBlocObserver observer;
  late MockBloc mockBloc;

  setUp(() {
    mockLogger = MockLogger();
    mockBloc = MockBloc();
    observer = FlutterBlocObserver(logger: mockLogger);
  });

  group('FlutterBlocObserver', () {
    test('logs event when printEvents is enabled', () {
      final event = 'TestEvent';
      observer.onEvent(mockBloc, event);

      verify(() => mockLogger.i(any())).called(1);
    });

    test('does not log event when printEvents is disabled', () {
      observer.copyWith(printEvents: false).onEvent(mockBloc, 'TestEvent');
      verifyNever(() => mockLogger.i(any()));
    });

    test('logs transition when printTransitions is enabled', () {
      final transition = Transition(
        currentState: 'StateA',
        event: 'EventA',
        nextState: 'StateB',
      );

      observer.onTransition(mockBloc, transition);
      verify(() => mockLogger.i(any())).called(1);
    });

    test('does not log transition when printTransitions is disabled', () {
      final transition = Transition(
        currentState: 'StateA',
        event: 'EventA',
        nextState: 'StateB',
      );

      observer
          .copyWith(printTransitions: false)
          .onTransition(mockBloc, transition);
      verifyNever(() => mockLogger.i(any()));
    });

    test('logs error with stack trace', () {
      final error = Exception('Test error');
      final stackTrace = StackTrace.current;

      observer.onError(mockBloc, error, stackTrace);
      verify(
        () => mockLogger.e(any(), error: error, stackTrace: stackTrace),
      ).called(1);
    });

    test('logs creation when printCreations is enabled', () {
      observer.copyWith(printCreations: true).onCreate(mockBloc);
      verify(() => mockLogger.i(any())).called(1);
    });

    test('does not log creation when printCreations is disabled', () {
      observer.copyWith(printCreations: false).onCreate(mockBloc);
      verifyNever(() => mockLogger.i(any()));
    });

    test('logs closing when printClosings is enabled', () {
      observer.copyWith(printClosings: true).onClose(mockBloc);
      verify(() => mockLogger.i(any())).called(1);
    });

    test('does not log closing when printClosings is disabled', () {
      observer.copyWith(printClosings: false).onClose(mockBloc);
      verifyNever(() => mockLogger.i(any()));
    });

    test('respects transitionFilter', () {
      final transition = Transition(
        currentState: 'StateA',
        event: 'EventA',
        nextState: 'StateB',
      );
      transitionFilter(bloc, transition) => false;
      observer
          .copyWith(transitionFilter: transitionFilter)
          .onTransition(mockBloc, transition);
      verifyNever(() => mockLogger.i(any()));
    });

    test('respects eventFilter', () {
      observer
          .copyWith(eventFilter: (bloc, event) => false)
          .onEvent(mockBloc, 'TestEvent');
      verifyNever(() => mockLogger.i(any()));
    });
  });
}
