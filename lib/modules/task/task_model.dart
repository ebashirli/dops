class TaskModel {
  String? id;
  String? parentId;
  String revisionMark;
  bool? issueType;
  int revisionCount;
  double? percentage;
  bool? revisionStatus;
  int? changeNumber;
  List<String> referenceDocuments;
  String note;
  DateTime? taskCreateDate;
  bool isHidden;

  TaskModel({
    this.id,
    this.parentId,
    required this.revisionMark,
    required this.referenceDocuments,
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
      'revisionMark': revisionMark,
      'referenceDocuments': referenceDocuments,
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
      revisionMark: map['revisionMark'],
      referenceDocuments: List<String>.from(map['referenceDocuments']),
      note: map['note'],
      taskCreateDate:
          map['taskCreateDate'] != null ? map['taskCreateDate'].toDate() : null,
      isHidden: map['isHidden'] != null ? map['isHidden'] : null,
      revisionCount: map['revisionCount'] != null ? map['revisionCount'] : null,
      changeNumber: map['changeNumber'] != null ? map['changeNumber'] : null,
    );
  }
}
