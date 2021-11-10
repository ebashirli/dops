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
            onCellTap: (details) => controller.buildAddEdit(
                staffListModel:
                    controller.staffLists[details.rowColumnIndex.rowIndex - 1]),
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




// [
  //             // DataGridCell<String?>(columnName: 'id', value: e.id),
  //             DataGridCell<String>(columnName: 'badgeNo', value: e.badgeNo),
  //             DataGridCell<String>(columnName: 'name', value: e.name),
  //             DataGridCell<String>(columnName: 'surname', value: e.surname),
  //             DataGridCell<String>(
  //                 columnName: 'patronymic', value: e.patronymic),
  //             DataGridCell<String>(columnName: 'fullName', value: e.fullName),
  //             DataGridCell<String>(columnName: 'initial', value: e.initial),
  //             DataGridCell<String>(
  //                 columnName: 'systemDesignation', value: e.systemDesignation),
  //             DataGridCell<String>(columnName: 'jobTitle', value: e.jobTitle),
  //             DataGridCell<String>(columnName: 'email', value: e.email),
  //             DataGridCell<String>(columnName: 'company', value: e.company),
  //             DataGridCell<DateTime>(
  //                 columnName: 'dateOfBirth', value: e.dateOfBirth),
  //             DataGridCell<String>(
  //                 columnName: 'homeAddress', value: e.homeAddress),
  //             DataGridCell<DateTime>(
  //                 columnName: 'startDate', value: e.startDate),
  //             DataGridCell<String>(
  //                 columnName: 'currentPlace', value: e.currentPlace),
  //             DataGridCell<DateTime>(
  //                 columnName: 'contractFinishDate',
  //                 value: e.contractFinishDate),
  //             DataGridCell<String>(columnName: 'contact', value: e.contact),
  //             DataGridCell<String>(
  //                 columnName: 'emergencyContact', value: e.emergencyContact),
  //             DataGridCell<String>(
  //                 columnName: 'emergencyContactName',
  //                 value: e.emergencyContactName),
  //             DataGridCell<String>(columnName: 'note', value: e.note),
  //           ]


// List<DataColumn2> getColumns(List<String> columns) =>
//       columns.map((String column) {
//         return DataColumn2(
//           label: Text(column),
//           onSort: onSort,
//         );
//       }).toList();

//   List<DataRow2> getRows(List<StaffListModel> staffListModels) {
//     List<DataRow2> dataRows =
//         staffListModels.map((StaffListModel staffListModel) {
//       final map = staffListModel.toMap();
//       List cells = map.values.toList();

//       return DataRow2(
//         onTap: () {
//           controller.buildAddEdit(staffListModel: staffListModel);
//         },
//         cells: getCells(cells),
//       );
//     }).toList();

//     return dataRows;
//   }

//   List<DataCell> getCells(List<dynamic> cells) => cells.map((data) {
//         return DataCell(
//           Text(data is DateTime
//               ? '${data.month}/${data.day}/${data.year}'
//               : data is num
//                   ? data.toString()
//                   : data ?? ''),
//         );
//       }).toList();

