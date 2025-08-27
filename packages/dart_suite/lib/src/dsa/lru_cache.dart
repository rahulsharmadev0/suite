import 'dart:collection';
import 'impl/lru_cache_impl.dart';

/// Lightweight abstraction for LRU-backed maps.
///
/// This extends [MapBase] and exposes a few LRU-specific operations so
/// implementations can guarantee promotion-on-read and capacity semantics.
abstract class LruCache<K, V> extends MapBase<K, V> {
  factory LruCache(int capacity) = LruCacheImpl<K, V>;

  /// The maximum number of entries this cache can hold.
  int get capacity;

  /// Reads a value and promotes the key to most-recently-used.
  V? get(K key);

  /// Inserts or updates a value and promotes the key to most-recently-used.
  V put(K key, V value);
}