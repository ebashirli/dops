import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dops/models/activity_model.dart';
import 'package:dops/services/firebase_service/storage_service.dart';
import 'package:get/get.dart';

class ActivityRepository {
  final _api = Get.find<StorageService>(tag: 'activities');
  late List<ActivityModel> activities = [];

  Future fetchActivityModels() async {
    QuerySnapshot result = await _api.getData();
    activities = result.docs.map((snapshot) {
      return ActivityModel.fromMap(
        snapshot.data() as Map<String, dynamic>,
        snapshot.id,
      );
    }).toList();
    return activities;
  }

  Stream<List<ActivityModel>> getAllActivitiesAsStream() {
    return _api.getDataAsStream().map((QuerySnapshot query) {
      List<ActivityModel> returnValue = [];
      query.docs.forEach((snapshot) {
        returnValue.add(ActivityModel.fromMap(
          snapshot.data() as Map<String, dynamic>,
          snapshot.id,
        ));
      });
      return returnValue;
    });
  }

  Future<ActivityModel> getActivityModelById(String id) async {
    var doc = await _api.getDocumentById(id);
    return ActivityModel.fromMap(doc.data(), doc.id);
  }

  removeActivityModel(ActivityModel data) async {
    data.isHidden = true;
    await _api.updateDocument(data.toMap(), data.id!);
    ;
  }

  updateActivityModel(ActivityModel data, String id) async {
    await _api.updateDocument(data.toMap(), id);
  }

  addActivityModel(ActivityModel data) async {
    await _api.addDocument(data.toMap());
  }
}
