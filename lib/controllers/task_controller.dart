import 'package:dops/models/task_model.dart';
import 'package:dops/repositories/task_repository.dart';
import 'package:dops/widgets/custom_multiselect_dropdown_menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'package:dops/constants/style.dart';
import 'package:dops/widgets/custom_widgets.dart';

class TaskController extends GetxController {
  final GlobalKey<FormState> taskFormKey = GlobalKey<FormState>();
  final _repository = Get.find<TaskRepository>();

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

    _documents.bindStream(_repository.getAllTasksAsStream());
  }

  saveTask({required TaskModel model}) async {
    CustomFullScreenDialog.showDialog();
    await _repository.addTaskModel(model);
    CustomFullScreenDialog.cancelDialog();
    Get.back();
  }

  updateTask({
    required TaskModel model,
  }) async {
    final isValid = taskFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    taskFormKey.currentState!.save();
    //update
    CustomFullScreenDialog.showDialog();
    await _repository.updateTaskModel(model);
    CustomFullScreenDialog.cancelDialog();
    Get.back();
  }

  void deleteTask(String id) {
    _repository.removeTaskModel(id);
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

  void fillEditingControllers(TaskModel model) {
    drawingNumberController.text = model.drawingNumber;
    coverSheetRevisionController.text = model.coverSheetRevision;
    drawingTitleController.text = model.drawingTitle;
    noteController.text = model.note;

    activityCodeText = model.activityCode;
    projectText = model.project;
    moduleNameText = model.moduleName;
    levelText = model.level;
    functionalAreaText = model.functionalArea;
    structureTypeText = model.structureType;

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

  buildAddEdit({TaskModel? aModel}) {
    if (aModel != null) {
      fillEditingControllers(aModel);
    } else {
      clearEditingControllers();
    }

    Get.defaultDialog(
      barrierDismissible: false,
      radius: 12,
      titlePadding: EdgeInsets.only(top: 20, bottom: 20),
      title: aModel == null ? 'Add task' : 'Update task',
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
                          CustomDropdownMenu(
                            labelText: 'Activity Code',
                            selectedItem: activityCodeText,
                            onChanged: (value) {
                              activityCodeText = value ?? '';
                            },
                          ),
                          CustomDropdownMenu(
                            labelText: 'Project',
                            selectedItem: projectText,
                            onChanged: (value) {
                              projectText = value ?? '';
                            },
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
                          ),
                          CustomDropdownMenu(
                            labelText: 'Level',
                            selectedItem: levelText,
                            onChanged: (value) {
                              levelText = value ?? '';
                            },
                          ),
                          CustomMultiselectDropdownMenu(
                            hint: 'Area',
                            items: ['1', '2', '3', '4'],
                            onChanged: (values) => areaList = values,
                          ),
                          CustomDropdownMenu(
                            labelText: 'Functional Area',
                            selectedItem: functionalAreaText,
                            onChanged: (value) {
                              functionalAreaText = value ?? '';
                            },
                          ),
                          CustomDropdownMenu(
                            labelText: 'Structure Type',
                            selectedItem: structureTypeText,
                            onChanged: (value) {
                              structureTypeText = value ?? '';
                            },
                          ),
                          CustomMultiselectDropdownMenu(
                            hint: 'Design Drawing',
                            items: ['a', 'b', 'c'],
                            onChanged: (values) => designDrawingList = values,
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
                        if (aModel != null)
                          ElevatedButton.icon(
                            onPressed: () {
                              deleteTask(aModel.id!);
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
                            TaskModel model = TaskModel(
                              id: aModel != null ? aModel.id : null,
                              activityCode: activityCodeText,
                              designDrawing: designDrawingList,
                              drawingNumber: drawingNumberController.text,
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
                            aModel == null
                                ? saveTask(model: model)
                                : updateTask(model: model);
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
    );
  }

  List<Map<String, dynamic>> get getDataForTableView {
    return _documents.map((document) {
      Map<String, dynamic> map = {};
      document.toMap().entries.forEach((entry) {
        map[entry.key] = entry.value.toString();
      });
      return map;
    }).toList();
  }
}
