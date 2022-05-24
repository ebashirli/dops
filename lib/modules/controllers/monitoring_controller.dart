import 'package:dops/constants/constant.dart';
import 'package:dops/constants/lists.dart';
import 'package:dops/models/base_table_view_controller.dart';
import 'package:dops/modules/models/staff_model.dart';
import 'package:dops/modules/models/stage_model.dart';
import 'package:dops/modules/models/task_model.dart';
import 'package:dops/modules/models/value_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recase/recase.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class MonitoringController extends BaseViewController {
  static MonitoringController instance = Get.find();

  RxBool sortAscending = false.obs;
  RxInt sortColumnIndex = 0.obs;

  @override
  List<Map<String, dynamic>?> get tableData {
    return staffController.documents.map((staff) {
      Map<String, dynamic> map = {};
      map = {
        'id': staff.id!,
        'fullName': '${staff.name} ${staff.surname}',
        'initial': '${staff.initial}',
        'jobTitle': '${staff.jobTitle}',
        'count': valueController.documents
            .where(
                (e) => e?.employeeId == staff.id && e?.submitDateTime == null)
            .length,
      };
      homeController.currentViewModel.value.columns!
          .sublist(5)
          .forEach((colName) {
        map[ReCase(colName!).camelCase] =
            getTaskModels(id: staff.id!, colName: colName)
                .map((e) => e?.taskNumber)
                .join(', ');
      });

      return homeController.getTableMap(map);
    }).toList();
  }

  Set<TaskModel?> getTaskModels({String? id, String? colName}) {
    if ([colName, id].contains(null)) return {};
    final Map<String, int> stageNames = {};

    stageDetailsList
        .map((e) => ReCase(e['name']).camelCase)
        .toList()
        .asMap()
        .forEach((key, value) => stageNames[value] = key);
    StaffModel? staffModel = staffController.getById(id!);
    List<ValueModel?> valueModels = staffModel?.valueModels ?? [];
    Set<StageModel?> stageModels =
        valueModels.map((e) => e?.stageModel).toSet();

    Set<StageModel?> stageModelsByIndex =
        stageModels.where((e) => e?.index == stageNames[colName]).toSet();
    return stageModelsByIndex.map((e) => e?.taskModel).toSet();
  }

  @override
  List get documents {
    return staffController.documents;
  }

  @override
  bool get loading {
    return staffController.loading &&
        drawingController.loading &&
        taskController.loading &&
        stageController.loading &&
        valueController.loading;
  }

  @override
  void onInit() => super.onInit();
  @override
  buildAddForm({String? parentId}) {}
  @override
  buildUpdateForm({required String id}) {}

  @override
  Color? getRowColor(DataGridRow row) {
    final int count = row.getCells()[4].value;
    return count == 0 ? Colors.red[100] : null;
  }

  @override
  Widget getCellWidget(DataGridCell cell, String? id) {
    switch (cell.columnName) {
      case 'importing':
      case 'modelling':
      case 'drafting':
      case 'checking':
      case 'backDrafting':
      case 'backChecking':
      case 'reviewing':
      case 'filing':
      case 'nesting':
      case 'issuing':
        Set<TaskModel?> taskModels = getTaskModels(
          colName: cell.columnName,
          id: id,
        );
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: taskModels.map((e) {
            return TextButton(
              onPressed:
                  e == null ? null : () => taskController.goToStages(e.id!),
              child: Text('${e?.taskNumber}'),
            );
          }).toList(),
        );
      default:
        return Text('${cell.value}');
    }
  }
}
