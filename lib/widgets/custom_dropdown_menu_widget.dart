import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:dops/constants/lists.dart';

// ignore: must_be_immutable
class CustomDropdownMenu extends StatelessWidget {
  late String labelText;
  final dynamic Function(String?)? onChanged;
  final String? selectedItem;
  final double? width;

  CustomDropdownMenu({
    Key? key,
    required this.labelText,
    required this.onChanged,
    this.selectedItem,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: Column(
        children: [
          Padding(
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
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
