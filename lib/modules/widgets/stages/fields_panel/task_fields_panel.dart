import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/modules/models/task_model.dart';
import 'package:dops/modules/widgets/stages/stage_widgets.dart';
import 'package:flutter/material.dart';

class TaskFieldsWidget extends StatelessWidget {
  const TaskFieldsWidget({Key? key, required this.taskModel}) : super(key: key);
  final TaskModel taskModel;

  @override
  Widget build(BuildContext context) {
    final bool readonly = true;

    final double width = MediaQuery.of(context).size.width;
    final double btwFields = width * .005;
    final double btwColumns = width * .01;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Flexible(
          flex: 4,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlexTextWidget(
                    initialValue: taskModel.revisionMark,
                    labelText: 'Revision mark',
                  ),
                  SizedBox(width: btwFields),
                  FlexTextWidget(
                    initialValue: taskController.getRevTypeAndStatus(taskModel),
                    labelText: 'Revision Type',
                  ),
                  SizedBox(width: btwFields),
                  FlexTextWidget(
                    initialValue: taskController.getRevTypeAndStatus(
                      taskModel,
                      isStatus: true,
                    ),
                    labelText: 'Revision Status',
                  ),
                  SizedBox(width: btwFields),
                  FlexTextWidget(
                    initialValue: taskModel.changeNumber == 0
                        ? " "
                        : '${taskModel.changeNumber}',
                    labelText: 'ECF Number',
                  ),
                ],
              ),
              SizedBox(height: 8),
              CustomTextFormField(
                initialValue: taskModel.referenceDocuments.join(', '),
                readOnly: readonly,
                labelText: 'Reference Documents',
              ),
            ],
          ),
        ),
        SizedBox(width: btwColumns),
        Flexible(
          flex: 4,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlexTextWidget(
                    initialValue: taskModel.creationDate!.toDMYhm(),
                    labelText: 'Task create date',
                  ),
                  SizedBox(width: btwFields),
                  FlexTextWidget(
                    initialValue: stageController.lastActivityAndStatusDate(
                      taskModel,
                      isStatus: true,
                    ),
                    labelText: 'Status date',
                  ),
                  SizedBox(width: btwFields),
                  FlexTextWidget(
                    initialValue:
                        stageController.lastActivityAndStatusDate(taskModel),
                    labelText: 'Last activity date',
                  ),
                  SizedBox(width: btwFields),
                  FlexTextWidget(
                    controller: TextEditingController()
                      ..text = taskController
                          .precentageProvider(taskModel)
                          .toString(),
                    labelText: 'Completion %',
                  ),
                ],
              ),
              SizedBox(height: 8),
              CustomTextFormField(
                initialValue: taskModel.note,
                readOnly: readonly,
                labelText: 'Note',
              ),
            ],
          ),
        ),
        SizedBox(width: btwColumns),
        Flexible(
          flex: 2,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlexTextWidget(
                    initialValue: taskModel.activityStatus,
                    labelText: 'Activity Status',
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  SizedBox(height: 32),
                  if (staffController.isCoordinator)
                    ElevatedButton(
                      onPressed: () =>
                          taskController.buildUpdateForm(id: taskModel.id!),
                      child: Text('Edit'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
