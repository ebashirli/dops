import 'package:dops/components/custom_widgets.dart';
import 'package:dops/components/select_item_snackbar.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/modules/stages/stage_model.dart';
import 'package:dops/modules/task/widgets/task_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'task_model.dart';
import 'task_repository.dart';

class TaskController extends GetxService {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _repository = Get.find<TaskRepository>();
  static TaskController instance = Get.find();

  late TextEditingController nextRevisionMarkController, taskNoteController;
  late List<String> referenceDocumentsList;

  RxList<TaskModel> _documents = RxList<TaskModel>([]);
  List<TaskModel?> get documents => _documents;

  @override
  void onInit() {
    super.onInit();
    nextRevisionMarkController = TextEditingController();
    taskNoteController = TextEditingController();
    referenceDocumentsList = [];

    _documents.bindStream(_repository.getAllDocumentsAsStream());
  }

  Future<String> addNew({required TaskModel model}) async {
    CustomFullScreenDialog.showDialog();
    model.taskCreateDate = DateTime.now();
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
    referenceDocumentsList = [];
  }

  void fillEditingControllers(String id) {
    TaskModel taskModel = documents.singleWhere((e) => e!.id == id)!;
    nextRevisionMarkController.text = taskModel.revisionMark;
    taskNoteController.text = taskModel.note;
    referenceDocumentsList = taskModel.referenceDocuments;
  }

  buildAddEdit({
    String? id,
    bool newRev = false,
  }) {
    if (homeController.dataGridController.value.selectedRow == null) {
      selectItemSnackbar();
    } else {
      id = homeController.dataGridController.value.selectedRow!
          .getCells()[0]
          .value;
    }

    newRev ? clearEditingControllers() : fillEditingControllers(id!);

    formDialog(
      id: id,
      newRev: newRev,
    );
  }

  formDialog({
    String? id,
    bool newRev = false,
  }) {
    Get.defaultDialog(
      barrierDismissible: false,
      radius: 12,
      titlePadding: EdgeInsets.only(top: 20, bottom: 20),
      title: newRev ? 'Add next revision' : 'Update current revision',
      content: TaskForm(
        id: id,
        newRev: newRev,
      ),
    );
  }

  List<Map<String, dynamic>> get getDataForTableView {
    return drawingController.documents.map(
      (drawing) {
        TaskModel task = TaskModel(
          id: null,
          revisionMark: '',
          revisionCount: 0,
          referenceDocuments: [],
          note: '',
        );

        if (documents.isNotEmpty) {
          List<TaskModel?> drawingTasks =
              documents.where((task) => task!.parentId == drawing.id).toList();

          if (drawingTasks.isNotEmpty) {
            drawingTasks
                .sort((a, b) => b!.revisionCount.compareTo(a!.revisionCount));

            task = drawingTasks[0]!;
          }
        }

        Map<String, dynamic> map = {
          'id': task.id ?? null,
          'parentId': drawing.id,
          'priority': activityController.documents.indexOf(activityController
                  .documents
                  .where((activity) => activity.id == drawing.activityCodeId)
                  .toList()[0]) +
              1,
          'activityCode': activityController.documents
              .where((activity) => activity.id == drawing.activityCodeId)
              .toList()[0]
              .activityId,
          'drawingNumber': '${drawing.drawingNumber}|${task.id}',
          'revisionMark': task.revisionMark,
          'drawingTitle': drawing.drawingTitle,
          'drawingTag': drawing.drawingTag,
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
          'referenceDocuments': '${task.referenceDocuments.join(';')}',
          'changeNumber': task.changeNumber,
          'taskCreateDate': task.taskCreateDate ?? '',
        };
        return map;
      },
    ).toList();
  }

  void onAddNextRevisionPressed(String? parentId) {
    TaskModel newTaskModel = TaskModel(
      parentId: parentId,
      referenceDocuments: referenceDocumentsList,
      revisionMark: nextRevisionMarkController.text,
      note: taskNoteController.text,
      revisionCount: documents.length == 0
          ? 1
          : documents
                  .where((task) {
                    return task!.parentId == parentId;
                  })
                  .toList()
                  .length +
              1,
    );
    newTaskModel.changeNumber = newTaskModel.revisionCount == 1
        ? 0
        : (documents.length - drawingController.documents.length) + 1;

    addNew(model: newTaskModel).then((taskId) {
      StageModel stage = StageModel(
        taskId: taskId,
        creationDateTime: DateTime.now(),
      );
      stageController.addNew(model: stage);
    });
  }

  void onUpdatePressed({required String id}) {
    TaskModel taskModel = documents.singleWhere((e) => e!.id == id)!;
    print(taskModel.revisionMark + id);

    Map<String, dynamic> map = {
      if (nextRevisionMarkController.text != taskModel.revisionMark)
        'revisionMark': nextRevisionMarkController.text,
      if (taskNoteController.text != taskModel.note)
        'note': taskNoteController.text,
      if (referenceDocumentsList != taskModel.referenceDocuments)
        'referenceDocuments': referenceDocumentsList,
    };

    updateTaskFields(map: map, id: id);
  }

  void onDeletePressed(String id) {
    deleteTask(id);
    Get.back();
  }
}
