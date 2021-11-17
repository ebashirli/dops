import 'package:cloud_firestore/cloud_firestore.dart';
import 'stages_model.dart';
import '../../services/firebase_service/storage_service.dart';
import 'package:get/get.dart';

class StagesRepository {
  final _api = Get.find<StorageService>(tag: 'stages');
  late List<StagesModel> stages = [];

  Future fetchStagesModels() async {
    QuerySnapshot result = await _api.getData();
    stages = result.docs
        .map(
          (snapshot) => StagesModel.fromMap(
            snapshot.data() as Map<String, dynamic>,
            snapshot.id,
          ),
        )
        .toList();
    return stages;
  }

  Stream<List<StagesModel>> getAllStagesAsStream() {
    return _api.getShowingDataAsStream().map((QuerySnapshot query) {
      List<StagesModel> returnValue = [];
      query.docs.forEach(
        (snapshot) {
          returnValue.add(
            StagesModel.fromMap(
              snapshot.data() as Map<String, dynamic>,
              snapshot.id,
            ),
          );
        },
      );
      return returnValue;
    });
  }

  Future<StagesModel> getStagesModelById(String id) async {
    var doc = await _api.getDocumentById(id);
    return StagesModel.fromMap(
      doc.data(),
      doc.id,
    );
  }

  removeStagesModel(StagesModel data) async {
    data.isHidden = true;
    await _api.updateDocument(data.toMap(), data.id!);
  }

  updateStagesModel(StagesModel data) async {
    await _api.updateDocument(data.toMap(), data.id!);
  }

  addStagesModel(StagesModel data) async {
    await _api.addDocument(data.toMap());
  }
}
