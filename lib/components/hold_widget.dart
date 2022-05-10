import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HoldWidget extends StatelessWidget {
  const HoldWidget({
    Key? key,
    this.isContainsHold = false,
  }) : super(key: key);
  final bool isContainsHold;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            children: [
              CustomText(
                isContainsHold
                    ? valueController.containsHold.value
                        ? 'No Hold'
                        : 'Contains Hold'
                    : taskController.isHeld.value
                        ? 'Unhold: '
                        : 'Hold: ',
              ),
              Center(
                child: Switch(
                  value: isContainsHold
                      ? valueController.containsHold.value
                      : taskController.isHeld.value,
                  onChanged: (value) {
                    isContainsHold
                        ? valueController.containsHold.value = value
                        : taskController.isHeld.value = value;
                  },
                  activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.green,
                ),
              ),
            ],
          ),
          if (isContainsHold
              ? valueController.containsHold.value
              : taskController.isHeld.value)
            Expanded(
              child: CustomTextFormField(
                width: 200,
                maxLines: 2,
                controller: isContainsHold
                    ? stageController.textEditingControllers.first
                    : taskController.holdReasonController,
                labelText:
                    isContainsHold ? 'Hold Containing Reason' : 'Hold Reason',
              ),
            ),
        ],
      ),
    );
  }
}
