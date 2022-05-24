import 'package:dops/constants/constant.dart';
import 'package:dops/modules/models/activity_model.dart';
import 'package:dops/modules/models/drawing_model.dart';
import 'package:dops/modules/models/stage_model.dart';
import 'package:dops/modules/models/value_model.dart';
import 'package:collection/collection.dart';

class TaskModel {
  String? id;
  String? parentId;
  String revisionMark;
  List<String?> referenceDocuments;
  int changeNumber;
  String? holdReason;
  String? note;
  DateTime? creationDate;
  bool isHidden;

  TaskModel({
    this.id,
    this.parentId,
    required this.revisionMark,
    required this.referenceDocuments,
    required this.note,
    required this.changeNumber,
    this.holdReason,
    this.creationDate,
    this.isHidden = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'parentId': parentId,
      'revisionMark': revisionMark,
      'referenceDocuments': referenceDocuments,
      'changeNumber': changeNumber,
      'holdReason': holdReason,
      'note': note,
      'creationDate': creationDate,
      'isHidden': isHidden,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map, String? id) {
    return TaskModel(
      id: id ?? null,
      parentId: map['parentId'],
      revisionMark: map['revisionMark'],
      referenceDocuments: List<String>.from(map['referenceDocuments']),
      changeNumber: map['changeNumber'],
      holdReason: map['holdReason'] != null ? map['holdReason'] : null,
      note: map['note'],
      creationDate:
          map['creationDate'] != null ? map['creationDate'].toDate() : null,
      isHidden: map['isHidden'] != null ? map['isHidden'] : null,
    );
  }

  DrawingModel? get drawingModel => drawingController.getById(parentId);
  ActivityModel? get activityModel =>
      activityController.getById(drawingModel?.activityCodeId);

  String get taskNumber {
    return '${drawingModel?.drawingNumber}-${this.revisionMark}';
  }

  List<ValueModel?> get valueModels {
    return valueController.documents
        .where((e) => e?.taskModel?.id == id)
        .toList();
  }

  List<StageModel?> get stageModels =>
      stageController.documents.where((e) => e?.taskModel == this).toList();

  String get revisionType =>
      drawingModel?.taskModels.indexOf(this) == 0 ? "First Issue" : "Revision";

  String get activityStatus => this.holdReason != null
      ? 'Hold'
      : this.id == null
          ? ''
          : stageController.containsHoldFun(this)
              ? 'Contains Hold'
              : 'Live';

  String get totalHoldReason => this.holdReason != null
      ? this.holdReason!
      : valueModels.firstWhereOrNull((e) => e?.hold != null)?.hold ?? '';
}
