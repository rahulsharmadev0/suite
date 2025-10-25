# Changelog

## 0.0.8 - Minor 🚀
### 🎉 Upgrade to dart_suite ^0.0.8

### New Features ✨
- Introduced one-time-password utilities with `Hotp`, `TOTP`, and configurable `HashAlgorithm` support for MFA workflows.
- Added helper APIs for drift-tolerant verification, window timing, and otpauth URI generation.

### Documentation 📚
- Expanded README with usage guidance and examples for the OTP helpers.

## 0.0.7 - Patch 📃
### 🎉 Upgrade to dart_suite ^0.0.7

### Improvements 🔧
- Updated README with additional usage examples for `Optional<T>`.
- Bug fixes and performance improvements.

## 0.0.6 - Minor 🚀
### 🎉 Upgrade to dart_suite ^0.0.6

### New Features ✨
- Added `Optional<T>` type for representing optional values with channel-like operations (inspired by Java's `Optional` and Rust's `Option`).

### Improvements 🔧
- Updated README with usage examples for `Optional<T>`.
- Bug fixes and performance improvements.

## 0.0.5 - Patch 📃
### 🎉 Upgrade to dart_suite ^0.0.5

### New Features ✨
- Added `@singleton` annotation for generating singleton classes (required for gen_suite functionality).

## 0.0.4 - Minor 🚀
### 🎉 Upgrade to dart_suite ^0.0.4

### New Features ✨
- Java-like functional typedefs: `Predicate`, `BiPredicate`, `Consumer`, `BiConsumer`, `Supplier`, `UnaryOperator`, `BinaryOperator`, `Runnable`, `Callable`, `Comparator`, `ThrowingConsumer`, `ThrowingSupplier`, `ThrowingFunction`, etc.
- `lcm` and `gcd` extensions for `int` and `Iterable<int>`.
- LRU cache data structure: `LruCache<K, V>`.

### Improvements 🔧
- Improved typedef documentation and usage examples in README.

## 0.0.3 - Patch 📃
### 🎉 Upgrade to dart_suite ^0.0.3

### New Features ✨
- Introduced `RetryPolicy` class to configure retry attempts, delays, backoff, and exception types.

### Improvements 🔧
- Improved naming conventions for better code readability.
- Helpers like `retryWithPolicy` for easier async retries.

## 0.0.2 - Patch 📃
### 🎉 Upgrade to dart_suite ^0.0.2

### Update — Extension Overhaul 🚀
- Enhanced `num`, `String`, and `Map` extensions with more intuitive methods.
- Improved naming conventions for clearer, more consistent APIs.

## 0.0.1 - Initial Release 🎊
### 🎉 Initial release
- First version — foundation established.

