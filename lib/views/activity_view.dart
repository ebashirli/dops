import 'package:dops/controllers/activity_controller.dart';
import 'package:dops/views/table_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActivityView extends StatelessWidget {
  final controller = Get.find<ActivityController>();
  final tableName = 'activity';

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
