import 'package:dops/controllers/dropdown_source_lists_controller.dart';
import 'package:dops/widgets/custom_list_items.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DropdownSourceListsView extends GetView<DropdownSourceListsController> {
  @override
  Widget build(BuildContext context) {
    var lists = controller.dropdownSourceLists;
    return Scaffold(
      appBar: AppBar(
        title: Text('Lists'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: lists.length,
              itemBuilder: (context, index) {
                return CustomListItems(
                  lst: lists[index],
                  lstName: lists[index],
                  newItemController: controller.newItemControllerList[index],
                  formKey: controller.dropdownSourceListsFormKeyList[index],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
