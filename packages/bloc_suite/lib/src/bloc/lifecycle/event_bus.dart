part of 'lifecycle_bloc.dart';

/// Represents the lifecycle status of an event.
enum EventStatus { started, success, error, completed }

/// A wrapper that holds an event along with its lifecycle status and error (if any).
class EventWrapper<T> {
  final T event;
  final EventStatus status;
  final dynamic error;

  const EventWrapper(this.event, this.status, {this.error});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventWrapper<T> &&
          runtimeType == other.runtimeType &&
          event == other.event &&
          status == other.status &&
          error == other.error;

  @override
  int get hashCode => Object.hash(event, status);
}

/// An optimized EventBus mixin using RxDart's BehaviorSubject for better reactivity.
mixin _EventBus<K, Event> on BlocEventSink<Event> {
  // Map of BehaviorSubjects for each event key
  final Map<K, BehaviorSubject<EventWrapper<Event>>> _subjects = {};

  /// Gets or creates a BehaviorSubject for a specific key
  BehaviorSubject<EventWrapper<Event>> _getSubject(K key) {
    if (!_subjects.containsKey(key)) {
      _subjects[key] = BehaviorSubject<EventWrapper<Event>>();
    }
    return _subjects[key]!;
  }

  /// Adds a new event listener for a given key.
  /// Returns a subscription that can be used to cancel the listener.
  StreamSubscription<EventWrapper<Event>> addEventListener(
    K key,
    void Function(EventWrapper<Event> eventWrapper) callback, {
    void Function(dynamic, StackTrace)? onError,
  }) {
    final subject = _getSubject(key);
    return subject.stream.listen(callback, onError: onError);
  }

  /// Removes all listeners for the given key and disposes the subject.
  void removeEventListeners(K key) {
    _subjects[key]?.close();
    _subjects.remove(key);
  }

  void _disposeEventBus() {
    for (final subject in _subjects.values) {
      subject.close();
    }
    _subjects.clear();
  }

  void _addEvent(K key, Event event, EventStatus status, {dynamic error}) {
    final wrapper = EventWrapper<Event>(event, status, error: error);
    _getSubject(key).add(wrapper);
  }

  bool get hasListeners => _subjects.isNotEmpty;

  bool get hasActiveListeners =>
      _subjects.values.any((subject) => subject.hasListener);

  int get totalListeners => _subjects.length;

  List<K> get activeEvents => _subjects.keys.toList();

  bool hasListenersForEvent(K key) => _subjects.containsKey(key);
}
