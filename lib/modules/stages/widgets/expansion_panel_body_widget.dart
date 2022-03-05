import 'package:flutter/material.dart';

class ExpansionPanelBodyWidget extends StatelessWidget {
  ExpansionPanelBodyWidget({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // if (staffController.isCoordinator &&
        //     stageController.lastIndex == index)
        //   CoordinatorFormWidget(),
        // if (stageDetailsList[index]['get files'] != null)
        //   GetFilesButton(index: index),
        // if (stageController.isUserFormVisible) UserFormWidget(),
        // ValuesListViewWidget(),
      ],
    );
  }
}
