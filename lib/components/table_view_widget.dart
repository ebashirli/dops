import 'package:dops/components/select_item_snackbar.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/enum.dart';
import 'package:dops/modules/issue/issue_model.dart';
import 'package:dops/modules/values/value_model.dart';
import 'package:dops/routes/app_pages.dart';
import 'package:expendable_fab/expendable_fab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recase/recase.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../constants/table_details.dart';
import 'package:dops/components/date_time_extension.dart';
import 'package:collection/collection.dart';

class TableView extends StatelessWidget {
  final controller;
  final String tableName;

  TableView({
    Key? key,
    required this.controller,
    required this.tableName,
  }) : super(key: key);

  DataSource get dataSource => DataSource(data: controller.getDataForTableView);

  @override
  Widget build(BuildContext context) => isDocumentsEmpty
      ? CircularProgressIndicator() // TODO: apply timer here after several seconds that indicator turns column heads
      : Obx(
          () => Scaffold(
            floatingActionButton: baseFab(),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SfDataGrid(
                isScrollbarAlwaysShown: false,
                source: dataSource,
                columns: getColumns(tableColNames[tableName]!),
                gridLinesVisibility: GridLinesVisibility.both,
                headerGridLinesVisibility: GridLinesVisibility.both,
                columnWidthMode: ColumnWidthMode.fill,
                allowSorting: true,
                rowHeight: 70,
                controller: homeController.dataGridController.value,
                selectionMode: SelectionMode.singleDeselect,
                navigationMode: GridNavigationMode.row,
                onCellDoubleTap: onCellDoubleTap,
              ),
            ),
          ),
        );

  bool get isDocumentsEmpty => tableName != 'task'
      ? controller.documents.isEmpty
      : drawingController.documents.isEmpty
          ? true
          : taskController.documents.isNotEmpty
              ? stageController.documents.isEmpty
              : false;

  Widget? baseFab() {
    bool isThereIncompleteIssueCreatedByCurrentUser =
        homeController.homeStates == HomeStates.IssueState &&
            issueController.documents
                .where(
                  (e) =>
                      e.issueDate == null &&
                      e.createdBy == staffController.currentUserId,
                )
                .isNotEmpty;
    return staffController.isCoordinator ||
            isThereIncompleteIssueCreatedByCurrentUser
        ? tableName == 'task'
            ? expandableFab()
            : fab()
        : null;
  }

  FloatingActionButton fab() {
    return FloatingActionButton(
      onPressed: () => onUpdatePressed(controller),
      child: const Icon(Icons.edit),
      backgroundColor: Colors.green,
    );
  }

  ExpendableFab expandableFab() {
    return ExpendableFab(
      distance: 80.0,
      children: [
        ElevatedButton(
          onPressed: () => onUpdatePressed(drawingController, cellIndex: 1),
          child: Text('Edit drawing'),
        ),
        ElevatedButton(
          onPressed: () => onUpdatePressed(controller),
          child: Text('Edit task'),
        ),
      ],
    );
  }

  void onCellDoubleTap(_) {
    if (tableName == 'task') {
      String? rowId = homeController.dataGridController.value.selectedRow!
          .getCells()[0]
          .value;
      if (rowId != null) {
        Get.toNamed(Routes.STAGES, parameters: {'id': rowId});
      }
      ;
    }
  }

  void onUpdatePressed(contr, {int cellIndex = 0}) {
    DataGridRow? selectedRow =
        homeController.dataGridController.value.selectedRow;
    if (selectedRow == null) {
      selectItemSnackbar();
    } else {
      String? id = selectedRow.getCells()[cellIndex].value;
      print(id.toString());

      id == null
          ? selectItemSnackbar(
              message: 'Select a drawing with a task to update')
          : contr.buildUpdateForm(id: id);
    }
  }

  displayDeleteDialog(String docId) {
    Get.defaultDialog(
      title: "Delete a staff member",
      titleStyle: TextStyle(fontSize: 20),
      middleText: 'Are you sure to delete $tableName?',
      textCancel: "Cancel",
      textConfirm: "Confirm",
      confirmTextColor: Colors.black,
      onCancel: () {},
      onConfirm: () {},
    );
  }

  List<GridColumn> getColumns(List<String> colNames) {
    return colNames.map(
      (colName) {
        switch (colName) {
          case 'parentid':
          case 'id':
            return GridColumn(
              columnName: ReCase(colName).camelCase,
              width: 100,
              label: Text(
                colName,
              ),
            );
          default:
            return GridColumn(
              columnName: ReCase(colName).camelCase,
              autoFitPadding: const EdgeInsets.all(8.0),
              label: Center(
                child: Container(
                  decoration: BoxDecoration(),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      colName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            );
        }
      },
    ).toList();
  }
}

List<DataGridRow> _data = [];

class DataSource extends DataGridSource {
  DataSource({required List<Map<String, dynamic>> data}) {
    _data = data.map<DataGridRow>(
      (map) {
        return DataGridRow(
          cells: map.entries.map(
            (entry) {
              return DataGridCell<dynamic>(
                columnName: entry.key,
                value: entry.value,
              );
            },
          ).toList(),
        );
      },
    ).toList();
  }

  @override
  List<DataGridRow> get rows => _data;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>(
        (cell) {
          if (['submitDate', 'issueDate'].contains(cell.columnName) &&
              cell.value == null) return provideIssueButtons(cell, row);

          if (cell.value != null) {
            void onPressed(String id) =>
                Get.toNamed(Routes.STAGES, parameters: {'id': id});

            Text textDrawingNumber = Text('');
            String? taskId = null;

            if (cell.columnName == 'drawingNumber') {
              int indexOfVbar = cell.value.indexOf('|');
              if (indexOfVbar != -1) {
                textDrawingNumber = Text(cell.value.substring(0, indexOfVbar));
                taskId = cell.value.substring(indexOfVbar + 1);
              }
            }

            DateTime? dateTimeCellValue = null;
            if (cell.value is DateTime) dateTimeCellValue = cell.value;

            return Container(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: cell.columnName == 'files'
                    ? TextButton(
                        onPressed: cell.value.isNotEmpty
                            ? () => filesDialog(cell.value)
                            : null,
                        child: Text(cell.value.length.toString()),
                      )
                    : (cell.columnName == 'assignedTasks' ||
                            cell.columnName == 'drawingNumber')
                        ? cell.columnName == 'drawingNumber'
                            ? taskId != 'null'
                                ? TextButton(
                                    onPressed: () => onPressed(taskId!),
                                    child: textDrawingNumber,
                                  )
                                : textDrawingNumber
                            : TextButton(
                                onPressed: '|'.allMatches(cell.value).isNotEmpty
                                    ? () =>
                                        taskNumberDialog(cell.value, onPressed)
                                    : null,
                                child: Text(
                                  '|'.allMatches(cell.value).length.toString(),
                                ),
                              )
                        : Text(
                            cell.value is DateTime
                                ? dateTimeCellValue!.toDMYhm()
                                : cell.value.toString(),
                          ),
              ),
            );
          } else {
            return Text('');
          }
        },
      ).toList(),
    );
  }

  Widget provideIssueButtons(DataGridCell<dynamic> cell, DataGridRow row) {
    String rowId = row.getCells()[0].value;
    IssueModel? issueModel =
        issueController.loading.value || issueController.documents.isEmpty
            ? null
            : issueController.documents.firstWhereOrNull((e) => e.id == rowId);
    if (issueModel == null) return Text('');

    bool isSubmitVisible = (cell.columnName == 'submitDate') &&
        (issueModel.createdBy == staffController.currentUserId) &&
        (issueModel.linkedTasks.isNotEmpty || issueModel.files.isNotEmpty);

    bool isIssueButtonVisible = cell.columnName == 'issueDate' &&
        staffController.isCoordinator &&
        issueModel.issueDate == null &&
        areAllValueModelsSubmitted(issueModel.linkedTasks);

    return isSubmitVisible
        ? Padding(
            padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
            child: ElevatedButton(
              key: Key(row.getCells()[0].value),
              onPressed: () => issueController.onIssueSubmitPressed(issueModel),
              child: Text('Submit'),
            ),
          )
        : isIssueButtonVisible
            ? Padding(
                padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                child: ElevatedButton(
                  key: Key(row.getCells()[0].value),
                  onPressed: () =>
                      issueController.onSendToDCCPressed(issueModel),
                  child: Text('Send To DCC'),
                ),
              )
            : Text('');
  }

  void taskNumberDialog(
    String cellValue,
    void onPressed(String id),
  ) =>
      Get.defaultDialog(
        title: 'Assigned Tasks',
        content: Column(
          children: cellValue.split('|').sublist(1).map<Widget>(
            (taskNoId) {
              String taskId = taskNoId.split(';')[1];
              return TextButton(
                onPressed: () => onPressed(taskId),
                child: Text(taskController.taskNumber(taskNoId, taskId)),
              );
            },
          ).toList(),
        ),
      );

  bool areAllValueModelsSubmitted(List<String?> linkedTasks) {
    linkedTasks = taskController.removeDeletedIds(linkedTasks);
    if (linkedTasks.isEmpty) return false;

    return !linkedTasks.map((String? taskId) {
      List<ValueModel?> valueModelList = stageController
          .getStageByTaskAndIndex(taskId: taskId!, index: 8)!
          .values
          .first;
      if (valueModelList.isEmpty) return true;

      return valueModelList
          .map((e) => e!.submitDateTime == null)
          .contains(true);
    }).contains(true);
  }
}
