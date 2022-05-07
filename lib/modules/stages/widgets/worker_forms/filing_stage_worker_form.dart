import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/constants/lists.dart';
import 'package:dops/modules/values/value_model.dart';
import 'package:dops/services/file_api/file_api.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilingStageWorkerForm extends StatelessWidget {
  FilingStageWorkerForm({Key? key, required this.valueModel}) : super(key: key);

  final ValueModel? valueModel;

  final RxBool isChecked = false.obs;

  @override
  Widget build(BuildContext context) {
    if (valueModel != null)
      for (int i = 0; i < stageController.filingFiles.length; i++) {
        stageController.filingFiles[i].fileNames =
            valueModel!.toMap()[stageController.filingFiles[i].dbName] ?? [];
      }

    return valueModel == null
        ? SizedBox()
        : Form(
            child: Container(
              height: 384,
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ...List.generate(
                        filingTypes.length,
                        (ind) => Row(
                          children: [
                            SizedBox(
                              width: 250,
                              child: Text(
                                  '${stageController.filingFiles[ind].name}'),
                            ),
                            SizedBox(width: 20),
                            if (valueModel!.employeeId ==
                                    staffController.currentUserId &&
                                valueModel!.submitDateTime == null)
                              Obx(
                                () => ElevatedButton(
                                  onPressed: () => stageController
                                      .onFileButtonPressed(
                                          allowedExtensions: [
                                        stageController
                                            .filingFiles[ind].extention
                                      ],
                                          allowMultiple: !(ind > 5),
                                          fun: (FilePickerResult result) {
                                            stageController
                                                .filingFiles[ind]
                                                .files
                                                .value = result.files.toList();
                                          }),
                                  child: Center(
                                    child: Text(
                                        'Files (${stageController.filingFiles[ind].files.length})'),
                                  ),
                                ),
                              ),
                            SizedBox(width: 20),
                            Obx(() => TextButton(
                                  onPressed: stageController
                                          .filingFiles[ind].fileNames.isEmpty
                                      ? null
                                      : () => filesDialog(
                                            stageController
                                                .filingFiles[ind].fileNames,
                                            files: stageController
                                                .filingFiles[ind].files,
                                            valueModelIds:
                                                valueModel!.submitDateTime ==
                                                        null
                                                    ? null
                                                    : [valueModel!.id],
                                            filingFolder: stageController
                                                .filingFiles[ind].name,
                                            valueModelId:
                                                valueModel!.submitDateTime ==
                                                        null
                                                    ? null
                                                    : valueModel!.id,
                                          ),
                                  child: Text(
                                      '${stageController.filingFiles[ind].fileNames.length}'),
                                )),
                          ],
                        ),
                      ),
                      if (valueModel!.submitDateTime != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            TextButton(
                              onPressed: () =>
                                  dowloadFiles(ids: [valueModel!.id]),
                              child: Text('Download all'),
                            )
                          ],
                        ),
                    ],
                  ),
                  SizedBox(width: 40),
                  if (valueModel!.employeeId == staffController.currentUserId &&
                      valueModel!.submitDateTime == null)
                    SizedBox(
                      width: 360,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HoldWidget(isContainsHold: true),
                          SizedBox(height: 10),
                          CustomTextFormField(
                            maxLines: 5,
                            labelText: 'Note',
                            controller:
                                stageController.textEditingControllers.last,
                          ),
                          SizedBox(height: 6),
                          InkWell(
                            onTap: () => isChecked.value = !isChecked.value,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Obx(() {
                                  return Checkbox(
                                    checkColor: Colors.white,
                                    value: isChecked.value,
                                    onChanged: (bool? isCh) =>
                                        isChecked.value = isCh!,
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
                          ),
                          SizedBox(height: 20),
                          Container(
                            color: Colors.amberAccent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Obx(() {
                                  return ElevatedButton(
                                    onPressed: !isChecked.value
                                        ? null
                                        : stageController.onSubmitPressed,
                                    child: Text('Submit'),
                                  );
                                }),
                                SizedBox(width: 100),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                ],
              ),
            ),
          );
  }
}
