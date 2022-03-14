import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/modules/drawing/widgets/drawing_form.dart';
import 'package:dops/modules/task/task_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'drawing_model.dart';
import 'drawing_repository.dart';

class DrawingController extends GetxService {
  final GlobalKey<FormState> drawingFormKey = GlobalKey<FormState>();
  final _repository = Get.find<DrawingRepository>();
  static DrawingController instance = Get.find();

  late TextEditingController drawingNumberController,
      nextRevisionMarkController,
      drawingTitleController,
      drawingNoteController,
      taskNoteController;

  late List<String> areaList;
  late List<String> drawingTagList;
  late List<String> referenceDocumentsList;

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
    nextRevisionMarkController = TextEditingController();
    drawingTitleController = TextEditingController();
    drawingNoteController = TextEditingController();
    taskNoteController = TextEditingController();

    areaList = [];
    drawingTagList = [];
    referenceDocumentsList = [];
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
    nextRevisionMarkController.clear();
    drawingTitleController.clear();
    drawingNoteController.clear();

    activityCodeIdText = '';
    moduleNameText = '';
    levelText = '';
    functionalAreaText = '';
    structureTypeText = '';

    areaList = [];
    drawingTagList = [];
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
    drawingTagList = drawingModel.drawingTag;

    if (taskModel != null) {
      nextRevisionMarkController.text = taskModel.revisionMark;
      taskNoteController.text = taskModel.note;
      referenceDocumentsList = taskModel.referenceDocuments;
    }
  }

  buildAddEdit({String? drawingId}) {
    late final DrawingModel? drawingModel;
    late final TaskModel? taskModel;

    String? taskId = null;

    if (taskController.documents.isNotEmpty) {
      if (taskController.documents
          .map((e) => e!.parentId)
          .contains(drawingId)) {
        taskId = taskController.documents
            .lastWhere((e) => e!.parentId == drawingId)!
            .id;
      }
    }

    if (drawingId != null) {
      drawingModel =
          documents.singleWhere((drawings) => drawings.id == drawingId);

      if (taskId != null) {
        taskModel =
            taskController.documents.singleWhere((task) => task!.id == taskId);
      }

      fillEditingControllers(
        drawingModel: drawingModel,
        taskModel: taskId != null ? taskModel : null,
      );
    } else {
      clearEditingControllers();
    }

    final double dialogWidth = Get.width * .5;

    formDialog(
      drawingId: drawingId,
      dialogWidth: dialogWidth,
      taskId: taskId,
    );
  }

  void formDialog({
    String? drawingId,
    String? taskId,
    required double dialogWidth,
  }) =>
      Get.defaultDialog(
        barrierDismissible: false,
        radius: 12,
        titlePadding: EdgeInsets.only(top: 20, bottom: 20),
        title: drawingId == null ? 'Add new drawing' : 'Update drawing',
        content: DrawingForm(
          dialogWidth: dialogWidth,
          drawingId: drawingId,
          taskId: taskId,
        ),
      );
}
