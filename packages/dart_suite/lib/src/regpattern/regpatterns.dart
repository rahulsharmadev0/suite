// ignore_for_file: constant_identifier_names, prefer_interpolation_to_compose_strings
part 'patterns/file_format_patterns.dart';
part 'patterns/password_patterns.dart';
part 'patterns/numeric_patterns.dart';
part 'patterns/other_patterns.dart';
part 'patterns/pan_gst_patterns.dart';
part 'patterns/general_patterns.dart';
part 'regpattern.dart';

const regPatterns = _RegPatterns._internal();

class _RegPatterns
    with
        _PasswordRegPatterns,
        _NumericRegPatterns,
        _OtherRegPatterns,
        _PanGstPatterns,
        _GeneralRegPatterns {
  const _RegPatterns._internal();

  _FileFormatRegPatterns get fileFormats => _FileFormatRegPatterns();
}
