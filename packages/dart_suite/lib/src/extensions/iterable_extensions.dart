import 'dart:convert';
import 'dart:math' as math;
import 'package:crypto/crypto.dart' as crypto;

extension NullableIterableGettersExtensions<T> on Iterable<T?> {
  Iterable<T> get nonNulls {
    return [
      for (var e in this)
        if (e != null) e
    ];
  }

  Iterable<T> get tillFirstNull {
    final result = <T>[];
    for (var e in this) {
      if (e == null) break;
      result.add(e);
    }
    return result;
  }
}

extension IterableExtensions<T> on Iterable<T> {
  /// Returns the number of elements that matches the [test].\
  /// If not [test] is specified it will count every element.\
  /// Example:
  /// ```
  /// [1, 2, 3, 13, 14, 15].count();             // 6
  /// [1, 2, 3, 13, 14, 15].count((n) => n > 9); // 3
  /// ```
  int count([bool Function(T element)? test]) {
    if (test == null) return length;
    if (isEmpty) return 0;

    return map((element) => test(element) ? 1 : 0).reduce((value, element) => value + element);
  }

  bool anyOf(List<T> ls) {
    for (var e in ls) {
      if (contains(e)) return true;
    }
    return false;
  }

  /// Returns true if every element in [other] also exists in [this].
  ///
  /// Example:
  /// ```dart
  /// [1, 2, 3].containsAll([1, 2]); // true
  /// [1, 2].containsAll([1, 2, 3]); // false
  /// ```
  ///
  /// If [collapseDuplicates] is true, only the presence of a value will be
  /// considered, not the number of times it occurs. If [collapseDuplicates] is
  /// false, the number of occurrences of a given value in [this] must be
  /// greater than or equal to the number of occurrences of that value in
  /// [other] for the result to be true.
  ///
  /// Example:
  /// ```
  /// [1, 2, 3].containsAll([1, 1, 1, 2]); // true
  /// [1, 2, 3].containsAll([1, 1, 1, 2], collapseDuplicates: false); // false
  /// [1, 1, 2, 3].containsAll([1, 1, 2], collapseDuplicates: false); // true
  /// ```
  bool containsAll(Iterable<T> other, {bool collapseDuplicates = true}) {
    if (other.isEmpty) return true;
    if (collapseDuplicates) {
      return Set<T>.from(this).containsAll(Set<T>.from(other));
    }

    final thisElementCounts = _elementCountsIn<T>(this);
    final otherElementCounts = _elementCountsIn<T>(other);

    for (final element in otherElementCounts.keys) {
      final countInThis = thisElementCounts[element] ?? 0;
      final countInOther = otherElementCounts[element] ?? 0;
      if (countInThis < countInOther) {
        return false;
      }
    }
    return true;
  }

  /// Returns a random element or null
  T? getRandom({int skipFirst = 0}) {
    if (isEmpty || skipFirst >= length) return null;
    return elementAt(math.Random().nextInt(length - skipFirst) + skipFirst);
  }

  Map<E, int> _elementCountsIn<E>(Iterable<E> iterable) {
    final counts = <E, int>{};
    for (final element in iterable) {
      final currentCount = counts[element] ?? 0;
      counts[element] = currentCount + 1;
    }
    return counts;
  }

  /// Splits the elements into lists of the specified [size].
  ///
  /// You can specify an optional [fill] function that produces values
  /// that fill up the last chunk to match the chunk size.
  ///
  /// Example:
  /// ```dart
  /// [1, 2, 3, 4, 5, 6].chunked(2);        // [[1, 2], [3, 4], [5, 6]]
  /// [1, 2, 3].chunked(2);                 // [[1, 2], [3]]
  /// [1, 2, 3].chunked(2, fill: () => 99); // [[1, 2], [3, 99]]
  /// ```
  Iterable<List<T>> chunked(int size, {T Function()? fill}) {
    ArgumentError.checkNotNull(size, 'chunkSize');
    if (size <= 0) {
      throw ArgumentError('chunkSize must be positive integer greater than 0.');
    }

    if (isEmpty) {
      return const Iterable.empty();
    }

    final countOfChunks = (length / size.toDouble()).ceil();

    return Iterable.generate(countOfChunks, (int index) {
      final chunk = skip(index * size).take(size).toList();

      if (fill != null) {
        while (chunk.length < size) {
          chunk.add(fill());
        }
      }

      return chunk;
    });
  }

