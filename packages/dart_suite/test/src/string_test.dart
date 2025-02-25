// ignore_for_file: non_constant_identifier_names

import 'package:dart_suite/dart_suite.dart';
import 'package:test/test.dart';

void main() {
  group('StringExtensions.numericOnly', () {
    var testcase = {
      'OTP 12312 27/04/2020': '1231227042020',
      'No numbers here': '',
      '1234567890': '1234567890',
      '': '',
      '#123, OTP: 456*789!': '123456789'
    };
    test('get numericOnly', () {
      for (var e in testcase.entries) {
        expect(e.key.numericOnly(), e.value);
      }
    });
    test('extracts the first numeric word when firstWordOnly is true', () {
      expect('OTP 12312 27/04/2020'.numericOnly(firstWordOnly: true), '12312');
    });
  });

  group('isPalindrom', () {
    var testcase_after_removeAllSpace = {
      'a man a plan a canal panama': true,
      'This is not a palindrome': false,
      'racecar': true,
      '': true,
    };
    var testcase = {
      'a man a plan a canal panama': false,
      'This is not a palindrome': false,
      'racecar': true,
      '': true,
    };
    test('returns true for palindromic string with spaces', () {
      for (var e in testcase.entries) {
        expect(e.key.isPalindrom(), e.value);
      }
    });
    test('returns true for palindromic string without spaces', () {
      for (var e in testcase_after_removeAllSpace.entries) {
        expect(e.key.isPalindrom(true), e.value);
      }
    });
  });

  group('toEncodedBase64', () {
    test('encodes string to Base64', () {
      expect('hello'.toEncodedBase64, 'aGVsbG8=');
    });

    test('encodes empty string to Base64', () {
      expect(''.toEncodedBase64, '');
    });
  });

  group('toDecodedBase64', () {
    test('decodes Base64 string', () {
      expect('aGVsbG8='.toDecodedBase64, 'hello');
    });

    test('decodes empty Base64 string', () {
      expect(''.toDecodedBase64, '');
    });
  });

  group('utf8Encode', () {
    test('encodes string to UTF-8', () {
      expect('hello'.utf8Encode, [104, 101, 108, 108, 111]);
    });

    test('encodes empty string to UTF-8', () {
      expect(''.utf8Encode, []);
    });
  });
}
