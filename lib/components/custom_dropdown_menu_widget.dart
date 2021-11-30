import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class CustomDropdownMenu extends StatelessWidget {
  final List<dynamic> items;
  final void Function(dynamic) onChanged;
  final String labelText;
  final List<String> selectedItems;
  final double? width;
  final bool isMultiSelectable;
  final bool showSearchBox;

  CustomDropdownMenu({
    Key? key,
    required this.labelText,
    required this.onChanged,
    required this.selectedItems,
    this.width,
    required this.items,
    this.isMultiSelectable = false,
    this.showSearchBox = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: isMultiSelectable
                ? DropdownSearch<String>.multiSelection(
                    selectedItems: selectedItems,
                    showSearchBox: showSearchBox,
                    maxHeight: items.length < 3
                        ? 150
                        : items.length < 10
                            ? items.length * 50
                            : 250,
                    dropdownSearchDecoration: InputDecoration(
                      labelText: labelText,
                      contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    mode: Mode.MENU,
                    showSelectedItems: false,
                    items: items
                        .map((e) => e is List ? e[1].toString() : e.toString())
                        .toList(),
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
                  )
                : DropdownSearch<String>(
                    selectedItem: selectedItems[0],
                    showSearchBox: showSearchBox,
                    maxHeight: items.length < 10 ? items.length * 50 : 250,
                    mode: Mode.MENU,
                    items: items
                        .map((e) => e is List ? e[1].toString() : e.toString())
                        .toList(),
                    dropdownSearchDecoration: InputDecoration(
                      labelText: labelText,
                      contentPadding: EdgeInsets.only(left: 10),
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
