import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../repositories/mess_repository.dart';
import '../../repositories/mock/mock_mess_repository.dart';

final messRepositoryProvider = Provider<MessRepository>(
  (ref) => MockMessRepository(),
);
