import 'package:data_table_2/data_table_2.dart';
import 'package:dops/controllers/activity_code_controller.dart';
import 'package:dops/models/activity_codes_model.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:dops/constants/table_details.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ActivityCodeView extends StatelessWidget {
  final controller = Get.find<ActivityCodeController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          return DataTable2(
            columns: getColumns(activityCodeTableColumnNames),
            rows: getRows(controller.activityCodes),
            columnSpacing: 12,
            horizontalMargin: 12,
            dividerThickness: 1,
            bottomMargin: 10,
            minWidth: 900,
            dataRowHeight: 40,
            border: TableBorder(
              horizontalInside:
                  BorderSide(width: 0.5, color: Colors.grey[400]!),
              //   verticalInside: BorderSide(width: 0.5, color: Colors.grey[400]!),
              bottom: BorderSide(width: 0.5, color: Colors.grey[400]!),
            ),
            headingTextStyle: TextStyle(fontWeight: FontWeight.bold),
            sortColumnIndex: controller.sortColumnIndex.value,
            sortAscending: controller.sortAscending.value,
          );
        },
      ),
    );
  }

  displayDeleteDialog(String docId) {
    Get.defaultDialog(
      title: "Delete Activity Code",
      titleStyle: TextStyle(fontSize: 20),
      middleText: 'Are you sure to delete employee ?',
      textCancel: "Cancel",
      textConfirm: "Confirm",
      confirmTextColor: Colors.black,
      onCancel: () {},
      onConfirm: () {
        // controller.removeActivityCodeModel();
      },
    );
  }

  List<DataColumn2> getColumns(List<String> columns) {
    return columns.map(
      (String column) {
        return DataColumn2(
          label: Text(column),
          onSort: onSort,
        );
      },
    ).toList();
  }

  List<DataRow2> getRows(List<ActivityCodeModel> activityCodes) {
    List<DataRow2> dataRows =
        activityCodes.map((ActivityCodeModel activityCode) {
      final map = activityCode.toMap();
      List cells = map.values.toList();

      return DataRow2(
        onTap: () {
          controller.buildAddEdit(activityCodeModel: activityCode);
        },
        cells: getCells(cells),
      );
    }).toList();

    return dataRows;
  }

  List<DataCell> getCells(List<dynamic> cells) => cells.map((data) {
        return DataCell(
          Text(data is DateTime
              ? '${data.month}/${data.day}/${data.year}'
              : data is int || data is double
                  ? data.toString()
                  : data ?? ''),
        );
      }).toList();

  onSort(int columnIndex, bool ascending) {
    switch (columnIndex) {
      case 0:
        controller.activityCodes.sort(
          (activityCode1, activityCode2) => compare(
            ascending,
            activityCode1.activityId,
            activityCode2.activityId,
          ),
        );
        break;
      case 1:
        controller.activityCodes.sort(
          (activityCode1, activityCode2) => compare(
            ascending,
            activityCode1.activityName,
            activityCode2.activityName,
          ),
        );
        break;
      case 2:
        controller.activityCodes.sort(
          (activityCode1, activityCode2) => compare(
            ascending,
            activityCode1.area,
            activityCode2.area,
          ),
        );
        break;
      case 3:
        controller.activityCodes.sort(
          (activityCode1, activityCode2) => compare(
            ascending,
            activityCode1.prio,
            activityCode2.prio,
          ),
        );
        break;
      case 4:
        controller.activityCodes.sort(
          (
            activityCode1,
            activityCode2,
          ) =>
              compare(
            ascending,
            activityCode1.coefficient,
            activityCode2.coefficient,
          ),
        );
        break;
      case 5:
        controller.activityCodes.sort(
          (activityCode1, activityCode2) => compare(
            ascending,
            activityCode1.currentPriority,
            activityCode2.currentPriority,
          ),
        );
        break;
      case 6:
        controller.activityCodes.sort(
          (
            activityCode1,
            activityCode2,
          ) =>
              compare(
            ascending,
            activityCode1.budgetedLaborUnits,
            activityCode2.budgetedLaborUnits,
          ),
        );
        break;
      case 7:
        controller.activityCodes.sort(
          (
            activityCode1,
            activityCode2,
          ) =>
              compare(
            ascending,
            activityCode1.start,
            activityCode2.start,
          ),
        );
        break;
      case 8:
        controller.activityCodes.sort(
          (activityCode1, activityCode2) => compare(
            ascending,
            activityCode1.finish,
            activityCode2.finish,
          ),
        );
        break;
    }

    controller.sortColumnIndex.value = columnIndex;
    controller.sortAscending.value = ascending;
  }

  int compare(bool ascending, dynamic value1, dynamic value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);
}
