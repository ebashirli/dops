import 'package:dops/components/custom_multiselect_dropdown_menu_widget.dart';
import 'package:flutter/material.dart';

class CustomExpansionPanelBody extends StatelessWidget {
  CustomExpansionPanelBody({
    Key? key,
    required items,
  }) : super(key: key);

  // final String labelText;
  // final DateTime? initialValue;
  // final dynamic Function(DateTime value)? onDateSelected;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Column(
        children: <Widget>[
          CustomMultiselectDropdownMenu(
            labelText: 'Design Drawing',
            items: items,
            onChanged: (values) => staffList = values,
            selectedItems: staffList,
          ),
        ],
      ),
    );
  }
}
