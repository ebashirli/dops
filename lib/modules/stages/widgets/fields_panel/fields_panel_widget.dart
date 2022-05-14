import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/constants/style.dart';
import 'package:dops/modules/drawing/drawing_model.dart';
import 'package:dops/modules/stages/widgets/fields_panel/drawing_fields_panel.dart';
import 'package:dops/modules/stages/widgets/fields_panel/task_fields_panel.dart';
import 'package:dops/modules/task/task_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FieldsPanelWidget extends StatelessWidget {
  const FieldsPanelWidget({Key? key}) : super(key: key);

  @override
  Widget build(_) {
    return Obx(
      () {
        return taskController.loading.value
            ? CircularProgressIndicator()
            : (stageController.currentTask == null ||
                    stageController.currentDrawing == null)
                ? CustomText('Task not found!')
                : _buildFieldPanelsWidget(
                    taskModel: stageController.currentTask!,
                    drawingModel: stageController.currentDrawing!,
                  );
      },
    );
  }

  Widget _buildFieldPanelsWidget({
    required TaskModel taskModel,
    required DrawingModel drawingModel,
  }) {
    final String fullTaskNumber =
        '${drawingModel.drawingNumber}-${taskModel.revisionMark}';
    return SizedBox(
      height: Get.height * .43,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(
            'Drawing details of ${drawingModel.drawingNumber}',
            style: kBold18,
          ),
          SizedBox(height: 10),
          DrawingFieldsWidget(drawingModel: drawingModel),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                'Task details of $fullTaskNumber',
                style: kBold18,
              ),
              TextButton(
                onPressed: () {},
                child: Text('Other revisions'),
              ),
            ],
          ),
          SizedBox(height: 16),
          TaskFieldsWidget(taskModel: taskModel),
          Divider(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: stageIndicators(),
          ),
          Divider(),
          CustomText('Stages of $fullTaskNumber', style: kBold18),
        ],
      ),
    );
  }

  List<Widget> stageIndicators() {
    return List.generate(
      10,
      (index) {
        return Row(
          children: [
            Container(
              height: 20,
              width: (Get.width - 280) / 10,
              color: index == stageController.indexOfLast
                  ? Colors.green
                  : index > stageController.maxIndex
                      ? Colors.grey
                      : Colors.yellow,
              child: Center(child: CustomText('${index + 1}')),
            ),
            Container(width: 2),
          ],
        );
      },
    );
  }
}
