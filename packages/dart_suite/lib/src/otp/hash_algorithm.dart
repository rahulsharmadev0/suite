// ignore_for_file: constant_identifier_names
import 'package:crypto/crypto.dart';

enum HashAlgorithm {
  /// Use SHA1
  SHA1,
  /// Use SHA256
  SHA256,

  /// Use SHA512
  SHA512;

  Hash getHash() => switch (this) {
        SHA1 => sha1,
        SHA256 => sha256,
        SHA512 => sha512,
      };
  
  int hashLength() => switch (this) {
        SHA1 => 20,
        SHA256 => 32,
        SHA512 => 64,
      };
}
