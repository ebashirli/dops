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
        return Stack(
          children: [
            if (controller.documents.isEmpty)
              Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            Padding(
              padding: EdgeInsets.only(left: 200, top: 20),
              child: Container(
                // decoration: BoxDecoration(
                //     border: Border.all(width: 1.0, color: Colors.grey)),
                child: TableView(
                  controller: controller,
                  tableName: tableName,
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
