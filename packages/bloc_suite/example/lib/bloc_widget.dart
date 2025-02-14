import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Signature for the `builder` function which takes the `BuildContext` and
/// [state] and is responsible for returning a widget which is to be rendered.
/// This is analogous to the `builder` function in [StreamBuilder].
typedef BlocWidgetBuilder<S> = Widget Function(BuildContext context, S state);

/// Signature for the `buildWhen` function which takes the previous `state` and
/// the current `state` and is responsible for returning a [bool] which
/// determines whether to rebuild [BlocBuilder] with the current `state`.
typedef BlocBuilderCondition<S> = bool Function(S previous, S current);

/// {@template bloc_builder_base}
/// Base class for widgets that build themselves based on interaction with
/// a specified [bloc].
///
/// A [BlocWidget] is stateful and maintains the state of the interaction
/// so far. The type of the state and how it is updated with each interaction
/// is defined by sub-classes.
/// {@endtemplate}
abstract class BlocWidget<B extends StateStreamable<S>, S> extends StatefulWidget {
  /// {@macro bloc_builder_base}
  const BlocWidget({super.key, B? bloc, this.buildWhen}) : _bloc = bloc;

  // internal field for the bloc
  final B? _bloc;

  /// {@macro bloc_builder_build_when}
  final BlocBuilderCondition<S>? buildWhen;

  /// Returns a widget based on the `BuildContext` and current [state].
  Widget build(BuildContext context, B bloc, S state);

  @override
  State<BlocWidget<B, S>> createState() => _BlocWidgetState<B, S>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<BlocBuilderCondition<S>?>.has('buildWhen', buildWhen))
      ..add(DiagnosticsProperty<B?>('bloc', _bloc));
  }
}

class _BlocWidgetState<B extends StateStreamable<S>, S> extends State<BlocWidget<B, S>> {
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
  Widget build(BuildContext context) {
    if (widget._bloc == null) {
      // Trigger a rebuild if the bloc reference has changed.
      // See https://github.com/felangel/bloc/issues/2127.
      context.select<B, bool>((bloc) => identical(_bloc, bloc));
    }
    return BlocListener<B, S>(
      bloc: _bloc,
      listenWhen: widget.buildWhen,
      listener: (context, state) => setState(() => _state = state),
      child: widget.build(context, _bloc, _state),
    );
  }
}
