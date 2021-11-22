import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dops/components/custom_number_text_field_widget.dart';
import 'package:dops/constants/lists.dart';
import 'package:dops/constants/stages_details.dart';
import 'package:dops/modules/dropdown_source/dropdown_sources_controller.dart';
import 'package:dops/modules/staff/staff_controller.dart';
import 'package:dops/modules/task/task_controller.dart';
import 'package:dops/modules/task/task_model.dart';
import 'package:dops/modules/task/task_repository.dart';
import '../../components/custom_multiselect_dropdown_menu_widget.dart';
import '../../components/custom_string_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

import '../../components/custom_dropdown_menu_widget.dart';
import '../../components/custom_full_screen_dialog_widget.dart';
import '../../components/custom_snackbar_widget.dart';
import '../activity/activity_controller.dart';
import '../reference_document/reference_document_controller.dart';

class StagesController extends GetxController {
  final RxList<bool> isExpandedList =
      List<bool>.generate(9, (int index) => false, growable: false).obs;

  final List<GlobalKey<FormState>> formKeyList =
      List<GlobalKey<FormState>>.generate(
    13,
    (int index) => GlobalKey<FormState>(),
    growable: false,
  );

  final List<TextEditingController> textEditingControllerList =
      List<TextEditingController>.generate(
    15,
    (int index) => TextEditingController(),
    growable: false,
  );

  late List<PlatformFile?> drafteringFiles = [];

  final GlobalKey<FormState> taskFormKey = GlobalKey<FormState>();

  final _repository = Get.find<TaskRepository>();
  final activityController = Get.find<ActivityController>();
  final referenceDocumentController = Get.find<ReferenceDocumentController>();
  final dropdownSourcesController = Get.find<DropdownSourcesController>();
  final taskController = Get.find<TaskController>();
  final staffController = Get.find<StaffController>();

  late TextEditingController drawingNumberController,
      coverSheetRevisionController,
      drawingTitleController,
      noteController;

  late List<String> areaList = [];
  late List<String> designDrawingsList = [];
  late List<String> assigned3DAdmins = [];

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
    coverSheetRevisionController = TextEditingController();
    drawingTitleController = TextEditingController();
    noteController = TextEditingController();

