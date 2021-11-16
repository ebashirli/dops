import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dops/modules/reference_document/reference_document_model.dart';
import 'package:dops/services/firebase_service/storage_service.dart';
import 'package:get/get.dart';

class ReferenceDocumentRepository {
  final _api = Get.find<StorageService>(tag: 'reference_documents');
  late List<ReferenceDocumentModel> referenceDocuments = [];

  Future fetchReferenceDocumentModels() async {
    QuerySnapshot result = await _api.getData();
    referenceDocuments = result.docs
        .map(
          (snapshot) => ReferenceDocumentModel.fromMap(
            snapshot.data() as Map<String, dynamic>,
            snapshot.id,
          ),
        )
        .toList();
    return referenceDocuments;
  }

  Stream<List<ReferenceDocumentModel>> getAllReferenceDocumentsAsStream() {
    return _api.getShowingDataAsStream().map((QuerySnapshot query) {
      List<ReferenceDocumentModel> returnValue = [];
      query.docs.forEach(
        (snapshot) {
          returnValue.add(
            ReferenceDocumentModel.fromMap(
              snapshot.data() as Map<String, dynamic>,
              snapshot.id,
            ),
          );
        },
      );
      return returnValue;
    });
  }

  Future<ReferenceDocumentModel> getReferenceDocumentModelById(
      String id) async {
    var doc = await _api.getDocumentById(id);
    return ReferenceDocumentModel.fromMap(
      doc.data(),
      doc.id,
    );
  }

  removeReferenceDocumentModel(ReferenceDocumentModel data) async {
    data.isHidden = true;
    await _api.updateDocument(data.toMap(), data.id!);
  }

  updateReferenceDocumentModel(ReferenceDocumentModel data) async {
    await _api.updateDocument(data.toMap(), data.id!);
  }

  addReferenceDocumentModel(ReferenceDocumentModel data) async {
    await _api.addDocument(data.toMap());
  }

  incrementNumberOfAssignedDocumentField(List<String> designDrawing) async {
    await _api.incrementFiledValue('document_number', designDrawing);
  }
}
