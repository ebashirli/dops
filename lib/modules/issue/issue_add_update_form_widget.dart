import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/constants/style.dart';
import 'package:dops/modules/issue/issue_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IssueAddUpdateFormWidget extends StatelessWidget {
  const IssueAddUpdateFormWidget({
    Key? key,
    this.id,
  }) : super(key: key);
  final String? id;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(8),
          topLeft: Radius.circular(8),
        ),
        color: light, //Color(0xff1E2746),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: issueController.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Container(
            width: Get.width * .3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 150,
                      child: Obx(
                        () => Row(
                          children: [
                            ElevatedButton(
                              onPressed: onFilesPressed,
                              child: Center(
                                child: Text(filesNumber),
                              ),
                            ),
                            SizedBox(width: 10),
                            if (id != null) filesCountTextButton(id!),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: CustomTextFormField(
                        width: 250,
                        controller: issueController.noteController,
                        labelText: 'Note',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  child: Row(
                    children: <Widget>[
                      if (id != null)
                        ElevatedButton.icon(
                          onPressed: onDeletePressed,
                          icon: const Icon(Icons.delete),
                          label: const Text('Delete'),
                          style: deleteStyle(),
                        ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: onCancelPressed,
                        child: const Text('Cancel'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: onAddUpdatePressed,
                        child: Text(addOrUpdate()),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String get filesNumber => 'Files (${issueController.fileNames.length})';

  ButtonStyle deleteStyle() {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(
        Colors.red,
      ),
    );
  }

  void onCancelPressed() => Get.back();

  String addOrUpdate() => id != null ? 'Update' : 'Add';

  void onAddUpdatePressed() {
    IssueModel model = IssueModel(
      note: issueController.noteController.text,
      creationDate: DateTime.now(),
      createdBy: staffController.currentUserId,
      files: issueController.fileNames,
      linkedTaskIds: issueController.linkedTaskIds,
      groupNumber: issueController.maxGroupNumber + 1,
    );
    id == null
        ? issueController.saveDocument(model: model)
        : issueController.updateDocument(id!);
  }

  void onDeletePressed() {
    issueController.deleteIssue(id!);
    Get.back();
  }

  void onFilesPressed() {
    stageController.onFileButtonPressed(
      allowMultiple: true,
      fun: fun,
    );
  }

  void fun(FilePickerResult result) {
    issueController.fileNames.value =
        result.files.map((file) => file.name).toList();
    issueController.files.value = result.files;
  }

  TextButton filesCountTextButton(String id) {
    return TextButton(
      onPressed: () => filesDialog(getFileNames(id)),
      child: Text(getFileCounts(id)),
    );
  }

  List<String?> getFileNames(String id) {
    IssueModel? issueModel = issueController.getById(id);
    return issueModel == null ? [] : issueModel.files;
  }

  String getFileCounts(String id) {
    IssueModel? issueModel = issueController.getById(id);
    List<String?> files = issueModel == null ? [] : issueModel.files;
    return files.isEmpty ? '0' : files.length.toString();
  }
}
