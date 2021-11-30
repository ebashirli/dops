import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dops/constants/table_details.dart';
import 'package:dops/modules/dropdown_source/dropdown_sources_controller.dart';
import '../../components/custom_text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/custom_dropdown_menu_widget.dart';
import '../../components/custom_full_screen_dialog_widget.dart';
import '../../components/custom_snackbar_widget.dart';
import '../../constants/style.dart';
import '../activity/activity_controller.dart';
import '../reference_document/reference_document_controller.dart';
import 'drawing_model.dart';
import 'drawing_repository.dart';

class DrawingController extends GetxController {
  final GlobalKey<FormState> drawingFormKeyOnStages = GlobalKey<FormState>();
  final _repository = Get.find<DrawingRepository>();
  final activityController = Get.find<ActivityController>();
  final referenceDocumentController = Get.find<ReferenceDocumentController>();
  final dropdownSourcesController = Get.find<DropdownSourcesController>();

  late TextEditingController drawingNumberController,
      nextRevisionNumberController,
      drawingTitleController,
      noteController;

  late List<String> areaList = [];
  late List<String> designDrawingsList = [];

  late int revisionNumber = 0;

  late String activityCodeText,
      moduleNameText,
      levelText,
      functionalAreaText,
      structureTypeText;

  RxBool sortAscending = false.obs;
  RxInt sortColumnIndex = 0.obs;

  RxList<DrawingModel> _documents = RxList<DrawingModel>([]);
  List<DrawingModel> get documents => _documents;

  @override
  void onInit() {
    super.onInit();
    drawingNumberController = TextEditingController();
    nextRevisionNumberController = TextEditingController();
    drawingTitleController = TextEditingController();
    noteController = TextEditingController();

    _documents.bindStream(_repository.getAllDocumentsAsStream());
  }

  addNewDrawing({required DrawingModel model}) async {
    CustomFullScreenDialog.showDialog();
    model.drawingCreateDate = DateTime.now();
    await _repository.addModel(model);
    CustomFullScreenDialog.cancelDialog();
    Get.back();
  }

  updateDrawing(
      {required DrawingModel updatedModel, required String id}) async {
    // TODO: move following line to Add/update button if it is relevant
    final isValid = drawingFormKeyOnStages.currentState!.validate();
    if (!isValid) {
      return;
    }
    drawingFormKeyOnStages.currentState!.save();
    //update
    CustomFullScreenDialog.showDialog();
    updatedModel.drawingCreateDate = documents
        .where((document) => document.id == id)
        .toList()[0]
        .drawingCreateDate;
    await _repository.updateModel(updatedModel, id);
    CustomFullScreenDialog.cancelDialog();
    Get.back();
  }

  void deleteDrawing(String id) {
    _repository.removeModel(id);
  }

  @override
  void onReady() {
    super.onReady();
  }

  void clearEditingControllers() {
    drawingNumberController.clear();
    nextRevisionNumberController.clear();
    drawingTitleController.clear();
    noteController.clear();

    activityCodeText = '';
    moduleNameText = '';
    levelText = '';
    functionalAreaText = '';
    structureTypeText = '';

    designDrawingsList = [];
    areaList = [];

    revisionNumber = 0;
  }

  void fillEditingControllers(DrawingModel model) {
    drawingNumberController.text = model.drawingNumber;
    drawingTitleController.text = model.drawingTitle;
    noteController.text = model.note;

    activityCodeText = model.activityCode;
    moduleNameText = model.module;
    levelText = model.level;
    functionalAreaText = model.functionalArea;
    structureTypeText = model.structureType;

    areaList = model.area;
  }

