import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/modules/task/task_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/style.dart';
import 'drawing_model.dart';
import 'drawing_repository.dart';

class DrawingController extends GetxService {
  final GlobalKey<FormState> drawingFormKey = GlobalKey<FormState>();
  final _repository = Get.find<DrawingRepository>();
  static DrawingController instance = Get.find();

  late TextEditingController drawingNumberController,
      nextRevisionNumberController,
      drawingTitleController,
      drawingNoteController,
      taskNoteController;

  late List<String> areaList;
  late List<String> designDrawingsList;

  late String activityCodeIdText,
      moduleNameText,
      levelText,
      functionalAreaText,
      structureTypeText;

  RxList<DrawingModel> _documents = RxList<DrawingModel>([]);
  List<DrawingModel> get documents => _documents;

  @override
  void onInit() {
    super.onInit();
    drawingNumberController = TextEditingController();
    nextRevisionNumberController = TextEditingController();
    drawingTitleController = TextEditingController();
    drawingNoteController = TextEditingController();
    taskNoteController = TextEditingController();

    areaList = [];
    designDrawingsList = [];
    activityCodeIdText = '';
    moduleNameText = '';
    levelText = '';
    functionalAreaText = '';
    structureTypeText = '';

    _documents.bindStream(_repository.getAllDocumentsAsStream());
  }

  addNewDrawing({required DrawingModel model}) async {
    final isValid = drawingFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    CustomFullScreenDialog.showDialog();
    model.drawingCreateDate = DateTime.now();
    await _repository.addModel(model);
    CustomFullScreenDialog.cancelDialog();
    Get.back();
  }

  updateDrawing(
      {required DrawingModel updatedModel, required String id}) async {
    // TODO: move following line to Add/update button if it is relevant
    final isValid = drawingFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    drawingFormKey.currentState!.save();
    //update
    CustomFullScreenDialog.showDialog();
    updatedModel.drawingCreateDate = documents
        .where((document) => document.id == id)
        .toList()[0]
        .drawingCreateDate;
    await _repository.updateModel(updatedModel, id);
    CustomFullScreenDialog.cancelDialog();
    Get.back();
  }

  void deleteDrawing(String id) {
    if (taskController.documents.isNotEmpty) {
      final List<TaskModel?> tasks = taskController.documents
          .where((task) => task!.parentId == id)
          .toList();
      if (tasks.isNotEmpty) {
        tasks.forEach((task) {
          taskController.deleteTask(task!.id!);
        });
      }
    }

    _repository.removeModel(id);
  }

  @override
  void onReady() {
    super.onReady();
  }

  void clearEditingControllers() {
    drawingNumberController.clear();
    nextRevisionNumberController.clear();
    drawingTitleController.clear();
    drawingNoteController.clear();

    activityCodeIdText = '';
    moduleNameText = '';
    levelText = '';
    functionalAreaText = '';
    structureTypeText = '';

    areaList = [];
  }

  void fillEditingControllers(
      {required DrawingModel drawingModel, TaskModel? taskModel}) {
    drawingNumberController.text = drawingModel.drawingNumber;
    drawingTitleController.text = drawingModel.drawingTitle;
    drawingNoteController.text = drawingModel.note;

    activityCodeIdText = drawingModel.activityCodeId;
    moduleNameText = drawingModel.module;
    levelText = drawingModel.level;
    functionalAreaText = drawingModel.functionalArea;
    structureTypeText = drawingModel.structureType;

    areaList = drawingModel.area;

    if (taskModel != null) {
      nextRevisionNumberController.text = taskModel.revisionNumber;
      taskNoteController.text = taskModel.note;
      designDrawingsList = taskModel.designDrawings;
    }
  }

