import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dops/constants/lists.dart';
import 'package:dops/services/firebase_service/firebase-database-service.dart';
import '../models/lists_model.dart';
import 'package:get/get.dart';

class ListsRepository {
  final _api = Get.find<StorageService>(tag: 'lists');

  Future<ListsModel> getModel() async {
    QuerySnapshot result = await _api.getData();
    ListsModel model =
        ListsModel.fromMap(result.docs.first.data() as Map<String, dynamic>);
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

  Future<void> updateListModel(ListsModel data) async {
    await _api.updateDocument(data.toMap(), data.id);
  }

  void chunckUpload() {
    dropDownMenuLists.forEach((key, value) {
      _api.updateDocument({key: value}, 'list');
    });
  }
}
