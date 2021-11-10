import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:dops/constants/table_details.dart';
import 'package:dops/models/reference_document_model.dart';
import 'package:dops/controllers/reference_document_controller.dart';

// class ReferenceDocumentView extends StatelessWidget {
//   final controller = Get.find<ReferenceDocumentController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Obx(
//         () {
//           return DataTable2(
//             columns: getColumns(referenceDocumentTableColumnNames),
//             rows: getRows(controller.referenceDocuments),
//             columnSpacing: 12,
//             horizontalMargin: 12,
//             dividerThickness: 1,
//             bottomMargin: 10,
//             minWidth: 900,
//             dataRowHeight: 40,
//             border: TableBorder(
//               horizontalInside:
//                   BorderSide(width: 0.5, color: Colors.grey[400]!),
//               verticalInside: BorderSide(width: 0.5, color: Colors.grey[400]!),
//               bottom: BorderSide(width: 0.5, color: Colors.grey[400]!),
//             ),
//             headingTextStyle: TextStyle(fontWeight: FontWeight.bold),
//             sortColumnIndex: controller.sortColumnIndex.value,
//             sortAscending: controller.sortAscending.value,
//           );
//         },
//       ),
//     );
//   }

// // TODO: ad this to delete button
//   displayDeleteDialog(String docId) {
//     Get.defaultDialog(
//       title: "Delete Reference Document",
//       titleStyle: TextStyle(fontSize: 20),
//       middleText: 'Are you sure to delete reference document?',
//       textCancel: "Cancel",
//       textConfirm: "Confirm",
//       confirmTextColor: Colors.black,
//       onCancel: () {},
//       onConfirm: () {
//         // controller.removeReferenceDocumentModel();
//       },
//     );
//   }

//   List<DataColumn2> getColumns(List<String> columns) =>
//       columns.map((String column) {
//         return DataColumn2(
//           label: Text(column),
//           onSort: onSort,
//         );
//       }).toList();

//   List<DataRow2> getRows(List<ReferenceDocumentModel> referenceDocuments) {
//     List<DataRow2> dataRows =
//         referenceDocuments.map((ReferenceDocumentModel referenceDocument) {
//       final map = referenceDocument.toMap();
//       List cells = map.values.toList();

//       return DataRow2(
//         onTap: () {
//           controller.buildAddEdit(referenceDocumentModel: referenceDocument);
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
//         controller.referenceDocuments.sort((
//           referenceDocument1,
//           referenceDocument2,
//         ) =>
//             compare(
//               ascending,
//               referenceDocument1.project,
//               referenceDocument2.project,
//             ));
//         break;
//       case 1:
//         controller.referenceDocuments.sort((
//           referenceDocument1,
//           referenceDocument2,
//         ) =>
//             compare(
//               ascending,
//               referenceDocument1.referenceType,
//               referenceDocument2.referenceType,
//             ));
//         break;
//       case 2:
//         controller.referenceDocuments.sort((
//           referenceDocument1,
//           referenceDocument2,
//         ) =>
//             compare(
//               ascending,
//               referenceDocument1.moduleName,
//               referenceDocument2.moduleName,
//             ));
//         break;
//       case 3:
//         controller.referenceDocuments.sort((
//           referenceDocument1,
//           referenceDocument2,
//         ) =>
//             compare(
//               ascending,
//               referenceDocument1.documentNumber,
//               referenceDocument2.documentNumber,
//             ));
//         break;
//       case 4:
//         controller.referenceDocuments.sort((
//           referenceDocument1,
//           referenceDocument2,
//         ) =>
//             compare(
//               ascending,
//               referenceDocument1.revisionCode,
//               referenceDocument2.revisionCode,
//             ));
//         break;
//       case 5:
//         controller.referenceDocuments.sort((
//           referenceDocument1,
//           referenceDocument2,
//         ) =>
//             compare(
//               ascending,
//               referenceDocument1.title,
//               referenceDocument2.title,
//             ));
//         break;
//       case 6:
//         controller.referenceDocuments.sort((
//           referenceDocument1,
//           referenceDocument2,
//         ) =>
//             compare(
//               ascending,
//               referenceDocument1.transmittalNumber,
//               referenceDocument2.transmittalNumber,
//             ));
//         break;
//       case 7:
//         controller.referenceDocuments.sort(
//           (
//             referenceDocument1,
//             referenceDocument2,
//           ) =>
//               compare(
//             ascending,
//             referenceDocument1.receivedDate,
//             referenceDocument2.receivedDate,
//           ),
//         );
//         break;
//       case 8:
//         controller.referenceDocuments.sort((
//           referenceDocument1,
//           referenceDocument2,
//         ) =>
//             compare(
//               ascending,
//               referenceDocument1.requiredActionNext,
//               referenceDocument2.requiredActionNext,
//             ));
//         break;
//       case 9:
//         controller.referenceDocuments.sort((
//           referenceDocument1,
//           referenceDocument2,
//         ) =>
//             compare(
//               ascending,
//               referenceDocument1.assignedDocumentsCount,
//               referenceDocument2.assignedDocumentsCount,
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

// ==========================================================================================================

class ReferenceDocumentView extends StatelessWidget {
  final controller = Get.find<ReferenceDocumentController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          final EmployeeDataSource employeeDataSource =
              EmployeeDataSource(employeeData: controller.referenceDocuments);

          return SfDataGrid(
            source: employeeDataSource,
            columns: getColumns(referenceDocumentTableColumnNames),
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
                    referenceDocumentModel: controller.referenceDocuments[
                        details.rowColumnIndex.rowIndex - 1]);
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
  EmployeeDataSource({required List<ReferenceDocumentModel> employeeData}) {
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
