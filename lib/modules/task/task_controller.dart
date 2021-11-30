import 'dart:math';

import 'package:dops/modules/drawing/drawing_controller.dart';
import 'package:dops/modules/drawing/drawing_model.dart';
import 'package:dops/modules/dropdown_source/dropdown_sources_controller.dart';
import '../../components/custom_text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/custom_dropdown_menu_widget.dart';
import '../../components/custom_full_screen_dialog_widget.dart';
import '../../constants/style.dart';
import '../activity/activity_controller.dart';
import '../reference_document/reference_document_controller.dart';
import 'task_model.dart';
import 'task_repository.dart';

class TaskController extends GetxController {
  final GlobalKey<FormState> taskFormKey = GlobalKey<FormState>();
  final _repository = Get.find<TaskRepository>();
  final activityController = Get.find<ActivityController>();
  final drawingController = Get.find<DrawingController>();

  final referenceDocumentController = Get.find<ReferenceDocumentController>();
  final dropdownSourcesController = Get.find<DropdownSourcesController>();

  late TextEditingController nextRevisionNumberController, noteController;
  late List<String> designDrawingsList;

  late int revisionNumber;

  RxList<TaskModel> _documents = RxList<TaskModel>([]);
  List<TaskModel?> get documents => _documents;

  @override
  void onInit() {
    super.onInit();
    nextRevisionNumberController = TextEditingController();
    noteController = TextEditingController();
    designDrawingsList = [];
    revisionNumber = 0;

    _documents.bindStream(_repository.getAllDocumentsAsStream());
  }

  addNewTask({required TaskModel model}) async {
    CustomFullScreenDialog.showDialog();
    model.taskCreateDate = DateTime.now();
    await _repository.addModel(model);
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
    nextRevisionNumberController.clear();
    noteController.clear();
    revisionNumber = 0;
    designDrawingsList = [];
  }

  buildAddEdit({String? id, bool newRev = false}) {
    
    if (newRev) {
      clearEditingControllers();
      DrawingModel selectedDrawing = drawingController.documents
          .where((drawing) => drawing.id == id)
          .toList()[0];

      TaskModel? selectedTask;
      if (!documents.isEmpty) {
        int maxRevisionCount = documents
            .where((task) => task!.parentId == selectedDrawing.id)
            .map((task) => task!.revisionCount)
            .reduce(max);
        selectedTask = documents
            .where((task) =>
                task!.revisionCount == maxRevisionCount &&
                task.parentId == selectedDrawing.id)
            .toList()[0]!;
      }

      Get.defaultDialog(
        barrierDismissible: false,
        radius: 12,
        titlePadding: EdgeInsets.only(top: 20, bottom: 20),
        title: 'Add next revision',
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
                            Column(
                              children: <Widget>[
                                Text(
                                  //  TODO: ask Ismayil
                                  'Current Revision: ${selectedDrawing.drawingNumber}-${selectedTask != null ? selectedTask.revisionNumber : ''}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                CustomTextFormField(
                                  controller: nextRevisionNumberController,
                                  labelText: 'Next Revision number',
                                ),
                                CustomDropdownMenu(
                                  isMultiSelectable: true,
                                  labelText: 'Design Drawings',
                                  items: referenceDocumentController.documents
                                      .map(
                                          (document) => document.documentNumber)
                                      .toList(),
                                  onChanged: (values) =>
                                      designDrawingsList = values,
                                  selectedItems: designDrawingsList,
                                ),
                                CustomTextFormField(
                                  controller: noteController,
                                  labelText: 'Note',
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      child: Row(
                        children: <Widget>[
                          ElevatedButton(
                              onPressed: () => Get.back(),
                              child: const Text('Cancel')),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              TaskModel newTaskModel = TaskModel(
                                parentId: id,
                                designDrawings: designDrawingsList,
                                revisionNumber:
                                    nextRevisionNumberController.text,
                                note: noteController.text,
                                revisionCount: documents.length == 0
                                    ? 1
                                    : documents
                                            .where((task) {
                                              return task!.parentId == id;
                                            })
                                            .toList()
                                            .length +
                                        1,
                              );

                              newTaskModel.changeNumber =
                                  newTaskModel.revisionCount == 1
                                      ? 0
                                      : (documents.length -
                                              drawingController
                                                  .documents.length) +
                                          1;

                              addNewTask(model: newTaskModel);
                            },
                            child: Text('Add next revision'),
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
    } else {
      drawingController.buildAddEdit(id: id, newRev: newRev);
    }
  }

  List<Map<String, dynamic>> get getDataForTableView {
    return drawingController.documents.map(
      (drawing) {
        late TaskModel task;
        if (!documents.isEmpty) {
          int maxRevisionCount = !documents.isEmpty
              ? documents
                  .where((task) => task!.parentId == drawing.id)
                  .map((task) => task!.revisionCount)
                  .reduce(max)
              : 0;
          task = documents
              .where((task) =>
                  task!.revisionCount == maxRevisionCount &&
                  task.parentId == drawing.id)
              .toList()[0]!;
        } else {
          task = TaskModel(
            parentId: '',
            id: '',
            revisionNumber: '',
            designDrawings: [],
            note: '',
            changeNumber: 0,
            percentage: 0,
          );
        }

        return <String, dynamic>{
          'parentId': drawing.id,
          'id': task.id,
          'priority': activityController.documents.indexOf(activityController
                  .documents
                  .where((activity) => activity.id == drawing.activityCodeId)
                  .toList()[0]) +
              1,
          'activityCode': activityController.documents
              .where((activity) => activity.id == drawing.activityCodeId)
              .toList()[0]
              .activityId,
          'drawingNumber': '${drawing.drawingNumber}|${drawing.id}',
          'revisionNumber': task.revisionNumber,
          'drawingTitle': drawing.drawingTitle,
          'module': drawing.module,
          'issueType': task.revisionCount == 1
              ? 'First issue'
              : task.revisionCount == 0
                  ? ''
                  : 'Revision',
          'revisionCount': task.revisionCount,
          'percentage': task.percentage,
          'revisionStatus': 'Current',
          'level': drawing.level,
          'structureType': drawing.structureType,
          'designDrawings': '${task.designDrawings.join(';')}',
          'changeNumber': task.changeNumber,
          'taskCreateDate': task.taskCreateDate ?? '',
        };
      },
    ).toList();
  }
}
