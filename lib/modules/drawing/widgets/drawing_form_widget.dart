import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/modules/activity/activity_model.dart';
import 'package:dops/modules/drawing/drawing_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawingFormWidget extends StatelessWidget {
  const DrawingFormWidget({
    Key? key,
    required this.dialogWidth,
    this.drawingId,
  }) : super(key: key);
  final double dialogWidth;
  final String? drawingId;

  @override
  Widget build(BuildContext context) {
    List<String?>? drawingTagItems =
        listsController.document.drawingTags == null
            ? null
            : listsController.document.drawingTags!
                .map((e) => e.toString())
                .toList();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(8),
          topLeft: Radius.circular(8),
        ),
      ),
      child: Form(
        key: drawingController.drawingFormKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SizedBox(
          width: dialogWidth,
          child: Column(
            children: [
              SizedBox(
                height: 160,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        CustomDropdownMenuWithModel<ActivityModel?>(
                          width: dialogWidth * .185,
                          items: activityController.documents,
                          labelText: 'Activity code',
                          showSearchBox: true,
                          selectedItems: [activitiCodeSelectedItem],
                          onChanged: onActivityCodeChanged,
                          itemAsString: (ActivityModel? activityModel) =>
                              activityModel!.activityId!,
                        ),
                        CustomTextFormField(
                          width: dialogWidth * .305,
                          controller: drawingController.drawingNumberController,
                          labelText: 'Drawing Number',
                        ),
                        Obx(() => CustomDropdownMenuWithModel<String>(
                              itemAsString: (e) => e!,
                              width: dialogWidth * .16,
                              labelText: 'Module name',
                              selectedItems: [drawingController.moduleNameText],
                              onChanged: onModuleNameChanged,
                              items: listsController.document.modules!
                                  .map((e) => e.toString())
                                  .toList(),
                            )),
                        Obx(() => CustomDropdownMenuWithModel<String>(
                              itemAsString: (e) => e!,
                              width: dialogWidth * .325,
                              showSearchBox: true,
                              isMultiSelectable: true,
                              labelText: 'Area',
                              items: listsController.document.areas!
                                  .map((e) => e.toString())
                                  .toList(),
                              onChanged: onAreaChanged,
                              selectedItems: drawingController.areaList,
                            )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Obx(() => CustomDropdownMenuWithModel<String>(
                              width: dialogWidth * .50,
                              itemAsString: (e) => e!,
                              showSearchBox: true,
                              labelText: 'Level',
                              selectedItems: [drawingController.levelText],
                              onChanged: (value) => staffController
                                  .jobTitleText = value.toString(),
                              items: listsController.document.levels!
                                  .map((e) => e.toString())
                                  .toList(),
                            )),
                        Obx(() => CustomDropdownMenuWithModel<String>(
                              width: dialogWidth * .49,
                              itemAsString: (e) => e!,
                              showSearchBox: true,
                              labelText: 'Structure Type',
                              selectedItems: [
                                drawingController.structureTypeText
                              ],
                              onChanged: onStructureTypeChanged,
                              items: listsController.document.structureTypes!
                                  .map((e) => e.toString())
                                  .toList(),
                            )),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextFormField(
                          controller: drawingController.drawingTitleController,
                          labelText: 'Drawing Title',
                          width: dialogWidth * .7,
                        ),
                        CustomDropdownMenuWithModel<String?>(
                          showSearchBox: true,
                          isMultiSelectable: true,
                          labelText: 'Drawing tags',
                          items: drawingTagItems,
                          onChanged: (values) =>
                              drawingController.drawingTagList = values,
                          selectedItems: drawingController.drawingTagList,
                          itemAsString: (v) => v.toString(),
                          width: dialogWidth * .29,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        CustomTextFormField(
                          width: dialogWidth * .5,
                          controller: drawingController.drawingNoteController,
                          labelText: 'Note',
                        ),
                        Obx(() {
                          return CustomDropdownMenuWithModel<String>(
                            width: dialogWidth * .49,
                            itemAsString: (e) => e!,
                            showSearchBox: true,
                            labelText: 'Functional Area',
                            selectedItems: [
                              drawingController.functionalAreaText
                            ],
                            onChanged: (value) =>
                                staffController.jobTitleText = value.toString(),
                            items: listsController.document.modules!
                                .map((e) => e.toString())
                                .toList(),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Row(
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
              )
            ],
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
        ? drawingController.add(model: revisedOrNewDrawing)
        : drawingController.update(
            updatedModel: revisedOrNewDrawing, id: drawingId!);
  }

  List<String> itemsReferenceDocuments() {
    return refDocController.documents
        .map((document) => document.documentNumber)
        .toList();
  }

  void onStructureTypeChanged(value) {
    drawingController.structureTypeText = value ?? '';
  }

  void onAreaChanged(values) => drawingController.areaList = values;

  void onModuleNameChanged(value) =>
      drawingController.moduleNameText = value ?? '';

  void onActivityCodeChanged(value) {
    ActivityModel? activityModel = activityController.getById(value.first!.id);
    drawingController.activityCodeIdText =
        activityModel == null ? '' : activityModel.id!;
  }

  ActivityModel? get activitiCodeSelectedItem => drawingId != null
      ? activityController.getById(drawingController.activityCodeIdText)
      : null;
}
