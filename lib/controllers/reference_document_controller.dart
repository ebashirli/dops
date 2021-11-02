import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dops/models/reference_document_model.dart';
import 'package:dops/widgets/customFullScreenDialog.dart';
import 'package:dops/widgets/customSnackBar.dart';
import 'package:get/get.dart';

class ReferenceDocumentController extends GetxController {
  final GlobalKey<FormState> referenceDocumentFormKey = GlobalKey<FormState>();

  late TextEditingController docNoController,
      revCodeController,
      titleController,
      transmittalNoController,
      actionRequiredNextController;
  late DateTime receiveDateController;

  late RxBool sortAscending;
  late RxInt sortColumnIndex;

  //Firestore operation
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  late CollectionReference collectionReference;

  RxList<ReferenceDocumentModel> referenceDocuments =
      RxList<ReferenceDocumentModel>([]);

  @override
  void onInit() {
    super.onInit();
    docNoController = TextEditingController();
    revCodeController = TextEditingController();
    titleController = TextEditingController();
    transmittalNoController = TextEditingController();
    receiveDateController = DateTime.now();
    actionRequiredNextController = TextEditingController();

    sortAscending = false.obs;
    sortColumnIndex = 0.obs;

    collectionReference = firebaseFirestore.collection("reference_documents");
    referenceDocuments.bindStream(getAllReferenceDocuments());
  }

  // TODO: write validation rules for all fields
  String? validateName(String value) {
    if (value.isEmpty) {
      return "Name can not be empty";
    }
    return null;
  }

  String? validateAddress(String value) {
    if (value.isEmpty) {
      return "Address can not be empty";
    }
    return null;
  }

  void saveUpdateReferenceDocument(
    String docId,
    String project,
    String refType,
    String modulName,
    String docNo,
    String revCode,
    String title,
    String transmittalNo,
    DateTime receiveDate,
    String actionRequiredNext,
    int addEditFlag,
  ) {
    final isValid = referenceDocumentFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    referenceDocumentFormKey.currentState!.save();
    if (addEditFlag == 1) {
      CustomFullScreenDialog.showDialog();
      collectionReference.add({
        'project': project,
        'ref_type': refType,
        'module_name': modulName,
        'doc_no': docNo,
        'rev_code': revCode,
        'title': title,
        'transmittal_no': transmittalNo,
        'receive_date': receiveDate,
        'action_required_next': actionRequiredNext,
      }).whenComplete(() {
        CustomFullScreenDialog.cancelDialog();
        clearEditingControllers();
        Get.back();
        CustomSnackBar.showSnackBar(
            context: Get.context,
            title: "Reference Document Added",
            message: "Reference Document successfully",
            backgroundColor: Colors.green);
      }).catchError((error) {
        CustomFullScreenDialog.cancelDialog();
        CustomSnackBar.showSnackBar(
            context: Get.context,
            title: "Error",
            message: "Something went wrong",
            backgroundColor: Colors.green);
      });
    } else if (addEditFlag == 2) {
      //update
      CustomFullScreenDialog.showDialog();
      collectionReference.doc(docId).update({
        'project': project,
        'ref_type': refType,
        'module_name': modulName,
        'doc_no': docNo,
        'rev_code': revCode,
        'title': title,
        'transmittal_no': transmittalNo,
        'receive_date': receiveDate,
        'action_required_next': actionRequiredNext,
      }).whenComplete(() {
        CustomFullScreenDialog.cancelDialog();
        clearEditingControllers();
        Get.back();
        CustomSnackBar.showSnackBar(
          context: Get.context,
          title: "Reference Document Updated",
          message: "Reference Document updated successfully",
          backgroundColor: Colors.green,
        );
      }).catchError((error) {
        CustomFullScreenDialog.cancelDialog();
        CustomSnackBar.showSnackBar(
          context: Get.context,
          title: "Error",
          message: "Something went wrong",
          backgroundColor: Colors.red,
        );
      });
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  void clearEditingControllers() {
    docNoController.clear();
    revCodeController.clear();
    titleController.clear();
    transmittalNoController.clear();
    actionRequiredNextController.clear();
  }

  Stream<List<ReferenceDocumentModel>> getAllReferenceDocuments() =>
      collectionReference.snapshots().map((query) => query.docs
          .map(
            (item) => ReferenceDocumentModel.fromMap(
                item.data() as Map<String, dynamic>),
          )
          .toList());

  void deleteData(String docId) {
    CustomFullScreenDialog.showDialog();
    collectionReference.doc(docId).delete().whenComplete(() {
      CustomFullScreenDialog.cancelDialog();
      Get.back();
      CustomSnackBar.showSnackBar(
          context: Get.context,
          title: "Reference Document Deleted",
          message: "Reference Document deleted successfully",
          backgroundColor: Colors.green);
    }).catchError((error) {
      CustomFullScreenDialog.cancelDialog();
      CustomSnackBar.showSnackBar(
          context: Get.context,
          title: "Error",
          message: "Something went wrong",
          backgroundColor: Colors.red);
    });
  }
}
