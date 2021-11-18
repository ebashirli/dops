class ReferenceDocumentModel {
  String? id;
  String project;
  String referenceType;
  String moduleName;
  String documentNumber;
  String revisionCode;
  String title;
  String transmittalNumber;
  bool actionRequiredOrNext;
  DateTime receivedDate;
  int assignedTasksCount;
  bool isHidden;

  ReferenceDocumentModel({
    this.id,
    required this.project,
    required this.referenceType,
    required this.moduleName,
    required this.documentNumber,
    required this.revisionCode,
    required this.title,
    required this.transmittalNumber,
    required this.receivedDate,
    required this.actionRequiredOrNext,
    this.assignedTasksCount = 0,
    this.isHidden = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'project': project,
      'referenceType': referenceType,
      'moduleName': moduleName,
      'documentNumber': documentNumber,
      'revisionCode': revisionCode,
      'title': title,
      'transmittalNumber': transmittalNumber,
      'receivedDate': receivedDate,
      'actionRequiredOrNext': actionRequiredOrNext,
      'assignedTasksCount': assignedTasksCount,
      'isHidden': isHidden,
    };
  }

  factory ReferenceDocumentModel.fromMap(
    Map<String, dynamic> map,
    String? id,
  ) {
    return ReferenceDocumentModel(
      id: id ?? '',
      project: map['project'],
      referenceType: map['referenceType'],
      moduleName: map['moduleName'],
      documentNumber: map['documentNumber'],
      revisionCode: map['revisionCode'],
      title: map['title'],
      transmittalNumber: map['transmittalNumber'],
      receivedDate:
          map['receivedDate'] != null ? map['receivedDate'].toDate() : null,
      actionRequiredOrNext: map['actionRequiredOrNext'],
      assignedTasksCount: map['assignedTasksCount'],
      isHidden: map['isHidden'] != null ? map['isHidden'] : null,
    );
  }
}
