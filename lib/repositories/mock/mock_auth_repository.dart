import '../../core/mock_data/fake_users.dart';
import '../../models/user_model.dart';
import '../auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  static const _mockDelay = Duration(milliseconds: 300);

  @override
  Future<User?> getCurrentUser() async {
    await Future<void>.delayed(_mockDelay);
    return fakeCurrentUser;
  }

  @override
  Future<void> logout() async {
    await Future<void>.delayed(_mockDelay);
  }
}
