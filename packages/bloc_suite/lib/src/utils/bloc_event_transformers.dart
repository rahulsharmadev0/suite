// ignore_for_file: library_private_types_in_public_api, prefer_function_declarations_over_variables
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

// Extension providing utility methods for Stream<E> to simplify transformer implementation
extension _UtilityExt<E> on Stream<E> {
  // Apply distinctness to an event stream if requested
  Stream<E> applyDistinct(bool distinct) => distinct ? this.distinct() : this;

  // Apply sequential or parallel processing based on condition
  Stream<T> applySequential<T>(bool condition, Stream<T> Function(E) mapper) =>
      condition ? asyncExpand(mapper) : flatMap(mapper);
}

/// A utility class providing various event transformers for Bloc pattern.
///
/// Event transformers modify how events are processed before they reach the event handler.
/// They can be used to control timing, filtering, or sequencing of events.
///
/// ## Choosing the Right BlocEventTransformer
///
/// | Transformer    | Sequential Processing | `distinct` Support | Best Use Case |
/// |---------------|----------------------|--------------------|------------------------------------------------|
/// | **`delay`**       | ✅ Always | 🔄 Configurable | Postpone processing (e.g., brief loading indicators). |
/// | **`debounce`**    | ✅ Always | 🔄 Configurable | Wait for inactivity before processing (e.g., search inputs, form validation). |
/// | **`throttle`**    | ✅ Always | 🔄 Configurable | Control frequent events (e.g., scrolling, resizing). |
/// | **`restartable`** | ✅ Always | 🔄 Configurable | Cancel outdated events when new ones arrive (e.g., live search API calls). |
/// | **`sequential`**  | ✅ Always | 🔄 Configurable | Ensure ordered execution (e.g., sending messages one by one). |
/// | **`droppable`**   | ✅ Always | 🔄 Configurable | Process only the latest event, dropping older ones (e.g., UI animations). |
/// | **`skip`**        | 🔄 Configurable | 🔄 Configurable | Ignore initial events (e.g., first trigger in a lifecycle). |
/// | **`distinct`**    | 🔄 Configurable | ✅ Always | Avoid duplicate event processing (e.g., filtering unchanged user actions). |
/// | **`take`** | 🔄 Configurable | 🔄 Configurable | Limit the number of events (e.g., first N items in a list). |
///
abstract class BlocEventTransformer<E> {
  /// The delay() transformer pauses adding events for a specified duration
  /// before emitting each event, shifting the entire sequence forward in time.
  ///
  /// [Interactive marble diagram](http://rxmarbles.com/#delay)
  ///
  /// **Example**
  /// ```dart
  /// on<ExampleEvent>(
  ///   _handleEvent,
  ///   transformer: BlocEventTransformer.delay(const Duration(seconds: 1)),
  /// );
  /// ```
  ///
  /// **Visual Representation:**
  ///
  /// ```
  /// Input:  --a--------b---c--->
  /// Output: ----a--------b---c->  (with 1s delay)
  /// ```
  ///
  /// - [duration] The time to delay each event
  /// - [distinct] When true, skips events that are equal to the previous event
  ///
  /// Returns an [EventTransformer] that delays events by the specified duration.
  static EventTransformer<Event> delay<Event>(
    Duration duration, {
    bool distinct = false,
  }) {
    return (events, mapper) =>
        events.applyDistinct(distinct).delay(duration).switchMap(mapper);
  }

