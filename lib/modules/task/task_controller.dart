import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/modules/drawing/drawing_model.dart';
import 'package:dops/modules/stages/stage_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/style.dart';
import 'task_model.dart';
import 'task_repository.dart';

class TaskController extends GetxService {
  final GlobalKey<FormState> taskFormKey = GlobalKey<FormState>();
  final _repository = Get.find<TaskRepository>();
  static TaskController instance = Get.find();

  late TextEditingController nextRevisionNumberController, taskNoteController;
  late List<String> designDrawingsList;

  RxList<TaskModel> _documents = RxList<TaskModel>([]);
  RxList<TaskModel?> get documents => _documents;

  @override
  void onInit() {
    super.onInit();
    nextRevisionNumberController = TextEditingController();
    taskNoteController = TextEditingController();
    designDrawingsList = [];

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
    final isValid = drawingController.drawingFormKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    drawingController.drawingFormKey.currentState!.save();
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
    nextRevisionNumberController.clear();
    designDrawingsList = [];
    taskNoteController.clear();
  }

  buildAddEdit({String? id, String? parentId, bool newRev = false}) {
    if (!newRev) {
      drawingController.buildAddEdit(
        drawingId: parentId,
        taskId: id,
      );
    } else {
      clearEditingControllers();

      DrawingModel selectedDrawing = drawingController.documents
          .where((drawing) => drawing.id == parentId)
          .toList()[0];

      final TaskModel? selectedTask = (documents.isNotEmpty && id != null)
          ? documents.where((task) => task!.id == id).toList()[0]
          : null;

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
                                  'Current Revision: ${selectedDrawing.drawingNumber}${selectedTask != null ? '-' + selectedTask.revisionNumber : ''}',
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
                                  showSearchBox: true,
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
                          ElevatedButton(
                            onPressed: () => Get.back(),
                            child: const Text('Cancel'),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () => onAddNextRevisionPressed(parentId),
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
    }
  }

  List<Map<String, dynamic>> get getDataForTableView {
    return drawingController.documents.map(
      (drawing) {
        TaskModel task = TaskModel(
          id: null,
          revisionNumber: '',
          revisionCount: 0,
          designDrawings: [],
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
        return map;
      },
    ).toList();
  }

  void onAddNextRevisionPressed(String? parentId) {
    TaskModel newTaskModel = TaskModel(
      parentId: parentId,
      designDrawings: designDrawingsList,
      revisionNumber: nextRevisionNumberController.text,
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
}
