<p align="center">
<img src="https://raw.githubusercontent.com/rahulsharmadev0/suite/refs/heads/main/assets/logo/bg_dart_suite.png" height="150" alt="Flutter Dart Package" />
</p>

<p align="center">
<a href="https://pub.dev/packages/dart_suite"><img src="https://img.shields.io/pub/v/dart_suite.svg" alt="Pub"></a>
<a href="https://github.com/rahulsharmadev0/bloc/actions"><img src="https://github.com/felangel/bloc/workflows/build/badge.svg" alt="build"></a>
<a href="https://github.com/rahulsharmadev0/suite"><img src="https://img.shields.io/github/stars/rahulsharmadev0/suite.svg?style=flat&logo=github&colorB=deeppink&label=stars" alt="Star on Github"></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>

---

A versatile Dart package offering a comprehensive collection of utilities, extensions, and data structures for enhanced development productivity. Features include:

- **Retry & RetryPolicy**: Automatic retry mechanism with exponential backoff
- **Timeago**: Convert dates into human-readable format like "2 hours ago"
- **Debounce**: Control function execution rate with delay
- **Guard**: Safe error handling for sync/async operations
- **ReCase**: Convert strings between different case formats
- **RegPatterns**: Common regex patterns for validation
- **LRU Cache**: Efficient Least Recently Used cache data structure
- **Typedefs**: Handy typedefs for cleaner code

---

## Retry & RetryPolicy

`RetryPolicy` provides a flexible way to configure retry strategies for async operations. You can set max attempts, delays, backoff, and which exceptions to retry. Use it with `retryWithPolicy`, `Retry.executeWithPolicy`, or the extension method.

```dart
import 'package:dart_suite/dart_suite.dart';

final policy = RetryPolicy(
  maxAttempts: 5,
  initialDelay: Duration(milliseconds: 500),
  maxDelay: Duration(seconds: 10),
  backoffMultiplier: 2.0,
  retryableExceptions: [TimeoutException],
);

final result = await retryWithPolicy(
  () async => await fetchData(),
  policy: policy,
  retryIf: (e) => e is TimeoutException,
  onRetry: (e) => print('Retrying after error: $e'),
);

// Or use the extension:
final value = await (() async => await fetchData()).executeWithPolicy(policy: policy);
```

**Why use RetryPolicy?**

- Centralizes retry logic for consistency
- Easily swap between aggressive, default, or no-retry strategies
- Supports exponential backoff, max delay, and custom error filtering

**Defaults:**

- `RetryPolicy.defaultPolicy` (3 attempts, 1s delay, 2x backoff)
- `RetryPolicy.aggressivePolicy` (5 attempts, 0.5s delay, 1.5x backoff)
- `RetryPolicy.noRetry` (single attempt)

See the API docs and `lib/src/async_control/retry.dart` for more details.

- **Throttle**: Rate limiting for function calls
- **Extensions**: Utility extensions for enhanced Dart functionality

---

## LRU Cache

An efficient Least Recently Used (LRU) cache data structure for managing limited-size caches with automatic eviction of least recently used items.

```dart
import 'package:dart_suite/dart_suite.dart';

final cache = LruCache<String, int>(capacity: 3);
cache['a'] = 1;
cache['b'] = 2;
cache['c'] = 3;
print(cache['a']); // 1
cache['d'] = 4; // 'b' is evicted (least recently used)
print(cache.containsKey('b')); // false
```

**Features:**

- Fast O(1) get/set operations
- Automatic eviction of least recently used items
- Customizable capacity

---

## Typedefs Toolkit

Lightweight, type-safe, and expressive typedefs for Dart & Flutter. No boilerplate classes needed!

### Why use this?

- Clean & descriptive code without extra class definitions
- Type-safe alternative to raw Maps or Lists
- Easy to serialize & debug (records print nicely)
- Works seamlessly in Dart & Flutter projects

### 📂 Categories & Typedefs

#### 📍 Geometry & Spatial

- `Point2D` → `(x, y)`
- `Point3D` → `(x, y, z)`
- `GeoCoordinate` → `(lat, lng)`
- `GeoCoordinate3D` → `(lat, lng, alt, acc?)`
- `Dimension` → `(length, width, height)`

#### 🌐 Data Structures

- `JSON<T>` → `Map<String, T>`
- `JSON_1<T>` → `(key, value)`
- `Pair<A, B>` → `(first, second)`
- `Triple<A, B, C>` → `(first, second, third)`

#### 🛠 Utility & Domain-Oriented

- `IdName` → `(id, name)`
- `RGB` → `(r, g, b)`
- `RGBA` → `(r, g, b, a)`
- `RectBounds` → `(x, y, width, height)`
- `Pagination` → `(page, pageSize, totalCount?)`

#### ☕ Java-like Functional Typedefs

