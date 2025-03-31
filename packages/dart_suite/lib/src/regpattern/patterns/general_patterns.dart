part of '../regpatterns.dart';

mixin _GeneralRegPatterns {
  /// Username regex
  RegPattern username({
    bool allowSpace = false,
    int minLength = 2,
    int maxLength = 16,
  }) {
    minLength = minLength < 2 ? 2 : minLength - 2;
    maxLength = maxLength - 2;
    var space = allowSpace ? ' ' : '';
    return RegPattern(
        pattern:
            '^[a-zA-Z0-9][a-zA-Z0-9_\\-/.$space]{$minLength,$maxLength}[a-zA-Z0-9]\$',
        message:
            'Only accepts a-zA-Z - _ • / ${allowSpace ? 'and space.' : ''}');
  }

  /// Name regex
  RegPattern get name => RegPattern(
      pattern: r'^[a-zA-Z]{2,32}(?: [a-zA-Z]{2,32}){0,2}$',
      message: 'Only letters (a-z, A-Z) are allowed, with up to 3 words.');

  /// Email regex
  RegPattern get email => RegPattern(
      pattern:
          r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$",
      message: 'Invalid email address.');

  /// URL regex
  RegPattern get url => RegPattern(
        pattern:
            r"^((((H|h)(T|t)|(F|f))(T|t)(P|p)((S|s)?))\://)?(www.|[a-zA-Z0-9].)[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,6}(\:[0-9]{1,5})*(/($|[a-zA-Z0-9\.\,\;\?\'\\\+&amp;%\$#\=~_\-]+))*$",
        message: 'Invalid url address.',
      );

  /// Phone Number regex
  RegPattern get phoneNumber {
    return RegPattern(
      pattern: r'^((?:([+]\d{1,4}).?)|0)?(\d{7,15})$',
      message:
          'Invalid phone number. Must start with "+" and 1-4 digits or "0", followed by 7-15 digits.',
    );
  }

  /// Postal Code
  RegPattern postalCode({int maxLength = 6, bool allowAlphabets = false}) =>
      RegPattern(
        pattern: allowAlphabets
            ? r'^[a-zA-Z0-9]{5,' + maxLength.toString() + r'}$'
            : r'^\d{5,' + maxLength.toString() + r'}?$',
      );
}