  /// Emits items from the source sequence only when there's a pause in events
  /// for the specified duration.
  ///
  /// This transformer is ideal for search inputs or form validation where you want
  /// to wait for the user to stop typing before processing.
  ///
  /// [Interactive marble diagram](http://rxmarbles.com/#debounceTime)
  ///
  /// **Example:**
  ///
  /// ```dart
  /// on<SearchQueryEvent>(
  ///   _handleSearchQuery,
  ///   transformer: BlocEventTransformer.debounce(const Duration(milliseconds: 300)),
  /// );
  /// ```
  ///
  /// **Visual Representation:**
  ///
  /// ```
  /// Input:  --a-ab-bc--c------d->
  /// Output: --------c---------d->  (with 300ms debounce)
  /// ```
  ///
  /// - [duration] The time window to wait for inactivity
  /// - [distinct] When true, skips events that are equal to the previous event
  ///
  /// Returns an [EventTransformer] that debounces events by the specified duration.
  static EventTransformer<Event> debounce<Event>(
    Duration duration, {
    bool distinct = false,
  }) {
    return (events, mapper) =>
        events.applyDistinct(distinct).debounceTime(duration).switchMap(mapper);
  }

  /// Skips the first [count] events before processing any.
  ///
  /// Useful for ignoring initial events such as initialization triggers.
  ///
  /// **Example:**
  ///
  /// ```dart
  /// on<PageLoadEvent>(
  ///   _handlePageLoad,
  ///   transformer: BlocEventTransformer.skip(1), // Skip first event
  /// );
  /// ```
  ///
  /// **Visual Representation:**
  ///
  /// ```
  /// Input:  --a--b--c--d--e-->
  /// Output: -----b--c--d--e-->  (with count: 1)
  /// ```
  ///
  /// - [count] The number of events to skip
  /// - [distinct] When true, skips events that are equal to the previous event
  /// - [sequential] When true, processes events one at a time in order
  ///
  /// Returns an [EventTransformer] that skips the specified number of events.
  static EventTransformer<Event> skip<Event>(
    int count, {
    bool distinct = false,
    bool sequential = false,
  }) {
    return (events, mapper) => events
        .applyDistinct(distinct)
        .skip(count)
        .applySequential(sequential, mapper);
  }

  /// Limits the rate at which events are processed.
  ///
  /// Throttling ensures that events are emitted at most once per specified duration.
  ///
  /// **Example:**
  ///
  /// ```dart
  /// on<ScrollEvent>(
  ///   _handleScrollEvent,
  ///   transformer: BlocEventTransformer.throttle(
  ///     const Duration(milliseconds: 200),
  ///     trailing: true, // Process the last event in a burst
  ///   ),
  /// );
  /// ```
  ///
  /// **Visual Representation:**
  /// ```
  /// Input:  --a-ab-bc--c-------d-->
  /// Output: --a----b----c-------d->  (with 200ms throttle, leading: true)
  /// ```
  ///
  /// - [duration] The minimum time between processed events
  /// - [trailing] If true, process the last event in a burst (default: false)
  /// - [leading] If true, process the first event in a burst (default: true)
  /// - [distinct] When true, skips events that are equal to the previous event
  ///
  /// Returns an [EventTransformer] that throttles events by the specified duration.
  static EventTransformer<Event> throttle<Event>(
    Duration duration, {
    bool trailing = false,
    bool leading = true,
    bool distinct = false,
  }) {
    return (events, mapper) => events
        .applyDistinct(distinct)
        .throttleTime(duration, trailing: trailing, leading: leading)
        .switchMap(mapper);
  }

  /// Cancels processing of the current event if a new event arrives.
  ///
  /// This transformer is ideal for network requests or other async operations
  /// that should be cancelled when newer data is requested.
  ///
  /// **Note**: Avoid using this with synchronous operations as it may cause unexpected behavior.
  ///
  /// **Example:**
  /// ```dart
  /// on<FetchDataEvent>(
  ///   _handleFetchData,
  ///   transformer: BlocEventTransformer.restartable(),
  /// );
  /// ```
  ///
  /// **Visual Representation:**
  /// ```
  /// Input:     --a-----b---c--->
  /// Processing: --[a]--X
  ///                  --[b]X
  ///                      --[c]--->
  /// Output:     ---------x----x--->
  /// ```
  ///
  /// - [distinct] When true, skips events that are equal to the previous event
  ///
  /// Returns an [EventTransformer] that cancels current processing when a new event arrives.
  static EventTransformer<Event> restartable<Event>({bool distinct = false}) {
    return (events, mapper) => events.applyDistinct(distinct).switchMap(mapper);
  }

