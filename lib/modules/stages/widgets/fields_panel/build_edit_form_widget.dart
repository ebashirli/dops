import 'package:dops/constants/constant.dart';
import 'package:dops/constants/style.dart';
import 'package:dops/modules/drawing/drawing_model.dart';
import 'package:dops/modules/stages/widgets/fields_panel/drawing_fields_panel.dart';
import 'package:dops/modules/stages/widgets/fields_panel/task_fields_panel.dart';
import 'package:dops/modules/task/task_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuildEditFormWidget extends StatelessWidget {
  const BuildEditFormWidget({Key? key}) : super(key: key);

  @override
  Widget build(_) {
    return Obx(
      () {
        return taskController.loading.value
            ? CircularProgressIndicator()
            : (stageController.currentTask == null ||
                    stageController.currentDrawing == null)
                ? Text('Task not found!')
                : _buildEditFormWidget(
                    taskModel: stageController.currentTask!,
                    drawingModel: stageController.currentDrawing!,
                  );
      },
    );
  }

  Widget _buildEditFormWidget({
    required TaskModel taskModel,
    required DrawingModel drawingModel,
  }) {
    final String fullTaskNumber =
        '${drawingModel.drawingNumber}-${taskModel.revisionMark}';
    return Container(
      height: Get.height * .47,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Drawing details of ${drawingModel.drawingNumber}',
            style: kBold18,
          ),
          SizedBox(height: 20),
          DrawingUpdateFormWidget(drawingModel: drawingModel),
          Text(
            'Task details of $fullTaskNumber',
            style: kBold18,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: stageIndicators(),
          ),
          SizedBox(height: 20),
          TaskUpdateFormWidget(taskModel: taskModel),
          SizedBox(height: 10),
          Text('Stages of $fullTaskNumber', style: kBold18),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  List<Widget> stageIndicators() {
    return List.generate(
      10,
      (index) => Row(
        children: [
          Container(
            height: 20,
            width: (Get.width - 280) / 10,
            color: index < stageController.maxIndex
                ? index == stageController.lastIndex
                    ? Colors.green
                    : Colors.yellow
                : Colors.grey,
            child: Center(child: Text('${index + 1}')),
          ),
          Container(width: 2),
        ],
      ),
    );
  }
}
