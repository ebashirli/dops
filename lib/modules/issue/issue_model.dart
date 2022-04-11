class IssueModel {
  String? id;
  int groupNumber;
  DateTime creationDate;
  String createdBy;
  List<String?> linkedTasks;
  String note;
  List<String?> files;
  DateTime? issueDate;
  bool isHidden;

  IssueModel({
    this.id,
    required this.groupNumber,
    required this.creationDate,
    required this.createdBy,
    required this.linkedTasks,
    required this.note,
    required this.files,
    this.issueDate,
    this.isHidden = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'groupNumber': groupNumber,
      'creationDate': creationDate,
      'createdBy': createdBy,
      'linkedTasks': linkedTasks,
      'note': note,
      'files': files,
      'issueDate': issueDate,
      'isHidden': isHidden,
    };
  }

  factory IssueModel.fromMap(Map<String, dynamic> map, String id) {
    return IssueModel(
      id: id,
      groupNumber: map['groupNumber'],
      creationDate:
          map['creationDate'] != null ? map['creationDate'].toDate() : null,
      createdBy: map['createdBy'],
      linkedTasks: List<String?>.from(map['linkedTasks']),
      note: map['note'] ?? '',
      files: List<String>.from(map['files']),
      issueDate: map['issueDate'] != null ? map['issueDate'].toDate() : null,
      isHidden: map['isHidden'] ?? false,
    );
  }
}
