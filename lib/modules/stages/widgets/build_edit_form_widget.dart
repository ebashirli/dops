import 'package:dops/components/custom_dropdown_menu_with_model_widget.dart';
import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/modules/activity/activity_model.dart';
import 'package:dops/modules/drawing/drawing_model.dart';
import 'package:dops/modules/task/task_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuildEditFormWidget extends StatelessWidget {
  const BuildEditFormWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (taskController.documents.isNotEmpty) {
      TaskModel taskModel = taskController.documents
          .firstWhere((task) => task!.id == Get.parameters['id'])!;

      DrawingModel drawingModel = drawingController.documents
          .firstWhere((drawing) => drawing.id == taskModel.parentId);

      drawingController.fillEditingControllers(
        drawingModel: drawingModel,
        taskModel: taskModel,
      );
      return _buildEditFormWidget(
        drawingModel: drawingModel,
        taskModel: taskModel,
        isCoordinator: staffController.isCoordinator,
      );
    } else {
      return CircularProgressIndicator();
    }
  }

  Widget _buildEditFormWidget({
    required DrawingModel drawingModel,
    required TaskModel taskModel,
    required isCoordinator,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: drawingController.drawingFormKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Container(
          width: Get.width * .5,
          child: Column(
            children: [
              Container(
                height: 220,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: <Widget>[
                          SizedBox(height: 10),
                          CustomDropdownMenuWithModel<ActivityModel>(
                            labelText: 'Activity code',
                            selectedItems: [
                              activityController.documents
                                  .where(
                                    (activity) =>
                                        activity.id ==
                                        drawingController.activityCodeIdText,
                                  )
                                  .toList()[0],
                            ],
                            onChanged: (value) {
                              drawingController.activityCodeIdText =
                                  activityController.documents
                                      .where((activity) =>
                                          activity.activityId == value)
                                      .toList()[0]
                                      .id!;
                            },
                            items: activityController.documents,
                            itemAsString: (ActivityModel? item) =>
                                item!.activityId!,
                          ),
                          CustomTextFormField(
                            controller:
                                drawingController.drawingNumberController,
                            labelText: 'Drawing Number',
                          ),
                          CustomTextFormField(
                            controller:
                                drawingController.drawingTitleController,
                            labelText: 'Drawing Title',
                          ),
                          CustomDropdownMenu(
                            labelText: 'Module name',
                            selectedItems: [drawingController.moduleNameText],
                            onChanged: (value) {
                              drawingController.moduleNameText = value ?? '';
                            },
                            items: listsController.document.value.modules!,
                          ),
                          CustomDropdownMenu(
                            showSearchBox: true,
                            labelText: 'Level',
                            selectedItems: [drawingController.levelText],
                            onChanged: (value) {
                              drawingController.levelText = value ?? '';
                            },
                            items: listsController.document.value.levels!,
                          ),
                          CustomDropdownMenu(
                            showSearchBox: true,
                            isMultiSelectable: true,
                            labelText: 'Area',
                            items: listsController.document.value.areas!,
                            onChanged: (values) =>
                                drawingController.areaList = values,
                            selectedItems: drawingController.areaList,
                          ),
                          CustomDropdownMenu(
                            showSearchBox: true,
                            labelText: 'Functional Area',
                            selectedItems: [
                              drawingController.functionalAreaText
                            ],
                            onChanged: (value) {
                              drawingController.functionalAreaText =
                                  value ?? '';
                            },
                            items:
                                listsController.document.value.functionalAreas!,
                          ),
                          CustomDropdownMenu(
                            showSearchBox: true,
                            labelText: 'Structure Type',
                            selectedItems: [
                              drawingController.structureTypeText
                            ],
                            onChanged: (value) {
                              drawingController.structureTypeText = value ?? '';
                            },
                            items:
                                listsController.document.value.structureTypes!,
                          ),
                          CustomTextFormField(
                            controller: drawingController.drawingNoteController,
                            labelText: 'Note',
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            '${drawingModel.drawingNumber}-${taskModel.revisionNumber}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          CustomTextFormField(
                            controller:
                                drawingController.nextRevisionNumberController,
                            labelText: 'Next Revision number',
                          ),
                          CustomDropdownMenu(
                            isMultiSelectable: true,
                            labelText: 'Design Drawings',
                            items: referenceDocumentController.documents
                                .map((document) => document.documentNumber)
                                .toList(),
                            onChanged: (values) =>
                                drawingController.designDrawingsList = values,
                            selectedItems: drawingController.designDrawingsList,
                          ),
                          CustomTextFormField(
                            controller: drawingController.taskNoteController,
                            labelText: 'Note',
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  if (isCoordinator)
                    ElevatedButton(
                      onPressed: () {
                        DrawingModel revisedOrNewModel = DrawingModel(
                          activityCodeId: drawingController.activityCodeIdText,
                          drawingNumber:
                              drawingController.drawingNumberController.text,
                          drawingTitle:
                              drawingController.drawingTitleController.text,
                          level: drawingController.levelText,
                          module: drawingController.moduleNameText,
                          structureType: drawingController.structureTypeText,
                          note: drawingController.drawingNoteController.text,
                          area: drawingController.areaList,
                          functionalArea: drawingController.functionalAreaText,
                        );

                        Map<String, dynamic> updatedTaskFields = {
                          'revisionNumber': drawingController
                              .nextRevisionNumberController.text,
                          'designDrawings':
                              drawingController.designDrawingsList,
                          'note': drawingController.taskNoteController.text,
                        };

                        drawingController.updateDrawing(
                          updatedModel: revisedOrNewModel,
                          id: drawingModel.id!,
                        );

                        taskController.updateTaskFields(
                          map: updatedTaskFields,
                          id: taskModel.id!,
                        );
                      },
                      child: Text('Update'),
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
