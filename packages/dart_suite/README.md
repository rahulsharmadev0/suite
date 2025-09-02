<p align="center">
<img src="https://raw.githubusercontent.com/rahulsharmadev0/suite/refs/heads/main/assets/logo/bg_dart_suite.png" height="150" alt="Flutter Dart Package" />
</p>

<p align="center">
<a href="https://pub.dev/packages/dart_suite"><img src="https://img.shields.io/pub/v/dart_suite.svg" alt="Pub"></a>
<a href="https://github.com/rahulsharmadev0/bloc/actions"><img src="https://github.com/felangel/bloc/workflows/build/badge.svg" alt="build"></a>
<a href="https://github.com/rahulsharmadev0/suite"><img src="https://img.shields.io/github/stars/rahulsharmadev0/suite.svg?style=flat&logo=github&colorB=deeppink&label=stars" alt="Star on Github"></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>

---

<p align="center">
  <strong style="font-size:22px; display:block; margin-bottom:10px;">
    📦 Other Packages in This Suite
  </strong>
</p>
  
<p align="center">🧩 <a href="https://pub.dev/packages/bloc_suite"><strong>bloc_suite</strong></a> — Lightweight state-management helpers and reusable BLoC utilities for predictable app architecture.</p>
<p align="center">⚙️ <a href="https://pub.dev/packages/gen_suite"><strong>gen_suite</strong></a> — Code-generation tools and annotations to automate boilerplate and speed up development.</p>

<p align="center">
  <a href="https://pub.dev/packages/bloc_suite">
    <img src="https://img.shields.io/pub/v/bloc_suite.svg?label=bloc_suite&color=1f7aed&logo=dart" alt="bloc_suite" />
  </a>
  &nbsp;&nbsp;
  <a href="https://pub.dev/packages/gen_suite">
    <img src="https://img.shields.io/pub/v/gen_suite.svg?label=gen_suite&color=ffcc00&logo=google" alt="gen_suite" />
  </a>
</p>

<p align="center">
  <a href="https://github.com/rahulsharmadev0/suite"><strong>🔎 Explore the full suite →</strong></a>
</p>


# Dart Suite

A versatile Dart package offering a comprehensive collection of utilities, extensions, and data structures for enhanced development productivity.

## 📚 Table of Contents

