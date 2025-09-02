
part of 'optional.dart';


/// {@template fpdart_curry_extension}
/// Extract first parameter from this function to allow curring.
/// {@endtemplate}
///
/// {@template fpdart_curry_last_extension}
/// Extract **last** parameter from this function to allow curring.
/// {@endtemplate}

extension CurryExtension2<Input1, Input2, Output> on Output Function(
    Input1, Input2) {
  /// Convert this function from accepting two parameters to a function
  /// that returns another function both accepting one parameter.
  ///
  /// Inverse of `uncurry`.
  Output Function(Input2) Function(Input1) get curry =>
      (input1) => (input2) => this(input1, input2);

  /// Convert this function from accepting two parameters to a function
  /// that returns another function both accepting one parameter.
  ///
  /// Curry the **last** parameter in the function.
  Output Function(Input1) Function(Input2) get curryLast =>
      (input2) => (input1) => this(input1, input2);
}

extension UncurryExtension2<Input1, Input2, Output> on Output Function(Input2)
    Function(Input1) {
  /// Convert a function that returns another function to a single function
  /// accepting two parameters.
  ///
  /// Inverse of `curry`.
  Output Function(Input1, Input2) get uncurry =>
      (input1, input2) => this(input1)(input2);
}

extension CurryExtension3<Input1, Input2, Input3, Output> on Output Function(
    Input1, Input2, Input3) {
  /// Convert this function from accepting three parameters to a series
  /// of functions that all accept one parameter.
  ///
  /// Inverse of `uncurry`.
  Output Function(Input3) Function(Input2) Function(Input1) get curryAll =>
      (input1) => (input2) => (input3) => this(input1, input2, input3);

  /// {@macro fpdart_curry_extension}
  Output Function(Input2, Input3) Function(Input1) get curry =>
      (input1) => (input2, input3) => this(input1, input2, input3);

  /// {@macro fpdart_curry_last_extension}
  Output Function(Input1, Input2) Function(Input3) get curryLast =>
      (input3) => (input1, input2) => this(input1, input2, input3);
}

extension UncurryExtension3<Input1, Input2, Input3, Output>
    on Output Function(Input3) Function(Input2) Function(Input1) {
  /// Convert a function that returns a series of functions to a single function
  /// accepting three parameters.
  ///
  /// Inverse of `curry`.
  Output Function(Input1, Input2, Input3) get uncurry =>
      (input1, input2, input3) => this(input1)(input2)(input3);
}

extension CurryExtension4<Input1, Input2, Input3, Input4, Output> on Output
    Function(Input1, Input2, Input3, Input4) {
  /// Convert this function from accepting four parameters to a series
  /// of functions that all accept one parameter.
  ///
  /// Inverse of `uncurry`.
  Output Function(Input4) Function(Input3) Function(Input2) Function(Input1)
      get curryAll => (input1) => (input2) =>
          (input3) => (input4) => this(input1, input2, input3, input4);

  /// {@macro fpdart_curry_extension}
  Output Function(Input2, Input3, Input4) Function(Input1) get curry =>
      (input1) =>
          (input2, input3, input4) => this(input1, input2, input3, input4);

  /// {@macro fpdart_curry_last_extension}
  Output Function(Input1, Input2, Input3) Function(Input4) get curryLast =>
      (input4) =>
          (input1, input2, input3) => this(input1, input2, input3, input4);
}

extension UncurryExtension4<Input1, Input2, Input3, Input4, Output>
    on Output Function(Input4) Function(Input3) Function(Input2) Function(
        Input1) {
  /// Convert a function that returns a series of functions to a single function
  /// accepting four parameters.
  ///
  /// Inverse of `curry`.
  Output Function(Input1, Input2, Input3, Input4) get uncurry =>
      (Input1 input1, Input2 input2, Input3 input3, Input4 input4) =>
          this(input1)(input2)(input3)(input4);
}

