
## 0.0.6
### Added
- `Optional<T>` type for representing optional values and powered with channel-like operations. Inspired by Java's Optional and Rust's Option.
### Changed
- Updated README.md with usage examples for `Optional<T>`.
- Bug fixes and performance improvements.

## 0.0.5
### Added
- @singleton annotation for generating singleton classes, necessary for gen_suite package functionality.

## 0.0.4
### Added

- Java-like functional typedefs (Predicate, BiPredicate, Consumer, BiConsumer, Supplier, UnaryOperator, BinaryOperator, Runnable, Callable, Comparator, ThrowingConsumer, ThrowingSupplier, ThrowingFunction, etc.) for expressive functional programming in Dart.
- `lcm` and `gcd` extensions for `int` and `Iterable<int>`
- LRU Cache data structure (`LruCache<K, V>`) for efficient caching
- Improved typedef documentation and usage examples in README.md.

## 0.0.3

- Improved naming conventions for better code readability
- Introduced `RetryPolicy` class for flexible and reusable retry strategies in async operations. Now you can configure retry attempts, delays, backoff, and exception types in a single place and use it with `retryWithPolicy` and related helpers.

## 0.0.2

**Extension Overhaul** 🚀

- Enhanced `num`, `string`, and `map` extensions with more intuitive methods
- Improved naming conventions for better code readability

## 0.0.1

- 🎉 Initial release! Foundation established.
