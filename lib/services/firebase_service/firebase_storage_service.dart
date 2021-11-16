import 'package:cloud_firestore/cloud_firestore.dart';
import 'storage_service.dart';
import 'package:get/get.dart';

class FirebaseStorageService extends GetxService implements StorageService {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final String path;
  late final CollectionReference ref;
  FirebaseStorageService(this.path) {
    ref = firebaseFirestore.collection(path);
  }

  Future<QuerySnapshot> getData() {
    return ref.get();
  }

  Stream<QuerySnapshot> getShowingDataAsStream() {
    return ref.where("isHidden", isEqualTo: false).snapshots();
  }
  Stream<QuerySnapshot> getDataAsStream() {
    return ref.snapshots();
  }

  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.doc(id).get();
  }

  Future<void> removeDocument(String id) {
    return ref.doc(id).delete();
  }

  Future<DocumentReference> addDocument(Map data) {
    return ref.add(data);
  }

  Future<void> updateDocument(Map<String, dynamic> data, String id) {
    return ref.doc(id).update(data);
  }

  Future<void> incrementFiledValue(String field, List<String> lst) async {
    QuerySnapshot querySnapshotList =
        await ref.where(field, whereIn: lst).get();

    List<String> ids =
        querySnapshotList.docs.map((snapshot) => snapshot.id).toList();

    ids.forEach((id) {
      ref.doc(id).update({
        "assigned_documents_count": FieldValue.increment(1),
      });
    });
  }
}
