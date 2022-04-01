import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dops/components/custom_widgets.dart';
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

  int get nextGroupNumber =>
      documents.isEmpty ? 0 : documents.map((e) => e.groupNumber).reduce(max);

  @override
  void onInit() {
    super.onInit();
    noteController = TextEditingController();

    _documents.bindStream(_repository.getAllDocumentsAsStream());
  }

  saveDocument({required IssueModel model}) async {
    CustomFullScreenDialog.showDialog();
    await _repository.addModel(model);
    CustomFullScreenDialog.cancelDialog();
    Get.back();
  }

  updateDocument({required IssueModel model, required String id}) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    formKey.currentState!.save();
    CustomFullScreenDialog.showDialog();
    await _repository.updateModel(model, id);
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

  buildAddEdit({String? id}) {
    if (id != null) {
      fillEditingControllers(id);
    } else {
      clearEditingControllers();
    }

    Get.defaultDialog(
      barrierDismissible: false,
      radius: 12,
      titlePadding: EdgeInsets.only(top: 20, bottom: 20),
      title: id == null
          ? 'Add New Group #${issueController.nextGroupNumber + 1}'
          : 'Update Group #${issueController.documents.singleWhere((e) => e.id == id).groupNumber}',
      content: IssueAddUpdateFormWidget(id: id),
    );
  }

  List<Map<String, dynamic>> get getDataForTableView {
    return documents.map((issue) {
      String assignedTasks = '';

      issue.linkedTasks.forEach((taskId) {
        TaskModel? taskModel =
            taskController.documents.singleWhere((e) => e!.id == taskId);
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
        'createdBy': staffController.documents
            .singleWhere((e) => e.id == issue.createdBy)
            .initial,
        'creationDate': issue.creationDate,
        'assignedTasks': assignedTasks,
        'files': issue.files,
        'note': issue.note,
        // 'submit': ,
      };

      return map;
    }).toList();
  }

  addValues({required Map<String, dynamic> map, required String id}) async {
    CustomFullScreenDialog.showDialog();
    await _repository.addFields(map, id);
    CustomFullScreenDialog.cancelDialog();
  }
}
