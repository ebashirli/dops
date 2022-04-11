import 'package:dops/components/custom_dropdown_menu_with_model_widget.dart';
import 'package:dops/components/custom_text_form_field_widget.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/constants/lists.dart';
import 'package:dops/modules/staff/staff_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CoordinatorForm extends StatefulWidget {
  const CoordinatorForm(
      {Key? key, required this.index, required bool this.visible})
      : super(key: key);
  final int index;
  final bool visible;

  @override
  State<CoordinatorForm> createState() => _CoordinatorFormState();
}

class _CoordinatorFormState extends State<CoordinatorForm> {
  String get labelText => stageDetailsList[widget.index]['staff job'];

  @override
  Widget build(BuildContext context) {
    if (widget.index == 9)
      return ElevatedButton(onPressed: () {}, child: Text('Done'));
    return Obx(() => Visibility(
          visible: widget.visible,
          child: Column(
            children: [
              SizedBox(height: 10),
              if (widget.index != 9)
                Row(
                  children: [
                    const SizedBox(width: 10),
                    CustomDropdownMenuWithModel<StaffModel>(
                      items: staffController.documents,
                      selectedItems: stageController.assignedStaffModels,
                      onChanged: onChanged,
                      itemAsString: itemAsString,
                      labelText: labelText,
                      isMultiselection:
                          [1, 2, 3, 4, 5, 8].contains(widget.index),
                    ),
                    const SizedBox(width: 20),
                    CustomTextFormField(
                      controller: stageController.coordinatorNoteController,
                      width: 400,
                      labelText: 'Note',
                    ),
                    const SizedBox(width: 20),
                    if (stageController.assigningStaffModels.isNotEmpty &&
                        !listEquals(stageController.assignedStaffModels,
                            stageController.assigningStaffModels))
                      ElevatedButton(
                        onPressed: () {
                          stageController.onAssignOrUpdatePressed();
                        },
                        child: Text(stageController.coordinatorAssigns
                            ? 'Assign'
                            : 'Update'),
                      )
                  ],
                )
            ],
          ),
        ));
  }

  void onChanged(List<StaffModel?> listStaffModel) {
    stageController.assigningStaffModels.value = listStaffModel;
  }

  String itemAsString(StaffModel? staffModel) =>
      '${staffModel!.name} ${staffModel.surname}';
}
