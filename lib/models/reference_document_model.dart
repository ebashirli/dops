import 'package:cloud_firestore/cloud_firestore.dart';

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

  toMap() {
    return {
      'docId': docId,
      'project': project,
      'refType': refType,
      'moduleName': moduleName,
      'docNo': docNo,
      'revCode': revCode,
      'title': title,
      'transmittalNo': transmittalNo,
      'receiveDate': receiveDate,
      'actionRequiredNext': actionRequiredNext,
      'assignedDocsCount': assignedDocsCount,
    };
  }

  ReferenceDocumentModel.fromMap(DocumentSnapshot data) {
    docId = data.id;
    project = data['project'];
    refType = data['ref_type'];
    moduleName = data['module_name'];
    docNo = data['doc_no'];
    revCode = data['rev_code'];
    title = data['title'];
    transmittalNo = data['transmittal_no'];
    receiveDate = data['receive_date'].toDate();
    actionRequiredNext = data['action_required_next'];
    // assignedDocsCount = data['assigned_docs_count'];
  }
}
