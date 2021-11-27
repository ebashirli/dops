class TaskModel {
  String? id;
  String activityCode;
  String drawingNumber;
  String coverSheetRevision;
  String drawingTitle;
  String module;
  bool? issueType;
  int? revisionNumber;
  double? percentage;
  bool? revisionStatus;
  String level;
  String structureType;
  List<String> area;
  int? changeNumber;
  List<String> designDrawings;
  String functionalArea;
  String note;
  DateTime? taskCreateDate;
  bool isHidden;

  TaskModel({
    this.id,
    required this.activityCode,
    required this.drawingNumber,
    required this.area,
    this.changeNumber,
    required this.coverSheetRevision,
    required this.designDrawings,
    required this.drawingTitle,
    required this.functionalArea,
    this.issueType = false,
    required this.level,
    required this.module,
    required this.note,
    this.percentage,
    this.revisionStatus = true,
    this.revisionNumber,
    required this.structureType,
    this.taskCreateDate,
    this.isHidden = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'activityCode': activityCode,
      'drawingNumber': drawingNumber,
      'coverSheetRevision': coverSheetRevision,
      'drawingTitle': drawingTitle,
      'module': module,
      'level': level,
      'area': area,
      'functionalArea': functionalArea,
      'structureType': structureType,
      'designDrawings': designDrawings,
      'note': note,
      'isHidden': isHidden,
      'taskCreateDate': taskCreateDate,
      'revisionNumber': revisionNumber,

      // 'priority': priority,
      // 'isRevised': isRevised,
      // 'percentage': percentage,
      // 'isRevisionStatusLatest': isRevisionStatusLatest,
      // 'changeNumber': changeNumber,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map, String? id) {
    return TaskModel(
      id: id ?? null,
      activityCode: map['activityCode'],
      drawingNumber: map['drawingNumber'],
      coverSheetRevision: map['coverSheetRevision'],
      drawingTitle: map['drawingTitle'],
      module: map['module'],
      level: map['level'],
      area: List<String>.from(map['area']),
      functionalArea: map['functionalArea'],
      structureType: map['structureType'],
      designDrawings: List<String>.from(map['designDrawings']),
      note: map['note'],
      taskCreateDate:
          map['taskCreateDate'] != null ? map['taskCreateDate'].toDate() : null,
      isHidden: map['isHidden'] != null ? map['isHidden'] : null,
      revisionNumber:
          map['revisionNumber'] != null ? map['revisionNumber'] : null,

      // priority: map['priority'] != null ? map['priority'] : null,
      // isRevised: map['isRevised'] != null ? map['isRevised'] : null,

      // percentage: map['percentage'] != null ? map['percentage'] : null,
      // isRevisionStatusLatest: map['isRevisionStatusLatest'] != null
      //     ? map['isRevisionStatusLatest']
      //     : null,
      // changeNumber: map['changeNumber'] != null ? map['changeNumber'] : null,
    );
  }
}
