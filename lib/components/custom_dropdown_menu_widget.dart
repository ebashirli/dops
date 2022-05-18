import 'package:dropdown_search2/dropdown_search2.dart';
import 'package:flutter/material.dart';

class CustomDropdownMenuWithModel<T> extends StatelessWidget {
  final List<T>? items;
  final void Function(List<T?>) onChanged;
  final String? Function(List<T?>?)? validator;
  final String Function(T?) itemAsString;
  final List<T?> selectedItems;
  final bool isMultiSelectable;
  final String labelText;
  final bool showSearchBox;
  final Widget Function(BuildContext)? clearButtonBuilder;
  final bool showClearButton;
  final double? width;
  final double? height;
  final bool enabled;
  final AutovalidateMode? autoValidateMode;

  CustomDropdownMenuWithModel({
    Key? key,
    this.items,
    required this.selectedItems,
    required this.onChanged,
    required this.itemAsString,
    required this.labelText,
    this.validator,
    this.isMultiSelectable = false,
    this.showSearchBox = true,
    this.showClearButton = false,
    this.clearButtonBuilder,
    this.width = 350,
    this.height,
    this.enabled = true,
    this.autoValidateMode = AutovalidateMode.disabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: !isMultiSelectable
          ? DropdownSearch<T>(
              autoValidateMode: autoValidateMode,
              validator:
                  validator == null ? null : (value) => validator!([value]),
              dropdownButtonSplashRadius: 10,
              enabled: enabled,
              selectedItem: selectedItems.isNotEmpty ? selectedItems[0] : null,
              items: items,
              itemAsString: itemAsString,
              mode: Mode.MENU,
              dropdownSearchDecoration: InputDecoration(
                hoverColor: Colors.transparent,
                isDense: true,
                labelText: labelText,
                contentPadding: EdgeInsets.fromLTRB(10, 2, 10, 2),
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
              autoValidateMode: autoValidateMode,
              validator: validator,
              dropdownButtonSplashRadius: 10,
              enabled: enabled,
              selectedItems: selectedItems,
              items: items,
              itemAsString: itemAsString,
              mode: Mode.MENU,
              dropdownSearchDecoration: InputDecoration(
                hoverColor: Colors.transparent,
                isDense: true,
                labelText: labelText,
                contentPadding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                border: OutlineInputBorder(),
              ),
              showSearchBox: true,
              onChange: onChanged,
            ),
    );
  }
}
