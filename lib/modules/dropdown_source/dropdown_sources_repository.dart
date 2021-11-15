import 'package:cloud_firestore/cloud_firestore.dart';
import 'dropdown_sources_model.dart';
import '../../services/firebase_service/storage_service.dart';
import 'package:get/get.dart';

class DropwdownSourcesRepository {
  final _api = Get.find<StorageService>(tag: 'lists');

  Future<DropdownSourcesModel> getModel() async {
    QuerySnapshot result = await _api.getData();
    DropdownSourcesModel model = DropdownSourcesModel.fromMap(
        result.docs.first.data() as Map<String, dynamic>);
    return model;
  }

  Stream<DropdownSourcesModel> getModelAsStream() {
    return _api.getDataAsStream().map(
      (QuerySnapshot query) {
        late DropdownSourcesModel returnValue;
        if (query.docs.first.id.isNotEmpty) {
          query.docs.forEach(
            (snapshot) {
              returnValue = DropdownSourcesModel.fromMap(
                snapshot.data() as Map<String, dynamic>,
              );
            },
          );
        } else {}
        return returnValue;
      },
    );
  }

  updateDropdownSourcesModel(DropdownSourcesModel data) async {
    await _api.updateDocument(data.toMap(), data.id);
  }

  // addDropdownSourcesModel(DropdownSourcesModel data) async {
  //   await _api.addDocument(data.toMap());
  // }
}
