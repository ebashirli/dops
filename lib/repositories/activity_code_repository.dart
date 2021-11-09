import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dops/models/activity_codes_model.dart';
import 'package:dops/services/firebase_service/storage_service.dart';
import 'package:get/get.dart';

class ActivityCodeRepository {
  final _api = Get.find<StorageService>(tag: 'activity_codes');
  late List<ActivityCodeModel> activityCodes = [];

  Future fetchActivityCodeModels() async {
    QuerySnapshot result = await _api.getData();
    activityCodes = result.docs.map((snapshot) {
      return ActivityCodeModel.fromMap(
        snapshot.data() as Map<String, dynamic>,
        snapshot.id,
      );
    }).toList();
    return activityCodes;
  }

  Stream<List<ActivityCodeModel>> getAllActivityCodesAsStream() {
    return _api.getDataAsStream().map((QuerySnapshot query) {
      List<ActivityCodeModel> returnValue = [];
      query.docs.forEach((snapshot) {
        returnValue.add(ActivityCodeModel.fromMap(
          snapshot.data() as Map<String, dynamic>,
          snapshot.id,
        ));
      });
      return returnValue;
    });
  }

  Future<ActivityCodeModel> getActivityCodeModelById(String id) async {
    var doc = await _api.getDocumentById(id);
    return ActivityCodeModel.fromMap(doc.data(), doc.id);
  }

  removeActivityCodeModel(String id) async {
    await _api.removeDocument(id);
  }

  updateActivityCodeModel(ActivityCodeModel data, String id) async {
    await _api.updateDocument(data.toMap(), id);
  }

  addActivityCodeModel(ActivityCodeModel data) async {
    await _api.addDocument(data.toMap());
  }
}
