import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dops/constants/lists.dart';
import 'package:dops/constants/style.dart';
import 'package:dops/constants/table_details.dart';
import 'package:dops/models/activity_codes_model.dart';
import 'package:dops/repositories/activity_code_repository.dart';
import 'package:dops/widgets/custom_date_time_form_field.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:dops/widgets/customFullScreenDialog.dart';
import 'package:dops/widgets/customSnackBar.dart';
import 'package:flutter/services.dart';
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
  String? areaText = '';

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
        .whenComplete(whenCompleted('Updated '))
        .catchError((error) {
      catchError(error);
    });
  }

  saveActivityCode({required ActivityCodeModel model}) {
    CustomFullScreenDialog.showDialog();
    _repository.addActivityCodeModel(model).whenComplete(whenCompleted('Updated ')).catchError((error) {
      catchError(error);
    });
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
    prioController.clear();
    coefficientController.clear();
    budgetedLaborUnitsController.clear();
    startTime = null;
    finishTime = null;
    areaText = null;
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
    // CustomFullScreenDialog.cancelDialog();
    clearEditingControllers();
    Get.back();
    // CustomSnackBar.showSnackBar(
    //     context: Get.context, title: title, message: "$title Successfully", backgroundColor: Colors.green);
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
      title: activityCodeModel == null ? 'Add Activity Code' : 'Update Activity Code',
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
                    TextFormField(
                        decoration: InputDecoration(
                          labelText: activityCodeTableColumnNames[0],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        controller: activityIdController,
                        validator: (value) {
                          return validateName(value!);
                        }),
                    SizedBox(height: 10),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        labelText: activityCodeTableColumnNames[1],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      controller: activityNameController,
                      validator: (value) {
                        return validateAddress(value!);
                      },
                    ),
                    SizedBox(height: 10),
                    _dropdownSearch(lists['Module']!, activityCodeTableColumnNames[2], 50 * 4, onChanged: (value) {
                      areaText = value ?? '';
                    }),
                    SizedBox(height: 10),
                    TextFormField(
                        controller: prioController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        decoration: InputDecoration(
                            labelText: activityCodeTableColumnNames[3], icon: Icon(Icons.phone_iphone))),
                    SizedBox(height: 10),
                    TextFormField(
                        controller: coefficientController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        decoration: InputDecoration(
                            labelText: activityCodeTableColumnNames[4], icon: Icon(Icons.phone_iphone))),
                    SizedBox(height: 10),
                    TextFormField(
                        controller: budgetedLaborUnitsController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        decoration: InputDecoration(
                            labelText: activityCodeTableColumnNames[5], icon: Icon(Icons.format_list_numbered))),
                    SizedBox(height: 10),
                    CustomDateTimeFormField(
                      initialValue: startTime,
                      labelText: activityCodeTableColumnNames[7],
                      onDateSelected: (DateTime value) {
                        startTime = value;
                      },
                    ),
                    SizedBox(height: 10),
                    CustomDateTimeFormField(
                      initialValue: finishTime,
                      labelText: activityCodeTableColumnNames[8],
                      onDateSelected: (DateTime value) {
                        finishTime = value;
                      },
                    ),
                    SizedBox(height: 10),
                    Container(
                      child: Row(
                        children: <Widget>[
                          if (activityCodeModel != null)
                            ElevatedButton.icon(
                              onPressed: () {
                                deleteActivityCode(activityCodeModel.docId!);
                                Get.back();
                              },
                              icon: Icon(Icons.delete),
                              label: const Text('Delete'),
                              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
                            ),
                          const Spacer(),
                          ElevatedButton(onPressed: () => Get.back(), child: const Text('Cancel')),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              ActivityCodeModel model = ActivityCodeModel(
                                docId: activityCodeModel != null ? activityCodeModel.docId : null,
                                activityId: activityIdController.text,
                                activityName: activityNameController.text,
                                area: areaText,
                                prio: int.parse(prioController.text),
                                coefficient: int.parse(coefficientController.text),
                                budgetedLaborUnits: double.parse(budgetedLaborUnitsController.text),
                                start: startTime,
                                finish: finishTime,
                                cumulative: 0,
                                currentPriority: 0,
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
  
  Widget _dropdownSearch(List<String> itemsList, String labelText, double maxHeight,
      {dynamic Function(String?)? onChanged}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: DropdownSearch<String>(
        maxHeight: maxHeight,
        mode: Mode.MENU,
        items: itemsList,
        selectedItem: areaText,
        dropdownSearchDecoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 10),
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }

}
