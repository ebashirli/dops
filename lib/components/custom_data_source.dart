import 'package:dops/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

List<DataGridRow> _data = [];

class DataSource extends DataGridSource {
  DataSource({required List data}) {
    _data = data.map<DataGridRow>(
      (model) {
        return DataGridRow(
          cells: model.toMap().entries.map(
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
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>(
        (cell) {
          return Container(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: (cell.columnName == 'assignedTasks' ||
                            cell.columnName == 'drawingNumber') &&
                        cell.value.length != 0
                    ? cell.columnName == 'drawingNumber'
                        ? TextButton(
                            child: Text('${cell.value[0]}'),
                            onPressed: () {
                              Get.toNamed(Routes.STAGES,
                                  parameters: {'id': cell.value[1]});
                            },
                          )
                        : TextButton(
                            child: Text('${cell.value.length}'),
                            onPressed: () {
                              Get.defaultDialog(
                                title: 'Assigned tasks',
                                content: Column(
                                  children: (cell.value).map<Widget>(
                                    (taskNoAndId) {
                                      return TextButton(
                                        child: Text('${taskNoAndId[0]}'),
                                        onPressed: () {
                                          Get.back();
                                          Get.toNamed(Routes.STAGES,
                                              parameters: {
                                                'id': taskNoAndId[1],
                                              });
                                        },
                                      );
                                    },
                                  ).toList(),
                                ),
                              );
                            },
                          )
                    : Text(
                        cell.value is DateTime
                            ? '${cell.value.day}/${cell.value.month}/${cell.value.year}'
                            : cell.value.toString(),
                      ),
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
