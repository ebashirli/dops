import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dops/services/firebase_service/firebase-database-service.dart';
import '../models/staff_model.dart';
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
    return _api.getDataAsStream().map((QuerySnapshot query) {
      List<StaffModel> returnValue = [];
      query.docs.forEach(
        (snapshot) {
          final snapshot_data = snapshot.data() as Map<String, dynamic>;
          if (!snapshot_data['isHidden'])
            returnValue.add(StaffModel.fromMap(snapshot_data, snapshot.id));
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

  addWithId(StaffModel data, String docId) async {
    await _api.addDocumentWithId(data.toMap(), docId);
  }
}
