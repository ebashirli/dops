import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class FirebaseStorageService extends GetxService implements StorageService {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  final String path;
  late final CollectionReference ref;
  FirebaseStorageService(this.path) {
    ref = firebaseFirestore.collection(path);
  }

  @override
  Future<QuerySnapshot> getData() {
    return ref.get();
  }

  @override
  Stream<QuerySnapshot> getDataAsStream() {
    return ref.snapshots();
  }

  @override
  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.doc(id).get();
  }

  @override
  Future<void> removeDocument(String id) {
    return ref.doc(id).delete();
  }

  @override
  Future<DocumentReference> addDocument(Map data) async {
    return await ref.add(data);
  }

  @override
  Future<void> updateDocument(Map<String, dynamic> data, String id) {
    return ref.doc(id).update(data);
  }

  @override
  Future<void> addDocumentWithId(Map data, String docId) {
    return ref.doc(docId).set(data);
  }
}

abstract class StorageService {
  Future<QuerySnapshot> getData();
  Stream<QuerySnapshot> getDataAsStream();
  Future getDocumentById(String id);
  Future<void> removeDocument(String id);
  Future<dynamic> addDocument(Map data);
  Future<void> addDocumentWithId(Map data, String docId);
  Future<void> updateDocument(Map<String, dynamic> data, String id);
}
