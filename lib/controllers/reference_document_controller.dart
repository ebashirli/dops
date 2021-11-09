import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'package:dops/constants/style.dart';
import 'package:dops/models/reference_document_model.dart';
import 'package:dops/repositories/reference_document_repository.dart';
import 'package:dops/widgets/custom_widgets.dart';

class ReferenceDocumentController extends GetxController {
  final GlobalKey<FormState> referenceDocumentFormKey = GlobalKey<FormState>();
  final _repository = Get.find<ReferenceDocumentRepository>();

  late TextEditingController documentNumberController,
      revisionCodeController,
      titleController,
      transmittalNumberController,
      requiredActionNextController;
  late DateTime receiveDate;
  String projectText = '';
  String referenceTypeText = '';
  String moduleNameText = '';

  RxBool sortAscending = false.obs;
  RxInt sortColumnIndex = 0.obs;

  RxList<ReferenceDocumentModel> _referenceDocuments =
      RxList<ReferenceDocumentModel>([]);
  List<ReferenceDocumentModel> get referenceDocuments => _referenceDocuments;

  @override
  void onInit() {
    super.onInit();
    documentNumberController = TextEditingController();
    revisionCodeController = TextEditingController();
    titleController = TextEditingController();
    transmittalNumberController = TextEditingController();
    receiveDate = DateTime.now();
    requiredActionNextController = TextEditingController();
    _referenceDocuments
        .bindStream(_repository.getAllReferenceDocumentsAsStream());
  }

  saveReferenceDocument({required ReferenceDocumentModel model}) async {
    CustomFullScreenDialog.showDialog();
    await _repository.addReferenceDocumentModel(model);
    CustomFullScreenDialog.cancelDialog();
    Get.back();
  }

  updateReferenceDocument({
    required ReferenceDocumentModel model,
  }) async {
    final isValid = referenceDocumentFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    referenceDocumentFormKey.currentState!.save();
    //update
    CustomFullScreenDialog.showDialog();
    await _repository.updateReferenceDocumentModel(model);
    CustomFullScreenDialog.cancelDialog();
    Get.back();
  }

  void deleteReferenceDocument(String id) {
    _repository.removeReferenceDocumentModel(id);
  }

  @override
  void onReady() {
    super.onReady();
  }

  void clearEditingControllers() {
    documentNumberController.clear();
    revisionCodeController.clear();
    titleController.clear();
    transmittalNumberController.clear();
    requiredActionNextController.clear();
    receiveDate = DateTime.now();
    projectText = '';
    moduleNameText = '';
    referenceTypeText = '';
  }

  void fillEditingControllers(ReferenceDocumentModel model) {
    documentNumberController.text = model.documentNumber;
    revisionCodeController.text = model.revisionCode;
    titleController.text = model.title;
    transmittalNumberController.text = model.transmittalNumber;
    requiredActionNextController.text = model.requiredActionNext;
    receiveDate = model.receivedDate;
    projectText = model.project;
    moduleNameText = model.moduleName;
    referenceTypeText = model.referenceType;
  }

  whenCompleted() {
    CustomFullScreenDialog.cancelDialog();
    clearEditingControllers();
    Get.back();
  }

  catchError(FirebaseException error) {
    {
      CustomFullScreenDialog.cancelDialog();
      CustomSnackBar.showSnackBar(
        context: Get.context,
        title: "Error",
        message: "${error.message.toString()}",
        backgroundColor: Colors.red,
      );
    }
  }

  buildAddEdit({ReferenceDocumentModel? referenceDocumentModel}) {
    if (referenceDocumentModel != null) {
      fillEditingControllers(referenceDocumentModel);
    } else {
      clearEditingControllers();
    }

    Get.defaultDialog(
      barrierDismissible: false,
      radius: 12,
      titlePadding: EdgeInsets.only(top: 20, bottom: 20),
      title: referenceDocumentModel == null
          ? 'Add Reference Document'
          : 'Update Reference Document',
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(8),
            topLeft: Radius.circular(8),
          ),
          color: light, //Color(0xff1E2746),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: referenceDocumentFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              child: Container(
                width: Get.width * 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomDropdownSearch(
                      labelText: 'Project',
                      selectedItem: projectText,
                      onChanged: (value) {
                        projectText = value ?? '';
                      },
                    ),
                    CustomDropdownSearch(
                      labelText: 'Module',
                      selectedItem: moduleNameText,
                      onChanged: (value) {
                        moduleNameText = value ?? '';
                      },
                    ),
                    CustomDropdownSearch(
                      labelText: 'Reference Type',
                      selectedItem: referenceTypeText,
                      onChanged: (value) {
                        referenceTypeText = value ?? '';
                      },
                    ),
                    CustomStringTextField(
                      controller: documentNumberController,
                      labelText: 'Document number',
                    ),
                    SizedBox(height: 10),
                    CustomStringTextField(
                      controller: revisionCodeController,
                      labelText: 'Revision code',
                    ),
                    SizedBox(height: 10),
                    CustomStringTextField(
                      controller: titleController,
                      labelText: 'Title',
                    ),
                    SizedBox(height: 10),
                    CustomStringTextField(
                      controller: transmittalNumberController,
                      labelText: 'Transmittal number',
                    ),
                    SizedBox(height: 10),
                    CustomDateTimeFormField(
                      labelText: 'Received date',
                      initialValue: receiveDate,
                      onDateSelected: (date) => receiveDate = date,
                    ),
                    SizedBox(height: 10),
                    CustomStringTextField(
                      controller: requiredActionNextController,
                      labelText: 'Required Action / Next',
                    ),
                    SizedBox(height: 10),
                    Container(
                      child: Row(
                        children: <Widget>[
                          if (referenceDocumentModel != null)
                            ElevatedButton.icon(
                              onPressed: () {
                                deleteReferenceDocument(
                                    referenceDocumentModel.id!);
                                Get.back();
                              },
                              icon: Icon(Icons.delete),
                              label: const Text('Delete'),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Colors.red,
                                ),
                              ),
                            ),
                          const Spacer(),
                          ElevatedButton(
                              onPressed: () => Get.back(),
                              child: const Text('Cancel')),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              ReferenceDocumentModel model =
                                  ReferenceDocumentModel(
                                id: referenceDocumentModel != null
                                    ? referenceDocumentModel.id
                                    : null,
                                project: projectText,
                                referenceType: referenceTypeText,
                                moduleName: moduleNameText,
                                documentNumber: documentNumberController.text,
                                revisionCode: revisionCodeController.text,
                                title: titleController.text,
                                transmittalNumber:
                                    transmittalNumberController.text,
                                receivedDate: receiveDate,
                                requiredActionNext:
                                    requiredActionNextController.text,
                                assignedDocumentsCount: 0,
                              );
                              referenceDocumentModel == null
                                  ? saveReferenceDocument(model: model)
                                  : updateReferenceDocument(model: model);
                            },
                            child: Text(
                              referenceDocumentModel != null ? 'Update' : 'Add',
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
