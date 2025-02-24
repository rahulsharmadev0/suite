// ignore_for_file: library_private_types_in_public_api, prefer_function_declarations_over_variables
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

class BlocEventTransformer {
  /// The delay() transformer is pausing adding events for a particular
  /// increment of time (that you specify) before emitting each of the events.
  /// This has the effect of shifting the entire sequence of
  /// events added to the bloc forward in time by that specified increment.
  ///
  /// [Interactive marble diagram](http://rxmarbles.com/#delay)
  ///
  /// ### Example
  ///
  ///     on<ExampleEvent>(
  ///       _handleEvent,
  ///       transformer: delay(const Duration(seconds: 1)),
  ///     );
  static EventTransformer<Event> delay<Event>(Duration duration) =>
      (events, mapper) => events.delay(duration).switchMap(mapper);

  /// Event transformer that will only emit items from the source
  /// sequence whenever the time span defined by [duration] passes, without the
  /// source sequence emitting another item.
  ///
  /// This time span start after the last debounced event was emitted.
  ///
  /// debounce filters out items obtained events that are
  /// rapidly followed by another emitted event.
  ///
  /// [Interactive marble diagram](http://rxmarbles.com/#debounceTime)
  ///
  /// ### Example
  ///
  ///     on<ExampleEvent>(
  ///       _handleEvent,
  ///       transformer: debounce(const Duration(seconds: 1)),
  ///     );
  static EventTransformer<Event> debounce<Event>(Duration duration) =>
      (events, mapper) => events.debounceTime(duration).switchMap(mapper);

  /// Skips the first [count] events.
  ///
  /// ### Example
  ///
  ///     on<ExampleEvent>(
  ///       _handleEvent,
  ///       transformer: skip(10),
  ///     )
  ///
  ///
  static EventTransformer<Event> skip<Event>(int count) =>
      (events, mapper) => events.skip(count).flatMap(mapper);

  /// Skips the first [count] events.
  ///
  /// ### Example
  ///
  ///     on<ExampleEvent>(
  ///       _handleEvent,
  ///       transformer: skip(10),
  ///     )
  static EventTransformer<Event> throttle<Event>(
    Duration duration, {
    bool trailing = false,
    bool leading = true,
  }) =>
      (events, mapper) =>
          events.throttleTime(duration, trailing: trailing, leading: leading).switchMap(mapper);

  /// Process only one event by cancelling any pending events and
  /// processing the new event immediately.
  ///
  /// Avoid using [restartable] if you expect an event to have
  /// immediate results -- it should only be used with asynchronous APIs.
  ///
  /// **Note**: there is no event handler overlap and any currently running tasks
  /// will be aborted if a new event is added before a prior one completes.
  static EventTransformer<Event> restartable<Event>() {
    return (events, mapper) => events.switchMap(mapper);
  }

  /// Process events one at a time by maintaining a queue of added events
  /// and processing the events sequentially.
  ///
  /// **Note**: there is no event handler overlap and every event is guaranteed
  /// to be handled in the order it was received.
  static EventTransformer<Event> sequential<Event>() {
    return (events, mapper) => events.asyncExpand(mapper);
  }

  /// Process only one event and ignore (drop) any new events
  /// until the current event is done.
  ///
  /// **Note**: dropped events never trigger the event handler.
  static EventTransformer<Event> droppable<Event>() {
    return (events, mapper) {
      return events.exhaustMap(mapper);
    };
  }
}
