import 'package:dops/constants/table_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class TableView extends StatelessWidget {
  final controller;
  final String tableName;

  const TableView({
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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SfDataGrid(
              isScrollbarAlwaysShown: false,
              source: dataSource,
              columns: getColumns(tableColNames[tableName]!),
              gridLinesVisibility: GridLinesVisibility.both,
              headerGridLinesVisibility: GridLinesVisibility.both,
              columnWidthMode: ColumnWidthMode.fill,
              allowSorting: true,
              rowHeight: 30,
              onCellTap: (details) {
                if (details.rowColumnIndex.rowIndex == 0) {
                  // dataSource.sortedColumns
                  //     .add(SortColumnDetails('id', SortDirection.ascending));
                  // _employeeDataSource.sort();
                  if (!controller.sortAscending.value) {
                    DataGridSortDirection.ascending;
                    controller.sortAscending.value = false;
                    dataSource.sort();
                  } else {
                    DataGridSortDirection.descending;
                    controller.sortAscending.value = true;
                  }
                } else {
                  print(dataSource.rows[details.rowColumnIndex.rowIndex]
                      .getCells()
                      .map((e) => e.value)
                      .toList());

                  controller.buildAddEdit(
                    aModel: controller
                        .documents[details.rowColumnIndex.rowIndex - 1],
                  );
                }
              },
            ),
          ],
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
    return colNames
        .map(
          (colName) => GridColumn(
            columnWidthMode: ColumnWidthMode.auto,
            columnName: colName.toLowerCase(),
            // autoFitPadding: const EdgeInsets.all(8.0),
            label: Center(
              child: Container(
                decoration: BoxDecoration(),
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    colName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        )
        .toList();
  }
}

List<DataGridRow> _data = [];

class DataSource extends DataGridSource {
  DataSource({required List<Map<String, dynamic>> data}) {
    _data = data
        .map<DataGridRow>(
          (map) => DataGridRow(
            cells: map.entries
                .map(
                  (entry) => DataGridCell<dynamic>(
                    columnName: entry.key,
                    value: entry.value,
                  ),
                )
                .toList(),
          ),
        )
        .toList();
  }

  @override
  List<DataGridRow> get rows => _data;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>(
      (e) {
        return Container(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(e.value),
          ),
        );
      },
    ).toList());
  }
}
