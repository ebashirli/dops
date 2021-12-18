import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/modules/drawing/drawing_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../constants/style.dart';
import 'reference_document_model.dart';
import 'reference_document_repository.dart';

class ReferenceDocumentController extends GetxController {
  final GlobalKey<FormState> referenceDocumentFormKey = GlobalKey<FormState>();
  final _repository = Get.find<ReferenceDocumentRepository>();
  static ReferenceDocumentController instance = Get.find();

  late TextEditingController documentNumberController,
      titleController,
      transmittalNumberController,
      receiveDateController;
  String projectText = '';
  String referenceTypeText = '';
  String moduleNameText = '';

  RxBool actionRequiredOrNext = false.obs;

  RxBool sortAscending = false.obs;
  RxInt sortColumnIndex = 0.obs;

  RxList<ReferenceDocumentModel> _documents =
      RxList<ReferenceDocumentModel>([]);
  List<ReferenceDocumentModel> get documents => _documents;

  @override
  void onInit() {
    super.onInit();
    documentNumberController = TextEditingController();
    titleController = TextEditingController();
    transmittalNumberController = TextEditingController();
    receiveDateController = TextEditingController();

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
    titleController.clear();
    transmittalNumberController.clear();
    receiveDateController.clear();
    projectText = '';
    moduleNameText = '';
    referenceTypeText = '';
  }

  void fillEditingControllers(String id) {
    final ReferenceDocumentModel model =
        documents.where((document) => document.id == id).toList()[0];

    documentNumberController.text = model.documentNumber;
    titleController.text = model.title;
    transmittalNumberController.text = model.transmittalNumber;
    actionRequiredOrNext.value = model.actionRequiredOrNext;
    receiveDateController.text =
        '${model.receivedDate.day}/${model.receivedDate.month}/${model.receivedDate.year}';
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
                      selectedItems: [projectText],
                      onChanged: (value) {
                        projectText = value ?? '';
                      },
                      items: dropdownSourcesController.document.value.projects!,
                    ),
                    CustomDropdownMenu(
                      labelText: 'Module name',
                      selectedItems: [moduleNameText],
                      onChanged: (value) {
                        moduleNameText = value ?? '';
                      },
                      items: dropdownSourcesController.document.value.modules!,
                    ),
                    CustomDropdownMenu(
                      labelText: 'Reference Type',
                      selectedItems: [referenceTypeText],
                      onChanged: (value) {
                        referenceTypeText = value ?? '';
                      },
                      items: dropdownSourcesController
                          .document.value.referenceTypes!,
                    ),
                    CustomTextFormField(
                      controller: documentNumberController,
                      labelText: 'Document number',
                    ),
                    CustomTextFormField(
                      controller: titleController,
                      labelText: 'Title',
                    ),
                    CustomTextFormField(
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
                              initialValue: receiveDateController.text,
                              controller: receiveDateController,
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            child: GestureDetector(
                              onTap: () {
                                _handleChangedRadio(false);
                              },
                              child: ListTile(
                                title: const Text('Action Required'),
                                leading: Radio<bool>(
                                  value: false,
                                  groupValue: actionRequiredOrNext.value,
                                  onChanged: (bool? value) {
                                    actionRequiredOrNext.value = value!;
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 200,
                            child: GestureDetector(
                              onTap: () {
                                _handleChangedRadio(true);
                              },
                              child: ListTile(
                                title: const Text('Next'),
                                leading: Radio<bool>(
                                  value: true,
                                  groupValue: actionRequiredOrNext.value,
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
                                title: titleController.text,
                                transmittalNumber:
                                    transmittalNumberController.text,
                                receivedDate: DateFormat('dd/MM/yyyy')
                                    .parse(receiveDateController.text),
                                actionRequiredOrNext:
                                    actionRequiredOrNext.value,
                                assignedTasksCount: 0,
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

  void _handleChangedRadio(bool? value) {
    actionRequiredOrNext.value = value!;
  }

  List<Map<String, dynamic>> get getDataForTableView {
    return documents.map((refDoc) {
      String assignedTasks = '';

      if (taskController.documents.isNotEmpty) {
        taskController.documents.forEach((task) {
          List<DrawingModel> drawing = drawingController.documents
              .where((drawing) => drawing.id == task!.parentId)
              .toList();
          if (drawing.isNotEmpty) {
            final String drawingNumber = drawing[0].drawingNumber;

            if (task!.designDrawings.contains(refDoc.documentNumber))
              assignedTasks += '|${drawingNumber};${task.id}';
          }
        });
      }

      Map<String, dynamic> map = {
        'id': refDoc.id,
        'project': !refDoc.actionRequiredOrNext ? 'Action required' : 'Next',
        'referenceType': refDoc.referenceType,
        'moduleName': refDoc.moduleName,
        'documentNumber': refDoc.documentNumber,
        'title': refDoc.title,
        'transmittalNumber': refDoc.transmittalNumber,
        'receivedDate': refDoc.receivedDate,
        'actionRequiredOrNext': refDoc.actionRequiredOrNext,
        'assignedTasks': assignedTasks,
      };

      return map;
    }).toList();
  }

}
