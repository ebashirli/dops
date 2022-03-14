import 'package:dropdown_search2/dropdown_search2.dart';
import 'package:flutter/material.dart';

class CustomDropdownMenu extends StatelessWidget {
  final List<dynamic> items;
  final void Function(dynamic) onChanged;
  final String? labelText;
  final List<String> selectedItems;
  final double? width;
  final bool isMultiSelectable;
  final bool enabled;
  final bool showSearchBox;
  final double sizeBoxHeight;
  final double bottomPadding;

  CustomDropdownMenu({
    Key? key,
    this.labelText,
    required this.onChanged,
    required this.selectedItems,
    this.width,
    required this.items,
    this.isMultiSelectable = false,
    this.showSearchBox = false,
    this.sizeBoxHeight = 0,
    this.bottomPadding = 0,
    bool this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: bottomPadding),
            child: isMultiSelectable
                ? DropdownSearch<String>.multiSelection(
                    enabled: enabled,
                    selectedItems: selectedItems,
                    showSearchBox: showSearchBox,
                    maxHeight: items.length < 3
                        ? 250
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
                    onChange: onChanged,
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
                    enabled: enabled,
                    selectedItem: selectedItems[0],
                    showSearchBox: showSearchBox,
                    maxHeight: items.length <= 3
                        ? items.length * 50
                        : items.length < 10
                            ? items.length * 100
                            : 250,
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
          SizedBox(height: sizeBoxHeight),
        ],
      ),
    );
  }
}
