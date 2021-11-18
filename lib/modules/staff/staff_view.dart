import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/table_view_widget.dart';
import 'staff_controller.dart';

class StaffView extends StatelessWidget {
  final controller = Get.find<StaffController>();
  final tableName = 'staff';
  late final List<Map<String, Widget>> documents;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Stack(
          children: [
            if (controller.getDataForTableView.isEmpty)
              Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            TableView(
              controller: controller,
              tableName: tableName,
            ),
          ],
        );
      },
    );
  }
}
