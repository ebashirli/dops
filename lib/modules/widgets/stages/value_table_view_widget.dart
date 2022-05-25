import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/constants/lists.dart';
import 'package:dops/modules/models/value_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recase/recase.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:collection/collection.dart';

class ValueTableView extends StatelessWidget {
  final int index;
  final List<ValueModel?>? valueModelsOfStage;

  ValueTableView({
    Key? key,
    required this.index,
    required this.valueModelsOfStage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> tableColumns = <String>[
      ...valueTableCommonColumnHeadList.sublist(0, 4),
      ...stageDetailsList[index]['form fields'],
      if (stageDetailsList[index]['comment'] != null) 'Is Commented',
      if (stageDetailsList[index]['file names'] != null) 'File Names',
      valueTableCommonColumnHeadList[4],
      valueTableCommonColumnHeadList[5],
    ];
    final DataSource dataSource = DataSource(
      data: getDataSourceData(tableColumns),
      index: index,
      valueModelsOfStage: valueModelsOfStage!,
    );
    final columnsWithTotal = ['Weight', 'GAS', 'SFD', 'DTL', 'File Names']
        .toSet()
        .intersection(stageDetailsList[index]['form fields'].toSet());
    if (stageDetailsList[index]['file names'] != null) {
      columnsWithTotal.add('File Names');
    }

    final DataGridController _dataGridController = DataGridController();
    return valueModelsOfStage == null || valueModelsOfStage!.isEmpty
        ? SizedBox.shrink()
        : Obx(
            () {
              if (valueController.documents.isEmpty) {
                return CircularProgressIndicator();
              } else {
                List<GridColumn> gridColumns = getColumns(tableColumns);

                return Column(
                  children: [
                    Divider(),
                    Container(
                      height: (valueModelsOfStage!.length + 1) * 100,
                      padding: const EdgeInsets.all(10.0),
                      child: SfDataGrid(
                        isScrollbarAlwaysShown: false,
                        source: dataSource,
                        columnWidthMode: ColumnWidthMode.fill,
                        tableSummaryRows: getTableSummaryRows(columnsWithTotal),
                        columns: gridColumns,
                        gridLinesVisibility: GridLinesVisibility.both,
                        headerGridLinesVisibility: GridLinesVisibility.both,
                        // allowSorting: true,
                        rowHeight: 60,
                        controller: _dataGridController,
                        selectionMode: SelectionMode.singleDeselect,
                        navigationMode: GridNavigationMode.row,
                      ),
                    ),
                  ],
                );
              }
            },
          );
  }

  List<GridTableSummaryRow> getTableSummaryRows(Set<String> columnsWithTotal) {
    return columnsWithTotal.isEmpty
        ? []
        : [
            GridTableSummaryRow(
              showSummaryInRow: false,
              title: 'Total:',
              titleColumnSpan: 1,
              columns: columnsWithTotal
                  .map(
                    (columnName) => GridSummaryColumn(
                      name: 'Sum',
                      columnName: columnName,
                      summaryType: GridSummaryType.sum,
                    ),
                  )
                  .toList(),
              position: GridTableSummaryRowPosition.bottom,
            ),
          ];
  }

  List<Map<String, dynamic>> getDataSourceData(List<String> tableColumns) {
    return valueModelsOfStage!.map((ValueModel? valueModel) {
      late Map<String, dynamic> map = {};
      tableColumns.forEach((columHead) {
        map[columHead] = valueModel!.toMap()[ReCase(columHead).camelCase];
      });

      if (stageDetailsList[index]['file names'] != null) {
        map['File Names'] = valueModel?.toMap()['fileNames']?.length;
      }

      map['id'] = valueModel!.id;

      return map;
    }).toList();
  }

  List<GridColumn> getColumns(List<String> colNames) {
    return colNames.map(
      (columnName) {
        switch (columnName) {
          case 'stageId':
          case 'id':
            return GridColumn(
              columnName: columnName,
              width: 0,
              label: CustomText(columnName),
            );

          default:
            return GridColumn(
              columnName: columnName,
              autoFitPadding: const EdgeInsets.all(8.0),
              label: Center(
                child: Container(
                  decoration: BoxDecoration(),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomText(
                      columnName == 'Employee Id'
                          ? 'Employee'
                          : columnName == 'File Names'
                              ? 'Files'
                              : columnName == 'Is Commented'
                                  ? 'Comment'
                                  : columnName == 'HOLD'
                                      ? 'Hold Reason'
                                      : columnName == 'transmittal'
                                          ? 'Transmittal number'
                                          : columnName,
                      style: TextStyle(fontWeight: FontWeight.bold),
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
  final int index;
  final List<ValueModel?> valueModelsOfStage;

  DataSource({
    required List<Map<String, dynamic>> data,
    required this.index,
    required this.valueModelsOfStage,
  }) {
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
  Widget? buildTableSummaryCellWidget(
    GridTableSummaryRow summaryRow,
    GridSummaryColumn? summaryColumn,
    RowColumnIndex rowColumnIndex,
    String summaryValue,
  ) {
    List<String?> fileNames = valueModelsOfStage
        .map((e) => e?.fileNames ?? [])
        .reduce((a, b) => a + b);
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Center(
        child: summaryColumn?.columnName == 'File Names'
            ? TextButton(
                onPressed: fileNames.isNotEmpty
                    ? () => homeController.getDialog(
                          barrierDismissible: true,
                          title: 'Files',
                          content: getFilesDialogContent(
                            fileNames,
                            valueModelIds:
                                valueModelsOfStage.map((e) => e?.id).toList(),
                          ),
                        )
                    : null,
                child: Text(
                  summaryValue,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            : CustomText(
                summaryValue,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final List<String?>? fileNames = valueModelsOfStage.isNotEmpty
        ? valueModelsOfStage
            .singleWhereOrNull(
                (ValueModel? e) => e!.id == row.getCells()[0].value)!
            .fileNames
        : null;
    final String? valueModelId = row.getCells()[0].value;

    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>(
        (cell) {
          DateTime? dateTimeCellValue = null;
          if (cell.value is DateTime) dateTimeCellValue = cell.value;

          if (cell.columnName == 'File Names') {
            return Center(
              child: fileNames != null
                  ? TextButton(
                      key: Key('Files' + valueModelId!),
                      onPressed: cell.value != 0
                          ? () => homeController.getDialog(
                                barrierDismissible: true,
                                title: 'Files',
                                content: getFilesDialogContent(
                                  valueController
                                          .getById(valueModelId)
                                          ?.fileNames ??
                                      [],
                                  valueModelId: valueModelId,
                                ),
                              )
                          : null,
                      child: Text(cell.value.toString()),
                    )
                  : SizedBox(),
            );
          } else {
            final cellValue = ['Employee Id', 'Assigned by']
                    .contains(cell.columnName)
                ? staffController.getStaffInitialById(cell.value)
                : cell.value is DateTime
                    ? dateTimeCellValue!
                        .toDMYhm() //'${cell.value.day}/${cell.value.month}/${cell.value.year} ${cell.value.hour}:${cell.value.minute}'
                    : cell.value ?? '';
            return Container(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomText(cellValue.toString()),
              ),
            );
          }
        },
      ).toList(),
    );
  }
}
