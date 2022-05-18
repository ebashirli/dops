import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/constants/lists.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonWorkerForm extends StatelessWidget {
  CommonWorkerForm({Key? key, required this.index}) : super(key: key);
  final int index;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Obx(() {
      return Form(
        key: formKey,
        child: Column(
          children: [
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ...List.generate(
                  stageController.specialFieldNames.length,
                  (ind) => CustomTextFormField(
                    isNumber: index == 9 ? false : true,
                    width: index == 9 ? 200 : 80,
                    labelText: index == 9
                        ? 'Transmittal number'
                        : stageController.specialFieldNames[ind],
                    controller: stageController.textEditingControllers[ind],
                  ),
                ),
                if (stageDetailsList[index]['file names'] != null)
                  ElevatedButton(
                    onPressed: () => stageController.onFileButtonPressed(),
                    child: Center(
                        child: Text('Files (${stageController.files.length})')),
                  ),
                if (stageDetailsList[index]['comment'] != null)
                  CustomDropdownMenuWithModel<String>(
                    autoValidateMode: AutovalidateMode.always,
                    labelText: 'Comment',
                    itemAsString: (e) => e!,
                    width: 140,
                    onChanged: (value) => stageController.commentStatus.value =
                        value.contains('With'),
                    selectedItems: [''],
                    items: ['', 'With', 'Without'],
                    validator: (value) =>
                        value!.contains('') ? 'Select with or without!' : null,
                  ),
                CustomTextFormField(
                  width: 200,
                  maxLines: 2,
                  labelText: 'Note',
                  controller: stageController.textEditingControllers.last,
                ),
                ElevatedButton(
                  onPressed: () {
                    final isValid = formKey.currentState!.validate();
                    if (!isValid) {
                      return;
                    }
                    stageController.onSubmitPressed();
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
