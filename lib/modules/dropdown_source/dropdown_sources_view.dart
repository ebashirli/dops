import 'package:dops/components/custom_list_items_widget.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dropdown_sources_controller.dart';

// ignore: must_be_immutable
class DropdownSourcesView extends StatelessWidget {
  final controller = Get.find<DropdownSourcesController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 20),
      child: Center(
        child: ListView.separated(
          padding: EdgeInsets.only(left: 12, right: 12),
          controller: ScrollController(),
          scrollDirection: Axis.horizontal,
          itemCount: controller.listNames.length,
          separatorBuilder: (context, index) => SizedBox(width: 12),
          itemBuilder: (context, index) {
            return Obx(() {
              if (controller.document.value.toMap().entries.map((e) => e.value).toList()[index] != null) {
                List list =
                    controller.document.value.toMap().entries.map((e) => e.value).toList()[index] ?? ['error happened'];
                return CustomListItems(
                    lst: list.length == 0 ? ['No Data'] : list, lstName: controller.listNames[index]);
              } else
                return Container();
            });
          },
        ),
      ),
    );
  }
}
