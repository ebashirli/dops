import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dops/modules/stages/stages_model.dart';
import 'package:dops/services/firebase_service/firebase_storage_service.dart';
import 'package:get/get.dart';

class StageRepository {
  final _api = Get.find<StorageService>(tag: 'stages');
  late List<StageModel> stages = [];

  Future fetchModels() async {
    QuerySnapshot result = await _api.getData();
    stages = result.docs
        .map(
          (snapshot) => StageModel.fromMap(
            snapshot.data() as Map<String, dynamic>,
            snapshot.id,
          ),
        )
        .toList();
    return stages;
  }

  Stream<List<StageModel>> getAllDocumentsAsStream() {
    return _api.getShowingDataAsStream().map((QuerySnapshot query) {
      List<StageModel> returnValue = [];
      query.docs.forEach(
        (snapshot) {
          returnValue.add(
            StageModel.fromMap(
              snapshot.data() as Map<String, dynamic>,
              snapshot.id,
            ),
          );
        },
      );
      return returnValue;
    });
  }

  removeModel(String id) async {
    await _api.updateDocument({'isHidden': true}, id);
  }

  updateModel(StageModel data, String id) async {
    await _api.updateDocument(data.toMap(), id);
  }

  updateFields(Map<String, dynamic> map, String id) async {
    await _api.updateDocument(map, id);
  }

  add(StageModel data) async {
    await _api.addDocument(data.toMap());
  }
}
