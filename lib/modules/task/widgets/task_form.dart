import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/modules/drawing/drawing_model.dart';
import 'package:dops/modules/task/task_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskForm extends StatelessWidget {
  const TaskForm({
    Key? key,
    this.id,
    this.newRev = false,
    this.drawingId,
  }) : super(key: key);

  final String? id;
  final bool newRev;
  final String? drawingId;

  @override
  Widget build(BuildContext context) {
    DrawingModel drawingModel = drawingController.documents.singleWhere(
      (e) =>
          e.id ==
          (drawingId ??
              taskController.documents
                  .singleWhere((e) => e!.id == id)!
                  .parentId),
    );

    TaskModel? taskModel = newRev
        ? null
        : taskController.documents.singleWhere(
            (e) => e!.id == id,
          );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text:
                '${drawingModel.drawingNumber}${taskModel != null ? '-' + taskModel.revisionMark : ''}',
            weight: FontWeight.bold,
          ),
          SizedBox(height: 10),
          Form(
            key: taskController.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Container(
              width: Get.width * .3,
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
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
                      SizedBox(height: 10),
                      CustomDropdownMenu(
                        showSearchBox: true,
                        isMultiSelectable: true,
                        labelText: 'Reference Documents',
                        items: itemsReferenceDocuments(),
                        onChanged: onReferenceDocumentsChanged,
                        selectedItems: taskController.referenceDocumentsList,
                      ),
                      SizedBox(height: 10),
                      if (stageController.isStageAssigned(taskModel))
                        HoldWidget()
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      if (id != null && !newRev)
                        ElevatedButton.icon(
                          onPressed: () =>
                              taskController.onDeletePressed(taskModel),
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
                                .onAddNextRevisionPressed(drawingModel.id!)
                            : taskController.onUpdatePressed(id: id!),
                        child: Text(newRev ? 'Add' : 'Update'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
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
