import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/modules/task/task_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskFieldsWidget extends StatelessWidget {
  const TaskFieldsWidget({Key? key, required this.taskModel}) : super(key: key);
  final TaskModel taskModel;

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
              enabled: enabled,
              width: totalWidth * .05,
              initialValue: taskModel.revisionMark,
              labelText: 'Revision mark',
            ),
            CustomTextFormField(
              enabled: enabled,
              width: totalWidth * .12,
              readOnly: true,
              initialValue: taskController.getRevTypeAndStatus(taskModel),
              labelText: 'Revision Type',
            ),
            CustomTextFormField(
              enabled: enabled,
              width: totalWidth * .12,
              readOnly: true,
              initialValue: taskController.getRevTypeAndStatus(
                taskModel,
                isStatus: true,
              ),
              labelText: 'Revision Status',
            ),
            CustomTextFormField(
              enabled: enabled,
              width: totalWidth * .1,
              readOnly: true,
              initialValue: taskModel.changeNumber.toString(),
              labelText: 'ECF Number',
            ),
            // SizedBox(width: 2),
            CustomTextFormField(
              enabled: enabled,
              width: totalWidth * .08,
              readOnly: true,
              initialValue: taskModel.creationDate!.toDMYhm(),
              labelText: 'Task create date',
            ),
            CustomTextFormField(
              enabled: enabled,
              width: totalWidth * .09,
              readOnly: true,
              initialValue: stageController.lastActivityAndStatusDate(
                taskModel,
                isStatus: true,
              ),
              labelText: 'Status date',
            ),
            CustomTextFormField(
              enabled: enabled,
              width: totalWidth * .09,
              readOnly: true,
              initialValue:
                  stageController.lastActivityAndStatusDate(taskModel),
              labelText: 'Last activity date',
            ),
            CustomTextFormField(
              enabled: enabled,
              width: totalWidth * .04,
              readOnly: true,
              initialValue: taskController.precentageProvider(taskModel),
              labelText: 'Completion %',
            ),
            CustomTextFormField(
              enabled: enabled,
              width: totalWidth * .19,
              initialValue: taskController.getActivityStatus(taskModel),
              labelText: 'Activity Status',
            ),
          ],
        ),
        SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            CustomTextFormField(
              initialValue: taskModel.referenceDocuments.join(', '),
              width: totalWidth * .44,
              enabled: enabled,
              labelText: 'Reference Documents',
            ),
            CustomTextFormField(
              initialValue: taskModel.note,
              enabled: enabled,
              width: totalWidth * .35,
              labelText: 'Note',
            ),
            SizedBox(width: 145),
            if (staffController.isCoordinator)
              Container(
                width: (totalWidth * .333) * .3,
                child: ElevatedButton(
                  onPressed: () =>
                      taskController.buildUpdateForm(id: taskModel.id!),
                  child: Text('Edit'),
                ),
              )
          ],
        ),
      ],
    );
  }
}
