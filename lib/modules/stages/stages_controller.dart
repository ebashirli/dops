import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dops/modules/dropdown_source/dropdown_sources_controller.dart';
import 'package:dops/modules/task/task_controller.dart';
import 'package:dops/modules/task/task_model.dart';
import 'package:dops/modules/task/task_repository.dart';
import '../../components/custom_multiselect_dropdown_menu_widget.dart';
import '../../components/custom_string_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/custom_dropdown_menu_widget.dart';
import '../../components/custom_full_screen_dialog_widget.dart';
import '../../components/custom_snackbar_widget.dart';
import '../../constants/style.dart';
import '../activity/activity_controller.dart';
import '../reference_document/reference_document_controller.dart';

class StagesController extends GetxController {
  final GlobalKey<FormState> taskFormKey = GlobalKey<FormState>();
  final _repository = Get.find<TaskRepository>();
  final activityController = Get.find<ActivityController>();
  final referenceDocumentController = Get.find<ReferenceDocumentController>();
  final dropdownSourcesController = Get.find<DropdownSourcesController>();
  final taskController = Get.find<TaskController>();

  late TextEditingController drawingNumberController,
      coverSheetRevisionController,
      drawingTitleController,
      noteController;

  late List<String> areaList = [];
  late List<String> designDrawingList = [];

  late String activityCodeText,
      projectText,
      moduleNameText,
      levelText,
      functionalAreaText,
      structureTypeText;

  RxList<TaskModel> _documents = RxList<TaskModel>([]);
  List<TaskModel> get documents => _documents;

  @override
  void onInit() {
    super.onInit();

    drawingNumberController = TextEditingController();
    coverSheetRevisionController = TextEditingController();
    drawingTitleController = TextEditingController();
    noteController = TextEditingController();

    activityCodeText = '';
    projectText = '';
    moduleNameText = '';
    levelText = '';
    functionalAreaText = '';
    structureTypeText = '';

    _documents.bindStream(_repository.getAllDocumentsAsStream());
  }

  saveDocument({required TaskModel model}) async {
    CustomFullScreenDialog.showDialog();
    model.taskCreateDate = DateTime.now();
    await _repository.addModel(model);
    CustomFullScreenDialog.cancelDialog();
    Get.back();
  }

  updateDocument({
    required TaskModel model,
    required String id,
  }) async {
    final isValid = taskFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    taskFormKey.currentState!.save();
    //update
    CustomFullScreenDialog.showDialog();
    await _repository.updateModel(model, id);
    CustomFullScreenDialog.cancelDialog();
    Get.back();
  }

  void deleteTask(String id) {
    _repository.removeModel(id);
  }

  @override
  void onReady() {
    super.onReady();
  }

  void clearEditingControllers() {
    drawingNumberController.clear();
    coverSheetRevisionController.clear();
    drawingTitleController.clear();
    noteController.clear();

    activityCodeText = '';
    projectText = '';
    moduleNameText = '';
    levelText = '';
    functionalAreaText = '';
    structureTypeText = '';

    designDrawingList = [];
    areaList = [];
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

  buildEdit({required String id}) {
    taskController.fillEditingControllers(id);
    return Container(
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
          key: taskFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Container(
            width: Get.width * .5,
            child: Column(
              children: [
                Container(
                  height: 540,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        CustomDropdownMenu(
                          labelText: 'Activity code',
                          selectedItem: activityCodeText,
                          onChanged: (value) {
                            activityCodeText = value ?? '';
                          },
                          items:
                              activityController.getFieldValues('activity_id'),
                        ),
                        CustomDropdownMenu(
                          labelText: 'Project',
                          selectedItem: projectText,
                          onChanged: (value) {
                            projectText = value ?? '';
                          },
                          items: dropdownSourcesController
                              .document.value.projects!,
                        ),
                        CustomStringTextField(
                          controller: drawingNumberController,
                          labelText: 'Drawing Number',
                        ),
                        CustomStringTextField(
                          controller: coverSheetRevisionController,
                          labelText: 'First Sheet Revision',
                        ),
                        CustomStringTextField(
                          controller: drawingTitleController,
                          labelText: 'Drawing Title',
                        ),
                        CustomDropdownMenu(
                          labelText: 'Module name',
                          selectedItem: moduleNameText,
                          onChanged: (value) {
                            moduleNameText = value ?? '';
                          },
                          items:
                              dropdownSourcesController.document.value.modules!,
                        ),
                        CustomDropdownMenu(
                          labelText: 'Level',
                          selectedItem: levelText,
                          onChanged: (value) {
                            levelText = value ?? '';
                          },
                          items:
                              dropdownSourcesController.document.value.levels!,
                        ),
                        CustomMultiselectDropdownMenu(
                          hint: 'Area',
                          items:
                              dropdownSourcesController.document.value.areas!,
                          onChanged: (values) => areaList = values,
                          selectedItems: areaList,
                        ),
                        CustomDropdownMenu(
                          labelText: 'Functional Area',
                          selectedItem: functionalAreaText,
                          onChanged: (value) {
                            functionalAreaText = value ?? '';
                          },
                          items: dropdownSourcesController
                              .document.value.functionalAreas!,
                        ),
                        CustomDropdownMenu(
                          labelText: 'Structure Type',
                          selectedItem: structureTypeText,
                          onChanged: (value) {
                            structureTypeText = value ?? '';
                          },
                          items: dropdownSourcesController
                              .document.value.structureTypes!,
                        ),
                        CustomMultiselectDropdownMenu(
                          hint: 'Design Drawing',
                          items: referenceDocumentController
                              .getFieldValues('document_number'),
                          onChanged: (values) => designDrawingList = values,
                          selectedItems: designDrawingList,
                        ),
                        CustomStringTextField(
                          controller: noteController,
                          labelText: 'Note',
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: Row(
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          TaskModel model = TaskModel(
                            activityCode: activityCodeText,
                            drawingNumber: drawingNumberController.text,
                            designDrawings: designDrawingList,
                            drawingTitle: drawingTitleController.text,
                            coverSheetRevision:
                                coverSheetRevisionController.text,
                            level: levelText,
                            moduleName: moduleNameText,
                            structureType: structureTypeText,
                            note: noteController.text,
                            area: areaList,
                            project: projectText,
                            functionalArea: functionalAreaText,
                          );
                          updateDocument(
                            model: model,
                            id: id,
                          );
                        },
                        child: Text('Update'),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<dynamic> getFieldValues(String fieldName) {
    return _documents.map((doc) => doc.toMap()[fieldName]).toList();
  }
}
