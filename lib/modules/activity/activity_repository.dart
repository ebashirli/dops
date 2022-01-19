import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dops/services/firebase_service/firebase_storage_service.dart';
import 'activity_model.dart';
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
    return _api.getDataAsStream().map(
      (QuerySnapshot query) {
        List<ActivityModel> returnValue = [];
        query.docs.forEach(
          (snapshot) {
            final snapshot_data = snapshot.data() as Map<String, dynamic>;
            if (!snapshot_data['isHidden'])
              returnValue
                  .add(ActivityModel.fromMap(snapshot_data, snapshot.id));
          },
        );
        returnValue.sort((a, b) => (a.finishDate)!.compareTo(b.finishDate!));
        returnValue.sort((a, b) => (a.startDate)!.compareTo(b.startDate!));
        return returnValue;
      },
    );
  }

  Future<ActivityModel> getModelById(String id) async {
    var doc = await _api.getDocumentById(id);
    return ActivityModel.fromMap(doc.data(), doc.id);
  }

  removeModel(String id) async {
    await _api.updateDocument({'isHidden': true}, id);
  }

  updateModel(ActivityModel data, String id) async {
    await _api.updateDocument(data.toMap(), id);
  }

  addModel(ActivityModel data) async {
    await _api.addDocument(data.toMap());
  }
}
