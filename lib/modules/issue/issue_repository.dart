import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dops/modules/issue/issue_model.dart';
import 'package:dops/services/firebase_service/firebase_storage_service.dart';
import 'package:get/get.dart';

class IssueRepository {
  final _api = Get.find<StorageService>(tag: 'issue');
  late List<IssueModel> referenceDocuments = [];

  Future fetchModels() async {
    QuerySnapshot result = await _api.getData();
    referenceDocuments = result.docs
        .map(
          (snapshot) => IssueModel.fromMap(
            snapshot.data() as Map<String, dynamic>,
            snapshot.id,
          ),
        )
        .toList();
    return referenceDocuments;
  }

  Stream<List<IssueModel>> getAllDocumentsAsStream() {
    return _api.getDataAsStream().map((QuerySnapshot query) {
      List<IssueModel> returnValue = [];
      query.docs.forEach(
        (snapshot) {
          final snapshot_data = snapshot.data() as Map<String, dynamic>;
          if (!snapshot_data['isHidden'])
            returnValue.add(IssueModel.fromMap(snapshot_data, snapshot.id));
        },
      );
      return returnValue;
    });
  }

  Future<IssueModel> getModelById(String id) async {
    var doc = await _api.getDocumentById(id);
    return IssueModel.fromMap(
      doc.data(),
      doc.id,
    );
  }

  removeModel(String id) async =>
      await _api.updateDocument({'isHidden': true}, id);

  updateModel(Map<String, dynamic> map, String id) async =>
      await _api.updateDocument(map, id);

  addModel(IssueModel data) async => await _api.addDocument(data.toMap());

  add(IssueModel data) async => await _api.addDocument(data.toMap());

  addFields(Map<String, dynamic> map, String id) async =>
      await _api.updateDocument(map, id);
}
