import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_repository_provider.dart';

final authStateProvider = StreamProvider<String?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});
