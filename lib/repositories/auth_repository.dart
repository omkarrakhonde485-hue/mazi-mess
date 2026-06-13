import '../models/user_model.dart';

abstract class AuthRepository {
  Future<User?> getCurrentUser();

  Future<void> logout();
}
