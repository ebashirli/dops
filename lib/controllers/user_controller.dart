import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dops/models/employeeModel.dart';
import 'package:dops/widgets/customFullScreenDialog.dart';
import 'package:dops/widgets/customSnackBar.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final GlobalKey<FormState> userFormKey = GlobalKey<FormState>();
  late TextEditingController nameController, addressController;

  // Firestore operation
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  late CollectionReference collectionEmployees;

  RxList<EmployeeModel> employees = RxList<EmployeeModel>([]);

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    addressController = TextEditingController();
    collectionEmployees = firebaseFirestore.collection("employees");
    employees.bindStream(getAllEmployees());
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

  void saveUpdateEmployee(
      String name, String address, String docId, int addEditFlag) {
    final isValid = userFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    userFormKey.currentState!.save();
    if (addEditFlag == 1) {
      CustomFullScreenDialog.showDialog();
      collectionEmployees
          .add({'name': name, 'address': address}).whenComplete(() {
        CustomFullScreenDialog.cancelDialog();
        clearEditingControllers();
        Get.back();
        CustomSnackBar.showSnackBar(
            context: Get.context,
            title: "Employee Added",
            message: "Employee added successfully",
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
      collectionEmployees
          .doc(docId)
          .update({'name': name, 'address': address}).whenComplete(() {
        CustomFullScreenDialog.cancelDialog();
        clearEditingControllers();
        Get.back();
        CustomSnackBar.showSnackBar(
            context: Get.context,
            title: "Employee Updated",
            message: "Employee updated successfully",
            backgroundColor: Colors.green);
      }).catchError((error) {
        CustomFullScreenDialog.cancelDialog();
        CustomSnackBar.showSnackBar(
            context: Get.context,
            title: "Error",
            message: "Something went wrong",
            backgroundColor: Colors.red);
      });
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    nameController.dispose();
    addressController.dispose();
  }

  void clearEditingControllers() {
    nameController.clear();
    addressController.clear();
  }

  Stream<List<EmployeeModel>> getAllEmployees() =>
      collectionEmployees.snapshots().map((query) =>
          query.docs.map((item) => EmployeeModel.fromMap(item as Map<String, dynamic>)).toList());

  void deleteData(String docId) {
    CustomFullScreenDialog.showDialog();
    collectionEmployees.doc(docId).delete().whenComplete(() {
      CustomFullScreenDialog.cancelDialog();
      Get.back();
      CustomSnackBar.showSnackBar(
          context: Get.context,
          title: "Employee Deleted",
          message: "Employee deleted successfully",
          backgroundColor: Colors.green);
    }).catchError((error) {
      CustomFullScreenDialog.cancelDialog();
      CustomSnackBar.showSnackBar(
          context: Get.context,
          title: "Error",
          message: "Something went wrong",
          backgroundColor: Colors.red);
    });
  }
}
