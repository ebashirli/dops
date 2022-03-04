import 'package:dops/components/custom_dropdown_menu_with_model_widget.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/constants/lists.dart';
import 'package:dops/modules/staff/staff_model.dart';
import 'package:dops/modules/stages/stage_model.dart';
import 'package:dops/modules/values/value_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CoordinatorFormWidget extends StatefulWidget {
  CoordinatorFormWidget({Key? key}) : super(key: key);

  @override
  State<CoordinatorFormWidget> createState() => _CoordinatorFormWidgetState();
}

class _CoordinatorFormWidgetState extends State<CoordinatorFormWidget> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late int index;
  late List<ValueModel?> lastTaskStageValues;
  late StageModel lastTaskStage;

  @override
  void initState() {
    super.initState();
    lastTaskStageValues = stageController.lastTaskStageValues;
    lastTaskStage = stageController.lastTaskStage;
    index = stageController.lastIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _dropDownSearchBuilder(),
                SizedBox(width: 10),
                Obx(() => _elevatedButtonBuilder()),
              ],
            ),
          ),
        ),
        Divider(),
      ],
    );
  }

  CustomDropdownMenuWithModel<StaffModel> _dropDownSearchBuilder() {
    return CustomDropdownMenuWithModel<StaffModel>(
      isMultiselection: ![0, 6, 7].contains(index),
      itemAsString: (StaffModel? item) => '${item!.name} ${item.surname}',
      labelText: stageDetailsList[index]['staff job'],
      onChanged: (values) =>
          stageController.assigningStaffModels.value = values,
      selectedItems: stageController.taskValueModels[index].values.last
          .map((e) => staffController.documents
              .singleWhere((element) => element.id == e?.employeeId))
          .toList(),
      items: staffController.documents.isNotEmpty
          ? staffController.documents
          : null,
    );
  }

  ElevatedButton _elevatedButtonBuilder() {
    var list1 = stageController.assigningStaffModels
        .map((element) => element!.id)
        .toList()
      ..sort();
    var list2 = stageController.taskValueModels[index].values.last
        .map((valueModel) => valueModel!.employeeId)
        .toList()
      ..sort();

    return ElevatedButton(
        onPressed: ((list2.isNotEmpty && list1.isEmpty) ||
                    (list2.isEmpty && list1.isEmpty)) ||
                listEquals(list1, list2)
            ? null
            : stageController.onAssignOrUpdatePressed,
        child: Container(
            height: 48,
            child: Center(
                child: Text((stageController.coordinatorAssigns)
                    ? 'Assign'
                    : 'Update'))));
  }
}
