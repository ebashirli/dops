import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/modules/activity/widgets/activiti_form_widget.dart';
import 'package:dops/modules/task/task_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';

import 'activity_model.dart';
import 'activity_repository.dart';

class ActivityController extends GetxService {
  final GlobalKey<FormState> activityFormKey = GlobalKey<FormState>();
  final _repository = Get.find<ActivityRepository>();

  static ActivityController instance = Get.find();

  late TextEditingController activityIdController,
      activityNameController,
      coefficientController,
      budgetedLaborUnitsController,
      startDateController,
      finishDateController;
  RxBool sortAscending = false.obs;
  RxInt sortColumnIndex = 0.obs;
  RxBool loading = true.obs;

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
    startDateController = TextEditingController();
    finishDateController = TextEditingController();
    _documents.bindStream(_repository.getAllActivitiesAsStream());
    _documents.listen((List<ActivityModel?> taskModelList) {
      if (taskModelList.isNotEmpty) loading.value = false;
    });
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

  void deleteActivity(String id) => _repository.removeModel(id);

  @override
  void onReady() {
    super.onReady();
  }

  void clearEditingControllers() {
    activityIdController.clear();
    activityNameController.clear();
    coefficientController.text = '1';
    budgetedLaborUnitsController.clear();
    startDateController.clear();
    finishDateController.clear();
    moduleNameText = '';
  }

  void fillEditingControllers(String id) {
    final ActivityModel model =
        documents.where((document) => document.id == id).toList()[0];

    activityIdController.text = model.activityId ?? '';
    activityNameController.text = model.activityName ?? '';
    coefficientController.text = model.coefficient.toString();
    budgetedLaborUnitsController.text = model.budgetedLaborUnits.toString();
    startDateController.text = model.startDate!.toDMYhmDash();
    finishDateController.text = model.finishDate!.toDMYhmDash();
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

  buildAddForm() {
    clearEditingControllers();
    getDialog(title: 'Add');
  }

  buildUpdateForm({required String id}) {
    fillEditingControllers(id);
    getDialog(title: 'Update', id: id);
  }

  void getDialog({required String title, String? id}) {
    Get.defaultDialog(
      barrierDismissible: false,
      radius: 12,
      titlePadding: EdgeInsets.only(top: 10),
      title: title,
      content: ActivityFormWidget(id: id),
    );
  }

  List<Map<String, dynamic>> get getDataForTableView {
    return documents.map((activity) {
      String assignedTasks = '';

      List<String?> drawingIdsOfActivity = drawingController.documents
          .where((drawing) =>
              drawing.isHidden == false &&
              drawing.activityCodeId == activity.id)
          .map((drawing) => drawing.id)
          .toList();

      List<TaskModel?> taskIdsOfDrawings = taskController.documents
          .where((task) => task != null
              ? drawingIdsOfActivity.contains(task.parentId)
              : false)
          .toList();

      taskIdsOfDrawings.forEach((task) {
        if (task != null) {
          final String drawingNumber = drawingController.documents
              .where((drawing) => drawing.id == task.parentId)
              .toList()[0]
              .drawingNumber;
          assignedTasks += '|${drawingNumber};${task.id!}';
        }
      });

      return <String, dynamic>{
        'id': activity.id,
        'activityId': activity.activityId,
        'activityName': activity.activityName,
        'moduleName': activity.moduleName,
        'priority': documents.indexOf(activity) + 1,
        'coefficient': activity.coefficient,
        'currentPriority':
            (documents.indexOf(activity) + 1) * activity.coefficient,
        'budgetedLaborUnits': activity.budgetedLaborUnits,
        'startDate': activity.startDate == null
            ? null
            : activity.startDate!.toDayMonthYear(),
        'finishDate': activity.finishDate == null
            ? null
            : activity.finishDate!.toDayMonthYear(),
        'cumulative': activity.cumulative,
        'assignedTasks': assignedTasks,
      };
    }).toList();
  }

  ActivityModel? getById(String id) {
    return loading.value || documents.isEmpty
        ? null
        : documents.singleWhereOrNull((e) => e.id == id);
  }

  String? selectedActivities(String activityCodeId) {
    ActivityModel? activityModel = getById(activityCodeId);
    return activityModel == null ? null : activityModel.activityId;
  }
}