  buildAddEdit({String? drawingId, String? taskId}) {
    late final DrawingModel? drawingModel;
    late final TaskModel? taskModel;

    String drawingWithRevNum = '';

    if (drawingId != null) {
      drawingModel =
          documents.where((drawings) => drawings.id == drawingId).toList()[0];

      if (taskId != null) {
        taskModel = taskController.documents
            .where((task) => task!.id == taskId)
            .toList()[0];
        drawingWithRevNum =
            '${drawingModel.drawingNumber}-${taskModel!.revisionNumber}';
      }

      fillEditingControllers(
          drawingModel: drawingModel,
          taskModel: taskId != null ? taskModel : null);
    } else {
      clearEditingControllers();
    }

    Get.defaultDialog(
      barrierDismissible: false,
      radius: 12,
      titlePadding: EdgeInsets.only(top: 20, bottom: 20),
      title: drawingId == null ? 'Add new drawing' : 'Update drawing',
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
            key: drawingFormKey,
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
                              SizedBox(height: 10),
                              CustomDropdownMenu(
                                showSearchBox: true,
                                labelText: 'Activity code',
                                selectedItems: [
                                  drawingId == null
                                      ? activityCodeIdText
                                      : activityController.documents
                                          .where(
                                            (activity) =>
                                                activity.id ==
                                                activityCodeIdText,
                                          )
                                          .toList()[0]
                                          .activityId!,
                                ],
                                onChanged: (value) {
                                  activityCodeIdText = activityController
                                      .documents
                                      .where((activity) =>
                                          activity.activityId == value)
                                      .toList()[0]
                                      .id!;
                                },
                                items: activityController.documents
                                    .map((document) => document.activityId)
                                    .toList(),
                              ),
                              CustomTextFormField(
                                controller: drawingNumberController,
                                labelText: 'Drawing Number',
                              ),
                              CustomTextFormField(
                                controller: drawingTitleController,
                                labelText: 'Drawing Title',
                              ),
                              CustomDropdownMenu(
                                labelText: 'Module name',
                                selectedItems: [moduleNameText],
                                onChanged: (value) {
                                  moduleNameText = value ?? '';
                                },
                                items: dropdownSourcesController
                                    .document.value.modules!,
                              ),
                              CustomDropdownMenu(
                                showSearchBox: true,
                                labelText: 'Level',
                                selectedItems: [levelText],
                                onChanged: (value) {
                                  levelText = value ?? '';
                                },
                                items: dropdownSourcesController
                                    .document.value.levels!,
                              ),
                              CustomDropdownMenu(
                                showSearchBox: true,
                                isMultiSelectable: true,
                                labelText: 'Area',
                                items: dropdownSourcesController
                                    .document.value.areas!,
                                onChanged: (values) => areaList = values,
                                selectedItems: areaList,
                              ),
                              CustomDropdownMenu(
                                showSearchBox: true,
                                labelText: 'Functional Area',
                                selectedItems: [functionalAreaText],
                                onChanged: (value) {
                                  functionalAreaText = value ?? '';
                                },
                                items: dropdownSourcesController
                                    .document.value.functionalAreas!,
                              ),
                              CustomDropdownMenu(
                                showSearchBox: true,
                                labelText: 'Structure Type',
                                selectedItems: [structureTypeText],
                                onChanged: (value) {
                                  structureTypeText = value ?? '';
                                },
                                items: dropdownSourcesController
                                    .document.value.structureTypes!,
                              ),
                              CustomTextFormField(
                                controller: drawingNoteController,
                                labelText: 'Note',
                              ),
                            ],
                          ),
                          if (taskId != null)
                            Column(
                              children: <Widget>[
                                Text(
                                  drawingWithRevNum,
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
                                  controller: taskNoteController,
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
                        if (drawingId != null)
                          ElevatedButton.icon(
                            onPressed: () {
                              deleteDrawing(drawingId);
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
                            DrawingModel revisedOrNewDrawing = DrawingModel(
                              activityCodeId: activityCodeIdText,
                              drawingNumber: drawingNumberController.text,
                              drawingTitle: drawingTitleController.text,
                              level: levelText,
                              module: moduleNameText,
                              structureType: structureTypeText,
                              note: drawingNoteController.text,
                              area: areaList,
                              functionalArea: functionalAreaText,
                            );

                            if (drawingId == null) {
                              addNewDrawing(model: revisedOrNewDrawing);
                            } else {
                              updateDrawing(
                                updatedModel: revisedOrNewDrawing,
                                id: drawingId,
                              );
                              if (taskId != null) {
                                Map<String, dynamic> revisedTaskFields = {
                                  'designDrawings': designDrawingsList,
                                  'revisionNumber':
                                      nextRevisionNumberController.text,
                                  'note': taskNoteController.text,
                                };

                                taskController.updateTaskFields(
                                  map: revisedTaskFields,
                                  id: taskId,
                                );
                              }
                              // TODO: update last revision details from here?
                            }
                          },
                          child: Text(
                            drawingId != null ? 'Update' : 'Add',
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
}
