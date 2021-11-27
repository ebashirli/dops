import 'package:dops/constants/table_details.dart';
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
  List<TaskModel> get documents => _documents;

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
    } else {
      drawingController.buildAddEdit(id: id, newRev: newRev);
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
                                documents
                                    .where((documents) => documents.id == id)
                                    .toList()[0]
                                    .drawingNumber,
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
                                    .map((document) => document.documentNumber)
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
                              drawingNumber: drawingController.documents
                                  .where((drawing) => drawing.id == id)
                                  .toList()[0]
                                  .drawingNumber,
                              designDrawings: designDrawingsList,
                              nextRevisionNumber:
                                  nextRevisionNumberController.text,
                              note: noteController.text,
                              revisionCount: documents
                                      .where((task) => task.id == id)
                                      .toList()[0]
                                      .revisionCount! +
                                  1,
                            );

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
  }

  List<Map<String, dynamic>> get getDataForTableView {
    List<String> mapPropNames = mapPropNamesGetter('task');

    return documents.map(
      (task) {
        Map<String, dynamic> map = {};
        final DrawingModel drawing = drawingController.documents
            .where((drawing) => drawing.drawingNumber == task.drawingNumber)
            .toList()[0];

        mapPropNames.forEach(
          (mapPropName) {
            switch (mapPropName) {
              case 'id':
                map[mapPropName] = task.id!;
                break;
              case 'priority':
                map[mapPropName] = activityController.documents.indexOf(
                        activityController.documents
                            .where((activity) =>
                                activity.activityId == drawing.activityCode)
                            .toList()[0]) +
                    1;
                break;
              case 'taskCreateDate':
                map[mapPropName] = task.taskCreateDate;
                break;
              case 'coverSheetRevision':
                map[mapPropName] = task.nextRevisionNumber;
                break;
              case 'issueType':
                map[mapPropName] = task.issueType;
                break;
              case 'revisionNumber':
                map[mapPropName] = task.revisionCount;
                break;
              case 'percentage':
                map[mapPropName] = task.percentage;
                break;
              case 'revisionStatus':
                map[mapPropName] = task.revisionStatus;
                break;
              case 'changeNumber':
                map[mapPropName] = task.changeNumber;
                break;
              case 'drawingNumber':
                map[mapPropName] = '${task.drawingNumber}|${task.id}';
                break;
              case 'designDrawings':
                map[mapPropName] = '${task.designDrawings.join(';')}';
                break;
              default:
                map[mapPropName] = drawing.toMap()[mapPropName];
                break;
            }
          },
        );
        return map;
      },
    ).toList();
  }
}
