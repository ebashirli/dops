class IssueModel {
  String? id;

  int groupNumber;
  DateTime creationDate;
  List<String?> linkedTasks;
  String note;
  List<String?> files;
  DateTime? submitDate;
  bool isHidden;

  IssueModel({
    this.id,
    required this.groupNumber,
    required this.creationDate,
    required this.linkedTasks,
    required this.note,
    required this.files,
    this.submitDate,
    this.isHidden = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'groupNumber': groupNumber,
      'creationDate': creationDate,
      'linkedTasks': linkedTasks,
      'note': note,
      'files': files,
      'submitDate': submitDate,
      'isHidden': isHidden,
    };
  }

  factory IssueModel.fromMap(Map<String, dynamic> map, String id) {
    return IssueModel(
      id: id,
      groupNumber: map['groupNumber'],
      creationDate:
          map['creationDate'] != null ? map['creationDate'].toDate() : null,
      linkedTasks: List<String?>.from(map['linkedTasks']),
      note: map['note'] ?? '',
      files: List<String>.from(map['files']),
      submitDate: map['submitDate'] != null ? map['submitDate'].toDate() : null,
      isHidden: map['isHidden'] ?? false,
    );
  }
}
