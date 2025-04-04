import 'package:flutter/widgets.dart';

extension TexttStyleExt on TextStyle {
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

  TextStyle $color(Color color) => copyWith(color: color);

  TextStyle $backgroundColor(Color backgroundColor) =>
      copyWith(backgroundColor: backgroundColor);

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

  TextStyle $decoration(TextDecoration decoration) => copyWith(decoration: decoration);

  TextStyle $decorationColor(Color decorationColor) =>
      copyWith(decorationColor: decorationColor);

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
}
