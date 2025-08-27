import 'dart:collection';

import 'package:dart_suite/src/dsa/lru_cache.dart';
import 'package:meta/meta.dart';


/// A small LRU cache implemented on top of [LinkedHashMap].
///
/// Keys are promoted to Most-Recently-Used on read and write. When capacity
/// is reached inserting a new key evicts the Least-Recently-Used key.
class LruCacheImpl<K, V> implements LruCache<K, V> {
  final int _capacity;
  final LinkedHashMap<K, V> _lruCache = LinkedHashMap<K, V>();

  @protected
  LruCacheImpl(int capacity)
      : assert(capacity > 0, 'Capacity must be greater than zero'),
        _capacity = capacity;

  @override
  int get capacity => _capacity;

  // On read, promote the key to Most-Recently-Used by removing and reinserting it.
  // We check containsKey first because a stored value may be `null`; calling
  // remove() directly could return null for either "not found" or "present but null".
  @override
  V? get(K key) => containsKey(key) ? _lruCache[key] = remove(key) as V : null;

  // Insert/update and promote to MRU, evict LRU if needed
  @override
  V put(K key, V value) {
    if (containsKey(key)) {
      remove(key);
    } else if (length >= capacity) {
      remove(keys.first);
    }

    return _lruCache[key] = value;
  }

  @override
  V? operator [](Object? key) => key is! K ? null : get(key);

  @override
  void operator []=(K key, V value) => put(key, value);

  @override
  V? remove(Object? key) => _lruCache.remove(key);

  @override
  void clear() => _lruCache.clear();

  @override
  Iterable<K> get keys => _lruCache.keys;

  @override
  int get length => _lruCache.length;

  @override
  bool containsKey(Object? key) => _lruCache.containsKey(key);

  @override
  bool containsValue(Object? value) => _lruCache.containsValue(value);

  @override
  Iterable<V> get values => _lruCache.values;

  @override
  bool get isEmpty => _lruCache.isEmpty;

  @override
  bool get isNotEmpty => _lruCache.isNotEmpty;

  @override
  void forEach(void Function(K key, V value) action) {
    // Iterate over a snapshot of keys since calling get() promotes keys and
    // mutates the underlying map which would otherwise cause a
    // ConcurrentModificationError.
    for (final key in List<K>.from(keys)) {
      action(key, get(key) as V);
    }
  }

  @override
  String toString() => _lruCache.toString();

  @override
  void addAll(Map<K, V> other) => other.forEach(put);

  @override
  void addEntries(Iterable<MapEntry<K, V>> newEntries) {
    for (final entry in newEntries) {
      put(entry.key, entry.value);
    }
  }

  @override
  Map<RK, RV> cast<RK, RV>() => _lruCache.cast<RK, RV>();

  @override
  V putIfAbsent(K key, V Function() ifAbsent) =>
      containsKey(key) ? get(key) as V : put(key, ifAbsent());

  @override
  void removeWhere(bool Function(K key, V value) test) => _lruCache.removeWhere(test);

  @override
  V update(K key, V Function(V value) update, {V Function()? ifAbsent}) {
    if (containsKey(key)) {
      return put(key, update(_lruCache[key] as V));
    } else {
      if (ifAbsent != null) return put(key, ifAbsent());
      throw ArgumentError.value(key, 'key', 'Key not found in map');
    }
  }

  @override
  void updateAll(V Function(K key, V value) update) {
    // Snapshot first to avoid concurrent modification during promotion.
    for (final e in List<MapEntry<K, V>>.from(entries)) {
      put(e.key, update(e.key, e.value));
    }
  }

  @override
  Iterable<MapEntry<K, V>> get entries => _lruCache.entries;

  @override
  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(K key, V value) transform) =>
      _lruCache.map(transform);
}
