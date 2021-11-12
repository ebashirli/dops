import 'package:dops/controllers/activity_controller.dart';
import 'package:dops/models/activity_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dops/constants/table_details.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ActivityView extends StatelessWidget {
  final controller = Get.find<ActivityController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          final EmployeeDataSource employeeDataSource =
              EmployeeDataSource(employeeData: controller.activities);

          return SfDataGrid(
            source: employeeDataSource,
            columns: getColumns(activityTableColumnNames),
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
                    aModel: controller
                        .activities[details.rowColumnIndex.rowIndex - 1]);
              }
            },
          );
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
        // controller.removeStaffModel();
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
  EmployeeDataSource({required List<ActivityModel> employeeData}) {
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
