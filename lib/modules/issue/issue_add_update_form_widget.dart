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
                              onPressed: () =>
                                  stageController.onFileButtonPressed(
                                allowMultiple: true,
                                fun: (FilePickerResult result) {
                                  issueController.files.value = result.files
                                      .map((file) => file.name)
                                      .toList();
                                },
                              ),
                              child: Center(
                                child: Text(
                                  'Files (${issueController.files.length})',
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            if (id != null)
                              TextButton(
                                onPressed: () => filesDialog(issueController
                                    .documents
                                    .singleWhere((e) => e.id == id)
                                    .files),
                                child: Text(
                                  '${issueController.documents.singleWhere((e) => e.id == id).files.length}',
                                ),
                              ),
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
                          onPressed: () {
                            // TODO: deleteStaff(id);
                            Get.back();
                          },
                          icon: Icon(Icons.delete),
                          label: const Text('Delete'),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.red,
                            ),
                          ),
                        ),
                      const Spacer(),
                      ElevatedButton(
                          onPressed: () => Get.back(),
                          child: const Text('Cancel')),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          IssueModel model = IssueModel(
                            note: issueController.noteController.text,
                            creationDate: DateTime.now(),
                            files: issueController.files,
                            linkedTasks: issueController.linkedTaskIds,
                            groupNumber: issueController.nextGroupNumber + 1,
                          );
                          id == null
                              ? issueController.saveDocument(model: model)
                              : issueController.updateDocument(
                                  model: model, id: id!);
                        },
                        child: Text(
                          id != null ? 'Update' : 'Add',
                        ),
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
}


// CustomDropdownMenuWithModel<TaskModel?>(
                      //   width: Get.width * .49,
                      //   isMultiselection: true,
                      //   onChanged: (value) {
                      //     issueController.linkedTaskIds.value =
                      //         value.map((e) => e!.id).toList();
                      //   },
                      //   selectedItems: issueController.linkedTaskIds
                      //       .map((e) => taskController.documents.singleWhere(
                      //           (TaskModel? taskModel) => taskModel!.id == e))
                      //       .toList(),
                      //   items: taskController.documents,
                      //   itemAsString: (TaskModel? taskModel) =>
                      //       '${drawingController.documents.singleWhere((e) => e.id == taskModel!.parentId).drawingNumber}-${taskModel!.revisionMark}',
                      //   labelText: 'Linked Tasks',
                      // ),