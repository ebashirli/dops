class TaskModel {
  String? id;
  String? parentId;
  String revisionMark;
  List<String> referenceDocuments;
  int changeNumber;
  bool isHeld;
  String? holdReason;
  String? note;
  DateTime? taskCreateDate;
  bool isHidden;

  TaskModel({
    this.id,
    this.parentId,
    required this.revisionMark,
    required this.referenceDocuments,
    required this.note,
    required this.changeNumber,
    this.isHeld = false,
    this.holdReason,
    this.taskCreateDate,
    this.isHidden = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'parentId': parentId,
      'revisionMark': revisionMark,
      'referenceDocuments': referenceDocuments,
      'changeNumber': changeNumber,
      'isHeld': isHeld,
      'holdReason': holdReason,
      'note': note,
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
      changeNumber: map['changeNumber'],
      isHeld: map['isHeld'] != null ? map['isHeld'] : null,
      holdReason: map['holdReason'] != null ? map['holdReason'] : null,
      note: map['note'],
      taskCreateDate:
          map['taskCreateDate'] != null ? map['taskCreateDate'].toDate() : null,
      isHidden: map['isHidden'] != null ? map['isHidden'] : null,
    );
  }
}
