import 'package:dops/components/custom_widgets.dart';
import 'package:dops/components/select_item_snackbar.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/models/base_table_view_controller.dart';
import 'package:dops/modules/models/task_model.dart';
import 'package:dops/modules/widgets/form_widgets/drawing_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../models/drawing_model.dart';
import '../repositories/drawing_repository.dart';

class DrawingController extends BaseViewController {
  final GlobalKey<FormState> drawingFormKey = GlobalKey<FormState>();
  final _repo = Get.find<DrawingRepository>();
  static DrawingController instance = Get.find();

  RxBool _loading = true.obs;
  @override
  bool get loading => _loading.value;

  late TextEditingController drawingNumberController,
      nextRevisionMarkController,
      drawingTitleController,
      drawingNoteController;

  late List<String?> areaList;
  late List<String?> drawingTagList;
  late List<String?> referenceDocumentsList;

  late String activityCodeIdText,
      moduleNameText,
      levelText,
      functionalAreaText,
      structureTypeText;

  RxList<DrawingModel?> _documents = RxList<DrawingModel>([]);
  @override
  List<DrawingModel?> get documents =>
      _documents; //.where((e) => e?.activityModel != null).toList();

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
      if (drawingModelList.isNotEmpty) _loading.value = false;
    });
  }

  add({required DrawingModel model}) async {
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

  update({required DrawingModel updatedModel, required String id}) async {
    // TODO: move following line to Add/update button if it is relevant
    final isValid = drawingFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    drawingFormKey.currentState!.save();
    //update
    CustomFullScreenDialog.showDialog();
    updatedModel.drawingCreateDate = documents
        .firstWhereOrNull((document) => document!.id == id)!
        .drawingCreateDate;
    await _repo.updateModel(updatedModel, id);
    CustomFullScreenDialog.cancelDialog();
    Get.back();
  }

  DrawingModel? getById(String? id) {
    return loading || documents.isEmpty
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

  @override
  buildAddForm({String? parentId}) {
    clearEditingControllers();
    homeController.getDialog(
      title: 'Add new drawing',
      content: DrawingFormWidget(),
    );
  }

  @override
  buildUpdateForm({required String id}) {
    final DrawingModel? drawingModel = getById(id);
    drawingModel == null
        ? selectItemSnackbar()
        : fillEditingControllers(drawingModel);

    homeController.getDialog(
      title: 'Update drawing',
      content: DrawingFormWidget(id: id),
    );
  }

  DrawingModel? drawingModelByTaskModel(String? parentId) => (loading ||
          documents.isEmpty)
      ? null
      : drawingController.documents.firstWhereOrNull((e) => e!.id == parentId);

  @override
  List<Map<String, dynamic>?> get tableData => throw UnimplementedError();

  @override
  Color? getRowColor(DataGridRow row) => null;

  @override
  Widget getCellWidget(DataGridCell cell, String? id) => SizedBox();
}
