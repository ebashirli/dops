import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'stages_controller.dart';

class StagesView extends StatelessWidget {
  final controller = Get.find<StagesController>();
  final tableName = 'stages';
  late final List<Map<String, dynamic>> documents;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Text('1');
      },
    );
  }
}
