import 'package:dops/components/select_item_snackbar.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/enum.dart';
import 'package:dops/modules/issue/issue_model.dart';
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
  Widget build(BuildContext context) {
    // TODO: apply timer here after several seconds that indicator turns column heads
    return isDocumentsLoadingOrEmpty
        ? Center(child: CircularProgressIndicator())
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
  }

  bool get isDocumentsLoadingOrEmpty {
    return tableName == 'task'
        ? drawingController.loading.value || drawingController.documents.isEmpty
        : controller.documents.isEmpty;
  }

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
      onPressed: () => onUpdatePressed(),
      child: const Icon(Icons.edit),
      backgroundColor: Colors.green,
    );
  }

  ExpendableFab expandableFab() {
    return ExpendableFab(
      distance: 80.0,
      children: [
        ElevatedButton(
          onPressed: () => onUpdatePressed(cellIndex: 1),
          child: Text('Edit drawing'),
        ),
        ElevatedButton(
          onPressed: () => onUpdatePressed(),
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

  void onUpdatePressed({int cellIndex = 0}) {
    DataGridRow? selectedRow =
        homeController.dataGridController.value.selectedRow;
    if (selectedRow == null) {
      selectItemSnackbar();
    } else {
      String? id = selectedRow.getCells()[cellIndex].value;
      cellIndex == 0
          ? controller.buildUpdateForm(id: id)
          : drawingController.buildUpdateForm(id: id!);
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
          if (['closeDate', 'issueDate'].contains(cell.columnName) &&
              cell.value == null) {
            return provideIssueButtons(cell, row);
          }

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
                                child: Text('|'
                                    .allMatches(cell.value)
                                    .length
                                    .toString()),
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
    final String rowId = row.getCells()[0].value;
    final IssueModel? issueModel =
        issueController.loading.value || issueController.documents.isEmpty
            ? null
            : issueController.documents.firstWhereOrNull((e) => e.id == rowId);
    if (issueModel == null) return Text('');

    bool isCloseVisible = (cell.columnName == 'closeDate') &&
        (issueModel.createdBy == staffController.currentUserId) &&
        (issueModel.linkedTaskIds.isNotEmpty || issueModel.files.isNotEmpty);

    bool isSendVisible = cell.columnName == 'issueDate' &&
        staffController.isCoordinator &&
        areAllGroupsClosed(issueModel.linkedTaskIds);

    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
      child: isCloseVisible || isSendVisible
          ? ElevatedButton(
              key: Key(row.getCells()[0].value),
              onPressed: () => isSendVisible
                  ? issueController.onSendPressed(issueModel)
                  : issueController.onClosePressed(issueModel),
              child: Text(isSendVisible ? 'Send' : 'Close'),
            )
          : Text(''),
    );
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

  bool areAllGroupsClosed(List<String?> linkedTaskIds) {
    if (linkedTaskIds.isEmpty) return true;
    linkedTaskIds = taskController.removeDeletedIds(linkedTaskIds);
    if (linkedTaskIds.isEmpty) return false;

    for (String? taskId in linkedTaskIds) {
      List<IssueModel?> issueModelList =
          issueController.issuModelsByTaskId(taskId!);
      if (issueModelList.isEmpty) return false;

      for (IssueModel? issueModel in issueModelList) {
        if (issueModel!.closeDate == null) return false;
      }
    }

    return true;
  }
}
