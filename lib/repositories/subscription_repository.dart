import '../models/subscription_model.dart';

abstract class SubscriptionRepository {
  Future<List<Subscription>> getSubscriptions();
}
