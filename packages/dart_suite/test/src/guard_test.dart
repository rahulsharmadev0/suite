import 'package:dart_suite/dart_suite.dart';
import 'package:test/test.dart';

void main() {
  group('guardSafe Method Test Cases', () {
    test('guardSafe should return true if function succeeds', () {
      bool result = (() => true).guardSafe();
      expect(result, true);
    });

    test('guardSafe should return false if function throws an exception', () {
      bool result = (() => throw Exception()).guardSafe();
      expect(result, false);
    });

    test('guardSafe with reThrow=true should rethrow the exception', () {
      void function() => throw Exception('Test Exception');
      expect(() => function.guardSafe(reThrow: true), throwsException);
    });

    test('guardSafe with onError callback should invoke the callback on error',
        () {
      bool errorHandled = false;
      void onError(dynamic error) {
        errorHandled = true;
        print('Error handled: $error');
      }

      (() => throw Exception()).guardSafe(onError: onError);
      expect(errorHandled, true);
    });
  });

  group('guard Method Test Cases', () {
    test('guard should return function result if succeeds', () {
      int? result = (() => 42).guard(def: 0);
      expect(result, 42);
    });

    test('guard should return default value if function throws an exception',
        () {
      int? funTest() => throw Exception();
      int? result = funTest.guard(def: 1);
      expect(result, 1);
    });

    test('guard with reThrow=true should rethrow the exception', () {
      void function() => throw Exception('Test Exception');
      expect(() => function.guard(reThrow: true), throwsException);
    });

    test('guard with onError callback should invoke the callback on error', () {
      bool errorHandled = false;
      void onError(dynamic error) {
        errorHandled = true;
        print('Error handled: $error');
      }

      (() => throw Exception()).guard(def: null, onError: onError);
      expect(errorHandled, true);
    });
  });

  group('asyncGuard Method Test Cases', () {
    test('asyncGuard should return function result if succeeds', () async {
      Future<int> asyncFunction() async => 42;
      int? result = await asyncFunction.asyncGuard(def: 0);
      expect(result, 42);
    });

    test(
        'asyncGuard should return default value if function throws an exception',
        () async {
      Future<int> asyncFunction() async => throw Exception();
      int? result = await asyncFunction.asyncGuard(def: 0);
      expect(result, 0);
    });

    test('asyncGuard with reThrow=true should rethrow the exception', () async {
      Future<void> asyncFunction() async => throw Exception('Test Exception');
      expect(asyncFunction.asyncGuard(reThrow: true), throwsException);
    });

    test('asyncGuard with onError callback should invoke the callback on error',
        () async {
      bool errorHandled = false;
      void onError(dynamic error) {
        errorHandled = true;
        print('Error handled: $error');
      }

      Future<void> asyncFunction() async => throw Exception();
      await asyncFunction.asyncGuard(onError: onError);
      expect(errorHandled, true);
    });
  });
}
