import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:dops/constants/lists.dart';

// ignore: must_be_immutable
class CustomDropdownSearch extends StatelessWidget {
  late String labelText;
  final dynamic Function(String?)? onChanged;
  final String? selectedItem;

  CustomDropdownSearch({
    Key? key,
    required this.labelText,
    required this.onChanged,
    this.selectedItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: DropdownSearch<String>(
        selectedItem: selectedItem,
        maxHeight: listsMap[labelText]!.length * 50,
        mode: Mode.MENU,
        items: listsMap[labelText],
        dropdownSearchDecoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 10),
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
