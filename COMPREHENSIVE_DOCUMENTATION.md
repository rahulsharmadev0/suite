# 📚 Comprehensive Documentation - Suite Repository

This repository contains a comprehensive suite of Dart and Flutter packages designed to enhance development productivity. This documentation provides deep, beginner-friendly yet technically accurate coverage of every file, class, function, and utility in the project.

## 📦 Package Overview

- **[dart_suite](#dart-suite)**: Core Dart utilities and extensions
- **[bloc_suite](#bloc-suite)**: Flutter BLoC utilities and extensions  
- **[flutter_suite](#flutter-suite)**: Flutter-specific utilities and widgets
- **[gen_suite](#gen-suite)**: Code generation utilities

---

# 🎯 dart_suite

The `dart_suite` package provides a comprehensive collection of utilities, extensions, and data structures for enhanced Dart development productivity. It serves as the foundation layer for the entire suite.

## 📁 Main Library Structure

### dart_suite.dart

**Overview**: The main entry point that exports all utilities and extensions from the dart_suite package.

**Technical Explanation**: This library file uses Dart's export directive to make all functionality available through a single import. It follows the standard Dart package structure by exporting from two main modules: `extensions.dart` and `utility.dart`.

**Usage Examples**:

1. **Basic Import and Usage**:
```dart
import 'package:dart_suite/dart_suite.dart';

void main() {
  // Access all utilities through single import
  final text = "hello world";
  print(text.camelCase); // "helloWorld" - from string extensions
  
  final cache = LRUCache<String, int>(capacity: 100); // from utilities
  cache['key'] = 42;
}
```

2. **Advanced Multi-Feature Usage**:
```dart
import 'package:dart_suite/dart_suite.dart';

void main() async {
  // Combine multiple utilities
  final result = await Guard.async(() => 
    Retry.exponential().execute(() => 
      fetchDataFromApi()
    )
  );
  
  if (result.isSuccess) {
    final timeAgo = result.value.timestamp.timeago(); // "2 hours ago"
    print('Data fetched $timeAgo');
  }
}
```

**Notes/Best Practices**: 
- Always import the main library file rather than individual modules for consistency
- The package is designed to have minimal conflicts with existing Dart libraries
- All utilities are null-safe and follow modern Dart patterns

---

## 🔧 Core Utilities

### Guard - Safe Error Handling

**Overview**: Guard provides a robust, functional approach to error handling in Dart. It wraps potentially throwing operations in try-catch blocks and offers graceful fallbacks, making your code more resilient and predictable.

**Technical Explanation**: Guard uses extension methods on function types to provide a clean API. It works with both synchronous and asynchronous operations, offering different return strategies - either returning default values on error or boolean success indicators. The implementation uses Dart's generic system to maintain type safety while providing flexible error handling.

**Usage Examples**:

1. **Basic Safe Parsing**:
```dart
// Instead of this risky code:
// int result = int.parse(userInput); // Could throw!

// Use guard for safe parsing:
final result = guard(
  () => int.parse(userInput),
  def: 0, // default value if parsing fails
  onError: (e) => print('Invalid input: $e'),
);
print('Parsed value: $result'); // Always prints a valid integer
```

2. **Advanced Async Network Operations**:
```dart
// Safe API call with retry logic
final userData = await asyncGuard(
  () async {
    final response = await httpClient.get('/user/profile');
    return UserProfile.fromJson(response.data);
  },
  def: UserProfile.guest(), // fallback user profile
  onError: (error) {
    logger.warning('Failed to load user profile', error);
    analytics.trackError('profile_load_failed', error);
  },
);

// Check if operation succeeded without throwing
final uploadSuccess = await asyncGuardSafe(
  () => uploadFileToServer(file),
  onError: (e) => showErrorSnackbar('Upload failed: ${e.message}'),
);

if (uploadSuccess) {
  showSuccessMessage('File uploaded successfully!');
}
```

**Notes/Best Practices**:
- Use `guard()` when you need a result with fallback values
- Use `guardSafe()` when you only need to know if an operation succeeded
- Always provide meaningful default values that make sense in your application context
- Consider logging errors even when providing defaults to aid in debugging
- The `reThrow` parameter should be used sparingly, mainly for debugging scenarios
- Guard is perfect for parsing user input, file operations, and network calls

---

### Retry - Automatic Retry Mechanism

**Overview**: Retry provides intelligent retry mechanisms with exponential backoff, helping handle transient failures in network requests, file operations, or any potentially failing operations.

**Technical Explanation**: The retry system implements exponential backoff with configurable jitter (randomization) to prevent thundering herd problems. It calculates delays as `pow(2, attempt) * delayFactor` with randomization, capped at `maxDelay`. The system distinguishes between retryable exceptions and permanent failures, allowing fine-grained control over what should trigger a retry.

**Usage Examples**:

1. **Basic Network Retry**:
```dart
import 'dart:io';

// Simple HTTP request with retry
final response = await retry(
  () => HttpClient().get('api.example.com', 443, '/users'),
  maxAttempts: 3,
  retryIf: (e) => e is SocketException || e is HttpException,
  onRetry: (e) => print('Retrying due to: ${e.toString()}'),
);
```

2. **Advanced Policy-Based Retry**:
```dart
// Define custom retry policies for different scenarios
final criticalDataPolicy = RetryPolicy(
  maxAttempts: 5,
  initialDelay: Duration(milliseconds: 500),
  maxDelay: Duration(seconds: 30),
  backoffMultiplier: 1.5,
  randomizeDelay: true,
);

// Use with complex async operations
final userData = await retryWithPolicy(
  () async {
    final response = await dio.get('/critical-user-data');
    if (response.statusCode != 200) {
      throw HttpException('Server error: ${response.statusCode}');
    }
    return UserData.fromJson(response.data);
  },
  policy: criticalDataPolicy,
  retryIf: (e) => e is DioError && e.response?.statusCode != 404,
  onRetry: (e) => logger.info('Retrying critical data fetch: $e'),
);

// Extension method usage
final result = await (() => fetchImportantData()).executeWithPolicy(
  policy: RetryPolicy.aggressivePolicy,
);
```

**Notes/Best Practices**:
- Use `RetryPolicy.defaultPolicy` for most network operations (3 attempts, exponential backoff)
- Use `RetryPolicy.aggressivePolicy` for critical operations that must succeed
- Always define `retryIf` to avoid retrying on permanent failures (like 404 errors)
- The `onRetry` callback is perfect for logging and monitoring retry attempts
- Default delay starts at 400ms and doubles each attempt with ±25% randomization
- Be careful with `maxAttempts` - high values can cause long delays for users

---

### Debounce - Rate Limiting Control

**Overview**: Debounce controls the rate of function execution by delaying calls and cancelling previous pending calls. It's essential for handling rapid user input, search queries, and preventing excessive API calls.

**Technical Explanation**: Debounce uses Dart's Timer mechanism to delay function execution. When a new call arrives, it cancels any pending timer and starts a fresh delay. This ensures that only the last call in a series of rapid calls actually executes, after the specified delay period has passed without new calls. The implementation supports both leading and trailing edge execution patterns.

**Usage Examples**:

1. **Search Input Debouncing**:
```dart
// Prevent excessive API calls while user types
void searchUsers(String query) async {
  if (query.isEmpty) return;
  
  final results = await userApi.search(query);
  updateSearchResults(results);
}

// Create debounced version
final debouncedSearch = debounce(
  searchUsers,
  Duration(milliseconds: 300), // Wait 300ms after user stops typing
  trailing: true, // Execute on the trailing edge
);

// Usage in text field
TextField(
  onChanged: (query) => debouncedSearch.execute([query]),
  decoration: InputDecoration(hintText: 'Search users...'),
)
```

2. **Advanced Save Draft Functionality**:
```dart
class DocumentEditor {
  final _saveDraft = debounce(
    _performSave,
    Duration(seconds: 2),
    leading: false,  // Don't save immediately
    trailing: true,  // Save after user stops editing
    maxWait: Duration(seconds: 30), // Force save every 30 seconds
  );

  void onTextChanged(String content) {
    // This will be debounced - only saves after user stops editing
    _saveDraft.execute([content]);
    
    // Check if save is pending
    if (_saveDraft.isPending) {
      showSavingIndicator();
    }
  }

  void _performSave(String content) {
    // Actual save logic
    saveToServer(content).then((_) => showSavedIndicator());
  }

  void dispose() {
    // Flush any pending saves before disposal
    _saveDraft.flush();
    _saveDraft.cancel();
  }
}

// Extension method usage
final quickSave = (() => saveDocument()).debounced(
  Duration(milliseconds: 500),
);
```

**Notes/Best Practices**:
- Use 200-500ms delays for search inputs to balance responsiveness with API efficiency
- Set `maxWait` for critical operations that must eventually execute (like auto-save)
- Always call `cancel()` in dispose methods to prevent memory leaks
- Use `flush()` when you need immediate execution of pending calls
- `leading: true` executes immediately, then prevents subsequent calls during the wait period
- Check `isPending` to show loading states to users

---

### Throttle - Fixed Rate Execution

**Overview**: Throttle limits function execution to a fixed rate, ensuring functions don't run more than once per specified time period. Unlike debounce, throttle guarantees regular execution intervals.

**Technical Explanation**: Throttle is implemented as a specialized debounce with `maxWait` equal to the throttle duration. This ensures that functions execute at regular intervals regardless of call frequency. The implementation maintains the timing constraints while providing both leading and trailing edge execution options.

**Usage Examples**:

1. **Progress Update Throttling**:
```dart
// Update progress UI at most once every 100ms
void updateUploadProgress(double progress) {
  progressBar.value = progress;
  statusText.text = '${(progress * 100).toStringAsFixed(1)}%';
}

final throttledProgress = throttle(
  updateUploadProgress,
  Duration(milliseconds: 100),
  leading: true,  // Update immediately on first call
  trailing: true, // Update with final value
);

// Usage during file upload
void onUploadProgress(double progress) {
  throttledProgress.execute([progress]);
  // UI updates at most 10 times per second, no matter how fast progress comes
}
```

2. **Scroll Event Throttling**:
```dart
class ScrollAnalytics {
  final _trackScroll = throttle(
    _logScrollPosition,
    Duration(milliseconds: 250), // Track at most 4 times per second
    leading: false, // Don't track the initial scroll
    trailing: true, // Track the final position
  );

  void onScrollChanged(ScrollController controller) {
    _trackScroll.execute([controller.offset]);
  }

  void _logScrollPosition(double offset) {
    analytics.track('scroll_position', {'offset': offset});
  }

  void dispose() {
    _trackScroll.flush(); // Log final position
    _trackScroll.cancel();
  }
}

// Extension usage for API rate limiting
final rateLimitedApi = (() => sendAnalytics()).throttle(Duration(seconds: 5));
```

**Notes/Best Practices**:
- Use throttle for smooth UI updates (progress bars, animations, scroll events)
- Set `leading: true` for immediate feedback, `trailing: true` for final state capture  
- Throttle is ideal for analytics tracking to avoid overwhelming servers
- Unlike debounce, throttle provides predictable execution intervals
- Perfect for rate-limiting API calls that need regular execution
- Use 100-500ms intervals for UI updates, longer intervals for analytics

---

## 🕒 Time Utilities

### Timeago - Human-Readable Time Formatting

**Overview**: Timeago converts dates and timestamps into human-readable relative time formats like "2 hours ago", "in 3 days", making temporal information more intuitive for users.

**Technical Explanation**: Timeago calculates the difference between a given DateTime and the current time, then maps these differences to appropriate human-readable strings using configurable symbol data. It supports both past and future times, handles various time units (seconds to years), and provides localization support through customizable symbol sets. The implementation uses pattern matching to determine the appropriate time unit and format.

**Usage Examples**:

1. **Basic Time Formatting**:
```dart
// Format past times
final postTime = DateTime.now().subtract(Duration(hours: 2));
print(postTime.timeago().format()); // "2 hours ago"

final oldPost = DateTime(2023, 1, 15);
print(oldPost.timeago().format()); // "11 months ago" (from current date)

// Duration-based formatting
final duration = Duration(minutes: 30);
print(duration.timeago().format()); // "30 minutes"

// Just now handling (less than 10 seconds)
final recent = DateTime.now().subtract(Duration(seconds: 5));
print(recent.timeago().format()); // "just now"
```

2. **Advanced Configuration and Localization**:
```dart
class SocialMediaPost {
  final DateTime createdAt;
  final String content;
  
  SocialMediaPost(this.createdAt, this.content);
  
  String get timeDisplay {
    final timeago = createdAt.timeago();
    
    // Enable short format for compact display
    timeago.enableShort = true;  // "2h" instead of "2 hours"
    timeago.enableSuffix = false; // Remove "ago" suffix
    
    return timeago.format();
  }
  
  String get fullTimeDisplay {
    return createdAt.timeago(locale: 'en_US').format();
  }
}

// Usage in UI
class PostWidget extends StatelessWidget {
  final SocialMediaPost post;
  
  const PostWidget(this.post);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(post.content),
          Text(
            post.timeDisplay, // "2h", "1d", etc.
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}

// Custom symbol configuration
final customTimeago = Timeago.since(
  DateTime.now().subtract(Duration(days: 5)),
  symbol: TimeagoSymbol(
    JUST_NOW: TimeagoSymbolValue('now', 'n'),
    SECONDS: TimeagoSymbolValue('seconds', 's'),
    // ... other custom symbols
  ),
);
```

**Notes/Best Practices**:
- Use `enableShort = true` for compact UI elements (mobile, cards, badges)
- Disable suffix with `enableSuffix = false` when space is limited
- The "just now" threshold is 10 seconds for better UX
- Time calculations handle months as 30 days and years as 365 days
- For precise timestamps, show exact dates for items older than a week
- Consider updating timeago strings periodically for live content (every minute)
- Use appropriate locales for international applications

---

### ReCase - String Case Conversion

**Overview**: ReCase provides comprehensive string case conversions between different naming conventions like camelCase, snake_case, kebab-case, and PascalCase, making it easy to transform text for different contexts.

**Technical Explanation**: ReCase analyzes input strings to identify word boundaries using various delimiters (spaces, underscores, hyphens, case changes) and rebuilds them according to specific formatting rules. It handles special cases like all-caps text and preserves word integrity while converting between formats. The algorithm first splits text into words, then applies formatting rules for each target case.

**Usage Examples**:

1. **API and Database Field Conversion**:
```dart
// Convert between API and Dart naming conventions
final apiField = "user_profile_image_url";
final dartProperty = apiField.reCase.camelCase; // "userProfileImageUrl"

// Convert for database table names
final className = "UserProfileData";
final tableName = className.reCase.snakeCase; // "user_profile_data"

// URL parameter conversion
final variableName = "sortDirection";
final urlParam = variableName.reCase.paramCase; // "sort-direction"

// Example usage in API mapping
class ApiConverter {
  static Map<String, dynamic> toDartMap(Map<String, dynamic> apiData) {
    final dartMap = <String, dynamic>{};
    
    for (final entry in apiData.entries) {
      final dartKey = entry.key.reCase.camelCase;
      dartMap[dartKey] = entry.value;
    }
    
    return dartMap;
  }
}
```

2. **Advanced Text Processing and File System Operations**:
```dart
class FilePathGenerator {
  // Generate file paths in different formats
  static String generatePath(String description, PathType type) {
    final recase = description.reCase;
    
    return switch (type) {
      PathType.unix => recase.pathCase,     // "user/profile/data"
      PathType.url => recase.paramCase,     // "user-profile-data"  
      PathType.constant => recase.constantCase, // "USER_PROFILE_DATA"
      PathType.class => recase.pascalCase,  // "UserProfileData"
    };
  }
}

// Document title formatting
class DocumentProcessor {
  static String formatTitle(String rawTitle) {
    final recase = rawTitle.reCase;
    
    // Clean multiple formats
    final formats = {
      'title': recase.titleCase,       // "User Profile Data"
      'header': recase.headerCase,     // "User-Profile-Data"  
      'sentence': recase.sentenceCase, // "User profile data"
      'dot': recase.dotCase,          // "user.profile.data"
    };
    
    return formats['title']!;
  }
}

// Custom symbol set for special parsing
final customRecase = ReCase._(
  "my#special@text", 
  {'#', '@', ' ', '_'}, // Custom word boundary symbols
);

print(customRecase.camelCase); // "mySpecialText"
```

**Notes/Best Practices**:
- Default symbol set includes space, period, slash, underscore, backslash, and hyphen
- Use `camelCase` for Dart properties and variables  
- Use `snake_case` for database fields and file names
- Use `PascalCase` for class names and types
- Use `param-case` for URLs and CSS classes
- Use `CONSTANT_CASE` for environment variables and constants
- The algorithm handles all-caps input intelligently (e.g., "XML_HTTP_REQUEST")
- Custom symbol sets allow parsing domain-specific text formats

---

## 📊 Data Structures

### LRU Cache - Least Recently Used Cache

**Overview**: LRU Cache is a memory-efficient caching data structure that automatically removes the least recently used items when the cache reaches capacity, providing fast access to frequently used data while maintaining bounded memory usage.

**Technical Explanation**: The LRU Cache combines a HashMap for O(1) key lookups with a doubly-linked list to track access order. When an item is accessed or added, it moves to the front of the list. When capacity is exceeded, items are removed from the back of the list (least recently used). This implementation uses LinkedHashMap's insertion order to track usage, providing O(1) operations for get, put, and remove.

**Usage Examples**:

1. **Simple Data Caching**:
```dart
// Create cache with capacity of 100 items
final cache = LruCache<String, User>(100);

// Store user data (promotes to most recently used)
cache['user123'] = User(id: '123', name: 'John Doe');
cache.put('user456', User(id: '456', name: 'Jane Smith'));

// Retrieve data (promotes key to MRU)
final user = cache.get('user123');
final userAlt = cache['user123']; // Same as get()

print('Cache size: ${cache.length}');
print('Has user456: ${cache.containsKey('user456')}');

// When cache exceeds capacity, least recently used items are evicted
for (int i = 0; i < 150; i++) {
  cache['temp_$i'] = User(id: 'temp_$i', name: 'Temp User $i');
}
// Only the last 100 users remain, earlier ones evicted
```

2. **Advanced Caching with Computed Values**:
```dart
class ImageCache {
  final LruCache<String, Future<Image>> _cache;
  final HttpClient _httpClient = HttpClient();
  
  ImageCache({int capacity = 50}) : _cache = LruCache(capacity);
  
  Future<Image> getImage(String url) async {
    // Check if image is already cached or being loaded
    final cached = _cache.get(url);
    if (cached != null) return cached;
    
    // Start loading and cache the future immediately
    final future = _loadImage(url);
    _cache.put(url, future);
    
    return future;
  }
  
  Future<Image> _loadImage(String url) async {
    final request = await _httpClient.getUrl(Uri.parse(url));
    final response = await request.close();
    return decodeImage(await response.expand((e) => e).toList());
  }
  
  void preloadImages(List<String> urls) {
    for (final url in urls) {
      // putIfAbsent only loads if not already present
      _cache.putIfAbsent(url, () => _loadImage(url));
    }
  }
  
  // Cache statistics
  Map<String, dynamic> get stats => {
    'size': _cache.length,
    'capacity': _cache.capacity,
    'utilization': _cache.length / _cache.capacity,
    'keys': _cache.keys.toList(),
  };
  
  void dispose() {
    _cache.clear();
    _httpClient.close();
  }
}

// Usage with automatic cleanup
final imageCache = ImageCache(capacity: 20);

// These will be cached and reused
final avatar1 = await imageCache.getImage('https://example.com/avatar1.jpg');
final avatar2 = await imageCache.getImage('https://example.com/avatar2.jpg');

// Accessing avatar1 again promotes it to most recently used
final avatar1Again = await imageCache.getImage('https://example.com/avatar1.jpg');
assert(identical(avatar1, avatar1Again)); // Same Future object
```

**Notes/Best Practices**:
- Choose capacity based on memory constraints and access patterns
- Use `get()` method to promote keys to most recently used
- `put()` always promotes keys, even for updates
- `putIfAbsent()` is efficient for lazy loading patterns
- Reading promotes keys automatically, which affects iteration order
- Consider caching expensive-to-compute values, not just data
- The cache is thread-safe for reads but not for concurrent modifications
- Use `clear()` to free memory when cache is no longer needed
- Monitor cache hit rates to optimize capacity and performance

---

## 🎯 Extensions and Utilities

Now let's examine the extensive collection of extensions that make Dart development more convenient and expressive.

### String Extensions - Enhanced Text Processing

**Overview**: String extensions provide powerful text processing capabilities including validation, formatting, parsing, encoding, and utility methods that make common string operations more intuitive and efficient.

**Technical Explanation**: These extensions leverage Dart's pattern matching, regular expressions, and character code operations to provide robust text processing. They handle edge cases like whitespace normalization, numeric extraction, and encoding/decoding operations while maintaining performance through efficient algorithms.

**Usage Examples**:

1. **Text Validation and Cleaning**:
```dart
// Validation utilities
final userInput = "  hello@world.com  ";
print(userInput.isNotBlank); // true (has non-whitespace content)
print("   ".isBlank);        // true (only whitespace)

// Text cleaning and formatting
final messyText = "  This   has   multiple   spaces.  ";
print(messyText.normalizeSpaces); // "This has multiple spaces."

final textWithNewlines = "what is \\n your name";
print(textWithNewlines.trimAll); // "whatisyourname"

// Numeric extraction
final mixed = "OTP 12312 27/04/2020";
print(mixed.numericOnly());           // "1231227042020"
print(mixed.numericOnly(firstWordOnly: true)); // "12312"

// File format detection
final filePath = "document.pdf?version=1.2";
print(filePath.fileFormat); // "pdf"
```

2. **Advanced Text Processing and Encoding**:
```dart
class TextProcessor {
  // Process user input with comprehensive cleaning
  static String processUserInput(String raw) {
    return raw
        .normalizeSpaces    // Clean whitespace
        .trim()            // Remove leading/trailing spaces
        .toLowerCase();    // Normalize case
  }
  
  // Create readable separated text (like credit card numbers)
  static String formatIdentifier(String id) {
    return id.removeAllSpace.separate(
      min: 4, 
      max: 4, 
      separator: '-'
    ); // "1234567890123456" → "1234-5678-9012-3456"
  }
  
  // Boolean string parsing
  static bool? parseBooleanSafely(String? value) {
    if (value == null) return null;
    
    if (value.isBool) {
      return value.isTrue;
    }
    
    return null; // Invalid boolean string
  }
  
  // Secure data handling
  static String encodeSecurely(String sensitive) {
    return sensitive.toEncodedBase64;
  }
  
  static String decodeSecurely(String encoded) {
    try {
      return encoded.toDecodedBase64;
    } catch (e) {
      throw FormatException('Invalid base64 string');
    }
  }
}

// URL and path utilities
final segment = "api/users";
final fullPath = segment.createPath(['profile', 'settings']);
print(fullPath); // "/api/users/profile/settings"

// Text analysis
final word = "racecar";
print(word.isPalindrom()); // true

final phrase = "race a car";
print(phrase.isPalindrom(removeAllSpace: true)); // true

// Character manipulation
print("hello".reversed); // "olleh"
print("world".toList);   // ['w', 'o', 'r', 'l', 'd']
```

**Notes/Best Practices**:
- Use `isNotBlank` instead of `isNotEmpty` when whitespace-only strings should be treated as empty
- `numericOnly()` with `firstWordOnly: true` is perfect for extracting OTPs or reference numbers
- The `separate()` method is ideal for formatting IDs, phone numbers, and credit card numbers
- Base64 encoding/decoding is useful for API data transmission and simple obfuscation
- `normalizeSpaces` is essential for user input cleaning and search functionality
- `createPath()` automatically handles leading slashes for consistent URL/path building

---

### DateTime Extensions - Enhanced Date Operations

**Overview**: DateTime extensions provide convenient methods for date manipulation, comparison, formatting, and time-based calculations, making temporal operations more intuitive and reducing boilerplate code.

**Technical Explanation**: These extensions build upon Dart's DateTime class to provide commonly needed operations like copying with modifications, time period detection, Unix timestamp conversion, and meridiem (AM/PM) handling. The implementations account for timezone differences and edge cases in date calculations.

**Usage Examples**:

1. **Date Manipulation and Comparison**:
```dart
final now = DateTime.now();
final birthday = DateTime(1990, 6, 15);

// Check if date is today
print(now.isToday); // true
print(birthday.isToday); // false

// Copy with modifications (immutable updates)
final nextYear = now.copyWith(year: now.year + 1);
final endOfMonth = now.copyWith(
  day: DateTime(now.year, now.month + 1, 0).day, // Last day of month
  hour: 23,
  minute: 59,
  second: 59,
);

// Time period calculations
print(now.quarter); // 1, 2, 3, or 4 based on month

// Unix timestamp conversion
final unixTime = now.toUnixTime();
print('Unix timestamp: $unixTime');

// 12-hour format support
final afternoon = DateTime(2024, 1, 1, 15, 30); // 3:30 PM
print(afternoon.period);      // Meridiem.pm
print(afternoon.hourOfPeriod); // 3 (3 PM)

final midnight = DateTime(2024, 1, 1, 0, 0); // 12:00 AM
print(midnight.period);       // Meridiem.am
print(midnight.hourOfPeriod); // 12
```

2. **Advanced Date Operations and Business Logic**:
```dart
class EventScheduler {
  // Check if event is happening today
  static bool isEventToday(DateTime eventDate) {
    return eventDate.isToday;
  }
  
  // Schedule recurring event (monthly)
  static List<DateTime> generateMonthlyEvents(
    DateTime start, 
    int months
  ) {
    final events = <DateTime>[];
    
    for (int i = 0; i < months; i++) {
      final eventDate = start.copyWith(
        month: start.month + i,
      );
      events.add(eventDate);
    }
    
    return events;
  }
  
  // Business hours checker
  static bool isBusinessHours(DateTime dateTime) {
    final businessStart = dateTime.copyWith(hour: 9, minute: 0);
    final businessEnd = dateTime.copyWith(hour: 17, minute: 0);
    
    return dateTime >= businessStart && dateTime <= businessEnd;
  }
  
  // Quarter-based reporting
  static String getQuarterReport(DateTime date) {
    return 'Q${date.quarter} ${date.year}';
  }
}

// Usage in real applications
class TimeTracker {
  final List<DateTime> clockIns = [];
  
  void clockIn() {
    final now = DateTime.now();
    
    if (EventScheduler.isBusinessHours(now)) {
      clockIns.add(now);
      print('Clocked in at ${now.hour}:${now.minute.toString().padLeft(2, '0')}');
    } else {
      print('Outside business hours!');
    }
  }
  
  DateTime? get todaysClockIn {
    return clockIns.where((time) => time.isToday).firstOrNull;
  }
}

// API integration with Unix timestamps
class ApiClient {
  static Map<String, dynamic> createTimestampPayload(DateTime eventTime) {
    return {
      'event_time': eventTime.toUnixTime(),
      'timezone': eventTime.timeZoneName,
      'is_today': eventTime.isToday,
      'quarter': eventTime.quarter,
    };
  }
}
```

**Notes/Best Practices**:
- `copyWith()` is essential for immutable date updates - avoid modifying DateTime objects directly
- Use `isToday` for dashboard widgets and "today's events" type features
- `toUnixTime()` is perfect for API integration and database storage
- The `quarter` property is useful for business reporting and analytics
- `hourOfPeriod` handles 12-hour format display correctly (12 AM/PM edge cases)
- Use the less-than operator `<` for readable date comparisons
- Always consider timezone implications when using these extensions
- `copyWith()` preserves UTC/local timezone context automatically

---

**Usage Examples**:

1. **Async Delays and Time Management**:
```dart
// Simple delays
await Duration(seconds: 2).delay();
print('2 seconds have passed');

// Delays with callbacks
await Duration(milliseconds: 500).delay(() {
  print('This executes after 500ms');
});

// Extended time unit calculations
final longDuration = Duration(days: 400);
print('Years: ${longDuration.inYears}');     // 1 year (400/365 ≈ 1)
print('Months: ${longDuration.inMonths}');   // 13 months (400/30.4167 ≈ 13)
print('Weeks: ${longDuration.inWeeks}');     // 57 weeks (400/7)

// Time formatting for display
final playbackTime = Duration(minutes: 2, seconds: 30);
print(playbackTime.hms()); // "2:30"

final longerTime = Duration(hours: 1, minutes: 23, seconds: 45);
print(longerTime.hms(showFull: true)); // "1:23:45"
```

2. **Advanced Timing and Animation Control**:
```dart
class AnimationController {
  static const animationDuration = Duration(milliseconds: 300);
  static const delayBetweenAnimations = Duration(milliseconds: 100);
  
  static Future<void> staggeredAnimation(List<Widget> widgets) async {
    for (int i = 0; i < widgets.length; i++) {
      // Start animation for current widget
      animateWidget(widgets[i]);
      
      // Wait before starting next animation
      await delayBetweenAnimations.delay();
    }
  }
  
  static void animateWidget(Widget widget) {
    // Animation logic here
  }
}

// Media player progress display
class MediaPlayer {
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration(minutes: 5, seconds: 30);
  
  String get progressDisplay {
    return '${currentPosition.hms()} / ${totalDuration.hms()}';
  }
  
  String get timeRemaining {
    final remaining = totalDuration - currentPosition;
    return '-${remaining.hms()}';
  }
  
  // Calculate approximate time periods for statistics
  void logPlaybackStatistics() {
    final totalWeeks = totalDuration.inWeeks;
    final totalMonths = totalDuration.inMonths;
    
    print('Total content: $totalWeeks weeks, $totalMonths months');
  }
}

// Polling and retry with custom intervals
class DataPoller {
  static const pollInterval = Duration(seconds: 30);
  static const maxPollDuration = Duration(minutes: 10);
  
  Future<void> startPolling(Future<bool> Function() dataCheck) async {
    final stopTime = DateTime.now().add(maxPollDuration);
    
    while (DateTime.now().isBefore(stopTime)) {
      final hasNewData = await dataCheck();
      
      if (hasNewData) {
        print('New data received!');
        break;
      }
      
      print('No new data, waiting ${pollInterval.inSeconds}s...');
      await pollInterval.delay();
    }
    
    print('Polling completed after ${maxPollDuration.inMinutes} minutes max');
  }
}

// Timeout management
class ApiClient {
  static const requestTimeout = Duration(seconds: 10);
  static const retryDelay = Duration(seconds: 2);
  
  Future<Response> makeRequestWithTimeout() async {
    try {
      return await http.get(Uri.parse('/api/data'))
          .timeout(requestTimeout);
    } catch (e) {
      print('Request failed, retrying in ${retryDelay.inSeconds}s...');
      await retryDelay.delay();
      rethrow;
    }
  }
}
```

**Notes/Best Practices**:
- `delay()` is perfect for animations, polling, and rate limiting
- Extended time units (years/months) use approximations - don't use for precise calculations
- `hms()` provides clean time formatting for media players and timers
- Use `delay()` with callbacks for fire-and-forget delayed operations
- The delay method returns a Future that can be awaited or chained
- Years and months calculations are approximate (365 days/year, 30.4167 days/month)
- Consider timezone changes when using long durations with DateTime arithmetic
- `delay()` is more readable than `Future.delayed()` for simple cases

---

## 🎨 Typedefs and Records

The dart_suite package includes an extensive collection of typedefs that provide clean, descriptive types for common data patterns, making code more readable and type-safe.

**Usage Examples**:

1. **Geometric and Spatial Data**:
```dart
// 2D and 3D coordinates
Point2D screenPosition = (x: 150.0, y: 200.0);
Point3D worldPosition = (x: 10.0, y: 5.0, z: -3.0);

// Using extensions for calculations
Point2D center = (x: 100.0, y: 100.0);
Point2D offset = (x: 50.0, y: 25.0);
Point2D newPosition = center + offset; // (x: 150.0, y: 125.0)

// Geographic coordinates
GeoCoordinate newYork = (lat: 40.7128, lng: -74.0060);
GeoCoordinate3D mountEverest = (
  lat: 27.9881, 
  lng: 86.9250, 
  alt: 8848.86,
  acc: 1.0 // 1 meter accuracy
);

// Dimensions for 3D objects
Dimension boxSize = (l: 10.0, w: 5.0, h: 2.0);
final volume = boxSize.l * boxSize.w * boxSize.h;

// Color representations
RGB red = (r: 255, g: 0, b: 0);
RGBA semiTransparentBlue = (r: 0, g: 0, b: 255, a: 0.5);

// Using color extensions
final hexColor = semiTransparentBlue.toHex(); // "#0000FF80"
```

2. **Advanced Data Patterns and Functional Programming**:
```dart
class UserRepository {
  // Clean data structures
  List<IdName> getDepartmentOptions() => [
    (id: 'eng', name: 'Engineering'),
    (id: 'sales', name: 'Sales'),
    (id: 'hr', name: 'Human Resources'),
  ];
  
  // Pagination with type safety
  Future<(List<User>, Pagination)> getUsers(Pagination request) async {
    final users = await fetchUsers(
      page: request.page,
      limit: request.pageSize,
    );
    
    final resultPagination = (
      page: request.page,
      pageSize: request.pageSize,
      totalCount: users.total,
    );
    
    return (users.data, resultPagination);
  }
}

// Functional programming patterns
class DataProcessor<T> {
  // Using functional typedefs for clean APIs
  List<T> filter(List<T> items, Predicate<T> predicate) {
    return items.where(predicate).toList();
  }
  
  List<R> transform<R>(List<T> items, Function<T, R> mapper) {
    return items.map(mapper).toList();
  }
  
  void process(List<T> items, Consumer<T> action) {
    items.forEach(action);
  }
  
  T reduce(List<T> items, T initialValue, BinaryOperator<T> accumulator) {
    return items.fold(initialValue, accumulator);
  }
}

// Usage with real data
final processor = DataProcessor<User>();

// Find active users
final activeUsers = processor.filter(
  allUsers, 
  (user) => user.isActive, // Predicate<User>
);

// Extract user names
final userNames = processor.transform(
  activeUsers,
  (user) => user.name, // Function<User, String>
);

// Send notifications
processor.process(
  activeUsers,
  (user) => sendNotification(user), // Consumer<User>
);

// Calculate total age
final totalAge = processor.reduce(
  activeUsers,
  0,
  (sum, user) => sum + user.age, // BinaryOperator<int>
);

// Key-Value operations with strong typing
final userPreferences = <String, JSON_1<String>>{
  'theme': (key: 'ui_theme', value: 'dark'),
  'lang': (key: 'language', value: 'en'),
};

// Pair and Triple for complex returns
Pair<bool, String> validateUser(User user) {
  if (user.email.isEmpty) {
    return (first: false, second: 'Email is required');
  }
  return (first: true, second: 'Valid user');
}

Triple<double, double, String> calculateGeometry(Dimension dim) {
  final volume = dim.l * dim.w * dim.h;
  final surfaceArea = 2 * (dim.l*dim.w + dim.w*dim.h + dim.h*dim.l);
  final description = '${dim.l}x${dim.w}x${dim.h}';
  
  return (first: volume, second: surfaceArea, third: description);
}
```

**Notes/Best Practices**:
- Use `Point2D` and `Point3D` for UI coordinates and 3D graphics calculations
- `GeoCoordinate` types are perfect for maps and location-based services
- `IdName` is ideal for dropdown options and lookup tables
- `RGB` and `RGBA` provide type-safe color handling with extensions
- `Pagination` standardizes API pagination patterns across your application
- Functional typedefs (`Predicate`, `Consumer`, etc.) make APIs more self-documenting
- `Pair` and `Triple` avoid creating single-use classes for simple data groupings
- `JSON<T>` provides type-safe alternatives to `Map<String, dynamic>`
- These typedefs are zero-cost abstractions - they compile to their underlying types
- Use extensions to add domain-specific operations to these basic structures

---

## 🔍 Pattern Matching and Validation

### RegPatterns - Comprehensive Validation Library

**Overview**: RegPatterns provides a comprehensive collection of pre-built regular expressions for common validation scenarios including emails, phone numbers, credit cards, passwords, and file formats, eliminating the need to write and maintain custom regex patterns.

**Technical Explanation**: The patterns are organized into categories (general, numeric, password, file formats, PAN/GST for Indian compliance) with carefully crafted regex that handle edge cases and international variations. Each pattern is tested and optimized for performance while maintaining accuracy.

**Usage Examples**:

1. **Basic Validation**:
```dart
// Email validation
final email = "user@example.com";
print(RegPatterns.email.hasMatch(email)); // true

// Phone number validation (various formats)
print(RegPatterns.phone.hasMatch("+1-555-123-4567")); // true
print(RegPatterns.phone.hasMatch("(555) 123-4567"));  // true

// URL validation
print(RegPatterns.url.hasMatch("https://flutter.dev")); // true

// Credit card numbers
print(RegPatterns.creditCard.hasMatch("4111111111111111")); // Visa
```

2. **Advanced Form Validation**:
```dart
class FormValidator {
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }
    if (!RegPatterns.email.hasMatch(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }
  
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    if (!RegPatterns.passwordMedium.hasMatch(password)) {
      return 'Password must be at least 8 characters with letters and numbers';
    }
    return null;
  }
  
  static String? validateIndianPAN(String? pan) {
    if (pan == null || pan.isEmpty) return 'PAN is required';
    if (!RegPatterns.panCard.hasMatch(pan)) {
      return 'Please enter a valid PAN number (e.g., ABCDE1234F)';
    }
    return null;
  }
}
```

**Notes/Best Practices**:
- Use specific patterns like `passwordStrong` vs `passwordWeak` based on security requirements
- `RegPatterns.alphaNumeric` is perfect for usernames and IDs
- File format patterns help with upload validation
- Indian-specific patterns (PAN, GST) are included for regional compliance
- All patterns are case-insensitive where appropriate

---

### Optional Type - Null Safety Enhancement

**Overview**: Optional provides a more explicit and functional approach to handling nullable values, similar to Option types in functional programming languages, making null handling more intentional and reducing null-related errors.

**Technical Explanation**: Optional wraps potentially null values in a container that forces explicit handling through methods like `map`, `flatMap`, `orElse`, and `ifPresent`. This pattern prevents accidental null dereferencing and makes the presence or absence of values part of the type signature.

**Usage Examples**:

1. **Safe Value Handling**:
```dart
// Instead of nullable types
Optional<String> getName(int userId) {
  final user = findUser(userId);
  return user != null ? Optional.of(user.name) : Optional.empty();
}

// Chain operations safely
final displayName = getName(123)
  .map((name) => name.toUpperCase())
  .filter((name) => name.length > 2)
  .orElse('Anonymous');

// Handle presence/absence explicitly
getName(456).ifPresent((name) => print('Hello, $name!'));
```

2. **API Integration and Error Handling**:
```dart
class UserService {
  Future<Optional<User>> fetchUser(String id) async {
    try {
      final response = await api.get('/users/$id');
      return Optional.of(User.fromJson(response.data));
    } catch (e) {
      return Optional.empty();
    }
  }
  
  Future<String> getUserDisplayName(String id) async {
    return (await fetchUser(id))
      .map((user) => '${user.firstName} ${user.lastName}')
      .filter((name) => name.trim().isNotEmpty)
      .orElse('Unknown User');
  }
}
```

---

# 🧩 bloc_suite Package

The `bloc_suite` package extends Flutter's BLoC library with additional utilities, widgets, and patterns for more efficient state management.

## 🔄 Enhanced BLoC Components

### BlocWidget - Base Widget for BLoC Integration

**Overview**: BlocWidget provides a base class that simplifies building UI components that depend on a BLoC, reducing boilerplate and providing consistent patterns for BLoC-aware widgets.

**Technical Explanation**: BlocWidget automatically handles BLoC lifecycle, provides convenient access to the BLoC instance, and offers hooks for state changes and error handling. It integrates with Flutter's widget tree efficiently and supports both local and global BLoC instances.

**Usage Examples**:

1. **Simple BLoC Widget**:
```dart
class CounterWidget extends BlocWidget<CounterBloc, CounterState> {
  @override
  Widget build(BuildContext context, CounterState state) {
    return Column(
      children: [
        Text('Count: ${state.count}'),
        ElevatedButton(
          onPressed: () => bloc.add(CounterIncrement()),
          child: Text('Increment'),
        ),
      ],
    );
  }
}
```

2. **Advanced Error Handling**:
```dart
class UserProfileWidget extends BlocWidget<UserBloc, UserState> {
  @override
  void onError(Object error, StackTrace stackTrace) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error loading user: $error')),
    );
  }
  
  @override
  Widget build(BuildContext context, UserState state) {
    return switch (state) {
      UserLoading() => CircularProgressIndicator(),
      UserLoaded(:final user) => UserDetails(user: user),
      UserError(:final message) => ErrorWidget(message),
    };
  }
}
```

---

### LifecycleBloc - Event Lifecycle Management

**Overview**: LifecycleBloc provides automatic lifecycle callbacks for events, enabling complex inter-bloc communication and state management patterns while maintaining loose coupling between components.

**Technical Explanation**: LifecycleBloc extends the standard BLoC pattern with lifecycle hooks (processing, completed, error) and an event bus system. It tracks event states and provides a clean API for other components to listen to specific event completions without tight coupling.

**Usage Examples**:

1. **Basic Lifecycle Handling**:
```dart
class DataBloc extends LifecycleBloc<DataEvent, DataState> {
  @override
  Stream<DataState> mapEventToState(DataEvent event) async* {
    switch (event) {
      case LoadData():
        yield* _handleLoadData(event);
    }
  }
  
  Stream<DataState> _handleLoadData(LoadData event) async* {
    // Lifecycle automatically tracks: processing -> completed/error
    try {
      final data = await repository.loadData();
      yield DataLoaded(data);
      // Lifecycle status: completed
    } catch (e) {
      yield DataError(e.toString());
      // Lifecycle status: error
    }
  }
}
```

2. **Inter-Bloc Communication**:
```dart
class NotificationBloc extends LifecycleBloc<NotificationEvent, NotificationState> {
  late final StreamSubscription _dataSubscription;
  
  @override
  void onCreate() {
    super.onCreate();
    
    // Listen to DataBloc events
    _dataSubscription = eventBus.listen<LoadData>((event, status) {
      if (status == EventStatus.completed) {
        add(ShowNotification('Data loaded successfully!'));
      } else if (status == EventStatus.error) {
        add(ShowNotification('Failed to load data'));
      }
    });
  }
  
  @override
  void onClose() {
    _dataSubscription.cancel();
    super.onClose();
  }
}
```

---

# 🎨 flutter_suite Package

The `flutter_suite` package provides Flutter-specific utilities, widgets, and extensions for enhanced UI development.

## 📏 Design System Constants

### Design Constants - Consistent Spacing and Theming

**Overview**: The design constants provide a consistent design system with predefined spacing, border radius, and shape values that ensure visual consistency across your Flutter application.

**Technical Explanation**: The constants are organized hierarchically (micro, tiny, small, medium, normal, large) and provide both individual values and combined utilities like EdgeInsets, BorderRadius, and RoundedRectangleBorder for immediate use in widgets.

**Usage Examples**:

1. **Consistent Spacing**:
```dart
class ProductCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: $EdgeInsets.medium,      // Consistent medium spacing
      shape: $RoundedRectangleBorder.normal, // Standard border radius
      child: Padding(
        padding: $EdgeInsets.normal,
        child: Column(
          children: [
            ProductImage(),
            SizedBox(height: $small),    // Consistent small spacing
            ProductTitle(),
            SizedBox(height: $tiny),     // Consistent tiny spacing
            ProductPrice(),
          ],
        ),
      ),
    );
  }
}
```

2. **Responsive Design System**:
```dart
class ResponsiveLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 1200;
    
    return Container(
      padding: isDesktop ? $EdgeInsets.large : $EdgeInsets.medium,
      margin: $EdgeInsets.horizontalNormal, // Horizontal-only margin
      decoration: BoxDecoration(
        borderRadius: $BorderRadius.normal,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Content(),
    );
  }
}
```

---

# ⚙️ gen_suite Package

The `gen_suite` package provides code generation utilities for Dart, starting with singleton pattern generation.

## 🔧 Singleton Generation

### @singleton Annotation - Automatic Singleton Generation

**Overview**: The @singleton annotation automatically generates singleton implementations for abstract classes, eliminating boilerplate code while ensuring thread-safety and lazy initialization.

**Technical Explanation**: The generator analyzes abstract classes marked with @singleton and creates concrete implementations with private constructors, static instances, and proper initialization handling. It supports various constructor patterns and maintains type safety.

**Usage Examples**:

1. **Simple Singleton Service**:
```dart
@singleton
abstract class ConfigService {
  String get apiUrl;
  int get timeout;
  
  // Constructor with parameters
  ConfigService(String environment);
}

// Generated code creates:
// class _ConfigService extends ConfigService { ... }
// with proper singleton implementation

// Usage:
final config = ConfigService('production');
assert(identical(config, ConfigService('any_param'))); // Same instance
```

2. **Advanced Singleton with Dependencies**:
```dart
@singleton  
abstract class DatabaseService {
  Future<List<User>> getUsers();
  Future<void> saveUser(User user);
  
  DatabaseService({
    required String connectionString,
    int poolSize = 10,
  });
}

// Usage in app initialization:
void initServices() {
  DatabaseService(
    connectionString: 'sqlite:///app.db',
    poolSize: 20,
  );
  
  // Later in the app:
  final db = DatabaseService(); // Returns same instance
}
```

---

## 📋 Complete Package Summary

This comprehensive documentation covers the entire suite repository with detailed explanations, practical examples, and best practices for:

### dart_suite (Core Foundation)
- **Error Handling**: Guard utilities for safe operations
- **Async Control**: Retry, Debounce, and Throttle mechanisms  
- **Time Utilities**: Timeago formatting and Duration extensions
- **Text Processing**: String extensions and ReCase transformations
- **Data Structures**: LRU Cache for efficient memory management
- **Type Safety**: Comprehensive typedefs and Optional types
- **Validation**: RegPatterns for common validation scenarios

### bloc_suite (State Management)  
- **Enhanced Widgets**: BlocWidget and BlocSelectorWidget for cleaner UI
- **Lifecycle Management**: LifecycleBloc for event tracking and inter-bloc communication
- **Advanced Patterns**: ReplayBloc with undo/redo functionality
- **Developer Tools**: Enhanced BlocObserver with detailed logging
- **Event Handling**: Specialized transformers for complex event flows

### flutter_suite (UI Utilities)
- **Design System**: Consistent spacing, radius, and shape constants
- **Extensions**: Context, Color, and Theme extensions for cleaner code
- **Widgets**: Specialized widgets for common UI patterns
- **Layouts**: Adaptive builders and form layouts
- **Utilities**: Platform detection, permissions, and navigation helpers

### gen_suite (Code Generation)
- **Singleton Generation**: Automatic singleton pattern implementation
- **Build Integration**: Seamless integration with build_runner
- **Type Safety**: Generated code maintains full type safety
- **Extensible**: Framework for additional generators

Each component includes comprehensive examples ranging from basic usage to advanced real-world scenarios, along with performance considerations and best practices for production applications.

---

## 🚀 Getting Started

To use any package from this suite:

```yaml
dependencies:
  dart_suite: ^latest_version
  bloc_suite: ^latest_version  # For Flutter projects
  flutter_suite: ^latest_version  # For Flutter projects
  
dev_dependencies:
  gen_suite: ^latest_version  # For code generation
  build_runner: ^latest_version  # Required for gen_suite
```

Import and start using:

```dart
import 'package:dart_suite/dart_suite.dart';
import 'package:bloc_suite/bloc_suite.dart';
import 'package:flutter_suite/flutter_suite.dart';

// All utilities are now available!
```

This documentation serves as both a learning resource and a reference guide for leveraging the full power of the suite ecosystem in your Dart and Flutter applications.
