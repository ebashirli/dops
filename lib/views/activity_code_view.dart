import 'package:data_table_2/data_table_2.dart';
import 'package:date_field/date_field.dart';
import 'package:dops/constants/lists.dart';
import 'package:dops/controllers/activity_code_controller.dart';
import 'package:dops/models/activity_codes_model.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:dops/constants/table_details.dart';
import 'package:flutter/services.dart';
import '../constants/style.dart';
import 'package:get/get.dart';

class ActivityCodeView extends GetView<ActivityCodeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Codes'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _buildAddEditActivityCodeView(
                text: 'Add',
                addEditFlag: 1,
                docId: '',
              );
            },
          )
        ],
      ),
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
            sortColumnIndex: controller.sortColumnIndex.value,
            sortAscending: controller.sortAscending.value,
          );
        },
      ),
    );
  }

  _buildAddEditActivityCodeView(
      {String? text, int? addEditFlag, String? docId}) {
    Get.defaultDialog(
      barrierDismissible: false,
      // onCancel: () => Get.back(),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: Text('Cancel'),
      ),
      title: '$text Activity Code',
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(8),
            topLeft: Radius.circular(8),
          ),
          color: light, //Color(0xff1E2746),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: controller.activityCodeFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: activityCodeTableColumnNames[0],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    controller: controller.activityIdController,
                    validator: (value) {
                      return controller.validateName(value!);
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      labelText: activityCodeTableColumnNames[1],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    controller: controller.activityNameController,
                    validator: (value) {
                      return controller.validateAddress(value!);
                    },
                  ),
                  SizedBox(height: 8),
                  _dropdownSearch(
                    modules,
                    activityCodeTableColumnNames[2],
                    50 * 4,
                    onChanged: (value) {
                      controller.dropdownFieldModel.moduleNameText = value;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                      controller: controller.prioController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      decoration: InputDecoration(
                          labelText: activityCodeTableColumnNames[3],
                          icon: Icon(Icons.phone_iphone))),
                  SizedBox(height: 10),
                  TextFormField(
                      controller: controller.coefficientController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      decoration: InputDecoration(
                          labelText: activityCodeTableColumnNames[4],
                          icon: Icon(Icons.phone_iphone))),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                      controller: controller.budgetedLaborUnitsController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      decoration: InputDecoration(
                          labelText: activityCodeTableColumnNames[5],
                          icon: Icon(Icons.format_list_numbered))),
                  SizedBox(
                    height: 10,
                  ),
                  DateTimeFormField(
                    mode: DateTimeFieldPickerMode.date,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.black45),
                      errorStyle: TextStyle(color: Colors.redAccent),
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.event_note),
                      labelText: activityCodeTableColumnNames[7],
                    ),
                    firstDate: DateTime.now().add(const Duration(days: 10)),
                    initialDate: DateTime.now().add(const Duration(days: 10)),
                    autovalidateMode: AutovalidateMode.always,
                    validator: (DateTime? e) =>
                        (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                    onDateSelected: (DateTime value) {
                      controller.startController = value;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DateTimeFormField(
                    mode: DateTimeFieldPickerMode.date,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.black45),
                      errorStyle: TextStyle(color: Colors.redAccent),
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.event_note),
                      labelText: activityCodeTableColumnNames[8],
                    ),
                    firstDate: DateTime.now().add(const Duration(days: 10)),
                    initialDate: DateTime.now().add(const Duration(days: 10)),
                    autovalidateMode: AutovalidateMode.always,
                    validator: (DateTime? e) =>
                        (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                    onDateSelected: (DateTime value) {
                      controller.finishController = value;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                      width: Get.context!.width,
                      height: 45,
                    ),
                    child: ElevatedButton(
                      child: Text(
                        text!,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () {
                        controller.saveUpdateActivityCode(
                          docId!,
                          controller.activityIdController.text,
                          controller.activityNameController.text,
                          controller.dropdownFieldModel.moduleNameText!,
                          int.parse(controller.prioController.text),
                          int.parse(controller.coefficientController.text),
                          double.parse(
                              controller.budgetedLaborUnitsController.text),
                          controller.startController,
                          controller.finishController,
                          addEditFlag!,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _dropdownSearch(
      List<String> itemsList, String labelText, double maxHeight,
      {dynamic Function(String?)? onChanged}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: DropdownSearch<String>(
        maxHeight: maxHeight,
        mode: Mode.MENU,
        items: itemsList,
        dropdownSearchDecoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onChanged: onChanged,
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
        controller.deleteData(docId);
      },
    );
  }

  List<DataColumn2> getColumns(List<String> columns) =>
      columns.map((String column) {
        return DataColumn2(
          label: Text(column),
          onSort: onSort,
        );
      }).toList();

  List<DataRow2> getRows(List<ActivityCodeModel> activityCodes) =>
      activityCodes.map((ActivityCodeModel activityCode) {
        final map = activityCode.toMap();
        List cells = map.values.toList();
        cells = cells.sublist(1, cells.length);
        return DataRow2(
          cells: getCells(cells),
        );
      }).toList();

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
