import 'package:bloc/bloc.dart';

/// Base event that supports lifecycle callbacks for Bloc event processing.
///
/// Provides three optional callback functions:
/// * [onSuccess] - Called when the event is processed successfully
/// * [onCompleted] - Called when the event processing is complete (regardless of success/failure)
/// * [onError] - Called when an error occurs during event processing
abstract class LifecycleEvent {
  final void Function()? _onSuccess;
  final void Function()? _onCompleted;
  final Function(dynamic error)? _onError;

  /// Creates a new lifecycle event with optional callback functions.
  ///
  /// Example:
  /// ```dart
  /// class MyEvent extends LifecycleEvent {
  ///   MyEvent(): super(
  ///     onSuccess: () => print('Success!'),
  ///     onCompleted: () => print('Completed!'),
  ///     onError: (error) => print('Error: $error'),
  ///   );
  /// }
  /// ```
  const LifecycleEvent({
    void Function()? onSuccess,
    void Function()? onCompleted,
    dynamic Function(dynamic)? onError,
  }) : _onSuccess = onSuccess,
       _onCompleted = onCompleted,
       _onError = onError;
}

///{@template LifecycleBloc}
/// A specialized [Bloc] that automatically handles lifecycle callbacks for events.
///
/// The `LifecycleBloc` extends the standard `Bloc` functionality by adding automatic
/// lifecycle callback handling for success, completion, and error states during
/// event processing.
///
/// Key Features:
/// * Automatic callback execution
/// * Support for event throttling
/// * Compatible with existing Bloc patterns
/// * Type-safe event handling
///
/// Example usage:
/// ```dart
/// // Define your state
/// class CounterState {
///   final int value;
///   const CounterState(this.value);
/// }
///
/// // Define your events with lifecycle callbacks
/// sealed class CounterEvent extends LifecycleEvent {
///   const CounterEvent({super.onCompleted, super.onError});
/// }
///
/// class Increment extends CounterEvent {
///   const Increment({
///     super.onCompleted,
///     super.onSuccess,
///     super.onError,
///   });
/// }
///
/// // Implement your bloc
/// class CounterBloc extends LifecycleBloc<CounterEvent, CounterState> {
///   CounterBloc() : super(CounterState(0)) {
///     // With throttling
///     on<Increment>(
///       (event, emit) => emit(CounterState(state.value + 1)),
///       transformer: BlocEventTransformer.throttle(
///         const Duration(milliseconds: 500),
///       ),
///     );
///   }
/// }
///
/// // Usage in UI
/// ElevatedButton(
///   onPressed: () => bloc.add(
///     Increment(
///       onSuccess: () => print('Counter increased'),
///       onCompleted: () => print('Operation completed'),
///       onError: (error) => print('Error: $error'),
///     ),
///   ),
///   child: Text('Increment'),
/// )
/// ```
///{@endtemplate}
abstract class LifecycleBloc<Event extends LifecycleEvent, State>
    extends Bloc<Event, State> {
  /// {@macro LifecycleBloc}
  LifecycleBloc(super.initialState);

  /// Creates an event transformer that handles lifecycle callbacks.
  ///
  /// This internal transformer wraps the event processing to ensure proper
  /// execution of [onSuccess], [onError], and [onCompleted] callbacks.
  EventTransformer<E> _callbackTransformer<E extends LifecycleEvent>() {
    return (events, mapper) => events.asyncExpand((event) async* {
      try {
        yield* mapper(event);
        event._onSuccess?.call();
      } catch (error) {
        event._onError?.call(error);
        rethrow;
      } finally {
        event._onCompleted?.call();
      }
    });
  }

  /// Registers an event handler with lifecycle callback support.
  ///
  /// [handler] - The event handler function
  /// [transformer] - Optional event transformer (e.g., for throttling)
  ///
  /// The provided [transformer] is combined with the internal callback transformer
  /// to ensure both custom transformation and lifecycle callbacks work together.
  @override
  void on<E extends Event>(
    EventHandler<E, State> handler, {
    EventTransformer<E>? transformer,
  }) {
    final EventTransformer<E> mergedTransformer =
        transformer != null
            ? (events, mapper) => transformer(
              events,
              (e) => _callbackTransformer<E>()(Stream.value(e), mapper),
            )
            : _callbackTransformer<E>();

    super.on<E>(handler, transformer: mergedTransformer);
  }
}
