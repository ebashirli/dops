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
    final DataSource dataSource = DataSource(data: controller.getDataForTableView);
    return SfDataGrid(
      source: dataSource,
      columns: getColumns(tableColNames[tableName]!),
      gridLinesVisibility: GridLinesVisibility.both,
      headerGridLinesVisibility: GridLinesVisibility.both,
      columnWidthMode: ColumnWidthMode.fill,
      allowSorting: true,
      allowMultiColumnSorting: true,
      allowTriStateSorting: true,
      showSortNumbers: true,
      onCellTap: (details) {
        if (details.rowColumnIndex.rowIndex == 0) {
          if (controller.sortAscending.value) {
            DataGridSortDirection.descending;
            controller.sortAscending.value = false;
          } else {
            DataGridSortDirection.ascending;
            controller.sortAscending.value = true;
          }
        } else {
          controller.buildAddEdit(
              aModel:
                  controller.documents[details.rowColumnIndex.rowIndex - 1]);
        }
      },
    );
  }

  displayDeleteDialog(String docId) {
    Get.defaultDialog(
      title: "Delete Staff List",
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
                // padding: EdgeInsets.all(20.0),
                alignment: Alignment.center,
                child: Text(colName),
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
          child: Text(e.value),
        );
      },
    ).toList());
  }
}
