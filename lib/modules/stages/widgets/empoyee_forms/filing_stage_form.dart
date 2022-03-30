import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:file_picker/src/file_picker_result.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilingStageForm extends StatelessWidget {
  FilingStageForm({Key? key}) : super(key: key);

  final List<List<String>> fileTypeList = [
    ['General Arrangement Drawing - .dwg', 'dwg'],
    ['General Arrangement Drawing - .pdf', 'pdf'],
    ['Assembly Drawings - .dwg', 'dwg'],
    ['Assembly Drawings - .pdf', 'pdf'],
    ['Single Part Drawings - .dwg', 'dwg'],
    ['Single Part Drawings - .pdf', 'pdf'],
    ['Weld Report - .csv', 'csv'],
    ['MTO Report - .csv', 'csv'],
    ['Drawing List - .csv', 'csv'],
    ['Weld Index - .pdf', 'pdf'],
    ['3D file export - .dwg', 'dwg'],
    ['3D file export - .ifc', 'ifc'],
  ];

  final RxList<List<String>> fileNamesList = RxList(<List<String>>[
    <String>[],
    <String>[],
    <String>[],
    <String>[],
    <String>[],
    <String>[],
    <String>[],
    <String>[],
    <String>[],
    <String>[],
    <String>[],
    <String>[],
  ]);

  final RxBool isChecked = false.obs;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        height: 384,
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                fileTypeList.length,
                (ind) => Row(
                  children: [
                    SizedBox(
                      width: 250,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [Text('${fileTypeList[ind][0]}')],
                      ),
                    ),
                    SizedBox(width: 20),
                    Column(
                      children: [
                        Obx(
                          () => ElevatedButton(
                            onPressed: () =>
                                stageController.onFileButtonPressed(
                              allowedExtensions: [fileTypeList[ind][1]],
                              allowMultiple: !(ind > 5),
                              fun: (FilePickerResult result) =>
                                  func(result, ind),
                            ),
                            child: Center(
                              child: Text(
                                'Files (${fileNamesList[ind].length})',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 20),
                    Column(
                      children: [
                        TextButton(
                          onPressed: () => filesDialog(fileNamesList[ind]),
                          child:
                              Obx(() => Text('${fileNamesList[ind].length}')),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Obx(() {
                      return Checkbox(
                        checkColor: Colors.white,
                        value: isChecked.value,
                        onChanged: (bool? isCh) => isChecked.value = isCh!,
                      );
                    }),
                    Column(
                      children: [
                        SizedBox(height: 6),
                        Text(
                          'By clicking this checkbox I confirm that all files\nare attached correctly and below appropriate task',
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                CustomTextFormField(
                  width: 340,
                  maxLines: 5,
                  labelText: 'Note',
                  controller: stageController.textEditingControllers.last,
                ),
                SizedBox(height: 20),
                Obx(() {
                  return ElevatedButton(
                    onPressed: !isChecked.value
                        ? null
                        : () {
                            stageController.fileNames.value =
                                fileNamesList.reduce((a, b) => a + b).toList();
                            stageController.onSubmitPressed();
                          },
                    child: Text('Submit'),
                  );
                }),
              ],
            )
          ],
        ),
      ),
    );
  }

  void func(FilePickerResult result, int ind) =>
      fileNamesList[ind] = result.files.map((file) => file.name).toList();
}
