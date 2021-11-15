class ReferenceDocumentModel {
  String? id;
  String project;
  String referenceType;
  String moduleName;
  String documentNumber;
  String revisionCode;
  String title;
  String transmittalNumber;
  int requiredActionNext;
  DateTime receivedDate;
  int assignedDocumentsCount;
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
    required this.requiredActionNext,
    this.assignedDocumentsCount = 0,
    this.isHidden = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'project': project,
      'reference_type': referenceType,
      'module_name': moduleName,
      'document_number': documentNumber,
      'revision_code': revisionCode,
      'title': title,
      'transmittal_number': transmittalNumber,
      'received_date': receivedDate,
      'required_action_next': requiredActionNext,
      'assigned_documents_count': assignedDocumentsCount,
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
      referenceType: map['reference_type'],
      moduleName: map['module_name'],
      documentNumber: map['document_number'],
      revisionCode: map['revision_code'],
      title: map['title'],
      transmittalNumber: map['transmittal_number'],
      receivedDate:
          map['received_date'] != null ? map['received_date'].toDate() : null,
      requiredActionNext: map['required_action_next'],
      assignedDocumentsCount: map['assigned_documents_count'],
      isHidden: map['isHidden'] != null ? map['isHidden'] : null,
    );
  }
}
