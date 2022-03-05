import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/constants/lists.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkerForm extends StatelessWidget {
  WorkerForm({Key? key, required this.index, bool this.visible = false})
      : super(key: key);
  final int index;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Visibility(
        visible: visible,
        child: Form(
          child: Column(
            children: [
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ...List.generate(
                    stageController.specialFieldNames.length,
                    (ind) => CustomTextFormField(
                        isNumber: true,
                        width: 80,
                        labelText: stageController.specialFieldNames[ind],
                        controller:
                            stageController.textEditingControllers[ind]),
                  ),
                  if (stageDetailsList[index]['file names'] != null)
                    ElevatedButton(
                      onPressed: onPressed,
                      child: Center(
                        child: Text(
                          'Files (${stageController.fileNames.length})',
                        ),
                      ),
                    ),
                  if (stageDetailsList[index]['comment'] != null)
                    CustomDropdownMenu(
                      bottomPadding: 0,
                      sizeBoxHeight: 0,
                      width: 140,
                      onChanged: (value) => stageController
                          .commentCheckbox.value = value == 'With',
                      selectedItems: [''],
                      items: ['', 'With', 'Without'],
                    ),
                  CustomTextFormField(
                    width: 200,
                    maxLines: 2,
                    labelText: 'Note',
                    controller: stageController.textEditingControllers.last,
                  ),
                  ElevatedButton(
                    onPressed: stageController.onSubmitPressed,
                    child: Text('Submit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  void onPressed() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (result != null) {
      print(result.files.map((file) => file.name).toList());
      stageController.fileNames.value =
          result.files.map((file) => file.name).toList();
    }
  }
}
