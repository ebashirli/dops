import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dops/modules/dropdown_source/dropdown_sources_controller.dart';
import 'package:dops/modules/task/task_controller.dart';
import 'package:dops/components/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/style.dart';
import '../../constants/table_details.dart';
import 'activity_model.dart';
import 'activity_repository.dart';

class ActivityController extends GetxController {
  final GlobalKey<FormState> activityFormKey = GlobalKey<FormState>();
  final _repository = Get.find<ActivityRepository>();
  late final taskController = Get.find<TaskController>();
  late final dropdownSourcesController = Get.find<DropdownSourcesController>();

  late TextEditingController activityIdController,
      activityNameController,
      coefficientController,
      budgetedLaborUnitsController;
  DateTime? startTime, finishTime;
  RxBool sortAscending = false.obs;
  RxInt sortColumnIndex = 0.obs;
  String? moduleNameText = '';

  RxList<ActivityModel> _documents = RxList<ActivityModel>([]);
  List<ActivityModel> get documents => _documents;

  @override
  void onInit() async {
    super.onInit();
    activityIdController = TextEditingController();
    activityNameController = TextEditingController();
    coefficientController = TextEditingController();
    budgetedLaborUnitsController = TextEditingController();
    startTime = DateTime.now();
    finishTime = DateTime.now();
    _documents.bindStream(_repository.getAllActivitiesAsStream());
  }

  String? validateName(String value) {
    if (value.isEmpty) {
      return "Name can not be empty";
    }
    return null;
  }

  String? validateAddress(String value) {
    if (value.isEmpty) {
      return "Address can not be empty";
    }
    return null;
  }

  updateDocument({required ActivityModel model, required String id}) async {
    final isValid = activityFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    activityFormKey.currentState!.save();
    //update
    CustomFullScreenDialog.showDialog();
    await _repository.updateModel(model, id);
    CustomFullScreenDialog.cancelDialog();
    Get.back();
  }

  saveDocument({required ActivityModel model}) async {
    CustomFullScreenDialog.showDialog();
    await _repository.addModel(model);
    CustomFullScreenDialog.cancelDialog();
    Get.back();
  }

  void deleteActivity(String id) {
    _repository.removeModel(id);
  }

  @override
  void onReady() {
    super.onReady();
  }

  void clearEditingControllers() {
    activityIdController.clear();
    activityNameController.clear();
    coefficientController.text = '1';
    budgetedLaborUnitsController.clear();
    startTime = null;
    finishTime = null;
    moduleNameText = '';
  }

  void fillEditingControllers(String id) {
    final ActivityModel model =
        documents.where((document) => document.id == id).toList()[0];

    activityIdController.text = model.activityId ?? '';
    activityNameController.text = model.activityName ?? '';
    coefficientController.text = model.coefficient.toString();
    budgetedLaborUnitsController.text = model.budgetedLaborUnits.toString();
    startTime = model.startDate;
    finishTime = model.finishDate;
    moduleNameText = model.moduleName;
  }

  whenCompleted() {
    CustomFullScreenDialog.cancelDialog();
    clearEditingControllers();
    Get.back();
  }

  catchError(FirebaseException error) {
    {
      CustomFullScreenDialog.cancelDialog();
      CustomSnackBar.showSnackBar(
        context: Get.context,
        title: "Error",
        message: "${error.message.toString()}",
        backgroundColor: Colors.red,
      );
    }
  }

  buildAddEdit({String? id, bool? newRev = false}) {
    if (id != null) {
      fillEditingControllers(id);
    } else {
      clearEditingControllers();
    }

    Get.defaultDialog(
      barrierDismissible: false,
      // onCancel: () => Get.back(),

      radius: 12,
      titlePadding: EdgeInsets.only(top: 20, bottom: 20),
      title: id == null ? 'Add Activity' : 'Update Activity',
      content: Container(
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
            key: activityFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              child: Container(
                width: Get.width * 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextFormField(
                      controller: activityIdController,
                      labelText: tableColNames['activity']![1],
                    ),
                    CustomTextFormField(
                      controller: activityNameController,
                      labelText: tableColNames['activity']![2],
                    ),
                    CustomDropdownMenu(
                      labelText: 'Module name',
                      onChanged: (value) {
                        moduleNameText = value ?? '';
                      },
                      selectedItems: [moduleNameText!],
                      items: dropdownSourcesController.document.value.modules!,
                    ),
                    CustomTextFormField(
                      isNumber: true,
                      controller: coefficientController,
                      labelText: tableColNames['activity']![5],
                    ),
                    CustomTextFormField(
                      isNumber: true,
                      controller: budgetedLaborUnitsController,
                      labelText: tableColNames['activity']![7],
                    ),
                    CustomDateTimeFormField(
                      initialValue: startTime,
                      labelText: tableColNames['activity']![8],
                      onDateSelected: (DateTime value) {
                        startTime = value;
                      },
                    ),
                    CustomDateTimeFormField(
                      initialValue: finishTime,
                      labelText: tableColNames['activity']![9],
                      onDateSelected: (DateTime value) {
                        finishTime = value;
                      },
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          if (id != null)
                            ElevatedButton.icon(
                              onPressed: () {
                                deleteActivity(id);
                                Get.back();
                              },
                              icon: Icon(Icons.delete),
                              label: const Text('Delete'),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.red)),
                            ),
                          const Spacer(),
                          ElevatedButton(
                              onPressed: () => Get.back(),
                              child: const Text('Cancel')),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              ActivityModel model = ActivityModel(
                                activityId: activityIdController.text,
                                activityName: activityNameController.text,
                                moduleName: moduleNameText,
                                coefficient:
                                    int.parse(coefficientController.text),
                                budgetedLaborUnits: double.parse(
                                    budgetedLaborUnitsController.text),
                                startDate: startTime,
                                finishDate: finishTime,
                              );
                              id == null
                                  ? saveDocument(model: model)
                                  : updateDocument(
                                      model: model,
                                      id: id,
                                    );
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
        ),
      ),
    );
  }

  List<Map<String, dynamic>> get getDataForTableView {
    List<String> mapPropNames = mapPropNamesGetter('activity');
    return documents.map((activity) {
      Map<String, dynamic> map = {};
      mapPropNames.forEach((mapPropName) {
        switch (mapPropName) {
          case 'id':
            map[mapPropName] = activity.id!;
            break;
          case 'priority':
            map[mapPropName] = documents.indexOf(activity) + 1;
            break;
          case 'currentPriority':
            map[mapPropName] =
                (_documents.indexOf(activity) + 1) * activity.coefficient;
            break;
          case 'assignedTasks':
            String assignedTasks = '';
            taskController.documents.forEach((task) {
              if (task.activityCode == activity.activityId)
                assignedTasks += '|${task.drawingNumber};${task.id!}';
            });
            map[mapPropName] = assignedTasks;
            break;
          default:
            map[mapPropName] = activity.toMap()[mapPropName];
            break;
        }
      });
      return map;
    }).toList();
  }
  List<String> getFieldValues(String fieldName) {
    return _documents.map((doc) => doc.toMap()[fieldName].toString()).toList();
  }
}
