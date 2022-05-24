import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/modules/models/drawing_model.dart';
import 'package:dops/modules/widgets/stages/stage_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawingFieldsWidget extends StatelessWidget {
  const DrawingFieldsWidget({
    Key? key,
    required this.drawingModel,
  }) : super(key: key);
  final DrawingModel drawingModel;

  @override
  Widget build(BuildContext context) {
    final bool readOnly = true;

    return Row(
      children: <Widget>[
        Flexible(
          flex: 66,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlexTextWidget(
                    flex: 10,
                    labelText: 'Activity code',
                    initialValue: activityController
                        .selectedActivities(drawingModel.activityCodeId),
                  ),
                  Flexible(child: SizedBox()),
                  FlexTextWidget(
                    flex: 20,
                    initialValue: drawingModel.drawingNumber,
                    labelText: 'Drawing Number',
                  ),
                ],
              ),
              SizedBox(height: 10),
              CustomTextFormField(
                initialValue: drawingModel.drawingTitle,
                readOnly: readOnly,
                labelText: 'Drawing Title',
                maxLines: 1,
              ),
              SizedBox(height: 10),
              CustomTextFormField(
                initialValue: drawingModel.drawingTag.join(', '),
                readOnly: readOnly,
                labelText: 'Drawing Tags',
              ),
            ],
          ),
        ),
        SizedBox(width: Get.width * .01),
        Flexible(
          flex: 66,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FlexTextWidget(
                    flex: 10,
                    initialValue: drawingModel.module,
                    labelText: 'Module name',
                  ),
                  Flexible(child: SizedBox()),
                  FlexTextWidget(
                    initialValue: drawingModel.level,
                    labelText: 'Level',
                    flex: 20,
                  ),
                ],
              ),
              SizedBox(height: 10),
              CustomTextFormField(
                initialValue:
                    drawingModel.note.isEmpty ? ' ' : drawingModel.note,
                readOnly: readOnly,
                maxLines: 1,
                labelText: 'Note',
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlexTextWidget(
                    flex: 10,
                    controller: TextEditingController()
                      ..text = stageController.phaseInitialValue == null
                          ? ' '
                          : '${stageController.phaseInitialValue}',
                    labelText: 'Tekla Phase',
                  ),
                  Flexible(child: SizedBox()),
                  FlexTextWidget(
                    flex: 20,
                    initialValue:
                        '${drawingModel.drawingCreateDate!.toDMYhm()}',
                    labelText: 'Drawing create date',
                  ),
                ],
              )
            ],
          ),
        ),
        SizedBox(width: Get.width * .01),
        Flexible(
          flex: 66,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FlexTextWidget(
                    initialValue: drawingModel.structureType,
                    labelText: 'Structure Type',
                    flex: 20,
                  ),
                  Flexible(child: SizedBox()),
                  FlexTextWidget(
                    initialValue: drawingModel.area.join(', '),
                    labelText: 'Area',
                    flex: 10,
                  ),
                ],
              ),
              SizedBox(height: 10),
              CustomTextFormField(
                initialValue: drawingModel.functionalArea,
                readOnly: readOnly,
                labelText: 'Functional Area',
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  SizedBox(height: 34),
                  if (staffController.isCoordinator)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () => drawingController.buildUpdateForm(
                              id: drawingModel.id!),
                          child: Text('Edit'),
                        ),
                      ],
                    ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
