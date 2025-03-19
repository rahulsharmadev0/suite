import 'package:flutter/material.dart';
import 'package:flutter_suite/flutter_suite.dart';

class SuiteAdaptiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context)? compact;
  final Widget Function(BuildContext context)? medium;
  final Widget Function(BuildContext context)? expanded;
  final Widget Function(BuildContext context)? large;
  final Widget Function(BuildContext context)? extraLarge;

  const SuiteAdaptiveBuilder({
    super.key,
    this.compact,
    this.medium,
    this.expanded,
    this.large,
    this.extraLarge,
  });

  @override
  Widget build(BuildContext context) {
    final active = WindowSize.evaluate(
      orientation: context.mQ.orientation,
      width: context.height,
      height: context.width,
      devicePixelRatio: context.dpr,
      devicePhysicalDensity: context.dpi,
    );

    // Simplified layout selection logic
    final layout = _getLayoutForWindowSize(active);
    return layout?.call(context) ?? _defaultLayout(context);
  }

  Widget Function(BuildContext context)? _getLayoutForWindowSize(WindowSize size) {
    switch (size) {
      case WindowSize.EXTRA_LARGE:
        return extraLarge ?? large ?? expanded ?? medium ?? compact;
      case WindowSize.LARGE:
        return large ?? expanded ?? medium ?? compact;
      case WindowSize.EXPANDED:
        return expanded ?? medium ?? compact;
      case WindowSize.MEDIUM:
        return medium ?? compact;
      case WindowSize.COMPACT:
        return compact;
    }
  }

  Widget _defaultLayout(BuildContext context) =>
      Center(child: Text('No layout defined!', style: context.TxT.h2));
}
