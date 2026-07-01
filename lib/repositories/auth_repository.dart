abstract class AuthRepository {
  Future<void> logout();

  Stream<String?> authStateChanges();

  Future<void> sendOtp({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(String error) onFailed,
  });

  Future<void> verifyOtp({
    required String verificationId,
    required String smsCode,
  });
}
