import 'package:dops/constants/constant.dart';
import 'package:dops/modules/stages/stages/expantion_panel_item_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpansionPanelBody extends StatelessWidget {
  const ExpansionPanelBody({Key? key, required this.item}) : super(key: key);
  final ExpantionPanelItemModel item;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          children: <Widget>[
            if (staffController.isCoordinator) item.coordinatorForm,
            if (stageController.isWorkerFormVisible) item.workerForm,
            item.valueTable,
          ],
        ));
  }
}