extension CurryExtension5<Input1, Input2, Input3, Input4, Input5, Output>
    on Output Function(Input1, Input2, Input3, Input4, Input5) {
  /// Convert this function from accepting five parameters to a series
  /// of functions that all accept one parameter.
  ///
  /// Inverse of `uncurry`.
  Output Function(Input5) Function(Input4) Function(Input3) Function(Input2)
          Function(Input1)
      get curryAll => (input1) => (input2) => (input3) =>
          (input4) => (input5) => this(input1, input2, input3, input4, input5);

  /// {@macro fpdart_curry_extension}
  Output Function(Input2, Input3, Input4, Input5) Function(Input1) get curry =>
      (input1) => (input2, input3, input4, input5) =>
          this(input1, input2, input3, input4, input5);

  /// {@macro fpdart_curry_last_extension}
  Output Function(Input1, Input2, Input3, Input4) Function(Input5)
      get curryLast => (input5) => (input1, input2, input3, input4) =>
          this(input1, input2, input3, input4, input5);
}

extension UncurryExtension5<Input1, Input2, Input3, Input4, Input5, Output>
    on Output Function(Input5) Function(Input4) Function(Input3) Function(
            Input2)
        Function(Input1) {
  /// Convert a function that returns a series of functions to a single function
  /// accepting five parameters.
  ///
  /// Inverse of `curry`.
  Output Function(Input1, Input2, Input3, Input4, Input5) get uncurry =>
      (input1, input2, input3, input4, input5) =>
          this(input1)(input2)(input3)(input4)(input5);
}

/// {@template fpdart_iterable_extension_head}
/// Get the first element of the [Iterable].
/// If the [Iterable] is empty, return [Absent].
/// {@endtemplate}

/// Functional programming functions on a mutable dart [Iterable] using `fpdart`.
extension FpdartOnIterable<T> on Iterable<T> {
  /// {@macro fpdart_iterable_extension_head}
  ///
  /// Same as `firstOption`.
  Optional<T> get head {
    var it = iterator;
    if (it.moveNext()) return present(it.current);
    return const Absent();
  }

  /// {@macro fpdart_iterable_extension_head}
  ///
  /// Same as `head`.
  Optional<T> get firstOption => head;

  /// Get the last element of the [Iterable].
  /// If the [Iterable] is empty, return [Absent].
  ///
  /// **Note**: Because accessing the last element of an [Iterable] requires
  /// stepping through all the other elements, `lastOption` **can be slow**.
  Optional<T> get lastOption => isEmpty ? const Absent() : present(last);

  /// Return all the elements of a [Iterable] except the first one.
  /// If the [Iterable] is empty, return [Absent].
  ///
  /// **Notice**: This operation checks whether the iterable is empty
  /// at the time when the [Optional] is returned.
  /// The length of a non-empty iterable may change before the returned
  /// iterable is iterated. If this original iterable has become empty
  /// at that point, the returned iterable will also be empty, same
  /// as if this iterable has only one element.
  Optional<Iterable<T>> get tail => isEmpty ? const Absent() : present(skip(1));

  /// Returns the list of those elements that satisfy `test`.
  ///
  /// Equivalent to `Iterable.where`.
  Iterable<T> filter(bool Function(T t) test) => where(test);

  /// Returns the list of those elements that satisfy `test`.
  Iterable<T> filterWithIndex(bool Function(T t, int index) test) sync* {
    var index = 0;
    for (var value in this) {
      if (test(value, index)) {
        yield value;
      }
      index += 1;
    }
  }

  /// Extract all elements **starting from the first** as long as `test` returns `true`.
  ///
  /// Equivalent to `Iterable.takeWhile`.
  Iterable<T> takeWhileLeft(bool Function(T t) test) => takeWhile(test);

  /// Remove all elements **starting from the first** as long as `test` returns `true`.
  ///
  /// Equivalent to `Iterable.skipWhile`.
  Iterable<T> dropWhileLeft(bool Function(T t) test) => skipWhile(test);

  /// Return a record where first element is longest prefix (possibly empty) of this [Iterable]
  /// with elements that **satisfy** `test` and second element is the remainder of the [Iterable].
  (Iterable<T>, Iterable<T>) span(bool Function(T t) test) =>
      (takeWhile(test), skipWhile(test));

  /// Return a record where first element is an [Iterable] with the first `n` elements of this [Iterable],
  /// and the second element contains the rest of the [Iterable].
  (Iterable<T>, Iterable<T>) splitAt(int n) => (take(n), skip(n));

  /// Return the suffix of this [Iterable] after the first `n` elements.
  ///
  /// Equivalent to `Iterable.skip`.
  Iterable<T> drop(int n) => skip(n);

  /// Checks whether every element of this [Iterable] satisfies [test].
  ///
  /// Equivalent to `Iterable.every`.
  bool all(bool Function(T t) test) => every(test);

