import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dops/models/staff_model.dart';
import 'package:dops/services/firebase_service/storage_service.dart';
import 'package:get/get.dart';

class StaffRepository {
  final _api = Get.find<StorageService>(tag: 'employees');
  late List<StaffModel> employees = [];

  Future fetchStaffModels() async {
    QuerySnapshot result = await _api.getData();
    employees = result.docs
        .map(
          (snapshot) => StaffModel.fromMap(
            snapshot.data() as Map<String, dynamic>,
            snapshot.id,
          ),
        )
        .toList();
    return employees;
  }

  Stream<List<StaffModel>> getAllEmployeesAsStream() {
    return _api.getDataAsStream().map((QuerySnapshot query) {
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

  Future<StaffModel> getStaffModelById(String id) async {
    var doc = await _api.getDocumentById(id);
    return StaffModel.fromMap(
      doc.data(),
      doc.id,
    );
  }

  removeStaffModel(StaffModel data) async {
    data.isHidden = true;
    await _api.updateDocument(data.toMap(), data.id!);
  }

  updateStaffModel(StaffModel data) async {
    await _api.updateDocument(data.toMap(), data.id!);
  }

  addStaffModel(StaffModel data) async {
    await _api.addDocument(data.toMap());
  }
}
