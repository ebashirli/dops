import 'package:dops/components/custom_widgets.dart';
import 'package:dops/components/select_item_snackbar.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/modules/drawing/widgets/drawing_form_widget.dart';
import 'package:dops/modules/task/task_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';

import 'drawing_model.dart';
import 'drawing_repository.dart';

class DrawingController extends GetxService {
  final GlobalKey<FormState> drawingFormKey = GlobalKey<FormState>();
  final _repo = Get.find<DrawingRepository>();
  static DrawingController instance = Get.find();

  RxBool loading = true.obs;

  late TextEditingController drawingNumberController,
      nextRevisionMarkController,
      drawingTitleController,
      drawingNoteController;

  late List<String> areaList;
  late List<String?> drawingTagList;
  late List<String?> referenceDocumentsList;

  late String activityCodeIdText,
      moduleNameText,
      levelText,
      functionalAreaText,
      structureTypeText;

  RxList<DrawingModel?> _documents = RxList<DrawingModel>([]);
  List<DrawingModel?> get documents => _documents;

  @override
  void onInit() {
    super.onInit();
    drawingNumberController = TextEditingController();
    nextRevisionMarkController = TextEditingController();
    drawingTitleController = TextEditingController();
    drawingNoteController = TextEditingController();

    areaList = [];
    drawingTagList = [];
    referenceDocumentsList = [];
    activityCodeIdText = '';
    moduleNameText = '';
    levelText = '';
    functionalAreaText = '';
    structureTypeText = '';

    _documents.bindStream(_repo.getAllDocumentsAsStream());
    _documents.listen((List<DrawingModel?> drawingModelList) {
      if (drawingModelList.isNotEmpty) loading.value = false;
    });
  }

  addNewDrawing({required DrawingModel model}) async {
    final isValid = drawingFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    CustomFullScreenDialog.showDialog();
    model.drawingCreateDate = DateTime.now();
    await _repo.addModel(model);
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
        .firstWhere((document) => document!.id == id)!
        .drawingCreateDate;
    await _repo.updateModel(updatedModel, id);
    CustomFullScreenDialog.cancelDialog();
    Get.back();
  }

  DrawingModel? getById(String id) {
    return loading.value || documents.isEmpty
        ? null
        : documents.singleWhereOrNull((e) => e!.id == id);
  }

  void deleteDrawing(String id) {
    if (taskController.documents.isNotEmpty) {
      final List<TaskModel?> tasks = taskController.documents
          .where((task) => task!.parentId == id)
          .toList();
      if (tasks.isNotEmpty) {
        tasks.forEach((task) {
          taskController.deleteTask(task);
        });
      }
    }

    _repo.removeModel(id);
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

  void fillEditingControllers(DrawingModel drawingModel) {
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
  }

  buildAddForm() {
    clearEditingControllers();
    getDialog();
  }

  buildUpdateForm({required String id}) {
    final DrawingModel? drawingModel = getById(id);
    drawingModel == null
        ? selectItemSnackbar()
        : fillEditingControllers(drawingModel);

    getDialog(drawingId: id);
  }

  void getDialog({String? drawingId, String? taskId}) => Get.defaultDialog(
        barrierDismissible: false,
        radius: 12,
        titlePadding: EdgeInsets.only(top: 20, bottom: 20),
        title: drawingId == null ? 'Add new drawing' : 'Update drawing',
        content: DrawingFormWidget(
          dialogWidth: Get.width * 0.5,
          drawingId: drawingId,
        ),
      );

  DrawingModel? drawingModelByTaskModel(String? parentId) => (loading.value ||
          documents.isEmpty)
      ? null
      : drawingController.documents.firstWhereOrNull((e) => e!.id == parentId);
}
