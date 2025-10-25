import 'dart:math';
import 'dart:typed_data';
import 'package:base32/base32.dart';
import 'package:crypto/crypto.dart';
import 'hash_algorithm.dart';

part "hotp.dart";
part "totp.dart";

abstract class Otp {
  final String secret;
  final int length;
  final HashAlgorithm algorithm;
  const Otp(
      {required this.secret, required this.length, required this.algorithm})
      : assert(length > 0 && length <= 10,
            'OTP length must be between 1 and 10 digits');

  bool _verifyCode(String otp, int testCounter) {
    final expected = _generateCode(testCounter);

    if (otp.length != expected.length) return false;

    var result = true;
    for (var i = 0; i < otp.length; i++) {
      result = (otp[i] == expected[i]) && result;
    }
    return result;
  }

  String _generateCode(int counter) {
    final hmac = Hmac(algorithm.getHash(), base32.decode(secret.toUpperCase()));
    final digest = hmac.convert(_int2bytes(counter)).bytes;

    final offset = digest[digest.length - 1] & 0x0f;

    final binary = ((digest[offset] & 0x7f) << 24) |
        ((digest[offset + 1] & 0xff) << 16) |
        ((digest[offset + 2] & 0xff) << 8) |
        (digest[offset + 3] & 0xff);

    final code = binary % pow(10, length) as int;

    return code.toString().padLeft(length, '0');
  }

  static Uint8List _int2bytes(int long) {
    // we want to represent the input as a 8-bytes array
    final byteArray = Uint8List(8);

    for (var index = byteArray.length - 1; index >= 0; index--) {
      final byte = long & 0xff;
      byteArray[index] = byte;
      long = (long - byte) ~/ 256;
    }
    return byteArray;

    // Cleaner implementation but breaks in dart2js/flutter web
    // return Uint8List(8)..buffer.asByteData().setInt64(0, long);
  }
}
