class TaskModel {
  String? id;
  String? parentId;
  String revisionNumber;
  bool? issueType;
  int revisionCount = 0;
  double? percentage;
  bool? revisionStatus;
  int? changeNumber;
  List<String> designDrawings;
  String note;
  DateTime? taskCreateDate;
  bool isHidden;

  TaskModel({
    this.id,
    this.parentId,
    required this.revisionNumber,
    required this.designDrawings,
    this.revisionCount = 0,
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
      'revisionNumber': revisionNumber,
      'designDrawings': designDrawings,
      'note': note,
      'revisionCount': revisionCount,
      'changeNumber': changeNumber,
      'taskCreateDate': taskCreateDate,
      'isHidden': isHidden,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map, String? id) {
    return TaskModel(
      id: id ?? null,
      parentId: map['parentId'],
      revisionNumber: map['revisionNumber'],
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
