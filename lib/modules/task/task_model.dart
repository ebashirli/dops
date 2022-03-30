class TaskModel {
  String? id;
  String? parentId;
  String revisionMark;
  List<String> referenceDocuments;
  int changeNumber;
  String? holdReason;
  String? note;
  DateTime? creationDate;
  bool isHidden;

  TaskModel({
    this.id,
    this.parentId,
    required this.revisionMark,
    required this.referenceDocuments,
    required this.note,
    required this.changeNumber,
    this.holdReason,
    this.creationDate,
    this.isHidden = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'parentId': parentId,
      'revisionMark': revisionMark,
      'referenceDocuments': referenceDocuments,
      'changeNumber': changeNumber,
      'holdReason': holdReason,
      'note': note,
      'creationDate': creationDate,
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
      holdReason: map['holdReason'] != null ? map['holdReason'] : null,
      note: map['note'],
      creationDate:
          map['creationDate'] != null ? map['creationDate'].toDate() : null,
      isHidden: map['isHidden'] != null ? map['isHidden'] : null,
    );
  }
}
