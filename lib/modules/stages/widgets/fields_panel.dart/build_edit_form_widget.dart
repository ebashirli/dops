import 'package:dops/constants/constant.dart';
import 'package:dops/constants/style.dart';
import 'package:dops/modules/drawing/drawing_model.dart';
import 'package:dops/modules/stages/widgets/fields_panel.dart/drawing_fields_panel.dart';
import 'package:dops/modules/stages/widgets/fields_panel.dart/task_fields_panel.dart';
import 'package:dops/modules/task/task_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuildEditFormWidget extends StatelessWidget {
  const BuildEditFormWidget({Key? key}) : super(key: key);

  @override
  Widget build(_) {
    return Obx(
      () {
        if (taskController.documents.isNotEmpty) {
          TaskModel taskModel = taskController.documents
              .singleWhere((task) => task!.id == Get.parameters['id'])!;

          DrawingModel drawingModel = drawingController.documents
              .singleWhere((drawing) => drawing.id == taskModel.parentId);

          drawingController.fillEditingControllers(
            drawingModel: drawingModel,
            taskModel: taskModel,
          );
          return _buildEditFormWidget(
            drawingModel: drawingModel,
            taskModel: taskModel,
            isCoordinator: staffController.isCoordinator,
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget _buildEditFormWidget({
    required DrawingModel drawingModel,
    required TaskModel taskModel,
    required isCoordinator,
  }) {
    final String fullTaskNumber =
        '${drawingModel.drawingNumber}-${taskModel.revisionMark}';
    return Container(
      height: 440,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Drawing details of ${drawingModel.drawingNumber}',
            style: kBold18,
          ),
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
          Text(
            'Stages of $fullTaskNumber',
            style: kBold18,
          ),
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
