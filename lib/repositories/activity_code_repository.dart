import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dops/models/activity_codes_model.dart';
import 'package:dops/services/firebase_service/firebase_storage_service.dart';
import 'package:get/get.dart';

class ActivityCodeRepository {
  final _api = Get.find<FirebaseStorageService>(tag: 'activity_code');
  List<ActivityCodeModel> activitycodes = [];

  Future<List<ActivityCodeModel>> fetchActivityCodeModels() async {
    QuerySnapshot result = await _api.getData();
    activitycodes = result.docs
        .map((activityCode) => ActivityCodeModel.fromMap(activityCode.data() as Map<String, dynamic>, activityCode.id))
        .toList();
    return activitycodes;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchActivityCodeModelsAsStream() {
    return _api.getDataAsStream() as Stream<QuerySnapshot<Map<String, dynamic>>>;
  }

  Future<ActivityCodeModel> getActivityCodeModelById(String id) async {
    var doc = await _api.getDocumentById(id);
    return ActivityCodeModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

  Future removeActivityCodeModel(String id) async {
    await _api.removeDocument(id);
    return;
  }

  Future updateActivityCodeModel(ActivityCodeModel data, String id) async {
    await _api.updateDocument(data.toMap(), id);
    return;
  }

  Future addActivityCodeModel(ActivityCodeModel data) async {
    await _api.addDocument(data.toMap());
    return;
  }
}
