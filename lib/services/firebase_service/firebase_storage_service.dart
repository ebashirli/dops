import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dops/services/firebase_service/storage_service.dart';
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
}