  /// Processes events one at a time in a queue, ensuring order is preserved.
  ///
  /// This transformer maintains a queue of events and processes them sequentially,
  /// waiting for each operation to complete before starting the next one.
  ///
  /// **Example:**
  /// ```dart
  /// on<SaveDataEvent>(
  ///   _handleSaveData,
  ///   transformer: BlocEventTransformer.sequential(),
  /// );
  /// ```
  ///
  /// **Visual Representation:**
  /// ```
  /// Input:     --a--b--c-------->
  /// Processing: --[a]--[b]--[c]-->
  /// Output:     ----x----x----x-->
  /// ```
  ///
  /// - [distinct] When true, skips events that are equal to the previous event
  ///
  /// Returns an [EventTransformer] that processes events sequentially.
  static EventTransformer<Event> sequential<Event>({bool distinct = false}) {
    return (events, mapper) =>
        events.applyDistinct(distinct).asyncExpand(mapper);
  }

  /// Ignores new events until the current event processing is complete.
  ///
  /// This transformer is ideal for intensive operations where only the current
  /// event should be processed fully before considering any new events.
  ///
  /// **Example:**
  /// ```dart
  /// on<ProcessIntensiveEvent>(
  ///   _handleIntensiveTask,
  ///   transformer: BlocEventTransformer.droppable(),
  /// );
  /// ```
  ///
  /// **Visual Representation:**
  /// ```
  /// Input:     --a--b--c-------->
  /// Processing: --[a]-------->
  /// Output:     -------x--------->  (b and c are dropped)
  /// ```
  ///
  /// - [distinct] When true, skips events that are equal to the previous event
  ///
  /// Returns an [EventTransformer] that drops new events while processing the current one.
  static EventTransformer<Event> droppable<Event>({bool distinct = false}) {
    return (events, mapper) =>
        events.applyDistinct(distinct).exhaustMap(mapper);
  }

  /// Skips events that are equal to the previous event.
  ///
  /// Equality is determined by the `==` operator, so your event classes
  /// should properly implement equality for accurate comparison.
  ///
  /// **Example:**
  /// ```dart
  /// on<FilterEvent>(
  ///   _handleFilterEvent,
  ///   transformer: BlocEventTransformer.distinct(),
  /// );
  /// ```
  ///
  /// **Visual Representation:**
  /// ```
  /// Input:  --a--a--b--b--a--a-->
  /// Output: --a-----b-----a----->  (duplicate events are skipped)
  /// ```
  ///
  /// - [sequential] When true, processes events one at a time in order
  ///
  /// Returns an [EventTransformer] that filters out duplicate events.
  static EventTransformer<Event> distinct<Event>({bool sequential = false}) {
    return (events, mapper) =>
        events.distinct().applySequential(sequential, mapper);
  }

  /// Takes only a specified number of events.
  ///
  /// The [count] parameter specifies the maximum number of events to take.
  /// After [count] events are processed, no more events will be emitted.
  ///
  /// **Example:**
  /// ```dart
  /// on<LoadEvent>(
  ///   _handleLoadEvent,
  ///   transformer: BlocEventTransformer.take(3), // Take only first 3 events
  /// );
  /// ```
  ///
  /// **Visual Representation:**
  /// ```
  /// Input:  --a--b--c--d--e-->
  /// Output: --a--b--c-------->  (with count: 3)
  /// ```
  ///
  /// - [count] The maximum number of events to take
  /// - [distinct] When true, skips events that are equal to the previous event
  /// - [sequential] When true, processes events one at a time in order
  ///
  /// Returns an [EventTransformer] that takes the specified number of events.
  static EventTransformer<Event> take<Event>(
    int count, {
    bool distinct = false,
    bool sequential = false,
  }) {
    return (events, mapper) => events
        .applyDistinct(distinct)
        .take(count)
        .applySequential(sequential, mapper);
  }
}
