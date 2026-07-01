import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../repositories/auth_repository.dart';
import '../../repositories/firebase/firebase_auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => FirebaseAuthRepository(),
);
