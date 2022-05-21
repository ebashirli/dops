import 'dart:math';
import 'package:collection/collection.dart';

import 'package:dops/components/custom_widgets.dart';
import 'package:dops/components/select_item_snackbar.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/constants/lists.dart';
import 'package:dops/models/base_table_view_controller.dart';
import 'package:dops/modules/activity/activity_model.dart';
import 'package:dops/modules/drawing/drawing_model.dart';
import 'package:dops/modules/stages/stage_model.dart';
import 'package:dops/modules/task/widgets/task_form.dart';
import 'package:dops/modules/values/value_model.dart';
import 'package:dops/routes/app_pages.dart';
import 'package:dops/services/file_api/file_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'task_model.dart';
import 'task_repository.dart';

class TaskController extends BaseViewController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _repo = Get.find<TaskRepository>();
  static TaskController instance = Get.find();

  late TextEditingController nextRevisionMarkController,
      taskNoteController,
      holdReasonController;
  late List<String> referenceDocumentsList;
  final RxBool isHeld = false.obs;
  RxBool _loading = true.obs;
  bool get loading => _loading.value;

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

    _documents.bindStream(_repo.getAllDocumentsAsStream());
    _documents.listen((List<TaskModel?> taskModelList) {
      if (taskModelList.isNotEmpty) _loading.value = false;
    });
  }

  int colculateNextChangeNumber(String parentId) =>
      documents.where((e) => e?.parentId == parentId).isEmpty
          ? 0
          : documentsAll.map((e) => e!.changeNumber).reduce(max) + 1;

  add(String parentId) {
    CustomFullScreenDialog.showDialog();
    final DateTime now = DateTime.now();
    TaskModel taskModel = TaskModel(
      parentId: parentId,
      referenceDocuments: referenceDocumentsList,
      revisionMark: nextRevisionMarkController.text,
      note: taskNoteController.text,
      changeNumber: colculateNextChangeNumber(parentId),
      creationDate: now,
    );

    _repo.add(taskModel).then((taskId) {
      StageModel stage = StageModel(taskId: taskId, creationDateTime: now);
      stageController.add(model: stage);
      if (!checkIfIsFirstTask(getById(taskId)))
        stageController.add(
          model: StageModel(
            index: 1,
            taskId: taskId,
            creationDateTime: now,
          ),
        );
    });
    sendNotificationEmail(taskModel: taskModel);
    CustomFullScreenDialog.cancelDialog();
    Get.back();
  }

  update({
    required Map<String, dynamic> map,
    required String id,
  }) async {
    final isValid = taskController.formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    taskController.formKey.currentState!.save();
    CustomFullScreenDialog.showDialog();
    await _repo.updateFields(map, id);
    CustomFullScreenDialog.cancelDialog();
    Get.back();
  }

  Future<String> deleteTask(TaskModel? taskModel) async {
    if (taskModel == null) return 'Error';
    CustomFullScreenDialog.showDialog();
    await _repo.removeModel(taskModel.id!);
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

  @override
  void buildAddForm({String? parentId}) {
    clearEditingControllers();
    homeController.getDialog(
      title: 'Add task',
      content: TaskAddUpdateForm(
        drawingId: parentId,
      ),
    );
  }

  @override
  void buildUpdateForm({required String? id}) {
    if (id == null) {
      selectItemSnackbar();
    } else {
      final TaskModel? taskModel = getById(id);
      if (taskModel == null) return;

      fillEditingControllers(taskModel);
      homeController.getDialog(
        title: 'Update task',
        content: TaskAddUpdateForm(id: id),
      );
    }
  }

  List<TaskModel?> get taskModelsAssignedCU =>
      stageController.taskIdsAsignedCU.isEmpty || loading || documents.isEmpty
          ? []
          : stageController.taskIdsAsignedCU.map((e) => getById(e!)).toList();

  List<TaskModel?> get taskModelsNotAssignedYet =>
      stageController.taskIdsNotAsignedYet.isEmpty ||
              loading ||
              documents.isEmpty
          ? []
          : stageController.taskIdsAsignedCU.map((e) => getById(e!)).toList();

  List<String?> get parentIdsAssignedCU => taskModelsAssignedCU.isEmpty
      ? []
      : taskModelsAssignedCU.map((e) => e!.parentId).toList();

  List<String?> get parentIdsNotAssignedYet => taskModelsNotAssignedYet.isEmpty
      ? []
      : taskModelsNotAssignedYet.map((e) => e!.parentId).toList();

  TaskModel? getLastTaskByParentId(String? id) {
    if (id == null || loading || documents.isEmpty) return null;
    return documents.lastWhereOrNull((e) => e!.parentId == id);
  }

  @override
  List<Map<String, dynamic>?> get tableData {
    List<DrawingModel?> drawingDocuments = [];

    if (homeController.currentViewModel.value.isMyTasks) {
      drawingDocuments = drawingController.drawingModelsAssignedCU;
      if (staffController.isCoordinator) {
        drawingDocuments = [
          ...drawingDocuments,
          ...drawingController.drawingModelsNotAssignedYet
        ].toSet().toList();
      }
    } else {
      drawingDocuments =
          drawingController.loading ? [] : drawingController.documents;
    }

    late Map<String, dynamic> map;

    return drawingDocuments.isEmpty || homeController.columnNames.isEmpty
        ? []
        : drawingDocuments.map(
            (e) {
              List<TaskModel?> tasksOfDrawing = taskModelsByDrawingId(e!.id);

              TaskModel? taskModel =
                  tasksOfDrawing.isNotEmpty ? tasksOfDrawing.last : null;
              map = {
                'id': taskModel == null ? null : taskModel.id,
                'parentId': e.id,
                'priority': activityController.getPriority(e),
                'activityCode': getActivityCode(e),
                'drawingNumber': getDrawingNumber(e, taskModel),
                'revisionMark':
                    taskModel == null ? null : taskModel.revisionMark,
                'drawingTitle': e.drawingTitle,
                'taskStatus': taskStatusProvider(taskModel),
                'drawingTag': e.drawingTag.join(", "),
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
              return homeController.getTableMap(map);
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

  List<StageModel?> getStageModelsOnLastIndexByTask(TaskModel? task) {
    List<Map<StageModel, List<ValueModel?>>?> valueModelsOfTask =
        stageController.getStagesAndValueModelsByTask(task);

    List<StageModel?> stageModelsOnLastIndex =
        valueModelsOfTask.isEmpty ? [] : valueModelsOfTask.last!.keys.toList();
    stageModelsOnLastIndex.sort(
      (a, b) => a!.creationDateTime.compareTo(b!.creationDateTime),
    );
    return stageModelsOnLastIndex;
  }

  bool? checkIfTaskStatusAwaits(TaskModel? task) {
    if (task == null || task.id == null) return null;

    List<Map<StageModel, List<ValueModel?>>?> valueModelsOfTask =
        stageController.getStagesAndValueModelsByTask(task);

    if (valueModelsOfTask.isEmpty) return null;

    List<StageModel?> stageModelsOnLastIndex =
        getStageModelsOnLastIndexByTask(task);

    return valueModelsOfTask.last![stageModelsOnLastIndex.last]!.isEmpty;
  }

  String? getStageName(TaskModel? task) {
    List<StageModel?> stageModelsOnLastIndex =
        getStageModelsOnLastIndexByTask(task);

    if (stageModelsOnLastIndex.isEmpty) return null;

    int index = stageModelsOnLastIndex.last!.index;

    final String stageName = stageDetailsList[index]['name'];

    return stageName;
  }

  String taskStatusProvider(TaskModel? task) {
    bool? isTaskStatusAwaits = checkIfTaskStatusAwaits(task);
    String stageName = getStageName(task) ?? '';
    return isTaskStatusAwaits == null
        ? ''
        : isTaskStatusAwaits
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

  String getDrawingNumber(DrawingModel drawing, TaskModel? task) {
    return task == null
        ? drawing.drawingNumber
        : '${drawing.drawingNumber}|${task.id}';
  }

  String getReferenceDocuments(TaskModel task) =>
      '${task.referenceDocuments.join(';')}';

  String? getActivityCode(DrawingModel drawing) {
    ActivityModel? activityModel =
        activityController.getById(drawing.activityCodeId);

    return activityModel == null ? null : activityModel.activityId;
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

    update(map: map, id: id);
  }

  void onDeletePressed(TaskModel? taskModel) {
    deleteTask(taskModel);
    Get.back();
  }

  String? get selectedTaskId =>
      homeController.dataGridController.value.selectedRow!.getCells()[0].value;

  TaskModel? get selectedTask => loading
      ? null
      : documents.firstWhereOrNull((e) => e!.id == selectedTaskId);

  bool get isTaskCompleted {
    // TODO: Rearrage here
    String? taskId = homeController.selectedId;
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
      (loading || documents.isEmpty || drawingId == null)
          ? []
          : documents.where((e) => e!.parentId == drawingId).toList();

  bool checkIfIsFirstTask(TaskModel? taskModel) => (loading ||
          documents.isEmpty ||
          taskModel == null)
      ? false
      : documents.firstWhereOrNull((e) => e!.parentId == taskModel.parentId) ==
          taskModel;

  TaskModel? getById(String? id) => documents.singleWhere((e) => e?.id == id);

  List<TaskModel?> getByIds(List<String?> ids) =>
      documents.where((e) => ids.contains(e?.id)).toList();

  List<TaskModel?> taskModelsByEmployeeId({
    required String employeeId,
    required int index,
  }) {
    List<String?> taskIds = stageController.taskIdsByEmployeeId(
      employeeId: employeeId,
      index: index,
    );
    return getByIds(taskIds);
  }

  List<String?> getTaskNamesByEmpoyeeIdAndIndex(
      {required String employeeId, required int index}) {
    List<String?> taskNames = taskModelsByEmployeeId(
      employeeId: employeeId,
      index: index,
    ).map((e) {
      DrawingModel? drawingModel = drawingController.getById(e?.parentId);

      return '${drawingModel?.drawingNumber}-${e?.revisionMark}';
    }).toList();

    return taskNames;
  }

  String? getRevisionMarkById({String? taskId, String? parentId}) {
    final TaskModel? taskModel = getById(taskId ?? '');
    TaskModel? lastTaskModel = null;

    if (parentId != null && documents.isNotEmpty) {
      lastTaskModel = loading || documents.isEmpty
          ? null
          : documents.lastWhereOrNull((e) => e!.parentId == parentId);
    }

    final String? revisionmark = taskModel == null
        ? [parentId, lastTaskModel].contains(null)
            ? null
            : lastTaskModel!.revisionMark
        : taskModel.revisionMark;

    return revisionmark;
  }

  String? getRevisionMarkWithDash({String? taskId, String? parentId}) {
    String? revisionMark = getRevisionMarkById(
      taskId: taskId,
      parentId: parentId,
    );
    return revisionMark == null ? null : '-' + revisionMark;
  }

  String taskNumber(String taskNoId, String taskId) {
    List<String> splitTaskNoId = taskNoId.split(';');
    return splitTaskNoId.first +
        (getRevisionMarkWithDash(taskId: taskId) ?? '');
  }

  removeDeletedIds(List<String?> ids) {
    List<String?> taskIds = (loading || documents.isEmpty || ids.isEmpty)
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
