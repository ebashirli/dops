import 'package:dops/constants/constant.dart';
import 'package:dops/modules/stages/widgets/empoyee_forms/employee_forms.dart';
import 'package:dops/modules/stages/widgets/expantion_panel_item_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpansionPanelBody extends StatelessWidget {
  const ExpansionPanelBody({Key? key, required this.item}) : super(key: key);
  final ExpantionPanelItemModel item;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: <Widget>[
          if (staffController.isCoordinator) item.coordinatorForm,
          if (stageController.isWorkerFormVisible &&
              item.index == stageController.lastIndex)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: workerForm(item),
            ),
          item.valueTable,
        ],
      );
    });
  }

  Widget workerForm(ExpantionPanelItemModel item) {
    switch (item.index) {
      case 7:
        return FilingStageForm();
      case 8:
        return NestingStageForm();
      default:
        return item.workerForm;
    }
  }
}
