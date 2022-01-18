import 'package:dops/constants/lists.dart';
import 'package:flutter/material.dart';

import 'coordinator_form_widget.dart';
import 'user_form_widget.dart';

class ExpansionPanelBodyWidget extends StatelessWidget {
  ExpansionPanelBodyWidget({Key? key, required this.index}) : super(key: key);

  final int index;
  GlobalKey<FormState> coordinatorFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> userFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CoordinatorFormWidget(
          index: index,
          formKey: coordinatorFormKey,
        ),
        // if (stageDetailsList[index]['get files'] != null)
        //   GetFilesButton(index: index),
        UserFormWidget(
          index: index,
          formKey: coordinatorFormKey,
        ),
      ],
    );
  }
}
