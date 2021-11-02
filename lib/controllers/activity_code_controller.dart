import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dops/models/activity_codes_model.dart';
import 'package:dops/repositories/activity_code_repository.dart';
import 'package:flutter/material.dart';
import 'package:dops/widgets/customFullScreenDialog.dart';
import 'package:dops/widgets/customSnackBar.dart';
import 'package:get/get.dart';

class ActivityCodeController extends GetxController {
  final alma = 'alma';
  final GlobalKey<FormState> activityCodeFormKey = GlobalKey<FormState>();
  final _repository = Get.find<ActivityCodeRepository>();

  late TextEditingController activityIdController,
      activityNameController,
      prioController,
      coefficientController,
      budgetedLaborUnitsController;
  DateTime? startTime, finishTime;
  RxBool sortAscending = false.obs;
  RxInt sortColumnIndex = 0.obs;
  String? areaText;

  RxList<ActivityCodeModel> _activityCodes = RxList<ActivityCodeModel>([]);
  List<ActivityCodeModel> get activityCodes => _activityCodes.value;

  @override
  void onInit() async {
    super.onInit();
    activityIdController = TextEditingController();
    activityNameController = TextEditingController();
    prioController = TextEditingController();
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

  updateActivityCode({required ActivityCodeModel model}) {
    final isValid = activityCodeFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    activityCodeFormKey.currentState!.save();
    //update
    CustomFullScreenDialog.showDialog();
    _repository
        .updateActivityCodeModel(model, model.docId!)
        .whenComplete(whenCompleted('Activity Code Updated '))
        .catchError((error) {
      catchError(error);
    });
  }

  saveActivityCode({required ActivityCodeModel model}) {
    CustomFullScreenDialog.showDialog();
    _repository.addActivityCodeModel(model).whenComplete(whenCompleted('Activity Code Updated ')).catchError((error) {
      catchError(error);
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  void clearEditingControllers() {
    activityIdController.clear();
    activityNameController.clear();
    prioController.clear();
    coefficientController.clear();
    budgetedLaborUnitsController.clear();
  }

  void fillEditingControllers(ActivityCodeModel model) {
    activityIdController.text = model.activityId ?? '';
    activityNameController.text = model.activityName ?? '';
    prioController.text = model.prio.toString();
    coefficientController.text = model.coefficient.toString();
    budgetedLaborUnitsController.text = model.budgetedLaborUnits.toString();
    startTime = model.start;
    finishTime = model.finish;
    areaText = model.area;
  }

  whenCompleted(String title) {
    CustomFullScreenDialog.cancelDialog();
    clearEditingControllers();
    Get.back();
    CustomSnackBar.showSnackBar(
        context: Get.context, title: title, message: "$title Successfully", backgroundColor: Colors.green);
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

  // void deleteData(String docId) {
  //   CustomFullScreenDialog.showDialog();
  //   _repository
  //       .removeActivityCodeModel(docId)
  //       .whenComplete(whenCompleted('Deleted Activity Code'))
  //       .catchError((error) {
  //     catchError(error);
  //   });
  // }
}
