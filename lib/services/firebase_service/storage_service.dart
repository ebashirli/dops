import 'package:cloud_firestore/cloud_firestore.dart';

abstract class StorageService {
  Future<QuerySnapshot> getData();
  Stream<QuerySnapshot> getDataAsStream();
  Future getDocumentById(String id);
  Future<void> removeDocument(String id);
  Future<void> addDocument(Map data);
  Future<void> updateDocument(Map<String, dynamic> data, String id);
}
