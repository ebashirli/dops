import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/constants/style.dart';
import 'package:dops/modules/models/drawing_model.dart';
import 'package:dops/modules/models/task_model.dart';
import 'package:dops/modules/widgets/stages/stage_widgets.dart';
import 'package:dops/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FieldsPanelWidget extends StatelessWidget {
  const FieldsPanelWidget({Key? key}) : super(key: key);

  List<TaskModel?> get otherTaskModels {
    return taskController.documents
        .where((e) => [e, stageController.currentDrawingModel].contains(null)
            ? false
            : e!.parentId == stageController.currentDrawingModel!.id &&
                e.id != stageController.currentTaskModelId)
        .toList();
  }

  Widget get content {
    List<Widget> widgets = otherTaskModels
        .map((e) => TextButton(
            onPressed: () => Get.toNamed(
                  Routes.STAGES,
                  parameters: {'id': e!.id!},
                ),
            child: Text(e!.revisionMark)))
        .toList();
    return Column(children: widgets);
  }

  @override
  Widget build(_) {
    return stageController.currentTaskModel == null ||
            stageController.currentDrawingModel == null
        ? CustomText('Task not found!')
        : _buildFieldPanelsWidget(
            taskModel: stageController.currentTaskModel!,
            drawingModel: stageController.currentDrawingModel!,
          );
  }

  Widget _buildFieldPanelsWidget(
      {required TaskModel taskModel, required DrawingModel drawingModel}) {
    final String fullTaskNumber =
        '${drawingModel.drawingNumber}-${taskModel.revisionMark}';
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomText(
          'Drawing details of ${drawingModel.drawingNumber}',
          style: kBold18,
        ),
        SizedBox(height: 8),
        DrawingFieldsWidget(drawingModel: drawingModel),
        Divider(),
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            CustomText(
              'Task details of ${taskModel.revisionMark}',
              style: kBold18,
            ),
            if (otherTaskModels.isNotEmpty)
              TextButton(
                onPressed: () {
                  Get.defaultDialog(
                    title: 'Other revisions',
                    content: content,
                  );
                },
                child: Text('Other revisions'),
              ),
          ],
        ),
        SizedBox(height: 6),
        TaskFieldsWidget(taskModel: taskModel),
        Divider(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: stageProgressDiagram(),
        ),
        Divider(),
        CustomText('Stages of $fullTaskNumber', style: kBold18),
      ],
    );
  }

  List<Widget> stageProgressDiagram() {
    return List.generate(
      10,
      (index) {
        return Flexible(
          flex: 1,
          child: Row(
            children: [
              Flexible(
                flex: 9,
                child: Container(
                  height: 20,
                  // width: (Get.width - 280) / 10,
                  color: index == stageController.indexOfLast &&
                          stageController.lastTaskStageValues
                              .every((e) => e?.submitDateTime == null)
                      ? Colors.green
                      : index >= stageController.maxIndex
                          ? Colors.grey
                          : Colors.yellow,
                  child: Center(child: CustomText('${index + 1}')),
                ),
              ),
              Flexible(
                child: SizedBox(width: Get.width * .05),
              ),
            ],
          ),
        );
      },
    );
  }
}
