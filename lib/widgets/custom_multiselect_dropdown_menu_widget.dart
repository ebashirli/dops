import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomMultiselectDropdownMenu extends StatelessWidget {
  late List<String> items;
  final void Function(List<String>) onChanged;
  final String hint;

  CustomMultiselectDropdownMenu({
    Key? key,
    required this.onChanged,
    required this.items,
    required this.hint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>.multiSelection(
      validator: (List<String>? v) {
        return v == null || v.isEmpty ? "required field" : null;
      },
      dropdownSearchDecoration: InputDecoration(
        hintText: "Select a ${hint.toLowerCase()}",
        labelText: hint,
        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
        border: OutlineInputBorder(),
      ),
      mode: Mode.MENU,
      showSelectedItems: false,
      items: items,
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
    );
  }
}
