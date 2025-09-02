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

**Technical Explanation**: Timeago calculates the difference between a given DateTime and the current time, then maps these differences to appropriate human-readable strings using configurable symbol data. It supports both past and future times, handles various time units (seconds to years), and provides localization support through customizable symbol sets.
