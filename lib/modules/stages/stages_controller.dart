import 'package:dops/constants/constant.dart';
import 'package:dops/constants/lists.dart';
import 'package:dops/modules/drawing/drawing_model.dart';
import 'package:dops/modules/task/task_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../../components/custom_widgets.dart';

class StagesController extends GetxController {
  static StagesController instance = Get.find();

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

  final List<List<String>> selectedItemsList = List<List<String>>.generate(
    9,
    (int index) => [],
    growable: false,
  );

  final List controllersListForNumberFields = stageDetailsList
      .map((stage) => List.generate(
          stage['number fields'].length, (index) => TextEditingController()))
      .toList();

  final List controllersListForStringFields = stageDetailsList
      .map((stage) => List.generate(
          stage['string fields'].length, (index) => TextEditingController()))
      .toList();

  late List<List> filesList = List.generate(9, (index) => []);

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
  }

  @override
  void onReady() {
    super.onReady();
  }

  buildEditForm() {
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
                            items:
                                dropdownSourcesController.document.value.areas!,
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
                              drawingController.structureTypeText = value ?? '';
                            },
                            items: dropdownSourcesController
                                .document.value.structureTypes!,
                          ),
                          CustomTextFormField(
                            controller: drawingController.drawingNoteController,
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
                            controller:
                                drawingController.nextRevisionNumberController,
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
                            selectedItems: drawingController.designDrawingsList,
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
                  ElevatedButton(
                    onPressed: () {
                      DrawingModel revisedOrNewModel = DrawingModel(
                        activityCodeId: drawingController.activityCodeIdText,
                        drawingNumber:
                            drawingController.drawingNumberController.text,
                        drawingTitle:
                            drawingController.drawingTitleController.text,
                        level: drawingController.levelText,
                        module: drawingController.moduleNameText,
                        structureType: drawingController.structureTypeText,
                        note: drawingController.drawingNoteController.text,
                        area: drawingController.areaList,
                        functionalArea: drawingController.functionalAreaText,
                      );

                      Map<String, dynamic> updatedTaskFields = {
                        'revisionNumber':
                            drawingController.nextRevisionNumberController.text,
                        'designDrawings': drawingController.designDrawingsList,
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
  }

  Widget buildPanel() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 200),
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          isExpandedList[index] = !isExpanded;
        },
        children: List.generate(
          9,
          (index) => ExpansionPanel(
            canTapOnHeader: true,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(
                  '${index + 1} | ${stageDetailsList[index]['name']}',
                ),
              );
            },
            body: Container(
              decoration: BoxDecoration(
                color: Colors.amber[50],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(children: [
                  Form(
                    key: formKeysList[index][0],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomDropdownMenu(
                              showSearchBox: true,
                              width: 350,
                              isMultiSelectable: true,
                              labelText: stageDetailsList[index]['staff job'],
                              items: staffController.documents
                                  .map((e) => e.name)
                                  .toList(),
                              onChanged: (values) {
                                selectedItemsList[index] = values;
                              },
                              selectedItems: selectedItemsList[index],
                            ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                if (formKeysList[index][0]
                                    .currentState!
                                    .validate()) {}
                              },
                              child: Container(
                                height: 48,
                                child: Center(child: const Text('Assign')),
                              ),
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
                                child:
                                    Text(stageDetailsList[index]['get files']),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            if (stageDetailsList[index]['number fields']
                                    .length >
                                0) // number fields
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    stageDetailsList[index]['number fields']
                                        ['suffix'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  ...List.generate(
                                    stageDetailsList[index]['number fields']
                                        .length,
                                    (indexF) => CustomTextFormField(
                                      isNumber: true,
                                      controller:
                                          controllersListForNumberFields[index]
                                              [indexF],
                                      labelText: stageDetailsList[index]
                                          ['number fields']['name'][indexF],
                                      width: 80,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            if (stageDetailsList[index]['isThereFiles'] !=
                                null) // files button
                              ElevatedButton(
                                onPressed: () async {
                                  FilePickerResult? result =
                                      await FilePicker.platform.pickFiles(
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
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(width: 10),
                            if (stageDetailsList[index]['string fields']
                                    .length >
                                0) // string fields
                              ...List.generate(
                                stageDetailsList[index]['string fields'].length,
                                (indexF) => CustomTextFormField(
                                  controller:
                                      controllersListForStringFields[index]
                                          [indexF],
                                  labelText: stageDetailsList[index]
                                      ['string fields'][indexF],
                                  width: 500,
                                  maxLines: 3,
                                ),
                              ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                if (formKeysList[index][1]
                                    .currentState!
                                    .validate()) {}
                              },
                              child: Container(
                                height: 46,
                                child: Center(child: const Text('Finish Task')),
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
            isExpanded: isExpandedList[index],
          ),
        ),
      ),
    );
  }
}
