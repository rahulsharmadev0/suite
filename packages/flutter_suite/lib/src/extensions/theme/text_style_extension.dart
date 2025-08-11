import 'package:flutter/widgets.dart';

extension TexttStyleExt<T extends TextStyle> on T {
  /// The most thick - FontWeight.w900
  TextStyle get $mostThick => copyWith(fontWeight: FontWeight.w900);
  TextStyle get $w900 => copyWith(fontWeight: FontWeight.w900);

  /// Extra-bold - FontWeight.w800
  TextStyle get $extraBold => copyWith(fontWeight: FontWeight.w800);
  TextStyle get $w800 => copyWith(fontWeight: FontWeight.w800);

  /// Bold - FontWeight.bold - FontWeight.w700
  TextStyle get $bold => copyWith(fontWeight: FontWeight.w700);
  TextStyle get $w700 => copyWith(fontWeight: FontWeight.w700);

  /// Semi-bold - FontWeight.w600
  TextStyle get $semiBold => copyWith(fontWeight: FontWeight.w600);
  TextStyle get $w600 => copyWith(fontWeight: FontWeight.w600);

  /// Medium - FontWeight.w500
  TextStyle get $medium => copyWith(fontWeight: FontWeight.w500);
  TextStyle get $w500 => copyWith(fontWeight: FontWeight.w500);

  /// Regular - FontWeight.w400
  TextStyle get $regular => copyWith(fontWeight: FontWeight.w400);
  TextStyle get $w400 => copyWith(fontWeight: FontWeight.w400);

  /// Light - FontWeight.w300
  TextStyle get $light => copyWith(fontWeight: FontWeight.w300);
  TextStyle get $w300 => copyWith(fontWeight: FontWeight.w300);

  /// Extra-light - FontWeight.w200
  TextStyle get $extraLight => copyWith(fontWeight: FontWeight.w200);
  TextStyle get $w200 => copyWith(fontWeight: FontWeight.w200);

  /// Thin, the least thick - FontWeight.w100
  TextStyle get $thin => copyWith(fontWeight: FontWeight.w100);
  TextStyle get $w100 => copyWith(fontWeight: FontWeight.w100);

  TextStyle $inherit(bool inherit) => copyWith(inherit: inherit);

  TextStyle $color(Color color, [double? opacity]) =>
      copyWith(color: color.withValues(alpha: opacity ?? 1));

  TextStyle $backgroundColor(Color backgroundColor, [double? opacity]) =>
      copyWith(backgroundColor: backgroundColor.withValues(alpha: opacity ?? 1));

  TextStyle $fontSize(double fontSize) => copyWith(fontSize: fontSize);

  TextStyle $fontWeight(FontWeight fontWeight) => copyWith(fontWeight: fontWeight);

  TextStyle $fontStyle(FontStyle fontStyle) => copyWith(fontStyle: fontStyle);

  TextStyle $letterSpacing(double letterSpacing) =>
      copyWith(letterSpacing: letterSpacing);

  TextStyle $wordSpacing(double wordSpacing) => copyWith(wordSpacing: wordSpacing);

  TextStyle $textBaseline(TextBaseline textBaseline) =>
      copyWith(textBaseline: textBaseline);

  TextStyle $height(double height) => copyWith(height: height);

  TextStyle $leadingDistribution(TextLeadingDistribution leadingDistribution) =>
      copyWith(leadingDistribution: leadingDistribution);

  TextStyle $locale(Locale locale) => copyWith(locale: locale);

  TextStyle $foreground(Paint foreground) => copyWith(foreground: foreground);

  TextStyle $background(Paint background) => copyWith(background: background);

  TextStyle $shadows(List<Shadow> shadows) => copyWith(shadows: shadows);

  TextStyle $fontFeatures(List<FontFeature> fontFeatures) =>
      copyWith(fontFeatures: fontFeatures);

  TextStyle $fontVariations(List<FontVariation> fontVariations) =>
      copyWith(fontVariations: fontVariations);

  /// Shorthand for text decoration properties
  TextStyle $decoration(TextDecoration decoration,
          {Color? color,
          double? opacity,
          TextDecorationStyle? style,
          double? thickness}) =>
      copyWith(
          decoration: decoration,
          decorationColor: color?.withValues(alpha: opacity ?? 1),
          decorationThickness: thickness,
          decorationStyle: style);

  TextStyle $decorationColor(Color decorationColor, [double? opacity]) =>
      copyWith(decorationColor: decorationColor.withValues(alpha: opacity ?? 1));

  TextStyle $decorationStyle(TextDecorationStyle decorationStyle) =>
      copyWith(decorationStyle: decorationStyle);

  TextStyle $decorationThickness(double decorationThickness) =>
      copyWith(decorationThickness: decorationThickness);

