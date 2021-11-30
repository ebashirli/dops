class DrawingModel {
  String? id;
  String activityCode;
  String drawingNumber;
  String drawingTitle;
  String module;
  String level;
  List<String> area;
  String functionalArea;
  String structureType;
  String note;
  DateTime? drawingCreateDate;
  bool isHidden;

  DrawingModel({
    this.id,
    required this.activityCode,
    required this.drawingNumber,
    required this.drawingTitle,
    required this.module,
    required this.level,
    required this.area,
    required this.functionalArea,
    required this.structureType,
    required this.note,
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
      'drawingCreateDate': drawingCreateDate,
      'isHidden': isHidden,
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
    );
  }
}
