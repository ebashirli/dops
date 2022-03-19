import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/constants/style.dart';
import 'package:dops/modules/drawing/drawing_model.dart';
import 'package:dops/modules/task/task_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskForm extends StatelessWidget {
  const TaskForm({
    Key? key,
    this.id,
    this.newRev = false,
  }) : super(key: key);

  final String? id;
  final bool newRev;

  @override
  Widget build(BuildContext context) {
    String drawingId = homeController.dataGridController.value.selectedRow!
        .getCells()[1]
        .value;

    DrawingModel drawingModel =
        drawingController.documents.singleWhere((e) => e.id == drawingId);

    TaskModel? taskModel = newRev
        ? null
        : taskController.documents.singleWhere(
            (e) => e!.id == id,
          );

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
          key: taskController.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Container(
            width: Get.width * .3,
            child: Column(
              children: [
                Container(
                  height: Get.width * .09,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '${drawingModel.drawingNumber}${taskModel != null ? '-' + taskModel.revisionMark : ''}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          CustomTextFormField(
                            width: 80,
                            controller:
                                taskController.nextRevisionMarkController,
                            labelText: 'Next Revision number',
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: CustomTextFormField(
                              width: 200,
                              controller: taskController.taskNoteController,
                              labelText: 'Note',
                            ),
                          ),
                        ],
                      ),
                      CustomDropdownMenu(
                        showSearchBox: true,
                        isMultiSelectable: true,
                        labelText: 'Reference Documents',
                        items: itemsReferenceDocuments(),
                        onChanged: onReferenceDocumentsChanged,
                        selectedItems: taskController.referenceDocumentsList,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: Row(
                    children: <Widget>[
                      if (id != null && !newRev)
                        ElevatedButton.icon(
                          onPressed: () => taskController.onDeletePressed(id!),
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
                        child: const Text('Cancel'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => newRev
                            ? taskController
                                .onAddNextRevisionPressed(drawingModel.id)
                            : taskController.onUpdatePressed(id: id!),
                        child: Text(newRev ? 'Add' : 'Update'),
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
