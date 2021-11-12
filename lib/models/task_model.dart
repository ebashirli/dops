class TaskModel {
  String? id;
  bool isHidden;
  String activityCode;
  List<String> area;
  int? changeNumber;
  String coverSheetRevision;
  List<String> designDrawing;
  String drawingNumber;
  String drawingTitle;
  String functionalArea;
  bool? isRevised;
  String level;
  String moduleName;
  String note;
  double? percentage;
  int? priority;
  String project;
  bool? isRevisionStatusLatest;
  int? revisionNumber;
  String structureType;
  DateTime? taskCreateDate;
  String? taskNumber;

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
      coverSheetRevision: map['coverSheetRevision'],
      drawingNumber: map['drawingNumber'],
      drawingTitle: map['drawingTitle'],
      functionalArea: map['functionalArea'],
      level: map['level'],
      moduleName: map['moduleName'],
      note: map['note'],
      project: map['project'],
      area: List<String>.from(map['area']),
      designDrawing: List<String>.from(map['designDrawing']),
      changeNumber: map['changeNumber'] != null ? map['changeNumber'] : null,
      isRevised: map['isRevised'] != null ? map['isRevised'] : null,
      percentage: map['percentage'] != null ? map['percentage'] : null,
      priority: map['priority'] != null ? map['priority'] : null,
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
