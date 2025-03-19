import 'dart:async';
import 'package:flutter/material.dart';

/// A standardized layout for form views that provides consistent styling and behavior.
///
/// This widget handles common form patterns like titles, field layouts, validation,
/// keyboard management, and submission states.
class SuiteFormLayout extends StatelessWidget {
  final Widget? title, subtitle, caption;
  final List<Widget> children;
  final List<Widget> actions;
  final MainAxisAlignment actionsAlignment;
  final CrossAxisAlignment alignment;
  final double verticalGap;
  final double horizontalGap;
  final double actionsGap;
  final EdgeInsetsGeometry padding;

  // Form related properties
  final GlobalKey<FormState>? formKey;
  final bool? canPop;
  final void Function(bool, Object?)? onPopInvokedWithResult;
  final void Function()? onChanged;
  final AutovalidateMode? autovalidateMode;

  /// Whether to automatically dismiss the keyboard when tapping outside input fields
  final bool dismissKeyboardOnTap;

  /// Controller for the scroll view
  final ScrollController? scrollController;

  /// Whether the form is currently submitting/processing
  final bool isLoading;

  /// Widget to show when isLoading is true
  final Widget? loadingIndicator;

  /// Callback when form is submitted
  final FutureOr<void> Function()? onSubmit;

  /// Groups widgets in the form (enables better visual separation)
  final List<List<Widget>> fieldGroups;

  /// Spacing between field groups
  final double groupSpacing;

  /// Background color for the form
  final Color? backgroundColor;

  const SuiteFormLayout({
    super.key,
    this.children = const [],
    this.actions = const [],
    this.title,
    this.subtitle,
    this.alignment = CrossAxisAlignment.start,
    this.verticalGap = 16,
    this.horizontalGap = 16,
    this.actionsGap = 16,
    this.actionsAlignment = MainAxisAlignment.spaceEvenly,
    this.caption,
    this.padding = const EdgeInsets.fromLTRB(16, 0, 16, 24),
    this.formKey,
    this.canPop,
    this.onPopInvokedWithResult,
    this.onChanged,
    this.autovalidateMode,
    this.dismissKeyboardOnTap = true,
    this.scrollController,
    this.isLoading = false,
    this.loadingIndicator,
    this.onSubmit,
    this.fieldGroups = const [],
    this.groupSpacing = 24,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final formContent = Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: _buildScrollableContent(context),
    );

    Widget result = formKey == null
        ? formContent
        : Form(
            key: formKey!,
            onChanged: onChanged,
            autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
            canPop: canPop,
            onPopInvokedWithResult: onPopInvokedWithResult,
            child: formContent);

    if (dismissKeyboardOnTap) {
      result = GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: result,
      );
    }

    if (backgroundColor != null) {
      result = Container(
        color: backgroundColor,
        child: result,
      );
    }

    if (isLoading) {
      result = Stack(
        children: [
          result,
          Positioned.fill(
            child: Container(
              color: Colors.black12,
              child: Center(
                child: loadingIndicator ?? const CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      );
    }

    return result;
  }

  Widget _buildScrollableContent(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      padding: padding,
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: alignment,
        children: [
          if (title != null) _buildTitle(context),
          if (subtitle != null) _buildSubtitle(),
          SizedBox(height: verticalGap),
          ..._buildChildren(),
          if (fieldGroups.isNotEmpty) ..._buildFieldGroups(context),
          if (actions.isNotEmpty) _buildActions(),
          if (caption != null) _buildCaption(),
        ],
      ),
    );
  }

  List<Widget> _buildFieldGroups(BuildContext context) {
    List<Widget> result = [];

    for (var (i, list) in fieldGroups.indexed) {
      result.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: list.map((child) => _buildChild(child)).toList(),
        ),
      );
      if (i < fieldGroups.length - 1) {
        result.add(SizedBox(height: groupSpacing));
      }
    }

    return result;
  }

  List<Widget> _buildChildren() => children.map((child) => _buildChild(child)).toList();

  Widget _buildActions() => Padding(
        padding: EdgeInsets.only(top: verticalGap * 1.5),
        child: actions.length == 1
            ? actions.first
            : Row(
                mainAxisAlignment: actionsAlignment,
                spacing: actionsGap,
                children: actions.map((action) => action).toList()),
      );

  Widget _buildSubtitle() => subtitle!;

  Widget _buildTitle(BuildContext context) => Padding(
        padding: EdgeInsets.only(bottom: verticalGap * 0.5),
        child: title!,
      );

  Widget _buildChild(Widget child) {
    if (child is Flex && child.direction == Axis.horizontal) {
      return child.copyWith(spacing: verticalGap);
    }

    return Padding(
      padding: EdgeInsets.only(bottom: horizontalGap),
      child: child,
    );
  }

  Widget _buildCaption() => Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 4, top: 16),
          child: caption!,
        ),
      );
}

extension on Flex {
  Flex copyWith({
    Key? key,
    MainAxisAlignment? mainAxisAlignment,
    MainAxisSize? mainAxisSize,
    CrossAxisAlignment? crossAxisAlignment,
    TextDirection? textDirection,
    VerticalDirection? verticalDirection,
    TextBaseline? textBaseline,
    Clip? clipBehavior,
    double? spacing,
    List<Widget>? children,
  }) =>
      Flex(
        key: key,
        direction: direction,
        mainAxisAlignment: mainAxisAlignment ?? this.mainAxisAlignment,
        mainAxisSize: mainAxisSize ?? this.mainAxisSize,
        crossAxisAlignment: crossAxisAlignment ?? this.crossAxisAlignment,
        textDirection: textDirection ?? this.textDirection,
        verticalDirection: verticalDirection ?? this.verticalDirection,
        textBaseline: textBaseline ?? this.textBaseline,
        clipBehavior: clipBehavior ?? this.clipBehavior,
        spacing: spacing ?? 0.0,
        children: children ?? this.children,
      );
}