  /// Creates the lazy concatenation of this [Iterable] and `other`.
  ///
  /// Equivalent to `Iterable.followedBy`.
  Iterable<T> concat(Iterable<T> other) => followedBy(other);

  /// Insert `element` at the beginning of the [Iterable].
  Iterable<T> prepend(T element) sync* {
    yield element;
    yield* this;
  }

  /// Insert all the elements inside `other` at the beginning of the [Iterable].
  Iterable<T> prependAll(Iterable<T> other) => other.followedBy(this);

  /// Insert `element` at the end of the [Iterable].
  Iterable<T> append(T element) sync* {
    yield* this;
    yield element;
  }

  /// Check if `element` is contained inside this [Iterable].
  ///
  /// Equivalent to `Iterable.contains`.
  bool elem(T element) => contains(element);

  /// Check if `element` is **not** contained inside this [Iterable].
  bool notElem(T element) => !elem(element);



  /// Fold this [Iterable] into a single value by aggregating each element of the list
  /// **from the first to the last**.
  ///
  /// Equivalent to `Iterable.fold`.
  B foldLeft<B>(B initialValue, B Function(B b, T t) combine) =>
      fold(initialValue, combine);

  /// Same as `foldLeft` (`fold`) but provides also the `index` of each mapped
  /// element in the `combine` function.
  B foldLeftWithIndex<B>(
    B initialValue,
    B Function(B previousValue, T element, int index) combine,
  ) {
    var index = 0;
    var value = initialValue;
    for (var element in this) {
      value = combine(value, element, index);
      index += 1;
    }
    return value;
  }

  /// For each element of the [Iterable] apply function `toElements` and flat the result.
  ///
  /// Equivalent to `Iterable.expand`.
  Iterable<B> flatMap<B>(Iterable<B> Function(T t) toElements) =>
      expand(toElements);

  /// Join elements at the same index from two different [Iterable] into
  /// one [Iterable] containing the result of calling `combine` on
  /// each element pair.
  ///
  /// If one input [Iterable] is shorter,
  /// excess elements of the longer [Iterable] are discarded.
  Iterable<C> zipWith<B, C>(
    C Function(T t, B b) combine,
    Iterable<B> iterable,
  ) sync* {
    var it = iterator;
    var otherIt = iterable.iterator;
    while (it.moveNext() && otherIt.moveNext()) {
      yield combine(it.current, otherIt.current);
    }
  }

  /// `zip` is used to join elements at the same index from two different [Iterable]
  /// into one [Iterable] of a record.
  /// ```dart
  /// final list1 = ['a', 'b'];
  /// final list2 = [1, 2];
  /// final zipList = list1.zip(list2);
  /// print(zipList); // -> [(a, 1), (b, 2)]
  /// ```
  Iterable<(T, B)> zip<B>(Iterable<B> iterable) =>
      zipWith((a, b) => (a, b), iterable);


  /// Remove the **first occurrence** of `element` from this [Iterable].
  Iterable<T> delete(T element) sync* {
    var deleted = false;
    for (var current in this) {
      if (deleted || current != element) {
        yield current;
      } else {
        deleted = true;
      }
    }
  }

  /// Same as `map` but provides also the `index` of each mapped
  /// element in the mapping function (`toElement`).
  Iterable<B> mapWithIndex<B>(B Function(T t, int index) toElement) sync* {
    var index = 0;
    for (var value in this) {
      yield toElement(value, index);
      index += 1;
    }
  }

  /// Same as `flatMap` (`extend`) but provides also the `index` of each mapped
  /// element in the mapping function (`toElements`).
  Iterable<B> flatMapWithIndex<B>(
    Iterable<B> Function(T t, int index) toElements,
  ) sync* {
    var index = 0;
    for (var value in this) {
      yield* toElements(value, index);
      index += 1;
    }
  }



  /// Apply all the functions inside `iterable` to this [Iterable].
  Iterable<B> ap<B>(Iterable<B Function(T)> iterable) => iterable.flatMap(map);

  /// Return the intersection of two [Iterable] (all the elements that both [Iterable] have in common).
  ///
  /// If an element occurs twice in this iterable, it occurs twice in the
  /// result, but if it occurs twice in [iterable], only the first value
  /// is used.
  Iterable<T> intersect(Iterable<T> iterable) sync* {
    // If it's not important that [iterable] can change between
    // `element`s, consider creating a set from it first,
    // for faster `contains`.
    for (var element in this) {
      if (iterable.contains(element)) yield element;
    }
  }


