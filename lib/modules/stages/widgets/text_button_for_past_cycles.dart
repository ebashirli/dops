import 'package:dops/constants/constant.dart';
import 'package:dops/modules/stages/widgets/value_table_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PastCycles extends StatelessWidget {
  final int index;

  const PastCycles({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          key: Key('Cycles$index'),
          child: Text('Values of past cycles'),
          onPressed: onPressed,
        ),
        SizedBox(width: 20),
      ],
    );
  }

  void onPressed() => Get.defaultDialog(
        title: 'Values of past cycles',
        content: PastCycleContent(index: index),
      );
}

class PastCycleContent extends StatelessWidget {
  final int index;

  const PastCycleContent({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.6,
      width: Get.width * 0.8,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            stageController.stageAndValueModelsOfCurrentTask[index]!.length,
            (int ind) {
              var list = stageController
                  .stageAndValueModelsOfCurrentTask[index]!.keys
                  .toList()[ind];
              return Column(
                children: [
                  Text(
                      '${list.index + 1} - ${list.checkerCommentCounter} - ${list.reviewerCommentCounter}'),
                  ValueTableView(
                    index: index,
                    stageValueModelsList: stageController
                            .stageAndValueModelsOfCurrentTask[index]![
                        stageController
                            .stageAndValueModelsOfCurrentTask[index]!.keys
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
