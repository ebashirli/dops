import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dops/modules/models/value_model.dart';
import 'package:dops/services/firebase_service/firebase-database-service.dart';
import 'package:get/get.dart';

class ValueRepository {
  final _api = Get.find<StorageService>(tag: 'values');
  late List<ValueModel> values = [];

  Future fetchModels() async {
    QuerySnapshot result = await _api.getData();
    values = result.docs
        .map(
          (snapshot) => ValueModel.fromMap(
            snapshot.data() as Map<String, dynamic>,
            snapshot.id,
          ),
        )
        .toList();
    return values;
  }

  Stream<List<ValueModel>> getAllDocumentsAsStream() {
    return _api.getDataAsStream().map((QuerySnapshot query) {
      List<ValueModel> returnValue = [];
      query.docs.forEach(
        (snapshot) {
          if (!(snapshot.data() as Map<String, dynamic>)['isHidden'])
            returnValue.add(
              ValueModel.fromMap(
                snapshot.data() as Map<String, dynamic>,
                snapshot.id,
              ),
            );
        },
      );
      return returnValue;
    });
  }

  removeModel(String id) async {
    await _api.updateDocument({'isHidden': true}, id);
  }

  updateModel(ValueModel data, String id) async {
    await _api.updateDocument(data.toMap(), id);
  }

  Future<String> add(ValueModel model) async {
    return await _api.addDocument(model.toMap()).then((value) => value.id);
  }

  Future updateFileds(Map<String, dynamic> map, String id) async {
    return await _api.updateDocument(map, id);
  }
}