  /// Groups the elements of the list into a map by a key
  /// that is defined by a [keySelector] function.
  ///
  /// The optional [valueTransform] function can be used to
  /// remap your elements.
  ///
  /// Example:
  /// ```dart
  /// var map = [1, 2, 3, 97, 98, 99].groupBy((n) => n < 10 ? 'smallNumbers' : 'largeNumbers')
  /// // map = {'smallNumbers': [1, 2, 3], 'largeNumbers': [97, 98, 99]}
  /// ```
  ///
  /// ```dart
  /// List<Person> persons = [
  ///     Person(name: 'John', age: 21),
  ///     Person(name: 'Carl', age: 18),
  ///     Person(name: 'Peter', age: 56),
  ///     Person(name: 'Sarah', age: 61)
  /// ];
  /// var map = persons.groupBy((p) => p.age < 40 ? 'young' : 'old',
  ///        valueTransform: (p) => p.name);
  /// // map = {'young': ['John', 'Carl'], 'old': ['Peter', 'Sarah']}
  /// ```
  Map<K, List<V>> groupBy<K, V>(K Function(T element) keySelector, {V Function(T element)? valueTransform}) {
    ArgumentError.checkNotNull(keySelector);

    valueTransform ??= (element) => element as V;

    final map = <K, List<V>>{};

    forEach((element) {
      final key = keySelector(element);

      if (!map.containsKey(key)) {
        map[key] = [];
      }
      map[key]!.add(valueTransform!(element));
    });

    return map;
  }
}

/// Utility extension methods for [Iterable]s containing [num]s.
extension NumIterableBasics<E extends num> on Iterable<E> {
  /// Returns the greatest number in [this], or [null] if [this] is empty.
  ///
  /// Example:
  /// ```dart
  ///     [-47, 10, 2].max((a, b) =>
  ///     a.toString().length.compareTo(b.toString().length)).value; // -47
  /// ```
  E? max([Comparator<E>? compare]) =>
      isEmpty ? null : reduce(compare == null ? math.max : _generateCustomMaxFunction<E>(compare));

  /// Returns the least number in [this], or [null] if [this] is empty.
  ///
  /// Example:
  /// ```dart
  /// [-100, -200, 5].min((a, b) =>
  ///     a.toString().length.compareTo(b.toString().length)).value; // 5
  /// ```
  E? min([Comparator<E>? compare]) =>
      isEmpty ? null : reduce(compare == null ? math.min : _generateCustomMinFunction<E>(compare));

  /// Returns the sum of all the values in this iterable.
  ///
  /// Example:
  /// ```dart
  /// [1, 2, 3].sum(); // 6.
  /// [2, 3, 4].sum((i) => i * 0.5); // 4.5.
  /// [].sum() // 0.
  /// ```
  num sum([num Function(E)? addend]) {
    if (isEmpty) return 0;
    return addend == null
        ? reduce((a, b) => (a + b) as E)
        : fold(0, (prev, element) => prev + addend(element));
  }

  /// Returns the average of all the values in this iterable.
  ///
  /// Example:
  /// ```dart
  /// [2, 2, 4, 8].average(); // 4.
  /// [2, 2, 4, 8].average((i) => i + 1); // 5.
  /// [].average() // null.
  /// ```
  num? average([num Function(E)? value]) {
    if (isEmpty) return null;

    return sum(value) / length;
  }
}

T Function(T, T) _generateCustomMaxFunction<T>(Comparator<T> compare) {
  T max(T a, T b) {
    if (compare(a, b) >= 0) return a;
    return b;
  }

  return max;
}

T Function(T, T) _generateCustomMinFunction<T>(Comparator<T> compare) {
  T min(T a, T b) {
    if (compare(a, b) <= 0) return a;
    return b;
  }

  return min;
}

extension IntBasics<E extends int> on Iterable<E> {
  String get base64Encode => base64.encode(toList());

  String get utf8Decode => utf8.decode(toList());

  crypto.Digest get sha1 => crypto.sha1.convert(toList());
  crypto.Digest get sha224 => crypto.sha224.convert(toList());
  crypto.Digest get sha256 => crypto.sha256.convert(toList());
  crypto.Digest get sha512 => crypto.sha512.convert(toList());
  crypto.Digest get sha512224 => crypto.sha512224.convert(toList());
  crypto.Digest get sha512256 => crypto.sha512256.convert(toList());

  crypto.Digest get md5 => crypto.md5.convert(toList());
}
