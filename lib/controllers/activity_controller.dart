import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dops/constants/lists.dart';
import 'package:dops/constants/style.dart';
import 'package:dops/constants/table_details.dart';
import 'package:dops/models/activity_model.dart';
import 'package:dops/repositories/activity_repository.dart';
import 'package:dops/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActivityController extends GetxController {
  final GlobalKey<FormState> activityFormKey = GlobalKey<FormState>();
  final _repository = Get.find<ActivityRepository>();

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

  updateActivity({required ActivityModel model}) async {
    final isValid = activityFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    activityFormKey.currentState!.save();
    //update
    CustomFullScreenDialog.showDialog();
    await _repository.updateActivityModel(model, model.id!);
    CustomFullScreenDialog.cancelDialog();
    Get.back();
  }

  saveActivity({required ActivityModel model}) async {
    CustomFullScreenDialog.showDialog();
    await _repository.addActivityModel(model);
    CustomFullScreenDialog.cancelDialog();
    Get.back();
  }

  void deleteActivity(ActivityModel data) {
    _repository.removeActivityModel(data);
  }

  @override
  void onReady() {
    super.onReady();
  }

  void clearEditingControllers() {
    activityIdController.clear();
    activityNameController.clear();
    coefficientController.clear();
    budgetedLaborUnitsController.clear();
    startTime = null;
    finishTime = null;
    moduleNameText = null;
  }

  void fillEditingControllers(ActivityModel model) {
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

  buildAddEdit({ActivityModel? aModel}) {
    if (aModel != null) {
      fillEditingControllers(aModel);
    } else {
      clearEditingControllers();
    }

    Get.defaultDialog(
      barrierDismissible: false,
      // onCancel: () => Get.back(),

      radius: 12,
      titlePadding: EdgeInsets.only(top: 20, bottom: 20),
      title: aModel == null ? 'Add Activity' : 'Update Activity',
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
                    CustomStringTextField(
                      controller: activityIdController,
                      labelText: tableColNames['activity']![0],
                    ),
                    CustomStringTextField(
                      controller: activityNameController,
                      labelText: tableColNames['activity']![1],
                    ),
                    CustomDropdownMenu(
                      labelText: 'Module name',
                      onChanged: (value) {
                        moduleNameText = value ?? '';
                      },
                      selectedItem: moduleNameText,
                      items: listsMap['Module name']!,
                    ),
                    CustomNumberTextField(
                      controller: coefficientController,
                      labelText: tableColNames['activity']![4],
                    ),
                    CustomNumberTextField(
                      controller: budgetedLaborUnitsController,
                      labelText: tableColNames['activity']![6],
                    ),
                    CustomDateTimeFormField(
                      initialValue: startTime,
                      labelText: tableColNames['activity']![7],
                      onDateSelected: (DateTime value) {
                        startTime = value;
                      },
                    ),
                    CustomDateTimeFormField(
                      initialValue: finishTime,
                      labelText: tableColNames['activity']![8],
                      onDateSelected: (DateTime value) {
                        finishTime = value;
                      },
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          if (aModel != null)
                            ElevatedButton.icon(
                              onPressed: () {
                                deleteActivity(aModel);
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
                                id: aModel != null ? aModel.id : null,
                                activityId: activityIdController.text,
                                activityName: activityNameController.text,
                                moduleName: moduleNameText,
                                priority: 0, // TODO: priority colculator
                                coefficient:
                                    int.parse(coefficientController.text),
                                currentPriority:
                                    0 / int.parse(coefficientController.text),
                                budgetedLaborUnits: double.parse(
                                    budgetedLaborUnitsController.text),
                                startDate: startTime,
                                finishDate: finishTime,
                                cumulative: 0,
                              );
                              aModel == null
                                  ? saveActivity(model: model)
                                  : updateActivity(model: model);
                            },
                            child: Text(
                              aModel != null ? 'Update' : 'Add',
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

  List<Map<String, String>> get getDataForTableView {
    return _documents.map((document) {
      Map<String, String> map = {};
      document.toMap().entries.forEach((entry) {
        switch (entry.key) {
          case 'isHidden':
            break;
          default:
            map[entry.key] = entry.value.toString();
        }
      });
      return map;
    }).toList();
  }

  List<String> getFieldValues(String fieldName) {
    return _documents.map((doc) => doc.toMap()[fieldName].toString()).toList();
  }
}
