import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/models/base_table_view_controller.dart';
import 'package:dops/modules/models/drawing_model.dart';
import 'package:dops/modules/models/task_model.dart';
import 'package:dops/modules/widgets/form_widgets/form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:collection/collection.dart';

import '../models/ref_doc_model.dart';
import '../repositories/ref_doc_repository.dart';

class ReferenceDocumentController extends BaseViewController {
  final GlobalKey<FormState> referenceDocumentFormKey = GlobalKey<FormState>();
  final _repo = Get.find<ReferenceDocumentRepository>();
  static ReferenceDocumentController instance = Get.find();

  late TextEditingController documentNumberController,
      titleController,
      transmittalNumberController,
      receiveDateController;
  String projectText = '';
  String referenceTypeText = '';
  String moduleNameText = '';

  RxBool actionRequiredOrNext = false.obs;

  RxBool sortAscending = false.obs;
  RxInt sortColumnIndex = 0.obs;

  RxList<ReferenceDocumentModel> _documents =
      RxList<ReferenceDocumentModel>([]);
  @override
  List<ReferenceDocumentModel> get documents => _documents;

  RxBool _loading = true.obs;
  @override
  bool get loading => _loading.value;

  // ReferenceDocumentModel getById(String? id) => documents.singleWhere((e) => e.id ==id)

  @override
  void onInit() {
    super.onInit();
    documentNumberController = TextEditingController();
    titleController = TextEditingController();
    transmittalNumberController = TextEditingController();
    receiveDateController = TextEditingController();

    _documents.bindStream(_repo.getAllDocumentsAsStream());
    _documents.listen((List<ReferenceDocumentModel?> refDocList) {
      if (refDocList.isNotEmpty) {
        _loading.value = false;
      }
    });
  }

  add({required ReferenceDocumentModel model}) async {
    CustomFullScreenDialog.showDialog();
    await _repo.addModel(model);
    CustomFullScreenDialog.cancelDialog();
    Get.back();
  }

  update({
    required ReferenceDocumentModel model,
    required String id,
  }) async {
    final isValid = referenceDocumentFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    referenceDocumentFormKey.currentState!.save();
    CustomFullScreenDialog.showDialog();
    await _repo.updateModel(model, id);
    CustomFullScreenDialog.cancelDialog();
    Get.back();
  }

  void deleteReferenceDocument(String id) {
    _repo.removeModel(id);
  }

  @override
  void onReady() {
    super.onReady();
  }

  void clearEditingControllers() {
    documentNumberController.clear();
    titleController.clear();
    transmittalNumberController.clear();
    receiveDateController.clear();
    projectText = '';
    moduleNameText = '';
    referenceTypeText = '';
  }

  void fillEditingControllers(String id) {
    final ReferenceDocumentModel model =
        documents.where((document) => document.id == id).toList()[0];

    documentNumberController.text = model.documentNumber;
    titleController.text = model.title;
    transmittalNumberController.text = model.transmittalNumber;
    actionRequiredOrNext.value = model.actionRequiredOrNext;
    receiveDateController.text = model.receivedDate.toDMYhmDash();
    projectText = model.project;
    moduleNameText = model.moduleName;
    referenceTypeText = model.referenceType;
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

  @override
  buildAddForm({String? parentId}) {
    clearEditingControllers();
    homeController.getDialog(
      title: 'Add Reference Document',
      content: RefDocAddUpdateFormWidget(),
    );
  }

  @override
  buildUpdateForm({required String id}) {
    fillEditingControllers(id);
    homeController.getDialog(
      title: 'Update Reference Document',
      content: RefDocAddUpdateFormWidget(id: id),
    );
  }

  void handleChangedRadio(bool? value) {
    actionRequiredOrNext.value = value!;
  }

  @override
  List<Map<String, dynamic>?> get tableData {
    return documents.map((refDoc) {
      String assignedTasks = '';

      if (!taskController.loading || taskController.documents.isNotEmpty) {
        taskController.documents.forEach(
          (task) {
            DrawingModel? drawingModel =
                drawingController.loading || drawingController.documents.isEmpty
                    ? null
                    : drawingController.documents
                        .firstWhereOrNull((e) => e!.id == task!.parentId);

            final String? drawingNumber =
                drawingModel == null ? null : drawingModel.drawingNumber;

            if (drawingNumber != null &&
                task!.referenceDocuments.contains(refDoc.documentNumber)) {
              assignedTasks += '|${drawingNumber};${task.id}';
            }
          },
        );
      }

      Map<String, dynamic> map = {
        'id': refDoc.id,
        'project': refDoc.project,
        'referenceType': refDoc.referenceType,
        'moduleName': refDoc.moduleName,
        'documentNumber': refDoc.documentNumber,
        'title': refDoc.title,
        'transmittalNumber': refDoc.transmittalNumber,
        'receivedDate': refDoc.receivedDate.toDayMonthYear(),
        'actionRequiredOrNext':
            !refDoc.actionRequiredOrNext ? 'Action required' : 'Next',
        'assignedTasks': assignedTasks,
      };

      return homeController.getTableMap(map);
    }).toList();
  }

  ReferenceDocumentModel? getById(String? id) =>
      documents.singleWhereOrNull((e) => e.id == id);

  @override
  Color? getRowColor(DataGridRow row) => null;

  @override
  Widget getCellWidget(DataGridCell cell, String? id) {
    List<TaskModel?> taskModels = getById(id)?.taskModels ?? [];
    switch (cell.columnName) {
      case 'assignedTasks':
        return TextButton(
          onPressed: () => taskController.taskNumberDialog(taskModels),
          child: Text('${taskModels.length}'),
        );
      default:
        return Text('${cell.value}');
    }
  }
}
