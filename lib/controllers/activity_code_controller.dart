import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dops/models/activity_codes_model.dart';
import 'package:dops/models/dropdown_field_model.dart';
import 'package:flutter/material.dart';
import 'package:dops/widgets/customFullScreenDialog.dart';
import 'package:dops/widgets/customSnackBar.dart';
import 'package:get/get.dart';

class ActivityCodeController extends GetxController {
  final GlobalKey<FormState> activityCodeFormKey = GlobalKey<FormState>();
  DropdownFieldModel dropdownFieldModel = DropdownFieldModel();

  late TextEditingController activityIdController,
      activityNameController,
      prioController,
      coefficientController,
      budgetedLaborUnitsController;
  late DateTime startController, finishController;

  late RxBool sortAscending;
  late RxInt sortColumnIndex;

  //Firestore operation
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  late CollectionReference collectionReference;

  RxList<ActivityCodeModel> activityCodes = RxList<ActivityCodeModel>([]);

  @override
  void onInit() {
    super.onInit();
    activityIdController = TextEditingController();
    activityNameController = TextEditingController();
    prioController = TextEditingController();
    coefficientController = TextEditingController();
    budgetedLaborUnitsController = TextEditingController();
    startController = DateTime.now();
    finishController = DateTime.now();

    sortAscending = false.obs;
    sortColumnIndex = 0.obs;

    collectionReference = firebaseFirestore.collection("activity_codes");
    // activityCodes.bindStream(getAllActivityCodes());
  }

  // TODO: write validation rules for all fields
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

  // void saveUpdateActivityCode(
  //   String docId,
  //   String? activityId,
  //   String? activityName,
  //   String? area,
  //   int? prio,
  //   int? coefficient,
  //   double? budgetedLaborUnits,
  //   DateTime? start,
  //   DateTime? finish,
  //   int addEditFlag,
  // ) {
  //   final isValid = activityCodeFormKey.currentState!.validate();
  //   if (!isValid) {
  //     return;
  //   }
  //   activityCodeFormKey.currentState!.save();
  //   if (addEditFlag == 1) {
  //     CustomFullScreenDialog.showDialog();
  //     collectionReference.add({
  //       'activityId': activityId,
  //       'activityName': activityName,
  //       'area': area,
  //       'prio': prio,
  //       'coefficient': coefficient,
  //       'currentPriority': prio! / coefficient!,
  //       'budgetedLaborUnits': budgetedLaborUnits,
  //       'start': start,
  //       'finish': finish,
  //       'cumulative': 0.0,
  //     }).whenComplete(() {
  //       CustomFullScreenDialog.cancelDialog();
  //       clearEditingControllers();
  //       Get.back();
  //       CustomSnackBar.showSnackBar(
  //           context: Get.context,
  //           title: "Activity Code Added",
  //           message: "Activity Code successfully",
  //           backgroundColor: Colors.green);
  //     }).catchError((error) {
  //       CustomFullScreenDialog.cancelDialog();
  //       CustomSnackBar.showSnackBar(
  //           context: Get.context,
  //           title: "Error",
  //           message: "Something went wrong",
  //           backgroundColor: Colors.green);
  //     });
  //   } else if (addEditFlag == 2) {
  //     //update
  //     CustomFullScreenDialog.showDialog();
  //     collectionReference.doc(docId).update({
  //       'activityId': activityId,
  //       'activityName': activityName,
  //       'area': area,
  //       'prio': prio,
  //       'coefficient': coefficient,
  //       'currentPriority': prio! / coefficient!,
  //       'budgetedLaborUnits': budgetedLaborUnits,
  //       'start': start,
  //       'finish': finish,
  //       'cumulative': 0.0,
  //     }).whenComplete(() {
  //       CustomFullScreenDialog.cancelDialog();
  //       clearEditingControllers();
  //       Get.back();
  //       CustomSnackBar.showSnackBar(
  //         context: Get.context,
  //         title: "Activity Code Updated",
  //         message: "Activity Code updated successfully",
  //         backgroundColor: Colors.green,
  //       );
  //     }).catchError((error) {
  //       CustomFullScreenDialog.cancelDialog();
  //       CustomSnackBar.showSnackBar(
  //         context: Get.context,
  //         title: "Error",
  //         message: "Something went wrong",
  //         backgroundColor: Colors.red,
  //       );
  //     });
  //   }
  // }
  saveUpdateActivityCode({required ActivityCodeModel model, required int addEditFlag}) {
    final isValid = activityCodeFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
      activityCodeFormKey.currentState!.save();
    if (addEditFlag == 1) {
      CustomFullScreenDialog.showDialog();
      collectionReference.add({
        'activityId': activityId,
        'activityName': activityName,
        'area': area,
        'prio': prio,
        'coefficient': coefficient,
        'currentPriority': prio! / coefficient!,
        'budgetedLaborUnits': budgetedLaborUnits,
        'start': start,
        'finish': finish,
        'cumulative': 0.0,
      }).whenComplete(() {
        CustomFullScreenDialog.cancelDialog();
        clearEditingControllers();
        Get.back();
        CustomSnackBar.showSnackBar(
            context: Get.context,
            title: "Activity Code Added",
            message: "Activity Code successfully",
            backgroundColor: Colors.green);
      }).catchError((error) {
        CustomFullScreenDialog.cancelDialog();
        CustomSnackBar.showSnackBar(
            context: Get.context,
            title: "Error",
            message: "Something went wrong",
            backgroundColor: Colors.green);
      });
    } else if (addEditFlag == 2) {
      //update
      CustomFullScreenDialog.showDialog();
      collectionReference.doc(docId).update({
        'activityId': activityId,
        'activityName': activityName,
        'area': area,
        'prio': prio,
        'coefficient': coefficient,
        'currentPriority': prio! / coefficient!,
        'budgetedLaborUnits': budgetedLaborUnits,
        'start': start,
        'finish': finish,
        'cumulative': 0.0,
      }).whenComplete(() {
        CustomFullScreenDialog.cancelDialog();
        clearEditingControllers();
        Get.back();
        CustomSnackBar.showSnackBar(
          context: Get.context,
          title: "Activity Code Updated",
          message: "Activity Code updated successfully",
          backgroundColor: Colors.green,
        );
      }).catchError((error) {
        CustomFullScreenDialog.cancelDialog();
        CustomSnackBar.showSnackBar(
          context: Get.context,
          title: "Error",
          message: "Something went wrong",
          backgroundColor: Colors.red,
        );
      });
    }
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

  Stream<List<ActivityCodeModel>> getAllActivityCodes() => collectionReference.snapshots().map((query) =>
      query.docs.map((item) => ActivityCodeModel.fromMap(item.data() as Map<String, dynamic>, item.id)).toList());

  void deleteData(String docId) {
    CustomFullScreenDialog.showDialog();
    collectionReference.doc(docId).delete().whenComplete(() {
      CustomFullScreenDialog.cancelDialog();
      Get.back();
      CustomSnackBar.showSnackBar(
          context: Get.context,
          title: "Activity Code Deleted",
          message: "Activity Code deleted successfully",
          backgroundColor: Colors.green);
    }).catchError((error) {
      CustomFullScreenDialog.cancelDialog();
      CustomSnackBar.showSnackBar(
          context: Get.context, title: "Error", message: "Something went wrong", backgroundColor: Colors.red);
    });
  }
}
