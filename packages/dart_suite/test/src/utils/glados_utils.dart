import 'package:dart_suite/src/optional/optional.dart';
import 'package:glados/glados.dart';

extension AnyOption on Any {
  /// `glados` [Generator] for [Optional] of any type [T], given
  /// a generator for type [T].
  ///
  /// `ratioNone` defines the ratio of [Absent] in the test (default 10%).
  Generator<Optional<T>> optionGenerator<T>(
    Generator<T> source, {
    double ratioNone = 0.1,
  }) =>
      (random, size) => (random.nextDouble() > ratioNone
          ? source.map(present)
          : source.map((value) => absent<T>()))(random, size);

  /// [Generator] for `Optional<int>`
  Generator<Optional<int>> get optionInt => optionGenerator(any.int);

  /// [Generator] for `Optional<double>`
  Generator<Optional<double>> get optionDouble => optionGenerator(any.double);

  /// [Generator] for `Optional<String>`
  Generator<Optional<String>> get optionString =>
      optionGenerator(any.letterOrDigits);
}
