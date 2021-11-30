class TaskModel {
  String? id;
  String? parentId;
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
    this.parentId,
    this.id,
    required this.drawingNumber,
    required this.nextRevisionNumber,
    required this.designDrawings,
    this.revisionCount = 1,
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
      'parentId': parentId,
      'drawingNumber': drawingNumber,
      'coverSheetRevision': nextRevisionNumber,
      'designDrawings': designDrawings,
      'note': note,
      'isHidden': isHidden,
      'taskCreateDate': taskCreateDate,
      'revisionCount': revisionCount,
      'changeNumber': changeNumber,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map, String? id) {
    return TaskModel(
      id: id ?? null,
      parentId: map['parentId'],
      drawingNumber: map['drawingNumber'],
      nextRevisionNumber: map['coverSheetRevision'],
      designDrawings: List<String>.from(map['designDrawings']),
      note: map['note'],
      taskCreateDate:
          map['taskCreateDate'] != null ? map['taskCreateDate'].toDate() : null,
      isHidden: map['isHidden'] != null ? map['isHidden'] : null,
      revisionCount: map['revisionCount'] != null ? map['revisionCount'] : null,
      changeNumber: map['changeNumber'] != null ? map['changeNumber'] : null,
    );
  }
}
