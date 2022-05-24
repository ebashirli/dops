import 'package:dops/constants/constant.dart';
import 'package:dops/modules/models/activity_model.dart';
import 'package:dops/modules/models/task_model.dart';
import 'package:dops/modules/models/value_model.dart';

class DrawingModel {
  String? id;
  String activityCodeId;
  String drawingNumber;
  String drawingTitle;
  String module;
  String level;
  List<String> area;
  List<String?> drawingTag;
  String functionalArea;
  String structureType;
  String note;
  DateTime? drawingCreateDate;
  bool isHidden;

  DrawingModel({
    this.id,
    required this.activityCodeId,
    required this.drawingNumber,
    required this.drawingTitle,
    required this.module,
    required this.level,
    required this.area,
    required this.drawingTag,
    required this.functionalArea,
    required this.structureType,
    required this.note,
    this.drawingCreateDate,
    this.isHidden = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'activityCodeId': activityCodeId,
      'drawingNumber': drawingNumber,
      'drawingTitle': drawingTitle,
      'module': module,
      'level': level,
      'area': area,
      'drawingTag': drawingTag,
      'functionalArea': functionalArea,
      'structureType': structureType,
      'note': note,
      'drawingCreateDate': drawingCreateDate,
      'isHidden': isHidden,
    };
  }

  factory DrawingModel.fromMap(Map<String, dynamic> map, String? id) {
    return DrawingModel(
      id: id ?? null,
      activityCodeId: map['activityCodeId'],
      drawingNumber: map['drawingNumber'],
      drawingTitle: map['drawingTitle'],
      module: map['module'],
      level: map['level'],
      area: List<String>.from(map['area']),
      drawingTag: List<String>.from(map['drawingTag']),
      functionalArea: map['functionalArea'],
      structureType: map['structureType'],
      note: map['note'],
      drawingCreateDate: map['drawingCreateDate'] != null
          ? map['drawingCreateDate'].toDate()
          : null,
      isHidden: map['isHidden'] != null ? map['isHidden'] : null,
    );
  }

  ActivityModel? get activityModel =>
      activityController.getById(activityCodeId);

  List<ValueModel?> get valueModels =>
      valueController.documents.where((e) => e?.drawingModel == this).toList();

  List<TaskModel?> get taskModels =>
      taskController.documents.where((e) => e?.drawingModel == this).toList();

  int get teklaPhase => valueModels.first?.phase ?? 0;
}