    activityCodeText = '';
    projectText = '';
    moduleNameText = '';
    levelText = '';
    functionalAreaText = '';
    structureTypeText = '';
  }

  updateDocument({
    required TaskModel model,
    required String id,
  }) async {
    final isValid = taskFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    taskFormKey.currentState!.save();
    CustomFullScreenDialog.showDialog();
    await _repository.updateModel(model, id);
  }

  @override
  void onReady() {
    super.onReady();
  }

  void fillEditingControllers(TaskModel model) {
    drawingNumberController.text = model.drawingNumber;
    coverSheetRevisionController.text = model.coverSheetRevision;
    drawingTitleController.text = model.drawingTitle;
    noteController.text = model.note;

    activityCodeText = model.activityCode;
    projectText = model.project;
    moduleNameText = model.module;
    levelText = model.level;
    functionalAreaText = model.functionalArea;
    structureTypeText = model.structureType;

    designDrawingsList = model.designDrawings;
    areaList = model.area;
    // assigned3DAdmins = model.assigned3DAdmins;
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
    fillEditingControllers(taskController.documents
        .where((document) => document.id == taskController.openedTaskId.value)
        .toList()[0]);

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
                          selectedItem: activityCodeText,
                          onChanged: (value) {
                            activityCodeText = value ?? '';
                          },
                          items:
                              activityController.getFieldValues('activityId'),
                        ),
                        SizedBox(width: 10),
                        CustomStringTextField(
                          readOnly: true,
                          width: 80,
                          initialValue: '1',
                          labelText: 'Priority',
                        ),
                        SizedBox(width: 10),
                        CustomDropdownMenu(
                          width: 100,
                          labelText: 'Project',
                          selectedItem: projectText,
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
                          selectedItem: moduleNameText,
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
                        CustomStringTextField(
                          width: 180,
                          controller: drawingNumberController,
                          labelText: 'Drawing Number',
                        ),
                        SizedBox(width: 10),
                        CustomStringTextField(
                          width: 150,
                          controller: coverSheetRevisionController,
                          labelText: 'Cover Sheet Revision',
                        ),
                        SizedBox(width: 10),
                        CustomStringTextField(
                          width: 150,
                          controller: drawingTitleController,
                          labelText: 'Drawing Title',
                        ),
                        SizedBox(width: 10),
                        CustomDropdownMenu(
                          width: 150,
                          labelText: 'Level',
                          selectedItem: levelText,
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
                          child: CustomMultiselectDropdownMenu(
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
                          child: CustomMultiselectDropdownMenu(
                            labelText: 'Area',
                            items:
                                dropdownSourcesController.document.value.areas!,
                            onChanged: (values) => areaList = values,
                            selectedItems: areaList,
                          ),
                        ),
                        SizedBox(width: 10),
                        CustomStringTextField(
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
                          selectedItem: functionalAreaText,
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
                          selectedItem: structureTypeText,
                          onChanged: (value) {
                            structureTypeText = value ?? '';
                          },
                          items: dropdownSourcesController
                              .document.value.structureTypes!,
                        ),
                        SizedBox(width: 10),
                        CustomStringTextField(
                          readOnly: true,
                          width: 150,
                          initialValue: '0',
                          labelText: 'Revision Number',
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomStringTextField(
                          width: 200,
                          controller: noteController,
                          labelText: 'Note',
                        ),
                        SizedBox(width: 10),
                        CustomStringTextField(
                          readOnly: true,
                          width: 100,
                          initialValue: '100%',
                          labelText: 'Percentage',
                        ),
                        SizedBox(width: 10),
                        CustomStringTextField(
                          readOnly: true,
                          width: 120,
                          initialValue: '0',
                          labelText: 'Revision Status',
                        ),
                        SizedBox(width: 10),
                        CustomStringTextField(
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
                        coverSheetRevision: coverSheetRevisionController.text,
                        level: levelText,
                        module: moduleNameText,
                        structureType: structureTypeText,
                        note: noteController.text,
                        area: areaList,
                        project: projectText,
                        functionalArea: functionalAreaText,
                      );
                      updateDocument(
                        model: model,
                        id: taskController.openedTaskId.value,
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
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        isExpandedList[index] = !isExpanded;
      },
      children: [
        ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(title: Text(stageNames[0]));
          },
          body: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  child: Form(
                    key: formKeyList[0],
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomDropdownMenu(
                          items: staffController.documents
                              .map((e) => e.name)
                              .toList(),
                          labelText: stageInputFieldListsMap.keys.toList()[0],
                          onChanged: (String) {},
                          width: 250,
                        ),
                        SizedBox(width: 10),
                        Container(
                          width: 80,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ElevatedButton(
                              onPressed: () {
                                if (formKeyList[0].currentState!.validate()) {
                                  print('helllllllooooooooooooo');
                                }
                              },
                              child: const Text('Assign'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const VerticalDivider(
                  color: Colors.grey,
                  thickness: 1,
                  indent: 20,
                  endIndent: 0,
                  width: 20,
                ),
                Container(
                  child: Form(
                    key: formKeyList[1],
                    child: Row(
                      children: [
                        CustomNumberTextField(
                          controller: textEditingControllerList[0],
                          labelText: stageInputFieldListsMap.values.toList()[0]
                              [0],
                          width: 80,
                        ),
                        SizedBox(width: 10),
                        CustomNumberTextField(
                          width: 80,
                          controller: textEditingControllerList[1],
                          labelText: stageInputFieldListsMap.values.toList()[0]
                              [1],
                        ),
                        SizedBox(width: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKeyList[1].currentState!.validate()) {
                                print('helllllllooooooooooooo');
                              }
                            },
                            child: const Text('Submit'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          isExpanded: isExpandedList[0],
        ),
        ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
                title: Text(
              stageInputFieldListsMap.keys.toList()[1],
            ));
          },
          body: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  child: Form(
                    key: formKeyList[2],
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomDropdownMenu(
                          width: 200,
                          items: staffController.documents
                              .map((e) => e.name)
                              .toList(),
                          labelText: stageInputFieldListsMap.keys.toList()[1],
                          onChanged: (String) {},
                        ),
                        SizedBox(width: 10),
                        Container(
                          width: 80,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ElevatedButton(
                              onPressed: () {
                                if (formKeyList[0].currentState!.validate()) {
                                  print('helllllllooooooooooooo');
                                }
                              },
                              child: const Text('Assign'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(),
                Container(
                  child: Form(
                    key: formKeyList[3],
                    child: Row(
                      children: [
                        CustomNumberTextField(
                          width: 70,
                          controller: textEditingControllerList[0],
                          labelText: stageInputFieldListsMap.values.toList()[1]
                              [0],
                        ),
                        SizedBox(width: 10),
                        CustomNumberTextField(
                          width: 70,
                          controller: textEditingControllerList[1],
                          labelText: stageInputFieldListsMap.values.toList()[1]
                              [1],
                        ),
                        SizedBox(width: 10),
                        CustomNumberTextField(
                          width: 70,
                          controller: textEditingControllerList[1],
                          labelText: stageInputFieldListsMap.values.toList()[1]
                              [2],
                        ),
                        SizedBox(width: 10),
                        CustomNumberTextField(
                          width: 70,
                          controller: textEditingControllerList[1],
                          labelText: stageInputFieldListsMap.values.toList()[1]
                              [3],
                        ),
                        SizedBox(width: 10),
                        Container(
                          width: 80,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ElevatedButton(
                              onPressed: () {
                                if (formKeyList[1].currentState!.validate()) {
                                  print('helllllllooooooooooooo');
                                }
                              },
                              child: const Text('Submit'),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          isExpanded: isExpandedList[1],
        ),
        ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(
                stageInputFieldListsMap.keys.toList()[2],
              ),
            );
          },
          body: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  child: Form(
                    key: formKeyList[4],
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomDropdownMenu(
                          width: 200,
                          items: staffController.documents
                              .map((e) => e.name)
                              .toList(),
                          labelText: stageInputFieldListsMap.keys.toList()[2],
                          onChanged: (String) {},
                        ),
                        SizedBox(width: 10),
                        Container(
                          width: 80,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ElevatedButton(
                              onPressed: () {
                                if (formKeyList[0].currentState!.validate()) {
                                  print('helllllllooooooooooooo');
                                }
                              },
                              child: const Text('Assign'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(),
                Container(
                  child: Form(
                    key: formKeyList[5],
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: selectDrafteringFiles,
                          child: Text(
                            stageInputFieldListsMap.values.toList()[2][0],
                          ),
                        ),
                        if (!drafteringFiles.isEmpty)
                          Column(
                            children: drafteringFiles
                                .map((drafteringFile) =>
                                    Text(drafteringFile!.name))
                                .toList(),
                          ),
                        SizedBox(width: 10),
                        CustomNumberTextField(
                          width: 70,
                          controller: textEditingControllerList[1],
                          labelText: stageInputFieldListsMap.values.toList()[2]
                              [1],
                        ),
                        SizedBox(width: 10),
                        CustomNumberTextField(
                          width: 70,
                          controller: textEditingControllerList[1],
                          labelText: stageInputFieldListsMap.values.toList()[2]
                              [2],
                        ),
                        SizedBox(width: 10),
                        CustomNumberTextField(
                          width: 70,
                          controller: textEditingControllerList[1],
                          labelText: stageInputFieldListsMap.values.toList()[2]
                              [3],
                        ),
                        SizedBox(width: 10),
                        Container(
                          width: 80,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ElevatedButton(
                              onPressed: () {
                                if (formKeyList[1].currentState!.validate()) {
                                  print('helllllllooooooooooooo');
                                }
                              },
                              child: const Text('Submit'),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          isExpanded: isExpandedList[2],
        ),
      ],
    );
  }

  void selectDrafteringFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );
    if (result == null) return;
    drafteringFiles = result.files;
  }
}
