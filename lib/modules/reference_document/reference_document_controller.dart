import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/custom_date_time_form_field_widget.dart';
import '../../components/custom_dropdown_menu_widget.dart';
import '../../components/custom_full_screen_dialog_widget.dart';
import '../../components/custom_snackbar_widget.dart';
import '../../components/custom_string_text_field_widget.dart';
import '../../constants/lists.dart';
import '../../constants/style.dart';
import 'reference_document_model.dart';
import 'reference_document_repository.dart';

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

  RxInt requiredActionNext = 0.obs;

  RxBool sortAscending = false.obs;
  RxInt sortColumnIndex = 0.obs;

  RxList<ReferenceDocumentModel> _documents =
      RxList<ReferenceDocumentModel>([]);
  List<ReferenceDocumentModel> get documents => _documents;

  @override
  void onInit() {
    super.onInit();
    documentNumberController = TextEditingController();
    revisionCodeController = TextEditingController();
    titleController = TextEditingController();
    transmittalNumberController = TextEditingController();
    receiveDate = DateTime.now();
    requiredActionNextController = TextEditingController();
    _documents.bindStream(_repository.getAllReferenceDocumentsAsStream());
  }

  saveDocument({required ReferenceDocumentModel model}) async {
    CustomFullScreenDialog.showDialog();
    await _repository.addReferenceDocumentModel(model);
    CustomFullScreenDialog.cancelDialog();
    Get.back();
  }

  updateDocument({
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

  void deleteReferenceDocument(ReferenceDocumentModel data) {
    _repository.removeReferenceDocumentModel(data);
  }

  void incrementNumberOfAssignedDocumentField(List<String> designDrawing) {
    _repository.incrementNumberOfAssignedDocumentField(designDrawing);
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
    requiredActionNext.value = model.requiredActionNext;
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

  buildAddEdit({ReferenceDocumentModel? aModel}) {
    if (aModel != null) {
      fillEditingControllers(aModel);
    } else {
      clearEditingControllers();
    }

    Get.defaultDialog(
      barrierDismissible: false,
      radius: 12,
      titlePadding: EdgeInsets.only(top: 20, bottom: 20),
      title: aModel == null
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
                    CustomDropdownMenu(
                      labelText: 'Project',
                      selectedItem: projectText,
                      onChanged: (value) {
                        projectText = value ?? '';
                      },
                      items: listsMap['Project']!,
                    ),
                    CustomDropdownMenu(
                      labelText: 'Module name',
                      selectedItem: moduleNameText,
                      onChanged: (value) {
                        moduleNameText = value ?? '';
                      },
                      items: listsMap['Module name']!,
                    ),
                    CustomDropdownMenu(
                      labelText: 'Reference Type',
                      selectedItem: referenceTypeText,
                      onChanged: (value) {
                        referenceTypeText = value ?? '';
                      },
                      items: listsMap['Reference Type']!,
                    ),
                    CustomStringTextField(
                      controller: documentNumberController,
                      labelText: 'Document number',
                    ),
                    CustomStringTextField(
                      controller: revisionCodeController,
                      labelText: 'Revision code',
                    ),
                    CustomStringTextField(
                      controller: titleController,
                      labelText: 'Title',
                    ),
                    CustomStringTextField(
                      controller: transmittalNumberController,
                      labelText: 'Transmittal number',
                    ),
                    Obx(() {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 400,
                            child: CustomDateTimeFormField(
                              labelText: 'Received date',
                              initialValue: receiveDate,
                              onDateSelected: (date) => receiveDate = date,
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            child: GestureDetector(
                              onTap: () {
                                _handleChangedRadio(0);
                              },
                              child: ListTile(
                                title: const Text('Required Action'),
                                leading: Radio<int>(
                                  value: 0,
                                  groupValue: requiredActionNext.value,
                                  onChanged: (int? value) {
                                    requiredActionNext.value = value!;
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            child: GestureDetector(
                              onTap: () {
                                _handleChangedRadio(1);
                              },
                              child: ListTile(
                                title: const Text('Next'),
                                leading: Radio<int>(
                                  value: 1,
                                  groupValue: requiredActionNext.value,
                                  onChanged: _handleChangedRadio,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                    Container(
                      child: Row(
                        children: <Widget>[
                          if (aModel != null)
                            ElevatedButton.icon(
                              onPressed: () {
                                deleteReferenceDocument(aModel);
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
                                id: aModel != null ? aModel.id : null,
                                project: projectText,
                                referenceType: referenceTypeText,
                                moduleName: moduleNameText,
                                documentNumber: documentNumberController.text,
                                revisionCode: revisionCodeController.text,
                                title: titleController.text,
                                transmittalNumber:
                                    transmittalNumberController.text,
                                receivedDate: receiveDate,
                                requiredActionNext: requiredActionNext.value,
                                assignedDocumentsCount: 0,
                              );
                              aModel == null
                                  ? saveDocument(model: model)
                                  : updateDocument(model: aModel);
                            },
                            child: Text(
                              aModel != null ? 'Update' : 'Add',
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

  void _handleChangedRadio(int? value) {
    requiredActionNext.value = value!;
  }

  List<Map<String, dynamic>> get getDataForTableView {
    return _documents.map((document) {
      Map<String, String> map = {};
      document.toMap().entries.forEach((entry) {
        switch (entry.key) {
          case 'isHidden':
            break;
          default:
            map[entry.key] = entry.value.toString();
        }
      });
      return map;
    }).toList();
  }

  List<String> getFieldValues(String fieldName) {
    return _documents.map((doc) => doc.toMap()[fieldName].toString()).toList();
  }
}