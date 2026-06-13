import '../../core/mock_data/fake_subscriptions.dart';
import '../../models/subscription_model.dart';
import '../subscription_repository.dart';

class MockSubscriptionRepository implements SubscriptionRepository {
  static const _mockDelay = Duration(milliseconds: 300);

  @override
  Future<List<Subscription>> getSubscriptions() async {
    await Future<void>.delayed(_mockDelay);
    return List<Subscription>.unmodifiable(fakeSubscriptions);
  }
}
