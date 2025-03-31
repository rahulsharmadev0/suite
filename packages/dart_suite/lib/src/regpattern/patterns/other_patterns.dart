part of '../regpatterns.dart';

// ignore: unused_element
mixin _OtherRegPatterns {
  RegPattern get googlePlusCode => RegPattern(
        pattern: r'^[2-9CFGHJMPQRVWX]{4}\+[2-9CFGHJMPQRVWX]{2,8}$',
        message: 'Invalid Google Plus Code.',
      );

  /// MD5 regex
  RegPattern get md5 => RegPattern(
        pattern: r'^[a-f0-9]{32}$',
        message: 'Invalid md5 format.',
      );

  /// SHA1 regex
  RegPattern get sha1 => RegPattern(
        pattern: r'(([A-Fa-f0-9]{2}\:){19}[A-Fa-f0-9]{2}|[A-Fa-f0-9]{40})',
        message:
            'Either 40 hexadecimal characters or 20 pairs of hexadecimal characters separated by colons.',
      );

  /// SHA256 regex
  RegPattern get sha256 => RegPattern(
        pattern: r'([A-Fa-f0-9]{2}\:){31}[A-Fa-f0-9]{2}|[A-Fa-f0-9]{64}',
        message:
            'Either be 64 hexadecimal characters or 32 pairs of hexadecimal characters separated by colons.',
      );

  /// SSN (Social Security Number) regex
  RegPattern get ssn => RegPattern(
        pattern:
            r'^(?!0{3}|6{3}|9[0-9]{2})[0-9]{3}-?(?!0{2})[0-9]{2}-?(?!0{4})[0-9]{4}$',
        message:
            "ensuring it doesn't start with all zeros in each section and follows the typical format: XXX-XX-XXXX.",
      );

  /// IPv4 regex
  RegPattern get ipv4 =>
      RegPattern(pattern: r'^(?:(?:^|\.)(?:2(?:5[0-5]|[0-4]\d)|1?\d?\d)){4}$');

  /// IPv6 regex
  RegPattern get ipv6 => RegPattern(
      pattern:
          r'^((([0-9A-Fa-f]{1,4}:){7}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){6}:[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){5}:([0-9A-Fa-f]{1,4}:)?[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){4}:([0-9A-Fa-f]{1,4}:){0,2}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){3}:([0-9A-Fa-f]{1,4}:){0,3}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){2}:([0-9A-Fa-f]{1,4}:){0,4}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){6}((\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b)\.){3}(\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b))|(([0-9A-Fa-f]{1,4}:){0,5}:((\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b)\.){3}(\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b))|(::([0-9A-Fa-f]{1,4}:){0,5}((\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b)\.){3}(\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b))|([0-9A-Fa-f]{1,4}::([0-9A-Fa-f]{1,4}:){0,5}[0-9A-Fa-f]{1,4})|(::([0-9A-Fa-f]{1,4}:){0,6}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){1,7}:))$');

  /// ISBN 10 & 13 regex
  RegPattern get isbn => RegPattern(
      pattern:
          r'(ISBN(\-1[03])?[:]?[ ]?)?(([0-9Xx][- ]?){13}|([0-9Xx][- ]?){10})');

  RegPattern get base64 => RegPattern(
      pattern:
          r'^(?:[A-Za-z0-9+\/]{4})*(?:[A-Za-z0-9+\/]{2}==|[A-Za-z0-9+\/]{3}=|[A-Za-z0-9+\/]{4})$');

  /// DateTime regex (UTC)
  /// Unformatted date time (UTC and Iso8601)
  /// Example: 2020-04-27 08:14:39.977, 2020-04-27T08:14:39.977, 2020-04-27 01:14:39.977Z
  RegPattern get basicDateTime => RegPattern(
      pattern: r'^\d{4}-\d{2}-\d{2}[ T]\d{2}:\d{2}:\d{2}.\d{3}Z?$',
      message: 'Invalid UTC or Iso8601 format.');

  /// Github repository regex
  RegPattern get github => RegPattern(
      pattern:
          r'((git|ssh|http(s)?)|(git@[\w\.]+))(:(\/\/)?)([\w\.@\:/\-~]+)(\.git)(\/)?');

  /// Passport No. regex
  RegPattern get passport => RegPattern(pattern: r'^(?!^0+$)[a-zA-Z0-9]{6,9}$');

  /// Currency regex
  RegPattern get currency => RegPattern(
      pattern:
          r'^(S?\$|\₩|Rp|\¥|\€|\₹|\₽|fr|R$|R)?[ ]?[-]?([0-9]{1,3}[,.]([0-9]{3}[,.])*[0-9]{3}|[0-9]*)([,.][0-9]{1,2})?( ?(USD?|AUD|NZD|CAD|CHF|GBP|CNY|EUR|JPY|IDR|MXN|NOK|KRW|TRY|INR|RUB|BRL|ZAR|SGD|MYR))?$');

  /// Alphabet Only regex (No Whitespace & Symbols)
  RegPattern get alphabetOnly => RegPattern(pattern: r'^[a-zA-Z]+$');

  RegPattern get alphabetAndDigits => RegPattern(pattern: r'^[a-zA-Z]+$');

  /// HTML Tags
  /// multiLine = true
  RegPattern get htmlTags => RegPattern(
      pattern:
          r"^<(?:([A-Za-z][A-Za-z0-9]*)\b[^>]*>(?:.*?)</\1>|[A-Za-z][A-Za-z0-9]*\b[^/>]*/>)$",
      message: "Ensures the tags have proper names");

  /// Credit/Debit Card
  RegPattern get creditCard => RegPattern(
      pattern:
          r"^(?:3[47]\d{2}([\- ]?)\d{6}\1\d{5}|(?:4\d{3}|5[1-5]\d{2}|6011)([\- ]?)\d{4}\2\d{4}\2\d{4})$",
      message: "Invalid credit/debit card format");
}
