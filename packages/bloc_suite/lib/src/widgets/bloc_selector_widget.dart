import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// {@template bloc_selector_widget}
/// A specialized widget that optimizes rebuilds by selecting specific parts of a Bloc's state.
/// Combines the functionality of [BlocBuilder] with selective state updates.
///
/// Core Features:
/// * Selects and monitors specific state values
/// * Manages bloc lifecycle automatically
/// * Prevents unnecessary rebuilds
/// * Supports both provided and inherited blocs
///
/// Example - Counter implementation:
/// ```dart
/// class CounterScreen extends BlocSelectorWidget<CounterBloc, CounterState, int> {
///   CounterScreen() : super(
///     bloc: CounterBloc(),
///     selector: (state) => state.counterValue,
///   );
///
///   @override
///   Widget build(context, bloc, value) {
///     return Scaffold(
///       body: Text('$value'),
///       floatingActionButton: IconButton(
///         onPressed: bloc.increment,
///         icon: Icon(Icons.add),
///       ),
///     );
///   }
/// }
/// ```
///
/// Type Parameters:
///   - `B`: The bloc type (must be StateStreamableSource)
///   - `S`: The full state type
///   - `T`: The selected state portion type
///
/// Parameters:
///   - [`bloc`]: Optional BLoC instance. If not provided, will be obtained from context
///   - [`selector`]: Required function to select a value from the state
///   - [`key`]: Optional widget key
///
/// **Note: The widget will automatically close the manually provided [bloc] during disposal
/// unless [autoClose] is set to false.**
/// {@endtemplate}
abstract class BlocSelectorWidget<B extends StateStreamableSource<S>, S, T> extends StatefulWidget {
  /// {@macro bloc_selector_widget}
  const BlocSelectorWidget({
    required T Function(S) selector,
    super.key,
    B? bloc,
  })  : _bloc = bloc,
        _selector = selector;

  /// The [_bloc] that the [BlocSelector] will interact with.
  /// If omitted, [BlocSelector] will automatically perform a lookup using
  /// [BlocProvider] and the current [BuildContext].
  final B? _bloc;

  /// The [_selector] function which will be invoked on each widget build
  /// and is responsible for returning a selected value of type [T] based on
  /// the current state.
  final BlocWidgetSelector<S, T> _selector;

  /// Whether the bloc should be automatically closed during disposal.
  bool get autoClose => true;

  /// Returns a widget based on the `BuildContext` and current [state].
  Widget build(BuildContext context, B bloc, T state);

  @override
  State<BlocSelectorWidget<B, S, T>> createState() => _BlocSelectorStateWidget<B, S, T>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<B?>('bloc', _bloc))
      ..add(ObjectFlagProperty<BlocWidgetSelector<S, T>>.has('selector', _selector));
  }
}

class _BlocSelectorStateWidget<B extends StateStreamableSource<S>, S, T>
    extends State<BlocSelectorWidget<B, S, T>> {
  late B _bloc;
  late T _state;

  @override
  void initState() {
    super.initState();
    _bloc = widget._bloc ?? context.read<B>();
    _state = widget._selector(_bloc.state);
  }

  @override
  void didUpdateWidget(BlocSelectorWidget<B, S, T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldBloc = oldWidget._bloc ?? context.read<B>();
    final currentBloc = widget._bloc ?? oldBloc;
    if (oldBloc != currentBloc) {
      _bloc = currentBloc;
      _state = widget._selector(_bloc.state);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bloc = widget._bloc ?? context.read<B>();
    if (_bloc != bloc) {
      _bloc = bloc;
      _state = widget._selector(_bloc.state);
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
      listener: (context, state) {
        final selectedState = widget._selector(state);
        if (_state != selectedState) setState(() => _state = selectedState);
      },
      child: widget.build(context, _bloc, _state),
    );
  }
}
