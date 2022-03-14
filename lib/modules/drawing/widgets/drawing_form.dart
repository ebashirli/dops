import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/constants/style.dart';
import 'package:dops/modules/activity/activity_model.dart';
import 'package:dops/modules/drawing/drawing_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawingForm extends StatelessWidget {
  const DrawingForm({
    Key? key,
    required this.dialogWidth,
    this.drawingId,
    this.taskId,
  }) : super(key: key);
  final double dialogWidth;
  final String? drawingId;
  final String? taskId;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(8),
          topLeft: Radius.circular(8),
        ),
        color: light,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: drawingController.drawingFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Container(
            width: dialogWidth,
            child: Column(
              children: [
                Container(
                  height: 320,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 320,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                CustomDropdownMenuWithModel<ActivityModel>(
                                  width: dialogWidth * .185,
                                  items: activityController.documents,
                                  labelText: 'Activity code',
                                  showSearchBox: true,
                                  selectedItems: activitiCodeSelectedItem,
                                  onChanged: onActivityCodeChanged,
                                  itemAsString:
                                      (ActivityModel? activityModel) =>
                                          activityModel!.activityId!,
                                ),
                                CustomTextFormField(
                                  width: dialogWidth * .305,
                                  controller:
                                      drawingController.drawingNumberController,
                                  labelText: 'Drawing Number',
                                ),
                                CustomDropdownMenu(
                                  width: dialogWidth * .16,
                                  labelText: 'Module name',
                                  selectedItems: [
                                    drawingController.moduleNameText
                                  ],
                                  onChanged: onModuleNameChanged,
                                  items:
                                      listsController.document.value.modules!,
                                ),
                                CustomDropdownMenu(
                                  width: dialogWidth * .325,
                                  showSearchBox: true,
                                  isMultiSelectable: true,
                                  labelText: 'Area',
                                  items: listsController.document.value.areas!,
                                  onChanged: onAreaChanged,
                                  selectedItems: drawingController.areaList,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                CustomDropdownMenu(
                                  width: dialogWidth * .50,
                                  showSearchBox: true,
                                  labelText: 'Level',
                                  selectedItems: [drawingController.levelText],
                                  onChanged: (value) {
                                    drawingController.levelText = value ?? '';
                                  },
                                  items: listsController.document.value.levels!,
                                ),
                                CustomDropdownMenu(
                                  width: dialogWidth * .49,
                                  showSearchBox: true,
                                  labelText: 'Structure Type',
                                  selectedItems: [
                                    drawingController.structureTypeText
                                  ],
                                  onChanged: onStructureTypeChanged,
                                  items: listsController
                                      .document.value.structureTypes!,
                                ),
                              ],
                            ),
                            CustomTextFormField(
                              controller:
                                  drawingController.drawingTitleController,
                              labelText: 'Drawing Title',
                            ),
                            CustomDropdownMenu(
                              showSearchBox: true,
                              isMultiSelectable: true,
                              labelText: 'Drawing tags',
                              items:
                                  listsController.document.value.drawingTags!,
                              onChanged: (values) =>
                                  drawingController.drawingTagList = values,
                              selectedItems: drawingController.drawingTagList,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                CustomTextFormField(
                                  width: dialogWidth * .5,
                                  controller:
                                      drawingController.drawingNoteController,
                                  labelText: 'Note',
                                ),
                                CustomDropdownMenu(
                                  width: dialogWidth * .49,
                                  showSearchBox: true,
                                  labelText: 'Functional Area',
                                  selectedItems: [
                                    drawingController.functionalAreaText
                                  ],
                                  onChanged: (value) => drawingController
                                      .functionalAreaText = value ?? '',
                                  items: listsController
                                      .document.value.functionalAreas!,
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: Row(
                    children: <Widget>[
                      if (drawingId != null)
                        ElevatedButton.icon(
                          onPressed: onDeletePressed,
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
                        child: const Text('Cancel'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: onUpdateAddPressed,
                        child: Text(
                          drawingId != null ? 'Update' : 'Add',
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
    );
  }

  void onDeletePressed() {
    drawingController.deleteDrawing(drawingId!);
    Get.back();
  }

  void onUpdateAddPressed() {
    DrawingModel revisedOrNewDrawing = DrawingModel(
      activityCodeId: drawingController.activityCodeIdText,
      drawingNumber: drawingController.drawingNumberController.text,
      drawingTitle: drawingController.drawingTitleController.text,
      level: drawingController.levelText,
      module: drawingController.moduleNameText,
      structureType: drawingController.structureTypeText,
      note: drawingController.drawingNoteController.text,
      area: drawingController.areaList,
      functionalArea: drawingController.functionalAreaText,
      drawingTag: drawingController.drawingTagList,
    );

    drawingId == null
        ? drawingController.addNewDrawing(model: revisedOrNewDrawing)
        : drawingController.updateDrawing(
            updatedModel: revisedOrNewDrawing, id: drawingId!);
  }

  List<String> itemsReferenceDocuments() {
    return referenceDocumentController.documents
        .map((document) => document.documentNumber)
        .toList();
  }

  void onStructureTypeChanged(value) {
    drawingController.structureTypeText = value ?? '';
  }

  void onAreaChanged(values) => drawingController.areaList = values;

  void onModuleNameChanged(value) =>
      drawingController.moduleNameText = value ?? '';

  void onActivityCodeChanged(value) =>
      drawingController.activityCodeIdText = activityController.documents
          .singleWhere((e) => e.id == value.first!.id)
          .id!;

  List<ActivityModel?> get activitiCodeSelectedItem => [
        drawingId != null
            ? activityController.documents.singleWhere(
                (activity) =>
                    activity.id == drawingController.activityCodeIdText,
              )
            : null
      ];
}
