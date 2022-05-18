import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/modules/activity/activity_model.dart';
import 'package:dops/modules/drawing/drawing_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawingFormWidget extends StatelessWidget {
  const DrawingFormWidget({
    Key? key,
    this.id,
  }) : super(key: key);
  final String? id;

  @override
  Widget build(BuildContext context) {
    final double dialogWidth = Get.width * 0.5;

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
      height: Get.height * .3,
      child: SizedBox(
        width: dialogWidth,
        child: Form(
          key: drawingController.drawingFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                flex: 8,
                child: ListView(
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
                    SizedBox(height: 10),
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
                    SizedBox(height: 10),
                    CustomTextFormField(
                      controller: drawingController.drawingTitleController,
                      labelText: 'Drawing Title',
                    ),
                    SizedBox(height: 10),
                    CustomDropdownMenuWithModel<String?>(
                      showSearchBox: true,
                      isMultiSelectable: true,
                      labelText: 'Drawing tags',
                      items: drawingTagItems,
                      onChanged: (values) =>
                          drawingController.drawingTagList = values,
                      selectedItems: drawingController.drawingTagList,
                      itemAsString: (v) => v.toString(),
                    ),
                    SizedBox(height: 10),
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
              // Flexible(child: SizedBox(height: 10)),
              Flexible(
                child: Row(
                  children: <Widget>[
                    if (id != null)
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
                        id != null ? 'Update' : 'Add',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onDeletePressed() {
    drawingController.deleteDrawing(id!);
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

    id == null
        ? drawingController.add(model: revisedOrNewDrawing)
        : drawingController.update(updatedModel: revisedOrNewDrawing, id: id!);
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

  ActivityModel? get activitiCodeSelectedItem => id != null
      ? activityController.getById(drawingController.activityCodeIdText)
      : null;
}
