part of 'otp.dart';

final class TOTP extends Otp {
  final int period; // default: 30 seconds
  final int startTime; // epoch base
  TOTP({
    required super.secret,
    super.length = 6,
    super.algorithm = HashAlgorithm.SHA1,
    this.period = 30,
    this.startTime = 0,
  });

  // To keep track of the last used timestep, might be useful for some applications
  int _lastUsedTime = -1;

  /// Generate OTP for current time or given timestamp
  String generateCode([int? timestamp]) {
    final currentTime = timestamp != null && timestamp > 10000000000
        ? timestamp ~/ 1000 // convert ms to sec if needed
        : (timestamp ?? DateTime.now().millisecondsSinceEpoch ~/ 1000);
    _lastUsedTime = ((currentTime - startTime) ~/ period);
    return _generateCode(_lastUsedTime);
  }

  /// Verify OTP against current time (± allowed drift)
  /// [drift] is the number of time steps to check before and after the current time step.
  /// For example, an allowedDrift of 1 will check the previous, current, and next time steps.
  bool verifyCode(String code, {int drift = 1, int? timestamp}) {
    final now = timestamp ?? DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final timeStep = ((now - startTime) ~/ period);
    for (int i = -drift; i <= drift; i++) {
      if (_verifyCode(code, timeStep + i)) return true;
    }
    return false;
  }

  /// There is a method that will tell you how much time remains in the current time step window in seconds.
  int remainingSeconds() {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final secondsElapsedInCurrentPeriod = (now - startTime) % period;
    return period - secondsElapsedInCurrentPeriod;
  }

  /// Generates a standard otpauth:// URI for TOTP (Time-based) secrets.
  ///
  /// This URI can be used to generate a QR code for easy enrollment in
  /// authenticator apps like Google Authenticator, Authy, or 1Password.
  /// The URI follows the Key Uri Format specified by Google:
  /// https://github.com/google/google-authenticator/wiki/Key-Uri-Format
  ///
  /// [accountName] - The name of the account (e.g., user@example.com)
  /// [issuer] - Optional issuer name (e.g., "MyApp" or "Company Name")
  ///
  /// Returns a URI string in the format:
  /// `otpauth://totp/[issuer:]accountName?secret=SECRET&issuer=ISSUER&algorithm=ALGO&digits=N&period=P`
  ///
  /// Example:
  /// ```dart
  /// final totp = TOTP(secret: 'JBSWY3DPEHPK3PXP');
  /// final uri = totp.generateURI('user@example.com', issuer: 'MyApp');
  /// // otpauth://totp/MyApp:user@example.com?secret=JBSWY3DPEHPK3PXP&issuer=MyApp&algorithm=SHA1&digits=6&period=30
  /// ```
  String generateURI(String accountName, {String? issuer}) {
    final buffer = StringBuffer('otpauth://totp/');

    // Add label (issuer:accountName or just accountName)
    if (issuer != null && issuer.isNotEmpty) {
      buffer
        ..write(Uri.encodeComponent(issuer))
        ..write(':');
    }

    buffer
      ..write(Uri.encodeComponent(accountName))
      ..write('?secret=')
      ..write(Uri.encodeComponent(secret.toUpperCase()));

    if (issuer != null && issuer.isNotEmpty) {
      buffer
        ..write('&issuer=')
        ..write(Uri.encodeComponent(issuer));
    }

    if (algorithm != HashAlgorithm.SHA1) {
      buffer
        ..write('&algorithm=')
        ..write(algorithm.name);
    }
    if (length != 6) {
      buffer
        ..write('&digits=')
        ..write(length);
    }

    if (period != 30) {
      buffer
        ..write('&period=')
        ..write(period);
    }

    return buffer.toString();
  }
}
