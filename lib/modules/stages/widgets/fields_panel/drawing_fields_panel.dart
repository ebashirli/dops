import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/modules/activity/activity_model.dart';
import 'package:dops/modules/drawing/drawing_model.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class DrawingUpdateFormWidget extends StatelessWidget {
  const DrawingUpdateFormWidget({Key? key, required this.drawingModel})
      : super(key: key);
  final DrawingModel drawingModel;

  @override
  Widget build(BuildContext context) {
    final double totalWidth = Get.width - 120;
    final bool enabled = false;
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            CustomTextFormField(
              initialValue: activityController
                  .selectedActivities(drawingModel.activityCodeId),
              enabled: enabled,
              sizeBoxHeight: 0,
              width: totalWidth * .11,
              labelText: 'Activity code',
            ),
            CustomTextFormField(
              initialValue: drawingModel.drawingNumber,
              enabled: enabled,
              sizeBoxHeight: 0,
              width: totalWidth * .22,
              labelText: 'Drawing Number',
            ),
            CustomTextFormField(
              initialValue: drawingModel.module,
              enabled: enabled,
              width: totalWidth * .11,
              sizeBoxHeight: 0,
              labelText: 'Module name',
            ),
            CustomTextFormField(
              initialValue: drawingModel.level,
              enabled: enabled,
              width: totalWidth * .21,
              sizeBoxHeight: 0,
              labelText: 'Level',
            ),
            CustomTextFormField(
              initialValue: drawingModel.structureType,
              enabled: enabled,
              width: totalWidth * .21,
              sizeBoxHeight: 0,
              labelText: 'Structure Type',
            ),
            CustomTextFormField(
              initialValue: drawingModel.area.join(', '),
              enabled: enabled,
              width: totalWidth * .14,
              sizeBoxHeight: 0,
              labelText: 'Area',
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                CustomTextFormField(
                  initialValue: drawingModel.drawingTitle,
                  enabled: enabled,
                  width: totalWidth * .334,
                  labelText: 'Drawing Title',
                ),
                SizedBox(height: 12),
                CustomTextFormField(
                  initialValue: drawingModel.drawingTag.join(', '),
                  enabled: enabled,
                  width: totalWidth * .334,
                  labelText: 'Drawing Tags',
                ),
              ],
            ),
            CustomTextFormField(
              initialValue: drawingModel.note,
              enabled: enabled,
              width: totalWidth * .333,
              maxLines: 5,
              labelText: 'Note',
            ),
            Column(
              children: <Widget>[
                CustomTextFormField(
                  initialValue: drawingModel.functionalArea,
                  enabled: enabled,
                  width: totalWidth * .333,
                  labelText: 'Functional Area',
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: totalWidth * .333,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      CustomTextFormField(
                        enabled: enabled,
                        width: (totalWidth * .333) * .3,
                        initialValue:
                            stageController.phaseInitialValue(drawingModel),
                        labelText: 'Tekla Phase',
                      ),
                      SizedBox(width: 10),
                      CustomTextFormField(
                        enabled: enabled,
                        width: (totalWidth * .333) * .3,
                        initialValue:
                            '${drawingModel.drawingCreateDate!.toDMYhm()}',
                        labelText: 'Drawing create date',
                      ),
                      Expanded(child: SizedBox(width: 10)),
                      if (staffController.isCoordinator)
                        Container(
                          width: (totalWidth * .333) * .3,
                          child: ElevatedButton(
                            onPressed: () => drawingController.buildUpdateForm(
                                id: drawingModel.id!),
                            child: Text('Edit'),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  void onUpdatePressed(DrawingModel drawingModel) {
    DrawingModel revisedOrNewModel = DrawingModel(
      activityCodeId: drawingController.activityCodeIdText,
      drawingNumber: drawingController.drawingNumberController.text,
      drawingTitle: drawingController.drawingTitleController.text,
      level: drawingController.levelText,
      module: drawingController.moduleNameText,
      structureType: drawingController.structureTypeText,
      note: drawingController.drawingNoteController.text,
      area: drawingController.areaList,
      drawingTag: drawingController.drawingTagList,
      functionalArea: drawingController.functionalAreaText,
    );

    drawingController.update(
      updatedModel: revisedOrNewModel,
      id: drawingModel.id!,
    );
  }

  void onActivitiesChanged(activityId) {
    ActivityModel? activityModel = activityController.getById(activityId);

    drawingController.activityCodeIdText =
        activityModel == null ? "" : activityModel.id!;
  }
}
