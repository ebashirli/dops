import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class CustomDropdownMenu extends StatelessWidget {
  final List<dynamic> items;
  final dynamic Function(String?)? onChanged;
  final String labelText;
  final String? selectedItem;
  final double? width;

  CustomDropdownMenu({
    Key? key,
    required this.labelText,
    required this.onChanged,
    this.selectedItem,
    this.width,
    required this.items,
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
              maxHeight: items.length < 10 ? items.length * 50 : 250,
              mode: Mode.MENU,
              items: items.map((e) => e.toString()).toList(),
              
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
