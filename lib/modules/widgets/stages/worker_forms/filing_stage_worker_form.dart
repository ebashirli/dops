import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/constants/lists.dart';
import 'package:dops/modules/models/value_model.dart';
import 'package:dops/services/file_api/file_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilingStageWorkerForm extends StatelessWidget {
  FilingStageWorkerForm({Key? key, required this.valueModel}) : super(key: key);
  final ValueModel valueModel;
  final RxBool isChecked = false.obs;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Form(
      key: formKey,
      child: Container(
        height: 384,
        child: Row(
          children: [
            Column(
              children: [
                FilingFilesFormWidget(valueModel: valueModel),
                if (valueModel.submitDateTime != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        onPressed: () => dowloadFiles(ids: [valueModel.id]),
                        child: Text('Download all'),
                      )
                    ],
                  ),
              ],
            ),
            SizedBox(width: 40),
            if (valueModel.employeeId == staffController.currentUserId &&
                valueModel.submitDateTime == null)
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
                      controller: stageController.textEditingControllers.last,
                    ),
                    SizedBox(height: 6),
                    Obx(() {
                      return Column(
                        children: [
                          CheckboxListTile(
                            title: Text(
                                'By clicking this checkbox I confirm that all files are attached correctly and below appropriate task'),
                            controlAffinity: ListTileControlAffinity.leading,
                            checkColor: Colors.white,
                            value: isChecked.value,
                            onChanged: (bool? isCh) => isChecked.value = isCh!,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: !isChecked.value
                                    ? null
                                    : stageController.onSubmitPressed,
                                child: Text('Submit'),
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class FilingFilesFormWidget extends StatelessWidget {
  final ValueModel valueModel;
  const FilingFilesFormWidget({Key? key, required this.valueModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: filingFileTypes.map(
        (filingFileType) {
          filingFileType.fileNames =
              valueModel.toMap()[filingFileType.dbName] ?? [];
          return Row(
            children: [
              SizedBox(
                width: 250,
                child: CustomText('${filingFileType.folderName}'),
              ),
              SizedBox(width: 20),
              if (valueModel.employeeId == staffController.currentUserId &&
                  valueModel.submitDateTime == null)
                ElevatedButton(
                  onPressed: () => stageController.onFileButtonPressed(
                      uploadingFiles: filingFileType),
                  child: Text('Files (${filingFileType.files.length})'),
                ),
              SizedBox(width: 20),
              getFileCountButton(filingFileType),
            ],
          );
        },
      ).toList(),
    );
  }

  TextButton getFileCountButton(FilingFileType filingFileType) {
    return TextButton(
      onPressed: filingFileType.fileNames.isEmpty
          ? null
          : () => homeController.getDialog(
                barrierDismissible: true,
                title: 'Files',
                content: filesDialog(
                  filingFileType.fileNames,
                  files: filingFileType.files,
                  valueModelIds: valueModel.submitDateTime == null
                      ? null
                      : [valueModel.id],
                  filingFolder: filingFileType.folderName,
                  valueModelId:
                      valueModel.submitDateTime == null ? null : valueModel.id,
                ),
              ),
      child: Text('${filingFileType.fileNames.length}'),
    );
  }
}
