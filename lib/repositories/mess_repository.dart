import '../models/mess_model.dart';
import '../models/plan_model.dart';

abstract class MessRepository {
  Future<List<Mess>> getMesses();

  Future<Mess?> getMessById(String messId);

  Future<List<Plan>> getPlansByMessId(String messId);
}
