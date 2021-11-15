class TaskModel {
  String? id;
  String activityCode;
  String drawingNumber;
  List<String> area;
  int? changeNumber;
  String coverSheetRevision;
  List<String> designDrawing;
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
  bool isHidden;

  TaskModel({
    this.id,
    required this.activityCode,
    required this.drawingNumber,
    required this.area,
    this.changeNumber,
    required this.coverSheetRevision,
    required this.designDrawing,
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
    this.isHidden = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'priority': priority,
      'activityCode': activityCode,
      'drawingNumber': drawingNumber,
      'coverSheetRevision': coverSheetRevision,
      'drawingTitle': drawingTitle,
      'moduleName': moduleName,
      'isRevised': isRevised,
      'revisionNumber': revisionNumber,
      'percentage': percentage,
      'isRevisionStatusLatest': isRevisionStatusLatest,
      'level': level,
      'structureType': structureType,
      'designDrawing': designDrawing,
      'changeNumber': changeNumber,
      'area': area,
      'taskCreateDate': taskCreateDate,
      'functionalArea': functionalArea,
      'note': note,
      'project': project,
      'isHidden': isHidden,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map, String? id) {
    return TaskModel(
      id: id ?? null,
      priority: map['priority'] != null ? map['priority'] : null,
      activityCode: map['activityCode'],
      drawingNumber: map['drawingNumber'],
      coverSheetRevision: map['coverSheetRevision'],
      drawingTitle: map['drawingTitle'],
      moduleName: map['moduleName'],
      isRevised: map['isRevised'] != null ? map['isRevised'] : null,
      revisionNumber:
          map['revisionNumber'] != null ? map['revisionNumber'] : null,
      percentage: map['percentage'] != null ? map['percentage'] : null,
      isRevisionStatusLatest: map['isRevisionStatusLatest'] != null
          ? map['isRevisionStatusLatest']
          : null,
      level: map['level'],
      structureType: map['structureType'],
      changeNumber: map['changeNumber'] != null ? map['changeNumber'] : null,
      taskCreateDate:
          map['taskCreateDate'] != null ? map['taskCreateDate'].toDate() : null,
      functionalArea: map['functionalArea'],
      note: map['note'],
      project: map['project'],
      area: List<String>.from(map['area']),
      designDrawing: List<String>.from(map['designDrawing']),
      isHidden: map['isHidden'] != null ? map['isHidden'] : null,
    );
  }
}
