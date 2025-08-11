import 'dart:async';

import 'package:flutter/material.dart';

/// A generic loading/data/error wrapper for async and sync data sources.
///
/// Supports Future, Stream, or static data. Highly customizable for loading,
/// error, and data states. Can be used as a full-screen or embedded widget.
class LoadingWrapper<R extends Object> extends StatelessWidget {
  /// The async data source. Use either [future] or [stream].
  final Future<R>? future;
  final Stream<R>? stream;

  /// The widget to display when data is loaded successfully.
  final Widget Function(R data) child;

  /// Initial data for the builder (optional).
  final R? initialData;

  /// Optional error message or object.
  final Object? error;

  /// Optional callback for retry functionality when an error occurs.
  final VoidCallback? onRetry;

  /// Optional custom loading widget. If not provided, a default CircularProgressIndicator
  /// with a loading message will be shown.
  final Widget? loadingWidget;

  /// Optional custom error widget. If not provided, a default error icon, message, and retry
  /// button will be shown.
  final Widget Function(Object error, VoidCallback? onRetry)?
  errorWidgetBuilder;

  /// Whether to wrap the content in a Scaffold. Set to false for embedding.
  final bool useScaffold;

  /// Optional placeholder widget while waiting for the first frame.
  final Widget? placeholder;

  /// Optional builder for full control over all states.
  final Widget Function(BuildContext context, AsyncSnapshot<R> snapshot)?
  builder;

  /// Optional padding for the content.
  final EdgeInsetsGeometry? padding;

  /// Optional alignment for the content.
  final AlignmentGeometry? alignment;

  /// Creates a LoadingWrapper.
  ///
  /// Use [future] or [stream] for async data, or just [initialData] for static data.
  const LoadingWrapper({
    super.key,
    this.future,
    this.stream,
    required this.child,
    this.initialData,
    this.error,
    this.onRetry,
    this.loadingWidget,
    this.errorWidgetBuilder,
    this.useScaffold = true,
    this.placeholder,
    this.builder,
    this.padding,
    this.alignment,
  }) : assert(
         future != null || stream != null || initialData != null,
         'Provide at least one of future, stream, or initialData.',
       );

  @override
  Widget build(BuildContext context) {
    if (builder != null) {
      // Custom builder for full control
      if (future != null) {
        return FutureBuilder<R>(
          future: future,
          initialData: initialData,
          builder: builder!,
        );
      } else if (stream != null) {
        return StreamBuilder<R>(
          stream: stream,
          initialData: initialData,
          builder: builder!,
        );
      } else {
        return builder!(
          context,
          AsyncSnapshot.withData(ConnectionState.done, initialData as R),
        );
      }
    }
    if (future != null) {
      return FutureBuilder<R>(
        future: future,
        initialData: initialData,
        builder: (context, snapshot) => _buildState(context, snapshot),
      );
    } else if (stream != null) {
      return StreamBuilder<R>(
        stream: stream,
        initialData: initialData,
        builder: (context, snapshot) => _buildState(context, snapshot),
      );
    } else {
      // Static data
      return _wrapContent(child(initialData as R));
    }
  }

  Widget _buildState(BuildContext context, AsyncSnapshot<R> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return _wrapContent(
        placeholder ?? loadingWidget ?? _defaultLoading(context),
      );
    }
    if (snapshot.hasError || error != null) {
      return _wrapContent(
        errorWidgetBuilder != null
            ? errorWidgetBuilder!(
              snapshot.error ?? error ?? 'Unknown error',
              onRetry,
            )
            : _defaultError(
              context,
              snapshot.error ?? error ?? 'Unknown error',
            ),
      );
    }
    if (snapshot.hasData) {
      return _wrapContent(child(snapshot.data as R));
    }
    // Fallback: show loading
    return _wrapContent(loadingWidget ?? _defaultLoading(context));
  }

  Widget _wrapContent(Widget content) {
    Widget wrapped = content;
    if (padding != null) {
      wrapped = Padding(padding: padding!, child: wrapped);
    }
    if (alignment != null) {
      wrapped = Align(alignment: alignment!, child: wrapped);
    }
    if (useScaffold) {
      wrapped = Scaffold(body: Center(child: wrapped));
    }
    return wrapped;
  }

  Widget _defaultLoading(BuildContext context) => const Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(height: 16),
      CircularProgressIndicator(),
      SizedBox(height: 16),
      Text('Loading...'),
    ],
  );

  Widget _defaultError(BuildContext context, Object error) {
    var theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
        const SizedBox(height: 16),
        Text(
          error.toString(),
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: 16),
        if (onRetry != null)
          FilledButton(onPressed: onRetry, child: const Text('Retry')),
      ],
    );
  }
}