//   onSort(int columnIndex, bool ascending) {
//     switch (columnIndex) {
//       case 0:
//         controller.staffLists.sort((
//           staffListItem1,
//           staffListItem2,
//         ) =>
//             compare(
//               ascending,
//               staffListItem1.badgeNo,
//               staffListItem2.badgeNo,
//             ));
//         break;
//       case 1:
//         controller.staffLists.sort((
//           staffListItem1,
//           staffListItem2,
//         ) =>
//             compare(
//               ascending,
//               staffListItem1.name,
//               staffListItem2.name,
//             ));
//         break;
//       case 2:
//         controller.staffLists.sort((
//           staffListItem1,
//           staffListItem2,
//         ) =>
//             compare(
//               ascending,
//               staffListItem1.surname,
//               staffListItem2.surname,
//             ));
//         break;
//       case 3:
//         controller.staffLists.sort((
//           staffListItem1,
//           staffListItem2,
//         ) =>
//             compare(
//               ascending,
//               staffListItem1.patronymic,
//               staffListItem2.patronymic,
//             ));
//         break;
//       case 4:
//         controller.staffLists.sort((
//           staffListItem1,
//           staffListItem2,
//         ) =>
//             compare(
//               ascending,
//               staffListItem1.fullName,
//               staffListItem2.fullName,
//             ));
//         break;
//       case 5:
//         controller.staffLists.sort((
//           staffListItem1,
//           staffListItem2,
//         ) =>
//             compare(
//               ascending,
//               staffListItem1.initial,
//               staffListItem2.initial,
//             ));
//         break;
//       case 6:
//         controller.staffLists.sort((
//           staffListItem1,
//           staffListItem2,
//         ) =>
//             compare(
//               ascending,
//               staffListItem1.systemDesignation,
//               staffListItem2.systemDesignation,
//             ));
//         break;
//       case 7:
//         controller.staffLists.sort(
//           (
//             staffListItem1,
//             staffListItem2,
//           ) =>
//               compare(
//             ascending,
//             staffListItem1.jobTitle,
//             staffListItem2.jobTitle,
//           ),
//         );
//         break;
//       case 8:
//         controller.staffLists.sort((
//           staffListItem1,
//           staffListItem2,
//         ) =>
//             compare(
//               ascending,
//               staffListItem1.email,
//               staffListItem2.email,
//             ));
//         break;
//       case 9:
//         controller.staffLists.sort((
//           staffListItem1,
//           staffListItem2,
//         ) =>
//             compare(
//               ascending,
//               staffListItem1.company,
//               staffListItem2.company,
//             ));
//         break;
//       case 10:
//         controller.staffLists.sort((
//           staffListItem1,
//           staffListItem2,
//         ) =>
//             compare(
//               ascending,
//               staffListItem1.dateOfBirth,
//               staffListItem2.dateOfBirth,
//             ));
//         break;
//       case 11:
//         controller.staffLists.sort((
//           staffListItem1,
//           staffListItem2,
//         ) =>
//             compare(
//               ascending,
//               staffListItem1.homeAddress,
//               staffListItem2.homeAddress,
//             ));
//         break;
//       case 12:
//         controller.staffLists.sort((
//           staffListItem1,
//           staffListItem2,
//         ) =>
//             compare(
//               ascending,
//               staffListItem1.startDate,
//               staffListItem2.startDate,
//             ));
//         break;
//       case 13:
//         controller.staffLists.sort((
//           staffListItem1,
//           staffListItem2,
//         ) =>
//             compare(
//               ascending,
//               staffListItem1.currentPlace,
//               staffListItem2.currentPlace,
//             ));
//         break;
//       case 14:
//         controller.staffLists.sort((
//           staffListItem1,
//           staffListItem2,
//         ) =>
//             compare(
//               ascending,
//               staffListItem1.contractFinishDate,
//               staffListItem2.contractFinishDate,
//             ));
//         break;
//       case 15:
//         controller.staffLists.sort((
//           staffListItem1,
//           staffListItem2,
//         ) =>
//             compare(
//               ascending,
//               staffListItem1.contact,
//               staffListItem2.contact,
//             ));
//         break;
//       case 16:
//         controller.staffLists.sort((
//           staffListItem1,
//           staffListItem2,
//         ) =>
//             compare(
//               ascending,
//               staffListItem1.emergencyContact,
//               staffListItem2.emergencyContact,
//             ));
//         break;
//       case 17:
//         controller.staffLists.sort((
//           staffListItem1,
//           staffListItem2,
//         ) =>
//             compare(
//               ascending,
//               staffListItem1.emergencyContactName,
//               staffListItem2.emergencyContactName,
//             ));
//         break;
//       case 18:
//         controller.staffLists.sort((
//           staffListItem1,
//           staffListItem2,
//         ) =>
//             compare(
//               ascending,
//               staffListItem1.note,
//               staffListItem2.note,
//             ));
//         break;
//     }

//     controller.sortColumnIndex.value = columnIndex;
//     controller.sortAscending.value = ascending;
//   }

//   int compare(
//     bool ascending,
//     dynamic value1,
//     dynamic value2,
//   ) =>
//       ascending ? value1.compareTo(value2) : value2.compareTo(value1);
// }