import 'package:dops/constants/lists.dart';
import 'package:dops/controllers/dropdown_sources_controller.dart';
import 'package:dops/widgets/custom_list_items_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../enum.dart';

class DropdownSourcesView extends StatelessWidget {
  final controller = Get.find<DropdownSourcesController>();
  List<String> fieldNames = [];
  List<List<String>> values = [];

  @override
  Widget build(BuildContext context) {
     
      // controller..toMap().entries.forEach((element) {
      //   print(element.value);
      //   // fieldNames.add(element.key);
      //   // values.add(element.value as List<String>);
      // });
      return Center(
        child: ListView.separated(
          padding: EdgeInsets.zero,
          controller: ScrollController(),
          scrollDirection: Axis.horizontal,
          itemCount: 12,
          separatorBuilder: (context, index) => SizedBox(width: 12),
          itemBuilder: (context, index) {
            // print(fieldNames[index].toString());
            // print(values[index].toString());
            return Container();
            // CustomListItems(
            //   lstName: controller.document.value.toMap().entries.map((entry) => entry.key).toList()[index],
            //   lst: controller.document.value.toMap().entries.map((entry) => entry.value).toList()[index],
            // );
          },
        ),
      );
    
  }
}
