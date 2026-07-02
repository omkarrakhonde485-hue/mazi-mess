import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../repositories/profile_repository.dart';
import '../../repositories/firebase/firestore_profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return FirestoreProfileRepository();
});
