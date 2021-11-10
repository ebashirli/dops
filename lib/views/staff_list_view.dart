import 'package:dops/controllers/staff_list_controller.dart';
import 'package:dops/models/staff_list_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:dops/constants/table_details.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class StaffListView extends StatelessWidget {
  final controller = Get.find<StaffListController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          final EmployeeDataSource employeeDataSource =
              EmployeeDataSource(employeeData: controller.staffLists);

          return SfDataGrid(
              source: employeeDataSource,
              columns: getColumns(staffListTableColumnNames),
              gridLinesVisibility: GridLinesVisibility.both,
              // columnWidthMode: ColumnWidthMode.fitByCellValue,
              showCheckboxColumn: true,
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
                      staffListModel: controller
                          .staffLists[details.rowColumnIndex.rowIndex - 1]);
                }
              });
        },
      ),
    );
  }

  displayDeleteDialog(String docId) {
    Get.defaultDialog(
      title: "Delete Staff List",
      titleStyle: TextStyle(fontSize: 20),
      middleText: 'Are you sure to delete staff list?',
      textCancel: "Cancel",
      textConfirm: "Confirm",
      confirmTextColor: Colors.black,
      onCancel: () {},
      onConfirm: () {
        // controller.removeStaffListModel();
      },
    );
  }

  getColumns(List<String> lst) {
    return lst
        .map(
          (e) => GridColumn(
            columnWidthMode: ColumnWidthMode.auto,
            columnName: e.toLowerCase(),
            // autoFitPadding: const EdgeInsets.all(8.0),
            label: Center(
              child: Container(
                decoration: BoxDecoration(),
                // padding: EdgeInsets.all(20.0),
                alignment: Alignment.center,
                child: Text(e),
              ),
            ),
          ),
        )
        .toList();
  }
}

List<DataGridRow> _employeeData = [];

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource({required List<StaffListModel> employeeData}) {
    _employeeData = employeeData
        .map<DataGridRow>(
          (e) => DataGridRow(
            cells: e
                .toMap()
                .entries
                .map(
                  (i) => DataGridCell<dynamic>(
                    columnName: i.key,
                    value: i.value,
                  ),
                )
                .toList(),
          ),
        )
        .toList();
  }

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        // padding: EdgeInsets.all(8.0),
        child: Text(e.value is DateTime
            ? '${e.value.month}/${e.value.day}/${e.value.year}'
            : e.value is num
                ? e.value.toString()
                : e.value ?? ''),
      );
    }).toList());
  }
}
