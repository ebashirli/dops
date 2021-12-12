import 'dart:math';

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
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import '../../components/custom_widgets.dart';

class StageController extends GetxController {
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

  late final List<List<String>> assignedEmployeeIdsList;

  late final List<DateTime?> firstAssignDateTimeList;

  late final List<Map<String, TextEditingController>> controllersListForNumberFields;

  // late final List<Map<String, int>> valueSumList;

  late final List<TextEditingController> controllersListForNote;

  late final List<List<List<String?>>> stageNotesList;

  late List<List<String>> filesList;

  late List<String> commentStatus;

  final Rx<bool> isCoordinator = false.obs;

  final Rx<bool> isChecked = false.obs;

  RxList<StageModel> _documents = RxList<StageModel>([]);
  List<StageModel> get documents => _documents;

  @override
  void onInit() {
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
    

    assignedEmployeeIdsList = List<List<String>>.generate(
      9,
      (int index) => <String>[],
      growable: false,
    );

    firstAssignDateTimeList = List<DateTime?>.generate(
      9,
      (int index) => null,
      growable: false,
    );

    controllersListForNumberFields = List.generate(
      9, 
      (index) {
        Map<String, TextEditingController> map = {};
        stageDetailsList[index]['number fields']['name'].forEach(
          (String? fieldName){
            if(fieldName!=null) map[fieldName]=TextEditingController();
          });
        return map;
      });

    stageDetailsList
        .map((stage) => List.generate(stage['number fields']['name'].length,
            (index) => TextEditingController()))
        .toList();
    
    // valueSumList = List.generate(
    //   9,
    //   (index) {
    //     Map<String, int> map = {};
    //     stageDetailsList[index]['number fields']['name'].forEach((String? fieldName) {
    //       if(fieldName != null) map[fieldName] = 0;
    //     });
    //     return map;
    // });

    controllersListForNote =
        List.generate(9, (index) => TextEditingController());

    stageNotesList = List.generate(9, (index) => <List<String?>>[]);

    filesList = List.generate(9, (index) => <String>[]);

    commentStatus = ['', ''];
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

  void filling(
      {required List<StageModel> taskStages, required int maxIndex}) async {

    for (int index = 0; index <= maxIndex; index++) {

      StageModel taskStage =
          taskStages.lastWhere((stage) => stage.index == index);


      List<ValueModel> valueModels = await valueController.documents
          .where((valueModel) => valueModel.stageId == taskStage.id)
          .toList();

      assignedEmployeeIdsList[index] =
          valueModels.map((valueModel) => valueModel.employeeId).toList();

      firstAssignDateTimeList[index] = taskStage.creationDateTime;

      final numberFieldsLength =
          stageDetailsList[index]['number fields']['name'].length;
    
      // for (int indF = 0; indF < numberFieldsLength; indF++) {
      //   final int? fieldValueSum = valueModels
      //       .map((valueModel) => valueModel.toMap()[stageDetailsList[index]
      //               ['number fields']['name'][indF]
      //           .toLowerCase()])
      //       .toList()
      //       .reduce((a, b) => (a ?? 0) + (b ?? 0));
      //   controllersListForNumberFields[index][indF].text =
      //       '${fieldValueSum ?? ""}';
      // }

      stageNotesList[index] = valueModels
          .map((valueModel) => [valueModel.employeeId, valueModel.note])
          .toList();

      // controllersListForNote[index].text = valueModels
      //     .map((valueModel) =>
      //         valueModel.note != null ? '${valueModel.note}' : '')
      //     .toList()
      //     .reduce((a, b) => a + '\n' + b);
    }
  }

  buildPanel() {
    List<StageModel> taskStages = documents
        .where((stage) => stage.taskId == Get.parameters['id'])
        .toList();

    taskStages
        .sort((a, b) => a.creationDateTime!.compareTo(b.creationDateTime!));

    final RxInt maxIndex =
        taskStages.map((stageModel) => stageModel.index).reduce(max).obs;
    // filling(taskStages: taskStages, maxIndex: maxIndex.value);

    return Padding(
      padding: const EdgeInsets.only(bottom: 200),
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          isExpandedList[index] = !isExpanded;
        },
        children: List.generate(
          maxIndex.value + 1,
          (index) {
            List<StageModel?> stageStageModels = taskStages
                .where((stageModel) => stageModel.index == index)
                .toList();

            // TODO: add isStageSkipped field to StageModel

            final bool isStageSkipped = false;


            bool coordinatorAssigns = valueController.documents.isEmpty
                ? true
                : valueController.documents
                    .where((valueModel) =>
                        valueModel.stageId == stageStageModels.last!.id)
                    .isEmpty;

            List<List<ValueModel>> stageValueModelsLists = stageStageModels
                .map((stageModel) => valueController.documents
                    .where((valueModel) => valueModel.stageId == stageModel!.id)
                    .toList())
                .toList();


            stageValueModelsLists[index].forEach((valueModel) { 
              assignedEmployeeIdsList[index].add(staffController.documents.singleWhere((staffModel) => staffModel.id == valueModel.employeeId).id!);
              
              if(valueModel.employeeId == auth.currentUser!.uid) stageDetailsList[index]['number fields']['name'].forEach((String? fieldName){
                if(fieldName!=null) controllersListForNumberFields[index][fieldName] = valueModel.toMap()[fieldName.toLowerCase()];
              });
              
            });

            bool isCurrentUserAssigned = coordinatorAssigns
                ? false
                : stageValueModelsLists.last
                    .map((valueModel) => valueModel.employeeId)
                    .contains(auth.currentUser!.uid);

            bool isSubmitted = isCurrentUserAssigned
                ? stageValueModelsLists.last
                        .singleWhere(
                            (valueModel) => valueModel.employeeId == auth.currentUser!.uid)
                        .endDateTime !=
                    null
                : false;
            
            return ExpansionPanel(
              canTapOnHeader: true,
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
                                    child: [0, 6, 7, 8].contains(index)
                                        ? DropdownSearch<StaffModel>(
                                            enabled: isCoordinator.value,
                                            selectedItem: assignedEmployeeIdsList[
                                                        index]
                                                    .isNotEmpty
                                                ? staffController.documents
                                                    .firstWhere((staffModel) =>
                                                        staffModel.id ==
                                                        assignedEmployeeIdsList[
                                                            index][0])
                                                : null,
                                            items: staffController.documents,
                                            itemAsString: (StaffModel? item) =>
                                                '${item!.name} ${item.surname}',
                                            // maxHeight: 300,
                                            mode: Mode.MENU,
                                            dropdownSearchDecoration:
                                                InputDecoration(
                                              labelText: stageDetailsList[index]
                                                  ['staff job'],
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      12, 12, 0, 0),
                                              border: OutlineInputBorder(),
                                            ),
                                            showSearchBox: true,
                                            onChanged: (employee) {
                                              assignedEmployeeIdsList[index] = [
                                                employee!.id!
                                              ];
                                            },
                                          )
                                        : DropdownSearch<
                                            StaffModel>.multiSelection(
                                            enabled: isCoordinator.value,
                                            selectedItems: staffController
                                                .documents
                                                .where((element) =>
                                                    assignedEmployeeIdsList[
                                                            index]
                                                        .contains(element.id))
                                                .toList(),
                                            items: staffController.documents,
                                            itemAsString: (StaffModel?
                                                    employee) =>
                                                '${employee!.name} ${employee.surname}',
                                            // maxHeight: 300,
                                            mode: Mode.MENU,
                                            dropdownSearchDecoration:
                                                InputDecoration(
                                              labelText: stageDetailsList[index]
                                                  ['staff job'],
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      12, 12, 0, 0),
                                              border: OutlineInputBorder(),
                                            ),
                                            showSearchBox: true,
                                            onChanged: (employees) {
                                              assignedEmployeeIdsList[index] =
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
                              if (isCoordinator.value)
                                ElevatedButton(
                                  onPressed: (index !=
                                          stageStageModels.last!.index)
                                      ? null
                                      : () => _onAssignOrUpdatePressed(
                                          index,
                                          stageStageModels.last!.id!,
                                          coordinatorAssigns,
                                          stageValueModelsLists.last
                                              .map(
                                                  (valueModel) => valueModel.id)
                                              .toSet()),
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
                              SizedBox(width: 100),
                              Text(
                                firstAssignDateTimeList[index] != null
                                    ? 'Start date and time: ${DateFormat("dd-MM-yyyy HH:mm").format(firstAssignDateTimeList[index]!)}'
                                    : '',
                              ),
                            ],
                          ),
                          if (stageDetailsList[index]['get files'] != null)
                            ElevatedButton(
                              onPressed: () {},
                              child: Container(
                                height: 48,
                                width: 100,
                                child: Center(
                                  child: Text(
                                      stageDetailsList[index]['get files']),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Divider(),
                    Form(
                      key: formKeysList[index][1],
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Flexible(
                            flex: index == 7 ? 6 : 2,
                            child: Column(
                              children: <Widget>[
                                // number fields
                                if (stageDetailsList[index]['number fields']
                                        ['name']
                                    .isNotEmpty)
                                  Column(
                                    crossAxisAlignment: index < 5
                                        ? CrossAxisAlignment.center
                                        : CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Center(
                                        child: Text(
                                          'Submitted ' +
                                              stageDetailsList[index]
                                                  ['number fields']['suffix'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      if (index < 5)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Center(child: Text('Field')),
                                            if (isCurrentUserAssigned)
                                              Center(child: Text('By me')),
                                            Center(child: Text('Total')),
                                          ],
                                        ),
                                      SizedBox(height: 10),
                                      ...List.generate(
                                        stageDetailsList[index]['number fields']
                                                ['name']
                                            .length,
                                        (indexF) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(stageDetailsList[index]
                                                      ['number fields']['name']
                                                  [indexF]),
                                              if (isCurrentUserAssigned)
                                                CustomTextFormField(
                                                  isNumber: true,
                                                  controller:
                                                      controllersListForNumberFields[
                                                          index][indexF],
                                                  width: 80,
                                                ),
                                              if (index < 5) Text(
                                                stageValueModelsLists[index].map((valueModel) => valueModel.toMap()[stageDetailsList[index]['number fields']['name'][indexF].toLowerCase()]).reduce((p, c) => p+c).toString()
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                if (stageDetailsList[index]['isThereFiles'] !=
                                    null) // files button
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          FilePickerResult? result =
                                              await FilePicker.platform
                                                  .pickFiles(
                                            allowMultiple: true,
                                          );
                                          if (result != null) {
                                            filesList[index] = result.files
                                                .map((file) => file.name)
                                                .toList();
                                          }
                                        },
                                        child: Container(
                                          height: 48,
                                          width: 80,
                                          child: Center(
                                            child: Text('Browse files'),
                                          ),
                                        ),
                                      ),
                                      if ([2, 3, 4].contains(index))
                                        TextButton(
                                          onPressed: () {},
                                          style: TextButton.styleFrom(
                                            minimumSize: Size.zero,
                                            padding: EdgeInsets.zero,
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
                                          ),
                                          child: Text('20'),
                                        ),
                                    ],
                                  ),
                                if (stageDetailsList[index]['files'] != null)
                                  DataTable(
                                    columns: <DataColumn>[
                                      ...stageDetailsList[index]['files']
                                              ['columns']
                                          .map(
                                            (col) => DataColumn(
                                              label: Text(
                                                col,
                                                style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList()
                                    ],
                                    rows: <DataRow>[
                                      ...stageDetailsList[index]['files']
                                              ['rowsIds']
                                          .map(
                                        (ri) {
                                          return DataRow(
                                            cells: <DataCell>[
                                              DataCell(
                                                Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  width: 250,
                                                  child: Text(ri),
                                                ),
                                              ),
                                              DataCell(
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    FilePickerResult? result =
                                                        await FilePicker
                                                            .platform
                                                            .pickFiles(
                                                      allowMultiple: true,
                                                    );
                                                    if (result != null) {
                                                      filesList[index] = result
                                                          .files
                                                          .map((file) =>
                                                              file.name)
                                                          .toList();
                                                    }
                                                  },
                                                  child: Container(
                                                    height: 30,
                                                    width: 50,
                                                    child: Center(
                                                      child: Text('Files'),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              DataCell(TextButton(
                                                onPressed: () {},
                                                child: Text(
                                                  '${Random().nextInt(60)}',
                                                  style: TextStyle(
                                                      decoration: TextDecoration
                                                          .underline,
                                                      color: Colors.blue),
                                                ),
                                              )),
                                            ],
                                          );
                                        },
                                      ).toList(),
                                    ],
                                  )
                              ],
                            ),
                          ),
                          Spacer(flex: 3),
                          Flexible(
                            flex: 5,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (index == 7)
                                  Column(
                                    children: [
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
                                              '''By clicking this checkbox I confirm that all files
 are attached correctly and below appropriate task'''),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                if (stageNotesList[index].isNotEmpty)
                                  Container(
                                    width: double.infinity,
                                    height: 3 * 50,
                                    child: ListView.builder(
                                      itemCount: stageNotesList[index].length,
                                      itemBuilder: (context, ind) {
                                        return ListTile(
                                          leading: Text(stageNotesList[index]
                                                  [ind][0] ??
                                              ''),
                                          trailing: Text(
                                            stageNotesList[index][ind][1] ?? '',
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 15),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                if (isCurrentUserAssigned)
                                  CustomTextFormField(
                                    controller: controllersListForNote[index],
                                    labelText: stageDetailsList[index]
                                        ['string fields'][0],
                                    width: double.infinity,
                                    maxLines: 2,
                                  ),
                                SizedBox(width: 10),
                                Row(
                                  mainAxisAlignment: [5, 6].contains(index)
                                      ? MainAxisAlignment.spaceBetween
                                      : MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if ([5, 6].contains(index))
                                      CustomDropdownMenu(
                                          width: 200,
                                          labelText: 'Comment',
                                          onChanged: (value) =>
                                              commentStatus[index - 5] = value,
                                          selectedItems: [
                                            commentStatus[index - 5]
                                          ],
                                          items: [
                                            'With Comment',
                                            'No Comment'
                                          ]),
                                    if (isCurrentUserAssigned && !isSubmitted)
                                      ElevatedButton(
                                        onPressed: (index ==
                                                stageStageModels.last!.index)
                                            ? () => _onSubmitPressed(
                                                index, stageStageModels.last!)
                                            : null,
                                        child: Container(
                                          height: 46,
                                          child: Center(
                                            child: const Text(
                                              'Submit',
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              isExpanded: isExpandedList[index],
            );
          },
        ),
      ),
    );
  }

  void _onAssignOrUpdatePressed(
      int index, String stageId, bool isAssign, Set employeeIdsSet) async {
    final List<String> selectedEmployeeIds = assignedEmployeeIdsList[index];
    ValueModel value = await ValueModel(
      stageId: stageId,
      employeeId: '',
      assignedBy: auth.currentUser!.uid,
      assignedDateTime: DateTime.now(),
    );
    if (isAssign) {
      selectedEmployeeIds.forEach((employeeId) async {
        value.employeeId = employeeId;
      });
    } else {
      selectedEmployeeIds
          .toSet()
          .difference(employeeIdsSet)
          .forEach((employeeId) async => value.employeeId = employeeId);
      employeeIdsSet
          .difference(selectedEmployeeIds.toSet())
          .forEach((employeeId) async {
        final String valueId = valueController.documents
            .singleWhere((valueModel) => (valueModel.stageId == stageId &&
                valueModel.employeeId == employeeId))
            .id!;
        valueController.addValues(map: {'isHidden': true}, id: valueId);
      });
    }
    valueController.addNew(model: value);
  }

  void _onSubmitPressed(index, StageModel lastTaskStage) {
    ValueModel valueModel = valueController.documents.firstWhere((valueModel) =>
        valueModel.stageId == lastTaskStage.id &&
        valueModel.employeeId == auth.currentUser!.uid);

    Map<String, dynamic> map = {};

    // for (int indF = 0;
    //     indF < stageDetailsList[index]['number fields']['name'].length;
    //     indF++) {
    //   map[stageDetailsList[index]['number fields']['name'][indF]
    //           .toLowerCase()] =
    //       int.parse(controllersListForNumberFields[index][indF].text);
    // }
    map['note'] = controllersListForNote[index].text;
    map['endDateTime'] = DateTime.now();
    valueController.addValues(
      map: map,
      id: valueModel.id!,
    );

    // if(valueModel.employeeId != null)
    // StageModel stage = StageModel(
    //   taskId: taskId,
    //   index: index + 1,
    //   reviewerCommentCounter: isCommented ? lastTaskStage.reviewerCommentCounter + 1 : 0,
    //   checkerCommentCounter: isCommented ? lastTaskStage.checkerCommentCounter + 1 : 0,
    // );
    // addNew(model: stage);
  }
}
