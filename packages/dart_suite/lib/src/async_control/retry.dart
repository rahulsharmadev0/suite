import 'dart:async';
import 'dart:math' as math;

/// Enhanced retry policy configuration that wraps the retry package
class RetryPolicy {
  final int maxAttempts;
  final Duration initialDelay;
  final Duration maxDelay;
  final double backoffMultiplier;
  final List<Type> retryableExceptions;
  final bool randomizeDelay;

  const RetryPolicy({
    this.maxAttempts = 3,
    this.initialDelay = const Duration(milliseconds: 1000),
    this.maxDelay = const Duration(seconds: 30),
    this.backoffMultiplier = 2.0,
    this.retryableExceptions = const [],
    this.randomizeDelay = true,
  });

  /// Default retry policy for network operations
  static const RetryPolicy defaultPolicy = RetryPolicy(
    maxAttempts: 3,
    initialDelay: Duration(milliseconds: 1000),
    maxDelay: Duration(seconds: 10),
    backoffMultiplier: 2.0,
  );

  /// Aggressive retry policy for critical operations
  static const RetryPolicy aggressivePolicy = RetryPolicy(
    maxAttempts: 5,
    initialDelay: Duration(milliseconds: 500),
    maxDelay: Duration(seconds: 30),
    backoffMultiplier: 1.5,
  );

  /// No retry policy
  static const RetryPolicy noRetry = RetryPolicy(maxAttempts: 1);

  /// Convert to retry package's RetryOptions
  Retry generateRetry() => Retry(
        maxAttempts: maxAttempts,
        delayFactor: initialDelay,
        maxDelay: maxDelay,
        randomizationFactor: randomizeDelay ? 0.1 : 0.0,
      );
}

final _rand = math.Random();

/// Object holding options for retrying a function.
///
/// With the default configuration functions will be retried up-to 7 times
/// (8 attempts in total), sleeping 1st, 2nd, 3rd, ..., 7th attempt:
///  1. 400 ms +/- 25%
///  2. 800 ms +/- 25%
///  3. 1600 ms +/- 25%
///  4. 3200 ms +/- 25%
///  5. 6400 ms +/- 25%
///  6. 12800 ms +/- 25%
///  7. 25600 ms +/- 25%
///
/// **Example**
/// ```dart
/// final r = Retry();
/// final response = await r.execute(
///   // Make a GET request
///   () => http.get('https://google.com').timeout(Duration(seconds: 5)),
///   // Retry on SocketException or TimeoutException
///   retryIf: (e) => e is SocketException || e is TimeoutException,
/// );
/// print(response.body);
/// ```
final class Retry {
  /// Delay factor to double after every attempt.
  ///
  /// Defaults to 200 ms, which results in the following delays:
  ///
  ///  1. 400 ms
  ///  2. 800 ms
  ///  3. 1600 ms
  ///  4. 3200 ms
  ///  5. 6400 ms
  ///  6. 12800 ms
  ///  7. 25600 ms
  ///
  /// Before application of [randomizationFactor].
  final Duration delayFactor;

  /// Percentage the delay should be randomized, given as fraction between
  /// 0 and 1.
  ///
  /// If [randomizationFactor] is `0.25` (default) this indicates 25 % of the
  /// delay should be increased or decreased by 25 %.
  final double randomizationFactor;

  /// Maximum delay between retries, defaults to 30 seconds.
  final Duration maxDelay;

  /// Maximum number of attempts before giving up, defaults to 8.
  final int maxAttempts;

  /// Create a set of [Retry].
  ///
  /// Defaults to 8 attempts, sleeping as following after 1st, 2nd, 3rd, ...,
  /// 7th attempt:
  ///  1. 400 ms +/- 25%
  ///  2. 800 ms +/- 25%
  ///  3. 1600 ms +/- 25%
  ///  4. 3200 ms +/- 25%
  ///  5. 6400 ms +/- 25%
  ///  6. 12800 ms +/- 25%
  ///  7. 25600 ms +/- 25%
  const Retry({
    this.delayFactor = const Duration(milliseconds: 200),
    this.randomizationFactor = 0.25,
    this.maxDelay = const Duration(seconds: 30),
    this.maxAttempts = 8,
  });

  /// Delay after [attempt] number of attempts.
  ///
  /// This is computed as `pow(2, attempt) * delayFactor`, then is multiplied by
  /// between `-randomizationFactor` and `randomizationFactor` at random.
  Duration delay(int attempt) {
    assert(attempt >= 0, 'attempt cannot be negative');
    if (attempt <= 0) {
      return Duration.zero;
    }
    final rf = (randomizationFactor * (_rand.nextDouble() * 2 - 1) + 1);
    final exp = math.min(attempt, 31); // prevent overflows.
    final delay = (delayFactor * math.pow(2.0, exp) * rf);
    return delay < maxDelay ? delay : maxDelay;
  }

