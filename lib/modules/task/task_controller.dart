import 'dart:math';
import 'package:collection/collection.dart';

import 'package:dops/components/custom_widgets.dart';
import 'package:dops/components/select_item_snackbar.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/constants/lists.dart';
import 'package:dops/enum.dart';
import 'package:dops/modules/drawing/drawing_model.dart';
import 'package:dops/modules/stages/stage_model.dart';
import 'package:dops/modules/task/widgets/task_form.dart';
import 'package:dops/modules/values/value_model.dart';
import 'package:dops/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'task_model.dart';
import 'task_repository.dart';

class TaskController extends GetxService {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _repository = Get.find<TaskRepository>();
  static TaskController instance = Get.find();

  late TextEditingController nextRevisionMarkController,
      taskNoteController,
      holdReasonController;
  late List<String> referenceDocumentsList;
  final RxBool isHeld = false.obs;
  RxBool loading = true.obs;

  RxList<TaskModel?> _documents = RxList<TaskModel?>([]);
  List<TaskModel?> get documents => _documents.isEmpty
      ? []
      : _documents.where((e) => e!.isHidden == false).toList();
  List<TaskModel?> get documentsAll => _documents;

  @override
  void onInit() {
    super.onInit();
    nextRevisionMarkController = TextEditingController();
    taskNoteController = TextEditingController();
    holdReasonController = TextEditingController();
    referenceDocumentsList = [];

    _documents.bindStream(_repository.getAllDocumentsAsStream());
    _documents.listen((List<TaskModel?> taskModelList) {
      if (taskModelList.isNotEmpty) loading.value = false;
    });
  }

  addNew(String parentId) {
    CustomFullScreenDialog.showDialog();
    int nextChangeNumber = documents.isEmpty
        ? 0
        : documents.where((e) => e!.parentId == parentId).isEmpty
            ? 0
            : documentsAll.map((e) => e!.changeNumber).reduce(max) + 1;

    TaskModel taskModel = TaskModel(
      parentId: parentId,
      referenceDocuments: referenceDocumentsList,
      revisionMark: nextRevisionMarkController.text,
      note: taskNoteController.text,
      changeNumber: nextChangeNumber,
      creationDate: DateTime.now(),
    );

    _repository.add(taskModel).then((taskId) {
      StageModel stage = StageModel(
        taskId: taskId,
        creationDateTime: DateTime.now(),
      );
      stageController.addNew(model: stage);
      if (!checkFirstTask(getById(taskId))) {
        StageModel stage = StageModel(
          index: 1,
          taskId: taskId,
          creationDateTime: DateTime.now(),
        );
        stageController.addNew(model: stage);
      }
    });
    CustomFullScreenDialog.cancelDialog();
    Get.back();
  }

  updateTaskFields({
    required Map<String, dynamic> map,
    required String id,
  }) async {
    final isValid = taskController.formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    taskController.formKey.currentState!.save();
    CustomFullScreenDialog.showDialog();
    await _repository.updateFields(map, id);
    CustomFullScreenDialog.cancelDialog();
    Get.back();
  }

  Future<String> deleteTask(TaskModel? taskModel) async {
    if (taskModel == null) return 'Error';
    CustomFullScreenDialog.showDialog();
    await _repository.removeModel(taskModel.id!);
    CustomFullScreenDialog.cancelDialog();
    Get.offAndToNamed(Routes.HOME);
    return 'Done';
  }

  @override
  void onReady() {
    super.onReady();
  }

  void clearEditingControllers() {
    nextRevisionMarkController.clear();
    taskNoteController.clear();
    holdReasonController.clear();
    referenceDocumentsList = [];
  }

  void fillEditingControllers(TaskModel taskModel) {
    nextRevisionMarkController.text = taskModel.revisionMark;
    taskNoteController.text = taskModel.note ?? '';
    holdReasonController.text = taskModel.holdReason ?? '';
    referenceDocumentsList = taskModel.referenceDocuments;
    isHeld.value = taskModel.holdReason != null;
  }

