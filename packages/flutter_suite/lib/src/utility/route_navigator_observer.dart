import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';

/// An observer for monitoring route changes in the navigator with
/// customizable logging capabilities.
final class RouteNavigatorObserver extends NavigatorObserver {
  final bool enabled;
  final bool logPushes;
  final bool logPops;
  final bool logRemovals;
  final bool logReplacements;
  final bool logUserGestures;
  final bool Function(Route<dynamic>? route, Route<dynamic>? previousRoute)? routeFilter;
  final Logger _log;
  final List<String> _routeStack = [];

  RouteNavigatorObserver({
    this.enabled = kDebugMode,
    this.logPushes = true,
    this.logPops = true,
    this.logRemovals = true,
    this.logReplacements = true,
    this.logUserGestures = true,
    this.routeFilter,
    Logger? log,
  }) : _log = log ?? Logger();

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _updateRouteStack(route.settings.name);
    _logIfEnabled(
      action: 'PUSH',
      condition: logPushes,
      route: route,
      previousRoute: previousRoute,
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (_routeStack.isNotEmpty) _routeStack.removeLast();
    _logIfEnabled(
      action: 'POP',
      condition: logPops,
      route: previousRoute,
      previousRoute: route,
    );
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _removeRouteFromStack(previousRoute?.settings.name);
    _logIfEnabled(
      action: 'REMOVE',
      condition: logRemovals,
      route: route,
      previousRoute: previousRoute,
    );
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute == null || oldRoute == null) return;
    _replaceRouteInStack(oldRoute.settings.name, newRoute.settings.name);
    _logIfEnabled(
      action: 'REPLACE',
      condition: logReplacements,
      route: newRoute,
      previousRoute: oldRoute,
    );
  }

  @override
  void didStartUserGesture(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _logIfEnabled(
      action: 'START_USER_GESTURE',
      condition: logUserGestures,
      route: route,
      previousRoute: previousRoute,
    );
  }

  @override
  void didStopUserGesture() {
    if (enabled && logUserGestures) {
      _log.i('🖐️ STOP_USER_GESTURE');
    }
  }

  void _updateRouteStack(String? routeName) {
    if (routeName != null) _routeStack.add(routeName);
  }

  void _removeRouteFromStack(String? routeName) {
    _routeStack.removeWhere((name) => name == routeName);
  }

  void _replaceRouteInStack(String? oldRouteName, String? newRouteName) {
    for (int i = _routeStack.length - 1; i >= 0; i--) {
      if (_routeStack[i] == oldRouteName) {
        _routeStack[i] = newRouteName!;
        break;
      }
    }
  }

  void _logIfEnabled({
    required String action,
    bool condition = true,
    required Route<dynamic>? route,
    required Route<dynamic>? previousRoute,
  }) {
    if (!enabled || !condition) return;
    if (routeFilter != null && !routeFilter!(route, previousRoute)) return;

    final emoji = _getEmojiForAction(action);
    _log.t({
      'ACTION': '$emoji $action',
      'ACTIVE_ROUTE': route?.settings.name ?? 'NULL',
      'PREVIOUS_ROUTE': previousRoute?.settings.name ?? 'NULL',
      'ROUTE_STACK': _routeStack.join(' / '),
    });
  }

  String _getEmojiForAction(String action) {
    switch (action) {
      case 'PUSH':
        return '➡️';
      case 'POP':
        return '⬅️';
      case 'REMOVE':
        return '❌';
      case 'REPLACE':
        return '🔄';
      case 'START_USER_GESTURE':
        return '👆';
      default:
        return '📝';
    }
  }
}

@visibleForTesting
extension RouteNavigatorObserverExt on RouteNavigatorObserver {
  RouteNavigatorObserver copyWith({
    bool? enabled,
    bool? logPushes,
    bool? logPops,
    bool? logRemovals,
    bool? logReplacements,
    bool? logUserGestures,
    bool Function(Route<dynamic>? route, Route<dynamic>? previousRoute)? routeFilter,
  }) =>
      RouteNavigatorObserver(
        enabled: enabled ?? this.enabled,
        logPushes: logPushes ?? this.logPushes,
        logPops: logPops ?? this.logPops,
        logRemovals: logRemovals ?? this.logRemovals,
        logReplacements: logReplacements ?? this.logReplacements,
        logUserGestures: logUserGestures ?? this.logUserGestures,
        routeFilter: routeFilter ?? this.routeFilter,
        log: _log,
      );
}
