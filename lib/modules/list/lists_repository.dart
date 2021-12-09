import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dops/services/firebase_service/firebase_storage_service.dart';
import 'lists_model.dart';
import 'package:get/get.dart';

class ListsRepository {
  final _api = Get.find<StorageService>(tag: 'lists');

  Future<ListsModel> getModel() async {
    QuerySnapshot result = await _api.getData();
    ListsModel model = ListsModel.fromMap(result.docs.first.data() as Map<String, dynamic>);
    return model;
  }

  Stream<ListsModel> getModelAsStream() {
    return _api.getDataAsStream().map(
      (QuerySnapshot query) {
        late ListsModel returnValue;

        query.docs.forEach(
          (snapshot) {
            returnValue = ListsModel.fromMap(
              snapshot.data() as Map<String, dynamic>,
            );
          },
        );

        return returnValue;
      },
    );
  }

  Future<void> updateDropdownSourcesModel(ListsModel data) async {
    await _api.updateDocument(data.toMap(), data.id);
  }

  // addDropdownSourcesModel(DropdownSourcesModel data) async {
  //   await _api.addDocument(data.toMap());
  // }
}
