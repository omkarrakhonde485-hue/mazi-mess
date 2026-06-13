import '../../core/mock_data/fake_messes.dart';
import '../../core/mock_data/fake_plans.dart';
import '../../models/mess_model.dart';
import '../../models/plan_model.dart';
import '../mess_repository.dart';

class MockMessRepository implements MessRepository {
  static const _mockDelay = Duration(milliseconds: 300);

  @override
  Future<List<Mess>> getMesses() async {
    await Future<void>.delayed(_mockDelay);
    return List<Mess>.unmodifiable(fakeMesses);
  }

  @override
  Future<Mess?> getMessById(String messId) async {
    await Future<void>.delayed(_mockDelay);
    for (final mess in fakeMesses) {
      if (mess.messId == messId) {
        return mess;
      }
    }
    return null;
  }

  @override
  Future<List<Plan>> getPlansByMessId(String messId) async {
    await Future<void>.delayed(_mockDelay);
    return fakePlans
        .where((plan) => plan.messId == messId && plan.isActive)
        .toList(growable: false);
  }
}
