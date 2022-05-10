import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/modules/drawing/drawing_model.dart';
import 'package:dops/modules/task/task_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskAddUpdateForm extends StatelessWidget {
  const TaskAddUpdateForm({Key? key, this.id, this.drawingId})
      : super(key: key);

  final String? id;
  final String? drawingId;

  @override
  Widget build(BuildContext context) {
    TaskModel? taskModel = id == null ? null : taskController.getById(id!);

    DrawingModel? drawingModel = drawingController
        .getById(drawingId ?? (taskModel == null ? '' : taskModel.parentId!));

    return drawingModel == null
        ? CustomText('Drawing not found')
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  getTaskNumber(drawingModel, taskModel),
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
                                    controller:
                                        taskController.taskNoteController,
                                    labelText: 'Note',
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            CustomDropdownMenuWithModel<String>(
                              itemAsString: (e) => e!,
                              showSearchBox: true,
                              isMultiSelectable: true,
                              labelText: 'Reference Documents',
                              items: itemsReferenceDocuments(),
                              onChanged: onReferenceDocumentsChanged,
                              selectedItems:
                                  taskController.referenceDocumentsList,
                            ),
                            SizedBox(height: 10),
                            if (stageController.isStageAssigned(taskModel))
                              HoldWidget()
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            if (id != null)
                              ElevatedButton.icon(
                                onPressed: () =>
                                    taskController.onDeletePressed(taskModel),
                                icon: Icon(Icons.delete),
                                label: const Text('Delete'),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
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
                              onPressed: () => id == null
                                  ? taskController.addNew(drawingModel.id!)
                                  : taskController.onUpdatePressed(id: id!),
                              child: Text(id == null ? 'Add' : 'Update'),
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

  String getTaskNumber(DrawingModel drawingModel, TaskModel? taskModel) {
    String? revisionMark = taskModel == null
        ? taskController.getRevisionMarkWithDash(parentId: drawingModel.id)
        : taskController.getRevisionMarkWithDash(taskId: taskModel.id!);
    return (revisionMark == null ? '' : 'Current Rev.: ') +
        drawingModel.drawingNumber +
        (revisionMark ?? '-no revison yet');
  }

  void onReferenceDocumentsChanged(values) =>
      taskController.referenceDocumentsList = values;

  List<String> itemsReferenceDocuments() {
    return refDocController.documents
        .map((document) => document.documentNumber)
        .toList();
  }
}
