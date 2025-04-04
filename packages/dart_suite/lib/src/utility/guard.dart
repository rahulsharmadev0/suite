import 'dart:async';

import 'package:dart_suite/src/utility.dart';

/// {@macro guard_function}
T? guard<T>(T Function() callback,
    {T? def, bool reThrow = false, void Function(dynamic error)? onError}) {
  return callback.guard(def: def, reThrow: reThrow, onError: onError);
}

/// {@macro async_guard_function}
Future<T?> asyncGuard<T>(Future<T> Function() callback,
        {T? def,
        bool reThrow = false,
        void Function(dynamic error)? onError}) =>
    callback.asyncGuard(def: def, reThrow: reThrow, onError: onError);

/// {@macro guard_safe}
bool guardSafe(void Function() callback,
        {bool reThrow = false, void Function(dynamic error)? onError}) =>
    callback.guardSafe(reThrow: reThrow, onError: onError);

/// {@macro async_guard_function}
Future<bool> asyncGuardSafe(Future Function() callback,
        {bool reThrow = false, void Function(dynamic error)? onError}) =>
    callback.asyncGuardSafe(reThrow: reThrow, onError: onError);

extension GuardFunctionExt<T> on T Function() {
  /// {@template guard_safe}
  /// Executes a synchronous function and returns a boolean indicating success or failure.
  /// Returns true if the function executes without throwing, false otherwise.
  ///
  /// Example:
  /// ```dart
  /// final success = guardSafe(
  ///   () => File('example.txt').deleteSync(),
  ///   onError: (e) => print('Failed to delete file: $e'),
  /// ); // returns false if file doesn't exist
  /// ```
  /// {@endtemplate}
  bool guardSafe({
    bool reThrow = false,
    void Function(dynamic error)? onError,
  }) {
    try {
      this();
      return true;
    } catch (error) {
      if (onError != null) onError(error);
      if (reThrow) rethrow;
      return false;
    }
  }

  /// {@template guard_function}
  /// Wraps a synchronous function with try/catch and provides a safe way to handle exceptions.
  /// Returns the function's result or a default value if an error occurs or the result is null.
  ///
  /// Example:
  /// ```dart
  /// final result = guard(
  ///   () => int.parse('invalid'), // This will throw
  ///   def: -1,
  ///   onError: (e) => print('Error: $e'),
  /// ); // returns -1
  ///
  /// final safeResult = guard(
  ///   () => int.parse('42'),
  ///   def: -1,
  /// ); // returns 42
  /// ```
  /// {@endtemplate}
  T? guard({
    T? def,
    bool reThrow = false,
    void Function(dynamic error)? onError,
  }) {
    try {
      return this() ?? def;
    } catch (err) {
      if (onError != null) onError(err);
      if (reThrow) rethrow;
      return def;
    }
  }
}

extension AsyncGuardFunctionExt<T> on FutureOr<T> Function() {
  /// {@template async_guard_function}
  /// Wraps an asynchronous function with try/catch and provides a safe way to handle exceptions.
  /// Returns the function's result or a default value if an error occurs or the result is null.
  ///
  /// Example:
  /// ```dart
  /// final result = await asyncGuard(
  ///   () async => await Future.delayed(
  ///     Duration(seconds: 1),
  ///     () => throw Exception('Network error'),
  ///   ),
  ///   def: 'offline',
  ///   onError: (e) => print('Error: $e'),
  /// ); // returns 'offline'
  /// ```
  /// {@endtemplate}
  Future<T?> asyncGuard({
    T? def,
    bool reThrow = false,
    void Function(dynamic error)? onError,
  }) async {
    try {
      return await this() ?? def;
    } catch (err) {
      if (onError != null) onError(err);
      if (reThrow) rethrow;
      return def;
    }
  }

  /// {@template async_guard_safe}
  /// Executes an asynchronous function and returns a boolean indicating success or failure.
  /// Returns true if the function executes without throwing, false otherwise.
  ///
  /// Example:
  /// ```dart
  /// final success = await asyncGuardSafe(
  ///   () => Future.delayed(
  ///     Duration(seconds: 1),
  ///     () => print('Operation completed'),
  ///   ),
  ///   onError: (e) => print('Operation failed: $e'),
  /// );
  /// ```
  /// {@endtemplate}
  Future<bool> asyncGuardSafe({
    bool reThrow = false,
    void Function(dynamic error)? onError,
  }) async {
    try {
      await this();
      return true;
    } catch (error) {
      if (onError != null) onError(error);
      if (reThrow) rethrow;
      return false;
    }
  }
}
