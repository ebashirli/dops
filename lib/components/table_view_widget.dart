import 'package:dops/routes/app_pages.dart';
import 'package:expendable_fab/expendable_fab.dart';
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

  get rowId => null;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final DataSource dataSource =
            DataSource(data: controller.getDataForTableView);
        final DataGridController _dataGridController = DataGridController();
        void onEditPressed({bool? newRev = false}) {
          if (_dataGridController.selectedRow == null) {
            Get.snackbar(
              'Selection',
              'Select an item',
              maxWidth: 250,
              backgroundColor: Colors.green[50],
            );
          } else {
            String rowId = _dataGridController.selectedRow!.getCells()[0].value;
            controller.buildAddEdit(id: rowId, newRev: newRev);
          }
        }

        return Scaffold(
          floatingActionButton: tableName == 'task'
              ? ExpendableFab(
                  distance: 80.0,
                  children: [
                    ActionButton(
                      onPressed: onEditPressed,
                      icon: const Icon(Icons.edit),
                    ),
                    ActionButton(
                      onPressed: () => {onEditPressed(newRev: true)},
                      icon: const Icon(Icons.add),
                    ),
                  ],
                )
              : FloatingActionButton(
                  onPressed: onEditPressed,
                  child: const Icon(Icons.edit),
                  backgroundColor: Colors.green,
                ),
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
              controller: _dataGridController,
              selectionMode: SelectionMode.single,
              onCellTap: (_) {
                if (_dataGridController.selectedIndex >= 0) {
                  _dataGridController.selectedIndex = -1;
                }
              },
              onCellDoubleTap: (_) {
                if (tableName == 'task') {
                  String rowId =
                      _dataGridController.selectedRow!.getCells()[0].value;
                  Get.toNamed(Routes.STAGES, parameters: {
                    'id': rowId,
                  });
                }
              },
            ),
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
          void onPressed(id) {
            Get.toNamed(Routes.STAGES, parameters: {'id': id});
          }

          return Container(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: (cell.columnName == 'assignedTasks' ||
                          cell.columnName == 'drawingNumber') &&
                      cell.value.length != 0
                  ? cell.columnName == 'drawingNumber'
                      ? TextButton(
                          onPressed: () => onPressed(cell.value
                              .substring(cell.value.indexOf('|') + 1)),
                          child: Text(
                              cell.value.substring(0, cell.value.indexOf('|'))),
                        )
                      : TextButton(
                          onPressed: () {
                            Get.defaultDialog(
                                content: Column(
                              children: cell.value
                                  .split('|')
                                  .sublist(1)
                                  .map<Widget>(
                                    (taskNoId) => TextButton(
                                      onPressed: () =>
                                          onPressed(taskNoId.split(';')[1]),
                                      child: Text(taskNoId.split(';')[0]),
                                    ),
                                  )
                                  .toList(),
                            ));
                          },
                          child: Text(
                              '|'.allMatches(cell.value).length.toString()),
                        )
                  : Text(cell.value is DateTime
                      ? '${cell.value.day}/${cell.value.month}/${cell.value.year}'
                      : cell.value.toString()),
            ),
          );
        },
      ).toList(),
    );
  }
}
