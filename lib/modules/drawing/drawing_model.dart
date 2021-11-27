class DrawingModel {
  String? id;
  String activityCode;
  String drawingNumber;
  String drawingTitle;
  String module;
  bool? issueType;
  double? percentage;
  bool? revisionStatus;
  String level;
  String structureType;
  List<String> area;
  int? changeNumber;
  String functionalArea;
  String note;
  DateTime? drawingCreateDate;
  bool isHidden;

  DrawingModel({
    this.id,
    required this.activityCode,
    required this.drawingNumber,
    required this.area,
    this.changeNumber,
    required this.drawingTitle,
    required this.functionalArea,
    this.issueType = false,
    required this.level,
    required this.module,
    required this.note,
    this.percentage,
    this.revisionStatus = true,
    required this.structureType,
    this.drawingCreateDate,
    this.isHidden = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'activityCode': activityCode,
      'drawingNumber': drawingNumber,
      'drawingTitle': drawingTitle,
      'module': module,
      'level': level,
      'area': area,
      'functionalArea': functionalArea,
      'structureType': structureType,
      'note': note,
      'isHidden': isHidden,
      'drawingCreateDate': drawingCreateDate,

      // 'priority': priority,
      // 'isRevised': isRevised,
      // 'percentage': percentage,
      // 'isRevisionStatusLatest': isRevisionStatusLatest,
      // 'changeNumber': changeNumber,
    };
  }

  factory DrawingModel.fromMap(Map<String, dynamic> map, String? id) {
    return DrawingModel(
      id: id ?? null,
      activityCode: map['activityCode'],
      drawingNumber: map['drawingNumber'],
      drawingTitle: map['drawingTitle'],
      module: map['module'],
      level: map['level'],
      area: List<String>.from(map['area']),
      functionalArea: map['functionalArea'],
      structureType: map['structureType'],
      note: map['note'],
      drawingCreateDate: map['drawingCreateDate'] != null
          ? map['drawingCreateDate'].toDate()
          : null,
      isHidden: map['isHidden'] != null ? map['isHidden'] : null,

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