  /// Return an [Iterable] placing an `middle` in between elements of the this [Iterable].
  Iterable<T> intersperse(T middle) sync* {
    var it = iterator;
    if (!it.moveNext()) return;
    yield it.current;
    while (it.moveNext()) {
      yield middle;
      yield it.current;
    }
  }

}

/// Functional programming functions on `Iterable<Iterable<T>>` using `fpdart`.
extension FpdartOnIterableOfIterable<T> on Iterable<Iterable<T>> {
  /// From a `Iterable<Iterable<T>>` return a `Iterable<T>` of their concatenation.
  Iterable<T> get flatten => expand(identity);
}


/// Functional programming functions on a mutable dart [Iterable] using `fpdart`.
extension FpdartOnList<T> on List<T> {
  /// Fold this [List] into a single value by aggregating each element of the list
  /// **from the last to the first**.
  B foldRight<B>(
    B initialValue,
    B Function(B previousValue, T element) combine,
  ) {
    var value = initialValue;
    for (var element in reversed) {
      value = combine(value, element);
    }
    return value;
  }

  /// Same as `foldRight` but provides also the `index` of each mapped
  /// element in the `combine` function.
  B foldRightWithIndex<B>(
    B initialValue,
    B Function(B previousValue, T element, int index) combine,
  ) {
    var index = 0;
    var value = initialValue;
    for (var element in reversed) {
      value = combine(value, element, index);
      index += 1;
    }
    return value;
  }

  /// Extract all elements **starting from the last** as long as `test` returns `true`.
  Iterable<T> takeWhileRight(bool Function(T t) test) =>
      reversed.takeWhile(test);

  /// Remove all elements **starting from the last** as long as `test` returns `true`.
  Iterable<T> dropWhileRight(bool Function(T t) test) =>
      reversed.skipWhile(test);
}

extension FpdartTraversableIterable<T> on Iterable<T> {
  /// {@macro fpdart_traverse_list_option}
  Optional<List<B>> traverseOptionWithIndex<B>(
    Optional<B> Function(T a, int i) f,
  ) =>
      Optional.traverseListWithIndex(toList(), f);

  /// {@macro fpdart_traverse_list_option}
  Optional<List<B>> traverseOption<B>(
    Optional<B> Function(T a) f,
  ) =>
      Optional.traverseList(toList(), f);
}

extension FpdartSequenceIterableOption<T> on Iterable<Optional<T>> {
  /// {@macro fpdart_sequence_list_option}
  Optional<List<T>> sequenceOption() => Optional.sequenceList(toList());
}



extension FpdartOnOption<T> on Optional<T> {
  /// Return the current [Optional] if it is a [Present], otherwise return the result of `orElse`.
  ///
  /// Used to provide an **alt**ernative [Optional] in case the current one is [Absent].
  /// ```dart
  /// [🍌].alt(() => [🍎]) -> [🍌]
  /// [_].alt(() => [🍎]) -> [🍎]
  /// ```
  Optional<T> alt(Optional<T> Function() orElse) =>
      this is Present<T> ? this : orElse();

  /// If this [Optional] is a [Present] then return the value inside the [Optional].
  /// Otherwise return the result of `orElse`.
  /// ```dart
  /// [🍌].getOrElse(() => 🍎) -> 🍌
  /// [_].getOrElse(() => 🍎) -> 🍎
  ///
  ///  👆 same as 👇
  ///
  /// [🍌].match(() => 🍎, (🍌) => 🍌)
  /// ```
  T getOrElse(T Function() orElse) => match(orElse, identity);
}

extension FpdartOnString on String {
  /// {@macro fpdart_string_extension_to_num_option}
  Optional<num> get toNumOption => Optional.fromNullable(num.tryParse(this));

  /// {@macro fpdart_string_extension_to_int_option}
  Optional<int> get toIntOption => Optional.fromNullable(int.tryParse(this));

  /// {@macro fpdart_string_extension_to_double_option}
  Optional<double> get toDoubleOption =>
      Optional.fromNullable(double.tryParse(this));

  /// {@macro fpdart_string_extension_to_bool_option}
  Optional<bool> get toBoolOption => Optional.fromNullable(bool.tryParse(this));

}