  void buildAddForm({required String parentId}) {
    clearEditingControllers();
    formDialog(drawingId: parentId);
  }

  void buildUpdateForm({required String? id}) {
    if (id == null) {
      selectItemSnackbar();
    } else {
      final TaskModel? taskModel = getById(id);
      if (taskModel == null) return;

      fillEditingControllers(taskModel);
      formDialog(id: id);
    }
  }

  void formDialog({String? id, String? drawingId}) {
    Get.defaultDialog(
      barrierDismissible: false,
      radius: 12,
      // titlePadding: EdgeInsets.only(top: 20, bottom: 20),
      title: id == null ? 'Add next revision' : 'Update current revision',
      content: TaskForm(id: id, drawingId: drawingId),
    );
  }

  List<Map<String, dynamic>?> get getDataForTableView {
    List<DrawingModel?> drawingDocuments = [];

    if (homeController.homeStates != HomeStates.HomeState) {
      drawingDocuments =
          drawingController.loading.value ? [] : drawingController.documents;
    } else {
      final List<ValueModel?> valueModels =
          valueController.loading.value ? [] : valueController.documents;

      final Iterable<ValueModel?> currentUserValueModels = valueModels.isEmpty
          ? Iterable.empty()
          : valueModels.where(
              (e) =>
                  e!.submitDateTime == null &&
                  e.employeeId == staffController.currentUserId,
            );

      List<String?> stageIds = currentUserValueModels.isEmpty
          ? []
          : currentUserValueModels.map((e) => e!.stageId).toList();

      if (staffController.isCoordinator) {
        Iterable<String?> stageIdOfValueModels =
            valueController.loading.value || valueController.documents.isEmpty
                ? Iterable.empty()
                : valueController.documents.map((e) => e!.stageId);

        Iterable<StageModel?> stageModelsWithoutValueModels =
            stageController.loading.value || stageController.documents.isEmpty
                ? Iterable.empty()
                : stageController.documents
                    .where((e) => !stageIdOfValueModels.contains(e!.id));

        Iterable<String?> stageIdsWithoutValueModels =
            stageModelsWithoutValueModels.isEmpty
                ? Iterable.empty()
                : stageModelsWithoutValueModels.map((e) => e!.id);

        stageIds.addAll(stageIdsWithoutValueModels);
      }

      final Iterable<StageModel?> stageModels = stageController.loading.value ||
              stageController.documents.isEmpty
          ? Iterable.empty()
          : stageController.documents.where((e) => stageIds.contains(e!.id));

      Iterable<String?> taskids = stageModels.isEmpty
          ? Iterable.empty()
          : stageModels.map((e) => e!.taskId);

      List<TaskModel?> taskModels = taskids.isEmpty ||
              taskController.loading.value ||
              taskController.documents.isEmpty
          ? []
          : taskController.documents
              .where((e) => taskids.contains(e!.id))
              .toList();
      Iterable<String?> parentIds =
          taskModels.isEmpty ? [] : taskModels.map((e) => e!.parentId);

      drawingDocuments = parentIds.isEmpty ||
              drawingController.loading.value ||
              drawingController.documents.isEmpty
          ? []
          : drawingController.documents
              .where((e) => parentIds.contains(e!.id))
              .toList();
    }
    return drawingDocuments.isEmpty
        ? []
        : drawingDocuments.map(
            (e) {
              List<TaskModel?> tasksOfDrawing = taskModelsByDrawingId(e!.id);

              TaskModel? taskModel =
                  tasksOfDrawing.isNotEmpty ? tasksOfDrawing.last : null;

              return {
                'id': taskModel == null ? null : taskModel.id,
                'parentId': e.id,
                'priority': getPriorrity(e),
                'activityCode': getActivityCode(e),
                'drawingNumber':
                    taskModel == null ? null : getDrawingNumber(e, taskModel),
                'revisionMark':
                    taskModel == null ? null : taskModel.revisionMark,
                'drawingTitle': e.drawingTitle,
                'taskStatus': taskStatusProvider(taskModel),
                'drawingTag': e.drawingTag,
                'module': e.module,
                'revisionType':
                    taskModel == null ? null : getRevTypeAndStatus(taskModel),
                'percentage': precentageProvider(taskModel),
                'revisionStatus': taskModel == null
                    ? null
                    : getRevTypeAndStatus(taskModel, isStatus: true),
                'hold': taskModel == null ? null : getActivityStatus(taskModel),
                'holdReason':
                    taskModel == null ? null : getHoldReason(taskModel),
                'level': e.level,
                'structureType': e.structureType,
                'referenceDocuments':
                    taskModel == null ? null : getReferenceDocuments(taskModel),
                'changeNumber': getChangeNumber(taskModel),
                'taskCreateDate':
                    taskModel == null ? null : taskModel.creationDate,
              };
            },
          ).toList();
  }

