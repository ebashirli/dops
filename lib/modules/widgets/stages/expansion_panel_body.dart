import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/modules/widgets/stages/stage_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpansionPanelBody extends StatelessWidget {
  const ExpansionPanelBody({Key? key, required this.item}) : super(key: key);
  final ExpantionPanelItemModel item;

  @override
  Widget build(BuildContext context) => Obx(
        () {
          String? coordinatorNote =
              stageController.getCoordinatorNoteByindex(item.index);
          return Column(
            children: <Widget>[
              stageController.isCoordinatorFormVisible(item)
                  ? item.coordinatorForm
                  : coordinatorNote == null || coordinatorNote == ''
                      ? SizedBox()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 10),
                            CustomText(
                              "Coordinator note: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            CustomText(coordinatorNote),
                          ],
                        ),
              if ([3, 4, 5, 6].contains(item.index))
                Row(
                  children: <Widget>[
                    TextButton(
                      key: Key('Download${item.index}'),
                      onPressed: () => stageController.download(item.index),
                      child: Text('Get files'),
                    ),
                    // TextButton(
                    //   key: Key('Copy${item.index}'),
                    //   onPressed: () =>
                    //       stageController.copyToClipBoard(item.index - 1),
                    //   child: Text('Copy address'),
                    // ),
                  ],
                ),
              if (stageController.isWorkerFormVisible(item)) workerForm(item),
              if ([4, 5, 6].contains(item.index)) PastCycles(index: item.index),
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
