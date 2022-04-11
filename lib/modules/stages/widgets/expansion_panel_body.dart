import 'package:dops/constants/constant.dart';
import 'package:dops/modules/stages/widgets/expantion_panel_item_model.dart';
import 'package:dops/modules/stages/widgets/text_button_for_past_cycles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpansionPanelBody extends StatelessWidget {
  const ExpansionPanelBody({Key? key, required this.item}) : super(key: key);
  final ExpantionPanelItemModel item;

  @override
  Widget build(BuildContext context) => Obx(
        () {
          return Column(
            children: <Widget>[
              if (stageController.isCoordinatorFormVisible(item))
                item.coordinatorForm,
              if (stageController.isWorkerFormVisible(item)) workerForm(item),
              if ([4, 5, 6].contains(item.index))
                TxtButtonForPastCycles(index: item.index),
              item.valueTable,
            ],
          );
        },
      );

  Widget workerForm(ExpantionPanelItemModel item) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: item.workerForm,
    );
  }
}
