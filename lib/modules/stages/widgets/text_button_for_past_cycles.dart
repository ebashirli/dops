import 'package:dops/constants/constant.dart';
import 'package:dops/modules/stages/widgets/value_table_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TxtButtonForPastCycles extends StatelessWidget {
  final int index;

  const TxtButtonForPastCycles({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          child: Text('Values of past cycles'),
          onPressed: onPressed,
        ),
        SizedBox(width: 20),
      ],
    );
  }

  void onPressed() => Get.defaultDialog(
        title: 'Values of past cycles',
        content: PastCycleContent(
          index: index,
        ),
      );
}

class PastCycleContent extends StatelessWidget {
  final int index;

  const PastCycleContent({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(
            stageController.taskValueModels[index].length,
            (int ind) {
              var list =
                  stageController.taskValueModels[index].keys.toList()[ind];
              return Column(
                children: [
                  Text(
                      '${list.index} - ${list.checkerCommentCounter} - ${list.reviewerCommentCounter}'),
                  ValueTableView(
                    index: index,
                    stageValueModelsList: stageController.taskValueModels[index]
                        [stageController.taskValueModels[index].keys
                            .toList()[ind]],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
