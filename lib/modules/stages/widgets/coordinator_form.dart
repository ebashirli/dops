import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/modules/staff/staff_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CoordinatorForm extends StatelessWidget {
  CoordinatorForm({Key? key, required this.index}) : super(key: key);
  final int index;
  final RxBool isVisible = true.obs;

  Widget build(BuildContext context) {
    stageController.fillEditingControllers();
    isVisible.value = index == 9;
    return Obx(() => Column(
          children: [
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(width: 10),
                CustomDropdownMenuWithModel<StaffModel>(
                  items: staffController.documents,
                  selectedItems:
                      index == 9 && stageController.coordinatorAssigns
                          ? [staffController.currentStaff]
                          : stageController.assignedStaffModels,
                  onChanged: onStaffChanged,
                  itemAsString: itemAsString,
                  labelText: stageController.labelText,
                  isMultiSelectable:
                      [1, 2, 3, 4, 5, 8].contains(stageController.indexOfLast),
                ),
                if (index == 9)
                  CustomTextFormField(
                    width: 400,
                    labelText: 'Email',
                    controller: stageController.emailController,
                    onChanged: onEmailChanged,
                  ),
                const SizedBox(width: 20),
                CustomTextFormField(
                  controller: stageController.noteController,
                  width: 400,
                  labelText: 'Note',
                  onChanged: onNoteChanged,
                ),
                const SizedBox(width: 20),
                Obx(() {
                  if (isVisible.value) {
                    return ElevatedButton(
                      onPressed: stageController.onAssignOrUpdatePressed,
                      child: Text(
                        index == 9
                            ? 'Send to DCC'
                            : stageController.coordinatorAssigns
                                ? 'Assign'
                                : 'Update',
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                }),
              ],
            ),
          ],
        ));
  }

  void onStaffChanged(List<StaffModel?> listStaffModel) {
    stageController.assigningStaffModels.value = listStaffModel;

    if (!stageController.coordinatorAssigns) {
      if (stageController.assigningStaffModels.isNotEmpty &&
          !listEquals(stageController.assignedStaffModels,
              stageController.assigningStaffModels)) {
        isVisible.value = true;
      } else {
        isVisible.value = false;
      }
    } else {
      isVisible.value = true;
    }
  }

  String itemAsString(StaffModel? staffModel) =>
      '${staffModel!.name} ${staffModel.surname}';

  void onNoteChanged(String str) {
    if (!stageController.coordinatorAssigns) {
      if (stageController.lastTaskStage.note != str) {
        isVisible.value = true;
      } else {
        isVisible.value = false;
      }
    } else {
      isVisible.value = stageController.assigningStaffModels.isNotEmpty;
    }
  }

  void onEmailChanged(String str) {
    if (!stageController.coordinatorAssigns) {
      if (stageController.emailController.text != str) {
        isVisible.value = true;
      } else {
        isVisible.value = false;
      }
    }
  }
}