- [🚀 Quick Start](#-quick-start)
- [🔄 Asynchronous Utilities](#-asynchronous-utilities)
  - [Retry & RetryPolicy](#-retry--retrypolicy)
  - [Debounce](#%EF%B8%8F-debounce)
  - [Guard](#%EF%B8%8F-guard)
  - [Throttle](#-throttle)
- [💾 Data Structures & Algorithms](#-data-structures--algorithms)
  - [LRU Cache](#%EF%B8%8F-lru-cache)
  - [LCM & GCD](#-lcm--gcd)
- [📝 Utility Typedefs](#-utility-typedefs)
  - [Geometry & Spatial](#-geometry--spatial)
  - [Data Structures](#-data-structures)
  - [Utility & Domain-Oriented](#%EF%B8%8F-utility--domain-oriented)
  - [Java-like Functional Typedefs](#-java-like-functional-typedefs)
- [📦 Options & Null Safety](#-options--null-safety)
- [⏰ Time Utilities](#-time-utilities)
  - [Timeago](#-timeago)
- [🔤 Text Processing](#-text-processing)
  - [ ReCase](#-recase)
  - [RegPatterns](#-regpatterns)
- [🌐 URL Schemes](#-url-schemes)
  - [Mailto](#-mailto)
- [🏗️ Annotations & Code Generation](#%EF%B8%8F-annotations--code-generation)
  - [Singleton Annotation](#-singleton-annotation)
- [🔧 Validation](#-validation)
  - [ValidatorMixin](#-validatormixin)
- [🚀 Extensions](#-extensions)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)

---

## 🚀 Quick Start

Add `dart_suite` to your `pubspec.yaml`:

```yaml
dependencies:
  dart_suite: ^latest_version
```

Then import the package:

```dart
import 'package:dart_suite/dart_suite.dart';
```

---

## 🔄 Asynchronous Utilities

### 🔁 Retry & RetryPolicy

> **Smart retry mechanisms with exponential backoff and customizable policies**

`RetryPolicy` provides a flexible way to configure retry strategies for async operations. You can set max attempts, delays, backoff, and which exceptions to retry.

#### 🎯 Key Features

- ✅ **Centralized retry logic** for consistency across your app
- ⚙️ **Exponential backoff** with customizable multipliers
- 🎛️ **Pre-configured policies** (default, aggressive, no-retry)
- 🔍 **Custom error filtering** with retryable exceptions
- 📊 **Detailed logging** and error callbacks

#### 📋 Usage Examples

```dart
import 'package:dart_suite/dart_suite.dart';

// Create a custom retry policy
final policy = RetryPolicy(
  maxAttempts: 5,
  initialDelay: Duration(milliseconds: 500),
  maxDelay: Duration(seconds: 10),
  backoffMultiplier: 2.0,
  retryableExceptions: [TimeoutException, SocketException],
);

// Method 1: Using retryWithPolicy function
final result = await retryWithPolicy(
  () async => await fetchData(),
  policy: policy,
  retryIf: (e) => e is TimeoutException,
  onRetry: (e, attempt) => print('Retry $attempt after error: $e'),
);

// Method 2: Using extension method
final value = await (() async => await fetchData())
    .executeWithPolicy(policy: policy);

// Method 3: Using Retry class
final retry = Retry(policy: policy);
final data = await retry.execute(() async => await fetchData());
```

#### 🎚️ Pre-configured Policies

| Policy                         | Attempts | Initial Delay | Backoff | Use Case            |
| ------------------------------ | -------- | ------------- | ------- | ------------------- |
| `RetryPolicy.defaultPolicy`    | 3        | 1s            | 2x      | General purpose     |
| `RetryPolicy.aggressivePolicy` | 5        | 0.5s          | 1.5x    | Critical operations |
| `RetryPolicy.noRetry`          | 1        | -             | -       | Testing/debugging   |

```dart
// Quick setup with pre-configured policies
final result = await retryWithPolicy(
  () async => await criticalApiCall(),
  policy: RetryPolicy.aggressivePolicy,
);
```

### ⏱️ Debounce

> **Delay function execution until after a specified wait time has elapsed since the last invocation**

Debounce is perfect for scenarios like search inputs, API calls, or any operation that should only execute after user activity has stopped.

#### 🎯 Key Features

- ⏳ **Configurable delay** with trailing/leading edge execution
- 🔄 **Automatic cancellation** of previous pending executions
- 📏 **Max wait limits** to prevent indefinite delays
- 🎛️ **Flexible execution modes** (leading, trailing, or both)

#### 📋 Usage Examples

```dart
import 'package:dart_suite/dart_suite.dart';

// Example 1: Search API debouncing
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
  debouncedSearch([query]); // Will only execute after 300ms of inactivity
}

// Example 2: Leading edge execution (immediate first call)
final debouncedButton = Debounce(
  handleButtonPress,
  const Duration(milliseconds: 1000),
  leading: true,    // Execute immediately on first call
  trailing: false,  // Don't execute after delay
);

// Example 3: Using extension method with max wait
final debouncedSave = autoSave.debounced(
  const Duration(milliseconds: 500),
  maxWait: const Duration(seconds: 2), // Force execution after 2s max
);

// Example 4: Advanced configuration
final debouncer = Debounce(
  expensiveOperation,
  const Duration(milliseconds: 250),
  leading: false,
  trailing: true,
  maxWait: const Duration(seconds: 1),
);
```

#### 💡 Use Cases

| Scenario          | Configuration             | Benefit                           |
| ----------------- | ------------------------- | --------------------------------- |
| **Search Input**  | 300ms delay, trailing     | Reduces API calls                 |
| **Auto-save**     | 500ms delay + 2s max wait | Balances UX and data safety       |
| **Button Clicks** | 1s delay, leading only    | Prevents accidental double-clicks |
| **Resize Events** | 100ms delay, trailing     | Optimizes performance             |

### 🛡️ Guard

> **Safe exception handling with default values and optional error callbacks**

Guard provides a clean way to handle exceptions in both synchronous and asynchronous operations without verbose try-catch blocks.

#### 🎯 Key Features

- 🛡️ **Exception safety** with graceful fallbacks
- 🔄 **Sync & async support** with unified API
- 📝 **Custom error handling** with optional callbacks
- 🎛️ **Flexible error behavior** (suppress, log, or rethrow)

#### 📋 Usage Examples

```dart
import 'package:dart_suite/dart_suite.dart';

// Example 1: Basic guard with default value
final result = guard(
  () => int.parse('invalid_number'),
  def: -1,
  onError: (e) => print('Parsing error: $e'),
); // Returns -1 instead of throwing

// Example 2: Async guard with API fallback
final userData = await asyncGuard(
  () => fetchUserFromApi(userId),
  def: User.guest(), // Fallback user
  onError: (e) => logError('API failed', e),
);

// Example 3: Safe file operations
final success = guardSafe(
  () => File('temp.txt').deleteSync(),
  onError: (e) => print('Could not delete file: $e'),
); // Returns true if successful, false if error

// Example 4: Using extension methods
final config = (() => loadConfigFromFile())
    .guard(def: Config.defaultConfig());

final apiData = (() async => await fetchCriticalData())
    .asyncGuard(
      def: [],
      reThrow: false, // Don't rethrow exceptions
    );

// Example 5: Multiple fallback strategies
final imageUrl = guard(
  () => user.profileImage?.url,
  def: guard(
    () => getDefaultAvatarUrl(user.gender),
    def: 'assets/default_avatar.png',
  ),
);
```

#### 💡 Use Cases

| Scenario          | Guard Type   | Benefit              |
| ----------------- | ------------ | -------------------- |
| **API Calls**     | `asyncGuard` | Graceful degradation |
| **File I/O**      | `guardSafe`  | Prevent crashes      |
| **Parsing**       | `guard`      | Default values       |
| **Configuration** | `guard`      | Fallback configs     |

### 🚦 Throttle

> **Rate limiting for function calls to prevent excessive executions**

Throttle ensures a function is called at most once per specified time interval, perfect for performance optimization and rate limiting.

#### 🎯 Key Features

- ⏱️ **Configurable intervals** with precise timing control
- 🎛️ **Leading/trailing execution** modes
- 🔄 **Automatic scheduling** of delayed executions
- 📊 **Performance optimization** for expensive operations

#### 📋 Usage Examples

```dart
import 'package:dart_suite/dart_suite.dart';

// Example 1: API rate limiting
void updateServer(Map<String, dynamic> data) async {
  await api.updateUserProfile(data);
}

final throttledUpdate = Throttle(
  updateServer,
  const Duration(seconds: 1), // Max 1 call per second
);

// Multiple rapid calls will be throttled
throttledUpdate([profileData1]);
throttledUpdate([profileData2]); // Ignored if within 1 second
throttledUpdate([profileData3]); // Ignored if within 1 second

// Example 2: Scroll event optimization
final throttledScroll = onScroll.throttled(
  const Duration(milliseconds: 16), // ~60 FPS
  leading: true,  // Execute immediately
  trailing: true, // Execute final call after delay
);

// Example 3: Expensive calculations
final throttledCalculation = Throttle(
  performHeavyCalculation,
  const Duration(milliseconds: 500),
);
```

---

## 💾 Data Structures & Algorithms

### 🗂️ LRU Cache

> **Efficient Least Recently Used cache with automatic eviction and O(1) operations**

An high-performance LRU cache implementation that automatically manages memory by evicting least recently used items when capacity is reached.

#### 🎯 Key Features

- ⚡ **O(1) Performance** for get, set, and delete operations
- 🔄 **Automatic Eviction** of least recently used items
- 📏 **Customizable Capacity** with efficient memory management
- 🔍 **Standard Map Interface** for familiar usage patterns

#### 📋 Usage Examples

```dart
import 'package:dart_suite/dart_suite.dart';

// Example 1: Basic LRU cache usage
final cache = LruCache<String, int>(capacity: 3);

cache['a'] = 1;
cache['b'] = 2;
cache['c'] = 3;

print(cache['a']); // 1 (moves 'a' to most recently used)

cache['d'] = 4; // Evicts 'b' (least recently used)
print(cache.containsKey('b')); // false
print(cache.keys); // ['c', 'a', 'd'] (most recent last)

// Example 2: Cache with complex objects
final userCache = LruCache<int, User>(capacity: 100);

userCache[123] = User(id: 123, name: 'John');
final user = userCache[123]; // Quick O(1) retrieval

// Example 3: Image caching scenario
final imageCache = LruCache<String, ImageData>(capacity: 50);

ImageData? getCachedImage(String url) {
  return imageCache[url];
}

void cacheImage(String url, ImageData image) {
  imageCache[url] = image;
}

// Example 4: With null safety
final safeCache = LruCache<String, String?>(capacity: 10);
safeCache['key'] = null; // Explicitly cache null values
```

#### 📊 Performance Characteristics

| Operation          | Time Complexity | Description                             |
| ------------------ | --------------- | --------------------------------------- |
| `get(key)`         | O(1)            | Retrieve and mark as recently used      |
| `put(key, value)`  | O(1)            | Insert/update and manage capacity       |
| `remove(key)`      | O(1)            | Remove specific key                     |
| `containsKey(key)` | O(1)            | Check existence without affecting order |

#### 💡 Use Cases

- **Image/Asset Caching** - Limit memory usage in mobile apps
- **API Response Caching** - Store recent network responses
- **Computed Values** - Cache expensive calculations
- **User Session Data** - Maintain recent user interactions

### 🧮 LCM & GCD

> **Mathematical utilities for Least Common Multiple and Greatest Common Divisor calculations**

Built-in support for fundamental mathematical operations commonly needed in algorithms and mathematical computations.

```dart
import 'package:dart_suite/dart_suite.dart';

// GCD (Greatest Common Divisor)
int result1 = gcd(48, 18); // 6
int result2 = gcd(17, 13); // 1 (coprime numbers)

// LCM (Least Common Multiple)
int result3 = lcm(12, 8);  // 24
int result4 = lcm(7, 5);   // 35

// Use in real scenarios
int findOptimalBatchSize(int itemCount, int containerSize) {
  return lcm(itemCount, containerSize) ~/ itemCount;
}
```

---

## 📝 Utility Typedefs

> **Lightweight, type-safe, and expressive type definitions without boilerplate classes**

### 🌟 Why Use These Typedefs?

- ✅ **Clean & descriptive code** without extra class definitions
- 🔒 **Type-safe alternative** to raw Maps or Lists
- 🖨️ **Easy to serialize & debug** (records print beautifully)
- 🚀 **Seamless integration** with Dart & Flutter projects
- 🎯 **Zero runtime overhead** - pure compile-time types

### 📍 Geometry & Spatial

Perfect for 2D/3D graphics, mapping, and spatial calculations:

```dart
// Basic 2D and 3D points
Point2D location = (x: 100.0, y: 200.0);
Point3D position = (x: 1.0, y: 2.0, z: 3.0);

// Geographic coordinates
GeoCoordinate userLocation = (lat: 37.7749, lng: -122.4194); // San Francisco
GeoCoordinate3D preciseLocation = (
  lat: 37.7749,
  lng: -122.4194,
  alt: 52.0,     // altitude in meters
  acc: 5.0       // accuracy in meters (optional)
);

// Dimensions for layouts and measurements
Dimension boxSize = (length: 10.0, width: 5.0, height: 3.0);
RectBounds viewport = (x: 0, y: 0, width: 1920, height: 1080);
```

### 🌐 Data Structures

Lightweight data containers for common programming patterns:

```dart
// JSON handling made simple
JSON<String> config = {'theme': 'dark', 'language': 'en'};
JSON<int> scores = {'alice': 95, 'bob': 87, 'charlie': 92};

// Key-value pairs
JSON_1<String> setting = (key: 'theme', value: 'dark');
Pair<String, int> nameAge = (first: 'Alice', second: 30);
Triple<String, String, int> fullRecord = (first: 'Alice', second: 'Smith', third: 30);

// Common domain objects
IdName category = (id: 'tech', name: 'Technology');
Pagination pageInfo = (page: 1, pageSize: 20, totalCount: 100);
```

### 🛠️ Utility & Domain-Oriented

Specialized types for common application domains:

```dart
// Color representations
RGB primaryColor = (r: 255, g: 100, b: 50);
RGBA transparentColor = (r: 255, g: 255, b: 255, a: 0.8);

// UI and layout
RectBounds modalBounds = (x: 100, y: 50, width: 300, height: 200);
Dimension screenSize = (length: 1920, width: 1080, height: 1);

// Pagination for APIs
Pagination getUsersPage(int page) => (
  page: page,
  pageSize: 25,
  totalCount: null // Will be filled by API response
);
```

### ☕ Java-like Functional Typedefs

Bringing familiar functional programming patterns from Java to Dart:

#### 🔍 Predicates & Conditions

```dart
// Simple predicates
Predicate<int> isEven = (n) => n % 2 == 0;
Predicate<String> isNotEmpty = (s) => s.isNotEmpty;

// Bi-predicates for comparisons
BiPredicate<int, int> isGreater = (a, b) => a > b;
BiPredicate<String, String> startsWith = (text, prefix) => text.startsWith(prefix);

// Usage in filtering
List<int> numbers = [1, 2, 3, 4, 5, 6];
List<int> evenNumbers = numbers.where(isEven).toList();
```

#### 🔄 Functions & Operators

```dart
// Consumers for side effects
Consumer<String> logger = (message) => print('[LOG] $message');
BiConsumer<String, int> logWithLevel = (message, level) =>
    print('[L$level] $message');

// Suppliers for lazy values
Supplier<DateTime> currentTime = () => DateTime.now();
Supplier<String> randomId = () => Uuid().v4();

// Operators for transformations
UnaryOperator<String> toUpperCase = (s) => s.toUpperCase();
BinaryOperator<int> add = (a, b) => a + b;
BinaryOperator<String> concat = (a, b) => '$a$b';
```

#### 🎯 Advanced Functional Types

```dart
// Comparators for sorting
Comparator<Person> byAge = (p1, p2) => p1.age.compareTo(p2.age);
Comparator<String> byLength = (a, b) => a.length.compareTo(b.length);

// Throwing functions for error handling
ThrowingSupplier<String> readFile = () {
  // Might throw IOException
  return File('config.txt').readAsStringSync();
};

ThrowingFunction<String, int> parseNumber = (str) {
  // Might throw FormatException
  return int.parse(str);
};

// Callables and Runnables
Runnable cleanup = () => tempFiles.clear();
Callable<bool> validate = () => form.isValid();
```

#### 💡 Real-World Example

```dart
import 'package:dart_suite/dart_suite.dart';

// API service with pagination and error handling
Future<List<GeoCoordinate>> fetchLocations(String url, Pagination pageInfo) async {
  final response = await http.get('$url?page=${pageInfo.page}&size=${pageInfo.pageSize}');
  return parseLocations(response.body);
}

// Cache fallback function
List<GeoCoordinate>? getCachedLocations(String url, Pagination pageInfo) {
  return locationCache['${url}_${pageInfo.page}_${pageInfo.pageSize}'];
}

void main() async {
  Pagination pageInfo = (page: 1, pageSize: 20, totalCount: null);
  String apiUrl = "https://api.example.com/locations";

  // Use asyncGuard for automatic fallback to cache
  final locations = await asyncGuard(
    () => fetchLocations(apiUrl, pageInfo),
    def: getCachedLocations(apiUrl, pageInfo) ?? <GeoCoordinate>[],
    onError: (e) => print('API failed, using cache: $e'),
  );

  // Process locations with functional approach
  Consumer<GeoCoordinate> logLocation = (coord) =>
      print('Location: ${coord.lat}, ${coord.lng}');

  locations.forEach(logLocation);
}
```

### 💡 Important Notes

> **⚠️ These typedefs complement, not replace, Flutter's core types:**
>
> - Use Flutter's `Size`, `Offset`, `Rect` for UI positioning
> - Use `DateTimeRange` for date ranges in Flutter apps
> - These typedefs are ideal for **data modeling**, **JSON mapping**, and **utility functions**

---

## ⏰ Time Utilities

### 🕐 Timeago

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

> **Human-readable time differences with internationalization support**

Transform timestamps into user-friendly relative time strings like "2 hours ago", "just now", or "in 3 days" with full localization support.

#### 🎯 Key Features

- 🌍 **Multi-language Support** with built-in locales
- 🎨 **Flexible Formatting** with full/abbreviated modes
- 📅 **Smart Date Handling** with year formatting options
- ⚡ **Performance Optimized** for frequent updates

#### 📋 Usage Examples

```dart
import 'package:dart_suite/dart_suite.dart';

// Example 1: Basic timeago usage
var pastDate = DateTime(2020, 6, 10);
var timeago1 = Timeago.since(pastDate);        // English (default)
var timeago2 = Timeago.since(pastDate, code: 'hi'); // Hindi

print(timeago1.format());                       // "3y"
print(timeago1.format(isFull: true));          // "3 years ago"
print(timeago2.format(isFull: true));          // "3 वर्षों पूर्व"

// Example 2: Advanced formatting with date fallback
var oldDate = DateTime(2012, 6, 10);
var timeago = Timeago.since(oldDate);

print(timeago.format(isFull: true, yearFormat: (date) => date.yMMMEd()));
// Output: "Sat, Jun 10, 2012" (switches to date format for old dates)

// Example 3: Real-time updates
class CommentWidget extends StatefulWidget {
  final DateTime createdAt;

  Widget build(BuildContext context) {
    final timeago = Timeago.since(createdAt);
    return Text(timeago.format(isFull: true));
  }
}

// Example 4: Different locales
final dates = [
  DateTime.now().subtract(Duration(minutes: 5)),
  DateTime.now().subtract(Duration(hours: 2)),
  DateTime.now().subtract(Duration(days: 1)),
];

for (final date in dates) {
  final en = Timeago.since(date, code: 'en');
  final hi = Timeago.since(date, code: 'hi');
  final es = Timeago.since(date, code: 'es');

  print('EN: ${en.format(isFull: true)}');
  print('HI: ${hi.format(isFull: true)}');
  print('ES: ${es.format(isFull: true)}');
}
```

#### 🌍 Supported Languages

| Code | Language | Example Output                    |
| ---- | -------- | --------------------------------- |
| `en` | English  | "2 hours ago", "in 3 days"        |
| `hi` | Hindi    | "2 घंटे पूर्व", "3 दिनों में"     |
| `es` | Spanish  | "hace 2 horas", "en 3 días"       |
| `fr` | French   | "il y a 2 heures", "dans 3 jours" |
| `de` | German   | "vor 2 Stunden", "in 3 Tagen"     |

#### 📊 Format Options

```dart
final timeago = Timeago.since(DateTime.now().subtract(Duration(hours: 2)));

// Abbreviated format
print(timeago.format());              // "2h"

// Full format
print(timeago.format(isFull: true));  // "2 hours ago"

// With custom year formatting
print(timeago.format(
  isFull: true,
  yearFormat: (date) => DateFormat.yMMMMd().format(date)
)); // "June 10, 2023" for dates over a year old
```

#### 💡 Use Cases

- **Social Media Feeds** - Show post/comment timestamps
- **Chat Applications** - Display message times
- **Activity Logs** - Track user actions
- **Content Management** - Show last modified dates

---

## 🔤 Text Processing

### 🔄 ReCase

> **Convert strings between different case formats with ease**

Transform text between camelCase, snake_case, PascalCase, and many other formats for consistent naming conventions.

#### 🎯 Key Features

- 🔄 **Multiple Case Formats** - Support for 10+ case types
- 🎯 **Smart Recognition** - Automatically detects source format
- 🔗 **Method Chaining** - Fluent API for easy transformations
- 🚀 **Performance Optimized** - Efficient string processing

#### 📋 Available Cases

| Method         | Input         | Output        | Use Case              |
| -------------- | ------------- | ------------- | --------------------- |
| `camelCase`    | `hello_world` | `helloWorld`  | JavaScript variables  |
| `pascalCase`   | `hello_world` | `HelloWorld`  | Class names           |
| `snakeCase`    | `HelloWorld`  | `hello_world` | Database columns      |
| `constantCase` | `HelloWorld`  | `HELLO_WORLD` | Environment variables |
| `dotCase`      | `HelloWorld`  | `hello.world` | File extensions       |
| `paramCase`    | `HelloWorld`  | `hello-world` | URL slugs             |
| `pathCase`     | `HelloWorld`  | `hello/world` | File paths            |
| `sentenceCase` | `hello_world` | `Hello world` | UI text               |
| `titleCase`    | `hello_world` | `Hello World` | Headings              |
| `headerCase`   | `hello_world` | `Hello-World` | HTTP headers          |

#### 📋 Usage Examples

```dart
import 'package:dart_suite/dart_suite.dart';

// Example 1: API response transformation
Map<String, dynamic> apiResponse = {
  'user_name': 'john_doe',
  'email_address': 'john@example.com',
  'profile_image_url': 'https://...'
};

// Convert to Dart naming convention
Map<String, dynamic> dartFormat = apiResponse.map(
  (key, value) => MapEntry(key.reCase.camelCase, value),
);
// Result: {'userName': 'john_doe', 'emailAddress': 'john@example.com', ...}

// Example 2: Database to UI conversion
final databaseColumn = 'created_at_timestamp';
final uiLabel = databaseColumn.reCase.titleCase; // 'Created At Timestamp'
final constantName = databaseColumn.reCase.constantCase; // 'CREATED_AT_TIMESTAMP'

// Example 3: URL slug generation
final articleTitle = 'How to Build Amazing Flutter Apps';
final urlSlug = articleTitle.reCase.paramCase; // 'how-to-build-amazing-flutter-apps'

// Example 4: Code generation
final className = 'user_profile_service';
final dartClass = className.reCase.pascalCase;     // 'UserProfileService'
final fileName = className.reCase.snakeCase;       // 'user_profile_service'
final constantName = className.reCase.constantCase; // 'USER_PROFILE_SERVICE'

// Example 5: Multi-format processing
final input = 'some_complex_variable_name';
final recase = input.reCase;

print('Original: $input');
print('Camel: ${recase.camelCase}');        // someComplexVariableName
print('Pascal: ${recase.pascalCase}');      // SomeComplexVariableName
print('Constant: ${recase.constantCase}');  // SOME_COMPLEX_VARIABLE_NAME
print('Sentence: ${recase.sentenceCase}');  // Some complex variable name
print('Title: ${recase.titleCase}');        // Some Complex Variable Name
```

### 🔍 RegPatterns

> **Comprehensive regular expression patterns for common validation scenarios**

A complete collection of pre-built regex patterns for emails, passwords, URLs, phone numbers, file formats, and more - all with built-in validation and error handling.

#### 🎯 Key Features

- 📝 **50+ Predefined Patterns** for common use cases
- 🔐 **Advanced Password Validation** with customizable requirements
- 📱 **Phone & Email Validation** with international support
- 🌐 **URL & Domain Patterns** for web applications
- 📄 **File Format Detection** for uploads and processing
- 🎛️ **Customizable Parameters** for flexible validation

#### 🌟 General Patterns

```dart
import 'package:dart_suite/dart_suite.dart';

// Email validation with detailed checking
bool isValidEmail = 'user@domain.com'.regMatch(regPatterns.email);
print(isValidEmail); // true

// URL validation (HTTP, HTTPS, FTP)
bool isValidUrl = 'https://example.com/path?param=value'.regMatch(regPatterns.url);

// Phone number validation (international formats)
bool isValidPhone = '+1-234-567-8900'.regMatch(regPatterns.phoneNumber);

// Username validation with custom rules
final usernamePattern = regPatterns.username(
  allowSpace: false,
  allowSpecialChar: '_-',
  minLength: 3,
  maxLength: 16,
);
bool isValidUsername = 'john_doe_123'.regMatch(usernamePattern);

// Name validation (supports international characters)
bool isValidName = 'José María García'.regMatch(regPatterns.name);
```

#### 🔐 Password Patterns

Create secure password requirements with fine-grained control:

```dart
// Example 1: Enterprise-grade password
final strongPasswordPattern = regPatterns.password(
  PasswordType.ALL_CHARS_UPPER_LOWER_NUM_SPECIAL,
  minLength: 12,
  maxLength: 128,
  allowSpace: false,
);

bool isStrong = 'MySecure!Pass123'.regMatch(strongPasswordPattern);

// Example 2: User-friendly password
final basicPasswordPattern = regPatterns.password(
  PasswordType.ALL_CHARS_UPPER_LOWER_NUM,
  minLength: 8,
  maxLength: 50,
  allowSpace: true,
);

// Example 3: PIN-style password
final pinPattern = regPatterns.password(
  PasswordType.ONLY_LETTER_NUM,
  minLength: 4,
  maxLength: 6,
);

// Available password types:
// - ALL_CHARS_UPPER_LOWER_NUM_SPECIAL (most secure)
// - ALL_CHARS_UPPER_LOWER_NUM (balanced)
// - ALL_CHAR_LETTER_NUM (alphanumeric)
// - ONLY_LETTER_NUM (simple)
// - ANY_CHAR (minimal restrictions)
```

#### 🔢 Numeric Patterns

Validate various number formats with precision:

```dart
// Decimal numbers with custom separators
final decimalPattern = regPatterns.number(
  type: Number.decimal,
  allowEmptyString: false,
  allowSpecialChar: '.,',  // Allow both dots and commas
  minLength: 1,
  maxLength: 20,
);

// Examples that match:
'123.45'.regMatch(decimalPattern);    // true
'1,234.56'.regMatch(decimalPattern);  // true
'-99.99'.regMatch(decimalPattern);    // true

// Binary numbers
'1010110'.regMatch(regPatterns.number(type: Number.binary)); // true

// Hexadecimal numbers
'0xFF42A1'.regMatch(regPatterns.number(type: Number.hexDecimal)); // true

// Octal numbers
'755'.regMatch(regPatterns.number(type: Number.octal)); // true
```

#### 📄 File Format Patterns

Detect and validate file types by extension:

```dart
// Image files
bool isImage = 'photo.jpg'.regMatch(regPatterns.fileFormats.image);
bool isPNG = 'logo.png'.regMatch(regPatterns.fileFormats.image);
bool isWebP = 'modern.webp'.regMatch(regPatterns.fileFormats.image);

// Document files
bool isPDF = 'document.pdf'.regMatch(regPatterns.fileFormats.pdf);
bool isWord = 'report.docx'.regMatch(regPatterns.fileFormats.word);
bool isExcel = 'spreadsheet.xlsx'.regMatch(regPatterns.fileFormats.excel);
bool isPowerPoint = 'presentation.pptx'.regMatch(regPatterns.fileFormats.ppt);

// Media files
bool isAudio = 'music.mp3'.regMatch(regPatterns.fileFormats.audio);
bool isVideo = 'movie.mp4'.regMatch(regPatterns.fileFormats.video);

// Archive files
bool isZip = 'archive.zip'.regMatch(regPatterns.fileFormats.archive);
```

#### 🌐 Network & Security Patterns

```dart
// IP Address validation
bool isIPv4 = '192.168.1.1'.regMatch(regPatterns.ipv4);
bool isIPv6 = '2001:0db8:85a3::8a2e:0370:7334'.regMatch(regPatterns.ipv6);

// Credit card validation (basic format check)
bool isCreditCard = '4111-1111-1111-1111'.regMatch(regPatterns.creditCard);

// Base64 validation
bool isBase64 = 'SGVsbG8gV29ybGQ='.regMatch(regPatterns.base64);

// Date time validation
bool isDateTime = '2023-11-27 08:14:39.977'.regMatch(regPatterns.basicDateTime);
```

#### 🔀 Pattern Combination & Advanced Usage

```dart
// Check if string matches ANY pattern
final contactPatterns = {
  regPatterns.email,
  regPatterns.phoneNumber,
  regPatterns.url,
};

bool isValidContact = 'john@example.com'.regAnyMatch(contactPatterns); // true
bool isValidContact2 = '+1-555-0123'.regAnyMatch(contactPatterns); // true
bool isInvalidContact = 'not-valid-input'.regAnyMatch(contactPatterns); // false

// Check if string matches ALL patterns (rare but useful)
final strictPatterns = {
  regPatterns.username(minLength: 5, maxLength: 15),
  regPatterns.password(PasswordType.ALL_CHAR_LETTER_NUM, minLength: 5),
};

// Validation with error handling
try {
  'invalid-email'.regMatch(regPatterns.email, throwError: true);
} catch (e) {
  print('Email validation failed: $e');
}

// Custom error handling
'weak123'.regMatch(
  regPatterns.password(PasswordType.ALL_CHARS_UPPER_LOWER_NUM_SPECIAL),
  throwError: true,
  onError: (e) => showUserFriendlyError('Password is too weak'),
);
```

#### 💡 Real-World Examples

```dart
// Form validation
class RegistrationForm {
  bool validateEmail(String email) =>
      email.regMatch(regPatterns.email);

  bool validatePassword(String password) =>
      password.regMatch(regPatterns.password(
        PasswordType.ALL_CHARS_UPPER_LOWER_NUM_SPECIAL,
        minLength: 8,
      ));

  bool validateUsername(String username) =>
      username.regMatch(regPatterns.username(
        allowSpace: false,
        minLength: 3,
        maxLength: 20,
      ));
}

// File upload validation
bool canUploadFile(String filename) {
  final allowedFormats = {
    regPatterns.fileFormats.image,
    regPatterns.fileFormats.pdf,
    regPatterns.fileFormats.word,
  };
  return filename.regAnyMatch(allowedFormats);
}

// Data cleaning
List<String> cleanPhoneNumbers(List<String> rawNumbers) {
  return rawNumbers
      .where((number) => number.regMatch(regPatterns.phoneNumber))
      .toList();
}
```

---

## 🌐 URL Schemes

### 📧 Mailto

> **Generate properly formatted mailto URLs with support for multiple recipients, subjects, and body content**

Create email links that work across all platforms and email clients with proper encoding and validation.

#### 📋 Usage Examples

```dart
import 'package:dart_suite/dart_suite.dart';

// Example 1: Simple email link
final simpleEmail = Mailto(to: ['support@example.com']).toString();
// Result: "mailto:support@example.com"

// Example 2: Complex email with all options
final detailedEmail = Mailto(
  to: ['john@example.com', 'jane@example.com'],
  cc: ['manager@example.com'],
  bcc: ['admin@example.com'],
  subject: 'Project Update - Q4 2023',
  body: '''Dear Team,

Please find attached the quarterly report.
The key metrics show significant improvement.

Best regards,
Project Manager''',
).toString();

// Example 3: Support ticket template
final supportTicket = Mailto(
  to: ['support@yourapp.com'],
  subject: 'Bug Report - App Version ${AppVersion.current}',
  body: '''
Device: ${Platform.operatingSystem}
App Version: ${AppVersion.current}
Issue Description:

[Please describe the issue here]

Steps to Reproduce:
1.
2.
3.

Expected Behavior:

Actual Behavior:
''',
).toString();

// Example 4: Feedback form
Widget createFeedbackButton() {
  return ElevatedButton(
    onPressed: () async {
      final feedbackEmail = Mailto(
        to: ['feedback@yourapp.com'],
        subject: 'App Feedback',
        body: 'I would like to share the following feedback:\n\n',
      ).toString();

      if (await canLaunch(feedbackEmail)) {
        await launch(feedbackEmail);
      }
    },
    child: Text('Send Feedback'),
  );
}
```

---

## 🏗️ Annotations & Code Generation

### 🔒 Singleton Annotation

> **Automatic singleton pattern implementation with code generation**

Generate clean singleton classes from private abstract classes with full constructor support and lazy initialization - works with `gen_suite` package for code generation.

#### 🎯 Key Features

- 🏗️ **Full Constructor Support** - Works with default, positional, optional, and named parameters
- 🎯 **Parameter Preservation** - Maintains parameter shapes and default values
- ⚡ **Lazy Initialization** - Static-backed instance creation only when needed
- 🔒 **Type Safety** - Compile-time singleton pattern enforcement
- 📝 **Clean Generation** - Uses `code_builder` + `source_gen` for readable output

#### 📋 Usage Examples

```dart
// Step 1: Create your singleton service
import 'package:dart_suite/dart_suite.dart';

part 'my_service.g.dart'; // This file will be generated

@Singleton()
abstract class _ApiService {
  // Constructor with various parameter types
  _ApiService(
    String apiKey,                 // Required positional
    String baseUrl, {              // Required positional
    int timeout = 30,              // Named with default
    int retryCount = 3,            // Named with default
    bool debugMode = false,        // Named with default
    String this.userAgent,         // Required named
  }) {
    print('ApiService initialized with key: ${apiKey.substring(0, 8)}...');

    _client = HttpClient()
      ..connectionTimeout = Duration(seconds: timeout)
      ..userAgent = userAgent;
  }

  late final HttpClient _client;

  Future<Map<String, dynamic>> get(String endpoint) async {
    if(APIService.I.baseUrl.isEmpty) { // Access via singleton instance
      throw Exception("Base URL cannot be empty");
    }
    // Implementation here
    return {};
  }
  
  bool get debugMode; // don't define it, it's auto-generated
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    if(debugMode) { // Access via getter
      //....do something
    }
    // Implementation here
    return {};
  }
}
```

```dart
// Step 2: Run code generation
// In your terminal:
dart run build_runner build


```dart
// Step 3: Use your singleton
void main() {
  // First call creates the instance
  final apiService1 = ApiService.init(
    'your-api-key-here',
    'https://api.example.com',
    timeout: 45,
    userAgent: 'MyApp/1.0',
  );

  // Subsequent calls return the same instance 😂
  final apiService2 = ApiService.init(...);

  print(identical(apiService1, apiService2)); // true

   // Use the singleton instance
  await ApiService.I.get('/users');

  // Or via the instance
  await apiService2.post('/users', {'name': 'John'});
}
```

#### ⚠️ Important Notes

- **Private Classes Only**: The annotation only works with private abstract classes (starting with `_`)
- **No Generics**: Generic classes are not supported by the generator
- **Single Constructor**: Each class should have only one constructor
- **Part Files**: Always include the `part 'filename.g.dart';` directive

#### 🚀 Benefits

- **Memory Efficient**: Only one instance per singleton class
- **Thread Safe**: Generated code handles concurrent access properly
- **Developer Friendly**: Maintains your constructor's signature exactly
- **Error Prevention**: Compile-time checks prevent singleton pattern mistakes

---

## 🔧 Validation

### ✅ ValidatorMixin

> **Centralized validation logic for domain objects with safe exception handling**

A lightweight mixin that enforces validation patterns and provides safe validation checking without repetitive try-catch blocks.

#### 🎯 Key Features

- 🔒 **Enforced Validation** - Requires implementation of `validator()` method
- 🛡️ **Safe Validation** - Built-in exception handling with `isValid()`
- 🎛️ **Flexible Error Handling** - Optional error callbacks and re-throwing
- 🧪 **Testing Friendly** - Debug-friendly validation with detailed errors

#### 📋 Core Concepts

**Classes mixing `ValidatorMixin` must implement:**

- `validator()` - Protected method containing validation logic
- Throw exceptions for invalid states

**The mixin provides:**

- `isValid()` - Safe validation that returns `true`/`false`
- Built-in exception handling via `guardSafe`
- Optional error callbacks and re-throwing for debugging

#### 📋 Usage Examples

```dart
import 'package:dart_suite/dart_suite.dart';

// Example 1: Simple domain object validation
class PersonName with ValidatorMixin {
  final String firstName;
  final String lastName;

  const PersonName({
    required this.firstName,
    required this.lastName,
  });

  @override
  void validator() {
    if (firstName.isEmpty) throw ValidationException('First name cannot be empty');
    if (lastName.isEmpty) throw ValidationException('Last name cannot be empty');
    if (firstName.length < 2) throw ValidationException('First name too short');
    if (lastName.length < 2) throw ValidationException('Last name too short');
  }
}

// Usage
final validName = PersonName(firstName: 'John', lastName: 'Doe');
final invalidName = PersonName(firstName: '', lastName: 'Doe');

print(validName.isValid());   // true
print(invalidName.isValid()); // false

// Example 2: Email validation with regex
class Email with ValidatorMixin {
  final String address;

  const Email(this.address);

  @override
  void validator() {
    if (!address.regMatch(regPatterns.email)) {
      throw ValidationException('Invalid email format: $address');
    }
  }
}

final email1 = Email('user@domain.com');
final email2 = Email('invalid-email');

print(email1.isValid()); // true
print(email2.isValid()); // false

// Example 3: Complex business object validation
class BankAccount with ValidatorMixin {
  final String accountNumber;
  final String routingNumber;
  final double balance;
  final String accountType;

  const BankAccount({
    required this.accountNumber,
    required this.routingNumber,
    required this.balance,
    required this.accountType,
  });

  @override
  void validator() {
    // Account number validation
    if (accountNumber.length < 8 || accountNumber.length > 17) {
      throw ValidationException('Account number must be 8-17 digits');
    }
    if (!RegExp(r'^\d+$').hasMatch(accountNumber)) {
      throw ValidationException('Account number must contain only digits');
    }

    // Routing number validation (US format)
    if (routingNumber.length != 9) {
      throw ValidationException('Routing number must be exactly 9 digits');
    }
    if (!RegExp(r'^\d+$').hasMatch(routingNumber)) {
      throw ValidationException('Routing number must contain only digits');
    }

    // Balance validation
    if (balance < 0 && accountType != 'credit') {
      throw ValidationException('Balance cannot be negative for $accountType account');
    }

    // Account type validation
    final validTypes = ['checking', 'savings', 'credit', 'investment'];
    if (!validTypes.contains(accountType.toLowerCase())) {
      throw ValidationException('Invalid account type: $accountType');
    }
  }
}

// Usage with error handling
final account = BankAccount(
  accountNumber: '1234567890',
  routingNumber: '987654321',
  balance: 1500.50,
  accountType: 'checking',
);

// Safe validation
if (account.isValid()) {
  print('Account is valid');
} else {
  print('Account validation failed');
}

// Validation with error logging
bool isAccountValid = account.isValid(
  onError: (error) => print('Validation error: $error'),
);

// Debug validation (re-throws for detailed error info)
try {
  bool isValid = account.isValid(reThrow: true);
} catch (e) {
  print('Detailed validation error: $e');
}
```

#### 💡 Best Practices

| ✅ **Do**                                              | ❌ **Don't**                                      |
| ------------------------------------------------------ | ------------------------------------------------- |
| Keep `validator()` methods focused and lightweight     | Perform side effects (network calls, file I/O)    |
| Use specialized helpers like `regMatch` for validation | Write large validation methods with complex logic |
| Throw descriptive exceptions with helpful messages     | Throw generic exceptions without context          |
| Use `reThrow: true` during testing for debugging       | Ignore validation errors in production            |
| Compose validation by calling other validators         | Duplicate validation logic across classes         |

#### 🔧 Integration with Forms

```dart
// Form integration example
class RegistrationFormValidator with ValidatorMixin {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;

  const RegistrationFormValidator({
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  @override
  void validator() {
    // Use existing patterns
    if (!username.regMatch(regPatterns.username(minLength: 3, maxLength: 20))) {
      throw ValidationException('Invalid username format');
    }
    if (!email.regMatch(regPatterns.email)) {
      throw ValidationException('Invalid email format');
    }
    if (!password.regMatch(regPatterns.password(
      PasswordType.ALL_CHARS_UPPER_LOWER_NUM_SPECIAL,
      minLength: 8
    ))) {
      throw ValidationException('Password does not meet requirements');
    }
    if (password != confirmPassword) {
      throw ValidationException('Passwords do not match');
    }
  }
}

// Usage in Flutter
class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  String? _validationError;

  void _validateForm() {
    final validator = RegistrationFormValidator(
      username: _usernameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
    );

    setState(() {
      _validationError = null;
    });

    final isValid = validator.isValid(
      onError: (error) => setState(() => _validationError = error.toString()),
    );

    if (isValid) {
      _submitForm();
    }
  }
}
```

---


## 📦 Optional<T> — Type-safe null handling with functional patterns

Replace dangerous `null` with a principled, lightweight `Optional<T>`. The API in this guide is **grounded in the actual implementation** of `optional.dart` you shared (including its `Present` / `Absent` types, `Optional.Do` notation, `map2 / map3`, collection helpers, and error/nullable combinators like `tryCatch`, `flatMapNullable`, `flatMapThrowable`, etc.).

> Import once, use everywhere:

```dart
import 'package:dart_suite/dart_suite.dart';
```

---

### Why Optional?

* 🛡️ **Null safety by design** – Impossible to “forget” the empty case; the type system forces you to handle it.
* 🔗 **Fluent functional API** – `map`, `flatMap`, `filter`, `filterMap`, `ap`, `map2/map3`, `andThen`, etc.
* 💡 **Explicit branching** – `match` / `fold` keeps control flow obvious and safe.
* 🧰 **Interops cleanly** – Helpers for `T?` (`Optional.of`, `optional`, `flatMapNullable`, `get()`), thrown errors (`tryCatch`, `flatMapThrowable`), and collections (`traverseList`, `sequenceList`).
* ⚡ **Tiny wrapper** – Minimal overhead; `Present` holds a `T`, `Absent` holds nothing.


### Mental model

`Optional<T>` has two concrete states:

* `Present<T>(value)` – contains a `T`
* `Absent` – contains no value

Create values with **constructors** or **helpers**:

```dart
// Direct
final p = Present(42);                        // Present(42)
const n = Optional<int>.absent();             // Absent

// Idiomatic helpers (top-level)
final a = present(42);                        // Present(42)
final b = absent<int>();                      // Absent

// From nullable + optional predicate
final o1 = Optional.of('John');               // Present('John')
final o2 = Optional.of(null);                 // Absent
final o3 = Optional.of(10, (x) => x > 5);     // Present(10)
final o4 = Optional.of(3,  (x) => x > 5);     // Absent

// Convenience alias (just calls Optional.of)
final ox = optional('hi');                    // Present('hi')
```

---

### Core operations (the ones you’ll use daily)

```dart
// Pattern match (explicitly handle both branches)
final greeting = Optional.of('Alice').match(
  () => 'Hello, stranger!',
  (name) => 'Hello, $name!',
);

// map: T -> B
final len = Optional.of('abc').map((s) => s.length); // Present(3)

// flatMap: T -> Optional<B>
final email = Optional.of('john')
  .flatMap((u) => Optional.of('$u@example.com'));    // Present('john@example.com')

// filter: keep only if predicate is true
final adult = Optional.of(20).filter((n) => n >= 18); // Present(20)
final child = Optional.of(15).filter((n) => n >= 18); // Absent

// filterMap: T -> Optional<B> (filter + transform in one shot)
final parsed = Optional.of('123').filterMap(
  (s) => Optional.tryCatch(() => int.parse(s)),
); // Present(123)

// Fallbacks
final v1 = Optional.of(10).orElse(() => 99); // 10  (lazy)
final v2 = Optional.absent<int>().orElse(() => 99); // 99
final v3 = Optional.of(10).orElseGet(99); // 10  (eager)
final v4 = Optional.absent<int>().orElseGet(99); // 99

// Boolean tests
final presentFlag = Optional.of(1).isPresent; // true
final absentFlag  = Optional.absent<int>().isAbsent; // true
```

### Applicative & multi-arg mapping

**`ma**tch` vs `fold`**: `fold(onAbsent, onPresent)` is an alias for `match(onAbsent, onPresent)`. Use whichever you prefer.


**`ap` & `pure`**: `ap` applies a function **inside** an `Optional` to a value inside another `Optional`.

```dart
double sumToDouble(int a, int b) => (a + b).toDouble();

final a = Optional.of(10);
final b = Optional.of(20);

// Turn `a` into an Optional function we can apply to `b`
final fn = a.map((x) => (int y) => sumToDouble(x, y));

// Apply it to `b`
final out = b.ap(fn); // Present(30.0)
```

### `map2` / `map3`

Convenient when you need both values at once:

```dart
final fullName = Optional.of('Ada').map2(
  Optional.of('Lovelace'),
  (first, last) => '$first $last',
); // Present('Ada Lovelace')

final area = Optional.of(3).map3(
  Optional.of(4),
  Optional.of(5),
  (a, b, c) => a * b * c,
); // Present(60)
```

### `andThen`

Sequence without caring about the previous value:

```dart
final next = Optional.of('ignored').andThen(() => Optional.of(123)); // Present(123)
```

### `extend` / `duplicate`

Operate on the container itself (advanced use):

```dart
final o = Optional.of(5);
final sz = o.extend((self) => self.isPresent ? 'has!' : 'none'); // Present('has!')
final dup = o.duplicate(); // Present(Present(5))
```

---

## Interop with `null` and exceptions (Nullable interop)

```dart
// Build from nullable (and optional predicate)
final ok = Optional.of<int?>(42);      // Present(42)
final no = Optional.of<int?>(null);    // Absent

// Call a nullable-returning function in a flatMap
final nextNum = Optional.of('42')
  .flatMapNullable((s) => int.tryParse(s)); // Present(42)

// Get back to nullable (prefer match/orElse when possible)
final String? maybe = Optional.of('x').get(); // 'x'
final String? none  = Optional.absent<String>().get(); // null
```

### Exceptions as values

```dart
// Wrap a throwing computation
final parsed = Optional.tryCatch(() => int.parse('123'));     // Present(123)
final failed = Optional.tryCatch(() => int.parse('oops'));    // Absent

// Map with a function that may throw
final toInt = Optional.of('99').flatMapThrowable((s) => int.parse(s)); // Present(99)
```


### `traverseList` / `traverseListWithIndex`

Map a list to `Optional`s and collect **all** results, failing fast if any item is `Absent`.

```dart
final inputs = ['1', '2', 'invalid', '4'];

Optional<List<int>> parsed = Optional.traverseList(inputs, (s) =>
  Optional.tryCatch(() => int.parse(s)),
); // Absent (because 'invalid' fails)

final goods = ['1', '2', '3', '4'];
final okAll = Optional.traverseList(goods, (s) =>
  Optional.tryCatch(() => int.parse(s)),
); // Present([1,2,3,4])

// Need indices in your mapping?
Optional.traverseListWithIndex(goods, (s, i) =>
  (i % 2 == 0) ? Optional.tryCatch(() => int.parse(s))
               : Optional.absent(),
); // Absent (because odd indexes absent)
```

### `sequenceList`

Turn `List<Optional<A>>` into `Optional<List<A>>`:

```dart
final list = [Optional.of(1), Optional.of(2), Optional.of(3)];
final seq  = Optional.sequenceList(list); // Present([1,2,3])

final withHole = [Optional.of(1), Optional.absent<int>(), Optional.of(3)];
final none     = Optional.sequenceList(withHole); // Absent
```


### Predicates & partitioning

```dart
// Lift a predicate to Optional
final nonEmpty = Optional.fromPredicate('abc', (s) => s.isNotEmpty); // Present('abc')

// Map if predicate passes
final lengthWhenNonEmpty = Optional.fromPredicateMap<String, int>(
  'abc',
  (s) => s.isNotEmpty,
  (s) => s.length,
); // Present(3)

// Split into (leftWhenFalse, rightWhenTrue)
final (left, right) = Optional.of(10).partition((n) => n.isEven);
// left  = Absent, right = Present(10)
```

### The “Do notation” (ergonomic chaining)

`Optional.Do` lets you write sequential code and **extract** from `Optional`s using a special adapter (`$`). If any extracted value is `Absent`, the whole block becomes `Absent` automatically.

```dart
final res = Optional.Do(($) {
  final user   = $(findUserById(123));           // Optional<User>
  final email  = $(getVerifiedEmail(user));      // Optional<String>
  final lower  = email.toLowerCase();
  return lower;
});
```

> Under the hood it uses a private throw/catch on an adapter; that’s exactly what the code in `optional.dart` implements.


### Validation (no `if` pyramids)

```dart
class Registration {
  final String email;
  final String password;
  final int age;

  Registration({required this.email, required this.password, required this.age});

  Optional<String> validateEmail() =>
      Optional.fromPredicate(email, (e) => RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(e));

  Optional<String> validatePassword() =>
      Optional.fromPredicate(password, (p) => p.length >= 8);

  Optional<int> validateAge() =>
      Optional.fromPredicate(age, (a) => a >= 13 && a <= 120);

  Optional<Registration> validate() =>
      validateEmail()
        .andThen(validatePassword)
        .andThen(validateAge)
        .map((_) => this);
}
```

### API cheat-sheet (as implemented)

**Creation**

* `Present(value)` / `const Optional.absent()`
* `present<T>(t)` / `absent<T>()`
* `Optional.of([T? value, Predicate<T>? predicate])`
* `optional([value, predicate])` (alias to `Optional.of`)
* `Optional.fromPredicate(value, predicate)`
* `Optional.fromPredicateMap(value, predicate, f)`
* `Optional.tryCatch(() => ...)`
* `Optional.flatten(Optional<Optional<T>> m)`

**Core**

* `match(onAbsent, onPresent)` / `fold(onAbsent, onPresent)`
* `map(f)` / `flatMap(f)` / `flatMapNullable(f)` / `flatMapThrowable(f)`
* `filter(pred)` / `filterMap(f)` / `partition(pred)`
* `orElse(() => t)` / `orElseGet(t)` / `or(() => Optional<T>)`
* `isPresent` / `isAbsent` / `get()` (→ `T?`)

**Applicative & friends**

* `ap(Optional<B Function(T)>)` / `pure(b)`
* `map2(other, (a, b) => ...)`
* `map3(b, c, (a, b, c) => ...)`
* `andThen(() => Optional<B>)`
* `extend(f)` / `duplicate()`

**Collections**

* `Optional.traverseList(list, f)`
* `Optional.traverseListWithIndex(list, (a, i) => ...)`
* `Optional.sequenceList(list)`

**Do notation**

* `Optional.Do(($) { final x = $(opt); ... return ...; })`

**Equality & debug**

* `Present(a) == Present(b)` if `a == b`
* `Absent == Absent`
* `toString()`: `Present(value)` / `Absent`

---

## Best practices

| ✅ Do                                                     | ❌ Don’t                                                        |
| -------------------------------------------------------- | -------------------------------------------------------------- |
| Use `match`/`fold` to handle both branches               | Call `.get()` and assume non-null                              |
| Prefer `flatMap` to avoid nested `Optional<Optional<T>>` | Create `Optional<T?>` unless you truly need nested nullability |
| Use `filter`/`filterMap` instead of `if` chains          | Mix `null` and `Optional` haphazardly                          |
| Wrap throwing code with `tryCatch` or `flatMapThrowable` | Throw inside business logic and forget to catch                |
| Use `traverseList/sequenceList` for batch workflows      | Loop manually and forget to short-circuit on failure           |
| Reach for `map2`/`map3` for multi-input logic            | Chain deep pyramids of `flatMap` when combining many values    |

---

## 🚀 Extensions

> **Powerful utility extensions that enhance Dart's built-in types and functionality**

Dart Suite includes comprehensive extensions for strings, collections, numbers, dates, and more to make your code more expressive and concise.

#### 🔤 String Extensions

- **Case conversions** with `reCase`
- **Validation** with `regMatch`, `regAnyMatch`, `regAllMatch`
- **Parsing utilities** for safer type conversions
- **Text manipulation** helpers

#### 📊 Collection Extensions

- **Iterable enhancements** for filtering, mapping, and grouping
- **Map utilities** for safer access and transformation
- **Set operations** for mathematical set operations
- **List helpers** for common operations

#### 🔢 Numeric Extensions

- **Mathematical operations** like GCD, LCM
- **Range checks** and boundary utilities
- **Formatting helpers** for display

#### ⏰ DateTime Extensions

- **Relative time** with Timeago integration
- **Date arithmetic** and comparison utilities
- **Formatting shortcuts** for common patterns

#### 🎯 Optional Extensions

- **Null safety** helpers with `Optional<T>`
- **Safe chaining** operations
- **Default value** handling

---

## 🤝 Contributing

We welcome contributions to make Dart Suite even better! Here's how you can help:

#### 🐛 Reporting Issues

- Use our [issue tracker](https://github.com/rahulsharmadev0/suite/issues)
- Provide detailed reproduction steps
- Include version information and error logs

#### 🔧 Contributing Code

- Fork the repository
- Create a feature branch: `git checkout -b feature/amazing-feature`
- Write tests for your changes
- Ensure all tests pass: `dart test`
- Submit a pull request with clear description

#### 📖 Improving Documentation

- Help improve examples and explanations
- Add real-world use cases
- Fix typos and unclear sections

#### 💡 Suggesting Features

- Open an issue with the `enhancement` label
- Describe your use case clearly
- Provide examples of how it would work

---

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](https://github.com/rahulsharmadev0/suite/blob/main/packages/dart_suite/LICENSE) file for details.

### 📞 Support & Community

- 🐛 **Issues**: [GitHub Issues](https://github.com/rahulsharmadev0/suite/issues)
- 📚 **Documentation**: [API Reference](https://pub.dev/documentation/dart_suite/latest/)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/rahulsharmadev0/suite/discussions)
- ⭐ **Show Support**: [Star on GitHub](https://github.com/rahulsharmadev0/suite)

---

<div align="center">

**Made with ❤️ by [Rahul Sharma](https://github.com/rahulsharmadev0)**

_If this package has been helpful, consider giving it a ⭐ on [GitHub](https://github.com/rahulsharmadev0/suite)!_

</div>
