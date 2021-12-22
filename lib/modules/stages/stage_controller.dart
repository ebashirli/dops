import 'dart:math';

import 'package:dops/components/value_table_view_widget.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/constants/lists.dart';
import 'package:dops/modules/drawing/drawing_model.dart';
import 'package:dops/modules/staff/staff_model.dart';
import 'package:dops/modules/stages/stage_model.dart';
import 'package:dops/modules/stages/stage_repository.dart';
import 'package:dops/modules/task/task_model.dart';
import 'package:dops/modules/values/value_model.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/custom_widgets.dart';

class StageController extends GetxService {
  final _repository = Get.find<StageRepository>();
  static StageController instance = Get.find();

  final RxList<bool> isExpandedList =
      List<bool>.generate(9, (int index) => false, growable: false).obs;

  final List<List<GlobalKey<FormState>>> formKeysList =
      List<List<GlobalKey<FormState>>>.generate(
    9,
    (int index) => [
      GlobalKey<FormState>(),
      GlobalKey<FormState>(),
    ],
    growable: false,
  );

  late final List<List<String>> assigningEmployeeIdsList;

  late final List<Map<String, TextEditingController>?>
      controllersListForNumberFields;

  // late final List<Map<String, int>> valueSumList;

  late final List<TextEditingController> controllersListForNote;

  late final List<List<List<String?>>> stageNotesList;

  late RxList<List<String>> fileNamesList;

  late RxList<String> commentStatus;

  final Rx<bool> isCoordinator = false.obs;

  final Rx<bool> isChecked = false.obs;

  RxList<StageModel> _documents = RxList<StageModel>([]);
  List<StageModel> get documents => _documents;

  List<String?> numberFieldNames(int index) =>
      stageDetailsList[index]['number fields']['name'];

  @override
  void onInit() async {
    super.onInit();
    drawingController
      ..drawingNumberController = TextEditingController()
      ..nextRevisionNumberController = TextEditingController()
      ..drawingTitleController = TextEditingController()
      ..drawingNoteController = TextEditingController()
      ..taskNoteController = TextEditingController()
      ..areaList = []
      ..designDrawingsList = []
      ..activityCodeIdText = ''
      ..moduleNameText = ''
      ..levelText = ''
      ..functionalAreaText = ''
      ..structureTypeText = '';

    assigningEmployeeIdsList = List<List<String>>.generate(
      9,
      (int index) => <String>[],
      growable: false,
    );

    controllersListForNumberFields =
        List<Map<String, TextEditingController>?>.generate(9, (index) {
      Map<String, TextEditingController> map = {};

      if (numberFieldNames(index).isNotEmpty) {
        numberFieldNames(index).forEach((String? fieldName) {
          map[fieldName!.toLowerCase()] = TextEditingController();
        });
      }
      return map;
    });

    controllersListForNote =
        List.generate(9, (index) => TextEditingController());

    stageNotesList = List.generate(9, (index) => <List<String?>>[]);

    fileNamesList = List.generate(9, (index) => <String>[]).obs;

    commentStatus = ['', ''].obs;

    _documents.bindStream(_repository.getAllDocumentsAsStream());
  }

  Future<String> addNew({required StageModel model}) async {
    CustomFullScreenDialog.showDialog();
    model.creationDateTime = DateTime.now();
    await _repository.add(model).then((value) => model.id = value);
    CustomFullScreenDialog.cancelDialog();
    return model.id!;
  }

  @override
  void onReady() {
    super.onReady();
  }

