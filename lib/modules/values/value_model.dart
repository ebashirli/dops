import 'package:dops/constants/constant.dart';
import 'package:dops/modules/activity/activity_model.dart';
import 'package:dops/modules/drawing/drawing_model.dart';
import 'package:dops/modules/stages/stage_model.dart';
import 'package:dops/modules/task/task_model.dart';

class ValueModel {
  String? id;
  String stageId;
  String? employeeId;
  String assignedBy;
  DateTime assignedDateTime;
  String? unassignedBy;
  DateTime? unassignedDateTime;
  DateTime? submitDateTime;
  int? phase;
  int? weight;
  int? gas;
  int? sfd;
  int? dtl;
  String? hold;
  String? transmittal;
  String? note;
  bool isCommented;
  bool isHidden;
  List<String?>? fileNames;
  // filing files
  List<String?>? gaddwg;
  List<String?>? gadpdf;
  List<String?>? addwg;
  List<String?>? adpdf;
  List<String?>? spddwg;
  List<String?>? spdpdf;
  List<String?>? weldReport;
  List<String?>? mtoReport;
  List<String?>? drawingList;
  List<String?>? weldIndex;
  List<String?>? exptdwg;
  List<String?>? exptifc;

  ValueModel({
    this.id,
    required this.stageId,
    required this.employeeId,
    required this.assignedBy,
    required this.assignedDateTime,
    this.unassignedBy,
    this.unassignedDateTime,
    this.submitDateTime,
    this.phase,
    this.weight,
    this.gas,
    this.sfd,
    this.dtl,
    this.hold,
    this.transmittal,
    this.note,
    this.isCommented = false,
    this.isHidden = false,
    this.fileNames,
    this.gaddwg,
    this.gadpdf,
    this.addwg,
    this.adpdf,
    this.spddwg,
    this.spdpdf,
    this.weldReport,
    this.mtoReport,
    this.drawingList,
    this.weldIndex,
    this.exptdwg,
    this.exptifc,
  });

  Map<String, dynamic> toMap() {
    return {
      'stageId': stageId,
      'employeeId': employeeId,
      'assignedBy': assignedBy,
      'assignedDateTime': assignedDateTime,
      'isCommented': isCommented,
      'isHidden': isHidden,
      'submitDateTime': submitDateTime != null ? submitDateTime : null,
      if (hold != null) 'hold': hold != null ? hold : null,
      if (transmittal != null)
        'transmittal': transmittal != null ? transmittal : null,
      if (unassignedBy != null) 'unassignedBy': unassignedBy,
      if (unassignedDateTime != null) 'unassignedDateTime': unassignedDateTime,
      if (phase != null) 'phase': phase,
      if (weight != null) 'weight': weight,
      if (gas != null) 'gas': gas,
      if (sfd != null) 'sfd': sfd,
      if (dtl != null) 'dtl': dtl,
      if (note != null) 'note': note,
      if (fileNames != null) 'fileNames': fileNames,
      // filing files
      if (gaddwg != null) 'gaddwg': gaddwg,
      if (gadpdf != null) 'gadpdf': gadpdf,
      if (addwg != null) 'addwg': addwg,
      if (adpdf != null) 'adpdf': adpdf,
      if (spddwg != null) 'spddwg': spddwg,
      if (spdpdf != null) 'spdpdf': spdpdf,
      if (weldReport != null) 'weldReport': weldReport,
      if (mtoReport != null) 'mtoReport': mtoReport,
      if (drawingList != null) 'drawingList': drawingList,
      if (weldIndex != null) 'weldIndex': weldIndex,
      if (exptdwg != null) 'exptdwg': exptdwg,
      if (exptifc != null) 'exptifc': exptifc,
    };
  }

  factory ValueModel.fromMap(Map<String, dynamic> map, String? id) {
    return ValueModel(
      id: id ?? null,
      stageId: map['stageId'],
      employeeId: map['employeeId'],
      assignedBy: map['assignedBy'],
      assignedDateTime: map['assignedDateTime'] != null
          ? map['assignedDateTime'].toDate()
          : null,
      unassignedBy: map['unassignedBy'],
      unassignedDateTime: map['unassignedDateTime'] != null
          ? map['assignedDateTime'].toDate()
          : null,
      submitDateTime:
          map['submitDateTime'] != null ? map['submitDateTime'].toDate() : null,
      hold: map['hold'] != null ? map['hold'] : null,
      transmittal: map['transmittal'] != null ? map['transmittal'] : null,
      phase: map['phase'] != null ? map['phase'] : null,
      weight: map['weight'] != null ? map['weight'] : null,
      gas: map['gas'] != null ? map['gas'] : null,
      sfd: map['sfd'] != null ? map['sfd'] : null,
      dtl: map['dtl'] != null ? map['dtl'] : null,
      note: map['note'] != null ? map['note'] : null,
      fileNames:
          map['fileNames'] != null ? List<String>.from(map['fileNames']) : null,
      isCommented: map['isCommented'],
      isHidden: map['isHidden'],
      // filing files
      gaddwg: map['gaddwg'] != null ? List<String>.from(map['gaddwg']) : null,
      gadpdf: map['gadpdf'] != null ? List<String>.from(map['gadpdf']) : null,
      addwg: map['addwg'] != null ? List<String>.from(map['addwg']) : null,
      adpdf: map['adpdf'] != null ? List<String>.from(map['adpdf']) : null,
      spddwg: map['spddwg'] != null ? List<String>.from(map['spddwg']) : null,
      spdpdf: map['spdpdf'] != null ? List<String>.from(map['spdpdf']) : null,
      weldReport: map['weldReport'] != null
          ? List<String>.from(map['weldReport'])
          : null,
      mtoReport:
          map['mtoReport'] != null ? List<String>.from(map['mtoReport']) : null,
      drawingList: map['drawingList'] != null
          ? List<String>.from(map['drawingList'])
          : null,
      weldIndex:
          map['weldIndex'] != null ? List<String>.from(map['weldIndex']) : null,
      exptdwg:
          map['exptdwg'] != null ? List<String>.from(map['exptdwg']) : null,
      exptifc:
          map['exptifc'] != null ? List<String>.from(map['exptifc']) : null,
    );
  }

  StageModel? get stageModel => stageController.getById(stageId);
  TaskModel? get taskModel =>
      stageModel == null ? null : taskController.getById(stageModel?.taskId);

  DrawingModel? get drawingModel => taskModel == null
      ? null
      : drawingController.getById(taskModel?.parentId!);
  ActivityModel? get activityModel =>
      activityController.getById(drawingModel?.activityCodeId);
}
