import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dops/models/staff_list_model.dart';
import 'package:dops/services/firebase_service/storage_service.dart';
import 'package:get/get.dart';

class StaffListRepository {
  final _api = Get.find<StorageService>(tag: 'staff_lists');
  late List<StaffListModel> staffList = [];

  Future fetchStaffListModels() async {
    QuerySnapshot result = await _api.getData();
    staffList = result.docs
        .map(
          (snapshot) => StaffListModel.fromMap(
            snapshot.data() as Map<String, dynamic>,
            snapshot.id,
          ),
        )
        .toList();
    return staffList;
  }

  Stream<List<StaffListModel>> getAllStaffListsAsStream() {
    return _api.getDataAsStream().map((QuerySnapshot query) {
      List<StaffListModel> returnValue = [];
      query.docs.forEach(
        (snapshot) {
          returnValue.add(
            StaffListModel.fromMap(
              snapshot.data() as Map<String, dynamic>,
              snapshot.id,
            ),
          );
        },
      );
      return returnValue;
    });
  }

  Future<StaffListModel> getStaffListModelById(String id) async {
    var doc = await _api.getDocumentById(id);
    return StaffListModel.fromMap(
      doc.data(),
      doc.id,
    );
  }

  removeStaffListModel(String id) async {
    await _api.removeDocument(id);
  }

  updateStaffListModel(StaffListModel data) async {
    await _api.updateDocument(data.toMap(), data.id!);
  }

  addStaffListModel(StaffListModel data) async {
    await _api.addDocument(data.toMap());
  }
}
