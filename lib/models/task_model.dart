class TaskModel {
  String? id;
  final String activityCode;
  final List<String> area;
  final int? changeNumber;
  final String coverSheetRevision;
  final List<String> designDrawing;
  final String drawingNumber;
  final String drawingTitle;
  final String functionalArea;
  final bool? isRevised;
  final String level;
  final String moduleName;
  final String note;
  final double? percentage;
  final int? priority;
  final String project;
  final bool? isRevisionStatusLatest;
  final int? revisionNumber;
  final String structureType;
  final DateTime? taskCreateDate;
  final String? taskNumber;
  final bool? isHidden;

  TaskModel({
    this.id,
    required this.activityCode,
    required this.area,
    this.changeNumber,
    required this.coverSheetRevision,
    required this.designDrawing,
    required this.drawingNumber,
    required this.drawingTitle,
    required this.functionalArea,
    this.isRevised = false,
    required this.level,
    required this.moduleName,
    required this.note,
    this.percentage,
    this.priority,
    required this.project,
    this.isRevisionStatusLatest = true,
    this.revisionNumber,
    required this.structureType,
    this.taskCreateDate,
    this.taskNumber,
    this.isHidden = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'activityCode': activityCode,
      'area': area,
      'changeNumber': changeNumber,
      'coverSheetRevision': coverSheetRevision,
      'designDrawing': designDrawing,
      'drawingNumber': drawingNumber,
      'drawingTitle': drawingTitle,
      'functionalArea': functionalArea,
      'isRevised': isRevised,
      'level': level,
      'moduleName': moduleName,
      'note': note,
      'percentage': percentage,
      'priority': priority,
      'project': project,
      'isRevisionStatusLatest': isRevisionStatusLatest,
      'revisionNumber': revisionNumber,
      'structureType': structureType,
      'taskCreateDate': taskCreateDate?.millisecondsSinceEpoch,
      'taskNumber': taskNumber,
      'isHidden': isHidden,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map, String? id) {
    return TaskModel(
      id: id ?? null,
      activityCode: map['activityCode'],
      area: List<String>.from(map['area']),
      changeNumber: map['changeNumber'] != null ? map['changeNumber'] : null,
      coverSheetRevision: map['coverSheetRevision'],
      designDrawing: List<String>.from(map['designDrawing']),
      drawingNumber: map['drawingNumber'],
      drawingTitle: map['drawingTitle'],
      functionalArea: map['functionalArea'],
      isRevised: map['isRevised'] != null ? map['isRevised'] : null,
      level: map['level'],
      moduleName: map['moduleName'],
      note: map['note'],
      percentage: map['percentage'] != null ? map['percentage'] : null,
      priority: map['priority'] != null ? map['priority'] : null,
      project: map['project'],
      isRevisionStatusLatest: map['isRevisionStatusLatest'] != null
          ? map['isRevisionStatusLatest']
          : null,
      revisionNumber:
          map['revisionNumber'] != null ? map['revisionNumber'] : null,
      structureType: map['structureType'],
      taskCreateDate:
          map['taskCreateDate'] != null ? map['taskCreateDate'].toDate() : null,
      taskNumber: map['taskNumber'] != null ? map['taskNumber'] : null,
      isHidden: map['isHidden'] != null ? map['isHidden'] : null,
    );
  }
}
