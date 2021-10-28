import 'dart:convert';

class ReferenceDocumentModel {
  String? docId;
  String? project;
  String? refType;
  String? moduleName;
  String? docNo;
  String? revCode;
  String? title;
  String? transmittalNo;
  DateTime? receiveDate;
  String? actionRequiredNext;
  String? assignedDocsCount;

  ReferenceDocumentModel({
    this.docId,
    this.project,
    this.refType,
    this.moduleName,
    this.docNo,
    this.revCode,
    this.title,
    this.transmittalNo,
    this.receiveDate,
    this.actionRequiredNext,
    this.assignedDocsCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'docId': docId,
      'project': project,
      'refType': refType,
      'moduleName': moduleName,
      'docNo': docNo,
      'revCode': revCode,
      'title': title,
      'transmittalNo': transmittalNo,
      'receiveDate': receiveDate?.millisecondsSinceEpoch,
      'actionRequiredNext': actionRequiredNext,
      'assignedDocsCount': assignedDocsCount,
    };
  }

  factory ReferenceDocumentModel.fromMap(Map<String, dynamic> map) {
    return ReferenceDocumentModel(
      docId: map['docId'] != null ? map['docId'] : null,
      project: map['project'] != null ? map['project'] : null,
      refType: map['refType'] != null ? map['refType'] : null,
      moduleName: map['moduleName'] != null ? map['moduleName'] : null,
      docNo: map['docNo'] != null ? map['docNo'] : null,
      revCode: map['revCode'] != null ? map['revCode'] : null,
      title: map['title'] != null ? map['title'] : null,
      transmittalNo: map['transmittalNo'] != null ? map['transmittalNo'] : null,
      receiveDate: map['receiveDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['receiveDate'])
          : null,
      actionRequiredNext:
          map['actionRequiredNext'] != null ? map['actionRequiredNext'] : null,
      assignedDocsCount:
          map['assignedDocsCount'] != null ? map['assignedDocsCount'] : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReferenceDocumentModel.fromJson(String source) {
    return ReferenceDocumentModel.fromMap(json.decode(source));
  }
}
