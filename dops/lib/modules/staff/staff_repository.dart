import 'package:cloud_firestore/cloud_firestore.dart';
import 'staff_model.dart';
import '../../services/firebase_service/storage_service.dart';
import 'package:get/get.dart';

class StaffRepository {
  final _api = Get.find<StorageService>(tag: 'staff');
  late List<StaffModel> staff = [];

  Future fetchModels() async {
    QuerySnapshot result = await _api.getData();
    staff = result.docs
        .map(
          (snapshot) => StaffModel.fromMap(
            snapshot.data() as Map<String, dynamic>,
            snapshot.id,
          ),
        )
        .toList();
    return staff;
  }

  Stream<List<StaffModel>> getAllDocumentsAsStream() {
    return _api.getShowingDataAsStream().map((QuerySnapshot query) {
      List<StaffModel> returnValue = [];
      query.docs.forEach(
        (snapshot) {
          returnValue.add(
            StaffModel.fromMap(
              snapshot.data() as Map<String, dynamic>,
              snapshot.id,
            ),
          );
        },
      );
      return returnValue;
    });
  }

  Future<StaffModel> getModelById(String id) async {
    var doc = await _api.getDocumentById(id);
    return StaffModel.fromMap(
      doc.data(),
      doc.id,
    );
  }

  removeModel(String id) async {
    await _api.updateDocument({'isHidden': true}, id);
  }

  updateModel(StaffModel data, String id) async {
    await _api.updateDocument(data.toMap(), id);
  }

  addModel(StaffModel data) async {
    await _api.addDocument(data.toMap());
  }
}