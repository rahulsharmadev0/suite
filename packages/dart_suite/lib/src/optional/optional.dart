import 'package:dart_suite/dart_suite.dart';

part 'extension.dart';

/// Returns the given `a`.
///
/// Shortcut function to return the input parameter:
/// ```dart
/// final either = Either<String, int>.of(10);
///
/// /// Without using `identity`, you must write a function to return
/// /// the input parameter `(l) => l`.
/// final noId = either.match((l) => l, (r) => '$r');
///
/// /// Using `identity`, the function just returns its input parameter.
/// final withIdentity = either.match(identity, (r) => '$r');
/// ```
T identity<T>(T a) => a;

/// Return a `Present(t)`.
///
/// Shortcut for `Optional.of(r)`.
Optional<T> present<T>(T t) => Present(t);

/// Return a [Absent].
///
/// Shortcut for `Optional.absent()`.
Optional<T> absent<T>() => const Optional.absent();

/// Return an [Optional] containing `value` if not `null`, [Absent] otherwise.
/// If `predicate` is provided, return [Present] only if `predicate(value)` is `true
/// and `value` is not `null`, [Absent] otherwise.
/// ```dart
/// final Optional<String> mStr1 = optional('name'); // Present('name')
/// final Optional<String> mStr2 = optional(null); // Absent
/// final Optional<int> mInt1 = optional(10, (i) => i > 5 // Present(10)
/// final Optional<int> mInt2 = optional(3, (i) => i > 5); // Absent
/// ```
Optional<T> optional<T>([T? value, Predicate<T>? predicate]) =>
    Optional.of(value, predicate);

final class _OptionThrow {
  const _OptionThrow();
}

typedef DoAdapterOption = A Function<A>(Optional<A>);
A _doAdapter<A>(Optional<A> optional) =>
    optional.orElse(() => throw const _OptionThrow());

typedef DoFunctionOption<A> = A Function(DoAdapterOption $);

// `Optional<T> implements Functor<OptionHKT, T>` expresses correctly the
// return type of the `map` function as `HKT<OptionHKT, B>`.
// This tells us that the actual type parameter changed from `T` to `B`,
// according to the types `T` and `B` of the callable we actually passed as a parameter of `map`.
//
// Moreover, it informs us that we are still considering an higher kinded type
// with respect to the `OptionHKT` tag

/// A type that can contain a value of type `T` in a [Present] or no value with [Absent].
///
/// Used to represent type-safe missing values. Instead of using `null`, you define the type
/// to be [Optional]. In this way, you are required by the type system to handle the case in which
/// the value is missing.
/// ```dart
/// final Optional<String> mStr = Optional.of('name');
///
/// /// Using [Optional] you are required to specify every possible case.
/// /// The type system helps you to find and define edge-cases and avoid errors.
/// mStr.match(
///   () => print('I have no string to print 🤷‍♀️'),
///   printString,
/// );
/// ```
sealed class Optional<T> {
  const Optional();

  /// Initialize a **Do Notation** chain.
  // ignore: non_constant_identifier_names
  factory Optional.Do(DoFunctionOption<T> f) {
    try {
      return Optional.of(f(_doAdapter));
    } on _OptionThrow catch (_) {
      return const Optional.absent();
    }
  }

  /// Change the value of type `T` to a value of type `B` using function `f`.
  /// ```dart
  /// /// Change type `String` (`T`) to type `int` (`B`)
  /// final Optional<String> mStr = Optional.of('name');
  /// final Optional<int> mInt = mStr.map((a) => a.length);
  /// ```
  /// 👇
  /// ```dart
  /// [🥚].map((🥚) => 👨‍🍳(🥚)) -> [🍳]
  /// [_].map((🥚) => 👨‍🍳(🥚)) -> [_]
  /// ```
  Optional<B> map<B>(B Function(T t) f) => ap(pure(f));

  /// Apply the function contained inside `a` to change the value of type `T` to
  /// a value of type `B`.
  ///
  /// If `a` is [Absent], return [Absent].
  /// ```dart
  /// final a = Optional.of(10);
  /// final b = Optional.of(20);
  ///
  /// /// `map` takes one parameter [int] and returns `sumToDouble`.
  /// /// We therefore have a function inside a [Optional] that we want to
  /// /// apply to another value!
  /// final Optional<double Function(int)> map = a.map(
  ///   (a) => (int b) => sumToDouble(a, b),
  /// );
  ///
  /// /// Using `ap`, we get the final `Optional<double>` that we want 🚀
  /// final result = b.ap(map);
  /// ```

