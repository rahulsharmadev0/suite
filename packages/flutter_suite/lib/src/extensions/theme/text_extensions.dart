import 'package:flutter/material.dart';
import 'package:flutter_suite/flutter_suite.dart';

extension StyledText<T extends Text> on T {
  Text $copyWith({
    String? data,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    TextScaler? textScaler,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
    Color? selectionColor,
  }) =>
      Text(
        data ?? this.data ?? "",
        style: style ?? this.style,
        strutStyle: strutStyle ?? this.strutStyle,
        textAlign: textAlign ?? this.textAlign,
        locale: locale ?? this.locale,
        maxLines: maxLines ?? this.maxLines,
        overflow: overflow ?? this.overflow,
        semanticsLabel: semanticsLabel ?? this.semanticsLabel,
        softWrap: softWrap ?? this.softWrap,
        textDirection: textDirection ?? this.textDirection,
        textScaler: textScaler ?? this.textScaler,
        textWidthBasis: textWidthBasis ?? this.textWidthBasis,
        textHeightBehavior: textHeightBehavior ?? this.textHeightBehavior,
        selectionColor: selectionColor ?? this.selectionColor,
      );

  T $textStyle(TextStyle? style) => $copyWith(
        style: (this.style ?? const TextStyle()).copyWith(
          background: style?.background,
          backgroundColor: style?.backgroundColor,
          color: style?.color,
          debugLabel: style?.debugLabel,
          decoration: style?.decoration,
          decorationColor: style?.decorationColor,
          decorationStyle: style?.decorationStyle,
          decorationThickness: style?.decorationThickness,
          fontFamily: style?.fontFamily,
          fontFamilyFallback: style?.fontFamilyFallback,
          fontFeatures: style?.fontFeatures,
          fontVariations: style?.fontVariations,
          fontSize: style?.fontSize,
          fontStyle: style?.fontStyle,
          fontWeight: style?.fontWeight,
          foreground: style?.foreground,
          height: style?.height,
          leadingDistribution: style?.leadingDistribution,
          inherit: style?.inherit,
          letterSpacing: style?.letterSpacing,
          locale: style?.locale,
          shadows: style?.shadows,
          textBaseline: style?.textBaseline,
          wordSpacing: style?.wordSpacing,
          overflow: style?.overflow,
        ),
      ) as T;

  Text $copyWithRich({
    InlineSpan? textSpan,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    double? textScaleFactor,
    TextScaler? textScaler,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
    Color? selectionColor,
  }) =>
      Text.rich(
        textSpan ?? this.textSpan!,
        style: style ?? this.style,
        strutStyle: strutStyle ?? this.strutStyle,
        textAlign: textAlign ?? this.textAlign,
        locale: locale ?? this.locale,
        maxLines: maxLines ?? this.maxLines,
        overflow: overflow ?? this.overflow,
        semanticsLabel: semanticsLabel ?? this.semanticsLabel,
        softWrap: softWrap ?? this.softWrap,
        textDirection: textDirection ?? this.textDirection,
        // ignore: deprecated_member_use
        textScaleFactor: textScaleFactor ?? this.textScaleFactor,
        textScaler: textScaler ?? this.textScaler,
        textWidthBasis: textWidthBasis ?? this.textWidthBasis,
        textHeightBehavior: textHeightBehavior ?? this.textHeightBehavior,
        selectionColor: selectionColor ?? this.selectionColor,
      );

  T $align(TextAlign align) => $copyWith(textAlign: align) as T;

  T $direction(TextDirection direction) => $copyWith(textDirection: direction) as T;

  T $scale(TextScaler textScaler) => $copyWith(
        textScaler: textScaler,
      ) as T;
  T $widthBasis(TextWidthBasis textWidthBasis) =>
      $copyWith(textWidthBasis: textWidthBasis) as T;

  T $font({
    String? family,
    List<String>? fallback,
    String? package,
    double? size,
    FontWeight? weight,
    FontStyle? style,
    double? lineHeight,
    double? letter,
    double? word,
  }) =>
      $copyWith(
          style: (this.style ?? const TextStyle()).$font(
        family: family,
        fallback: fallback,
        package: package,
        size: size,
        weight: weight,
        style: style,
        lineHeight: lineHeight,
        letter: letter,
        word: word,
      )) as T;
}
