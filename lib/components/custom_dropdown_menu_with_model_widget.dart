import 'package:dops/constants/constant.dart';
import 'package:dops/constants/lists.dart';
import 'package:dops/modules/staff/staff_model.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class CustomDropdownMenuWithModel extends StatelessWidget {
  final int index;

  CustomDropdownMenuWithModel({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      child: [0, 6, 7].contains(index)
          ? DropdownSearch<StaffModel>(
              selectedItem:
                  stageController.assigningEmployeeIdsList[index].isNotEmpty
                      ? staffController.documents.firstWhere((staffModel) =>
                          staffModel.id ==
                          stageController.assigningEmployeeIdsList[index][0])
                      : null,
              items: staffController.documents,
              itemAsString: (StaffModel? item) =>
                  '${item!.name} ${item.surname}',
              mode: Mode.MENU,
              dropdownSearchDecoration: InputDecoration(
                labelText: stageDetailsList[index]['staff job'],
                contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                border: OutlineInputBorder(),
              ),
              showSearchBox: true,
              onChanged: (employee) {
                stageController.assigningEmployeeIdsList[index] = [
                  employee!.id!
                ];
              },
            )
          : DropdownSearch<StaffModel>.multiSelection(
              selectedItems: staffController.documents
                  .where((element) => stageController
                      .assigningEmployeeIdsList[index]
                      .contains(element.id))
                  .toList(),
              items: staffController.documents,
              itemAsString: (StaffModel? employee) =>
                  '${employee!.name} ${employee.surname}',
              mode: Mode.MENU,
              dropdownSearchDecoration: InputDecoration(
                labelText: stageDetailsList[index]['staff job'],
                contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                border: OutlineInputBorder(),
              ),
              showSearchBox: true,
              onChanged: (employees) {
                stageController.assigningEmployeeIdsList[index] =
                    employees.map((employee) => employee.id!).toList();
              },
            ),
    );
  }
}
