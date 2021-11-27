class TaskModel {
  String? id;
  String drawingNumber;
  String nextRevisionNumber;
  bool? issueType;
  int? revisionCount;
  double? percentage;
  bool? revisionStatus;
  int? changeNumber;
  List<String> designDrawings;
  String note;
  DateTime? taskCreateDate;
  bool isHidden;

  TaskModel({
    this.id,
    required this.drawingNumber,
    required this.nextRevisionNumber,
    required this.designDrawings,
    this.revisionCount,
    this.changeNumber,
    this.issueType = false,
    required this.note,
    this.percentage,
    this.revisionStatus = true,
    this.taskCreateDate,
    this.isHidden = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'drawingNumber': drawingNumber,
      'coverSheetRevision': nextRevisionNumber,
      'designDrawings': designDrawings,
      'note': note,
      'isHidden': isHidden,
      'taskCreateDate': taskCreateDate,
      'revisionNumber': revisionCount,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map, String? id) {
    return TaskModel(
      id: id ?? null,
      drawingNumber: map['drawingNumber'],
      nextRevisionNumber: map['coverSheetRevision'],
      designDrawings: List<String>.from(map['designDrawings']),
      note: map['note'],
      taskCreateDate:
          map['taskCreateDate'] != null ? map['taskCreateDate'].toDate() : null,
      isHidden: map['isHidden'] != null ? map['isHidden'] : null,
      revisionCount:
          map['revisionNumber'] != null ? map['revisionNumber'] : null,
    );
  }
}
