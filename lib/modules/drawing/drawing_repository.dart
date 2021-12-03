import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dops/services/firebase_service/firebase_storage_service.dart';
import 'drawing_model.dart';
import 'package:get/get.dart';

class DrawingRepository {
  final _api = Get.find<StorageService>(tag: 'drawings');
  late List<DrawingModel> drawings = [];

  Future fetchModels() async {
    QuerySnapshot result = await _api.getData();
    drawings = result.docs
        .map(
          (snapshot) => DrawingModel.fromMap(
            snapshot.data() as Map<String, dynamic>,
            snapshot.id,
          ),
        )
        .toList();
    return drawings;
  }

  Stream<List<DrawingModel>> getAllDocumentsAsStream() {
    return _api.getShowingDataAsStream().map((QuerySnapshot query) {
      List<DrawingModel> returnValue = [];
      query.docs.forEach(
        (snapshot) {
          returnValue.add(
            DrawingModel.fromMap(
              snapshot.data() as Map<String, dynamic>,
              snapshot.id,
            ),
          );
        },
      );
      return returnValue;
    });
  }

  Future<DrawingModel> getModelById(String id) async {
    var doc = await _api.getDocumentById(id);
    return DrawingModel.fromMap(
      doc.data(),
      doc.id,
    );
  }

  removeModel(String id) async {
    await _api.updateDocument({'isHidden': true}, id);
  }

  updateModel(DrawingModel data, String id) async {
    await _api.updateDocument(data.toMap(), id);
  }

  addModel(DrawingModel data) async {
    await _api.addDocument(data.toMap());
  }
}