/// Functional programming functions on a mutable dart [Map] using `fpdart`.
extension FpdartOnMap<K, V> on Map<K, V> {
  /// Return number of elements in the [Map] (`keys.length`).
  int get size => keys.length;

  /// Convert each **value** of the [Map] using
  /// the `update` function and returns a new [Map].
  Map<K, A> mapValue<A>(A Function(V value) update) =>
      {for (var MapEntry(:key, :value) in entries) key: update(value)};

  /// Convert each **value** of the [Map] using
  /// the `update` function and returns a new [Map].
  Map<K, A> mapWithIndex<A>(A Function(V value, int index) update) => {
        for (var (index, MapEntry(:key, :value)) in entries.indexed)
          key: update(value, index)
      };

  /// Returns a new [Map] containing all the elements of this [Map]
  /// where the **value** satisfies `test`.
  Map<K, V> filter(bool Function(V value) test) => {
        for (var MapEntry(:key, :value) in entries)
          if (test(value)) key: value
      };

  /// Returns a new [Map] containing all the elements of this [Map]
  /// where the **value** satisfies `test`.
  Map<K, V> filterWithIndex(bool Function(V value, int index) test) => {
        for (var (index, MapEntry(:key, :value)) in entries.indexed)
          if (test(value, index)) key: value
      };

  /// Returns a new [Map] containing all the elements of this [Map]
  /// where **key/value** satisfies `test`.
  Map<K, V> filterWithKey(bool Function(K key, V value) test) => {
        for (var (MapEntry(:key, :value)) in entries)
          if (test(key, value)) key: value
      };

  /// Returns a new [Map] containing all the elements of this [Map]
  /// where **key/value** satisfies `test`.
  Map<K, V> filterWithKeyAndIndex(
    bool Function(K key, V value, int index) test,
  ) =>
      {
        for (var (index, MapEntry(:key, :value)) in entries.indexed)
          if (test(key, value, index)) key: value
      };

  /// Get the value at given `key` if present, otherwise return [Absent].
  Optional<V> lookup(K key) {
    var value = this[key];
    if (value != null) return present(value);
    if (containsKey(key)) return present(value as V);
    return const Absent();
  }

  /// Get the value and key at given `key` if present, otherwise return [Absent].
  Optional<(K, V)> lookupWithKey(K key) {
    final value = this[key];
    if (value != null) return present((key, value));
    if (containsKey(key)) return present((key, value as V));
    return const Absent();
  }

  /// Return an [Optional] that conditionally accesses map keys, only if they match the
  /// given type.
  ///
  /// Useful for accessing nested JSON.
  ///
  /// ```dart
  /// { 'test': 123 }.extract<int>('test'); /// `Some(123)`
  /// { 'test': 'string' }.extract<int>('test'); /// `Absent()`
  /// ```
  Optional<T> extract<T>(K key) {
    final value = this[key];
    return value is T ? present(value) : const Absent();
  }

  /// Return an [Optional] that conditionally accesses map keys if they contain a value
  /// with a [Map] value.
  ///
  /// Useful for accessing nested JSON.
  ///
  /// ```dart
  /// { 'test': { 'foo': 'bar' } }.extractMap('test'); /// `Some({ 'foo': 'bar' })`
  /// { 'test': 'string' }.extractMap('test'); /// `Absent()`
  /// ```
  Optional<Map<K, dynamic>> extractMap(K key) => extract<Map<K, dynamic>>(key);

}

extension FpdartOnOptionMap<K> on Optional<Map<K, dynamic>> {
  /// Return an [Optional] that conditionally accesses map keys, only if they match the
  /// given type.
  ///
  /// Useful for accessing nested JSON.
  ///
  /// ```dart
  /// { 'test': 123 }.extract<int>('test'); /// `Some(123)`
  /// { 'test': 'string' }.extract<int>('test'); /// `Absent()`
  /// ```
  Optional<T> extract<T>(K key) => flatMap((map) => map.extract(key));

  /// Return an [Optional] that conditionally accesses map keys, if they contain a map
  /// with the same key type.
  ///
  /// Useful for accessing nested JSON.
  ///
  /// ```dart
  /// { 'test': { 'foo': 'bar' } }.extractMap('test'); /// `Some({ 'foo': 'bar' })`
  /// { 'test': 'string' }.extractMap('test'); /// `Absent()`
  /// ```
  Optional<Map<K, dynamic>> extractMap(K key) => extract<Map<K, dynamic>>(key);
}