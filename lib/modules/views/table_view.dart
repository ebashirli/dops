import 'package:dops/components/select_item_snackbar.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/modules/models/view_model.dart';
import 'package:dops/routes/app_pages.dart';
import 'package:expendable_fab/expendable_fab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recase/recase.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../components/custom_widgets.dart';

class TableViewWidget extends StatelessWidget {
  TableViewWidget({Key? key}) : super(key: key);

  final ViewModel tableViewModel = homeController.currentViewModel.value;

  DataSource get dataSource => DataSource(tableViewModel: tableViewModel);

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
    return staffController.isCoordinator &&
            !homeController.currentViewModel.value.isMonitoring
        ? tableViewModel.tableName == 'task'
            ? expandableFab()
            : fab()
        : null;
  }

  FloatingActionButton fab() {
    return FloatingActionButton(
      onPressed: onUpdatePressed,
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
        : colNames
            .map(
              (colName) => GridColumn(
                columnWidthMode: ColumnWidthMode.auto,
                maximumWidth: colName == 'Drawing Number'
                    ? 220
                    : ['id', 'parentId'].contains(colName)
                        ? 0
                        : double.nan,
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
              ),
            )
            .toList();
  }
}

List<DataGridRow> _data = [];
ViewModel? _tableViewModel = null;

class DataSource extends DataGridSource {
  DataSource({required ViewModel tableViewModel}) {
    _tableViewModel = tableViewModel;
    _data = tableViewModel.controller?.tableData
            .map<DataGridRow>((map) => DataGridRow(
                cells: map!.entries
                    .map((entry) => DataGridCell<dynamic>(
                        columnName: entry.key, value: entry.value))
                    .toList()))
            .toList() ??
        [];
  }

  @override
  List<DataGridRow> get rows => _data;

  ViewModel? get tableViewModel => _tableViewModel;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      color: tableViewModel?.controller?.getRowColor(row),
      cells: getCellsWidgets(row),
    );
  }

  List<Widget> getCellsWidgets(DataGridRow row) {
    final String? id = row.getCells().first.value;

    return row
        .getCells()
        .map<Widget>(
          (cell) => Container(
            alignment: Alignment.center,
            child: CellWidget(
                child: tableViewModel?.controller?.getCellWidget(cell, id)),
          ),
        )
        .toList();
  }
}

class CellWidget extends StatelessWidget {
  final Widget? child;

  const CellWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) => child ?? SizedBox();
}
