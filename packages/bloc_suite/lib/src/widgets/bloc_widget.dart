import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// {@template bloc_builder_base}
/// A base widget that simplifies building UI components that depend on a BLoC (Business Logic Component).
///
/// [BlocWidget] provides a streamlined way to create widgets that react to state changes
/// from a BLoC. It handles the complexity of BLoC subscription and state management internally.
///
/// Features:
/// * Automatic BLoC lifecycle management
/// * Built-in state subscription handling
/// * Optional conditional rebuilding with [buildWhen]
/// * Automatic BLoC disposal (configurable via [autoClose])
///
/// Example usage:
/// ```dart
/// class CounterWidget extends BlocWidget<CounterBloc, int> {
///   const CounterWidget({super.key});
///
///   @override
///   Widget build(BuildContext context, CounterBloc bloc, int state) {
///     return Text('Count: $state');
///   }
/// }
/// ```
///
/// Parameters:
///   - [`bloc`]: Optional BLoC instance. If not provided, will be obtained from context
///   - [`buildWhen`]: Optional callback to control widget rebuilds
///   - [`key`]: Optional widget key
///
/// **Note: The widget will automatically close the manually provided [bloc] during disposal
/// unless [autoClose] is set to false.**
/// {@endtemplate}
abstract class BlocWidget<B extends StateStreamableSource<S>, S> extends StatefulWidget {
  /// {@macro bloc_builder_base}
  const BlocWidget({super.key, B? bloc, bool Function(S, S)? buildWhen})
    : _buildWhen = buildWhen,
      _bloc = bloc;

  // internal field for the bloc
  final B? _bloc;

  /// {@macro bloc_builder_build_when}
  final BlocBuilderCondition<S>? _buildWhen;

  /// Returns a widget based on the `BuildContext` and current [state].
  Widget build(BuildContext context, B bloc, S state);

  /// Whether the bloc should be automatically closed during disposal.
  bool get autoClose => true;

  @override
  State<BlocWidget<B, S>> createState() => _BlocWidgetState<B, S>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<BlocBuilderCondition<S>?>.has('buildWhen', _buildWhen))
      ..add(DiagnosticsProperty<B?>('bloc', _bloc));
  }
}

class _BlocWidgetState<B extends StateStreamableSource<S>, S> extends State<BlocWidget<B, S>> {
  late B _bloc;
  late S _state;

  @override
  void initState() {
    super.initState();
    _bloc = widget._bloc ?? context.read<B>();
    _state = _bloc.state;
  }

  @override
  void didUpdateWidget(BlocWidget<B, S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldBloc = oldWidget._bloc ?? context.read<B>();
    final currentBloc = widget._bloc ?? oldBloc;
    if (oldBloc != currentBloc) {
      _bloc = currentBloc;
      _state = _bloc.state;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bloc = widget._bloc ?? context.read<B>();
    if (_bloc != bloc) {
      _bloc = bloc;
      _state = _bloc.state;
    }
  }

  @override
  void dispose() {
    // Only attempt to close the bloc if autoClose is enabled
    if (widget.autoClose && widget._bloc != null) {
      // Check if the bloc is provided manually (widget._bloc)
      // and not available in the widget tree
      var shouldClose = true;
      try {
        final treeBloc = context.read<B>();
        // Don't close if the bloc is still available in the tree
        shouldClose = !identical(treeBloc, _bloc);
      } catch (_) {
        // If read fails, it means the bloc is not in the tree
        // so we should close it if it was provided manually
        shouldClose = true;
      }

      if (shouldClose) {
        _bloc.close();
      }
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget._bloc == null) {
      // Trigger a rebuild if the bloc reference has changed.
      // See https://github.com/felangel/bloc/issues/2127.
      context.select<B, bool>((bloc) => identical(_bloc, bloc));
    }
    return BlocListener<B, S>(
      bloc: _bloc,
      listenWhen: widget._buildWhen,
      listener: (context, state) => setState(() => _state = state),
      child: widget.build(context, _bloc, _state),
    );
  }
}
