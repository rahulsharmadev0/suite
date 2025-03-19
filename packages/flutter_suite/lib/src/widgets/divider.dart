import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum DividerAlignment { start, center, end }

/// {@template j_divider}
/// Creates a Material Design divider.
///
/// The [thickness], [indent], and [endIndent] must be null or non-negative.
///
/// **CustomDivider**: A render widget that draws a horizontal line, with an optional text in the middle.\
/// **CustomDivider.v**: A render widget that draws a vertical line, with an optional text in the middle.
/// {@endtemplate}
class CustomDivider extends StatelessWidget {
  /// {@macro j_divider}
  const CustomDivider({
    super.key,
    this.text,
    this.thickness,
    this.indent,
    this.endIndent,
    this.color,
    this.textWidget,
    this.dividerRadius,
    this.textAlign,
    this.textPadding,
  })  : isVertical = false,
        assert(thickness == null || thickness >= 0.0),
        assert(indent == null || indent >= 0.0),
        assert(endIndent == null || endIndent >= 0.0);

  /// {@macro j_divider}
  const CustomDivider.v({
    super.key,
    this.text,
    this.thickness,
    this.indent,
    this.endIndent,
    this.color,
    this.textWidget,
    this.dividerRadius,
    this.textAlign,
    this.textPadding,
  })  : isVertical = true,
        assert(thickness == null || thickness >= 0.0),
        assert(indent == null || indent >= 0.0),
        assert(endIndent == null || endIndent >= 0.0);

  final bool isVertical;

  final Widget? textWidget;

  final String? text;

  final DividerAlignment? textAlign;

  final double? dividerRadius;

  final EdgeInsetsGeometry? textPadding;

  /// The thickness of the line drawn within the divider.
  ///
  /// A divider with a [thickness] of 0.0 is always drawn as a line with a
  /// height of exactly one device pixel.
  ///
  /// If this is null, then the [DividerThemeData.thickness] is used. If
  /// that is also null, then this defaults to 0.0.
  final double? thickness;

  /// The amount of empty space to the leading edge of the divider.
  ///
  /// If this is null, then the [DividerThemeData.indent] is used. If that is
  /// also null, then this defaults to 0.0.
  final double? indent;

  /// The amount of empty space to the trailing edge of the divider.
  ///
  /// If this is null, then the [DividerThemeData.endIndent] is used. If that is
  /// also null, then this defaults to 0.0.
  final double? endIndent;

  /// The color to use when painting the line.
  ///
  /// If this is null, then the [DividerThemeData.color] is used. If that is
  /// also null, then [ThemeData.dividerColor] is used.
  ///
  /// {@tool snippet}
  ///
  /// ```dart
  /// const Divider(
  ///   color: Colors.deepOrange,
  /// )
  /// ```
  /// {@end-tool}
  final Color? color;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('isVertical', isVertical));
    properties.add(DiagnosticsProperty<String?>('text', text));
    properties.add(DiagnosticsProperty<double?>('thickness', thickness));
    properties.add(DiagnosticsProperty<double?>('indent', indent));
    properties.add(DiagnosticsProperty<double?>('endIndent', endIndent));
    properties.add(DiagnosticsProperty<Color?>('color', color));
    properties.add(DiagnosticsProperty<Widget?>('textWidget', textWidget));
    properties.add(DiagnosticsProperty<double?>('dividerRadius', dividerRadius));
    properties.add(DiagnosticsProperty<DividerAlignment?>('textAlign', textAlign));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('textPadding', textPadding));
  }

  @override
  Widget build(BuildContext context) {
    final divider = buildDividerLine(context);
    Widget? text = buildText();

    return text != null ? layoutBuilder(divider, text) : divider;
  }

  Widget layoutBuilder(Widget divider, [Widget? child]) {
    final textAlign = this.textAlign ?? DividerAlignment.center;
    final children =
        List.generate(3, (i) => textAlign.index == i ? child! : Expanded(child: divider));
    return isVertical
        ? Column(mainAxisAlignment: MainAxisAlignment.center, children: children)
        : Row(mainAxisAlignment: MainAxisAlignment.center, children: children);
  }

  Widget buildDividerLine(BuildContext context) {
    final DividerThemeData dividerTheme = DividerTheme.of(context);
    final double thickness =
        this.thickness ?? dividerTheme.thickness ?? dividerTheme.thickness ?? 1;
    final double indent = this.indent ?? dividerTheme.indent ?? dividerTheme.indent ?? 0;
    final double endIndent =
        this.endIndent ?? dividerTheme.endIndent ?? dividerTheme.endIndent ?? 0;
    final margin = EdgeInsetsDirectional.only(start: indent, end: endIndent);
    final borderSide = Divider.createBorderSide(context, color: color, width: thickness);

    return Container(
        height: isVertical ? null : thickness,
        width: isVertical ? thickness : null,
        margin: margin,
        decoration: BoxDecoration(
            border: Border(
                bottom: !isVertical ? borderSide : BorderSide.none,
                right: isVertical ? borderSide : BorderSide.none),
            borderRadius: BorderRadius.circular(dividerRadius ?? 16)));
  }

  Widget? buildText() {
    return text != null
        ? Padding(
            padding: textPadding ?? const EdgeInsets.symmetric(horizontal: 4),
            child: Text(text!))
        : textWidget;
  }
}
