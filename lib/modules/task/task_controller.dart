import 'dart:math';

import 'package:dops/components/custom_widgets.dart';
import 'package:dops/components/select_item_snackbar.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/constants/lists.dart';
import 'package:dops/modules/drawing/drawing_model.dart';
import 'package:dops/modules/stages/stage_model.dart';
import 'package:dops/modules/task/widgets/task_form.dart';
import 'package:dops/modules/values/value_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  RxList<TaskModel> _documents = RxList<TaskModel>([]);
  List<TaskModel?> get documents =>
      _documents.where((e) => e.isHidden == false).toList();
  List<TaskModel?> get documentsAll => _documents;

  @override
  void onInit() {
    super.onInit();
    nextRevisionMarkController = TextEditingController();
    taskNoteController = TextEditingController();
    holdReasonController = TextEditingController();
    referenceDocumentsList = [];

    _documents.bindStream(_repository.getAllDocumentsAsStream());
  }

  Future<String> addNew({required TaskModel model}) async {
    CustomFullScreenDialog.showDialog();
    model.creationDate = DateTime.now();
    await _repository.add(model).then((value) => model.id = value);
    CustomFullScreenDialog.cancelDialog();
    Get.back();
    return model.id!;
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

  void deleteTask(String id) async {
    CustomFullScreenDialog.showDialog();
    await _repository.removeModel(id);
    CustomFullScreenDialog.cancelDialog();
    Get.back();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void clearEditingControllers() {
    nextRevisionMarkController.clear();
    taskNoteController.clear();
    holdReasonController.clear();
    isHeld.value = false;
    referenceDocumentsList = [];
  }

  void fillEditingControllers(String id) {
    TaskModel taskModel = documents.singleWhere((e) => e!.id == id)!;
    nextRevisionMarkController.text = taskModel.revisionMark;
    taskNoteController.text = taskModel.note ?? '';
    holdReasonController.text = taskModel.holdReason ?? '';
    referenceDocumentsList = taskModel.referenceDocuments;
    isHeld.value = taskModel.holdReason != null;
  }

  buildAddEdit({String? id, bool newRev = false, bool fromStages = false}) {
    String? drawingId = null;
    if (!fromStages) {
      if (homeController.dataGridController.value.selectedRow == null) {
        selectItemSnackbar();
      } else {
        id = homeController.dataGridController.value.selectedRow!
            .getCells()[0]
            .value;
        drawingId = homeController.dataGridController.value.selectedRow!
            .getCells()[1]
            .value;
      }
    }

    newRev ? clearEditingControllers() : fillEditingControllers(id!);

    formDialog(id: id, newRev: newRev, drawingId: drawingId);
  }

  formDialog({String? id, bool newRev = false, String? drawingId}) {
    Get.defaultDialog(
      barrierDismissible: false,
      radius: 12,
      titlePadding: EdgeInsets.only(top: 20, bottom: 20),
      title: newRev ? 'Add next revision' : 'Update current revision',
      content: TaskForm(
        id: id,
        newRev: newRev,
        drawingId: drawingId,
      ),
    );
  }

  List<Map<String, dynamic>> get getDataForTableView {
    return drawingController.documents.map(
      (drawing) {
        TaskModel task = TaskModel(
          id: null,
          revisionMark: '',
          referenceDocuments: [],
          note: '',
          changeNumber: 0,
        );

        if (documents.isNotEmpty) {
          List<TaskModel?> tasksOfDrawing =
              documents.where((e) => e!.parentId == drawing.id).toList();

          if (tasksOfDrawing.isNotEmpty) task = tasksOfDrawing.first!;
        }

        return {
          'id': task.id ?? null,
          'parentId': drawing.id,
          'priority': getPriorrity(drawing),
          'activityCode': getActivityCode(drawing),
          'drawingNumber': getDrawingNumber(drawing, task),
          'revisionMark': task.revisionMark,
          'drawingTitle': drawing.drawingTitle,
          'taskStatus': taskStatusProvider(task),
          'drawingTag': drawing.drawingTag,
          'module': drawing.module,
          'revisionType': getRevTypeAndStatus(task),
          'percentage': 0,
          'revisionStatus': getRevTypeAndStatus(task, isStatus: true),
          'hold': getActivityStatus(task),
          'holdReason': getHoldReason(task),
          'level': drawing.level,
          'structureType': drawing.structureType,
          'referenceDocuments': getReferenceDocuments(task),
          'changeNumber': task.changeNumber == 0 ? '' : task.changeNumber,
          'taskCreateDate': task.creationDate ?? '',
        };
      },
    ).toList();
  }

  String? getHoldReason(TaskModel task) => task.holdReason != null
      ? task.holdReason
      : stageController.containsHold(task)
          ? stageController
              .valueModelsByTaskId(task.id!)[7]!
              .values
              .first
              .first!
              .holdContainingReason
          : '';

  String getActivityStatus(TaskModel task) {
    return task.holdReason != null
        ? 'Hold'
        : task.id == null
            ? ''
            : stageController.containsHold(task)
                ? 'Contains Hold'
                : 'Live';
  }

  String taskStatusProvider(TaskModel task) {
    if (task.id == null) return '';


    List<Map<StageModel, List<ValueModel?>>?> valueModelsOfTask =
        stageController.valueModelsByTaskId(task.id!);

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

  void onAddNextRevisionPressed(String parentId) {
    int nextChangeNumber = documents.isEmpty
        ? 0
        : documents.where((e) => e!.parentId == parentId).isEmpty
            ? 0
            : documentsAll.map((e) => e!.changeNumber).reduce(max) + 1;

    TaskModel newTaskModel = TaskModel(
      parentId: parentId,
      referenceDocuments: referenceDocumentsList,
      revisionMark: nextRevisionMarkController.text,
      note: taskNoteController.text,
      changeNumber: nextChangeNumber,
    );

    addNew(model: newTaskModel).then((taskId) {
      StageModel stage = StageModel(
        taskId: taskId,
        creationDateTime: DateTime.now(),
      );
      stageController.addNew(model: stage).then((stageId) {
        TaskModel? taskModel = documents.isEmpty
            ? null
            : documents.firstWhere((e) => e!.parentId == parentId,
                orElse: null);
        if (taskModel != null) {
          StageModel firstStageModel = stageController.documents
              .firstWhere((e) => e!.taskId == taskModel.id)!;

          ValueModel firstValueModel = valueController.documents
              .firstWhere((e) => e!.stageId == firstStageModel.id)!;

          ValueModel valueModel = ValueModel(
            stageId: stageId,
            employeeId: firstValueModel.employeeId,
            assignedBy: firstValueModel.assignedBy,
            assignedDateTime: firstValueModel.assignedDateTime,
            phase: firstValueModel.phase,
            submitDateTime: firstValueModel.submitDateTime,
          );
          valueController.addNew(model: valueModel);
        }
      });
    });
  }

  void onUpdatePressed({required String id}) {
    TaskModel taskModel = documents.singleWhere((e) => e!.id == id)!;
    Map<String, dynamic> map = {
      if (nextRevisionMarkController.text != taskModel.revisionMark)
        'revisionMark': nextRevisionMarkController.text,
      if (taskNoteController.text != taskModel.note)
        'note': taskNoteController.text,
      if (holdReasonController.text != taskModel.holdReason || !isHeld.value)
        'holdReason': isHeld.value ? holdReasonController.text : null,
      if (referenceDocumentsList != taskModel.referenceDocuments)
        'referenceDocuments': referenceDocumentsList,
    };

    updateTaskFields(map: map, id: id);
  }

  void onDeletePressed(String id) {
    deleteTask(id);
    Get.back();
  }

  String? get selectedTaskId =>
      homeController.dataGridController.value.selectedRow!.getCells()[0].value;

  TaskModel? get selectedTask => documents.firstWhere(
        (e) => e!.id == selectedTaskId,
        orElse: null,
      );

  bool get isTaskCompleted {
    // TODO: Rearrage here
    final List<Map<StageModel, List<ValueModel?>>?> valueModelsMap =
        stageController.valueModelsByTaskId(
      homeController.dataGridController.value.selectedRow!
          .getCells()
          .first
          .value,
    );
    return valueModelsMap.length < 6
        ? false
        : !valueModelsMap.last!.values.last
            .map((e) => e!.submitDateTime)
            .contains(null);
  }
}
