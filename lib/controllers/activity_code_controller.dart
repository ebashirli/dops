import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dops/constants/style.dart';
import 'package:dops/constants/table_details.dart';
import 'package:dops/models/activity_codes_model.dart';
import 'package:dops/repositories/activity_code_repository.dart';
import 'package:dops/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActivityCodeController extends GetxController {
  final alma = 'alma';
  final GlobalKey<FormState> activityCodeFormKey = GlobalKey<FormState>();
  final _repository = Get.find<ActivityCodeRepository>();

  late TextEditingController activityIdController,
      activityNameController,
      coefficientController,
      budgetedLaborUnitsController;
  DateTime? startTime, finishTime;
  RxBool sortAscending = false.obs;
  RxInt sortColumnIndex = 0.obs;
  String? moduleNameText = '';

  RxList<ActivityCodeModel> _activityCodes = RxList<ActivityCodeModel>([]);
  List<ActivityCodeModel> get activityCodes => _activityCodes;

  @override
  void onInit() async {
    super.onInit();
    activityIdController = TextEditingController();
    activityNameController = TextEditingController();
    coefficientController = TextEditingController();
    budgetedLaborUnitsController = TextEditingController();
    startTime = DateTime.now();
    finishTime = DateTime.now();
    _activityCodes.bindStream(_repository.getAllActivityCodesAsStream());
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

  updateActivityCode({required ActivityCodeModel model}) async {
    final isValid = activityCodeFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    activityCodeFormKey.currentState!.save();
    //update
    CustomFullScreenDialog.showDialog();
    await _repository.updateActivityCodeModel(model, model.id!);
    CustomFullScreenDialog.cancelDialog();
    Get.back();
  }

  saveActivityCode({required ActivityCodeModel model}) async {
    CustomFullScreenDialog.showDialog();
    await _repository.addActivityCodeModel(model);
    CustomFullScreenDialog.cancelDialog();
    Get.back();
  }

  void deleteActivityCode(String id) {
    _repository.removeActivityCodeModel(id);
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

  void fillEditingControllers(ActivityCodeModel model) {
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

  buildAddEdit({ActivityCodeModel? activityCodeModel}) {
    if (activityCodeModel != null) {
      fillEditingControllers(activityCodeModel);
    } else {
      clearEditingControllers();
    }

    Get.defaultDialog(
      barrierDismissible: false,
      // onCancel: () => Get.back(),

      radius: 12,
      titlePadding: EdgeInsets.only(top: 20, bottom: 20),
      title: activityCodeModel == null
          ? 'Add Activity Code'
          : 'Update Activity Code',
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
            key: activityCodeFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              child: Container(
                width: Get.width * 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomStringTextField(
                      controller: activityIdController,
                      labelText: activityCodeTableColumnNames[0],
                    ),
                    CustomStringTextField(
                      controller: activityNameController,
                      labelText: activityCodeTableColumnNames[1],
                    ),
                    CustomDropdownSearch(
                      labelText: 'Module name',
                      onChanged: (value) {
                        moduleNameText = value ?? '';
                      },
                      selectedItem: moduleNameText,
                    ),
                    CustomNumberTextField(
                      controller: coefficientController,
                      labelText: activityCodeTableColumnNames[4],
                    ),
                    CustomNumberTextField(
                      controller: budgetedLaborUnitsController,
                      labelText: activityCodeTableColumnNames[6],
                    ),
                    CustomDateTimeFormField(
                      initialValue: startTime,
                      labelText: activityCodeTableColumnNames[7],
                      onDateSelected: (DateTime value) {
                        startTime = value;
                      },
                    ),
                    CustomDateTimeFormField(
                      initialValue: finishTime,
                      labelText: activityCodeTableColumnNames[8],
                      onDateSelected: (DateTime value) {
                        finishTime = value;
                      },
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          if (activityCodeModel != null)
                            ElevatedButton.icon(
                              onPressed: () {
                                deleteActivityCode(activityCodeModel.id!);
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
                              ActivityCodeModel model = ActivityCodeModel(
                                id: activityCodeModel != null
                                    ? activityCodeModel.id
                                    : null,
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
                              activityCodeModel == null
                                  ? saveActivityCode(model: model)
                                  : updateActivityCode(model: model);
                            },
                            child: Text(
                              activityCodeModel != null ? 'Update' : 'Add',
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
}
