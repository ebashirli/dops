import 'package:data_table_2/data_table_2.dart';
import 'package:date_field/date_field.dart';
import 'package:dops/constants/lists.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:dops/constants/table_details.dart';
import 'package:dops/models/reference_document_model.dart';
import '../constants/style.dart';
import '../controllers/reference_document_controller.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ReferenceDocumentView extends GetView<ReferenceDocumentController> {
  String moduleNameText = '';
  String projectText = '';
  String referenceTypeText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reference Documents'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _buildAddEditReferenceDocumentView(
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
            columns: getColumns(referenceDocumentTableColumnNames),
            rows: getRows(controller.referenceDocuments),
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

  _buildAddEditReferenceDocumentView({String? text, int? addEditFlag, String? docId}) {
    Get.defaultDialog(
      barrierDismissible: false,
      onCancel: () => Get.back(),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: Text('Cancel'),
      ),
      title: '$text Reference Document',
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
            key: controller.referenceDocumentFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _dropdownSearch(
                    lists['Project']!,
                    'Project',
                    50,
                    onChanged: (value) {
                      projectText = value??'-';
                    },
                  ),
                  _dropdownSearch(
                    lists['Reference type']!,
                    'Reference type',
                    50 * 5,
                    onChanged: (value) {
                     referenceTypeText = value??'-';
                    },
                  ),
                  _dropdownSearch(
                    lists['Module']!,
                    'Module name',
                    50 * 4,
                    onChanged: (value) {
                      moduleNameText = value??'-';
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Document number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    controller: controller.docNoController,
                    validator: (value) {
                      return controller.validateName(value!);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: 'Revision Code',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    controller: controller.revCodeController,
                    validator: (value) {
                      return controller.validateAddress(value!);
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    controller: controller.titleController,
                    validator: (value) {
                      return controller.validateName(value!);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Transmittal number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    controller: controller.transmittalNoController,
                    validator: (value) {
                      return controller.validateName(value!);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DateTimeFormField(
                    mode: DateTimeFieldPickerMode.date,
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(color: Colors.black45),
                      errorStyle: TextStyle(color: Colors.redAccent),
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.event_note),
                      labelText: 'Received Date',
                    ),
                    firstDate: DateTime.now().add(const Duration(days: 10)),
                    initialDate: DateTime.now().add(const Duration(days: 10)),
                    autovalidateMode: AutovalidateMode.always,
                    validator: (DateTime? e) => (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                    onDateSelected: (DateTime value) {
                      controller.receiveDateController = value;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Action Required / Next',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    controller: controller.actionRequiredNextController,
                    validator: (value) {
                      return controller.validateName(value!);
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
                        controller.saveUpdateReferenceDocument(
                          docId!,
                          projectText,
                          referenceTypeText,
                          moduleNameText,
                          controller.docNoController.text,
                          controller.revCodeController.text,
                          controller.titleController.text,
                          controller.transmittalNoController.text,
                          controller.receiveDateController,
                          controller.actionRequiredNextController.text,
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

  Widget _dropdownSearch(List<String> itemsList, String hintText, double maxHeight,
      {dynamic Function(String?)? onChanged}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: DropdownSearch<String>(
        maxHeight: maxHeight,
        mode: Mode.MENU,
        items: itemsList,
        dropdownSearchDecoration: InputDecoration(
          hintText: hintText,
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
      title: "Delete Reference Document",
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

  List<DataColumn2> getColumns(List<String> columns) => columns.map((String column) {
        return DataColumn2(
          label: Text(column),
          onSort: onSort,
        );
      }).toList();

  List<DataRow2> getRows(List<ReferenceDocumentModel> referenceDocuments) =>
      referenceDocuments.map((ReferenceDocumentModel referenceDocument) {
        // print('==========${referenceDocument.toMap()} =========');
        final map = referenceDocument.toMap();
        List cells = map.values.toList();
        cells = cells.sublist(1, cells.length);
        return DataRow2(
          cells: getCells(cells),
        );
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) => cells.map((data) {
        return DataCell(
          Text(data is DateTime ? '${data.month}/${data.day}/${data.year}' : data ?? ''),
        );
      }).toList();

  onSort(int columnIndex, bool ascending) {
    switch (columnIndex) {
      case 0:
        controller.referenceDocuments.sort((
          referenceDocument1,
          referenceDocument2,
        ) =>
            compare(
              ascending,
              referenceDocument1.project,
              referenceDocument2.project,
            ));
        break;
      case 1:
        controller.referenceDocuments.sort((
          referenceDocument1,
          referenceDocument2,
        ) =>
            compare(
              ascending,
              referenceDocument1.refType,
              referenceDocument2.refType,
            ));
        break;
      case 2:
        controller.referenceDocuments.sort((
          referenceDocument1,
          referenceDocument2,
        ) =>
            compare(
              ascending,
              referenceDocument1.moduleName,
              referenceDocument2.moduleName,
            ));
        break;
      case 3:
        controller.referenceDocuments.sort((
          referenceDocument1,
          referenceDocument2,
        ) =>
            compare(
              ascending,
              referenceDocument1.docNo,
              referenceDocument2.docNo,
            ));
        break;
      case 4:
        controller.referenceDocuments.sort((
          referenceDocument1,
          referenceDocument2,
        ) =>
            compare(
              ascending,
              referenceDocument1.revCode,
              referenceDocument2.revCode,
            ));
        break;
      case 5:
        controller.referenceDocuments.sort((
          referenceDocument1,
          referenceDocument2,
        ) =>
            compare(
              ascending,
              referenceDocument1.title,
              referenceDocument2.title,
            ));
        break;
      case 6:
        controller.referenceDocuments.sort((
          referenceDocument1,
          referenceDocument2,
        ) =>
            compare(
              ascending,
              referenceDocument1.transmittalNo,
              referenceDocument2.transmittalNo,
            ));
        break;
      case 7:
        controller.referenceDocuments.sort(
          (
            referenceDocument1,
            referenceDocument2,
          ) =>
              compare(
            ascending,
            referenceDocument1.receiveDate,
            referenceDocument2.receiveDate,
          ),
        );
        break;
      case 8:
        controller.referenceDocuments.sort((
          referenceDocument1,
          referenceDocument2,
        ) =>
            compare(
              ascending,
              referenceDocument1.actionRequiredNext,
              referenceDocument2.actionRequiredNext,
            ));
        break;
      case 9:
        controller.referenceDocuments.sort((
          referenceDocument1,
          referenceDocument2,
        ) =>
            compare(
              ascending,
              referenceDocument1.assignedDocsCount,
              referenceDocument2.assignedDocsCount,
            ));
        break;
    }

    controller.sortColumnIndex.value = columnIndex;
    controller.sortAscending.value = ascending;
  }

  int compare(
    bool ascending,
    dynamic value1,
    dynamic value2,
  ) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);
}
