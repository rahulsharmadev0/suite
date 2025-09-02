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
