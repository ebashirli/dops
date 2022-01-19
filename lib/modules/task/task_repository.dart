import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dops/services/firebase_service/firebase_storage_service.dart';
import 'task_model.dart';
import 'package:get/get.dart';

class TaskRepository {
  final _api = Get.find<StorageService>(tag: 'tasks');
  late List<TaskModel> tasks = [];

  Future fetchModels() async {
    QuerySnapshot result = await _api.getData();
    tasks = result.docs
        .map(
          (snapshot) => TaskModel.fromMap(
            snapshot.data() as Map<String, dynamic>,
            snapshot.id,
          ),
        )
        .toList();
    return tasks;
  }

  Stream<List<TaskModel>> getAllDocumentsAsStream() {
    return _api.getDataAsStream().map((QuerySnapshot query) {
      List<TaskModel> returnValue = [];
      query.docs.forEach(
        (snapshot) {
          final snapshot_data = snapshot.data() as Map<String, dynamic>;
          if (!snapshot_data['isHidden'])
            returnValue.add(TaskModel.fromMap(snapshot_data, snapshot.id));
        },
      );
      return returnValue;
    });
  }

  removeModel(String id) async {
    await _api.updateDocument({'isHidden': true}, id);
  }

  updateModel(TaskModel data, String id) async {
    await _api.updateDocument(data.toMap(), id);
  }

  updateFields(Map<String, dynamic> map, String id) async {
    await _api.updateDocument(map, id);
  }

  Future<String> add(TaskModel data) async {
    return await _api.addDocument(data.toMap()).then((value) => value.id);
  }
}