  Optional<B> ap<B>(covariant Optional<B Function(T t)> a) => a.match(
        () => Optional<B>.absent(),
        (f) => map(f),
      );

  /// Return a [Present] containing the value `b`.

  Optional<B> pure<B>(B b) => Present(b);

  /// Used to chain multiple functions that return a [Optional].
  ///
  /// You can extract the value of every [Optional] in the chain without
  /// handling all possible missing cases.
  /// If any of the functions in the chain returns [Absent], the result is [Absent].
  /// ```dart
  /// /// Using `flatMap`, you can forget that the value may be missing and just
  /// /// use it as if it was there.
  /// ///
  /// /// In case one of the values is actually missing, you will get a [Absent]
  /// /// at the end of the chain ⛓
  /// final a = Optional.of('name');
  /// final Optional<double> result = a.flatMap(
  ///   (s) => stringToInt(s).flatMap(
  ///     (i) => intToDouble(i),
  ///   ),
  /// );
  /// ```
  /// 👇
  /// ```dart
  /// final a = Optional.of(1);
  /// final inc = a.flatMap((x) => Optional.of(x + 1)); // Present(2)
  ///
  /// final none = Optional.absent<int>();
  /// final stillNone = none.flatMap((x) => Optional.of(x + 1)); // Absent
  ///
  /// // Chaining multiple flatMap calls
  /// final chained = Optional.of(1)
  ///     .flatMap((x) => Optional.of(x + 1))
  ///     .flatMap((y) => Optional.of(y * 2)); // Present(4)
  /// ```
  /// ```

  Optional<B> flatMap<B>(covariant Optional<B> Function(T t) f) =>
      match<Optional<B>>(() => Optional<B>.absent(), (t) => f(t));

  /// Return a new [Optional] that calls [Optional.of] on the result of of the given function [f].
  ///
  /// ```dart
  /// expect(
  ///   Optional.of(123).flatMapNullable((_) => null),
  ///   Optional.absent(),
  /// );
  ///
  /// expect(
  ///   Optional.of(123).flatMapNullable((_) => 456),
  ///   Optional.of(456),
  /// );
  /// ```
  Optional<B> flatMapNullable<B>(B? Function(T t) f) => flatMap((t) => Optional.of(f(t)));

  /// Return a new [Optional] that calls [Optional.tryCatch] with the given function [f].
  ///
  /// ```dart
  /// expect(
  ///   Optional.of(123).flatMapThrowable((_) => throw Exception()),
  ///   Optional.of(123).flatMapThrowable((_) => 456),
  ///   Optional.of(456),
  /// );
  /// ```
  Optional<B> flatMapThrowable<B>(B Function(T t) f) =>
      flatMap((t) => Optional.tryCatch(() => f(t)));

  /// Change the value of [Optional] from type `T` to type `Z` based on the
  /// value of `Optional<T>` using function `f`.

  Optional<Z> extend<Z>(Z Function(Optional<T> t) f) =>
      match<Optional<Z>>(() => Optional<Z>.absent(), (_) => Present(f(this)));

  /// Wrap this [Optional] inside another [Optional].

  Optional<Optional<T>> duplicate() => extend(identity);

  /// If this [Optional] is a [Present] and calling `f` returns `true`, then return this [Present].
  /// Otherwise return [Absent].

  Optional<T> filter(bool Function(T t) f) =>
      flatMap((t) => f(t) ? this : const Optional.absent());

  /// If this [Optional] is a [Present] and calling `f` returns [Present], then return this [Present].
  /// Otherwise return [Absent].

  Optional<Z> filterMap<Z>(Optional<Z> Function(T t) f) =>
      match<Optional<Z>>(() => Optional<Z>.absent(), (t) => f(t));

  /// Return a record. If this [Optional] is a [Present]:
  /// - if `f` applied to its value returns `true`, then the tuple contains this [Optional] as second value
  /// - if `f` applied to its value returns `false`, then the tuple contains this [Optional] as first value
  /// Otherwise the tuple contains both [Absent].
  (Optional<T>, Optional<T>) partition(bool Function(T t) f) =>
      (filter((a) => !f(a)), filter(f));

  /// If this [Optional] is a [Present], then return the result of calling `then`.
  /// Otherwise return [Absent].
  /// ```dart
  /// [🍌].andThen(() => [🍎]) -> [🍎]
  /// [_].andThen(() => [🍎]) -> [_]
  /// ```

  Optional<B> andThen<B>(covariant Optional<B> Function() then) => flatMap((_) => then());

  /// Change type of this [Optional] based on its value of type `T` and the
  /// value of type `C` of another [Optional].

  Optional<D> map2<C, D>(covariant Optional<C> mc, D Function(T t, C c) f) =>
      flatMap((a) => mc.map((c) => f(a, c)));

