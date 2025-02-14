import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';

/// Global logger instance with minimal configuration
final _log = Logger(printer: PrettyPrinter(methodCount: 0, printEmojis: false));

/// A BlocObserver that provides detailed logging capabilities for Flutter Bloc events
/// and state changes with customizable filtering options.
final class FlutterBlocObserver extends BlocObserver {
  final bool enabled;
  final bool printEvents;
  final bool printTransitions;
  final bool printChanges;
  final bool printCreations;
  final bool printClosings;
  final bool Function(Bloc bloc, Transition transition)? transitionFilter;
  final bool Function(Bloc bloc, Object? event)? eventFilter;

  const FlutterBlocObserver({
    this.enabled = kDebugMode,
    this.printEvents = true,
    this.printTransitions = true,
    this.printChanges = true,
    this.printCreations = true,
    this.printClosings = true,
    this.transitionFilter,
    this.eventFilter,
  });

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    _logIfEnabled(
      condition: printEvents,
      filter: eventFilter?.call(bloc, event) ?? true,
      message: _formatEvent(bloc, event),
    );
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    _logIfEnabled(
      condition: printTransitions,
      filter: transitionFilter?.call(bloc, transition) ?? true,
      message: _formatTransition(bloc, transition),
    );
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    _logIfEnabled(condition: printChanges, message: _formatChange(bloc, change));
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    _logIfEnabled(message: '🚫 ${bloc.runtimeType} Error', error: error, stackTrace: stackTrace);
  }

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    _logIfEnabled(condition: printCreations, message: '🔓 ${bloc.runtimeType} Created');
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    _logIfEnabled(condition: printClosings, message: '🔒 ${bloc.runtimeType} Closed');
  }

  void _logIfEnabled({
    bool condition = true,
    bool filter = true,
    required String message,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!enabled || !condition || !filter) return;
    error != null ? _log.e(message, error: error, stackTrace: stackTrace) : _log.d(message);
  }

  String _formatEvent(Bloc bloc, Object? event) => '📩 ${bloc.runtimeType} Event: $event}';

  String _formatTransition(Bloc bloc, Transition transition) {
    return '''🔄 ${bloc.runtimeType} Transition:
    ⤷ Event: ${transition.event.runtimeType}
    ⤷ From: ${transition.currentState}
    ⤷ To: ${transition.nextState}''';
  }

  String _formatChange(BlocBase bloc, Change change) {
    return '''📝 ${bloc.runtimeType} Changed:
    ⤷ From: ${change.currentState}
    ⤷ To: ${change.nextState}''';
  }
}