  Object? getChangeNumber(TaskModel? taskModel) {
    return taskModel == null
        ? null
        : taskModel.changeNumber == 0
            ? ''
            : taskModel.changeNumber;
  }

  String? getHoldReason(TaskModel task) => task.holdReason != null
      ? task.holdReason
      : stageController.containsHoldFun(task)
          ? stageController
              .getStagesAndValueModelsByTask(task)[7]!
              .values
              .first
              .first!
              .hold
          : '';

  String getActivityStatus(TaskModel task) {
    return task.holdReason != null
        ? 'Hold'
        : task.id == null
            ? ''
            : stageController.containsHoldFun(task)
                ? 'Contains Hold'
                : 'Live';
  }

  String taskStatusProvider(TaskModel? task) {
    if (task == null || task.id == null) return '';

    List<Map<StageModel, List<ValueModel?>>?> valueModelsOfTask =
        stageController.getStagesAndValueModelsByTask(task);

    if (valueModelsOfTask.isEmpty) return '';

    List<StageModel> stageModelsOnLastIndex =
        valueModelsOfTask.last!.keys.toList();
    stageModelsOnLastIndex.sort(
      (a, b) => a.creationDateTime.compareTo(b.creationDateTime),
    );
    final String stageName =
        stageDetailsList[stageModelsOnLastIndex.last.index]['name'];
    return valueModelsOfTask.last![stageModelsOnLastIndex.last]!.isEmpty
        ? 'Awaits $stageName'
        : stageName;
  }

  String? getRevTypeAndStatus(TaskModel task, {bool isStatus = false}) {
    if (task.id == null) return '';
    List<TaskModel?> siblingTasks = documents
        .where((e) => e!.parentId == task.parentId)
        .toList()
      ..sort((a, b) => a!.creationDate!.compareTo(b!.creationDate!));

    bool isTaskEqual =
        (!isStatus ? siblingTasks.first! : siblingTasks.last!) == task;
    return isTaskEqual
        ? isStatus
            ? 'Current'
            : 'First issue'
        : isStatus
            ? 'Superseded'
            : 'Revision';
  }

  String getDrawingNumber(DrawingModel drawing, TaskModel task) =>
      '${drawing.drawingNumber}|${task.id}';

  String getReferenceDocuments(TaskModel task) =>
      '${task.referenceDocuments.join(';')}';

  int getPriorrity(DrawingModel drawing) {
    return activityController.documents.indexOf(activityController.documents
            .where((activity) => activity.id == drawing.activityCodeId)
            .toList()[0]) +
        1;
  }

  String? getActivityCode(DrawingModel drawing) {
    return activityController.documents
        .where((activity) => activity.id == drawing.activityCodeId)
        .toList()[0]
        .activityId;
  }

