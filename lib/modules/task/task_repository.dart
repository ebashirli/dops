import 'package:cloud_firestore/cloud_firestore.dart';
import 'task_model.dart';
import '../../services/firebase_service/storage_service.dart';
import 'package:get/get.dart';

class TaskRepository {
  final _api = Get.find<StorageService>(tag: 'tasks');
  late List<TaskModel> tasks = [];

  Future fetchTaskModels() async {
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

  Stream<List<TaskModel>> getAllTasksAsStream() {
    return _api.getShowingDataAsStream().map((QuerySnapshot query) {
      List<TaskModel> returnValue = [];
      query.docs.forEach(
        (snapshot) {
          returnValue.add(
            TaskModel.fromMap(
              snapshot.data() as Map<String, dynamic>,
              snapshot.id,
            ),
          );
        },
      );
      return returnValue;
    });
  }

  Future<TaskModel> getTaskModelById(String id) async {
    var doc = await _api.getDocumentById(id);
    return TaskModel.fromMap(
      doc.data(),
      doc.id,
    );
  }

  removeTaskModel(TaskModel data) async {
    data.isHidden = true;
    await _api.updateDocument(data.toMap(), data.id!);
  }

  updateTaskModel(TaskModel data) async {
    await _api.updateDocument(data.toMap(), data.id!);
  }

  addTaskModel(TaskModel data) async {
    await _api.addDocument(data.toMap());
  }
}
