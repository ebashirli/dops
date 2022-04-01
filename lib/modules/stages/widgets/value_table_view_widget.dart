import 'package:dops/constants/constant.dart';
import 'package:dops/constants/lists.dart';
import 'package:dops/modules/issue/issue_model.dart';
import 'package:dops/modules/values/value_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recase/recase.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ValueTableView extends StatelessWidget {
  final int index;
  final List<ValueModel?>? stageValueModelsList;

  ValueTableView({
    Key? key,
    required this.index,
    required this.stageValueModelsList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> tableColumns = <String>[
      ...valueTableCommonColumnHeadList.sublist(0, 4),
      ...stageDetailsList[index]['form fields'],
      if (stageDetailsList[index]['file names'] != null) 'File Names',
      if (stageDetailsList[index]['comment'] != null) 'Is Commented',
      valueTableCommonColumnHeadList[4],
      if (index == 8) valueTableCommonColumnHeadList[6],
      valueTableCommonColumnHeadList[5],
    ];
    final DataSource dataSource = DataSource(
      data: getDataSourceData(tableColumns),
      index: index,
      stageValueModelsList: stageValueModelsList!,
    );
    final columnsWithTotal = ['Weight', 'GAS', 'SFD', 'DTL', 'File Names']
        .toSet()
        .intersection(stageDetailsList[index]['form fields'].toSet());
    final DataGridController _dataGridController = DataGridController();
    return stageValueModelsList == null || stageValueModelsList!.isEmpty
        ? SizedBox.shrink()
        : Obx(
            () {
              if (valueController.documents.isEmpty) {
                return CircularProgressIndicator();
              } else {
                return Column(
                  children: [
                    Divider(),
                    Container(
                      height: (stageValueModelsList!.length + 1) * 100,
                      padding: const EdgeInsets.all(10.0),
                      child: SfDataGrid(
                        isScrollbarAlwaysShown: false,
                        source: dataSource,
                        columnWidthMode: ColumnWidthMode.fill,
                        tableSummaryRows: columnsWithTotal.isEmpty
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
                              ],
                        columns: getColumns(tableColumns),
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

  List<Map<String, dynamic>> getDataSourceData(List<String> tableColumns) {
    return stageValueModelsList!.map((valueModel) {
      late Map<String, dynamic> map = {};
      tableColumns.forEach((columHead) {
        map[columHead] = valueModel!.toMap()[ReCase(columHead).camelCase];
      });
      if (tableColumns.contains('Group') &&
          issueController.documents.isNotEmpty) {
        List<IssueModel?> issueModelList = issueController.documents
            .where(
              (e) =>
                  e.linkedTasks.contains(stageController.currentTask!.id) &&
                  e.createdBy == valueModel!.employeeId,
            )
            .toList();
        map['Group'] = issueModelList.isNotEmpty
            ? issueModelList.first!.groupNumber
            : null;
        map['linkingToGroupDateTime'] = valueModel!.linkingToGroupDateTime;
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
              label: Text(
                columnName,
              ),
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
                    child: Text(
                      columnName == 'Employee Id'
                          ? 'Employee'
                          : columnName == 'File Names'
                              ? 'Files'
                              : columnName == 'Is Commented'
                                  ? 'Comment'
                                  : columnName == 'HOLD'
                                      ? 'Hold Reason'
                                      : columnName == 'linkingToGroupDateTime'
                                          ? 'Linking date time'
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
  final List<ValueModel?> stageValueModelsList;

  DataSource({
    required List<Map<String, dynamic>> data,
    required this.index,
    required this.stageValueModelsList,
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
    return (summaryColumn != null && summaryColumn.columnName == 'File Names')
        ? Container(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: TextButton(
                onPressed: () {
                  stageValueModelsList.forEach((e) {
                    if (e!.fileNames != null) print(e.fileNames);
                  });
                },
                child: Text(
                  summaryValue,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
        : Container(
            padding: const EdgeInsets.all(15.0),
            child: Center(
                child: Text(
              summaryValue,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            )),
          );
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final List<String>? fileNames = stageValueModelsList
        .singleWhere((e) => e!.id == row.getCells()[0].value)!
        .fileNames;

    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>(
        (cell) {

          if (cell.columnName == 'File Names') {
            return Center(
              child: fileNames != null
                  ? TextButton(
                      onPressed: cell.value.isNotEmpty
                          ? () => filesDialog(cell.value)
                          : null,
                      child: Text(cell.value.length.toString()),
                    )
                  : SizedBox(),
            );
          } else {
            final cellValue = ['Employee Id', 'Assigned by']
                    .contains(cell.columnName)
                ? staffController.documents
                    .singleWhere((e) => e.id == cell.value)
                    .initial
                : cell.value is DateTime
                    ? '${cell.value.day}/${cell.value.month}/${cell.value.year} ${cell.value.hour}:${cell.value.minute}'
                    : cell.value ?? '';
            return Container(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(cellValue.toString()),
              ),
            );
          }
        },
      ).toList(),
    );
  }
}
