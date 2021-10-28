import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dops/widgets/customFullScreenDialog.dart';
import 'package:dops/widgets/customSnackBar.dart';
import 'package:get/get.dart';

class DropdownSourceListsController extends GetxController {
  late List<TextEditingController> newItemControllerList;

  //Firestore operation
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  late CollectionReference collectionReference;

  RxList dropdownSourceLists = RxList([]);

  @override
  void onInit() {
    super.onInit();
    newItemControllerList =
        List.generate(20, (index) => TextEditingController());
    collectionReference = firebaseFirestore.collection("lists");

    dropdownSourceLists.bindStream(getAllDropdownSourceLists());

    // // Creating collection with given document ID and value in Firebase
    // // Only for first time
    // lists.forEach((key, value) {
    //   collectionReference.doc(key).set({'list': value});
    // });
  }

  final List<GlobalObjectKey<FormState>> dropdownSourceListsFormKeyList =
      List.generate(20, (index) => GlobalObjectKey<FormState>(index));

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

  void saveUpdateDropdownSourceList(
    String listName,
    int itemIndex,
    String newItem,
    int addEditFlag,
  ) {
    final isValid =
        dropdownSourceListsFormKeyList[itemIndex].currentState!.validate();
    if (!isValid) {
      return;
    }
    dropdownSourceListsFormKeyList[itemIndex].currentState!.save();
    if (addEditFlag == 1) {
      CustomFullScreenDialog.showDialog();
      // TODO: correct query

      collectionReference.doc(listName).update({
        'list1': newItem,
      }).whenComplete(() {
        CustomFullScreenDialog.cancelDialog();
        clearEditingControllers();
        Get.back();
        CustomSnackBar.showSnackBar(
            context: Get.context,
            title: "New item Added",
            message: "New item successfully",
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
      // TODO: correct query
      collectionReference.doc(listName).update({
        '${itemIndex}': newItem,
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
    newItemControllerList.map((e) => e.clear());
  }

  Stream<List> getAllDropdownSourceLists() {
    Stream<List> lst =
        collectionReference.snapshots().map((query) => query.docs.map((item) {
              return {item.id, item.data()};
            }).toList());
    return lst;
  }

  void deleteData(String lstName) {
    CustomFullScreenDialog.showDialog();
    // TODO: correct query
    collectionReference.doc(lstName).delete().whenComplete(() {
      CustomFullScreenDialog.cancelDialog();
      Get.back();
      CustomSnackBar.showSnackBar(
          context: Get.context,
          title: "Dropdown List itam Deleted",
          message: "Dropdown list itam deleted successfully",
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
