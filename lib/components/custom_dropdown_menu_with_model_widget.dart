import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class CustomDropdownMenuWithModel<T> extends StatelessWidget {
  final List<T>? items;
  final void Function(List<T>) onChanged;
  final String Function(T?) itemAsString;
  final List<T> selectedItems;
  final bool isMultiselection;
  final String labelText;
  final bool showSearchBox;

  CustomDropdownMenuWithModel({
    Key? key,
    this.items,
    required this.selectedItems,
    required this.onChanged,
    required this.itemAsString,
    required this.labelText,
    this.isMultiselection = false,
    this.showSearchBox = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      child: !isMultiselection
          ? DropdownSearch<T>(
              selectedItem: selectedItems[0],
              items: items,
              itemAsString: itemAsString,
              mode: Mode.MENU,
              dropdownSearchDecoration: InputDecoration(
                labelText: labelText,
                contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                border: OutlineInputBorder(),
              ),
              showSearchBox: true,
              onChanged: (value) {
                if (value != null) onChanged([value]);
              },
            )
          : DropdownSearch<T>.multiSelection(
              selectedItems: selectedItems,
              items: items,
              itemAsString: itemAsString,
              mode: Mode.MENU,
              dropdownSearchDecoration: InputDecoration(
                labelText: labelText,
                contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                border: OutlineInputBorder(),
              ),
              showSearchBox: true,
              onChanged: onChanged,
            ),
    );
  }
}

// selectedItem: stageController.assigningEmployeeIdsList[index].isNotEmpty
//                       ? staffController.documents.firstWhere((staffModel) =>
//                           staffModel.id ==
//                           stageController.assigningEmployeeIdsList[index][0])
//                       : null,

// onChanged (employee) {
//                 stageController.assigningEmployeeIdsList[index] = [
//                   employee!.id!
//                 ];
//               },

// selectedItems: staffController.documents
//                   .where((element) => stageController
//                       .assigningEmployeeIdsList[index]
//                       .contains(element.id))
//                   .toList(),

// onChanged: (employees) {
//                 stageController.assigningEmployeeIdsList[index] =
//                     employees.map((employee) => employee.id!).toList();
//               },

// isMultiselection [0, 6, 7].contains(index)

// itemAsString: (StaffModel? item) =>
//                   '${item!.name} ${item.surname}'

// items: staffController.documents,

// labelText: stageDetailsList[index]['staff job'],