  /// Change type of this [Optional] based on its value of type `T`, the
  /// value of type `C` of a second [Optional], and the value of type `D`
  /// of a third [Optional].

  Optional<E> map3<C, D, E>(covariant Optional<C> mc, covariant Optional<D> md,
          E Function(T t, C c, D d) f) =>
      flatMap((a) => mc.flatMap((c) => md.map((d) => f(a, c, d))));

  /// {@template fpdart_option_match}
  /// Execute `onPresent` when value is [Present], otherwise execute `onAbsent`.
  /// {@endtemplate}
  /// ```dart
  /// [🍌].match(() => 🍎, (🍌) => 🍌 * 2) -> 🍌🍌
  /// [_].match(() => 🍎, (🍌) => 🍌 * 2) -> 🍎
  /// ```
  ///
  /// Same as `fold`.
  B match<B>(B Function() onAbsent, B Function(T t) onPresent) {
    // Use runtime type checks to dispatch to the correct branch.
    if (this is Present<T>) {
      // Accessing `.value` is safe because Present is defined in this library.
      return onPresent((this as Present<T>).value);
    }

    return onAbsent();
  }

  /// {@macro fpdart_option_match}
  /// ```dart
  /// [🍌].fold(() => 🍎, (🍌) => 🍌 * 2) -> 🍌🍌
  /// [_].fold(() => 🍎, (🍌) => 🍌 * 2) -> 🍎
  /// ```
  ///
  /// Same as `match`.
  B fold<B>(B Function() onAbsent, B Function(T t) onPresent) =>
      match(onAbsent, onPresent);

  /// Return `true` when value is [Present].
  bool get isPresent => match(() => false, (_) => true);

  /// Return `true` when value is [Absent].
  bool get isAbsent => match(() => true, (_) => false);

  /// Return value of type `T` when this [Optional] is a [Present], `null` otherwise.
  /// ```dart
  /// [🍌].get() -> 🍌
  /// [_].get() -> null
  /// ```
  T? get() => match<T?>(() => null, identity);

  /// If this [Optional] is a [Present] then return the value inside the [Optional].
  /// Otherwise return the result of `orElse`.
  /// ```dart
  /// [🍌].orElse(() => 🍎) -> 🍌
  /// [_].orElse(() => 🍎) -> 🍎
  ///
  ///  👆 same as 👇
  ///
  /// [🍌].match(() => 🍎, (🍌) => 🍌)
  /// ```
  T orElse(T Function() fallback) => match(fallback, identity);

  /// If this [Optional] is a [Present] then return the value inside the [Optional].
  /// ```dart
  /// [🍌].orElseGet(🍎) -> 🍌
  /// [_].orElseGet(🍎) -> 🍎
  /// ```
  T orElseGet(T value) => match(() => value, identity);

  /// Return the current [Optional] if it is a [Present], otherwise return the result of `orElse`.
  ///
  /// Used to provide an **alt**ernative [Optional] in case the current one is [Absent].
  /// ```dart
  /// [🍌].or(() => [🍎]) -> [🍌]
  /// [_].or(() => [🍎]) -> [🍎]
  /// ```
  Optional<T> or(Optional<T> Function() orElse) => this is Present<T> ? this : orElse();

  /// {@template fpdart_traverse_list_option}
  /// Map each element in the list to an [Optional] using the function `f`,
  /// and collect the result in an `Optional<List<B>>`.
  ///
  /// If any mapped element of the list is [Absent], then the final result
  /// will be [Absent].
  /// {@endtemplate}
  ///
  /// Same as `Optional.traverseList` but passing `index` in the map function.
  static Optional<List<B>> traverseListWithIndex<A, B>(
    List<A> list,
    Optional<B> Function(A a, int i) f,
  ) {
    final resultList = <B>[];
    for (var i = 0; i < list.length; i++) {
      final o = f(list[i], i);
      final r = o.match<B?>(() => null, identity);
      if (r == null) return absent();
      resultList.add(r);
    }

    return present(resultList);
  }

  /// {@macro fpdart_traverse_list_option}
  ///
  /// Same as `Optional.traverseListWithIndex` but without `index` in the map function.
  static Optional<List<B>> traverseList<A, B>(
          List<A> list, Optional<B> Function(A a) f) =>
      traverseListWithIndex<A, B>(list, (a, _) => f(a));

  /// {@template fpdart_sequence_list_option}
  /// Convert a `List<Optional<A>>` to a single `Optional<List<A>>`.
  ///
  /// If any of the [Optional] in the [List] is [Absent], then the result is [Absent].
  /// {@endtemplate}
  static Optional<List<A>> sequenceList<A>(List<Optional<A>> list) =>
      traverseList(list, identity);

