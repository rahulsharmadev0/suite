import 'package:test/test.dart';
import 'package:dart_suite/src/dsa/lru_cache.dart';

void main() {
  group('LruCache - comprehensive', () {
    test('basic put/get and promotion on read', () {
      final cache = LruCache<String, int>(2);
      cache['a'] = 1;
      cache['b'] = 2;

      // Access 'a' -> promotes 'a' to MRU
      expect(cache['a'], equals(1));

      // Inserting 'c' should evict LRU which is 'b'
      cache['c'] = 3;

      expect(cache.containsKey('a'), isTrue);
      expect(cache.containsKey('b'), isFalse);
      expect(cache.containsKey('c'), isTrue);
    });

    test('promotion on write (overwrite) keeps size and updates MRU', () {
      final cache = LruCache<String, int>(2);
      cache['a'] = 1;
      cache['b'] = 2;
      // Overwrite 'a' should make it MRU
      cache['a'] = 11;
      cache['c'] = 3; // should evict 'b'

      expect(cache.containsKey('a'), isTrue);
      expect(cache['a'], equals(11));
      expect(cache.containsKey('b'), isFalse);
    });

    test('stores and promotes null values correctly', () {
      final cache = LruCache<String, int?>(2);
      cache['x'] = null;
      cache['y'] = 2;
      // stored null should be considered present
      expect(cache.containsKey('x'), isTrue);
      expect(cache['x'], isNull);

      // Accessing 'x' should promote it; inserting 'z' should evict 'y'
      final _ = cache['x'];
      cache['z'] = 3;

      expect(cache.containsKey('x'), isTrue);
      expect(cache.containsKey('y'), isFalse);
    });

    test('putIfAbsent returns existing and promotes key', () {
      final cache = LruCache<String, int>(2);
      cache['a'] = 1;
      cache['b'] = 2;

      final got = cache.putIfAbsent('a', () => 100);
      expect(got, equals(1));

      // 'a' should now be MRU; inserting 'c' evicts 'b'
      cache['c'] = 3;
      expect(cache.containsKey('a'), isTrue);
      expect(cache.containsKey('b'), isFalse);
    });

    test('update and updateAll behavior', () {
      final cache = LruCache<String, int>(3);
      cache.addAll({'a': 1, 'b': 2, 'c': 3});

      expect(cache.update('b', (v) => v + 10), equals(12));
      expect(cache.update('c', (v) => v + 10), equals(13));

      expect(cache['b'], equals(12));

      cache.updateAll((k, v) => v * 2);
      expect(cache['b'], equals(24));
      expect(cache['c'], equals(26));
      expect(cache['a'], equals(2));
    });

    test('addAll/addEntries and eviction order', () {
      final cache = LruCache<String, int>(3);
      cache.addAll({'a': 1, 'b': 2});
      cache.addEntries([MapEntry('c', 3), MapEntry('d', 4)]);

      // Capacity 3: after inserting d, the LRU should have been evicted
      expect(cache.length, equals(3));
      expect(cache.containsKey('a'), isFalse);
      expect(cache.containsKey('b'), isTrue);
      expect(cache.containsKey('c'), isTrue);
      expect(cache.containsKey('d'), isTrue);
    });

    test('remove, removeWhere and clear', () {
      final cache = LruCache<String, int>(3);
      cache.addAll({'a': 1, 'b': 2, 'c': 3});

      expect(cache.remove('b'), equals(2));
      expect(cache.containsKey('b'), isFalse);

      // Remove odd values (a=1, c=3) to test removeWhere
      cache.removeWhere((k, v) => v.isOdd);
      expect(cache.containsKey('a'), isFalse);
      expect(cache.containsKey('c'), isFalse);

      cache.clear();
      expect(cache.isEmpty, isTrue);
    });

    test('keys/values/entries and forEach maintain expected ordering', () {
      final cache = LruCache<String, int>(4);
      cache['a'] = 1;
      cache['b'] = 2;
      cache['c'] = 3;

      // Access 'a' to promote
      expect(cache['a'], equals(1));

      // Current order should be: b, c, a (LRU -> MRU)
      final keys = cache.keys.toList();
      expect(keys, equals(['b', 'c', 'a']));

      // forEach should iterate and (implementation) may promote on read.
      final seen = <String>[];
      cache.forEach((k, v) => seen.add(k));
      expect(seen.toSet(), equals({'b', 'c', 'a'}));

      // entries and values should reflect current state
      expect(cache.entries.map((e) => e.key).toSet(), equals({'b', 'c', 'a'}));
      expect(cache.values.toSet(), equals({1, 2, 3}));
    });

    test('capacity 1 behaves as expected', () {
      final cache = LruCache<String, int>(1);
      cache['x'] = 10;
      expect(cache.containsKey('x'), isTrue);
      cache['y'] = 20;
      expect(cache.containsKey('x'), isFalse);
      expect(cache.containsKey('y'), isTrue);
    });
  });
}