  Widget buildEditForm() {
    isCoordinator.value = staffController.documents
            .singleWhere((staff) => staff.id == auth.currentUser!.uid)
            .systemDesignation ==
        'Coordinator';
    if (taskController.documents.isNotEmpty) {
      TaskModel taskModel = taskController.documents
          .where((task) => task!.id == Get.parameters['id'])
          .toList()[0]!;

      DrawingModel drawingModel = drawingController.documents
          .where((drawing) => drawing.id == taskModel.parentId)
          .toList()[0];

      drawingController.fillEditingControllers(
        drawingModel: drawingModel,
        taskModel: taskModel,
      );
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: drawingController.drawingFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Container(
            width: Get.width * .5,
            child: Column(
              children: [
                Container(
                  height: 220,
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
                                activityController.documents
                                    .where(
                                      (activity) =>
                                          activity.id ==
                                          drawingController.activityCodeIdText,
                                    )
                                    .toList()[0]
                                    .activityId!,
                              ],
                              onChanged: (value) {
                                drawingController.activityCodeIdText =
                                    activityController.documents
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
                              controller:
                                  drawingController.drawingNumberController,
                              labelText: 'Drawing Number',
                            ),
                            CustomTextFormField(
                              controller:
                                  drawingController.drawingTitleController,
                              labelText: 'Drawing Title',
                            ),
                            CustomDropdownMenu(
                              labelText: 'Module name',
                              selectedItems: [drawingController.moduleNameText],
                              onChanged: (value) {
                                drawingController.moduleNameText = value ?? '';
                              },
                              items: dropdownSourcesController
                                  .document.value.modules!,
                            ),
                            CustomDropdownMenu(
                              showSearchBox: true,
                              labelText: 'Level',
                              selectedItems: [drawingController.levelText],
                              onChanged: (value) {
                                drawingController.levelText = value ?? '';
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
                              onChanged: (values) =>
                                  drawingController.areaList = values,
                              selectedItems: drawingController.areaList,
                            ),
                            CustomDropdownMenu(
                              showSearchBox: true,
                              labelText: 'Functional Area',
                              selectedItems: [
                                drawingController.functionalAreaText
                              ],
                              onChanged: (value) {
                                drawingController.functionalAreaText =
                                    value ?? '';
                              },
                              items: dropdownSourcesController
                                  .document.value.functionalAreas!,
                            ),
                            CustomDropdownMenu(
                              showSearchBox: true,
                              labelText: 'Structure Type',
                              selectedItems: [
                                drawingController.structureTypeText
                              ],
                              onChanged: (value) {
                                drawingController.structureTypeText =
                                    value ?? '';
                              },
                              items: dropdownSourcesController
                                  .document.value.structureTypes!,
                            ),
                            CustomTextFormField(
                              controller:
                                  drawingController.drawingNoteController,
                              labelText: 'Note',
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              '${drawingModel.drawingNumber}-${taskModel.revisionNumber}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            CustomTextFormField(
                              controller: drawingController
                                  .nextRevisionNumberController,
                              labelText: 'Next Revision number',
                            ),
                            CustomDropdownMenu(
                              isMultiSelectable: true,
                              labelText: 'Design Drawings',
                              items: referenceDocumentController.documents
                                  .map((document) => document.documentNumber)
                                  .toList(),
                              onChanged: (values) =>
                                  drawingController.designDrawingsList = values,
                              selectedItems:
                                  drawingController.designDrawingsList,
                            ),
                            CustomTextFormField(
                              controller: drawingController.taskNoteController,
                              labelText: 'Note',
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    if (isCoordinator.value)
                      ElevatedButton(
                        onPressed: () {
                          DrawingModel revisedOrNewModel = DrawingModel(
                            activityCodeId:
                                drawingController.activityCodeIdText,
                            drawingNumber:
                                drawingController.drawingNumberController.text,
                            drawingTitle:
                                drawingController.drawingTitleController.text,
                            level: drawingController.levelText,
                            module: drawingController.moduleNameText,
                            structureType: drawingController.structureTypeText,
                            note: drawingController.drawingNoteController.text,
                            area: drawingController.areaList,
                            functionalArea:
                                drawingController.functionalAreaText,
                          );

                          Map<String, dynamic> updatedTaskFields = {
                            'revisionNumber': drawingController
                                .nextRevisionNumberController.text,
                            'designDrawings':
                                drawingController.designDrawingsList,
                            'note': drawingController.taskNoteController.text,
                          };

                          drawingController.updateDrawing(
                            updatedModel: revisedOrNewModel,
                            id: drawingModel.id!,
                          );

                          taskController.updateTaskFields(
                            map: updatedTaskFields,
                            id: taskModel.id!,
                          );
                          // TODO: Ask Ismail: update last revision details from here?
                        },
                        child: Text('Update'),
                      ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return CircularProgressIndicator();
    }
  }

  buildPanel() {
    RxList<StageModel> taskStages = documents
        .where((stage) => stage.taskId == Get.parameters['id'])
        .toList()
        .obs;

    taskStages.sort((a, b) => a.creationDateTime.compareTo(b.creationDateTime));

    final int maxIndex =
        taskStages.map((stageModel) => stageModel.index).reduce(max);

    return Padding(
      padding: const EdgeInsets.only(bottom: 200),
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) =>
            isExpandedList[index] = !isExpanded,
        children: List.generate(
          maxIndex + 1,
          (index) {
            List<StageModel> stageStageModels = taskStages
                .where((stageModel) => stageModel.index == index)
                .toList();

            stageStageModels.sort(
                (a, b) => a.creationDateTime.compareTo(b.creationDateTime));

            // TODO: add isStageSkipped field to StageModel

            // final bool isStageSkipped = false;

            bool coordinatorAssigns = true;
            bool isCurrentUserAssigned = false;
            bool isSubmitted = false;
            int unsubmittedCount = 0;

            Map<String?, int?> totalValues = numberFieldNames(index).isNotEmpty
                ? Map<String, int>.fromIterable(
                    numberFieldNames(index),
                    key: (fieldName) => fieldName.toLowerCase(),
                    value: (element) => 0,
                  )
                : {};

            List<Map<String?, String?>?> notesList = [];

            List<List<ValueModel?>?> stageValueModelsLists = [];

            if (valueController.documents.isNotEmpty &&
                valueController.documents
                    .where((vm) => vm!.isHidden == false)
                    .isNotEmpty) {
              stageValueModelsLists = stageStageModels
                  .map((stageModel) => valueController.documents
                      .where((valueModel) =>
                          valueModel!.isHidden == false &&
                          valueModel.stageId == stageModel.id!)
                      .toList())
                  .toList();

              unsubmittedCount = stageValueModelsLists.last!.length;

              if (stageValueModelsLists.last!.isNotEmpty) {
                coordinatorAssigns = false;

                stageValueModelsLists.last!.forEach((valueModel) {
                  assigningEmployeeIdsList[index].add(staffController.documents
                      .singleWhere((staffModel) =>
                          staffModel.id == valueModel!.employeeId)
                      .id!);

                  if (valueModel!.employeeId == auth.currentUser!.uid &&
                      valueModel.isHidden != true) {
                    isCurrentUserAssigned = true;
                    if (valueModel.submitDateTime != null) {
                      isSubmitted = true;
                    }
                  }

                  if (valueModel.submitDateTime != null) {
                    notesList.add({
                      'employeeId': valueModel.employeeId,
                      'note': valueModel.note
                    });

                    totalValues.forEach((key, value) {
                      if (valueModel.employeeId == auth.currentUser!.uid) {
                        controllersListForNumberFields[index]![key]!.text =
                            valueModel.toMap()[key].toString();
                      }
                      totalValues[key] =
                          totalValues[key]! + (valueModel.toMap()[key]) as int;
                    });

                    unsubmittedCount--;
                  }
                });
              }
            }
            return ExpansionPanel(
              canTapOnHeader: true,
              isExpanded: isExpandedList[index],
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text(
                    '${index + 1} | ${stageDetailsList[index]['name']}',
                  ),
                );
              },
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    if (((!coordinatorAssigns && unsubmittedCount != 0) ||
                            coordinatorAssigns) &&
                        isCoordinator.value)
                      Column(
                        children: [
                          Form(
                            key: formKeysList[index][0],
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          width: 350,
                                          child: [0, 6, 7].contains(index)
                                              ? DropdownSearch<StaffModel>(
                                                  enabled: isCoordinator
                                                          .value &&
                                                      taskStages.last.index ==
                                                          index,
                                                  selectedItem: assigningEmployeeIdsList[
                                                              index]
                                                          .isNotEmpty
                                                      ? staffController
                                                          .documents
                                                          .firstWhere(
                                                              (staffModel) =>
                                                                  staffModel
                                                                      .id ==
                                                                  assigningEmployeeIdsList[
                                                                      index][0])
                                                      : null,
                                                  items:
                                                      staffController.documents,
                                                  itemAsString: (StaffModel?
                                                          item) =>
                                                      '${item!.name} ${item.surname}',
                                                  mode: Mode.MENU,
                                                  dropdownSearchDecoration:
                                                      InputDecoration(
                                                    labelText:
                                                        stageDetailsList[index]
                                                            ['staff job'],
                                                    contentPadding:
                                                        EdgeInsets.fromLTRB(
                                                            12, 12, 0, 0),
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                  showSearchBox: true,
                                                  onChanged: (employee) {
                                                    assigningEmployeeIdsList[
                                                        index] = [
                                                      employee!.id!
                                                    ];
                                                  },
                                                )
                                              : DropdownSearch<
                                                  StaffModel>.multiSelection(
                                                  enabled: isCoordinator
                                                          .value &&
                                                      taskStages.last.index ==
                                                          index,
                                                  selectedItems: staffController
                                                      .documents
                                                      .where((element) =>
                                                          assigningEmployeeIdsList[
                                                                  index]
                                                              .contains(
                                                                  element.id))
                                                      .toList(),
                                                  items:
                                                      staffController.documents,
                                                  itemAsString: (StaffModel?
                                                          employee) =>
                                                      '${employee!.name} ${employee.surname}',
                                                  // maxHeight: 300,
                                                  mode: Mode.MENU,
                                                  dropdownSearchDecoration:
                                                      InputDecoration(
                                                    labelText:
                                                        stageDetailsList[index]
                                                            ['staff job'],
                                                    contentPadding:
                                                        EdgeInsets.fromLTRB(
                                                            12, 12, 0, 0),
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                  showSearchBox: true,
                                                  onChanged: (employees) {
                                                    assigningEmployeeIdsList[
                                                            index] =
                                                        employees
                                                            .map((employee) =>
                                                                employee.id!)
                                                            .toList();
                                                  },
                                                ),
                                        ),
                                        SizedBox(height: 10),
                                      ],
                                    ),
                                    SizedBox(width: 10),
                                    if (isCoordinator.value &&
                                        taskStages.last.index == index)
                                      ElevatedButton(
                                        onPressed: () {
                                          _onAssignOrUpdatePressed(
                                            index: index,
                                            lastStageId:
                                                stageStageModels.last.id!,
                                            assigningEmployeeIds:
                                                assigningEmployeeIdsList[index]
                                                    .toSet(),
                                            assignedEmployeeIds:
                                                coordinatorAssigns
                                                    ? null
                                                    : stageValueModelsLists
                                                        .last!
                                                        .map((valueModel) =>
                                                            valueModel!
                                                                .employeeId)
                                                        .toSet(),
                                          );
                                        },
                                        child: Container(
                                          height: 48,
                                          child: Center(
                                            child: Text(
                                              (coordinatorAssigns)
                                                  ? 'Assign'
                                                  : 'Update',
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Divider(),
                        ],
                      ),
                    if (stageDetailsList[index]['get files'] != null)
                      ElevatedButton(
                        onPressed: () {
                          
                        },
                        child: Container(
                          height: 48,
                          width: 100,
                          child: Center(
                            child: Text(stageDetailsList[index]['get files']),
                          ),
                        ),
                      ),
                    if (!coordinatorAssigns)
                      Form(
                        key: formKeysList[index][1],
                        child: Column(
                          children: [
                            ValueTableView(
                              index: index,
                              stageValueModelsList: stageValueModelsLists.last!,
                            ),
                            if (isCurrentUserAssigned && !isSubmitted)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (index == 7)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Checkbox(
                                          checkColor: Colors.white,
                                          value: isChecked.value,
                                          onChanged: (bool? value) {
                                            isChecked.value = value!;
                                          },
                                        ),
                                        Text(
                                          'By clicking this checkbox I confirm that all files\nare attached correctly and below appropriate task',
                                        ),
                                      ],
                                    ),
                                  SizedBox(width: 10),
                                  ElevatedButton(
                                    onPressed: ([5, 6].contains(index) &&
                                            commentStatus[index - 5] == "")
                                        ? null
                                        : () {
                                            _onSubmitPressed(
                                              index: index,
                                              assignedValueModel:
                                                  stageValueModelsLists.last!
                                                      .singleWhere(
                                                          (valueModel) =>
                                                              valueModel!
                                                                  .employeeId ==
                                                              auth.currentUser!
                                                                  .uid)!,
                                              lastTaskStage:
                                                  stageStageModels.last,
                                              isCommented: [5, 6]
                                                      .contains(index)
                                                  ? commentStatus[index - 5] ==
                                                      'With'
                                                  : false,
                                              isLastSubmit:
                                                  unsubmittedCount == 1,
                                            );
                                          },
                                    child: Container(
                                      height: 20,
                                      child:
                                          Center(child: const Text('Submit')),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                ],
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _onAssignOrUpdatePressed({
    required int index,
    required String lastStageId,
    required Set assigningEmployeeIds,
    Set? assignedEmployeeIds,
  }) async {
    ValueModel vm = await ValueModel(
      stageId: lastStageId,
      employeeId: '',
      assignedBy: auth.currentUser!.uid,
      assignedDateTime: DateTime.now(),
    );
    if (assignedEmployeeIds == null) {
      // asigning
      assigningEmployeeIds.forEach((employeeId) async {
        vm.employeeId = employeeId;
        valueController.addNew(model: vm);
      });
    } else {
      // updating
      assigningEmployeeIds
          .difference(assignedEmployeeIds)
          .forEach((employeeId) async {
        vm.employeeId = employeeId;
        valueController.addNew(model: vm);
      });
      assignedEmployeeIds
          .difference(assigningEmployeeIds)
          .forEach((employeeId) async {
        final String valueId = valueController.documents
            .singleWhere(
              (valueModel) => (valueModel!.isHidden == false &&
                  valueModel.stageId == lastStageId &&
                  valueModel.employeeId == employeeId),
            )!
            .id!;
        valueController.addValues(map: {'isHidden': true}, id: valueId);
      });
    }
  }

  void _onSubmitPressed({
    required int index,
    required ValueModel assignedValueModel,
    required StageModel lastTaskStage,
    required bool isLastSubmit,
    bool isCommented = false,
  }) async {
    Map<String, dynamic> map = {};

    numberFieldNames(index).forEach(
      (String? fieldName) {
        if (fieldName != null) {
          map[fieldName.toLowerCase()] = int.parse(
            controllersListForNumberFields[index]![fieldName.toLowerCase()]!
                .text,
          );
        }
      },
    );

    map['note'] = controllersListForNote[index].text;
    map['fileNames'] = fileNamesList[index];
    map['submitDateTime'] = DateTime.now();
    map['isCommented'] = isCommented;

    valueController.addValues(
      map: map,
      id: assignedValueModel.id!,
    );

    print('isLastSubmit' + isLastSubmit.toString());

    if (isLastSubmit) {
      bool anyComment = await valueController.documents.any((valueModel) =>
              valueModel!.stageId == lastTaskStage.id &&
              valueModel.isCommented) ||
          isCommented;

      StageModel stage = StageModel(
        taskId: lastTaskStage.taskId,
        index: anyComment ? 4 : index + 1,
        checkerCommentCounter: (isCommented && index == 5)
            ? lastTaskStage.checkerCommentCounter + 1
            : 0,
        reviewerCommentCounter: (isCommented && index == 6)
            ? lastTaskStage.reviewerCommentCounter + 1
            : 0,
        creationDateTime: DateTime.now(),
      );

      String nextStageId = await addNew(model: stage);

      if (index == 3 || ((index == 5 || index == 6) && anyComment)) {
        final String? designingId = await documents
            .singleWhere((stageModel) =>
                stageModel.index == 1 &&
                stageModel.taskId == lastTaskStage.taskId)
            .id;

        final String? draftingId = await documents
            .singleWhere((stageModel) =>
                stageModel.index == 2 &&
                stageModel.taskId == lastTaskStage.taskId)
            .id;

        final List<String?> designerIds = valueController.documents
            .where((valueModel) => valueModel!.stageId == designingId)
            .map((valueModel) => valueModel!.employeeId)
            .toList();
        final List<String?> drafterIds = valueController.documents
            .where((valueModel) => valueModel!.stageId == draftingId)
            .map((valueModel) => valueModel!.employeeId)
            .toList();

        [...designerIds, ...drafterIds].toSet().forEach((designerId) {
          valueController.addNew(
            model: ValueModel(
              stageId: nextStageId,
              employeeId: designerId,
              assignedBy: auth.currentUser!.uid,
              assignedDateTime: DateTime.now(),
            ),
          );
        });
      } else if (index == 4) {
        final String? checkingId = await documents
            .singleWhere((stageModel) =>
                stageModel.index == 3 &&
                stageModel.taskId == lastTaskStage.taskId)
            .id;
        final List<String?> checkerIds = valueController.documents
            .where((valueModel) => valueModel!.stageId == checkingId)
            .map((valueModel) => valueModel!.employeeId)
            .toList();

        checkerIds.forEach((checkerId) {
          valueController.addNew(
            model: ValueModel(
              stageId: nextStageId,
              employeeId: checkerId,
              assignedBy: auth.currentUser!.uid,
              assignedDateTime: DateTime.now(),
            ),
          );
        });
      }
    }
  }
}