  void onAddPressed() {
    DataGridRow? selectedRow =
        homeController.dataGridController.value.selectedRow;
    if (selectedRow == null) {
      selectItemSnackbar();
    } else {
      String? taskId = selectedRow.getCells()[0].value;
      String drawingId = selectedRow.getCells()[1].value;

      (taskId != null && !isTaskCompleted)
          ? selectItemSnackbar(
              title: 'Task completion',
              message: 'Current task has not been completed yet',
            )
          : buildAddForm(parentId: drawingId);
    }
  }

  void onUpdatePressed({required String id}) {
    TaskModel? taskModel = getById(id);

    Map<String, dynamic> map = taskModel == null
        ? {}
        : {
            if (nextRevisionMarkController.text != taskModel.revisionMark)
              'revisionMark': nextRevisionMarkController.text,
            if (taskNoteController.text != taskModel.note)
              'note': taskNoteController.text,
            if (holdReasonController.text != taskModel.holdReason ||
                !isHeld.value)
              'holdReason': isHeld.value ? holdReasonController.text : null,
            if (referenceDocumentsList != taskModel.referenceDocuments)
              'referenceDocuments': referenceDocumentsList,
          };

    updateTaskFields(map: map, id: id);
  }

  void onDeletePressed(TaskModel? taskModel) {
    deleteTask(taskModel);
    Get.back();
  }

  String? get selectedTaskId =>
      homeController.dataGridController.value.selectedRow!.getCells()[0].value;

  TaskModel? get selectedTask => loading.value
      ? null
      : documents.firstWhereOrNull((e) => e!.id == selectedTaskId);

  bool get isTaskCompleted {
    // TODO: Rearrage here
    String? taskId = homeController.getSelectedId();
    TaskModel? taskModel = taskId == null ? null : getById(taskId);
    final List<Map<StageModel, List<ValueModel?>>?> valueModelList =
        stageController.getStagesAndValueModelsByTask(taskModel);
    return valueModelList.length < 1
        ? false
        : !valueModelList.last!.values.last
            .map((e) => e!.submitDateTime)
            .contains(null);
  }

  List<TaskModel?> taskModelsByDrawingId(String? drawingId) =>
      (loading.value || documents.isEmpty || drawingId == null)
          ? []
          : documents.where((e) => e!.parentId == drawingId).toList();

  bool checkFirstTask(TaskModel? taskModel) => (loading.value ||
          documents.isEmpty ||
          taskModel == null)
      ? false
      : documents.firstWhereOrNull((e) => e!.parentId == taskModel.parentId) ==
          taskModel;

  TaskModel? getById(String id) {
    return (loading.value || documents.isEmpty)
        ? null
        : documents.singleWhereOrNull((e) => e!.id == id);
  }

  String? getRevisionMarkById(String taskId) {
    TaskModel? taskModel = getById(taskId);
    return taskModel == null ? null : taskModel.revisionMark;
  }

  String getRevisionMarkWithDash(String taskId) {
    String? revisionMark = getRevisionMarkById(taskId);
    return revisionMark == null ? '' : '-' + revisionMark;
  }

  String taskNumber(String taskNoId, String taskId) {
    List<String> splitTaskNoId = taskNoId.split(';');
    return splitTaskNoId.first + getRevisionMarkWithDash(taskId);
  }

  removeDeletedIds(List<String?> ids) {
    List<String?> taskIds = (loading.value || documents.isEmpty || ids.isEmpty)
        ? []
        : taskController.documents.map((e) => e!.id).toList();
    return ids.where((id) => taskIds.contains(id)).toList();
  }

  String? precentageProvider(TaskModel? taskModel) {
    if (taskModel == null) return null;
    final List<Map<StageModel, List<ValueModel?>>?> details =
        stageController.getStagesAndValueModelsByTask(taskModel);
    int lastIndex = details.length - 1;

    int perc = lastIndex == -1
        ? 0
        : details[lastIndex]!.values.last.isEmpty
            ? percentages[percentages.length - lastIndex * 2 - 1]
            : percentages[percentages.length - lastIndex * 2 - 2];

    return '$perc%';
  }
}