  /// Call [fn] retrying so long as [retryIf] return `true` for the exception
  /// thrown.
  ///
  /// At every execute the [onRetry] function will be called (if given). The
  /// function [fn] will be invoked at-most [this.attempts] times.
  ///
  /// If no [retryIf] function is given this will execute any for any [Exception]
  /// thrown. To execute on an [Error], the error must be caught and _rethrown_
  /// as an [Exception].
  Future<T> execute<T>(
    FutureOr<T> Function() fn, {
    FutureOr<bool> Function(Exception)? retryIf,
    FutureOr<void> Function(Exception)? onRetry,
  }) async {
    var attempt = 0;
    // ignore: literal_only_boolean_expressions
    while (true) {
      attempt++; // first invocation is the first attempt
      try {
        return await fn();
      } on Exception catch (e) {
        if (attempt >= maxAttempts || (retryIf != null && !(await retryIf(e)))) {
          rethrow;
        }
        if (onRetry != null) {
          await onRetry(e);
        }
      }

      // Sleep for a delay
      await Future.delayed(delay(attempt));
    }
  }

  /// Execute operation with retry logic using the retry package
  static Future<T> executeWithPolicy<T>(
    Future<T> Function() operation, {
    RetryPolicy policy = RetryPolicy.defaultPolicy,
    FutureOr<bool> Function(Exception)? retryIf,
    FutureOr<void> Function(Exception)? onRetry,
  }) =>
      policy.generateRetry().execute(operation, retryIf: retryIf, onRetry: onRetry);
}

/// Call [fn] retrying so long as [retryIf] return `true` for the exception
/// thrown, up-to [maxAttempts] times.
///
/// Defaults to 8 attempts, sleeping as following after 1st, 2nd, 3rd, ...,
/// 7th attempt:
///  1. 400 ms +/- 25%
///  2. 800 ms +/- 25%
///  3. 1600 ms +/- 25%
///  4. 3200 ms +/- 25%
///  5. 6400 ms +/- 25%
///  6. 12800 ms +/- 25%
///  7. 25600 ms +/- 25%
///
/// ```dart
/// final response = await execute(
///   // Make a GET request
///   () => http.get('https://google.com').timeout(Duration(seconds: 5)),
///   // Retry on SocketException or TimeoutException
///   retryIf: (e) => e is SocketException || e is TimeoutException,
/// );
/// print(response.body);
/// ```
///
/// If no [retryIf] function is given this will execute any for any [Exception]
/// thrown. To execute on an [Error], the error must be caught and _rethrown_
/// as an [Exception].
Future<T> retry<T>(
  FutureOr<T> Function() fn, {
  Duration delayFactor = const Duration(milliseconds: 200),
  double randomizationFactor = 0.25,
  Duration maxDelay = const Duration(seconds: 30),
  int maxAttempts = 8,
  FutureOr<bool> Function(Exception)? retryIf,
  FutureOr<void> Function(Exception)? onRetry,
}) =>
    Retry(
      delayFactor: delayFactor,
      randomizationFactor: randomizationFactor,
      maxDelay: maxDelay,
      maxAttempts: maxAttempts,
    ).execute(fn, retryIf: retryIf, onRetry: onRetry);

Future<T> retryWithPolicy<T>(
  Future<T> Function() fn, {
  RetryPolicy policy = RetryPolicy.defaultPolicy,
  FutureOr<bool> Function(Exception)? retryIf,
  FutureOr<void> Function(Exception)? onRetry,
}) =>
    policy.generateRetry().execute(fn, retryIf: retryIf, onRetry: onRetry);

extension RetryExtension<T> on FutureOr<T> Function() {
  /// Converts this into a [Retry] function.
  Future<T> execute({
    Duration delayFactor = const Duration(milliseconds: 200),
    double randomizationFactor = 0.25,
    Duration maxDelay = const Duration(seconds: 30),
    int maxAttempts = 8,
    FutureOr<bool> Function(Exception)? retryIf,
    FutureOr<void> Function(Exception)? onRetry,
  }) =>
      Retry(
        delayFactor: delayFactor,
        randomizationFactor: randomizationFactor,
        maxDelay: maxDelay,
        maxAttempts: maxAttempts,
      ).execute(this, retryIf: retryIf, onRetry: onRetry);

  /// Converts this into a [RetryPolicy] function.
  Future<T> executeWithPolicy({
    RetryPolicy policy = RetryPolicy.defaultPolicy,
    FutureOr<bool> Function(Exception)? retryIf,
    FutureOr<void> Function(Exception)? onRetry,
  }) =>
      policy.generateRetry().execute(this, retryIf: retryIf, onRetry: onRetry);
}
