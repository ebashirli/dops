import 'package:dops/components/select_item_snackbar.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/modules/home/view_model.dart';
import 'package:dops/routes/app_pages.dart';
import 'package:expendable_fab/expendable_fab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recase/recase.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'custom_widgets.dart';

class TableViewWidget extends StatelessWidget {
  TableViewWidget({Key? key}) : super(key: key);

  final ViewModel tableViewModel = homeController.currentViewModel.value;

  DataSource get dataSource {
    List<Map<String, dynamic>?> tableData =
        tableViewModel.controller!.tableData;

    return DataSource(data: tableData);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: apply timer here after several seconds that indicator turns column heads
    return Obx(() {
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
                    columns: getColumns(homeController.columnNames),
                    gridLinesVisibility: GridLinesVisibility.both,
                    headerGridLinesVisibility: GridLinesVisibility.both,
                    columnWidthMode: ColumnWidthMode.auto,
                    allowSorting: true,
                    controller: homeController.dataGridController.value,
                    selectionMode: SelectionMode.singleDeselect,
                    navigationMode: GridNavigationMode.row,
                    onCellDoubleTap: onCellDoubleTap,
                  ),
                ),
              ),
            );
    });
  }

  bool get isDocumentsLoadingOrEmpty {
    return tableViewModel.tableName == 'task'
        ? drawingController.loading || drawingController.documents.isEmpty
        : tableViewModel.controller!.loading ||
            tableViewModel.controller!.documents.isEmpty;
  }

  Widget? baseFab() {
    return staffController.isCoordinator
        ? tableViewModel.tableName == 'task'
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
    if (tableViewModel.tableName == 'task') {
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
          ? tableViewModel.controller!.buildUpdateForm(id: id!)
          : drawingController.buildUpdateForm(id: id!);
    }
  }

  displayDeleteDialog(String docId) {
    Get.defaultDialog(
      title: "Delete a staff member",
      titleStyle: TextStyle(fontSize: 20),
      middleText: 'Are you sure to delete ${tableViewModel.tableName}?',
      textCancel: "Cancel",
      textConfirm: "Confirm",
      confirmTextColor: Colors.black,
      onCancel: () {},
      onConfirm: () {},
    );
  }

  List<GridColumn> getColumns(List<String?> colNames) {
    return colNames.isEmpty
        ? []
        : colNames.map(
            (colName) {
              switch (colName) {
                case 'Drawing Number':
                  return GridColumn(
                    columnWidthMode: ColumnWidthMode.auto,
                    maximumWidth: 220,
                    columnName: ReCase(colName!).camelCase,
                    // autoFitPadding: const EdgeInsets.all(8.0),
                    label: Center(
                      child: Container(
                        decoration: BoxDecoration(),
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomText(
                            colName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                default:
                  return GridColumn(
                    columnWidthMode: ColumnWidthMode.auto,
                    columnName: ReCase(colName!).camelCase,
                    autoFitPadding: const EdgeInsets.all(8.0),
                    label: Center(
                      child: Container(
                        decoration: BoxDecoration(),
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: CustomText(
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
  DataSource({required List<Map<String, dynamic>?> data}) {
    _data = data.map<DataGridRow>(
      (map) {
        return DataGridRow(
          cells: map!.entries.map(
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
              } else {
                textDrawingNumber = Text(cell.value);
                taskId == null;
              }
            }

            DateTime? dateTimeCellValue = null;
            if (cell.value is DateTime) dateTimeCellValue = cell.value;

            return Container(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: ['assignedTasks', 'drawingNumber']
                        .contains(cell.columnName)
                    ? cell.columnName == 'drawingNumber'
                        ? TextButton(
                            onPressed: taskId == null
                                ? null
                                : () => onPressed(taskId!),
                            child: textDrawingNumber,
                          )
                        : TextButton(
                            onPressed: '|'.allMatches(cell.value).isNotEmpty
                                ? () => taskNumberDialog(cell.value, onPressed)
                                : null,
                            child: Text(
                                '|'.allMatches(cell.value).length.toString()),
                          )
                    : CustomText(
                        cell.value is DateTime
                            ? dateTimeCellValue!.toDMYhm()
                            : cell.value.toString(),
                      ),
              ),
            );
          } else {
            return CustomText('');
          }
        },
      ).toList(),
    );
  }

  void taskNumberDialog(
    String cellValue,
    void onPressed(String id),
  ) =>
      homeController.getDialog(
        title: 'Assigned Tasks',
        content: Column(
          children: cellValue.split('|').sublist(1).map<Widget>(
            (taskNoId) {
              String taskId = taskNoId.split(';')[1];
              return TextButton(
                onPressed: () => onPressed(taskId),
                child: CustomText(taskController.taskNumber(taskNoId, taskId)),
              );
            },
          ).toList(),
        ),
      );
}
