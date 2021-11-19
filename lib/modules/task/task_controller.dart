import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dops/constants/table_details.dart';
import 'package:dops/modules/dropdown_source/dropdown_sources_controller.dart';
import 'package:dops/routes/app_pages.dart';
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
import 'task_model.dart';
import 'task_repository.dart';

class TaskController extends GetxController {
  final GlobalKey<FormState> taskFormKeyOnStages = GlobalKey<FormState>();
  final _repository = Get.find<TaskRepository>();
  final activityController = Get.find<ActivityController>();
  final referenceDocumentController = Get.find<ReferenceDocumentController>();
  final dropdownSourcesController = Get.find<DropdownSourcesController>();

  late TextEditingController drawingNumberController,
      coverSheetRevisionController,
      drawingTitleController,
      noteController;

  late List<String> areaList = [];
  late List<String> designDrawingsList = [];

  late String activityCodeText,
      projectText,
      moduleNameText,
      levelText,
      functionalAreaText,
      structureTypeText;

  RxString openedTaskId = ''.obs;

  RxBool sortAscending = false.obs;
  RxInt sortColumnIndex = 0.obs;

  RxList<TaskModel> _documents = RxList<TaskModel>([]);
  List<TaskModel> get documents => _documents;

  @override
  void onInit() {
    super.onInit();
    drawingNumberController = TextEditingController();
    coverSheetRevisionController = TextEditingController();
    drawingTitleController = TextEditingController();
    noteController = TextEditingController();

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
    required TaskModel updatedModel,
    required String id,
  }) async {
    // TODO: move following line to Add/update button if it is relevant
    final isValid = taskFormKeyOnStages.currentState!.validate();
    if (!isValid) {
      return;
    }
    taskFormKeyOnStages.currentState!.save();
    //update
    CustomFullScreenDialog.showDialog();
    await _repository.updateModel(updatedModel, id);
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

    designDrawingsList = [];
    areaList = [];
  }

  void fillEditingControllers(TaskModel model) {
    drawingNumberController.text = model.drawingNumber;
    coverSheetRevisionController.text = model.coverSheetRevision;
    drawingTitleController.text = model.drawingTitle;
    noteController.text = model.note;

    activityCodeText = model.activityCode;
    projectText = model.project;
    moduleNameText = model.module;
    levelText = model.level;
    functionalAreaText = model.functionalArea;
    structureTypeText = model.structureType;

    designDrawingsList = model.designDrawings;
    areaList = model.area;
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

  buildAddEdit({
    String? id,
  }) {
    if (id != null) {
      fillEditingControllers(
          documents.where((document) => document.id == id).toList()[0]);
    } else {
      clearEditingControllers();
    }

    Get.defaultDialog(
      barrierDismissible: false,
      radius: 12,
      titlePadding: EdgeInsets.only(top: 20, bottom: 20),
      title: id == null ? 'Add task' : 'Update task',
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
            key: taskFormKeyOnStages,
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
                                activityController.getFieldValues('activityId'),
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
                            labelText: 'Cover Sheet Revision',
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
                            items: dropdownSourcesController
                                .document.value.modules!,
                          ),
                          CustomDropdownMenu(
                            labelText: 'Level',
                            selectedItem: levelText,
                            onChanged: (value) {
                              levelText = value ?? '';
                            },
                            items: dropdownSourcesController
                                .document.value.levels!,
                          ),
                          CustomMultiselectDropdownMenu(
                            labelText: 'Area',
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
                            labelText: 'Design Drawings',
                            items: referenceDocumentController
                                .getFieldValues('documentNumber'),
                            onChanged: (values) => designDrawingsList = values,
                            selectedItems: designDrawingsList,
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
                        if (id != null)
                          ElevatedButton.icon(
                            onPressed: () {
                              deleteTask(id);
                              Get.back();
                            },
                            icon: Icon(Icons.delete),
                            label: const Text('Delete'),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
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
                            TaskModel updatedModel = TaskModel(
                              activityCode: activityCodeText,
                              drawingNumber: drawingNumberController.text,
                              designDrawings: designDrawingsList,
                              drawingTitle: drawingTitleController.text,
                              coverSheetRevision:
                                  coverSheetRevisionController.text,
                              level: levelText,
                              module: moduleNameText,
                              structureType: structureTypeText,
                              note: noteController.text,
                              area: areaList,
                              project: projectText,
                              functionalArea: functionalAreaText,
                            );
                            id == null
                                ? saveDocument(model: updatedModel)
                                : updateDocument(
                                    updatedModel: updatedModel,
                                    id: id,
                                  );
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
    );
  }

  List<Map<String, Widget>> get getDataForTableView {
    List<String> mapPropNames = mapPropNamesGetter('task');

    return documents.map(
      (task) {
        Map<String, Widget> map = {};

        mapPropNames.forEach(
          (mapPropName) {
            switch (mapPropName) {
              case 'id':
                map[mapPropName] = Text(task.id!);
                break;
              case 'area':
              case 'functionalArea':
              case 'note':
              case 'project':
              case 'isHidden':
                break;
              case 'taskCreateDate':
                map[mapPropName] = Text(task.taskCreateDate.toString());
                break;

              case 'drawingNumber':
                map[mapPropName] = TextButton(
                  child: Text('${task.drawingNumber}'),
                  onPressed: () {
                    openedTaskId.value = task.id!;
                    Get.toNamed(Routes.STAGES);
                  },
                );
                break;
              default:
                map[mapPropName] = Text('${task.toMap()[mapPropName] ?? ""}');
                break;
            }
          },
        );
        return map;
      },
    ).toList();
  }

  List<dynamic> getFieldValues(String fieldName) {
    return _documents.map((doc) => doc.toMap()[fieldName]).toList();
  }
}
