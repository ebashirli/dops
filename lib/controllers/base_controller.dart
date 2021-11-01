// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dops/models/base_model.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:dops/models/dropdown_field_model.dart';
// import 'package:dops/widgets/customFullScreenDialog.dart';
// import 'package:dops/widgets/customSnackBar.dart';

// class BaseController extends GetxController {
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   final DropdownFieldModel dropdownFieldModel = DropdownFieldModel();
//   late List<TextEditingController> textFieldControllers;
//   late List<DateTime> dateTimeControllers;
//   late final String collectionName;
//   late final String dataName;
//   late RxBool sortAscending;
//   late RxInt sortColumnIndex;
//   late int textEditingCotrollerCount;
//   late int dateTimeInputFieldCount;

//   //Firestore operation
//   FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

//   late CollectionReference collectionReference;

//   BaseController({
//     required this.collectionName,
//     required this.dataName,
//     required this.textEditingCotrollerCount,
//     required this.dateTimeInputFieldCount,
//   });

//   RxList<BaseModel> documents = RxList<BaseModel>([]);

//   @override
//   void onInit() {
//     super.onInit();
//     textFieldControllers = List.generate(
//         textEditingCotrollerCount, (index) => TextEditingController());

//     dateTimeControllers =
//         List.generate(dateTimeInputFieldCount, (index) => DateTime.now());

//     sortAscending = false.obs;
//     sortColumnIndex = 0.obs;

//     collectionReference = firebaseFirestore.collection(collectionName);
//     documents.bindStream(getAllDocuments());
//   }

//   // TODO: write validation rules for all fields
//   // String? validateName(String value) {
//   //   if (value.isEmpty) {
//   //     return "Name can not be empty";
//   //   }
//   //   return null;
//   // }

//   // String? validateAddress(String value) {
//   //   if (value.isEmpty) {
//   //     return "Address can not be empty";
//   //   }
//   //   return null;
//   // }

//   void saveUpdateData(
//     String docId,
//     BaseModel baseModel,
//     int addEditFlag,
//   ) {
//     final isValid = formKey.currentState!.validate();
//     if (!isValid) {
//       return;
//     }
//     formKey.currentState!.save();
//     if (addEditFlag == 1) {
//       CustomFullScreenDialog.showDialog();
//       collectionReference.add(baseModel.toJson()).whenComplete(() {
//         CustomFullScreenDialog.cancelDialog();
//         clearEditingControllers();
//         Get.back();
//         CustomSnackBar.showSnackBar(
//             context: Get.context,
//             title: "$dataName Added",
//             message: "$dataName added successfully.",
//             backgroundColor: Colors.green);
//       }).catchError((error) {
//         CustomFullScreenDialog.cancelDialog();
//         CustomSnackBar.showSnackBar(
//             context: Get.context,
//             title: "Error",
//             message: "Something went wrong",
//             backgroundColor: Colors.green);
//       });
//     } else if (addEditFlag == 2) {
//       //update
//       CustomFullScreenDialog.showDialog();
//       collectionReference
//           .doc(docId)
//           .update(baseModel.toJson())
//           .whenComplete(() {
//         CustomFullScreenDialog.cancelDialog();
//         clearEditingControllers();
//         Get.back();
//         CustomSnackBar.showSnackBar(
//           context: Get.context,
//           title: "$dataName Updated",
//           message: "$dataName updated successfully.",
//           backgroundColor: Colors.green,
//         );
//       }).catchError((error) {
//         CustomFullScreenDialog.cancelDialog();
//         CustomSnackBar.showSnackBar(
//           context: Get.context,
//           title: "Error",
//           message: "Something went wrong",
//           backgroundColor: Colors.red,
//         );
//       });
//     }
//   }

//   @override
//   void onReady() {
//     super.onReady();
//   }

//   void clearEditingControllers() {
//     textFieldControllers.map((e) => e.clear());
//   }

//   Stream<List<BaseModel>> getAllDocuments() =>
//       collectionReference.snapshots().map((query) => query.docs
//           .map(
//               (item) => BaseModel.fromJson(item.data() as Map<String, dynamic>))
//           .toList());

//   void deleteData(String docId) {
//     CustomFullScreenDialog.showDialog();
//     collectionReference.doc(docId).delete().whenComplete(() {
//       CustomFullScreenDialog.cancelDialog();
//       Get.back();
//       CustomSnackBar.showSnackBar(
//           context: Get.context,
//           title: "$dataName Deleted",
//           message: "$dataName deleted successfully.",
//           backgroundColor: Colors.green);
//     }).catchError((error) {
//       CustomFullScreenDialog.cancelDialog();
//       CustomSnackBar.showSnackBar(
//           context: Get.context,
//           title: "Error",
//           message: "Something went wrong",
//           backgroundColor: Colors.red);
//     });
//   }
// }
