// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart';

/// Type of Device
///
/// This can be android, ios, fuchsia, web, windows, mac, linux
enum Platform {
  web,

  /// Android: <https://www.android.com/>
  android,

  /// Fuchsia: <https://fuchsia.dev/fuchsia-src/concepts>
  fuchsia,

  /// iOS: <https://www.apple.com/ios/>
  iOS,

  /// Linux: <https://www.linux.org>
  linux,

  /// macOS: <https://www.apple.com/macos>
  macOS,

  /// Windows: <https://www.windows.com>
  windows;

  static bool get isWeb => current == Platform.web;
  static bool get isMacOS => current == Platform.macOS;
  static bool get isWindows => current == Platform.windows;
  static bool get isLinux => current == Platform.linux;
  static bool get isAndroid => current == Platform.android;
  static bool get isIOS => current == Platform.iOS;
  static bool get isFuchsia => current == Platform.fuchsia;
  static bool get isDesktop {
    Platform active = current;
    return active == Platform.windows ||
        active == Platform.linux ||
        active == Platform.macOS;
  }

  static bool get isMobileorTablet {
    Platform active = current;
    return active == Platform.iOS || active == Platform.android;
  }

  static Platform get current {
    if (kIsWeb) return Platform.web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return Platform.android;

      case TargetPlatform.iOS:
        return Platform.iOS;

      case TargetPlatform.windows:
        return Platform.windows;

      case TargetPlatform.macOS:
        return Platform.macOS;

      case TargetPlatform.linux:
        return Platform.linux;

      default:
        return Platform.fuchsia;
    }
  }

  void executeFor({
    VoidCallback? web,
    VoidCallback? macOS,
    VoidCallback? windows,
    VoidCallback? linux,
    VoidCallback? android,
    VoidCallback? iOS,
    VoidCallback? fuchsia,
    VoidCallback? others,
    VoidCallback? mobile,
    VoidCallback? desktop,
  }) {
    if (Platform.isAndroid && android != null) return android.call();
    if (Platform.isIOS && iOS != null) return iOS.call();
    if (Platform.isMobileorTablet && mobile != null) return mobile.call();
    if (Platform.isLinux && linux != null) return linux.call();
    if (Platform.isWindows && windows != null) return windows.call();
    if (Platform.isMacOS && macOS != null) return macOS.call();
    if (Platform.isDesktop && desktop != null) return desktop.call();
    if (Platform.isWeb && web != null) return web.call();
    if (Platform.isFuchsia && fuchsia != null) return fuchsia.call();
  }
}
