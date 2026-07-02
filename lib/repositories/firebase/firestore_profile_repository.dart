import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/app_user.dart';
import '../profile_repository.dart';

class FirestoreProfileRepository implements ProfileRepository {
  final FirebaseFirestore _firestore;

  FirestoreProfileRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<AppUser?> getProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    final data = doc.data();
    if (data == null) return null;

    return AppUser(
      userId: data['userId'] as String? ?? uid,
      fullName: data['fullName'] as String? ?? '',
      phoneNumber: data['phoneNumber'] as String? ?? '',
      email: data['email'] as String? ?? '',
      address: data['address'] as String? ?? '',
      profilePhotoUrl: data['profilePhotoUrl'] as String?,
      language: _parseLanguage(data['language'] as String?),
      theme: _parseThemePreference(data['theme'] as String?),
    );
  }

  @override
  Future<void> createProfile(AppUser profile) async {
    await _firestore
        .collection('users')
        .doc(profile.userId)
        .set(_toMap(profile));
  }

  @override
  Future<void> updateProfile(AppUser profile) async {
    await _firestore
        .collection('users')
        .doc(profile.userId)
        .update(_toMap(profile));
  }

  @override
  Future<void> deleteProfile(String uid) async {
    await _firestore.collection('users').doc(uid).delete();
  }

  Map<String, dynamic> _toMap(AppUser profile) {
    return {
      'userId': profile.userId,
      'fullName': profile.fullName,
      'phoneNumber': profile.phoneNumber,
      'email': profile.email,
      'address': profile.address,
      'profilePhotoUrl': profile.profilePhotoUrl,
      'language': profile.language.name,
      'theme': profile.theme.name,
    };
  }

  AppLanguage _parseLanguage(String? value) {
    if (value == null) return AppLanguage.en;
    return AppLanguage.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AppLanguage.en,
    );
  }

  AppThemePreference _parseThemePreference(String? value) {
    if (value == null) return AppThemePreference.system;
    return AppThemePreference.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AppThemePreference.system,
    );
  }
}
