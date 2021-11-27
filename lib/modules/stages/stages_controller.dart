import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dops/constants/lists.dart';
import 'package:dops/modules/dropdown_source/dropdown_sources_controller.dart';
import 'package:dops/modules/staff/staff_controller.dart';
import 'package:dops/modules/task/task_controller.dart';
import 'package:dops/modules/task/task_model.dart';
import 'package:dops/modules/task/task_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

import '../../components/custom_widgets.dart';
import '../activity/activity_controller.dart';
import '../reference_document/reference_document_controller.dart';

class StagesController extends GetxController {
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

  final GlobalKey<FormState> taskFormKey = GlobalKey<FormState>();

  final _repository = Get.find<TaskRepository>();
  final activityController = Get.find<ActivityController>();
  final referenceDocumentController = Get.find<ReferenceDocumentController>();
  final dropdownSourcesController = Get.find<DropdownSourcesController>();
  final taskController = Get.find<TaskController>();
  final staffController = Get.find<StaffController>();

  late TextEditingController drawingNumberController,
      nextRevisionNumberController,
      drawingTitleController,
      noteController;

  late List<String> areaList, designDrawingsList, assigned3DAdmins;

  late int revisionNumber;

  late String activityCodeText,
      projectText,
      moduleNameText,
      levelText,
      functionalAreaText,
      structureTypeText;

  @override
  void onInit() {
    super.onInit();

    drawingNumberController = TextEditingController();
    nextRevisionNumberController = TextEditingController();
    drawingTitleController = TextEditingController();
    noteController = TextEditingController();

    areaList = [];
    designDrawingsList = [];
    assigned3DAdmins = [];

    activityCodeText = '';
    projectText = '';
    moduleNameText = '';
    levelText = '';
    functionalAreaText = '';
    structureTypeText = '';
    revisionNumber = 0;
  }

