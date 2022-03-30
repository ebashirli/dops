import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/modules/task/task_model.dart';
import 'package:dops/modules/values/value_model.dart';
import 'package:flutter/material.dart';
import 'package:dops/components/date_time_extension.dart';
import 'package:get/get.dart';

class TaskUpdateFormWidget extends StatelessWidget {
  const TaskUpdateFormWidget({Key? key, required this.taskModel})
      : super(key: key);
  final TaskModel taskModel;

  @override
  Widget build(BuildContext context) {
    final double totalWidth = Get.width - 120;
    final bool enabled = false;
    taskController.documents
        .sort((a, b) => a!.creationDate!.compareTo(b!.creationDate!));

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            CustomTextFormField(
              enabled: enabled,
              width: totalWidth * .04,
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
              width: totalWidth * .12,
              readOnly: true,
              initialValue: taskModel.changeNumber.toString(),
              labelText: 'ECF Number',
            ),
            CustomTextFormField(
              enabled: enabled,
              width: totalWidth * .12,
              readOnly: true,
              initialValue: taskModel.creationDate!.toDMYhm(),
              labelText: 'Task create date',
            ),
            CustomTextFormField(
              enabled: enabled,
              width: totalWidth * .16,
              readOnly: true,
              initialValue: lastActivityDate(taskModel.id),
              labelText: 'Last activity date',
            ),
            CustomTextFormField(
              enabled: enabled,
              width: totalWidth * .04,
              readOnly: true,
              initialValue: '40%',
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
              width: totalWidth * .445,
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
                  onPressed: () => taskController.buildAddEdit(
                    id: taskModel.id,
                    fromStages: true,
                  ),
                  child: Text('Edit'),
                ),
              )
          ],
        ),
      ],
    );
  }

  String? lastActivityDate(taskId) {
    final List<ValueModel?> valueModelsList =
        stageController.valueModelsByTaskId(taskId)[stageController.lastIndex]!
            [stageController.lastTaskStage]!;

    DateTime assignedDateTime = DateTime(0);

    if (valueModelsList.isNotEmpty)
      assignedDateTime = valueModelsList
          .map((e) => e!.assignedDateTime)
          .reduce((a, b) => a.isAfter(b) ? a : b);

    return '${<DateTime>[
      stageController.lastTaskStage.creationDateTime,
      assignedDateTime
    ].reduce((a, b) => a.isAfter(b) ? a : b).toDMYhm()}';
  }
}
