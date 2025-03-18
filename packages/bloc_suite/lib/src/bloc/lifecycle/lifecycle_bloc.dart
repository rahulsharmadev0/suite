import 'package:bloc/bloc.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';
part 'event_bus.dart';

/// {@template LifecycleBloc}
/// # LifecycleBloc 🏗️
///
/// A specialized [Bloc] that enhances event lifecycle tracking in a reactive and decoupled way.
///
/// This class extends the standard `Bloc` by introducing automatic **event lifecycle tracking**.
/// Each event processed by the bloc goes through distinct phases:
///
/// - ✅ **started** – The event has been received and is being processed.
/// - ✅ **success** – The event has been processed successfully.
/// - ✅ **error** – An error occurred while handling the event.
/// - ✅ **completed** – The event lifecycle has concluded, whether successful or not.
///
/// ## 🔥 **Best Use Cases**
/// - **Bloc-to-Bloc communication** (event lifecycle tracking with less tight coupling).
/// - **Multi-step workflows** like authentication, payments, or file uploads.
/// - **Background processes** that require real-time UI updates.
/// - **Real-time event-driven systems** like chat apps, stock price updates, or notification handlers.
///
/// **Note:** Generally, sibling dependencies between two entities in the same [architectural](https://bloclibrary.dev/architecture/#bloc-to-bloc-communication) layer should be avoided due to hard maintain.🫡
///
/// {@endtemplate}
abstract class LifecycleBloc<Event, State> extends Bloc<Event, State>
    with _EventBus<Event, Event> {
  LifecycleBloc(super.initialState);

  EventTransformer<E> _lifecycleTransformer<E extends Event>() {
    return (events, mapper) => events.asyncExpand((event) async* {
      // Notify that event processing is starting.
      _addEvent(event, event, EventStatus.started);
      try {
        await for (final state in mapper(event)) {
          yield state;
        }
        // Notify that event processing succeeded.
        _addEvent(event, event, EventStatus.success);
      } catch (error) {
        // Notify that event processing encountered an error.
        _addEvent(event, event, EventStatus.error, error: error);
        rethrow;
      } finally {
        // Notify that event processing is complete.
        _addEvent(event, event, EventStatus.completed);
      }
    });
  }

  /// Overrides [on] to integrate the lifecycle transformer.
  ///
  /// This method ensures that all event handlers automatically benefit from
  /// lifecycle tracking while still allowing custom transformers to be used.
  @override
  void on<E extends Event>(
    EventHandler<E, State> handler, {
    EventTransformer<E>? transformer,
  }) {
    Stream<E> combinedTransformer(events, mapper) {
      final lifecycleTransformed = _lifecycleTransformer<E>();
      if (transformer != null) {
        // Combine custom transformer with the lifecycle transformer.
        return transformer(
          events,
          (event) => lifecycleTransformed(Stream.value(event), mapper),
        );
      }
      return lifecycleTransformed(events, mapper);
    }

    super.on<E>(handler, transformer: combinedTransformer);
  }

  @override
  Future<void> close() async {
    _disposeEventBus();
    return super.close();
  }
}
