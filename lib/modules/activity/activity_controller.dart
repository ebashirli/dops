import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/models/base_table_view_controller.dart';
import 'package:dops/modules/activity/widgets/activity_form_widget.dart';
import 'package:dops/modules/drawing/drawing_model.dart';
import 'package:dops/modules/task/task_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';

import 'activity_model.dart';
import 'activity_repository.dart';

class ActivityController extends BaseViewController {
  final GlobalKey<FormState> activityFormKey = GlobalKey<FormState>();
  final _repo = Get.find<ActivityRepository>();

  static ActivityController instance = Get.find();

  late TextEditingController activityIdController,
      activityNameController,
      coefficientController,
      budgetedLaborUnitsController,
      startDateController,
      finishDateController;
  RxBool sortAscending = false.obs;
  RxInt sortColumnIndex = 0.obs;

  RxBool _loading = true.obs;
  @override
  bool get loading => _loading.value;

  String? moduleNameText = '';

  RxList<ActivityModel?> _documents = RxList<ActivityModel>([]);
  @override
  List<ActivityModel?> get documents => _documents;

  @override
  void onInit() async {
    super.onInit();
    activityIdController = TextEditingController();
    activityNameController = TextEditingController();
    coefficientController = TextEditingController();
    budgetedLaborUnitsController = TextEditingController();
    startDateController = TextEditingController();
    finishDateController = TextEditingController();
    _documents.bindStream(_repo.getAllActivitiesAsStream());
    _documents.listen((List<ActivityModel?> taskModelList) {
      if (taskModelList.isNotEmpty) _loading.value = false;
    });
  }

  String? validateName(String value) =>
      value.isEmpty ? "Name can not be empty" : null;

  String? validateAddress(String value) =>
      value.isEmpty ? "Address can not be empty" : null;

  updateDocument({required ActivityModel model, required String id}) async {
    final isValid = activityFormKey.currentState!.validate();
    if (!isValid) return;
    activityFormKey.currentState!.save();
    //update
    CustomFullScreenDialog.showDialog();
    await _repo.updateModel(model, id);
    CustomFullScreenDialog.cancelDialog();
    Get.back();
  }

  saveDocument({required ActivityModel model}) async {
    CustomFullScreenDialog.showDialog();
    await _repo.addModel(model);
    CustomFullScreenDialog.cancelDialog();
    Get.back();
  }

  void deleteActivity(String id) => _repo.removeModel(id);

  @override
  void onReady() => super.onReady();

  void clearEditingControllers() {
    activityIdController.clear();
    activityNameController.clear();
    coefficientController.text = '1';
    budgetedLaborUnitsController.clear();
    startDateController.clear();
    finishDateController.clear();
    moduleNameText = '';
  }

  void fillEditingControllers(ActivityModel activityModel) {
    activityIdController.text = activityModel.activityId ?? '';
    activityNameController.text = activityModel.activityName ?? '';
    coefficientController.text = activityModel.coefficient.toString();
    budgetedLaborUnitsController.text =
        activityModel.budgetedLaborUnits.toString();
    startDateController.text = activityModel.startDate!.toDMYhmDash();
    finishDateController.text = activityModel.finishDate!.toDMYhmDash();
    moduleNameText = activityModel.moduleName;
  }

  whenCompleted() {
    CustomFullScreenDialog.cancelDialog();
    clearEditingControllers();
    Get.back();
  }

  catchError(FirebaseException error) {
    CustomFullScreenDialog.cancelDialog();
    CustomSnackBar.showSnackBar(
      context: Get.context,
      title: "Error",
      message: "${error.message.toString()}",
      backgroundColor: Colors.red,
    );
  }

  @override
  buildAddForm({String? parentId}) {
    clearEditingControllers();
    homeController.getDialog(
      title: 'Add activity',
      content: ActivityFormWidget(),
    );
  }

  @override
  buildUpdateForm({required String id}) {
    final ActivityModel? activityModel = loading || documents.isEmpty
        ? null
        : documents.firstWhereOrNull((e) => e!.id == id);

    if (activityModel == null) return;

    fillEditingControllers(activityModel);
    homeController.getDialog(
      title: 'Update activity',
      content: ActivityFormWidget(id: id),
    );
  }

  @override
  List<Map<String, dynamic>?> get tableData {
    return loading || documents.isEmpty
        ? []
        : documents.map((activity) {
            String assignedTasks = '';

            List<String?> drawingIdsOfActivity = [];

            if (drawingController.documents.isNotEmpty ||
                !drawingController.loading) {
              Iterable<DrawingModel?> drawingsOfActivity =
                  drawingController.documents.where((e) =>
                      e!.isHidden == false && e.activityCodeId == activity!.id);

              drawingIdsOfActivity = drawingsOfActivity.isEmpty
                  ? []
                  : drawingsOfActivity.map((e) => e!.id).toList();
            }

            List<TaskModel?> taskIdsOfDrawings =
                (taskController.documents.isNotEmpty || !taskController.loading)
                    ? []
                    : taskController.documents
                        .where((task) =>
                            drawingIdsOfActivity.contains(task!.parentId))
                        .toList();

            taskIdsOfDrawings.forEach((task) {
              if (task != null) {
                DrawingModel? drawingModel = drawingController.loading ||
                        drawingController.documents.isEmpty
                    ? null
                    : drawingController.documents
                        .firstWhereOrNull((e) => e!.id == task.parentId);
                final String? drawingNumber =
                    drawingModel == null ? null : drawingModel.drawingNumber;
                if (![drawingNumber, task.id].contains(null)) {
                  assignedTasks += '|${drawingNumber};${task.id!}';
                }
              }
            });

            Map<String, dynamic> map = <String, dynamic>{
              'id': activity!.id,
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
            return homeController.getTableMap(map);
          }).toList();
  }

  ActivityModel? getById(String id) {
    return loading || documents.isEmpty
        ? null
        : documents.singleWhereOrNull((e) => e!.id == id);
  }

  String selectedActivities(String activityCodeId) {
    ActivityModel? activityModel = getById(activityCodeId);
    return activityModel == null ? ' ' : (activityModel.activityId ?? ' ');
  }

  int getPriority(DrawingModel drawing) {
    ActivityModel? activityModel = getById(drawing.activityCodeId);
    int priority = documents.indexOf(activityModel) + 1;
    return priority;
  }
}
