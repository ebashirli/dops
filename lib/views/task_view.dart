import 'package:dops/controllers/task_controller.dart';
import 'package:dops/views/table_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskView extends StatelessWidget {
  final controller = Get.find<TaskController>();
  final tableName = 'task';

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return TableView(
          controller: controller,
          tableName: tableName,
        );
      },
    );
  }
}
