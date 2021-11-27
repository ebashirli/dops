import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/table_view_widget.dart';
import 'drawing_controller.dart';

class TaskView extends StatelessWidget {
  final controller = Get.find<TaskController>();
  final tableName = 'task';

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Stack(children: [
          if (controller.getDataForTableView.isEmpty)
            Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          TableView(
            controller: controller,
            tableName: tableName,
          )
        ]);
      },
    );
  }
}
