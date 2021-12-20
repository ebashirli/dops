import 'package:dops/constants/constant.dart';
import 'package:dops/constants/lists.dart';
import 'package:dops/modules/values/value_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recase/recase.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'custom_widgets.dart';

class ValueTableView extends StatelessWidget {
  final int index;
  final List<ValueModel?> stageValueModelsList;

  ValueTableView({
    Key? key,
    required this.index,
    required this.stageValueModelsList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (valueController.documents.isEmpty) {
          return CircularProgressIndicator();
        } else {
          final List<String> tableColumns = [
            ...valueTableColumnHeadList.sublist(0, 3),
            ...stageDetailsList1[index]['columns'],
            ...valueTableColumnHeadList.sublist(3),
          ];
          final DataSource dataSource = DataSource(
            data: stageValueModelsList.map((valueModel) {
              late Map<String, dynamic> map = {};
              tableColumns.forEach((columHead) {
                map[columHead] =
                    valueModel!.toMap()[ReCase(columHead).camelCase];
              });
              map['id'] = valueModel!.id;
              return map;
            }).toList(),
          );

          final columnsWithTotal = ['Weight', 'GAS', 'SFD', 'DTL']
              .toSet()
              .intersection(stageDetailsList1[index]['columns'].toSet());
          print(columnsWithTotal);

          final DataGridController _dataGridController = DataGridController();

          return Padding(
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
                          position: GridTableSummaryRowPosition.bottom),
                    ],
              columns: getColumns(tableColumns),
              gridLinesVisibility: GridLinesVisibility.both,
              headerGridLinesVisibility: GridLinesVisibility.both,
              // allowSorting: true,
              rowHeight: 70,
              controller: _dataGridController,
              selectionMode: SelectionMode.singleDeselect,
              navigationMode: GridNavigationMode.row,
            ),
          );
        }
      },
    );
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
                      columnName == 'Employee Id' ? 'Employee' : columnName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
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
  DataSource({required List<Map<String, dynamic>> data}) {
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
  ) =>
      Container(
        padding: const EdgeInsets.all(15.0),
        child: Center(
            child: Text(
          summaryValue,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        )),
      );

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final bool isImputForm = row.getCells()[2].value == auth.currentUser!.uid &&
        row
                .getCells()
                .singleWhere((element) => element.columnName == 'End date time')
                .value ==
            null;
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>(
        (cell) {
          if (['Weight', 'Phase', 'GAS', 'SFD', 'DTL', 'Files', 'Note']
                  .contains(cell.columnName) &&
              isImputForm) {
            switch (cell.columnName) {
              case 'Files':
                return Container(
                  height: 48,
                  width: 80,
                  child: Center(
                    child: Text('Browse files'),
                  ),
                );
              case 'Note':
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: CustomTextFormField(
                      sizeBoxHeight: 0,
                      // controller: controllersListForNote[index],
                      // labelText: stageDetailsList[index]['string fields'][0],
                      width: double.infinity,
                      maxLines: 2,
                    ),
                  ),
                );

              default:
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: CustomTextFormField(
                      sizeBoxHeight: 0,
                      isNumber: true,
                      controller: stageController
                          .controllersListForNumberFields[2]![cell.columnName],
                      width: 80,
                    ),
                  ),
                );
            }
          } else {
            final cellValue = ['Employee Id', 'Assigned by']
                    .contains(cell.columnName)
                ? staffController.documents
                    .singleWhere((staff) => staff.id == cell.value)
                    .initial
                : cell.value is DateTime
                    ? '${cell.value.day}/${cell.value.month}/${cell.value.year} ${cell.value.hour}:${cell.value.minute}'
                    : cell.value.toString();
            return Container(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(cellValue),
              ),
            );
          }
        },
      ).toList(),
    );
  }
}
