import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/table_view_widget.dart';
import 'activity_controller.dart';

class ActivityView extends StatelessWidget {
  final controller = Get.find<ActivityController>();
  final tableName = 'activity';

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
