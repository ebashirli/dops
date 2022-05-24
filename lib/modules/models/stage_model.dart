import 'package:dops/constants/constant.dart';
import 'package:dops/modules/models/task_model.dart';
import 'package:dops/modules/models/value_model.dart';

class StageModel {
  String? id;
  String taskId;
  int index;
  int checkerCommentCounter;
  int reviewerCommentCounter;
  bool isHidden;
  DateTime creationDateTime;
  String? note;

  StageModel({
    this.id,
    required this.taskId,
    this.index = 0,
    this.checkerCommentCounter = 0,
    this.reviewerCommentCounter = 0,
    this.isHidden = false,
    required this.creationDateTime,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'taskId': taskId,
      'index': index,
      'checkerCommentCounter': checkerCommentCounter,
      'reviewerCommentCounter': reviewerCommentCounter,
      'creationDateTime': creationDateTime,
      'note': note != null ? note : null,
      'isHidden': isHidden,
    };
  }

  factory StageModel.fromMap(Map<String, dynamic> map, String? id) {
    return StageModel(
      id: id ?? null,
      taskId: map['taskId'],
      index: map['index'],
      checkerCommentCounter: map['checkerCommentCounter'],
      reviewerCommentCounter: map['reviewerCommentCounter'],
      isHidden: map['isHidden'],
      creationDateTime: map['creationDateTime'] != null
          ? map['creationDateTime'].toDate()
          : null,
      note: map['note'] != null ? map['note'] : null,
    );
  }

  TaskModel? get taskModel => taskController.getById(taskId);

  List<ValueModel?> get valueModels =>
      valueController.documents.where((e) => e?.stageId == id).toList();
}
