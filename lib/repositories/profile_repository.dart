import '../models/app_user.dart';

abstract class ProfileRepository {
  Future<AppUser?> getProfile(String uid);

  Future<void> createProfile(AppUser profile);

  Future<void> updateProfile(AppUser profile);

  Future<void> deleteProfile(String uid);
}