- `Predicate<T>` → `bool Function(T t)`
- `BiPredicate<T, U>` → `bool Function(T t, U u)`
- `Consumer<T>` → `void Function(T t)`
- `BiConsumer<T, U>` → `void Function(T t, U u)`
- `Supplier<T>` → `T Function()`
- `UnaryOperator<T>` → `T Function(T operand)`
- `BinaryOperator<T>` → `T Function(T left, T right)`
- `Runnable` → `void Function()`
- `Callable<V>` → `V Function()`
- `Comparator<T>` → `int Function(T o1, T o2)`
- `ThrowingConsumer<T>` → `void Function(T t)`
- `ThrowingSupplier<T>` → `T Function()`
- `ThrowingFunction<T, R>` → `R Function(T t)`

### 📝 Usage Examples

```dart
import 'package:dart_suite/dart_suite.dart';

Future<List<GeoCoordinate>> fetchFromServer(String url, Pagination pageInfo) {
  ... // fetch data using pageInfo.page and pageInfo.pageSize
}

List<GeoCoordinate>? getFromCache(String url, Pagination pageInfo) {
  ... // get data using pageInfo.page and pageInfo.pageSize
}

void main() {

  Pagination pageInfo = (page: 1, pageSize: 20, totalCount: 95);
  String apiUrl = "https://api.example.com/locations";

  // Use asyncGuard to fall back to cache on error
  final data = await asyncGuard(
    () => fetchFromServer(apiUrl, pageInfo),
    def: getFromCache(apiUrl, pageInfo),
    onError: (e) => print('Fetch failed, using cache: $e'),
  );
}
```

### 💡 Notes

- These typedefs are **not replacements** for Flutter’s core types like `Size`, `Offset`, `Rect`, or `DateTimeRange`.
- They are designed for **lightweight data modeling**, JSON mapping, and utility/functional programming use cases.
- You can extend them with helper methods using **extensions** for added functionality.

---

## Timeago

Timeago is a dart library that converts a date into a humanized text. Instead of showing a date 2020-12-12 18:30 with timeago you can display something like "now", "an hour ago", "~1y", etc.

```dart
var oldDateTime = DateTime(2012, 6, 10);
    var t1 = Timeago.since(oldDateTime);
    var t2 = Timeago.since(oldDateTime, code: 'hi');

    // en
    print(t1.format());
    print(t1.format(isFull: true));
    print(t1.format(isFull: true, yearFormat: (p0) => p0.yMMMEd()));
    print(t1.format(isFull: true, yearFormat: (p0) => p0.yMMMEd(isFull: true)));

    // hi
    print(t2.format());
    print(t2.format(isFull: true, yearFormat: (p0) => p0.yMMMEd()));
    print(t2.format(isFull: true, yearFormat: (p0) => p0.yMMMEd(isFull: true)));


 Output _________________________
 |
 |  10 Yr ago
 |  10 Years ago
 |  Sat, Jun 10, 2012
 |  Saturday, June 10, 2012
 |
 |  10 वर्षों पूर्व
 |  शनि, जून 10, 2012
 |  शनिवार, जून 10, 2012
 |_______________________________
```

## Debounce

Debounce creates a function that delays invoking the callback until after a specified wait time has elapsed since the last time it was invoked. Useful for implementing behavior that should only happen after a repeated action has completed.

```dart
// Example 1: Basic debouncing of a search function
void searchApi(String query) async {
  final results = await api.search(query);
  updateUI(results);
}

final debouncedSearch = Debounce(
  searchApi,
  const Duration(milliseconds: 300),
);

// In your UI/input handler
void onSearchInput(String query) {
  debouncedSearch([query]);
}

// Example 2: Leading edge execution
final debouncedWithLeading = Debounce(
  callback,
  const Duration(seconds: 1),
  leading: true, // Execute on the leading edge
  trailing: false, // Don't execute on the trailing edge
);

// Example 3: Using extension method
final debouncedFunc = myFunction.debounced(
  const Duration(milliseconds: 500),
  maxWait: const Duration(seconds: 2),
);
```

## Guard

Guard provides a safe way to handle exceptions in both synchronous and asynchronous operations, with optional default values and error handling.

```dart
// Example 1: Basic guard usage
final result = guard(
  () => int.parse('invalid'),
  def: -1,
  onError: (e) => print('Error: $e'),
); // returns -1

// Example 2: Async guard with default value
final data = await asyncGuard(
  () => fetchDataFromApi(),
  def: [],
  onError: (e) => logError(e),
);

// Example 3: Guard safe execution
final success = guardSafe(
  () => File('example.txt').deleteSync(),
  onError: (e) => print('Failed to delete: $e'),
);

// Example 4: Using extension methods
final result = (() => riskyOperation()).guard(
  def: fallbackValue,
  reThrow: false,
);
```

## ReCase

ReCase is a utility for converting strings between different case formats (camelCase, snake_case, PascalCase, etc.).

