class ReferenceDocumentModel {
  String? id;
  String project;
  bool isHidden;
  String referenceType;
  String moduleName;
  String documentNumber;
  String revisionCode;
  String title;
  String transmittalNumber;
  String requiredActionNext;
  DateTime receivedDate;
  int assignedDocumentsCount;

  ReferenceDocumentModel({
    this.id,
    this.isHidden = false,
    required this.project,
    required this.referenceType,
    required this.moduleName,
    required this.documentNumber,
    required this.revisionCode,
    required this.title,
    required this.transmittalNumber,
    required this.receivedDate,
    required this.requiredActionNext,
    required this.assignedDocumentsCount,
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
      'received_date': receivedDate.day,
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
      receivedDate: map['received_date'].toDate(),
      requiredActionNext: map['required_action_next'],
      assignedDocumentsCount: map['assigned_documents_count'],
      isHidden: map['isHidden'] != null ? map['isHidden'] : null,
    );
  }
}
