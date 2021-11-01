import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dops/services/storage_service.dart';

class FirebaseStorageService extends StorageService {
  FirebaseStorageService(this.collectionName);

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final String collectionName;
  late CollectionReference collectionReference =
      firebaseFirestore.collection(collectionName);

  @override
  Future<void> deleteById(String docId) {
    return collectionReference
        .doc(docId)
        .delete()
        .whenComplete(() => 'Done')
        .catchError((error) => error.toString());
  }

  @override
  Stream<List<Map<String, dynamic>>> getAll() =>
      collectionReference.snapshots().map((query) => query.docs
          .map((item) => item.data() as Map<String, dynamic>)
          .toList());

  @override
  Future<int> insert(model) {
    // TODO: implement insert
    throw UnimplementedError();
  }

  @override
  Future<void> update(model) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
