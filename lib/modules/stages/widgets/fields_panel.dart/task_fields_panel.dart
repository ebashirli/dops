import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/modules/task/task_model.dart';
import 'package:flutter/material.dart';
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
        .sort((a, b) => a!.taskCreateDate!.compareTo(b!.taskCreateDate!));
    final List<TaskModel?> taskModelsOfDrawing = taskController.documents
        .where((e) => e!.parentId == taskModel.parentId)
        .toList();
    final bool isTaskModelFirst = taskModelsOfDrawing.first == taskModel;
    final bool isTaskModelLast = taskModelsOfDrawing.last == taskModel;
    final int indexOfThisTaskModel =
        taskController.documents.indexOf(taskModel);

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
              initialValue: isTaskModelFirst ? 'First Issue' : 'Revision',
              labelText: 'Revision Type',
            ),
            CustomTextFormField(
              enabled: enabled,
              width: totalWidth * .12,
              readOnly: true,
              initialValue: isTaskModelLast ? 'Current' : 'Superseded',
              labelText: 'Revision Status',
            ),
            CustomTextFormField(
              enabled: enabled,
              width: totalWidth * .12,
              readOnly: true,
              initialValue: indexOfThisTaskModel.toString(),
              labelText: 'ECF Number',
            ),
            CustomTextFormField(
              enabled: enabled,
              width: totalWidth * .12,
              readOnly: true,
              initialValue: taskModel.taskCreateDate.toString(),
              labelText: 'Task create date',
            ),
            CustomTextFormField(
              enabled: enabled,
              width: totalWidth * .16,
              readOnly: true,
              initialValue: 'Last activity date', //lastActivityDate(),
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
              initialValue: taskModel.isHeld ? 'Hold' : 'Live',
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

  String? lastActivityDate() => '';
  // stageController.lastTaskStageValues.isEmpty ? stageController.lastTaskStage.creationDateTime : stageController.lastTaskStageValues.map((e) => e!.submitDateTime)

}
