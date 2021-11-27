import 'package:dops/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recase/recase.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../constants/table_details.dart';

class TableView extends StatelessWidget {
  final controller;
  final String tableName;

  TableView({
    Key? key,
    required this.controller,
    required this.tableName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final DataSource dataSource =
            DataSource(data: controller.getDataForTableView);
        final DataGridController _dataGridController = DataGridController();

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              String rowId =
                  _dataGridController.selectedRow!.getCells()[0].value;
              controller.buildAddEdit(id: rowId);
            },
            child: const Icon(Icons.edit),
            backgroundColor: Colors.green,
          ),
          body: SfDataGrid(
            isScrollbarAlwaysShown: false,
            source: dataSource,
            columns: getColumns(tableColNames[tableName]!),
            gridLinesVisibility: GridLinesVisibility.both,
            headerGridLinesVisibility: GridLinesVisibility.both,
            columnWidthMode: ColumnWidthMode.fill,
            allowSorting: true,
            rowHeight: 70,
            controller: _dataGridController,
            selectionMode: SelectionMode.single,
            onCellTap: (details) {
              if (_dataGridController.selectedIndex >= 0) {
                _dataGridController.selectedIndex = -1;
              }
            },
          ),
        );
      },
    );
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

  getColumns(List<String> colNames) {
    return colNames.map(
      (colName) {
        switch (colName) {
          case 'id':
            return GridColumn(
              columnName: ReCase(colName).camelCase,
              width: 0,
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
          return Container(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: (cell.columnName == 'assignedTasks' ||
                          cell.columnName == 'drawingNumber') &&
                      cell.value.length != 0
                  ? cell.columnName == 'drawingNumber'
                      ? TextButton(
                          onPressed: () {
                            Get.toNamed(Routes.STAGES,
                                parameters: {'id': cell.value[1]});
                          },
                          child: Text(cell.value[0][0]),
                        )
                      : TextButton(
                          onPressed: () {
                            Get.defaultDialog(
                                content: Column(
                              children: cell.value
                                  .map<Widget>(
                                    (taskNoId) => TextButton(
                                      onPressed: () {
                                        Get.toNamed(Routes.STAGES,
                                            parameters: {'id': taskNoId[1]});
                                      },
                                      child: Text(taskNoId[0]),
                                    ),
                                  )
                                  .toList(),
                            ));
                          },
                          child: Text(cell.value.length.toString()),
                        )
                  : Text(cell.value.toString()),
            ),
          );
        },
      ).toList(),
    );
  }
}
