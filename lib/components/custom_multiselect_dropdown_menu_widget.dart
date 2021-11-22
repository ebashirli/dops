import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomMultiselectDropdownMenu extends StatelessWidget {
  late List<dynamic> items;
  final void Function(List<String>) onChanged;
  final String labelText;
  final List<String> selectedItems;
  final double? width;

  CustomMultiselectDropdownMenu({
    Key? key,
    required this.onChanged,
    required this.items,
    required this.labelText,
    required this.selectedItems,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownSearch<String>.multiSelection(
          selectedItems: selectedItems,
          validator: (List<String>? v) {
            return v == null || v.isEmpty ? "required field" : null;
          },
          dropdownSearchDecoration: InputDecoration(
            labelText: labelText,
            contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
            border: OutlineInputBorder(),
          ),
          mode: Mode.MENU,
          showSelectedItems: false,
          items: items.map((e) => e.toString()).toList(),
          maxHeight: items.length * 50,
          showClearButton: true,
          onChanged: onChanged,
          popupSelectionWidget: (
            cnt,
            String item,
            bool isSelected,
          ) {
            return isSelected
                ? Icon(
                    Icons.check_circle,
                    color: Colors.green[500],
                  )
                : Container();
          },
          clearButtonSplashRadius: 20,
        ),
        SizedBox(height: 10)
      ],
    );
  }
}
