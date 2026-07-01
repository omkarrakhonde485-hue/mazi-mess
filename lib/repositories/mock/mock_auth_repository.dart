import '../../core/mock_data/fake_users.dart';
import '../auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  static const _mockDelay = Duration(milliseconds: 300);

  @override
  Future<void> logout() async {
    await Future<void>.delayed(_mockDelay);
  }

  @override
  Stream<String?> authStateChanges() {
    return Stream.value(fakeCurrentUser.userId);
  }

  @override
  Future<void> sendOtp({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(String error) onFailed,
  }) async {
    await Future<void>.delayed(_mockDelay);
    onCodeSent('mock_verification_id');
  }

  @override
  Future<void> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    await Future<void>.delayed(_mockDelay);
  }
}
