import 'package:dops/controllers/staff_controller.dart';
import 'package:dops/widgets/table_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StaffView extends StatelessWidget {
  final controller = Get.find<StaffController>();
  final tableName = 'staff';
  late final List<Map<String, dynamic>> documents;

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