  updateDocument({required TaskModel model, required String id}) async {
    final isValid = taskFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    taskFormKey.currentState!.save();
    CustomFullScreenDialog.showDialog();
    model.taskCreateDate = taskController.documents
        .where((document) => document.id == id)
        .toList()[0]
        .taskCreateDate;
    await _repository.updateModel(model, id);
    CustomFullScreenDialog.cancelDialog();
    Get.back();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void fillEditingControllers(String id) {
    final TaskModel model = taskController.documents
        .where((document) => document.id == id)
        .toList()[0];

    drawingNumberController.text = model.drawingNumber;
    nextRevisionNumberController.text = model.coverSheetRevision;
    drawingTitleController.text = model.drawingTitle;
    noteController.text = model.note;

    activityCodeText = model.activityCode;
    moduleNameText = model.module;
    levelText = model.level;
    functionalAreaText = model.functionalArea;
    structureTypeText = model.structureType;
    revisionNumber = model.revisionNumber!;

    designDrawingsList = model.designDrawings;
    areaList = model.area;
  }

  whenCompleted() {
    CustomFullScreenDialog.cancelDialog();
    Get.back();
  }

  catchError(FirebaseException error) {
    {
      CustomFullScreenDialog.cancelDialog();
      CustomSnackBar.showSnackBar(
        context: Get.context,
        title: "Error",
        message: "${error.message.toString()}",
        backgroundColor: Colors.red,
      );
    }
  }

  Widget buildEditForm() {
    fillEditingControllers(Get.parameters['id']!);

    return Form(
      key: taskFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Container(
        width: Get.width * .5,
        child: Column(
          children: [
            Container(
              height: 350,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomDropdownMenu(
                          width: 250,
                          labelText: 'Activity code',
                          selectedItems: [activityCodeText],
                          onChanged: (value) {
                            activityCodeText = value ?? '';
                          },
                          items:
                              activityController.getFieldValues('activityId'),
                        ),
                        SizedBox(width: 10),
                        CustomTextFormField(
                          readOnly: true,
                          width: 80,
                          initialValue: '1',
                          labelText: 'Priority',
                        ),
                        SizedBox(width: 10),
                        CustomDropdownMenu(
                          width: 100,
                          labelText: 'Project',
                          selectedItems: [projectText],
                          onChanged: (value) {
                            projectText = value ?? '';
                          },
                          items: dropdownSourcesController
                              .document.value.projects!,
                        ),
                        SizedBox(width: 10),
                        CustomDropdownMenu(
                          width: 200,
                          labelText: 'Module name',
                          selectedItems: [moduleNameText],
                          onChanged: (value) {
                            moduleNameText = value ?? '';
                          },
                          items:
                              dropdownSourcesController.document.value.modules!,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomTextFormField(
                          width: 180,
                          controller: drawingNumberController,
                          labelText: 'Drawing Number',
                        ),
                        SizedBox(width: 10),
                        CustomTextFormField(
                          width: 150,
                          controller: nextRevisionNumberController,
                          labelText: 'Cover Sheet Revision',
                        ),
                        SizedBox(width: 10),
                        CustomTextFormField(
                          width: 150,
                          controller: drawingTitleController,
                          labelText: 'Drawing Title',
                        ),
                        SizedBox(width: 10),
                        CustomDropdownMenu(
                          width: 150,
                          labelText: 'Level',
                          selectedItems: [levelText],
                          onChanged: (value) {
                            levelText = value ?? '';
                          },
                          items:
                              dropdownSourcesController.document.value.levels!,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 200,
                          child: CustomDropdownMenu(
                            isMultiSelectable: true,
                            labelText: 'Design Drawing',
                            items: referenceDocumentController
                                .getFieldValues('documentNumber'),
                            onChanged: (values) => designDrawingsList = values,
                            selectedItems: designDrawingsList,
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          width: 300,
                          child: CustomDropdownMenu(
                            isMultiSelectable: true,
                            labelText: 'Area',
                            items:
                                dropdownSourcesController.document.value.areas!,
                            onChanged: (values) => areaList = values,
                            selectedItems: areaList,
                          ),
                        ),
                        SizedBox(width: 10),
                        CustomTextFormField(
                          readOnly: true,
                          width: 100,
                          initialValue: '0',
                          labelText: 'Issue Type',
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomDropdownMenu(
                          width: 200,
                          labelText: 'Functional Area',
                          selectedItems: [functionalAreaText],
                          onChanged: (value) {
                            functionalAreaText = value ?? '';
                          },
                          items: dropdownSourcesController
                              .document.value.functionalAreas!,
                        ),
                        SizedBox(width: 10),
                        CustomDropdownMenu(
                          width: 200,
                          labelText: 'Structure Type',
                          selectedItems: [structureTypeText],
                          onChanged: (value) {
                            structureTypeText = value ?? '';
                          },
                          items: dropdownSourcesController
                              .document.value.structureTypes!,
                        ),
                        SizedBox(width: 10),
                        CustomTextFormField(
                          readOnly: true,
                          width: 150,
                          initialValue: '0',
                          labelText: 'Revision Number',
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomTextFormField(
                          width: 200,
                          controller: noteController,
                          labelText: 'Note',
                        ),
                        SizedBox(width: 10),
                        CustomTextFormField(
                          readOnly: true,
                          width: 100,
                          initialValue: '100%',
                          labelText: 'Percentage',
                        ),
                        SizedBox(width: 10),
                        CustomTextFormField(
                          readOnly: true,
                          width: 120,
                          initialValue: '0',
                          labelText: 'Revision Status',
                        ),
                        SizedBox(width: 10),
                        CustomTextFormField(
                          readOnly: true,
                          width: 120,
                          initialValue: '0',
                          labelText: 'Change Number',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      TaskModel model = TaskModel(
                        activityCode: activityCodeText,
                        drawingNumber: drawingNumberController.text,
                        designDrawings: designDrawingsList,
                        drawingTitle: drawingTitleController.text,
                        coverSheetRevision: nextRevisionNumberController.text,
                        level: levelText,
                        module: moduleNameText,
                        structureType: structureTypeText,
                        note: noteController.text,
                        area: areaList,
                        functionalArea: functionalAreaText,
                        revisionNumber: revisionNumber,
                      );

                      updateDocument(
                        model: model,
                        id: Get.parameters['id']!,
                      );
                    },
                    child: Text('Update'),
                  ),
                ],
              ),
            )
          ],
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: [
                          Form(
                            key: formKeysList[index][0],
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomDropdownMenu(
                                  width: 350,
                                  isMultiSelectable: true,
                                  labelText: stageDetailsList[index]
                                      ['staff job'],
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
                                    height: 46,
                                    child: Center(child: const Text('Assign')),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (index != 8)
                        Form(
                          key: formKeysList[index][1],
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // fields
                              Column(
                                children: <Widget>[
                                  if (stageDetailsList[index]['isThereFiles'] !=
                                      null) // files button
                                    Column(
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
                                            width: 150,
                                            child: Center(
                                              child: Text('Browse files'),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                      ],
                                    ),
                                  if (stageDetailsList[index]['number fields']
                                          .length >
                                      0) // number fields
                                    ...List.generate(
                                      stageDetailsList[index]['number fields']
                                          .length,
                                      (indexF) => CustomTextFormField(
                                        isNumber: true,
                                        controller:
                                            controllersListForNumberFields[
                                                index][indexF],
                                        labelText: stageDetailsList[index]
                                            ['number fields'][indexF],
                                        width: 180,
                                      ),
                                    ),
                                  SizedBox(width: 10),
                                  if (stageDetailsList[index]['string fields']
                                          .length >
                                      0) // string fields
                                    ...List.generate(
                                      stageDetailsList[index]['string fields']
                                          .length,
                                      (indexF) => CustomTextFormField(
                                        controller:
                                            controllersListForStringFields[
                                                index][indexF],
                                        labelText: stageDetailsList[index]
                                            ['string fields'][indexF],
                                        width: 180,
                                      ),
                                    ),
                                  SizedBox(width: 10),
                                ],
                              ),
                              SizedBox(width: 10),
                              // submit button
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      if (formKeysList[index][1]
                                          .currentState!
                                          .validate()) {}
                                    },
                                    child: Container(
                                      height: 46,
                                      child:
                                          Center(child: const Text('Submit')),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ],
                          ),
                        ),
                    ],
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