  whenCompleted() {
    CustomFullScreenDialog.cancelDialog();
    clearEditingControllers();
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

  buildAddEdit({String? id, bool newRev = false}) {
    if (id != null && !newRev) {
      fillEditingControllers(
          documents.where((document) => document.id == id).toList()[0]);
    } else {
      clearEditingControllers();
    }

    Get.defaultDialog(
      barrierDismissible: false,
      radius: 12,
      titlePadding: EdgeInsets.only(top: 20, bottom: 20),
      title: id == null
          ? 'Add new drawing'
          : newRev
              ? 'Add next revision'
              : 'Update drawing',
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
            key: drawingFormKeyOnStages,
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
                          if (!newRev)
                            Column(
                              children: <Widget>[
                                SizedBox(height: 10),
                                CustomDropdownMenu(
                                  labelText: 'Activity code',
                                  selectedItems: [activityCodeText],
                                  onChanged: (value) {
                                    activityCodeText = value ?? '';
                                  },
                                  items: activityController.documents
                                      .map((document) => document.activityId)
                                      .toList(),
                                ),
                                CustomTextFormField(
                                  controller: drawingNumberController,
                                  labelText: 'Drawing Number',
                                ),
                                CustomTextFormField(
                                  controller: drawingTitleController,
                                  labelText: 'Drawing Title',
                                ),
                                CustomDropdownMenu(
                                  labelText: 'Module name',
                                  selectedItems: [moduleNameText],
                                  onChanged: (value) {
                                    moduleNameText = value ?? '';
                                  },
                                  items: dropdownSourcesController
                                      .document.value.modules!,
                                ),
                                CustomDropdownMenu(
                                  labelText: 'Level',
                                  selectedItems: [levelText],
                                  onChanged: (value) {
                                    levelText = value ?? '';
                                  },
                                  items: dropdownSourcesController
                                      .document.value.levels!,
                                ),
                                CustomDropdownMenu(
                                  isMultiSelectable: true,
                                  labelText: 'Area',
                                  items: dropdownSourcesController
                                      .document.value.areas!,
                                  onChanged: (values) => areaList = values,
                                  selectedItems: areaList,
                                ),
                                CustomDropdownMenu(
                                  labelText: 'Functional Area',
                                  selectedItems: [functionalAreaText],
                                  onChanged: (value) {
                                    functionalAreaText = value ?? '';
                                  },
                                  items: dropdownSourcesController
                                      .document.value.functionalAreas!,
                                ),
                                CustomDropdownMenu(
                                  labelText: 'Structure Type',
                                  selectedItems: [structureTypeText],
                                  onChanged: (value) {
                                    structureTypeText = value ?? '';
                                  },
                                  items: dropdownSourcesController
                                      .document.value.structureTypes!,
                                ),
                                CustomTextFormField(
                                  controller: noteController,
                                  labelText: 'Note',
                                ),
                              ],
                            ),
                          if (newRev || id != null)
                            Column(
                              children: <Widget>[
                                if (newRev)
                                  Text(
                                    documents
                                        .where(
                                            (documents) => documents.id == id)
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
                                      .map(
                                          (document) => document.documentNumber)
                                      .toList(),
                                  onChanged: (values) =>
                                      designDrawingsList = values,
                                  selectedItems: designDrawingsList,
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
                        if (id != null)
                          ElevatedButton.icon(
                            onPressed: () {
                              deleteDrawing(id);
                              Get.back();
                            },
                            icon: Icon(Icons.delete),
                            label: const Text('Delete'),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.red,
                              ),
                            ),
                          ),
                        const Spacer(),
                        ElevatedButton(
                            onPressed: () => Get.back(),
                            child: const Text('Cancel')),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            DrawingModel revisedOrNewModel = DrawingModel(
                              activityCode: activityCodeText,
                              drawingNumber: drawingNumberController.text,
                              drawingTitle: drawingTitleController.text,
                              level: levelText,
                              module: moduleNameText,
                              structureType: structureTypeText,
                              note: noteController.text,
                              area: areaList,
                              functionalArea: functionalAreaText,
                            );

                            id == null
                                ? addNewDrawing(model: revisedOrNewModel)
                                : updateDrawing(
                                    updatedModel: revisedOrNewModel,
                                    id: id,
                                  );
                          },
                          child: Text(
                            id != null ? 'Update' : 'Add',
                          ),
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
    List<String> mapPropNames = mapPropNamesGetter('drawing');

    return documents.map(
      (drawing) {
        Map<String, dynamic> map = {};

        mapPropNames.forEach(
          (mapPropName) {
            switch (mapPropName) {
              case 'id':
                map[mapPropName] = drawing.id!;
                break;
              case 'priority':
                map[mapPropName] = activityController.documents
                        .indexOf(activityController.documents.where((document) {
                      return document.activityId == drawing.activityCode;
                    }).toList()[0]) +
                    1;
                break;
              case 'area':
              case 'functionalArea':
              case 'note':
              case 'isHidden':
                break;
              case 'drawingCreateDate':
                map[mapPropName] = drawing.drawingCreateDate;
                break;
              case 'drawingNumber':
                map[mapPropName] = '${drawing.drawingNumber}|${drawing.id}';
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
