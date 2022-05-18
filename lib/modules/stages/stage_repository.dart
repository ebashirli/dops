import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dops/modules/stages/stage_model.dart';
import 'package:dops/services/firebase_service/firebase-database-service.dart';
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
    return _api.getDataAsStream().map((QuerySnapshot query) {
      List<StageModel> returnValue = [];
      query.docs.forEach(
        (snapshot) {
          final snapshot_data = snapshot.data() as Map<String, dynamic>;
          if (!snapshot_data['isHidden'])
            returnValue.add(StageModel.fromMap(snapshot_data, snapshot.id));
        },
      );
      return returnValue
        ..sort(
          (a, b) => a.creationDateTime.compareTo(b.creationDateTime),
        );
    });
  }

  removeModel(String id) async {
    await _api.updateDocument({'isHidden': true}, id);
  }

  updateModel(StageModel data, String id) async {
    await _api.updateDocument(data.toMap(), id);
  }

  updateFileds(Map<String, dynamic> map, String id) async {
    await _api.updateDocument(map, id);
  }

  Future<String> add(StageModel data) async {
    return await _api.addDocument(data.toMap()).then((value) => value.id);
  }

  addWithId(StageModel data, String id) async {
    await _api.addDocumentWithId(data.toMap(), id);
  }
}
