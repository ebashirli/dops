import 'dart:html' as html;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dops/constants/table_details.dart';
import 'package:dops/modules/dropdown_source/dropdown_sources_controller.dart';
import 'package:dops/modules/task/task_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recase/recase.dart';

import '../../components/custom_date_time_form_field_widget.dart';
import '../../components/custom_dropdown_menu_widget.dart';
import '../../components/custom_full_screen_dialog_widget.dart';
import '../../components/custom_snackbar_widget.dart';
import '../../components/custom_string_text_field_widget.dart';
import '../../constants/style.dart';
import 'reference_document_model.dart';
import 'reference_document_repository.dart';

class ReferenceDocumentController extends GetxController {
  final GlobalKey<FormState> referenceDocumentFormKey = GlobalKey<FormState>();
  final _repository = Get.find<ReferenceDocumentRepository>();
  late final taskController = Get.find<TaskController>();
  late final dropdownSourcesController = Get.find<DropdownSourcesController>();

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
    _documents.bindStream(_repository.getAllDocumentsAsStream());
  }

  saveDocument({required ReferenceDocumentModel model}) async {
    CustomFullScreenDialog.showDialog();
    await _repository.addModel(model);
    CustomFullScreenDialog.cancelDialog();
    Get.back();
  }

  updateDocument({
    required ReferenceDocumentModel model,
    required String id,
  }) async {
    final isValid = referenceDocumentFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    referenceDocumentFormKey.currentState!.save();
    CustomFullScreenDialog.showDialog();
    await _repository.updateModel(model, id);
    CustomFullScreenDialog.cancelDialog();
    Get.back();
  }

  void deleteReferenceDocument(String id) {
    _repository.removeModel(id);
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

  void fillEditingControllers(String id) async {
    final ReferenceDocumentModel model = await _repository.getModelById(id);

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

  buildAddEdit({String? id}) {
    if (id != null) {
      fillEditingControllers(id);
    } else {
      clearEditingControllers();
    }

    Get.defaultDialog(
      barrierDismissible: false,
      radius: 12,
      titlePadding: EdgeInsets.only(top: 20, bottom: 20),
      title:
          id == null ? 'Add Reference Document' : 'Update Reference Document',
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
                      items: dropdownSourcesController.document.value.projects!,
                    ),
                    CustomDropdownMenu(
                      labelText: 'Module name',
                      selectedItem: moduleNameText,
                      onChanged: (value) {
                        moduleNameText = value ?? '';
                      },
                      items: dropdownSourcesController.document.value.modules!,
                    ),
                    CustomDropdownMenu(
                      labelText: 'Reference Type',
                      selectedItem: referenceTypeText,
                      onChanged: (value) {
                        referenceTypeText = value ?? '';
                      },
                      items: dropdownSourcesController
                          .document.value.referenceTypes!,
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
                          if (id != null)
                            ElevatedButton.icon(
                              onPressed: () {
                                deleteReferenceDocument(id);
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
                              id == null
                                  ? saveDocument(model: model)
                                  : updateDocument(model: model, id: id);
                            },
                            child: Text(
                              id != null ? 'Update' : 'Add',
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

  List<Map<String, Widget>> get getDataForTableView {
    List<String> mapPropNames = tableColNames['reference document']!
        .map((colName) => ReCase(colName).snakeCase)
        .toList();

    return documents.map((referenceDocument) {
      Map<String, Widget> map = {};

      mapPropNames.forEach((mapPropName) {
        switch (mapPropName) {
          case 'assigned_tasks':
            final List<List<String>> assignedTasks = [];
            taskController.documents.forEach((task) {
              if (task.designDrawings
                  .contains(referenceDocument.documentNumber))
                assignedTasks.add([task.drawingNumber, task.id!]);
            });
            map[mapPropName] = assignedTasks.length != 0
                ? TextButton(
                    child: Text('${assignedTasks.length}'),
                    onPressed: () {
                      Get.defaultDialog(
                        title: 'Assigned tasks',
                        content: Column(
                          children: assignedTasks
                              .map(
                                (taskDrawingNumberAndId) => TextButton(
                                  onPressed: () {
                                    taskController.openedTaskId.value =
                                        taskDrawingNumberAndId[1];
                                    html.window.open('/#/stages', '_blank');
                                  },
                                  child: Text(taskDrawingNumberAndId[0]),
                                ),
                              )
                              .toList(),
                        ),
                      );
                    },
                  )
                : Text('0');

            break;
          default:
            map[mapPropName] =
                Text('${referenceDocument.toMap()[mapPropName]}');
            break;
        }
      });
      return map;
    }).toList();
  }

  List<String> getFieldValues(String fieldName) {
    return _documents.map((doc) => doc.toMap()[fieldName].toString()).toList();
  }
}
