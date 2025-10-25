part of 'otp.dart';

final class Hotp extends Otp {
  Hotp({
    required super.secret,
    super.length = 6,
    super.algorithm = HashAlgorithm.SHA1,
    required this.counter,
  });
  
  int counter;

  /// Generates an HOTP code for the given [counter].
  String generateCode([int? counter]) => _generateCode(counter ?? this.counter++);

  /// Verifies the given [code] against the expected HOTP code for the given [counter].
  bool verifyCode(String code, {int? counter}) => _verifyCode(code, counter ?? this.counter++);
}
