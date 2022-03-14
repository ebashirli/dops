import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskForm extends StatelessWidget {
  const TaskForm({Key? key, this.id}) : super(key: key);

  final String? id;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(8),
          topLeft: Radius.circular(8),
        ),
        color: light,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: taskController.taskFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Container(
            width: Get.width * .5,
            child: Column(
              children: [
                Container(
                  height: 540,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: <Widget>[
                            // Text(
                            //   //  TODO: ask Ismayil
                            //   'Current Revision: ${id.drawingNumber}${selectedTask != null ? '-' + selectedTask!.revisionMark : ''}',
                            //   style: TextStyle(
                            //     fontSize: 18,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            // ),
                            SizedBox(height: 10),
                            CustomTextFormField(
                              controller:
                                  taskController.nextRevisionMarkController,
                              labelText: 'Next Revision number',
                            ),
                            CustomDropdownMenu(
                              showSearchBox: true,
                              isMultiSelectable: true,
                              labelText: 'Reference Documents',
                              items: itemsReferenceDocuments(),
                              onChanged: onReferenceDocumentsChanged,
                              selectedItems:
                                  taskController.referenceDocumentsList,
                            ),
                            CustomTextFormField(
                              controller: taskController.taskNoteController,
                              labelText: 'Note',
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: Row(
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () => Get.back(),
                        child: const Text('Cancel'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => id == null
                            ? taskController.onAddNextRevisionPressed(id)
                            : taskController.updateTaskFields(
                                map: {},
                                id: id!,
                              ),
                        child: Text(id != null ? 'Update' : 'Add'),
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

  void onReferenceDocumentsChanged(values) =>
      taskController.referenceDocumentsList = values;

  List<String> itemsReferenceDocuments() {
    return referenceDocumentController.documents
        .map((document) => document.documentNumber)
        .toList();
  }
}


// if (taskId != null) {
//         Map<String, dynamic> revisedTaskFields = {
//           'referenceDocuments': drawingController.referenceDocumentsList,
//           'revisionMark': drawingController.nextRevisionMarkController.text,
//           'note': drawingController.taskNoteController.text,
//         };

//         taskController.updateTaskFields(
//           map: revisedTaskFields,
//           id: taskId!,
//         );
//       }