  TextStyle $debugLabel(String debugLabel) => copyWith(debugLabel: debugLabel);

  TextStyle $fontFamily(String fontFamily) => copyWith(fontFamily: fontFamily);

  TextStyle $fontFamilyFallback(List<String> fontFamilyFallback) =>
      copyWith(fontFamilyFallback: fontFamilyFallback);

  TextStyle $package(String package) => copyWith(package: package);

  TextStyle $overflow(TextOverflow overflow) => copyWith(overflow: overflow);

  TextStyle $opacity(double opacity) =>
      copyWith(color: color?.withValues(alpha: opacity));

  /// Common decoration shorthands
  TextStyle $underline(
          {Color? color,
          double? opacity,
          TextDecorationStyle? style,
          double? thickness}) =>
      $decoration(TextDecoration.underline,
          color: color, opacity: opacity, style: style, thickness: thickness);

  TextStyle $lineThrough(
          {Color? color,
          double? opacity,
          TextDecorationStyle? style,
          double? thickness}) =>
      $decoration(TextDecoration.lineThrough,
          color: color, opacity: opacity, style: style, thickness: thickness);

  TextStyle $overline(
          {Color? color,
          double? opacity,
          TextDecorationStyle? style,
          double? thickness}) =>
      $decoration(TextDecoration.overline,
          color: color, opacity: opacity, style: style, thickness: thickness);

  /// Shadow helpers
  TextStyle $addShadow(
      {double dx = 0,
      double dy = 0,
      double blur = 0,
      Color color = const Color(0xFF000000),
      double opacity = 1}) {
    final existing = shadows ?? const <Shadow>[];
    return copyWith(
      shadows: [
        ...existing,
        Shadow(
          offset: Offset(dx, dy),
          blurRadius: blur,
          color: color.withValues(alpha: opacity),
        ),
      ],
    );
  }

  TextStyle $shadowsAdd(List<Shadow> more) {
    final existing = shadows ?? const <Shadow>[];
    return copyWith(shadows: [...existing, ...more]);
  }

  TextStyle get $clearShadows => copyWith(shadows: const <Shadow>[]);

  /// Stroke/fill via foreground Paint
  TextStyle $stroke(double width, Color color, [double? opacity]) => copyWith(
        foreground: (foreground ?? Paint())
          ..style = PaintingStyle.stroke
          ..strokeWidth = width
          ..color = color.withValues(alpha: opacity ?? 1),
      );

  TextStyle $fillPaint(Color color, [double? opacity]) => copyWith(
        foreground: (foreground ?? Paint())
          ..style = PaintingStyle.fill
          ..color = color.withValues(alpha: opacity ?? 1),
      );

  /// Convenience getter for italic style
  TextStyle get $italic => copyWith(fontStyle: FontStyle.italic);
  TextStyle get $normalStyle => copyWith(fontStyle: FontStyle.normal);

  /// Remove any text decoration
  TextStyle get $noDecoration => copyWith(
        decoration: TextDecoration.none,
        decorationColor: null,
        decorationThickness: null,
        decorationStyle: null,
      );

  /// Combined spacing setter
  TextStyle $spacing({double? letter, double? word, double? lineHeight}) => copyWith(
        letterSpacing: letter ?? letterSpacing,
        wordSpacing: word ?? wordSpacing,
        height: lineHeight ?? height,
      );

  /// Combined font-related setter
  TextStyle $font({
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
      copyWith(
        fontFamily: family ?? fontFamily,
        fontFamilyFallback: fallback ?? fontFamilyFallback,
        package: package,
        fontSize: size ?? fontSize,
        fontWeight: weight ?? fontWeight,
        fontStyle: style ?? fontStyle,
        height: lineHeight ?? height,
        letterSpacing: letter ?? letterSpacing,
        wordSpacing: word ?? wordSpacing,
      );

  /// Font feature helpers (merge with existing)
  TextStyle $featuresAdd(List<FontFeature> features) {
    final existing = fontFeatures ?? const <FontFeature>[];
    return copyWith(fontFeatures: [...existing, ...features]);
  }

  TextStyle $featureEnable(String tag) => $featuresAdd([FontFeature.enable(tag)]);
  TextStyle $featureDisable(String tag) => $featuresAdd([FontFeature.disable(tag)]);

  /// Common feature convenience wrappers
  TextStyle get $enableLigatures => $featureEnable('liga');
  TextStyle get $disableLigatures => $featureDisable('liga');
  TextStyle get $smallCaps => $featureEnable('smcp');
  TextStyle get $tabularFigures => $featureEnable('tnum');

  /// Font variation helpers (merge with existing)
  TextStyle $variationsAdd(List<FontVariation> variations) {
    final existing = fontVariations ?? const <FontVariation>[];
    return copyWith(fontVariations: [...existing, ...variations]);
  }
}
