import 'dart:math';
import 'package:collection/collection.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dops/components/custom_widgets.dart';
import 'package:dops/components/select_item_snackbar.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/modules/issue/issue_add_update_form_widget.dart';
import 'package:dops/modules/issue/issue_model.dart';
import 'package:dops/modules/issue/issue_repository.dart';
import 'package:dops/modules/task/task_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IssueController extends GetxService {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _repository = Get.find<IssueRepository>();
  static IssueController instance = Get.find();

  late TextEditingController noteController;

  RxList<IssueModel> _documents = RxList<IssueModel>([]);
  List<IssueModel> get documents => _documents;

  final RxList<String?> linkedTaskIds = RxList<String?>([]);

  final RxList<String?> files = RxList<String?>([]);

  int get maxGroupNumber =>
      documents.isEmpty ? 0 : documents.map((e) => e.groupNumber).reduce(max);

  RxBool loading = true.obs;

  @override
  void onInit() {
    super.onInit();
    noteController = TextEditingController();

    _documents.bindStream(_repository.getAllDocumentsAsStream());
    _documents.listen((List<IssueModel?> issueModelList) {
      if (issueModelList.isNotEmpty) loading.value = false;
    });
  }

  saveDocument({required IssueModel model}) async {
    CustomFullScreenDialog.showDialog();
    await _repository.addModel(model);
    CustomFullScreenDialog.cancelDialog();
    Get.back();
  }

  updateDocument(String id) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    formKey.currentState!.save();
    CustomFullScreenDialog.showDialog();
    IssueModel? issueModel = getById(id);
    if (issueModel == null) return;

    Map<String, dynamic> map = {
      if (issueController.noteController.text != issueModel.note)
        'note': issueController.noteController.text,
      if (issueController.files != issueModel.files)
        'files': issueController.files,
      if (issueController.linkedTaskIds != issueModel.linkedTaskIds)
        'linkedTasks': issueController.linkedTaskIds,
    };

    await _repository.updateModel(map, id);
    CustomFullScreenDialog.cancelDialog();
    Get.back();
  }

  void deleteIssue(String id) {
    _repository.removeModel(id);
  }

  @override
  void onReady() {
    super.onReady();
  }

  void clearEditingControllers() {
    noteController.clear();
  }

  void fillEditingControllers(String id) {
    final IssueModel model =
        documents.where((document) => document.id == id).toList()[0];

    noteController.text = model.note;
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

  buildAddForm({String? id}) {
    int groupNumber = issueController.maxGroupNumber;

    if (id != null) {
      IssueModel? issueModel = getById(id);

      if (issueModel == null)
        return selectItemSnackbar(message: 'Refresh page');

      if (!staffController.isCoordinator &&
          issueModel.createdBy != staffController.currentUserId) {
        selectItemSnackbar(
            message: 'Select a group that created by yourselves');
        return;
      }
      groupNumber = issueModel.groupNumber;
      fillEditingControllers(id);
    } else {
      clearEditingControllers();
    }

    Get.defaultDialog(
      barrierDismissible: false,
      radius: 12,
      titlePadding: EdgeInsets.only(top: 20, bottom: 20),
      title: id == null
          ? 'Add New Group #${groupNumber + 1}'
          : 'Update Group #$groupNumber}',
      content: IssueAddUpdateFormWidget(id: id),
    );
  }

  buildUpdateForm({required String? id}) {
    int groupNumber = issueController.maxGroupNumber;

    if (id != null) {
      IssueModel? issueModel = getById(id);

      if (issueModel == null)
        return selectItemSnackbar(message: 'Refresh page');

      if (!staffController.isCoordinator &&
          issueModel.createdBy != staffController.currentUserId) {
        selectItemSnackbar(
            message: 'Select a group that created by yourselves');
        return;
      }
      groupNumber = issueModel.groupNumber;
      fillEditingControllers(id);
    } else {
      clearEditingControllers();
    }

    Get.defaultDialog(
      barrierDismissible: false,
      radius: 12,
      titlePadding: EdgeInsets.only(top: 20, bottom: 20),
      title: id == null
          ? 'Add New Group #${groupNumber + 1}'
          : 'Update Group #$groupNumber}',
      content: IssueAddUpdateFormWidget(id: id),
    );
  }

  List<Map<String, dynamic>> get getDataForTableView {
    return documents.map((issue) {
      String assignedTasks = '';
      if (issue.linkedTaskIds.isNotEmpty)
        issue.linkedTaskIds.forEach((String? taskId) {
          TaskModel? taskModel = taskController.getById(taskId!);
          if (taskModel != null) {
            final String drawingNumber = drawingController.documents
                .where((drawing) => drawing.id == taskModel.parentId)
                .toList()[0]
                .drawingNumber;
            assignedTasks += '|${drawingNumber};${taskModel.id!}';
          }
        });

      Map<String, dynamic> map = {
        'id': issue.id,
        'groupNumber': 'Group Number #${issue.groupNumber}',
        'createdBy': staffController.getStaffInitialById(issue.createdBy),
        'creationDate': issue.creationDate,
        'assignedTasks': assignedTasks,
        'files': issue.files,
        'note': issue.note,
        'closeDate': issue.closeDate,
        // 'submitDate': getMaxSubmitDate(issue.linkedTasks),
        'issueDate': issue.issueDate,
      };

      return map;
    }).toList();
  }

  addValues({required Map<String, dynamic> map, required String id}) async {
    CustomFullScreenDialog.showDialog();
    await _repository.addFields(map, id);
    CustomFullScreenDialog.cancelDialog();
  }

  onClosePressed(IssueModel issueModel) {
    onConfirm() {
      final DateTime now = DateTime.now();
      issueController.addValues(
        map: {
          'closeDate': now,
          'closedBy': staffController.currentUserId,
        },
        id: issueModel.id!,
      );
      for (String? taskId in issueModel.linkedTaskIds) {
        TaskModel? taskModel = taskController.loading.value ||
                taskController.documents.isEmpty ||
                taskId == null
            ? null
            : taskController.getById(taskId);
        if (taskModel == null) return 'Error: task model not found';

        String valueModelId = stageController
            .getStagesAndValueModelsByTask(taskModel)[8]!
            .values
            .first
            .singleWhereOrNull(
                (e) => e!.employeeId == staffController.currentUserId)!
            .id!;
        valueController.addValues(
          map: {'submitDateTime': now},
          id: valueModelId,
        );
      }
    }

    if (issueModel.linkedTaskIds.isEmpty || issueModel.files.isEmpty) {
      Get.defaultDialog(
        title: 'Empty field!',
        content: Text(
          'Theres is no linked tasks or files have not been attached.\nIf you want to continue press "Ok" else "Cancel".',
        ),
        onCancel: () {},
        onConfirm: () {
          onConfirm();
          Get.back();
        },
      );
    } else {
      onConfirm();
    }
  }

  void onSendPressed(IssueModel issueModel) {
    print('Sended');
    // stageController.addNew(
    //   model: StageModel(
    //     index: 10,
    //     taskId: taskId,
    //     creationDateTime: creationDateTime,
    //   ),
    // );
  }

  // DateTime? getMaxSubmitDate(List<String?> linkedTasks) {
  //   linkedTasks = taskController.removeDeletedIds(linkedTasks);
  //   if (linkedTasks.isEmpty) return null;
  //   List<DateTime?> maxSubmitDateList = linkedTasks.map((String? taskId) {
  //     Map<StageModel, List<ValueModel?>>? map =
  //         stageController.getStageByTaskAndIndex(
  //       taskId: taskId!,
  //       index: 8,
  //     );
  //     if (map == null || map.isEmpty) return null;
  //     List<ValueModel?> valueList = map.values.first;
  //     if (valueList.isEmpty) return null;
  //     List<DateTime?> submitDateList =
  //         valueList.map((e) => e!.submitDateTime).toList();
  //     if (submitDateList.contains(null)) return null;
  //     return submitDateList.reduce(
  //       (a, b) => a!.isAfter(b!) ? a : b,
  //     );
  //   }).toList();
  //   if (maxSubmitDateList.contains(null)) return null;
  //   return maxSubmitDateList.reduce((v, e) => v!.isAfter(e!) ? v : e);
  // }

  IssueModel? getById(String id) => loading.value || documents.isEmpty
      ? null
      : documents.singleWhereOrNull((e) => e.id == id);

  List<IssueModel?> issuModelsByTaskId(String taskId) {
    return documents.isEmpty || loading.value
        ? []
        : issueController.documents
            .where((IssueModel issueModel) =>
                issueModel.linkedTaskIds.contains(taskId))
            .toList();
  }
}