  /// Return [Present] of `value` when `predicate` applied to `value` returns `true`,
  /// [Absent] otherwise.
  factory Optional.fromPredicate(T value, Predicate<T> predicate) =>
      predicate(value) ? Present(value) : Optional.absent();

  /// Return [Present] of type `B` by calling `f` with `value` when `predicate` applied to `value` is `true`,
  /// `Absent` otherwise.
  /// ```dart
  /// /// If the value of `str` is not empty, then return a [Present] containing
  /// /// the `length` of `str`, otherwise [Absent].
  /// Optional.fromPredicateMap<String, int>(
  ///   str,
  ///   (str) => str.isNotEmpty,
  ///   (str) => str.length,
  /// );
  /// ```
  static Optional<B> fromPredicateMap<A, B>(
          A value, Predicate<A> predicate, B Function(A a) f) =>
      predicate(value) ? Present(f(value)) : Optional.absent();

  /// Return a [Absent].
  const factory Optional.absent() = Absent;

  /// Flat a [Optional] contained inside another [Optional] to be a single [Optional].
  factory Optional.flatten(Optional<Optional<T>> m) => m.flatMap(identity);

  /// Return [Absent] if `a` is `null`, [Present] otherwise.
  factory Optional.of([T? value, Predicate<T>? predicate]) =>
      predicate != null && value != null
          ? Optional.fromPredicate(value, predicate)
          : (value == null ? Optional.absent() : Present(value));

  /// Try to run `f` and return `Present(a)` when no error are thrown, otherwise return `Absent`.
  factory Optional.tryCatch(T Function() f) {
    try {
      return Present(f());
    } catch (_) {
      return const Optional.absent();
    }
  }
}

class Present<T> extends Optional<T> {
  final T _value;
  const Present(this._value);

  /// Extract value of type `T` inside the [Present].
  T get value => _value;

  @override
  Optional<D> map2<C, D>(covariant Optional<C> mc, D Function(T t, C c) f) =>
      flatMap((a) => mc.map((c) => f(a, c)));

  @override
  Optional<E> map3<C, D, E>(covariant Optional<C> mc, covariant Optional<D> md,
          E Function(T t, C c, D d) f) =>
      flatMap((a) => mc.flatMap((c) => md.map((d) => f(a, c, d))));

  @override
  Optional<B> map<B>(B Function(T t) f) => Present(f(_value));

  @override
  Optional<B> flatMap<B>(covariant Optional<B> Function(T t) f) => f(_value);

  @override
  B match<B>(B Function() onAbsent, B Function(T t) onPresent) => onPresent(_value);

  @override
  Optional<Z> extend<Z>(Z Function(Optional<T> t) f) => Present(f(this));

  @override
  bool get isPresent => true;

  @override
  bool get isAbsent => false;

  @override
  Optional<T> filter(bool Function(T t) f) => f(_value) ? this : Optional.absent();

  @override
  Optional<Z> filterMap<Z>(Optional<Z> Function(T t) f) => f(_value).match(
        () => const Optional.absent(),
        Present.new,
      );

  @override
  T get() => _value;

  @override
  bool operator ==(Object other) =>
      other.runtimeType == runtimeType && other is Present<T> && other._value == _value;

  @override
  int get hashCode => _value.hashCode;

  @override
  String toString() => 'Present($_value)';
}

class Absent extends Optional<Never> {
  const Absent();

  @override
  Optional<D> map2<C, D>(covariant Optional<C> mc, D Function(Never t, C c) f) => this;

  @override
  Optional<E> map3<C, D, E>(
    covariant Optional<C> mc,
    covariant Optional<D> md,
    E Function(Never t, C c, D d) f,
  ) =>
      this;

  @override
  Optional<B> map<B>(B Function(Never t) f) => this;

  @override
  Optional<B> flatMap<B>(covariant Optional<B> Function(Never t) f) => this;

  @override
  B match<B>(B Function() onAbsent, B Function(Never t) onPresent) => onAbsent();

  @override
  Optional<Z> extend<Z>(Z Function(Optional<Never> t) f) => const Optional.absent();

  @override
  bool get isPresent => false;

  @override
  bool get isAbsent => true;

  @override
  Optional<Z> filterMap<Z>(Optional<Z> Function(Never t) f) => const Optional.absent();

  @override
  bool operator ==(Object other) => other is Absent;

  @override
  Null get() => null;

  @override
  int get hashCode => 0;

  @override
  String toString() => 'Absent';
}
