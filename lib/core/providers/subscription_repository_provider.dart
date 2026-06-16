import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../repositories/mock/mock_subscription_repository.dart';
import '../../repositories/subscription_repository.dart';

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>(
  (ref) => MockSubscriptionRepository(),
);
