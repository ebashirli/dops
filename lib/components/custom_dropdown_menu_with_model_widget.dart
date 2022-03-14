import 'package:dropdown_search2/dropdown_search2.dart';
import 'package:flutter/material.dart';

class CustomDropdownMenuWithModel<T> extends StatelessWidget {
  final List<T>? items;
  final void Function(List<T?>) onChanged;
  final String Function(T?) itemAsString;
  final List<T?> selectedItems;
  final bool isMultiselection;
  final String labelText;
  final bool showSearchBox;
  final Widget Function(BuildContext)? clearButtonBuilder;
  final bool showClearButton;
  final double? width;
  final double? height;
  final bool enabled;

  CustomDropdownMenuWithModel({
    Key? key,
    this.items,
    required this.selectedItems,
    required this.onChanged,
    required this.itemAsString,
    required this.labelText,
    this.isMultiselection = false,
    this.showSearchBox = true,
    this.showClearButton = false,
    this.clearButtonBuilder,
    this.width = 350,
    this.height = 50,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: !isMultiselection
          ? DropdownSearch<T>(
              enabled: enabled,
              selectedItem: selectedItems.isNotEmpty ? selectedItems[0] : null,
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
              clearButtonBuilder: clearButtonBuilder,
              showClearButton: showClearButton,
            )
          : DropdownSearch<T?>.multiSelection(
              enabled: enabled,
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
              onChange: onChanged,
            ),
    );
  }
}