```dart
// Example 1: Basic case conversions
final text = 'hello_world'.reCase;
print(text.pascalCase);  // 'HelloWorld'
print(text.camelCase);   // 'helloWorld'
print(text.snakeCase);   // 'hello_world'
print(text.dotCase);     // 'hello.world'
print(text.paramCase);   // 'hello-param'
print(text.pathCase);    // 'hello/world'

// Example 2: Converting from PascalCase
final pascal = 'ThisIsATest'.reCase;
print(pascal.constantCase);  // 'THIS_IS_A_TEST'
print(pascal.sentenceCase); // 'This is a test'

// Example 3: Title and Header cases
final phrase = 'a_simple_phrase'.reCase;
print(phrase.titleCase);    // 'A Simple Phrase'
print(phrase.headerCase);   // 'A-Simple-Phrase'
```

## RegPatterns

RegPatterns provides a comprehensive set of predefined regular expression patterns for common validation scenarios. It includes patterns for passwords, numbers, emails, URLs, file formats, and more.

### General Patterns

```dart
// Email validation
'user@domain.com'.regMatch(regPatterns.email);

// URL validation
'https://example.com'.regMatch(regPatterns.url);

// Phone number validation
'+1234567890'.regMatch(regPatterns.phoneNumber);

// Username validation (customizable)
final usernamePattern = regPatterns.username(
  allowSpace: false,
  minLength: 3,
  maxLength: 16,
);
'john_doe'.regMatch(usernamePattern);

// Name validation
'John Doe'.regMatch(regPatterns.name);
```

### Password Patterns

```dart
// Create password pattern with specific requirements
final passwordPattern = regPatterns.password(
  PasswordType.ALL_CHARS_UPPER_LOWER_NUM_SPECIAL,
  minLength: 8,
  maxLength: 24,
  allowSpace: false,
);

'StrongPass123!'.regMatch(passwordPattern);  // true
'weak'.regMatch(passwordPattern);            // false

// Available password types:
// - ALL_CHARS_UPPER_LOWER_NUM_SPECIAL
// - ALL_CHARS_UPPER_LOWER_NUM
// - ALL_CHAR_LETTER_NUM
// - ONLY_LETTER_NUM
// - ANY_CHAR
```

### Numeric Patterns

```dart
// Number validation with custom settings
final numPattern = regPatterns.number(
  type: Number.decimal,      // decimal, binary, octal, hexDecimal
  allowEmptyString: false,
  allowSpecialChar: '.,',
  minLength: 2,
  maxLength: 16,
);

'123.45'.regMatch(numPattern);  // true
'12,345'.regMatch(numPattern); // true
```

### File Format Patterns

```dart
// Image files
'photo.jpg'.regMatch(regPatterns.fileFormats.image);
'doc.png'.regMatch(regPatterns.fileFormats.image);

// Document files
'document.pdf'.regMatch(regPatterns.fileFormats.pdf);
'sheet.xlsx'.regMatch(regPatterns.fileFormats.excel);
'presentation.pptx'.regMatch(regPatterns.fileFormats.ppt);

// Media files
'music.mp3'.regMatch(regPatterns.fileFormats.audio);
'video.mp4'.regMatch(regPatterns.fileFormats.video);
```

### Other Patterns

```dart
// Credit card validation
'4111111111111111'.regMatch(regPatterns.creditCard);

// IPv4 validation
'192.168.1.1'.regMatch(regPatterns.ipv4);

// IPv6 validation
'2001:0db8:85a3:0000:0000:8a2e:0370:7334'.regMatch(regPatterns.ipv6);

// Date time validation
'2023-11-27 08:14:39.977'.regMatch(regPatterns.basicDateTime);

// Base64 validation
'SGVsbG8gV29ybGQ='.regMatch(regPatterns.base64);
```

### Pattern Combination

```dart
// Check if string matches any pattern
final patterns = {
  regPatterns.email,
  regPatterns.url,
  regPatterns.phoneNumber,
};

'test@example.com'.regAnyMatch(patterns);  // true
'https://example.com'.regAnyMatch(patterns);  // true
'+1234567890'.regAnyMatch(patterns);  // true
'invalid-input'.regAnyMatch(patterns);  // false

// Check if string matches all patterns
'test@example.com'.regAllMatch(patterns);  // false
```

All patterns include built-in error messages and can be used with optional error throwing:

```dart
// With error throwing
'invalid'.regMatch(regPatterns.email, throwError: true);  // throws ArgumentError

// With custom error handling
'invalid'.regMatch(
  regPatterns.email,
  throwError: true,
  onError: (e) => print('Validation failed: $e'),
);
```

## Contributing

Contributions are welcome! Please open an issue or submit a pull request on [GitHub](https://github.com/rahulsharmadev0/suite).

## License

This project is licensed under the [MIT License](https://github.com/rahulsharmadev0/suite/blob/main/packages/dart_suite/LICENSE).
