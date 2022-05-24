import 'package:dops/components/custom_widgets.dart';
import 'package:dops/constants/constant.dart';
import 'package:dops/constants/lists.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 20),
      child: Center(
        child: ListView.separated(
          padding: EdgeInsets.only(left: 12, right: 12),
          controller: ScrollController(),
          scrollDirection: Axis.horizontal,
          itemCount: listNames.length,
          separatorBuilder: (context, index) => SizedBox(width: 12),
          itemBuilder: (context, index) {
            return Obx(() {
              if (listsController.document
                      .toMap()
                      .entries
                      .map((e) => e.value)
                      .toList()[index] !=
                  null) {
                List list = listsController.document
                        .toMap()
                        .entries
                        .map((e) => e.value)
                        .toList()[index] ??
                    ['error happened'];
                return CustomListItems(
                    lst: list.length == 0 ? ['No Data'] : list,
                    lstName: listNames[index]);
              } else
                return Container();
            });
          },
        ),
      ),
    );
  }
}
