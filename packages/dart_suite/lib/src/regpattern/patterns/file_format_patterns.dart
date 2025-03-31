part of '../regpatterns.dart';

class _FileFormatRegPatterns {
  /// Checks if the provided string represents a valid image file supported by Flutter.
  /// Supports file extensions: .jpeg, .jpg, .gif, .png, .bmp, .webp, .svg
  ///
  /// If the input string matches one of these image file extensions,
  /// it is considered a valid Flutter supported image file.
  RegPattern get image => RegPattern(
        pattern: r'.(jpeg|jpg|gif|png|bmp|webp|svg)$',
        message: 'Invalid flutter supported image file.',
      );

  /// Audio regex
  RegPattern get audio => RegPattern(
        pattern: r'.(mp3|wav|wma|amr|ogg)$',
        message: 'Invalid audio supported image file.',
      );

  /// Video regex
  RegPattern get video => RegPattern(
        pattern: r'.(mp4|avi|wmv|rmvb|mpg|mpeg|3gp)$',
        message: 'Invalid video format.',
      );

  /// Txt regex
  RegPattern get txt => RegPattern(
        pattern: r'.txt$',
        message: 'Invalid txt format.',
      );

  RegPattern get word => RegPattern(
        pattern: r'.(doc|docx)$',
        message: 'Invalid format only accepts doc and docx format.',
      );

  /// Excel regex
  RegPattern get excel => RegPattern(
        pattern: r'.(xls|xlsx)$',
        message: 'Invalid format only accepts xls and xlsx format.',
      );

  /// PPT regex
  RegPattern get ppt => RegPattern(
        pattern: r'.(ppt|pptx)$',
        message: 'Invalid format only accepts ppt and pptx format.',
      );

  /// APK regex
  RegPattern get apk => RegPattern(
        pattern: r'.apk$',
        message: 'Invalid apk format ',
      );

  /// PDF regex
  RegPattern get pdf => RegPattern(
        pattern: r'.pdf$',
        message: 'Invalid pdf format',
      );

  /// HTML regex
  RegPattern get html => RegPattern(
        pattern: r'.html$',
        message: 'Invalid html format.',
      );

  RegPattern get svg => RegPattern(
        pattern: r'.(svg)$',
        message: 'Invalid vector format.',
      );
}
