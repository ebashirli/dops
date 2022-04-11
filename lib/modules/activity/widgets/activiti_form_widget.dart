import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/constants/style.dart';
import 'package:dops/constants/table_details.dart';
import 'package:dops/modules/activity/activity_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ActivityFormWidget extends StatelessWidget {
  const ActivityFormWidget({Key? key, String? this.id}) : super(key: key);
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
          key: activityController.activityFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            child: Container(
              width: Get.width * 0.3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      CustomTextFormField(
                        width: 200,
                        controller: activityController.activityIdController,
                        labelText: tableColNames['activity']![1],
                      ),
                      CustomTextFormField(
                        width: 200,
                        controller: activityController.activityNameController,
                        labelText: tableColNames['activity']![2],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      CustomDropdownMenu(
                        width: 200,
                        labelText: 'Module name',
                        onChanged: (value) {
                          activityController.moduleNameText = value ?? '';
                        },
                        selectedItems: [activityController.moduleNameText!],
                        items: listsController.document.value.modules!,
                      ),
                      Container(
                        width: 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            CustomTextFormField(
                              width: 80,
                              isNumber: true,
                              controller:
                                  activityController.coefficientController,
                              labelText: tableColNames['activity']![5],
                            ),
                            CustomTextFormField(
                              width: 100,
                              isNumber: true,
                              controller: activityController
                                  .budgetedLaborUnitsController,
                              labelText: tableColNames['activity']![7],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      CustomDateTimeFormField(
                        initialValue:
                            activityController.startDateController.text,
                        labelText: tableColNames['activity']![8],
                        controller: activityController.startDateController,
                      ),
                      CustomDateTimeFormField(
                        initialValue:
                            activityController.finishDateController.text,
                        labelText: tableColNames['activity']![9],
                        controller: activityController.finishDateController,
                      ),
                    ],
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        if (id != null)
                          ElevatedButton.icon(
                            onPressed: () {
                              activityController.deleteActivity(id!);
                              Get.back();
                            },
                            icon: Icon(Icons.delete),
                            label: const Text('Delete'),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.red)),
                          ),
                        ElevatedButton(
                            onPressed: () => Get.back(),
                            child: const Text('Cancel')),
                        ElevatedButton(
                          onPressed: () {
                            ActivityModel model = ActivityModel(
                              activityId:
                                  activityController.activityIdController.text,
                              activityName: activityController
                                  .activityNameController.text,
                              moduleName: activityController.moduleNameText,
                              coefficient: int.parse(activityController
                                  .coefficientController.text),
                              budgetedLaborUnits: double.parse(
                                  activityController
                                      .budgetedLaborUnitsController.text),
                              startDate: DateFormat('dd/MM/yyyy').parse(
                                  activityController.startDateController.text),
                              finishDate: DateFormat('dd/MM/yyyy').parse(
                                  activityController.finishDateController.text),
                            );
                            id == null
                                ? activityController.saveDocument(model: model)
                                : activityController.updateDocument(
                                    model: model,
                                    id: id!,
                                  );
                          },
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
      ),
    );
  }
}
